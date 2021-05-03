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

    ; Set the title id
    mov [eax+CUser.title], ebx
set_title_packet_exit:
    mov esp, ebp
    pop ebp
    retn 4