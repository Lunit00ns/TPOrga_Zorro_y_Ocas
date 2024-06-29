global posicion_zorro
global busqueda_tablero

extern printf
%macro imprimir 0
    sub rsp, 8 
    call printf
    add rsp, 8 
%endmacro

section .data
    cont_fila db 0
    cont_col db 0
    v_invalido db -2
    posZorro            db '(%hi, %hi)',10,0

section .bss

section .text

posicion_zorro:
    mov         rax, 9 ; n° de filas
    mov         rbx, 9 ; n° de columnas
    mov         rcx, 0 ; fila actual
    mov         rdx, 0 ; columna actual

loop_externo:
    mov         rdx, 0 ; reinicio columna actual

loop_interno:
    lea r8, [r15]
    cmp byte[r8], 2
    je zorro_encontrado
    
;   test print
    mov         rdi, posZorro
    mov         rsi, [cont_fila]
    mov         rdx, [cont_col]
    imprimir
;   test print

    inc r8
    add dword[cont_col], 1
    cmp byte[cont_col], 8
    je zorro_encontrado
    ;jg aum_fila
    jmp loop_interno

aum_fila:
     dword[cont_fila], 1
    mov byte[cont_col], 0
    jmp loop_interno

zorro_encontrado:
    ; en este punto rcx tiene la fila y rdx la columna donde está el zorro
    mov         cl, byte[rcx]  ; Guardar fila en cl (como un byte)
    mov         dl, byte[rdx]  ; Guardar columna en dl (como un byte)
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