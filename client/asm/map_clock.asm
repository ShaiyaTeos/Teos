clock_horizontal_offset equ 28          ; The horizontal offset of the map clock.
draw_text               equ 0x54EE00    ; The function for drawing text.
clock_offset_retn       equ 0x4D0190    ; The address to return to.
text_client             equ 0x2261C28   ; Not 100% sure what this is, but it's used in every text call.

; The new format for the clock time.
map_clock_format:
    db "%a %d - %I:%M:%S %p", 0

; The function for adjusting the position of the clock text
adjust_clock_text:
    sub eax, clock_horizontal_offset
    push eax
    push text_client
    call draw_text
    jmp clock_offset_retn
