; --------------------------------------------------------
; nasm main.asm -f elf64
; nasm configuracion.asm -f elf64
; nasm verificarGanadores.asm -f elf64
; nasm finalizacion.asm -f elf64
; nasm funciones.asm -f elf64
; nasm Turnos/turno_zorro.asm -f elf64
; nasm Turnos/turno_oca.asm -f elf64
; gcc main.o configuracion.o verificarGanadores.o finalizacion.o funciones.o Turnos/turno_zorro.o Turnos/turno_oca.o -no-pie -o programa
; ./programa
; --------------------------------------------------------
global main, turno
extern printf,gets ,sscanf

extern config_jugadores, imprimir_tablero, pos_zorro, verificar_ganadores, entrada_zorro, oca_a_mover, gana_zorro, gana_oca,abandono, imprimir_estadisticas

%macro imprimir 0
    xor rax,rax
    sub rsp,8 
    call printf
    add rsp,8 
%endmacro

%macro leerInput 0
    sub rsp,8
    call gets
    add rsp,8
%endmacro

section .data
    msjBienvenida       db '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~',10
                        db '| 🦊 Hola! Bienvenidos al juego del Zorro y las Ocas 🦢 |',10
                        db '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~',10,0

    msInicio            db '¿Qué desea hacer?',10
                        db '1. Empezar una partida nueva',10
                        db '2. Cargar la última partida',10
                        db 'Opción: ',0
    msjError            db 'Opción inválida ✖️  Ingresá "1" para una partida nueva o "2" para cargar partida.',10,0

    msjOK               db  'TODO OK',10,0

    formatoOpcion       db  '%hi',0

    posNueva            db  0
    posOcaComida1       db  0
    desplazamiento      db  0
    turnoActual         db 'Z'

section .bss
    opcionInicio        resb 1  
    opcionValida        resb 1

section .text
main:
    mov         rdi, msjBienvenida
    imprimir

inicio:
    mov     rdi, msInicio
    imprimir
    mov		rdi,opcionInicio
	leerInput

    sub     rsp,8
    call    validar_opcion
    add     rsp,8

    cmp         byte [opcionValida], 'S'
    je          opcion_seleccionada

    mov         rdi, msjError
    imprimir

    jmp         inicio
    
validar_opcion:
    mov         byte[opcionValida],'N'

    mov         rdi,opcionInicio
    mov         rsi,formatoOpcion
    mov         rdx,opcionInicio
    
    sub		    rsp,8
	call	    sscanf
	add		    rsp,8    

    cmp         rax,1
    jne         invalido

    cmp         word[opcionInicio],1
    je          juego_nuevo
    cmp         word[opcionInicio],2
    je          cargar_partida

    mov         rdi, msjError
    imprimir

    jmp         inicio

opcion_seleccionada:
    mov         rdi,msjOK
    imprimir

cargar_partida: ; para hacer
    ret 
    
juego_nuevo:
    sub         rsp, 8
    call        config_jugadores

    call        imprimir_tablero
    add         rsp, 8

turno:
    mov         al, [turnoActual]
    cmp         al,'Z' 
    je          juego_zorro
    cmp         al,'O'
    je          juego_oca

juego_zorro: ; --> bucle principal del juego
    sub         rsp, 8
    call        entrada_zorro
    add         rsp, 8
    cmp         dil,'S';habria que ver si funciona
    je          finJuego        
    call        imprimir_tablero
    sub         rsp, 8
    call        imprimir_estadisticas
    add         rsp, 8
    
    mov         byte[turnoActual],'O'
    sub         rsp, 8
    call        verificar_ganadores
    add         rsp, 8
    cmp         rax,0
    jg          ganador_zorro
    jl          ganador_oca

juego_oca:
    sub         rsp, 8
    call        oca_a_mover
    add         rsp, 8
    cmp         dil,'S';habria que ver si funciona
    je          finJuego        
    call        imprimir_tablero
    mov         byte[turnoActual],'Z'
    sub         rsp, 8
    call        verificar_ganadores
    add         rsp, 8
    cmp         rax,0
    jg          ganador_zorro
    jl          ganador_oca
    jmp         turno

ganador_zorro:
    sub         rsp,8
    call        gana_zorro
    add         rsp,8
    ret

ganador_oca:
    sub         rsp,8
    call        gana_oca
    add         rsp,8
    ret

finJuego:
    sub         rsp,8
    call        abandono
    add         rsp,8

    mov         rax,60
    mov         rdi, 1
    syscall

invalido:
    ret