; The name of the costumes definition file.
costumes_definitions_file:
    db "data/Item/DualLayerClothes.SData", 0

; The message to display if costume definitions aren't found.
costumes_not_found_message:
    db "DualLayerClothes.SData was not found.", 0

; Load the costumes definitions.
load_costume_definitions:
    push ebp
    mov ebp, esp

    ; Load the definition file.
    push costumes_definitions_file
    call read_file
    test eax, eax
    je costumes_not_found
    jmp costumes_exit

costumes_not_found:
    push costumes_not_found_message
    call exit_with_message
costumes_exit:
    mov esp, ebp
    pop ebp
    retn