global pos_zorro

section .data

section .text

pos_zorro:
    mov rcx, 1
    mov rbx, 1
    
    lea rax, [r15]

bucle:
    cmp byte[rax], 'X'
    je encontrado
    inc rax

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
