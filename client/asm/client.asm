%include    "inc/client_pe.inc"
bits        32

; Update the virtual size on the read-only section header.
va_org  0x400220
dd      new_size_rdata

; Code hooks
va_section  .text

; Include read-only resources
va_section  .rdata

; Calculate the new size of the read-only data.
new_size_rdata  equ $-$$

; Append the rest of the data
va_org      end