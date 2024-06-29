; para ejecutar:
; nasm main.asm -f elf64
; nasm configuracion.asm -f elf64
; nasm imprimir_tablero.asm -f elf64
; nasm ValidadoresMovimientos/turno_zorro.asm -f elf64
; gcc main.o configuracion.o imprimir_tablero.o -no-pie -o programa
; ./programa
global main
extern printf

extern config_jugadores, imprimir_tablero, entrada_zorro, oca_a_mover, busqueda_tablero

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

    msjGanadorZorro     db  'El ganador es el Zorro!',10,0; podemos poner el nombre del jugador sino

    posZorro            db '(%hi, %hi)',10,0

    ocasComidas         db  0
    posNueva            db  0
    posOcaComida1       db  0
    posOcaComida2       db  0
    desplazamiento      db  0

section .bss
    filaZorro           resb 1
    columnaZorro        resb 1

section .text
main:
    mov         rdi, msjBienvenida
    imprimir

    sub         rsp, 8
    call        config_jugadores
    add         rsp, 8

    sub         rsp, 8
    call        imprimir_tablero
    add         rsp, 8

turnoZorro:
    ;calculo el dezplazamiento para luego cambiar la posicion del zorro
    ;como tenemos dos tableros con distintos elementos lo calculo para ambos
    mov         bx, [filaZorro]
    dec         bx
    imul        bx, bx, 8
    mov         [desplazamiento], bx
    mov         bx, [columnaZorro]
    dec         bx
    add         [desplazamiento], bx

    ;ahora empieza el turno
    mov         rsi, [filaZorro]
    mov         rdx, [columnaZorro]
    sub         rdi, rdi
    lea         rdi, r15
    sub         rsp, 8
    call        entrada_zorro
    add         rsp, 8
    
    mov         [posNueva], rax
    mov         [filaZorro], rcx
    mov         [columnaZorro], rdx
    mov         [posOcaComida1], r8
    mov         [posOcaComida2], r9
    
    add         byte[ocasComidas], bl; si no comio nada  suma cero
    cmp         bl, 1
    je          manejoOcasComidas1
    cmp         bl, 2
    je          manejoOcasComidas2
continuar:
    ;cambio de posicion al zorro
    
    mov         ebx, [posNueva]
    
    movzx       ecx, bl
    sub         eax, eax
    mov         rax, 0
    add         rax, rcx
    mov         byte[r15 + rax], 2

    mov         ebx, [desplazamiento]
    movzx       ecx, bl
    sub         eax, eax
    mov         rax, 0
    add         rax, rcx
    mov         byte[r15 + rax], 0

    mostrar_tablero

    cmp         byte[ocasComidas], 12
    je          ganadorZorro

turnoOcas:
    ret

manejoOcasComidas1:
    mov         rbx, [posOcaComida1]
    movzx       ecx, bl
    sub         eax, eax
    mov         rax, [r15]
    add         rax, rcx
    mov         byte[rax], 0

manejoOcasComidas2:
    mov         rbx, [posOcaComida1]
    movzx       ecx, bl
    sub         eax, eax
    mov         rax, [r15]
    add         rax, rcx
    mov         byte[rax], 0
    
    mov         rbx, [posOcaComida2]
    movzx       ecx, bl
    sub         eax, eax
    mov         rax, [r15]
    add         rax, rcx
    mov         byte[rax], 0

ganadorZorro:
    mov         rdi, msjGanadorZorro
    imprimir
    ret