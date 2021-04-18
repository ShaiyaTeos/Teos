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
num_equipment_slots equ 19

; The position of the player's gold.
inventory_gold_position:
    .x: dd  230.00
    .y: dd  485.00

; The positions of each equipment slot.
equipment_slot_positions:
    .helmet:
        dd 16.00    ; X (Original = 42.00)
        dd 62.00    ; Y (Original = 61.00)
    .top:
        dd 16.00    ; X (Original = 29.00)
        dd 104.00    ; Y (Original = 102.00)
    .pants:
        dd 16.00    ; X (Original = 16.00)
        dd 146.00   ; Y (Original = 143.00)
    .gloves:
        dd 16.00    ; X (Original = 28.00)
        dd 188.00   ; Y (Original = 184.00)
    .boots:
        dd 16.00    ; X (Original = 42.00)
        dd 230.00   ; Y (Original = 225.00)
    .weapon:
        dd 207.00   ; X (Original = 209.00)
        dd 146.00   ; Y (Original = 143.00)
    .shield:
        dd 210.00   ; X (Original = 197.00)
        dd 173.00   ; Y (Original = 184.00)
    .cape:
        dd 207.00   ; X (Original = 183.00)
        dd 229.00   ; Y (Original = 225.00)
    .amulet:
        dd 201.00   ; X (Original = 175.00)
        dd 61.00    ; Y (Original = 61.00)
    .left_ring:
        dd 200.00   ; X (Original = 183.00)
        dd 86.00    ; Y (Original = 86.00)
    .right_ring:
        dd 224.00   ; X (Original = 206.00)
        dd 86.00    ; Y (Original = 86.00)
    .left_loop:
        dd 200.00   ; X (Original = 188.00)
        dd 111.00   ; Y (Original = 111.00)
    .right_loop:
        dd 224.00   ; X (Original = 212.00)
        dd 111.00   ; Y (Original = 111.00)
    .mount:
        dd 224.00   ; X (Original = 199.00)
        dd 61.00    ; Y (Original = 61.00)
    .costume:
        dd 167.00   ; X
        dd 229.00   ; Y
    .weapon_skin:
        dd 168.00   ; X
        dd 146.00   ; Y
    .pet:
        dd 0.00     ; X
        dd 0.00     ; Y
    .left_artifact:
        dd 0.00     ; X
        dd 0.00     ; Y
    .right_artifact:
        dd 0.00     ; X
        dd 0.00     ; Y

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