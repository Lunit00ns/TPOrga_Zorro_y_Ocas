; para ejecutar:
; nasm main.asm -f elf64
; nasm personalizacion_partida.asm -f elf64
; nasm ValidadoresMovimientos/turno_zorro.asm -f elf64
; gcc main.o personalizacion_partida.o ValidadoresMovimientos/turno_zorro.o -no-pie -o programa
; ./programa

global main
extern printf

extern config_jugadores, entrada_zorro

%macro imprimir 0
    sub rsp,8 
    call printf
    add rsp,8 
%endmacro

%macro mostrar_tablero 0
    mov rax, 1
    mov rdi, 1
    mov rsi, tablero
    mov rdx, largo
    syscall
%endmacro

section .data             
    msjBienvenida       db '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~',10 
                        db '| 🦊 Hola! Bienvenidos al juego del Zorro y las Ocas 🦢 |',10
                        db '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~',10,0 

    tablero             db  ' ', ' ',' 1',' 2',' 3',' 4',' 5',' 6',' 7',' ',10,
                        db  ' ', '🟫','🟫','🟫','🟫','🟫','🟫','🟫','🟫','🟫',10, ; los emojis ocupan 4 bytes
                        db  '1', '🟫','🟫','🟫','🦢','🦢','🦢','🟫','🟫','🟫',10,
                        db  '2', '🟫','🟫','🟫','🦢','🦢','🦢','🟫','🟫','🟫',10,
                        db  '3', '🟫','🦢','🦢','🦢','🦢','🦢','🦢','🦢','🟫',10,
                        db  '4', '🟫','🦢','⬛','⬛','⬛','⬛','⬛','🦢','🟫',10,
                        db  '5', '🟫','🦢','⬛','⬛','🦊','⬛','⬛','🦢','🟫',10,
                        db  '6', '🟫','🟫','🟫','⬛','⬛','⬛','🟫','🟫','🟫',10,
                        db  '7', '🟫','🟫','🟫','⬛','⬛','⬛','🟫','🟫','🟫',10,
                        db  ' ', '🟫','🟫','🟫','🟫','🟫','🟫','🟫','🟫','🟫',10
    largo               equ $- tablero

section .bss

section .text
main:
    mov         rdi,msjBienvenida
    imprimir

    sub         rsp,8
    call        config_jugadores
    add         rsp,8

    mostrar_tablero

    sub         rsp,8
    call        entrada_zorro
    add         rsp,8

    ret