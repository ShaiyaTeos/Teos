config_file         equ 0x771240    ; The path to the config file.
config_const_true   equ 0x701BF0    ; The text "TRUE"
config_const_false  equ 0x700CDC    ; The text "FALSE"
config_const_video  equ 0x700CA0    ; The text "VIDEO"
save_graphic_exit   equ 0x50367C    ; The address to return to after saving the graphic settings to disk.
config_buffer_size  equ 260         ; The size of the config value buffer.
config_default      equ 0x700B64    ; The default load value.
load_graphic_exit   equ 0x406950    ; The address to return to after loading the custom graphic options.

; If effects are enabled
is_effects_enabled:
    db  01

; The effects key.
effects_key:
    db "EFFECTS", 0

; Save our custom graphic options.
save_graphic_options:
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
    call esi

    ; Exit the save graphic options
    cmp dword [0x771938], 0
    jmp save_graphic_exit

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
    je exit_graphic_options

    ; Load the return value into eax and compare it against false
    mov ecx, config_const_false
    lea eax, [esp + 0x10]
    mov dl, [eax]
    cmp dl, [ecx]
    jne exit_graphic_options

    ; The "effects" key is false.
    mov byte [is_effects_enabled], 0

exit_graphic_options:
    push config_file
    jmp load_graphic_exit