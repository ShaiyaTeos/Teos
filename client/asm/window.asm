sprintf                     equ 0x5FED7B    ; The C-function for formatting a string.
get_window_retn             equ 0x408207    ; The address to return to, for creating the window.
window_handle               equ 0x771EB8    ; The address of the window handle.
char_name_addr              equ 0x8C1260    ; The address where the current character name is stored. This is drawn in the info panel.
set_window_text             equ 0x70047C    ; The C-function for setting the window text.
char_write_player_name      equ 0x4DB050    ; Writes the player's name for the info panel.
char_write_player_name_retn equ 0x46F895    ; The address to return to after updating the window title.
reset_window_title_retn     equ 0x5B5076    ; The address to return to after resetting the window title in character screen.
screen_width                equ 0x75D0D8    ; The address where the window width is stored.
screen_height               equ 0x75D0DC    ; The address where the window height is stored.

; The window title format
window_title_format:
    db "Shaiya Teos (commit #%s)", 0

; The window title format with character name
window_title_format_char_name:
    db "Shaiya Teos - Playing as %s (commit #%s)", 0

; The name of the windows class
window_class_name:
    db "GAME", 0

; The formatted window title (128 bytes of space)
window_title:
    times   128  db 0

; Get window title
get_window_title:
    push git_hash               ; Format the title with the git hash
    push window_title_format
    push window_title
    call sprintf
    add esp, 12

    ; Generate the copyright footer
    call generate_copyright_text

    ; Create the window
    push window_title
    push window_class_name
    jmp get_window_retn

; Reset the window title to the default.
reset_window_title:
    push git_hash               ; Format the title with the git hash
    push window_title_format
    push window_title
    call sprintf
    add esp, 12

    ; Update the window title
    push eax
    mov eax, dword [window_handle]
    push window_title
    push eax
    call dword [set_window_text]
    pop eax

    ; Restore the original function
    sub esp, 136
    jmp reset_window_title_retn

; Update window title to include the character name.
update_window_title_char_name:
    ; Call the procedure to draw the info panel text.
    call char_write_player_name

    ; Format the window text.
    push git_hash
    push char_name_addr
    push window_title_format_char_name
    push window_title
    call sprintf
    add esp, 16

    ; Update the window title
    push eax
    mov eax, dword [window_handle]
    push window_title
    push eax
    call dword [set_window_text]
    pop eax
    jmp char_write_player_name_retn