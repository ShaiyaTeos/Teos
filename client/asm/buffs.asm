render_skill_icon   equ 0x4A8FD0    ; Renders a skill icon.
render_buff_retn    equ 0x4C66FD    ; The address to return to after rendering the buff icon.

; Renders the player's own buffs on the screen.
render_buffs:
    push 1          ; Skill active state (0 = Greyed out, 1 = Learned)
    push eax        ; Skill level.
    push ecx        ; Skill id.
    push ebx        ; Y position.
    push ebp        ; X position.
    push 0xFFFFFFFF ; Opacity
    mov ecx, edi    ; Skill definition
    call render_skill_icon
    jmp render_buff_retn