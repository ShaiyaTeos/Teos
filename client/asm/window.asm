sprintf         equ 0x5FED7B    ; The C-function for formatting a string.
get_window_retn equ 0x408207    ; The address to return to, for creating the window.
window_handle   equ 0x771EB8    ; The address of the window handle.

; The window title format
window_title_format:
    db "Shaiya Teos (commit #%s)", 0

; The name of the windows class
window_class_name:
    db "GAME", 0

; The formatted window title (64 bytes of space)
window_title:
    times   64  db 0

; Get window title
get_window_title:
    push git_hash               ; Format the title with the git hash
    push window_title_format
    push window_title
    call sprintf
    add esp, 12

    ; Create the window
    push window_title
    push window_class_name
    jmp get_window_retn
