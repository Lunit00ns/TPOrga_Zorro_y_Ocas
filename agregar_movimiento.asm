global agregar_movimiento

section .data

section .text

; La función recibe la fila y columna de la posición a avanzar (r8 y r9),
; y calcula (en rdx) dónde agregar un movimiento en el array "movimientos" (en r12).


; r8 = fila posicion a avanzar
; r9 = columna posicion a avanzar
    
; rbx = fila zorro
; rcx = columna zorro

; 0 | 1 | 2
; 3 | Z | 4
; 5 | 6 | 7

; add byte[r12 + rdx], 1

agregar_movimiento:
    sub rsp, 8
    call pos_zorro
    add rsp, 8
    
verif_filas:
    cmp r8, rbx
    jl fila_menor
    je fila_igual
    jmp fila_mayor

fila_menor:
    mov rdx, 0
    cmp r9, rcx
    jl columna_menor
    je columna_igual
    jmp columna_mayor

fila_igual:
    mov rdx, 3
    cmp r9, rcx
    jl columna_menor
    jmp columna_igual

fila_mayor:
    mov rdx, 5
    cmp r9, rcx
    jl columna_menor
    je columna_igual
    jmp columna_mayor

columna_menor:
    jmp agregar
columna_igual:
    add rdx, 1
    jmp agregar
columna_mayor:
    add rdx, 2
    jmp agregar

agregar:
    add byte[r12 + rdx], 1
    ret