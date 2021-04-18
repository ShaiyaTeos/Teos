item_container_size     equ 0x3C0       ; The number of bytes for each container page.
item_data_size          equ 0x28        ; The number of bytes for each item.
item_container_start    equ 0x8BEB7D    ; The start of the player's items.

; Represents an item.
struc CItem
    .type:           resb    1
    .type_id:        resb    1
    .quantity:       resb    1
    .endurance:      resw    1
    .lapis:          resb    6
    .craftname:      resb    21
    .create_time:    resb    4
    .expire_time:    resb    4
endstruc

; The total number of equipment slots.
num_equipment_slots equ 14

; The position of the player's gold.
inventory_gold_position:
    .x: dd  230.00
    .y: dd  485.00

; The positions of each equipment slot.
equipment_slot_positions:
    .helmet:
        dd 42.00    ; X
        dd 61.00    ; Y
    .top:
        dd 29.00    ; X
        dd 102.00   ; Y
    .pants:
        dd 16.00    ; X
        dd 143.00   ; Y
    .gloves:
        dd 28.00    ; X
        dd 184.00   ; Y
    .boots:
        dd 42.00    ; X
        dd 225.00   ; Y
    .weapon:
        dd 209.00   ; X
        dd 143.00   ; Y
    .shield:
        dd 197.00   ; X
        dd 184.00   ; Y
    .cape:
        dd 183.00   ; X
        dd 225.00   ; Y
    .amulet:
        dd 175.00   ; X
        dd 61.00    ; Y
    .left_ring:
        dd 183.00   ; X
        dd 86.00    ; Y
    .right_ring:
        dd 206.00   ; X
        dd 86.00    ; Y
    .left_loop:
        dd 188.00   ; X
        dd 111.00   ; Y
    .right_loop:
        dd 212.00   ; X
        dd 111.00   ; Y
    .mount:
        dd 199.00   ; X
        dd 61.00    ; Y

; A function which initialises the position of various inventory related data.
initialise_inventory_positions:
    %assign total_bytes     (num_equipment_slots * 8)
    %assign dword_passes    (total_bytes / 4)
    %assign current_byte    0

    ; Copy full dwords at a time for the equipment.
    %rep dword_passes
        mov edi, dword [equipment_slot_positions + current_byte]
        mov dword [eax + current_byte + 1880], edi
        %assign current_byte    current_byte + 4
    %endrep

    ; Assign the position of the player's gold.
    mov edi, dword [inventory_gold_position.x]
    mov dword [eax + 2032], edi
    mov edi, dword [inventory_gold_position.y]
    mov dword [eax + 2036], edi

    ; Exit the function.
    pop edi
    pop esi
    add esp, 128
    retn