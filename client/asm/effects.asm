load_effect_retn_fail   equ 0x40D745    ; The address for failing a "load effect" call.
load_effect_retn        equ 0x40D6BB    ; The address to return to for loading effects.

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