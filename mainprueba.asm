section .text
main:
    mov         rdi, msjBienvenida
    imprimir

    sub         rsp, 8
    call        config_jugadores

    call        imprimir_tablero
    add         rsp, 8

    sub         rsp, 8
    call        guardar
    add         rsp, 8

    ret