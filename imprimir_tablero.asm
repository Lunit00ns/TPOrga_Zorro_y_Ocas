global imprimir_tablero 

section .data
    fila    db " 0", " 1", " 2", " 3", " 4", " 5", " 6", " 7", " 8", " 9", 10
    largo_fila equ $ - fila
    pared   dw '🟫'
    fondo   dw '⬛'
    
    espaciado db 10

section .text

imprimir_tablero:
    lea rbx, [fila + 2] ; Aux de filas
    mov r9, 81      ; Cantidad de elementos
    lea r8, [r15]   ; Cargo el tablero
    
    mov rax, 1
    mov rdi, 1
    mov rsi, fila
    mov rdx, largo_fila
    syscall

agregar_num:
    mov rax, 1
    mov rdi, 1
    mov rsi, rbx ; donde está "rbx" antes estaba 
    mov rdx, 2
    syscall

    add rbx, 2

loop_start:
    cmp r9, 0
    je terminar

    ; ---- Condiciones de Emojis ----
    cmp byte[r8], -1
    je em_pared
    cmp byte[r8], 0
    je em_fondo
    cmp byte[r8], 1
    je em_oca
    cmp byte[r8], 2
    je em_zorro
    ; En caso de no coincidir con ningún número, habría que
    ; agregar un caso de "Excepción" (No sé si puede suceder).

loop_end:
    dec r9 ; Decremento el largo
    inc r8 ; Avanzo al siguiente elemento del tablero
    
    ; ---- Para agregar los \n al final de cada línea ----
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
    jg loop_start   ; En caso de no haber iterado todos los elementos
    jmp terminar    ; En caso de que sí

; --------- Emojis -----------
em_pared:
    mov rax, 1
    mov rdi, 1
    mov rsi, pared
    mov rdx, 4
    syscall
    jmp loop_end
em_fondo:
    mov rax, 1
    mov rdi, 1
    mov rsi, fondo
    mov rdx, 4
    syscall
    jmp loop_end
em_oca:
    mov rax, 1
    mov rdi, 1
    mov rsi, r14
    mov rdx, 4
    syscall
    jmp loop_end
em_zorro:
    mov rax, 1
    mov rdi, 1
    mov rsi, r13
    mov rdx, 4
    syscall
    jmp loop_end
; ----------------------------

prnt_espaciado:
    ; ---- Agrego un \n al final ----
    mov rax, 1
    mov rdi, 1
    mov rsi, espaciado
    mov rdx, 1
    syscall

    jmp agregar_num

terminar:
    ; ---- Agrego un \n al final ----
    mov rax, 1
    mov rdi, 1
    mov rsi, espaciado
    mov rdx, 1
    syscall