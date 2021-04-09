console_input_str   equ 0x5214D4
console_output_str  equ 0x5214E8
console_parse_retn  equ 0x4D5EBB
console_parse_exit  equ 0x4D5F63

; The address of the console command function
console_command_addr:
    dd 0

; Call our custom command function
console_command:
    ; Call our custom function
    push edi    ; Output string
    push eax    ; Length of input text
    push ebx    ; Input text
    call dword [console_command_addr]

    ; If the function returned "true", we should no longer parse the command
    test al,al
    jne console_command_exit

    ; Parse console commands as normal
    push edi
    push eax
    push ebx
    mov ecx,esi
    xor ebp,ebp
    jmp console_parse_retn

; Early return of parsing console commands
console_command_exit:
    push eax

    ; Load the log client
    mov eax, dword [g_pClientToLog]
    add eax, 0xE0

    ; Log the command input to the log file
    push ebx
    push console_input_str
    push eax
    call SLog_PrintFileDirect
    add esp, 12
    pop eax

    jmp console_parse_exit