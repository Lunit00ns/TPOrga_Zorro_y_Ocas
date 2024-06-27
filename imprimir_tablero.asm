; Este archivo lo probé sólo. No está conectado a ningún otro archivo.
global main ; <- Cambiar "main" en caso de conectarlo con un archivo

section .data
    tablero db  -1,-1, 1, 1, 1,-1,-1,
            db  -1,-1, 1, 1, 1,-1,-1,
            db   1, 1, 1, 1, 1, 1, 1,
            db   1, 0, 0, 0, 0, 0, 1,
            db   1, 0, 0, 2, 0, 0, 1,
            db  -1,-1, 0, 0, 0,-1,-1,
            db  -1,-1, 0, 0, 0,-1,-1
    largo_tablero equ $- tablero

    pared   dw '🟫'
    largo_pared equ $- pared
    fondo   dw '⬛'
    largo_fondo equ $- fondo
    oca     dw '🦢'
    largo_oca equ $- oca
    zorro   dw '🦊'
    largo_zorro equ $- zorro
    
    espaciado db 10

section .text

main: ; <- Cambiar "main" en caso de conectarlo con un archivo
    mov r9, largo_tablero ; Cantidad de elementos
    lea r8, [tablero] ; Cargo el tablero

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
    cmp r9, 7
    je prnt_espaciado
    cmp r9, 14
    je prnt_espaciado
    cmp r9, 21
    je prnt_espaciado
    cmp r9, 28
    je prnt_espaciado
    cmp r9, 35
    je prnt_espaciado
    cmp r9, 42
    je prnt_espaciado
    cmp r9, 49
    je prnt_espaciado

    cmp r9, 0
    jg loop_start ; En caso de no haber iterado todos los elementos
    jmp terminar ; En caso de que sí

; --------- Emojis -----------
em_pared:
    mov rax, 1
    mov rdi, 1
    mov rsi, pared
    mov rdx, largo_pared
    syscall
    jmp loop_end
em_fondo:
    mov rax, 1
    mov rdi, 1
    mov rsi, fondo
    mov rdx, largo_fondo
    syscall
    jmp loop_end
em_oca:
    mov rax, 1
    mov rdi, 1
    mov rsi, oca
    mov rdx, largo_oca
    syscall
    jmp loop_end
em_zorro:
    mov rax, 1
    mov rdi, 1
    mov rsi, zorro
    mov rdx, largo_zorro
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

    jmp loop_start

terminar:
    ; ---- Agrego un \n al final ----
    mov rax, 1
    mov rdi, 1
    mov rsi, espaciado
    mov rdx, 1
    syscall
    
    ; ---- Esto termina el programa ----
    mov rax, 60
    xor rdi, rdi
    syscall