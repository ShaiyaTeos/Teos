write_text              equ 0x41F1D0    ; The function to write text to the chat box.
error_message           equ 0x7023CC    ; The text for an error message box.
message_box_a           equ 0x700428    ; The address where USER32.MessageBoxA is stored.
post_message_a          equ 0x70042C    ; The address where USER32.PostMessageA is stored.
operator_new            equ 0x5FF93E    ; The function for allocating memory using C++'s operator new.
operator_delete         equ 0x5FD99A    ; The function for deleting memory using C++'s operator delete.
memset                  equ 0x5FEB80    ; The C function for setting a block of memory to a value.
play_animation          equ 0x412B50    ; The function for playing an animation.
digit_format            equ 0x702358    ; The formatter for a digit.
sscanf                  equ 0x5FE47D    ; The C function for scanning from a string.
effect_code_white       equ 0           ; The effect code for white text.
effect_code_top_orange  equ 13          ; The effect code for writing orange text to the top chat box.
effect_code_top_red     equ 14          ; The effect code for writing red text to the top chat box.
effect_code_top_yellow  equ 16          ; The effect code for writing yellow text to the top chat box.
effect_code_top_green   equ 17          ; The effect code for writing green text to the top chat box.
effect_code_top_pink    equ 18          ; The effect code for writing pink text to the top chat box.
effect_code_top_lblue   equ 19          ; The effect code for writing light blue text to the top chat box.
effect_code_top_lime    equ 20          ; The effect code for writing lime text to the top chat box.
effect_code_notice      equ 21          ; The effect code for writing text as if it were a notice.
effect_code_notice_y    equ 22          ; The effect code for writing yellow text in the top chat, and a normal notice.
effect_code_top_grey    equ 29          ; The effect code for writing grey text to the top chat box.
effect_code_grey        equ 32          ; The effect code for writing grey text.
effect_code_lime        equ 33          ; The effect code for writing lime text.
effect_code_peach       equ 34          ; The effect code for writing peach text.
effect_code_violet      equ 35          ; The effect code for writing violet text.
effect_code_cream       equ 36          ; The effect code for writing cream text.
effect_code_d_orange    equ 37          ; The effect code for writing dark orange text (same as yelling).
effect_code_yellow      equ 38          ; The effect code for writing yellow text.
effect_code_red         equ 40          ; The effect code for writing red text.
effect_code_pink        equ 45          ; The effect code for writing pink text.
effect_code_mts         equ 46          ; The effect code for writing text as a Message to Server.
effect_code_area        equ 47          ; The effect code for writing text with the blue colour from area chat.
effect_code_pink_mts    equ 48          ; The effect code for writing text as a darker Message to Server.

; The formatter for two digits
two_digit_format:
    db  "%d %d", 0

; Writes text to the player's chat box.
;
; Usage:
; push text_message
; push effect_code
; call write_client_chat_text
write_client_chat_text:
    push ebp
    mov ebp, esp    ; Stdcall

    mov esi, [ebp + 8]  ; Effect code
    mov edx, [ebp + 12] ; Input text

    push 0      ; Doesn't seem like it's actually used.
    push edx
    push esi
    call write_text
    add esp, 12

    mov esp, ebp
    pop ebp
    retn 8

; Exits the process with a message box.
;
; Usage:
; push message
; call exit_with_message
exit_with_message:
    push ebp
    mov ebp, esp    ; Stdcall

    mov ecx, [ebp + 8]  ; Message

    ; Display the message box.
    push 0x00000010  ; Error message style
    push error_message
    push ecx
    push 0  ; HWND
    call dword [message_box_a]

    ; Close the window.
    mov edx, dword [window_handle]
    push 0
    push 0
    push 0x10   ; WM_Close
    push edx
    call dword [post_message_a]

    mov esp, ebp
    pop ebp
    retn 4

; Compares two strings.
;
; Usage:
; push first_string
; push second_string
; call string_compare
string_compare:
    push ebp
    mov ebp, esp

    push edi
    push esi
    push ecx
    xor eax, eax

    mov edi, [ebp + 8]
    mov esi, [ebp + 12]

    ; Loop through and compare the strings.
string_compare_loop:
    mov cl, byte [edi+eax]
    test cl, cl
    je string_compare_exit  ; Exit if we've reached a null terminator.
    cmp byte [esi+eax], cl
    jne string_compare_fail ; Exit if the bytes aren't equal.
    inc eax
    jmp string_compare_loop  ; Re-nter the loop if the bytes are equal.
string_compare_fail:
    xor eax, eax

    ; Clean up the stack
string_compare_exit:
    pop ecx
    pop esi
    pop edi
    mov esp, ebp
    pop ebp
    retn 8