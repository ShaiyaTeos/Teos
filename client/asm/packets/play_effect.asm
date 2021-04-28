; Handle an effect packet.
play_effect_packet:
    push ebp
    mov ebp, esp
    mov edx, [ebp + 8]  ; Packet payload.

    push ecx
    xor eax, eax
    mov eax, [edx+2] ; Player id

    ; Get the player by their id
    mov ecx, client_base
    push eax
    call get_player
    test eax, eax
    je play_effect_packet_exit  ; Player doesn't exist, do nothing

    ; Play the effect
    mov edx, [ebp + 8]
    push 5
    lea ecx, [eax + 0x28]
    push ecx                ; Player's Z
    lea ecx, [eax + 0x1C]
    push ecx                ; Player's Y
    add eax, 0x10
    push eax                ; Player's X.
    xor eax, eax
    mov al, byte [edx + 7]
    push eax                ; Scene
    mov al, byte [edx + 6]
    push eax                ; Effect
    mov ecx, client_base
    call play_graphical_effect

play_effect_packet_exit:
    pop ecx
    mov esp, ebp
    pop ebp
    retn 4