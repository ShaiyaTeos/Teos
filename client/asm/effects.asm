render_primary_effect_retn      equ 0x4508F7    ; The address to return to for rendering effects.
render_secondary_effect_retn    equ 0x416D67    ; The address to return to for rendering effects.
play_graphical_effect           equ 0x4508F0    ; The function for rendering an effect.

; Toggle effects depending on the config state.
toggle_effects_primary:
    push eax
    mov al, byte [is_effects_enabled]
    test al, al
    pop eax
    jne render_primary_effects
    retn 24 ; Return early
render_primary_effects:
    mov eax, [esp+4]
    sub esp, 16
    jmp render_primary_effect_retn

; Toggle effects depending on the config state.
toggle_effects_secondary:
    push eax
    mov al, byte [is_effects_enabled]
    test al, al
    pop eax
    jne render_secondary_effects
    retn 12 ; Return early
render_secondary_effects:
    mov eax, [esp+4]
    sub esp, 16
    jmp render_secondary_effect_retn