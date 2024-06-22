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
    
    tableroConPos       db  -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
                        db  -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
                        db  -1,-1,-1,-1,1,1,1,-1,-1,-1,-1,
                        db  -1,-1,-1,-1,1,1,1,-1,-1,-1,-1,
                        db  -1,-1,1,1,1,1,1,1,1,-1,-1,
                        db  -1,-1,1,0,0,0,0,0,1,-1,-1,
                        db  -1,-1,1,0,0,2,0,0,1,-1,-1,
                        db  -1,-1,-1,-1,0,0,0,-1,-1,-1,-1,
                        db  -1,-1,-1,-1,0,0,0,-1,-1,-1,-1,
                        db  -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
    filaZorro           db  5; fil y columna actual del zorro
    columnaZorro        db  4
    ocasComidas         db  0
section .bss

section .text
main:
    mov         rdi,msjBienvenida
    imprimir

    sub         rsp,8
    call        config_jugadores
    add         rsp,8

    mostrar_tablero
    mov         rsi,filaZorro
    mov         rbx,columnaZorro
    mov         rdx,tableroConPos
    
turnoZorro;
    sub         rsp,8
    call        entrada_zorro
    add         rsp,8

    add         [ocasComidas],rbx
    cmp         [ocasComidas],12
    je          ganoZorro     

    ;ahora pongo al zorro en su nueva posicion

    mov     filaZorro,rcx
    mov     columnaZorro,rdx

    sub     rdx,rdx
    mov     rdx,[tableroConPos + rax];posicion nueva del zorro

    mov     r8,filaZorro
    imul    r8,11

    mov     rdx,columnaZorro
    imul    rdx,1

    add     r8,rdx
    mov     rsi,[tableroConPos + r8]
    mov     [tableroConPos + r8],rdx
    mov     [tableroConPos + rax],rsi
turnoOca:
    sub         rsp,8
    call        oca_a_mover
    add         rsp,8
ganoZorro:


    ret