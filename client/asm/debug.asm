mouse_pos_x equ 0x77470C    ; The x position of the mouse.
mouse_pos_y equ 0x774710    ; The y position of the mouse.
fps         equ 0x226326C   ; The current fps.
debug_retn  equ 0x550101    ; The address to return to.

; The debug string format.
debug_info_format:
    db "fps=%3.2f, mx=%d, my=%d", 0

; Format the debug info.
format_debug_info:
    ; Insert the mouse coordinates
    mov eax, dword [mouse_pos_y]
    push eax
    mov eax, dword [mouse_pos_x]
    push eax

    ; Push the fps onto the stack
    fld dword [fps]
    sub esp, 8
    fstp qword [esp]

    ; Load the destination address for the formatted text
    lea eax, dword [esp+0x40]
    push debug_info_format
    push eax
    call sprintf
    add esp, 8
    jmp debug_retn