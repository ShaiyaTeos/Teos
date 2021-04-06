game_service_id         equ 0x542CA6    ; The service name of the game process
log_return_address      equ 0x403D6B    ; The address to return to after having run our custom code
SLog_PrintFileDirect    equ 0x4D9510    ; The address of the SLog::PrintFileDirect function.
g_pClientToLog          equ 0x546F48    ; The logging client.

; When the `ps_game` service starts up, we should print a message containing the game service id, the
; Git branch, and the Git hash that this was compiled for.
modify_game_log_text:
    ; Save the value of EAX
    add eax,0xE0

    ; Print the startup log message
    push git_hash
    push branch_name
    push game_service_id
    push game_log_text
    push eax
    call SLog_PrintFileDirect
    add esp, 20

    ; Initialise our DLL
    jmp teos_startup