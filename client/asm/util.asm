write_text              equ 0x41F1D0    ; The function to write text to the chat box.
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