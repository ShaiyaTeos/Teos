kill_rank_table:
    dd 1        ; Rank 1 (I)
    dd 50       ; Rank 2 (II)
    dd 300      ; Rank 3 (III)
    dd 1000     ; Rank 4 (>)
    dd 5000     ; Rank 5 (>>)
    dd 10000    ; Rank 6 (>>>)
    dd 20000    ; Rank 7 (<>)
    dd 30000    ; Rank 8 (<><>)
    dd 40000    ; Rank 9 (<><><>)
    dd 50000    ; Rank 10 (1 Flower)
    dd 70000    ; Rank 11 (2 Flowers)
    dd 90000    ; Rank 12 (3 Flowers)
    dd 110000   ; Rank 13 (*)
    dd 130000   ; Rank 14 (**)
    dd 150000   ; Rank 15 (***)
    dd 200000   ; Rank 16 (Yellow I)
    dd 250000   ; Rank 17 (Yellow II)
    dd 300000   ; Rank 18 (Yellow III)
    dd 350000   ; Rank 19 (Yellow >)
    dd 400000   ; Rank 20 (Yellow >>)
    dd 450000   ; Rank 21 (Yellow >>>)
    dd 500000   ; Rank 22 (Yellow <>)
    dd 550000   ; Rank 23 (Yellow <><>)
    dd 600000   ; Rank 24 (Yellow <><><>)
    dd 650000   ; Rank 25 (Yellow 1 Flower)
    dd 700000   ; Rank 26 (Yellow 2 Flowers)
    dd 750000   ; Rank 27 (Yellow 3 Flowers)
    dd 800000   ; Rank 29 (Yellow *)
    dd 850000   ; Rank 30 (Yellow **)
    dd 900000   ; Rank 31 (Yellow ***)
    dd 1000000  ; Rank 32 (Pink Star)

; Get the kill rank for the player
get_player_kill_rank:
    push ebp
    mov ebp, esp

    xor eax, eax
    push ecx
    push ebx

    mov ecx, dword [player_kills]
get_player_kill_rank_loop:
    mov ebx, [kill_rank_table+eax*4]
    cmp ecx, ebx
    jl get_player_kill_rank_loop_exit
    inc eax
    jmp get_player_kill_rank_loop

get_player_kill_rank_loop_exit:
    mov esp, ebp
    pop ebp
    retn