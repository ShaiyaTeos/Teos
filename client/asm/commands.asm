strncmp             equ 0x5FFA7F    ; The C function for comparing strings.
parse_command_retn  equ 0x47574E    ; The address to return to after parsing custom commands.
command_success     equ 0x47B290    ; The return address for a successful command.

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

; Parses custom command inputs.
parse_custom_commands:
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
    jne parse_command_exit

    ; Set effects to "off"
    mov byte [is_effects_enabled], 0
    call save_config

    ; Write a message to the chat box
    push effect_off_success_message
    push effect_code_white
    call write_client_chat_text
    jmp command_success

parse_command_exit:
    ; Return to parsing the "/itemlv" command.
    push 7
    push 0x706C08
    jmp parse_command_retn