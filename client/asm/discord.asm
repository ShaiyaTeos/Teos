create_file_a           equ 0x7002EC    ; The Kernel32.CreateFileA function (https://docs.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-createfilea)
write_file              equ 0x700244    ; The Kernel32.WriteFile function (https://docs.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-writefile)
read_file               equ 0x700278    ; The Kernel32.ReadFile function (https://docs.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-readfile)
get_current_process_id  equ 0x700324    ; The Kernel32.GetCurrentProcessId function (https://docs.microsoft.com/en-us/windows/win32/api/processthreadsapi/nf-processthreadsapi-getcurrentprocessid)
sleep                   equ 0x700300    ; The Kernel32.Sleep function (https://docs.microsoft.com/en-us/windows/win32/api/synchapi/nf-synchapi-sleep)
create_thread           equ 0x700138    ; The Kernel32.CreateThread function (https://docs.microsoft.com/en-us/windows/win32/api/processthreadsapi/nf-processthreadsapi-createthread)

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

; Contains the number of bytes read from the discord pipe.
discord_num_bytes_read:
    dd  0

; The discord application id.
discord_application_id:
    db "836858659128213515", 0

; The handshake JSON format.
discord_handshake_format:
    db '{"v":1,"client_id":"%s"}', 0

; The name of the player's map
player_map_name:
    times 128 db 0

; The activity update JSON format.
discord_activity_format:
    db '{"nonce":"1","cmd":"SET_ACTIVITY","args":{"pid":%d, "activity":{'
    db '"state":"%s","details":"Lv.%d %s","assets":{"large_image":"bigshaiya","small_image":"kill_rank_%d","small_text":"%d kills"},'
    db '"instance":false}}}', 0

; The clear activity command.
discord_clear_activity:
    db '{"nonce":"1", "cmd":"SET_ACTIVITY","args":{"pid":%d}}',0

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

; Initialise the Discord IPC activity thread.
init_discord_activity_thread:
    push ebp
    mov ebp, esp

    ; Create a thread for updating the activity
    push 0                          ; lpThreadId
    push 0                          ; dwCreationFlags
    push 0                          ; lpParameter
    push discord_activity_thread    ; lpStartAddress
    push 0                          ; dwStackSize
    push 0                          ; lpThreadAttributes
    call dword [create_thread]

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
    dec eax
    mov dword [esp+4], eax
    inc eax

discord_send_frame_payload_loop:
    mov bl, byte [esi+eax]
    mov byte [esp+eax+8], bl
    test eax, eax
    je discord_send_frame_payload_loop_exit
    dec eax
    jmp discord_send_frame_payload_loop
discord_send_frame_payload_loop_exit:

    ; Write the payload
    dec edi
    mov ebx, esp
    push 0                          ; lpOverlapped
    push discord_num_bytes_written  ; lpNumberOfBytesWritten
    push edi                        ; nNumberOfBytesToWrite
    push ebx                        ; lpBuffer
    mov eax, dword [discord_ipc_handle]
    push eax
    call dword [write_file]
    add esp, 2048

    ; Compare the bytes written to the bytes requested
    cmp dword [discord_num_bytes_written], edi
    je discord_send_frame_exit

    ; Zero-out the IPC file.
    mov dword [discord_ipc_handle], 0
discord_send_frame_exit:
    ; Restore the stack
    pop ebx
    pop edi
    pop edx

    ; Exit the function.
    mov esp, ebp
    pop ebp
    retn 8

; Reads a frame from the Discord IPC client.
discord_read_frame:
    push ebp
    mov ebp, esp

    ; Allocate space on the stack for the response.
    push edi
    sub esp, 2048
    mov edi, esp

    ; Read a frame header.
    push 0                      ; lpOverlapped
    push discord_num_bytes_read ; lpNumberOfBytesRead
    push 8                      ; nNumberOfBytesToRead (frame header is u32 opcode, u32 len)
    push edi                    ; lpBuffer
    mov eax, dword [discord_ipc_handle]
    push eax                    ; hFile
    call dword [read_file]

    ; Read the frame payload.
    push 0                      ; lpOverlapped
    push discord_num_bytes_read ; lpNumberOfBytesRead
    mov eax, dword [edi + 4]
    push eax                    ; nNumberOfBytesToRead
    add edi, 8
    push edi                    ; lpBuffer
    mov eax, dword [discord_ipc_handle]
    push eax                    ; hFile
    call dword [read_file]

    ; Clean up the stack.
    add esp, 2048
    pop edi

    mov esp, ebp
    pop ebp
    retn

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

    ; Read the response
    call discord_read_frame

    mov esp, ebp
    pop ebp
    retn

; Handles the execution of the activity update thread.
discord_activity_thread:
    push ebp
    mov ebp, esp

discord_activity_thread_loop:
    ; If the Discord connection isn't active, exit this thread
    cmp dword [discord_ipc_handle], 0
    jne discord_activity_thread_exec

    ; Attempt to re-establish a connection
    call init_discord_ipc

    ; Sleep for 5 seconds
    push 5000
    call dword [sleep]
    jmp discord_activity_thread_loop

discord_activity_thread_exec:
    ; Sleep for 1 second.
    push 1000
    call dword [sleep]

    ; Update the rich presence
    call discord_activity_update
    jmp discord_activity_thread_loop

discord_activity_thread_exit:
    mov esp, ebp
    pop ebp
    retn

; Sends an activity update to Discord.
discord_activity_update:
    push ebp
    mov ebp, esp

    ; If the Discord IPC client value is null, do nothing
    cmp dword [discord_ipc_handle], 0
    je discord_activity_exit

    ; If the user is logged in to a character, set the activity.
    cmp dword [player_id], 0
    jne discord_activity_update_player

    ; Allocate space on the stack for the formatted command.
    push edi
    sub esp, 256
    mov edi, esp

    ; Format the activity
    call dword [get_current_process_id]
    push eax
    push discord_clear_activity
    push edi
    call sprintf

    ; Clear the activity.
    push DISCORD_OP_FRAME
    push edi
    call discord_send_frame
    add esp, 268
    pop edi

    ; Read the response
    call discord_read_frame
    jmp discord_activity_exit

discord_activity_update_player:
    ; Get the current map name.
    push ecx
    mov eax, dword [player_map]
    push eax
    push player_map_name
    mov ecx, file_client
    call get_map_name
    pop ecx

    ; Allocate space on the stack for the formatted command.
    push edi
    sub esp, 2048
    mov edi, esp

    ; Format the command.
    mov eax, dword [player_kills]
    push eax
    call get_player_kill_rank
    push eax
    push char_name_addr
    xor eax, eax
    mov ax, word [player_level]
    push eax
    push player_map_name
    call dword [get_current_process_id]
    push eax
    push discord_activity_format
    push edi
    call sprintf

    ; Send the frame.
    push DISCORD_OP_FRAME
    push edi
    call discord_send_frame
    add esp, 2080

    ; Read the response
    call discord_read_frame
    pop edi

discord_activity_exit:
    mov esp, ebp
    pop ebp
    retn