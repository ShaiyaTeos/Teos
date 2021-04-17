config_file         equ 0x771240    ; The path to the config file.
config_const_true   equ 0x701BF0    ; The text "TRUE"
config_const_false  equ 0x700CDC    ; The text "FALSE"
config_const_video  equ 0x700CA0    ; The text "VIDEO"
save_graphic_exit   equ 0x50367C    ; The address to return to after saving the graphic settings to disk.
config_buffer_size  equ 260         ; The size of the config value buffer.
config_default      equ 0x700B64    ; The default load value.
load_graphic_exit   equ 0x406950    ; The address to return to after loading the custom graphic options.
save_config_file    equ 0x502B70    ; The function for saving the config file.
load_config_file    equ 0x405FE0    ; The function for loading the config file.
write_profile_str   equ 0x7002C0    ; The function for writing to a cfg file.

; If effects are enabled
is_effects_enabled:
    db  01

; The effects key.
effects_key:
    db "EFFECTS", 0

; If costumes are enabled
is_costumes_enabled:
    db  01

; The costumes key.
costumes_key:
    db "COSTUMES", 0

; Wrapper function to save custom config state.
save_config:
    push ebp
    mov ebp, esp
    push ecx

    ; Save custom options
    push 6
    mov ecx, config_file
    call save_config_file
    add esp, 4

    pop ecx
    mov esp, ebp
    pop ebp
    retn

; Save our custom config.
save_custom_config:
    cmp eax, 5
    jne save_config_default
    call save_graphic_options
save_config_default:
    cmp eax, 4
    ja  0x50367D
    jmp 0x502BAC

; Save our custom graphic options.
save_graphic_options:
    push ebp
    mov ebp, esp

    ; Save the effects enabled option.
    push config_file
    cmp byte [is_effects_enabled], 0
    je effects_disabled
    push config_const_true
    jmp save_effects_option
effects_disabled:
    push config_const_false
save_effects_option:
    push effects_key
    push config_const_video
    call dword [write_profile_str]

    ; Save the costumes enabled option.
    push config_file
    cmp byte [is_costumes_enabled], 0
    je costumes_disabled
    push config_const_true
    jmp save_costumes_option
costumes_disabled:
    push config_const_false
save_costumes_option:
    push costumes_key
    push config_const_video
    call dword [write_profile_str]

    mov esp, ebp
    pop ebp
    retn

; Load our custom graphic options.
load_graphic_options:
    ; Load the "effects" option.
    push config_file
    push config_buffer_size
    lea edx, [esp + 0x18]   ; Push the buffer for the returned string.
    push edx
    push config_default
    push effects_key
    push config_const_video
    call esi
    test eax, eax
    je load_costumes_option

    ; Load the return value into eax and compare it against false
    mov ecx, config_const_false
    lea eax, [esp + 0x10]
    mov dl, [eax]
    cmp dl, [ecx]
    jne load_costumes_option

    ; The "effects" key is false.
    mov byte [is_effects_enabled], 0
load_costumes_option:
    ; Load the "costumes" option.
    push config_file
    push config_buffer_size
    lea edx, [esp + 0x18]   ; Push the buffer for the returned string.
    push edx
    push config_default
    push costumes_key
    push config_const_video
    call esi
    test eax, eax
    je exit_graphic_options

    ; Load the return value into eax and compare it against false
    mov ecx, config_const_false
    lea eax, [esp + 0x10]
    mov dl, [eax]
    cmp dl, [ecx]
    jne exit_graphic_options

    ; The "costumes" key is false.
    mov byte [is_costumes_enabled], 0
exit_graphic_options:
    push config_file
    jmp load_graphic_exit