create_file_a   equ 0x7002EC    ; The Kernel32.CreateFileA function (https://docs.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-createfilea)
write_file      equ 0x700244    ; The Kernel32.WriteFile function (https://docs.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-writefile)

; File access constants.
generic_read    equ 0x80000000
generic_write   equ 0x40000000

; The discord IPC operations.
DISCORD_OP_HANDSHAKE    equ 0
DISCORD_OP_FRAME        equ 1
DISCORD_OP_CLOSE        equ 2
DISCORD_OP_PING         equ 3
DISCORD_OP_PONG         equ 4

; The discord pipe format.
discord_pipe_format:
    db "\\?\pipe\discord-ipc-%d", 0

; The name of the discord pipe.
discord_pipe_name:
    times 64  db  0

; The discord ipc handle.
discord_ipc_handle:
    dd  0

; Contains the number of bytes written to the discord pipe.
discord_num_bytes_written:
    dd  0

; The discord application id.
discord_application_id:
    db "816374003710427198", 0

; The handshake JSON format.
discord_handshake_format:
    db "{'v': 1, 'client_id': %s}", 0

; Initialises the discord IPC client.
init_discord_ipc:
    push ebp
    mov ebp, esp    ; Stdcall
    push edi

    ; Initiate a loop that searches for an available named pipe.
    xor edi, edi
discord_pipe_search_loop:
    cmp edi, 10 ; Only attempt up to 10 iterations - if none is found, assume Discord isn't running.
    je discord_pipe_exit

    ; Format the string.
    push edi
    push discord_pipe_format
    push discord_pipe_name
    call sprintf
    add esp, 12

    ; Attempt to create the pipe handle.
    push 0                              ; hTemplateFile
    push 0                              ; dwFlagsAndAttributes
    push 3                              ; dwCreationDisposition (OPEN_EXISTING)
    push 0                              ; lpSecurityAttributes
    push 1                              ; dwShareMode (FILE_SHARE_READ)
    push (generic_read | generic_write) ; dwDesiredAccess
    push discord_pipe_name
    call dword [create_file_a]

    ; Increment the counter
    inc edi
    cmp eax, -1
    je discord_pipe_search_loop

    ; Save the pipe handle
    mov [discord_ipc_handle], eax

    ; Handshake with the Discord client.
    call discord_send_handshake

discord_pipe_exit:
    pop edi
    mov esp, ebp
    pop ebp
    retn

; Sends a frame to the Discord IPC client.
;
; Usage:
; push opcode
; push command
; call discord_send_frame
discord_send_frame:
    push ebp
    mov ebp, esp    ; Stdcall

    mov esi, [ebp + 8]  ; Command
    mov ecx, [ebp + 12] ; Opcode

    ; Find the length of the command string.
    push edx
    xor eax, eax
discord_send_frame_strlen_loop:
    mov dl, byte [esi+eax]
    inc eax
    test dl, dl
    jne discord_send_frame_strlen_loop

    ; The space of the payload.
    push ebx
    push edi
    mov edi, eax
    add edi, 8

    ; Allocate space on the stack for the payload
    sub esp, 2048

    ; Write the command opcode and length
    mov dword [esp], ecx
    mov dword [esp+4], eax

discord_send_frame_payload_loop:
    mov bl, byte [esi+eax]
    mov byte [esp+eax+8], bl
    test eax, eax
    je discord_send_frame_payload_loop_exit
    dec eax
    jmp discord_send_frame_payload_loop
discord_send_frame_payload_loop_exit:

    ; Write the payload
    mov ebx, esp
    push 0                          ; lpOverlapped
    push discord_num_bytes_written  ; lpNumberOfBytesWritten
    push edi                        ; nNumberOfBytesToWrite
    push ebx                        ; lpBuffer
    mov eax, dword [discord_ipc_handle]
    push eax
    call dword [write_file]
    add esp, 2048

    ; Restore the stack
    pop ebx
    pop edi
    pop edx

    ; Exit the function.
    mov esp, ebp
    pop ebp
    retn 8

; Sends the handshake to the Discord IPC client.
discord_send_handshake:
    push ebp
    mov ebp, esp

    ; Allocate space on the stack for the formatted command.
    push edi
    sub esp, 2048
    mov edi, esp

    ; Format the handshake frame.
    push discord_application_id
    push discord_handshake_format
    push edi
    call sprintf

    ; Send the frame.
    push DISCORD_OP_HANDSHAKE
    push edi
    call discord_send_frame
    add esp, 2060

    mov esp, ebp
    pop ebp
    retn