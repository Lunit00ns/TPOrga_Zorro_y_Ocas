global busq_tablero

section .data
    fila db 0
    columna db 0

section .text

; Registros que utiliza:
; rax, rbx, rcx, rdx

; Parámetros: (2 posibles)
; 1) Si se desea buscar por desplazamiento, colocar un 0 en rax y el desplazamiento en rdx
; 2) Si se desea buscar por fil/col, colocar un 1 en rax (u otro valor distinto de cero),
; y colocar la fila / columna en rbx / rcx.

; Este archivo tiene como función devolver lo que se encuentre en cierta posición del tablero.
; (En caso de ser una posición no válida devuelve -1)

busq_tablero:
    ; En caso de querer buscar por índice, el rax debe estar vacío
    cmp rax, 0
    je busq_indice

busq_filcol:
    ; Reviso si la posición está dentro del tablero
    cmp rbx, 1
    jl invalido
    cmp rbx, 9
    jg invalido
    cmp rcx, 1
    jl invalido
    cmp rcx, 9
    jg invalido

    ; Cargo el tablero y realizo el desplazamiento
    lea rax, [r15] ; Cargo el tablero
    dec rbx
    imul rbx, rbx, 9
    add rax, rbx ; Desplazamiento de fila
    dec rcx
    add rax, rcx ; Desplazamiento de columna
    
verificar:
    ; Verifico qué tipo de valor es y lo cambio para poder devolverlo.
    cmp byte[rax], '-'
    je pared
    cmp byte[rax], ' '
    je fondo
    cmp byte[rax], 'O'
    je oca
    cmp byte[rax], 'X'
    je zorro
    jmp invalido

busq_indice:
    ; Reviso si la posición está dentro del tablero
    cmp rdx, 0
    jl invalido
    cmp rdx, 80
    jg invalido

    ; Cargo el tablero y sumo el desplazamiento
    lea rax, [r15]
    add rax, rdx
    jmp verificar

; Tipos de valores
invalido:
    mov rax, -1
    ret
pared:
    mov rax, '-'
    jmp devolver_valores
fondo:
    mov rax, ' '
    jmp devolver_valores
oca:
    mov rax, 'O'
    jmp devolver_valores
zorro:
    mov rax, 'X'
    jmp devolver_valores

devolver_valores:
    ret