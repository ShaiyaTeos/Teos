teos_startup:
    ; Find the address to the Teos `startup` function from the IAT
    push edx
    mov edx, dword [teos_iat + teos_startup_rva]
    push summon_addr                    ; The address to store the send summon packet function pointer.
    push cuser_send_details_addr        ; The address to store the send user details fucntion pointer.
    push cuser_set_attack_addr          ; The address to store the set attack function pointer.
    push cuser_send_character_list_addr ; The address to store the send character list function pointer.
    push console_command_addr           ; The address to store the on_console_command function pointer.
    push cuser_on_packet_recv           ; The address to store the cuser_on_packet_recv function pointer.
    push cuser_on_connect               ; The address to store the cuser_on_connect function pointer.
    push cuser_size                     ; The address of the CUser struct size.
    call edx                            ; Call Teos.startup
    pop edx
    jmp log_return_address