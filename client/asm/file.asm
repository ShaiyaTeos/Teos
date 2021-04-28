saf_read_file   equ 0x40C900    ; The function for reading a file from the data file.
read_buffer     equ 0x59EB00    ; The function for reading from a buffer.
file_data       equ 0x7722F8    ; A pointer to the most recently opened file.
seed_decrypt    equ 0x5DC2E0    ; The function for decrypting SData buffers using KISA's SEED algorithm.
seed_key        equ 0x7647C8    ; The SEED key array (128 bytes).

; The header for an encrypted file.
struc SData
    .signature: resb    40
    .checksum:  resd    1
    .length:    resd    2
    .padding:   resb    12
endstruc

; The encryption key for reading sdata files.
sdata_key:
    db "0001CBCEBC5B2784D3FC9A2A9DB84D1C3FEB6E99", 0

; The flag for reading a file
read_file_flag:
    db "rb", 0  ; Read, binary

; The destination buffer for the file header.
header_buf:
    times   SData_size  db  0

; The length of the data.
data_length:
    dd  0

; Read a file from the data file.
read_sah_file:
    push ebp            ; Load the argument
    mov ebp, esp
    mov eax, [ebp + 8]

    push read_file_flag ; Read the file, file pointer stored in eax.
    push eax
    call saf_read_file
    add esp, 8

    mov esp, ebp    ; Clean up the stack
    pop ebp
    retn 4

; Read a SData file from the data file. This function takes care
; of decrypting the target file if necessary.
read_sdata_file:
    push ebp
    mov ebp, esp
    mov eax, [ebp + 8]  ; SData path.

    ; Load the file.
    push eax
    call read_sah_file
    test eax, eax
    je read_sdata_exit

    ; Read the header
    push eax            ; File pointer.
    push 40             ; 40 values.
    push 1              ; Single bytes.
    push header_buf     ; Destination buffer.
    call read_buffer
    add esp, 16

    ; Check if the header matches the encryption key.
    push header_buf
    push sdata_key
    call string_compare
    test al, al
    je read_sdata_unencrypted  ; No further action needed - file is not encrypted.

    ; Load the file
    mov eax, [ebp + 8]
    push eax
    call read_sah_file
    test eax, eax
    je read_sdata_exit

    ; Load the file pointer into ESI.
    push esi
    mov esi, eax

    ; Read the file header.
    push esi
    push SData_size
    push 1
    push header_buf
    call read_buffer
    add esp, 16

    ; Allocate a block of memory to read the data into.
    push ebx
    mov ebx, dword [header_buf + SData.length]
    push edi
    push ebx
    call operator_new
    add esp, 4
    mov edi, eax

    ; Zero out the memory region.
    push ebx
    push 0
    push edi
    call memset
    add esp, 12

    ; Read the file data.
    push esi
    push ebx
    push 1
    push edi
    call read_buffer
    add esp, 16

    ; Decrypt the file data.
    mov [data_length], ebx
    push seed_key
    push data_length
    push edi
    call seed_decrypt
    add esp, 12

    ; Move the address of the data into eax.
    mov eax, edi
    pop edi
    pop ebx
    pop esi
    jmp read_sdata_exit

read_sdata_unencrypted: ; Open the unencrypted file.
    mov eax, [ebp + 8]
    push eax
    call read_sah_file

read_sdata_exit:
    mov esp, ebp
    pop ebp
    retn 4