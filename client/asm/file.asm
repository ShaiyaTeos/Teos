saf_read_file   equ 0x40C900    ; The function for reading a file from the data file.
read_buffer     equ 0x59EB00    ; The function for reading from a buffer.

; The encryption key for reading sdata files.
sdata_key:
    db "0001CBCEBC5B2784D3FC9A2A9DB84D1C3FEB6E99", 0

; The flag for reading a file
read_file_flag:
    db "rb", 0  ; Read, binary

; The destination buffer for the file header.
header_buf:
    times   41  db  0

; Read a file from the data file.
read_file:
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
    call read_file
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


read_sdata_unencrypted: ; Open the encrypted file.
    mov eax, [ebp + 8]
    push eax
    call read_file
read_sdata_exit:
    mov esp, ebp
    pop ebp
    retn 4