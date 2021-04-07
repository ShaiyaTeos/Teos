statpoint_alloc_qty     equ 10          ; The number of statpoints to allocate when holding down shift.
statpoint_alloc_retn    equ 0x510188    ; The address to return to after adjusting the statpoint allocation.
get_async_key_state     equ 0x700504    ; The function for checking the state of a key.
vk_shift                equ 0x10        ; The shift key.

; The function to be executed when allocating statpoints.
allocate_stat_points:
    ; Preserve eax (will store our key state)
    push eax
    push ecx

    ; Get the state of the shift key.
    push vk_shift
    call dword [get_async_key_state]

    ; If the shift key is currently pressed down, the most significant bit should be set
    and eax, 0xFF00
    pop ecx
    pop eax
    je allocate_stat_points_original

    ; Store the amount of statpoints to allocate in edx
    push edx
    cmp ecx, statpoint_alloc_qty
    jge alloc_qty
    mov edx, ecx                    ; If `statpoint_alloc_qty` is greater than the available statpoints, just use that instead.
    jmp alloc_statpoints
alloc_qty:
    mov edx, statpoint_alloc_qty    ; Otherwise, allocate `statpoint_alloc_qty`.
alloc_statpoints:
    add word [esi+eax*2+64], dx     ; Add the number of statpoints.
    sub ecx, edx                    ; Decrement from the total free statpoints, and store the value.
    mov [esi+0x4C], ecx
    pop edx
    jmp statpoint_alloc_retn

; The function for allocating statpoints using the default method (1 at a time).
allocate_stat_points_original:
    dec ecx
    mov [esi+0x4C], ecx
    inc word [esi+eax*2+64]
    jmp statpoint_alloc_retn