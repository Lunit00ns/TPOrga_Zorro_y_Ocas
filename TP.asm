global main
extern printf
extern puts
extern gets

section .data
    mensajeBienvenida   db      'Hola bienbenidos al juego del Zorro y las Ocas',0
    mensajeTurnoZorro   db      'Turno jugagor zorro',0
    mensajeJugador2     db      'Turno jugagor ocas',0
    
    
    ;matriz times 49 resb 1 ;matriz de 7 X 7 de un char que ocupa 1 bytes
    matriz  dd '*','*','O','O','O','*','*'
            dd '*','*','O','O','O','*','*'
            dd 'O','O','O','O','O','O','O'
            dd 'O','#','#','#','#','#','O'
            dd 'O','#','#','X','#','#','O'
            dd '*','*','#','#','#','*','*'
            dd '*','*','#','#','#','*','*'
    longElem    dd  1
    longFila    dd  7
section .bss
    moviento resb 50

section .text
main:
    ;mostar bienvenida
    mov         rdi,mensajeBienvenida
    sub         rsp,8
    call        puts
    add         rsp,8	

    ;logica de un zorro
    mov         rdi,mensajeTurnoZorro
    sub         rsp,8
    call        puts
    add         rsp,8	

    ;pedir movimiento
    mov		rdi,moviento	
	sub		rsp,8	
    call    gets    
	add		rsp,8
    ;validar entrada
    sub     rsp,8
    call    validarZorro
    add     rsp,8




ret ;FIN DE PROGRAMA
;*********************************
; RUTINAS INTERNAS
;*********************************
validarZorro:





ret