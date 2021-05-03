; Sets the title index for a player.
set_title_packet:
    push ebp
    mov ebp, esp
    mov edx, [ebp + 8]  ; Packet payload.

    mov eax, [edx+2] ; Player id
    mov ebx, [edx+6] ; Title id

    ; Get the player by their id
    mov ecx, client_base
    push eax
    call get_player
    test eax, eax
    je set_title_packet_exit  ; Player doesn't exist, do nothing
    mov ecx, eax
    push ecx

    test ebx, ebx
    je clear_title  ; If the title id is 0, clear the title flag.

    ; Get the message
    push ebx
    call sysmsg_for_id
    add esp, 4
    pop ecx

    ; Flag the player as having a set title.
    mov byte [ecx+CUser.has_title], 1

    ; Copy the string
    push eax
    lea ecx, [ecx+CUser.title]
    push ecx
    call strcpy
    jmp set_title_packet_exit

clear_title:
    ; Flag the player as not having a title
    mov byte [ecx+CUser.has_title], 0
    pop ecx
set_title_packet_exit:
    mov esp, ebp
    pop ebp
    retn 4