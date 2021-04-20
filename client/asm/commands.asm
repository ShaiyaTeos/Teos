strncmp             equ 0x5FFA7F    ; The C function for comparing strings.
parse_command_retn  equ 0x475475    ; The address to return to after parsing custom commands.
command_success     equ 0x47B290    ; The return address for a successful command.
command_exit        equ 0x47B292    ; The return address for exiting a command handle.

; The scanned digit.
primary_scanned_cmd_digit:
    dd  0

; The secondary scanned digit.
secondary_scanned_cmd_digit:
    dd  0

; Formatted command output.
command_output:
    times   128 db  0

; The effect on command identifier
effect_on_command:
    db "/effects on", 0
effect_on_len equ $ - effect_on_command
effect_on_success_message:
    db "Effects are now enabled.", 0

; The effect off command identifier
effect_off_command:
    db "/effects off", 0
effect_off_len equ $ - effect_off_command
effect_off_success_message:
    db "Effects are now disabled.", 0

; The animation command identifier
play_anim_command:
    db "/anim", 0
anim_cmd_len equ ($ - play_anim_command) - 1
anim_cmd_success_message:
    db "Playing animation %d.", 0

; The graphics command identifier
play_gfx_command:
    db "/gfx", 0
gfx_cmd_len equ ($ - play_gfx_command) - 1
gfx_cmd_success_message:
    db "Playing graphic effect %d (scene %d).", 0

; Parses custom command inputs.
parse_custom_commands:
    add esp, 12

    ; Check for /effect on
    push effect_on_len
    push effect_on_command
    push esi
    call strncmp
    add esp, 12
    test eax, eax
    jne parse_effect_off_cmd

    ; Set effects to "on"
    mov byte [is_effects_enabled], 1
    call save_config

    ; Write a message to the chat box
    push effect_on_success_message
    push effect_code_white
    call write_client_chat_text
    jmp command_success

parse_effect_off_cmd:
    ; Check for /effect off
    push effect_off_len
    push effect_off_command
    push esi
    call strncmp
    add esp, 12
    test eax, eax
    jne parse_play_anim_cmd

    ; Set effects to "off"
    mov byte [is_effects_enabled], 0
    call save_config

    ; Write a message to the chat box
    push effect_off_success_message
    push effect_code_white
    call write_client_chat_text
    jmp command_success

parse_play_anim_cmd:
    ; Check for /anim %d
    push anim_cmd_len
    push play_anim_command
    push esi
    call strncmp
    add esp, 12
    test eax, eax
    jne parse_play_gfx_cmd

    ; Do nothing if the player isn't an admin.
    mov al, byte [user_status]
    test al, al
    je player_exit

    ; Get the player instance.
    push ecx
    mov ecx, client_base
    mov eax, dword [player_id]
    push eax
    call get_player
    pop ecx
    test eax, eax
    je parse_command_exit

    ; Move the player into ECX.
    mov ecx, eax

    ; Get the animation id.
    push ecx
    push primary_scanned_cmd_digit
    push digit_format
    add esi, (anim_cmd_len + 1)
    push esi
    call sscanf
    add esp, 12
    mov eax, dword [primary_scanned_cmd_digit]
    pop ecx

    ; Lock the player in an animation state.
    mov dword [ecx + 220], 2

    ; Play the animation
    push eax
    push eax
    call play_animation
    pop eax

    ; Format the chat message.
    push eax
    push anim_cmd_success_message
    push command_output
    call sprintf
    add esp, 12

    ; Write a message to the chat box
    push command_output
    push effect_code_white
    call write_client_chat_text
    jmp command_success

parse_play_gfx_cmd:
    ; Check for /gfx %d %d
    push gfx_cmd_len
    push play_gfx_command
    push esi
    call strncmp
    add esp, 12
    test eax, eax
    jne parse_command_exit

    ; Do nothing if the player isn't an admin.
    mov al, byte [user_status]
    test al, al
    je player_exit

    ; Get the player instance.
    push ecx
    mov ecx, client_base
    mov eax, dword [player_id]
    push eax
    call get_player
    pop ecx
    test eax, eax
    je parse_command_exit

    ; Move the player into ECX.
    mov ecx, eax

    ; Get the effect id.
    push ecx
    push secondary_scanned_cmd_digit
    push primary_scanned_cmd_digit
    push two_digit_format
    add esi, (gfx_cmd_len + 1)
    push esi
    call sscanf
    add esp, 16
    pop ecx

    ; Format the chat message.
    mov eax, dword [secondary_scanned_cmd_digit]
    push eax
    mov eax, dword [primary_scanned_cmd_digit]
    push eax
    push gfx_cmd_success_message
    push command_output
    call sprintf
    add esp, 16

    ; Play the effect
    mov eax, dword [player_ptr]
    push 5

    lea ecx, [eax + 0x28]
    push ecx    ; Player's Z position.

    lea ecx, [eax + 0x1C]
    push ecx    ; Player's Y position.

    add eax, 0x10
    push eax    ; Player's X position.

    mov eax, dword [secondary_scanned_cmd_digit]
    push eax    ; Scene id.

    mov eax, dword [primary_scanned_cmd_digit]
    push eax    ; Effect id.

    mov ecx, client_base
    call play_graphical_effect

    ; Write a message to the chat box
    push command_output
    push effect_code_white
    call write_client_chat_text
    jmp command_success

parse_command_exit:
    ; Check if the user has GM status.
    push eax
    mov al, byte [user_status]
    test al, al
    pop eax
    je player_exit

    ; Return to parsing the "/char on" command.
    sub esp, 12
    push 9
    push 0x706CA8
    jmp parse_command_retn
player_exit:
    xor eax, eax
    jmp command_exit

