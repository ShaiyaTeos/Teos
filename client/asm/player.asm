user_status     equ 0x8BDA5C    ; The address where the user's GM status is stored.
player_map      equ 0x8BEB64    ; The address where the user's current map id is stored.
pos_x           equ 0x8B5444    ; The address of the player's x position
pos_y           equ 0x8B5448    ; The address of the player's y position
pos_z           equ 0x8B544C    ; The address of the player's z position
get_player      equ 0x4498C0    ; The address for getting a player for their id.
player_id       equ 0x8BEB78    ; The address for the player's own id.
player_ptr      equ 0x8B541C    ; Stores the current player's pointer.
player_kills    equ 0x22563CC   ; Stores the player's kills.
player_level    equ 0x8BDA68    ; Stores the player's level.
client_base     equ 0x775550    ; Not sure what this does but it's required for getting player instances.

cuser_size      equ 1536        ; The number of bytes to allocate each player.

struc CUser
    .unknown        resb    52
    .id             resd    1
    .unknown2       resb    184
    .name           resb    21
    .unknown3       resb    419
    .admin_status   resb    1
    .unknown4       resb    343
    .title          resd    1
endstruc

; Modifies the CUser constructor slightly to also zero-out custom fields.
cuser_constructor:
    mov dword [esi+CUser.title], ebx
    pop ecx
    pop edi
    pop esi
    pop ebp
    pop ebx
    add esp, 32
    retn
