global pos_zorro

section .data
    v_invalido db -2

section .text

pos_zorro:
    mov rcx, 1
    mov rbx, 1
    
    lea r8, [r15]

bucle:
    cmp byte[r8], 'X'
    je encontrado
    inc r8

    inc rcx
    cmp rcx, 10
    je cambio_fila

    jmp bucle

cambio_fila:
    inc rbx

    cmp rbx, 10
    je no_encontrado

    mov rcx, 1
    jmp bucle

no_encontrado:
    mov rbx, -1
    mov rcx, -1
    
    ret

encontrado:
    ret

busqueda_tablero:
    ; rbx fila
    ; rcx columna
    cmp rbx, 1
    jl invalido
    cmp rcx, 1
    jl invalido

    cmp rbx, 9
    jg invalido
    cmp rcx, 9
    jg invalido

    lea rax, [r15] ; Cargo el tablero
    dec rbx
    imul rbx, 9
    add rax, rbx ; Desplazamiento de fila
    dec rcx
    add rax, rcx ; Desplazamiento de columna
    ret

invalido:
    xor rax, rax ; En caso de coordenadas no válidas, devuelve -2
    lea rax, [v_invalido]
    ret