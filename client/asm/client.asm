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

; Append the rest of the data
va_org      end