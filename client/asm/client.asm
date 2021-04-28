%include    "asm/client_pe.asm"
bits        32

; Update the virtual size on the read-only section header.
va_org  0x400220
dd      new_size_rdata

; =========================================================================================================
va_section  .text
; Patch: Load custom graphic options
va_org      0x40694B
jmp         load_graphic_options

; Patch: Always flag the window as focused.
va_org      0x407958
jmp         flag_window_focused
nop

; Patch: Customise the window title.
va_org      0x4081FD
jmp         get_window_title

; Patch: Write the ip address
va_org      0x408BD3
jmp         write_login_ip_addr

; Patch: Enable multi-client.
va_org      0x40B91C
jmp         short 0x40B96C
va_org      0x40B97A
jmp         short 0x40B9AD

; Patch: Don't require the updater start params.
va_org      0x40BCEB
jmp         0x40BDBC

; Patch: Toggle effects on or off depending on the config flag.
va_org      0x416D60
jmp         toggle_effects_secondary

; Patch: Run startup code before rendering login screen.
va_org      0x42CA40
jmp         startup

; Patch: Update the copyright logo
va_org      0x42CB3A
push        copyright_logo

; Patch: Update the copyright footer.
va_org      0x42CD60
push        copyright_text
va_org      0x42CD73
dd          copyright_x_offset
va_org      0x42CE7D
push        copyright_text
va_org      0x42CE90
dd          copyright_x_offset

; Patch: Use a custom camera limit
va_org      0x439C64
db          0xEB            ; Change the JE to a JMP
va_org      0x439C70
dd          camera_limit    ; The maximum camera limit.

; Patch: Use the custom kill table.
va_org      0x445F03
dd          kill_rank_table

; Patch: Modify the colour of GM's names.
va_org      0x44A325
dd          gm_name_color

; Patch: Toggle effects on or off depending on the config flag.
va_org      0x4508F0
jmp         toggle_effects_primary

; Patch: Update the window title when the user selects a character
va_org      0x46F890
jmp         update_window_title_char_name

; Patch: Add support for custom client commands.
va_org      0x47546E
jmp         parse_custom_commands

; Patch: Allow all users to use commands.
va_org      0x47D603
times       6 nop

; Patch: Apply the shadow on the item stack quantity to all item types.
va_org      0x4A8E52
je          0x4A8F02

; Patch: Format the text for the cooldown.
va_org      0x4A9FCB
jmp         prepare_cooldown_text

; Patch: Modify the colour of the cooldown dial.
va_org      0x4AA02C
dd          cooldown_colour

; Patch: Draw text for the cooldown.
va_org      0x4AA088
jmp         draw_cooldown_text

; Patch: Modify the loading screen delay
va_org      0x4C1D11
dd          loading_screen_delay

; Patch: Modify the player's buffs.
va_org      0x4C66EE
jmp         render_buffs

; Patch: Display map images for dungeons
va_org      0x4C8827
je          short 0x4C8837  ; By using "je short" we can guarantee it's a relative jump, as this should occupy only 2 bytes.

; Patch: Update the map clock format
va_org      0x4D012A
push        map_clock_format

; Patch: Update the position of the clock text.
va_org      0x4D0185
jmp         adjust_clock_text
nop

; Patch: Save custom config options.
va_org      0x502BA3
jmp         save_custom_config

; Patch: Adjust the amount of statpoints that are allocated.
va_org      0x51017F
jmp         allocate_stat_points

; Patch: Use the custom kill table.
va_org      0x510F93
dd          kill_rank_table

; Patch: Adjust the GM name colour for the target frame.
va_org      0x519F27
dd          gm_name_color

; Patch: Add the destination map to the summon dialogue box.
va_org      0x5361BF
jmp         write_summon_destination

; Patch: Add extra information to the debug text.
va_org      0x5500E6
jmp         format_debug_info

; Patch: Reset the window title when we enter the character screen
va_org      0x5B5070
jmp         reset_window_title

; Patch: Read the map id from the summon packet.
va_org      0x5BE6C5
jmp         read_summon_packet

; Patch: Read custom packets
va_org      0x5C7640
jmp         check_inbound_custom_packets

; Include read-only resources
va_section  .rdata

; Modify writable data
new_size_rdata  equ $-$$    ; Size of the read-only data.
va_section  .data

; Custom code
va_section  .teos
%include    "asm/metadata.asm"
%include    "asm/network.asm"
%include    "asm/window.asm"
%include    "asm/map_clock.asm"
%include    "asm/statpoints.asm"
%include    "asm/antifreeze.asm"
%include    "asm/summon.asm"
%include    "asm/names.asm"
%include    "asm/copyright.asm"
%include    "asm/loading.asm"
%include    "asm/cooldowns.asm"
%include    "asm/debug.asm"
%include    "asm/player.asm"
%include    "asm/camlimit.asm"
%include    "asm/settings.asm"
%include    "asm/effects.asm"
%include    "asm/commands.asm"
%include    "asm/util.asm"
%include    "asm/file.asm"
%include    "asm/costumes.asm"
%include    "asm/startup.asm"
%include    "asm/buffs.asm"
%include    "asm/discord.asm"
%include    "asm/kills.asm"
%include    "asm/packets.asm"

; Append the rest of the data
va_org      end