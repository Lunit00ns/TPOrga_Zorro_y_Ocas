global main

extern busq_tablero, pos_zorro

section .data
    tablero db  '-','-','-','-','-','-','-','-','-',
            db  '-','-','-','O','O','O','-','-','-',
            db  '-','-','-','O','O','O','-','-','-',
            db  '-','O','O','O','O','O','O','O','-',
            db  '-','O',' ','O','O','O',' ','O','-',
            db  '-','O',' ','O','X','O','O','O','-',
            db  '-','-','-','O','O','O','-','-','-',
            db  '-','-','-',' ','O',' ','-','-','-',
            db  '-','-','-','-','-','-','-','-','-'
    m_estancado db "Estancado", 10
    l_estancado equ $ - m_estancado
    m_posible db "Movimiento posible", 10
    l_posible equ $ - m_posible
section .text

main:
    ; Establezco el tablero y obtengo la posición del zorro (fila 6, columna 5)
    mov r15, tablero
    sub rsp, 8
    call pos_zorro
    add rsp, 8

verif_area:
    ; Me muevo a la casilla superior izquierda desde la posición del zorro
    
    ;Acá
    ; X | - | -
    ; - | Z | -
    ; - | - | -
    
    ; para poder verificar los 8 cuadrados alrededor del zorro.

    mov r8, 0
    mov r9, 0
    dec rbx
    dec rcx
buc_verif_area:
    call verif_casilla
    cmp rax, ' ' ; En caso de haber encontrado un espacio libre
    je movimiento_posible
    
    inc rcx ; Me muevo a la siguiente casilla
    inc r8
    cmp r8, 2
    jg aum_fila
    jmp buc_verif_area
aum_fila:
    inc rbx
    inc r9
    cmp r9, 2
    jg verif_saltos ; En caso de no haber encontrado espacios vacíos
    sub rcx, 3
    sub r8, 3
    jmp buc_verif_area

verif_casilla:
    mov rdx, 0 ; Parámetro de busq_tablero
    mov rax, 1 ; Parámetro de busq_tablero
    ; Al hacer esto, busco en el tablero utilizando la fila y columna
    ; (rbx y rcx) en vez de un desplazamiento (rdx)
    
    call busq_tablero
    
    ; Imprimo los valores sólo para verificar si detecta bien cada casilla
    ; (cosa de que no funciona jaja)
    mov [rsi], rax
    mov rax, 1
    mov rdi, 1
    mov rdx, 1
    syscall
    
    ret

verif_saltos:
    ; En caso de haber llegado hasta acá, faltaría verificar si el zorro
    ; puede escapar comiendo alguna oca.
    sub rsp, 8
    call pos_zorro
    add rsp, 8

    ; Casilla de arriba
    sub rbx, 2
    call verif_casilla
    cmp rax, ' '
    je movimiento_posible
    add rbx, 2

    ; Casilla de la derecha
    add rcx, 2
    call verif_casilla
    cmp rax, ' '
    je movimiento_posible
    sub rcx, 2

    ; Casilla de abajo
    add rbx, 2
    call verif_casilla
    cmp rax, ' '
    je movimiento_posible
    sub rbx, 2

    ; Casilla de la izquierda
    sub rcx, 2
    call verif_casilla
    cmp rax, ' '
    je movimiento_posible
    add rcx, 2

    ; Habiendo verificado todo, el zorro está estancado
    jmp estancado

movimiento_posible:
    ; Acá muestro un mensaje, pero podría devolver un 0 o -1 dependiendo
    ; de si el zorro está estancado o no
    
    ;mov rax, 0
    mov rax, 1
    mov rdi, 1
    mov rsi, m_posible
    mov rdx, l_posible
    syscall
    ret

estancado:
    ; Acá muestro un mensaje, pero podría devolver un 0 o -1 dependiendo
    ; de si el zorro está estancado o no
    
    ;mov rax, -1
    mov rax, 1
    mov rdi, 1
    mov rsi, m_estancado
    mov rdx, l_estancado
    syscall
    ret