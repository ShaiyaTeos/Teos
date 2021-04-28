%ifndef client_pe_asm
%define client_pe_asm

%ifndef ptarget
    %define ptarget "bin/ps0198-20-9-2012-game.exe"
%endif

imagebase       equ         0x400000

; .hdrs
virt.hdrs       equ         imagebase
raw.hdrs        equ         0x00
rsize.hdrs      equ         0x400
hdrs_vsize      equ         0x2F8
hdrs_end        equ         virt.hdrs + hdrs_vsize

; .text
virt.text       equ         imagebase + 0x1000
raw.text        equ         0x400
rsize.text      equ         0x2FE200
text_vsize      equ         0x2FE131
text_end        equ         virt.text + text_vsize

; .rdata
virt.rdata      equ         imagebase + 0x300000
raw.rdata       equ         0x2FE600
rsize.rdata     equ         0x5D000
rdata_vsize     equ         0x5CEBA
rdata_end       equ         virt.rdata + rdata_vsize

; .data
virt.data       equ         imagebase + 0x35D000
raw.data        equ         0x35B600
rsize.data      equ         0x14200
data_vsize      equ         0x1B52BB8
data_end        equ         virt.data + data_vsize

; .rsrc
virt.rsrc       equ         imagebase + 0x1EB0000
raw.rsrc        equ         0x36F800
rsize.rsrc      equ         0xBE00
rsrc_vsize      equ         0xBCFC
rsrc_end        equ         virt.rsrc + rsrc_vsize

; .teos
virt.teos       equ         imagebase + 0x1EBC000
raw.teos        equ         0x37B600
rsize.teos      equ         0x2000
teos_vsize      equ         0x2000
teos_end        equ         virt.teos + teos_vsize

; pre-define all sections
                section     .hdrs vstart=virt.hdrs
                section     .text vstart=virt.text follows=.hdrs
                section     .rdata vstart=virt.rdata follows=.text
                section     .data vstart=virt.data follows=.rdata
                section     .rsrc vstart=virt.rsrc follows=.data
                section     .teos vstart=virt.teos follows=.rsrc

; start in the .hdrs pseudo section
                section     .hdrs
%assign cur_raw raw.hdrs
%assign cur_virt virt.hdrs
%assign cur_rsize rsize.hdrs

; move assembly position to the start of a new section
%macro va_section 1
                incbin      ptarget, cur_raw + ($-$$), raw%1 - (cur_raw + ($-$$))
                section     %1
    %assign cur_raw  raw%1
    %assign cur_virt virt%1
    %assign cur_rsize rsize%1
%endmacro

; move assembly position forward within the current section.
; use 'va_org end' at the end of the code to append the remainder of the original data
%macro va_org 1
    %ifidn %1, end
                incbin      ptarget, cur_raw + ($-$$)
    %elif %1 >= cur_virt && %1 < cur_virt + cur_rsize
                incbin      ptarget, cur_raw + ($-$$), %1 - (cur_virt + ($-$$))
    %else
        %error address %1 out of section range
    %endif
%endmacro

%endif
