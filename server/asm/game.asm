%include    "asm/ps_game.asm"
bits        32

security_check_cookie   equ 0x505316 ; Check cookie function
security_cookie_default equ 0x54059C ; The address containing the default cookie value.

; Update the virtual size on the read-only section header.
va_org  0x400220
dd      new_size_rdata

; =========================================================================================================
va_section  .text
; Patch: Modify the text that gets printed when the log starts.
va_org      0x403D53
jmp         modify_game_log_text
times       19  nop

; Patch: Increase the amount of memory allocated for a player.
va_org      0x40AA68
jmp         cuser_create

; Patch: Call our custom function when a user connects.
va_org      0x44A831
jmp         cuser_enter_world
times       2   nop

; Patch: Call our custom SetAttack function after the stats are calculated.
va_org      0x454553
jmp         cuser_set_attack_end

; Patch: Call our custom function when a user sends a packet.
va_org      0x466ECE
jmp         cuser_packet_recv

; Patch: Call our custom SendCharacterList function.
va_org      0x46D06C
jmp         cuser_send_character_list

; Patch: Send the updated TP_CHAR_DATA packet.
va_org      0x483140
jmp         cuser_send_character_details

; Patch: Modify the summon packet.
va_org      0x48DB14
jmp         write_summon_packet

; Patch: Call our custom function when the admin sends a console command.
va_org      0x4D5EB4
jmp         console_command

; ========================================================================================================
va_section  .rdata
; Add a string to the end of the read-only data.
va_org          rdata_end
%include                    "asm/metadata.asm"
game_log_text   db          "PS_GAME__system log start (%s) [Teos - (branch=%s, rev=%s)]", 0

; ========================================================================================================
new_size_rdata  equ         $-$$    ; Size of the read-only data.
va_section  .data
; Turn NProtect off by default
g_bUseNProtect  equ         0x541F7C
va_org          g_bUseNProtect
db              0

; Include data for the custom code segment
va_section  .teos
%include    "asm/startup.asm"
%include    "asm/game_log_text.asm"
%include    "asm/cuser.asm"
%include    "asm/command.asm"
%include    "asm/summon.asm"
va_org          end