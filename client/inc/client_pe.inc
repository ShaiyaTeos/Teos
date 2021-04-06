%ifndef client_pe_inc
%define client_pe_inc

%ifndef ptarget
    %define ptarget "bin/ps0198-20-9-2012-game.exe"
%endif

imagebase       equ         0400000h

; .hdrs
virt.hdrs       equ         imagebase
raw.hdrs        equ         00h
rsize.hdrs      equ         0400h
hdrs_vsize      equ         02d0h
hdrs_end        equ         virt.hdrs + hdrs_vsize

; .text
virt.text       equ         imagebase + 01000h
raw.text        equ         0400h
rsize.text      equ         02fe200h
text_vsize      equ         02fe131h
text_end        equ         virt.text + text_vsize

; .rdata
virt.rdata      equ         imagebase + 0300000h
raw.rdata       equ         02fe600h
rsize.rdata     equ         05d000h
rdata_vsize     equ         05cebah
rdata_end       equ         virt.rdata + rdata_vsize

; .data
virt.data       equ         imagebase + 035d000h
raw.data        equ         035b600h
rsize.data      equ         014200h
data_vsize      equ         01b52bb8h
data_end        equ         virt.data + data_vsize

; .rsrc
virt.rsrc       equ         imagebase + 01eb0000h
raw.rsrc        equ         036f800h
rsize.rsrc      equ         0be00h
rsrc_vsize      equ         0bcfch
rsrc_end        equ         virt.rsrc + rsrc_vsize

; pre-define all sections
                section     .hdrs vstart=virt.hdrs
                section     .text vstart=virt.text follows=.hdrs
                section     .rdata vstart=virt.rdata follows=.text
                section     .data vstart=virt.data follows=.rdata
                section     .rsrc vstart=virt.rsrc follows=.data

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
