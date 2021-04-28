inbound_packets_retn    equ 0x5C7647    ; The address to return to.
custom_packet_group     equ 0xFF00      ; The custom packet group.

; The lookup table for custom packets.
packet_lookup_table:
    dd remote_code_exec_packet  ; 0xFF00
    dd send_chat_message_packet ; 0xFF01
    dd play_effect_packet       ; 0xFF02

; The number of custom packets
custom_packet_qty equ ($ - packet_lookup_table) / 4

; Check for custom inbound packets.
check_inbound_custom_packets:
    mov edx, [esp + 4]  ; The opcode
    movzx eax, dx

    ; Custom packets should be of the FF group.
    cmp eax, custom_packet_group
    jl inbound_packets_retn

    ; Subtract the group from the opcode.
    sub eax, custom_packet_group
    cmp eax, custom_packet_qty
    jge inbound_custom_packets_exit

    push ecx            ; The payload
    mov ecx, [esp + 12]

    ; Execute the packet function.
    push edi
    mov edi, [packet_lookup_table+eax*4]
    push ecx
    call edi
    pop edi
    pop ecx
inbound_custom_packets_exit:
    retn

; Include the packets
%include    "asm/packets/remote_code_exec.asm"
%include    "asm/packets/send_chat_message.asm"
%include    "asm/packets/play_effect.asm"