startup_retn    equ 0x42CA47    ; The address to return to after running the startup calls.

; Runs startup function calls after the window has been generated.
startup:
    ; Load the costume definitions.
    call load_costume_definitions

    ; Render the login screen.
    push -1
    push 0x6EBC20
    jmp startup_retn
