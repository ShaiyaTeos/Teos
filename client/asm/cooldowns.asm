cooldown_colour     equ 0xF0000000  ; The colour of the cooldown dial.
cooldown_retn       equ 0x4A9FD0    ; The address to return to.
cooldown_draw_retn  equ 0x4AA08D    ; The address to return to after drawing the text.

; The format to include minutes.
cooldown_minutes_format:
    db "%d:%02d", 0

; The formatted cooldown text.
cooldown_text:
    times   32 db  0

; The function to draw the cooldown text.
prepare_cooldown_text:
    ; Preserve eax (the remaining time on the cooldown)
    pushad
    pushfd

    ; Store the number of seconds into eax.
    mov ecx, 1000
    xor edx, edx
    div ecx

    ; Calculate the minutes and seconds
    mov ecx, 60
    xor edx, edx
    div ecx ; EDX = seconds, EAX = minutes

    ; Format the text.
    push edx
    push eax
    push cooldown_minutes_format
    push cooldown_text
    call sprintf
    add esp, 16

    ; Draw the cooldown dial.
    popfd
    popad
    push esi
    mov dword [esp+0x70], eax
    jmp cooldown_retn

; Draw the text for the cooldown of an item or skill
draw_cooldown_text:

    ; Draw the text
    push cooldown_text
    push 0x00   ; Alpha
    push 0x00   ; B
    push 0xEC   ; G
    push 0xFF   ; R

    ; Load the position of the item from the stack, and offset it slightly.
    mov eax, dword [esp+160]    ; Y
    add eax, 6                  ; Move the text down by 6 pixels.
    push eax
    mov eax, dword [esp+96]     ; X
    add eax, 6                  ; Move the text 6 pixels to the right.
    push eax

    ; Draw the text
    push text_client
    call draw_text
    add esp, 32

    ; Return to the draw function
    mov eax, dword [0x2261C20]
    jmp cooldown_draw_retn
