%ifndef ps_game_pe_inc  ; Include guards to stop this file being parsed multiple times
%define ps_game_pe_inc

%ifndef ptarget
    %define ptarget "bin/ps_game_original.exe"  ; Define the input target
%endif

imagebase       equ         0x400000    ; Base address of the image

; .hdrs
virt.hdrs       equ         imagebase
raw.hdrs        equ         0x00
rsize.hdrs      equ         0x1000
hdrs_vsize      equ         0x298
hdrs_end        equ         virt.hdrs + hdrs_vsize

; .text (code segment)
virt.text       equ         imagebase + 0x1000
raw.text        equ         0x1000
rsize.text      equ         0x120000
text_vsize      equ         0x11f244
text_end        equ         virt.text + text_vsize

; .rdata (read-only data segment)
virt.rdata      equ         imagebase + 0x121000
raw.rdata       equ         0x121000
rsize.rdata     equ         0x1F000
rdata_vsize     equ         0x1EC7A
rdata_end       equ         virt.rdata + rdata_vsize

; .data (writable data segment)
virt.data       equ         imagebase + 0x140000
raw.data        equ         0x140000
rsize.data      equ         0x3000
data_vsize      equ         0x3A94E88
data_end        equ         virt.data + data_vsize

; .teos (custom code segment)
virt.teos       equ         imagebase + 0x3BD5000
raw.teos        equ         0x143000
rsize.teos      equ         0x2000
teos_vsize      equ         0x2000
teos_end        equ         virt.teos + teos_vsize

; Define the address of the custom import table section
teos_iat            equ     0x3FD7000
teos_startup_rva    equ     0xEF

; pre-define all sections
                section     .hdrs   vstart=virt.hdrs
                section     .text   vstart=virt.text    follows=.hdrs
                section     .rdata  vstart=virt.rdata   follows=.text
                section     .data   vstart=virt.data    follows=.rdata
                section     .teos   vstart=virt.teos    follows=.data

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
