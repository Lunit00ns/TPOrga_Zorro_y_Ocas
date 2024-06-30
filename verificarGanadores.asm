global verificar_ganadores

extern  pos_zorro, contar_ocas, busq_tablero


section .data
    msjInputOK          db "Casilla ingresada correctamente!",0xA,0
    ocasComidas         db  0
    zorro               db  0
    contador_apariciones    db 0
    
section .bss
section .text
verificar_ganadores:

verif_perdio_ocas:
    sub     rsp, 8
    call    contar_ocas   ;rcx
    add     rsp, 8
    cmp     rcx,5
    jle     gano_zorro ;   rcx <= 5

verif_perdio_zorro:
    call pos_zorro
    dec rbx
    dec rcx
    call busq_tablero
    cmp rax, ' '
    je movimiento_posible

    call pos_zorro
    dec rbx
    call busq_tablero
    cmp rax, ' '
    je movimiento_posible

    call pos_zorro
    dec rbx
    inc rcx
    call busq_tablero
    cmp rax, ' '
    je movimiento_posible
    ; ----
    call pos_zorro
    dec rcx
    call busq_tablero
    cmp rax, ' '
    je movimiento_posible


    call pos_zorro
    inc rcx
    call busq_tablero
    cmp rax, ' '
    je movimiento_posible
    ; ----
    call pos_zorro
    inc rbx
    dec rcx
    call busq_tablero
    cmp rax, ' '
    je movimiento_posible

    call pos_zorro
    inc rbx
    call busq_tablero
    cmp rax, ' '
    je movimiento_posible

    call pos_zorro
    inc rbx
    inc rcx
    call busq_tablero
    cmp rax, ' '
    je movimiento_posible

verif_salto1:
    call pos_zorro
    dec rbx
    call busq_tablero
    cmp rax, 'O'
    je verif_arriba
verif_salto2:
    call pos_zorro
    dec rcx
    call busq_tablero
    cmp rax, 'O'
    je verif_izquierda
verif_salto3:
    call pos_zorro
    inc rcx
    call busq_tablero
    cmp rax, 'O'
    je verif_derecha
verif_salto4:
    call pos_zorro
    inc rbx
    call busq_tablero
    cmp rax, 'O'
    je verif_abajo

    jmp ganaron_ocas

verif_arriba:
    call pos_zorro
    dec rbx
    dec rbx
    call busq_tablero
    cmp rax, ' '
    je movimiento_posible
    jmp verif_salto2
verif_izquierda:
    call pos_zorro
    dec rcx
    dec rcx
    call busq_tablero
    cmp rax, ' '
    je movimiento_posible
    jmp verif_salto3
verif_derecha:
    call pos_zorro
    inc rcx
    inc rcx
    call busq_tablero
    cmp rax, ' '
    je movimiento_posible
    jmp verif_salto4
verif_abajo:
    call pos_zorro
    inc rbx
    inc rbx
    call busq_tablero
    cmp rax, ' '
    je movimiento_posible
    jmp ganaron_ocas

gano_zorro:
    mov rax, 1
    ret

movimiento_posible:
    mov rax, 0
    ret

ganaron_ocas:
    mov rax, -1
    ret