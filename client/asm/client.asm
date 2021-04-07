%include    "asm/client_pe.asm"
bits        32

; Update the virtual size on the read-only section header.
va_org  0x400220
dd      new_size_rdata

; =========================================================================================================
va_section  .text
; Patch: Customise the window title.
va_org      0x4081FD
jmp         get_window_title

; Patch: Write the ip address
va_org      0x408BD3
jmp         write_login_ip_addr

; Patch: Don't require the updater start params.
va_org      0x40BCEB
jmp         0x40BDBC

; Patch: Update the window title when the user selects a character
va_org      0x46F890
jmp         update_window_title_char_name

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

; Patch: Reset the window title when we enter the character screen
va_org      0x5B5070
jmp         reset_window_title

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

; Append the rest of the data
va_org      end