; Handle a chat message packet.
send_chat_message_packet:
    push ebp
    mov ebp, esp
    mov edx, [ebp + 8]  ; Packet payload.

    xor eax, eax
    mov al, [edx+2] ; Effect code
    add edx, 3      ; String

    ; Send the chat message
    push edx
    push eax
    call write_client_chat_text

    mov esp, ebp
    pop ebp
    retn 4