summon_char_name    equ 0x2256AFC   ; The address where the name of the player sending a summon is stored.
summon_retn         equ 0x5361CD    ; The address to return to after formatting the summon string.
read_packet_data    equ 0x5C9C80    ; The function for reading a data type from a buffer.
summon_packet_retn  equ 0x5BE6D1    ; The address to return to after reading the packet.
get_map_name        equ 0x4D8B90    ; The function for getting a map's name from an id.
file_client         equ 0x8BDA58    ; Not sure, maybe the data file client?

; The summon dialogue text. This could be added in the sysmsg-uni, but I don't want to require external edits right now.
dialogue_text:
    db "%s is summoning you to %s. Do you wish to accept?", 0

; The dialogue text box.
dialogue_text_box:
    times   128 db 0

; The name of the summon map.
summon_dest_map_name:
    times   128 db  0

; The summon destination map.
summon_dest_map_id:
    dd 0

; Writes the destination map in the summon dialogue box.
write_summon_destination:
    ; Preserve eax (stores current timer)
    push eax

    ; Get the map name.
    push ecx
    mov eax, dword [summon_dest_map_id]
    push eax
    push summon_dest_map_name
    mov ecx, file_client
    call get_map_name
    pop ecx

    ; Format the output string
    push summon_dest_map_name
    push summon_char_name
    push dialogue_text
    push dialogue_text_box
    call sprintf
    add esp, 16
    mov eax, dialogue_text_box

    ; Return to the drawing of the summon dialogue
    jmp summon_retn

; Reads the extra data in the summon packet.
read_summon_packet:
    ; Read the character id that is sending the summon.
    push 4
    lea eax, [esp+4]
    push eax
    call read_packet_data

    ; Read the destination map id.
    mov ecx, [esp+8]    ; The payload to read from.
    push 2
    push summon_dest_map_id
    call read_packet_data
    jmp summon_packet_retn