load_effect_retn_fail   equ 0x40D745    ; The address for failing a "load effect" call.
load_effect_retn        equ 0x40D6BB    ; The address to return to for loading effects.
play_graphical_effect   equ 0x4508F0    ; The function for rendering an effect.


; Toggle effects depending on the config state.
toggle_effects:
    push eax
    mov al, byte [is_effects_enabled]
    test al, al
    pop eax
    je load_effect_retn_fail

    cmp dword [edi + 0x0C], 0
    jne 0x40D6C0
    jmp load_effect_retn