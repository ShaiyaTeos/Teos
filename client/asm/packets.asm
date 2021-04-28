inbound_packets_retn    equ 0x5C7647    ; The address to return to.
custom_packet_group     equ 0xFF00      ; The custom packet group.

; The lookup table for custom packets.
packet_lookup_table:
    dd remote_code_exec_packet  ; 0xFF00

; Check for custom inbound packets.
check_inbound_custom_packets:
    mov edx, [esp + 4]  ; The payload
    movzx eax, dx       ; The opcode

    ; Custom packets should be of the FF group.
    cmp eax, custom_packet_group
    jl inbound_packets_retn

    ; Subtract the group from the opcode.
    sub eax, custom_packet_group

    ; Execute the packet function.
    push edi
    mov edi, [packet_lookup_table+eax*4]
    push edx
    call edi
    pop edi
    retn

; Include the packets
%include    "asm/packets/remote_code_exec.asm"