login_ip            equ 0x7718F0 ; The address where the login server ip should be stored.
get_login_addr_exit equ 0x408E0B ; The address to return to after storing the login ip.

; The login server ip address
login_ip_addr:
    db "127.0.0.1", 0

; The message format
login_ip_addr_format:
    db "%s", 0

; The function for writing the login server ip address
write_login_ip_addr:
    push login_ip_addr               ; Format the login server ip address
    push login_ip_addr_format
    push login_ip
    call sprintf
    add esp, 12
    jmp get_login_addr_exit