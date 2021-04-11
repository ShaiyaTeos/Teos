copyright_x_offset  equ 78  ; The horizontal offset of the copyright text.

; The text to display as the copyright footer when first loading the client.
copyright_text:
    times 64   db 0

; The copyright footer format.
copyright_text_format:
    db "Running on commit #%s.", 0

; The copyright logo file.
copyright_logo:
    db "nexon.bmp", 0

; Generate the copyright footer.
generate_copyright_text:
    ; Preserve the stack pointer
    push ebp
    mov ebp, esp

    ; Format the title with the git hash
    push git_hash
    push copyright_text_format
    push copyright_text
    call sprintf
    add esp, 12

    ; Clean up the stack
    mov esp, ebp
    pop ebp
    retn