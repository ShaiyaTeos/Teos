startup_retn    equ 0x4C3F55    ; The address to return to after running the startup calls.

; Runs startup function calls after the window has been generated.
startup:
    ; Load the costume definitions.
    call load_costume_definitions

    ; Render the login screen.
    mov eax, dword [0x2299F98]
    jmp startup_retn
