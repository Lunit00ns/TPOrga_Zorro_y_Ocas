global main, turno
extern printf,gets ,sscanf

global turnoActual

extern config_jugadores
extern imprimir_tablero
extern pos_zorro
extern verificar_ganadores
extern entrada_zorro
extern oca_a_mover
extern gana_zorro
extern gana_oca,abandono
extern imprimir_estadisticas
extern guardar
extern cargar

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
    msjError            db 'Opción inválida ✖️ Ingresá "1" para empezar una partida nueva o "2" para cargar la última partida guardada.',10,0

    formatoOpcion       db  '%hi',0

    turnoActual         db 'Z'

section .bss
    opcionInicio        resb 1  

section .text
main:
    mov         rdi, msjBienvenida
    imprimir

inicio:
    mov     rdi, msInicio
    imprimir
    mov		rdi,opcionInicio
	leerInput
    
validar_opcion:
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

cargar_partida:
    sub         rsp,8
    call        cargar

    call        imprimir_tablero
    add         rsp, 8

    jmp         turno
    
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

juego_zorro: 
    sub         rsp, 8
    call        entrada_zorro
    add         rsp, 8
    cmp         dil,'S'
    je          finJuego        
    call        imprimir_tablero
    
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
    cmp         dil,'S'
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

    mov         rax,60
    mov         rdi, 1
    syscall

ganador_oca:
    sub         rsp,8
    call        gana_oca
    add         rsp,8

    mov         rax,60
    mov         rdi, 1
    syscall

finJuego:
    sub         rsp,8
    call        abandono
    add         rsp,8

    sub         rsp, 8
    call        guardar
    add         rsp, 8

    mov         rax,60
    mov         rdi, 1
    syscall

invalido:
    mov         rdi, msjError
    imprimir

    jmp         inicio