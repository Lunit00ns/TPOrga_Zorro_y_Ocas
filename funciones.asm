;global funciones ; %include "funciones.asm" para usar las macros

global pos_zorro
global busq_tablero
global contar_ocas
global agregar_movimiento
global imprimir_tablero

%macro imprimir 0
    xor rax,rax
    sub rsp,8 
    call printf
    add rsp,8 
%endmacro

%macro leerInput 1
    mov rdi, %1
    sub rsp,8
    call gets
    add rsp,8
%endmacro

section .data
    numeros db " 0", " 1", " 2", " 3", " 4", " 5", " 6", " 7", " 8", " 9", 10
    largo_numeros equ $ - numeros
    pared   dw '🟫'
    fondo   dw '⬛'
    espaciado db 10

section .text

; --------------- Función posición zorro ---------------
; Registros que utiliza:
; rax, rbx, rcx

; Parámetros:
; Ninguno

; La función devuelve la posición del zorro en fila/columna (rbx y rcx), o
; -1 en ambos registros si es que no encuentra al zorro (cosa que no puede pasar).

pos_zorro:
    mov rcx, 1
    mov rbx, 1
    lea rax, [r15]

bucle_pos_zorro:
    cmp byte[rax], 'X'
    je encontrado
    inc rax

    inc rcx
    cmp rcx, 10
    je cambio_fila

    jmp bucle_pos_zorro

cambio_fila:
    inc rbx
    cmp rbx, 10
    je no_encontrado

    mov rcx, 1
    jmp bucle_pos_zorro

no_encontrado:
    mov rbx, -1
    mov rcx, -1
    ret

encontrado:
    ret


; --------------- Función búsqueda tablero ---------------
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
    jl valor_invalido
    cmp rbx, 9
    jg valor_invalido
    cmp rcx, 1
    jl valor_invalido
    cmp rcx, 9
    jg valor_invalido

    ; Cargo el tablero y realizo el desplazamiento
    lea rax, [r15] ; Cargo el tablero
    dec rbx
    imul rbx, rbx, 9
    add rax, rbx ; Desplazamiento de fila
    dec rcx
    add rax, rcx ; Desplazamiento de columna
    
verificar_valor:
    ; Verifico qué tipo de valor es y lo cambio para poder devolverlo.
    cmp byte[rax], '-'
    je valor_pared
    cmp byte[rax], ' '
    je valor_fondo
    cmp byte[rax], 'O'
    je valor_oca
    cmp byte[rax], 'X'
    je valor_zorro
    jmp valor_invalido

busq_indice:
    ; Reviso si la posición está dentro del tablero
    cmp rdx, 0
    jl valor_invalido
    cmp rdx, 80
    jg valor_invalido

    ; Cargo el tablero y sumo el desplazamiento
    lea rax, [r15]
    add rax, rdx
    jmp verificar_valor

; Tipos de valores
valor_invalido:
    mov rax, -1
    ret
valor_pared:
    mov rax, '-'
    jmp devolver_valores
valor_fondo:
    mov rax, ' '
    jmp devolver_valores
valor_oca:
    mov rax, 'O'
    jmp devolver_valores
valor_zorro:
    mov rax, 'X'
    jmp devolver_valores

devolver_valores:
    ret


; --------------- Función contar ocas ---------------
; Registros que utiliza:
; rax, rbx, rcx

; Parámetros:
; ninguno

; La función cuenta la cantidad de ocas que hay en el tablero y lo almacena en rcx

contar_ocas:
    mov rcx, 0
    mov rbx, 0
    lea rax, [r15]

bucle_contar:
    cmp rbx, 80
    jge terminar_ocas
    
    cmp byte[rax], 'O'
    je sumar

    inc rax
    inc rbx
    jmp bucle_contar

sumar:
    inc rcx
    inc rax
    inc rbx
    jmp bucle_contar

terminar_ocas:
    ret


; --------------- Función agregar movimientos ---------------
; Registros que utiliza:
; rbx, rcx, r8, r9

; Parámetros:
; r8 y r9: fila y columna de la posición a moverse.

; La función recibe la fila y columna de la posición a avanzar (r8 y r9),
; busca la posición del zorro para compararar, y calcula (en rdx)
; dónde agregar un movimiento en el array "movimientos" (en r12).


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
    jmp agregar_valor
columna_igual:
    add rdx, 1
    jmp agregar_valor
columna_mayor:
    add rdx, 2
    jmp agregar_valor

agregar_valor:
    add byte[r12 + rdx], 1
    ret


; --------------- Función imprimir tablero ---------------
; Registros que utiliza:
; rax, rbx, rdx, r8, r9

; Parámetros:
; Ninguno

; La función imprime el tablero por la terminal.

imprimir_tablero:
    lea rbx, [numeros + 2] ; Numeros
    mov r9, 81          ; Cantidad de elementos
    lea r8, [r15]       ; Cargo el tablero
    
    mov rax, 1
    mov rdi, 1
    mov rsi, numeros
    mov rdx, largo_numeros
    syscall

agregar_num:
    mov rax, 1
    mov rdi, 1
    mov rsi, rbx
    mov rdx, 2
    syscall

    add rbx, 2

loop_imprimir:
    cmp r9, 0
    je terminar_imprimir

    ; Condiciones de Emojis
    cmp byte[r8], '-'
    je em_pared
    cmp byte[r8], ' '
    je em_fondo
    cmp byte[r8], 'O'
    je em_oca
    cmp byte[r8], 'X'
    je em_zorro
    ; En caso de no coincidir con ningún número, habría que
    ; agregar un caso de "Excepción" (No sé si puede suceder).

loop_imprimir_fin:
    dec r9 ; Decremento el largo
    inc r8 ; Avanzo al siguiente elemento del tablero
    
    ; Para agregar los \n al final de cada línea
    cmp r9, 9
    je prnt_espaciado
    cmp r9, 18
    je prnt_espaciado
    cmp r9, 27
    je prnt_espaciado
    cmp r9, 36
    je prnt_espaciado
    cmp r9, 45
    je prnt_espaciado
    cmp r9, 54
    je prnt_espaciado
    cmp r9, 63
    je prnt_espaciado
    cmp r9, 72
    je prnt_espaciado
    cmp r9, 81
    je prnt_espaciado

    cmp r9, 0
    jg loop_imprimir ; En caso de no haber iterado todos los elementos
    jmp terminar_imprimir ; En caso de que sí

; Emojis
em_pared:
    mov rax, 1
    mov rdi, 1
    mov rsi, pared
    mov rdx, 4
    syscall
    jmp loop_imprimir_fin
em_fondo:
    mov rax, 1
    mov rdi, 1
    mov rsi, fondo
    mov rdx, 4
    syscall
    jmp loop_imprimir_fin
em_oca:
    mov rax, 1
    mov rdi, 1
    mov rsi, r14
    mov rdx, 4
    syscall
    jmp loop_imprimir_fin
em_zorro:
    mov rax, 1
    mov rdi, 1
    mov rsi, r13
    mov rdx, 4
    syscall
    jmp loop_imprimir_fin

prnt_espaciado:
    ; Agrego un \n al final
    mov rax, 1
    mov rdi, 1
    mov rsi, espaciado
    mov rdx, 1
    syscall

    jmp agregar_num

terminar_imprimir:
    ; Agrego un \n al final
    mov rax, 1
    mov rdi, 1
    mov rsi, espaciado
    mov rdx, 1
    syscall
    
    ret