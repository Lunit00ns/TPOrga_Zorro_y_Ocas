; para ejecutar:
; nasm main.asm -f elf64
; nasm configuracion.asm -f elf64
; nasm imprimir_tablero.asm -f elf64
; nasm posiciones.asm -f elf64
; nasm Turnos/turno_zorro.asm -f elf64
; gcc main.o configuracion.o imprimir_tablero.o posiciones.o Turnos/turno_zorro.o -no-pie -o programa
; ./programa
global main
extern printf

extern config_jugadores, imprimir_tablero, pos_zorro,vericar_ganadores, entrada_zorro,oca_a_mover

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
    jugadorZorro        resb 256
    jugadorOca          resb 256

section .text
main:
    mov         rdi, msjBienvenida
    imprimir

    sub         rsp, 8
    call        config_jugadores

    mov         [jugadorZorro], rsi  
    mov         [jugadorOca], rdi

    mov         rdi,msjSalir
    call        imprimir_tablero
    add         rsp, 8


juego_zorro: ; --> bucle principal del juego
    sub         rsp, 8
    call        entrada_zorro
    add         rsp, 8
    cmp         rdi,'S';habria que ver si funciona
    je          finJuego        
    call        imprimir_tablero
finJuego:    
    ret
    ; chequeo si terminó el juego, ya sea porque el zorro no
    ; tiene más movimientos, o porque el zorro comió 12 ocas
;     sub         rsp, 8
;     call        vericar_ganadores
;     add         rsp, 8

;     ; si no termino, guardo la partida y sigue el turno de la oca
;     mov         [turnoActual], 'O'

; juego_oca:
;     sub         rsp, 8
;     call        turnoOca
;     add         rsp, 8

;     ; de vuelta chequeo si terminó el juego. Si no terminó,
;     ; guardo la partida y arranco de vuelta.
;     sub         rsp, 8
;     call        vericar_ganadores
;     add         rsp, 8

;     mov         [turnoActual], 'Z'

;     jmp         juego_zorro


    
    
