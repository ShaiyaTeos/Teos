startup_retn    equ 0x42CA47    ; The address to return to after running the startup calls.

; The flag for running startup code.
startup_flag:
    db  0

; Runs startup function calls after the window has been generated.
startup:
    ; Skip the startup code if it's already been executed.
    cmp byte [startup_flag], 1
    je startup_exit

    ; Mark the startup as completed.
    mov byte [startup_flag], 1

    ; Preserve whatever state is needed
    pushad
    pushfd

    call init_discord_ipc               ; Initialise the Discord IPC client, for rich presence.
    call init_discord_activity_thread   ; Initialise the thread for updating the Discord activity.
    call load_costume_definitions       ; Load the costume definitions.

    ; Restore state
    popfd
    popad

startup_exit:
    ; Render the login screen.
    push -1
    push 0x6EBC20
    jmp startup_retn
