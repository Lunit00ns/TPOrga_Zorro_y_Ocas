global contar_ocas

section .data
section .text

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
    jge terminar
    
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

terminar:
    ret