; para ejecutar:
; nasm main.asm -f elf64
; nasm configuracion.asm -f elf64
; nasm imprimir_tablero.asm -f elf64
; nasm posiciones.asm -f elf64
; nasm verificarGanadores.asm -f elf64
; nasm finalizacion.asm -felf64
; nasm verificar_zorro.asm -f elf64
; nasm busq_tablero.arm -f elf64
; nasm contar_ocas.asm -f elf64
; nasm Turnos/turno_zorro.asm -f elf64
; nasm Turnos/turno_oca.asm -f elf64
; gcc main.o configuracion.o imprimir_tablero.o posiciones.o verificarGanadores.o finalizacion.o Turnos/turno_zorro.o Turnos/turno_oca.o contar_ocas.o busq_tablero.o -no-pie -o programa
; ./programa
;% include "funciones.asm"

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

global main, turno
extern printf

extern config_jugadores, imprimir_tablero, pos_zorro, verificar_ganadores, entrada_zorro, oca_a_mover, gana_zorro, gana_oca,abandono

%macro imprimir 0
    xor rax,rax
    sub rsp,8 
    call printf
    add rsp,8 
%endmacro

section .data
    msjBienvenida       db '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~',10
                        db '| 🦊 Hola! Bienvenidos al juego del Zorro y las Ocas 🦢 |',10
                        db '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~',10,0

    posNueva            db  0
    posOcaComida1       db  0
    desplazamiento      db  0
    turnoActual         db 'Z'
    msjSalir            db 'Cuando sea tu turno seleccione S para salir del juego'; esto luego lo ponemos lindo

    
section .bss

section .text
main:
    mov         rdi, msjBienvenida
    imprimir

    sub         rsp, 8
    call        config_jugadores

    mov         rdi,msjSalir
    call        imprimir_tablero
    add         rsp, 8

turno:
    mov al, [turnoActual]
    cmp     al,'Z' 
    je      juego_zorro
    cmp     al,'O'
    je    juego_oca


juego_zorro: ; --> bucle principal del juego
    sub         rsp, 8
    call        entrada_zorro
    add         rsp, 8
    cmp         dil,'S';habria que ver si funciona
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
    sub     rsp,8
    call    abandono
    add     rsp,8
    ret