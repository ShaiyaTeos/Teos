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