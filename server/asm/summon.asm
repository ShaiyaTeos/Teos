summon_packet_retn  equ 0x48DB33    ; The address to return to after writing the summon packet.
sconnection_send    equ 0x4D4D20    ; The function for sending a packet.

; The function pointer for sending a summon request.
summon_addr:
    dd 0

; Modify the summon packet to include the destination map.
write_summon_packet:
    add eax, 35000  ; The time until the summon is cancelled.

    ; Send the summon packet.
    push esi    ; Player receiving the summon.
    push ebp    ; Player sending the summon.
    call dword [summon_addr]

    ; Store the summon details and return
    mov [esi+0x147C], edx
    mov [esi+0x1480], eax
    jmp summon_packet_retn