window_focused_flag equ 0x771EC4    ; If the window is currently in focus.
window_focused_retn equ 0x40795E    ; The address to return to.

; Always flag the window as "focused" regardless of the actual state.
flag_window_focused:
    mov byte [window_focused_flag], 1
    jmp window_focused_retn