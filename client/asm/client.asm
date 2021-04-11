%include    "asm/client_pe.asm"
bits        32

; Update the virtual size on the read-only section header.
va_org  0x400220
dd      new_size_rdata

; =========================================================================================================
va_section  .text
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

; Patch: Modify the colour of GM's names.
va_org      0x44A325
dd          gm_name_color

; Patch: Update the window title when the user selects a character
va_org      0x46F890
jmp         update_window_title_char_name

; Patch: Modify the loading screen delay
va_org      0x4C1D11
dd          loading_screen_delay

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

; Patch: Adjust the amount of statpoints that are allocated.
va_org      0x51017F
jmp         allocate_stat_points

 ; Patch: Add the destination map to the summon dialogue box.
va_org      0x5361BF
jmp         write_summon_destination

; Patch: Reset the window title when we enter the character screen
va_org      0x5B5070
jmp         reset_window_title

; Patch: Read the map id from the summon packet.
va_org      0x5BE6C5
jmp         read_summon_packet

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

; Append the rest of the data
va_org      end