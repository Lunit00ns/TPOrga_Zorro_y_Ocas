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
    mov rsi, tablero2
    mov rdx, largo2
    syscall
%endmacro

section .data             
    msjBienvenida       db '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~',10 
                        db '| 🦊 Hola! Bienvenidos al juego del Zorro y las Ocas 🦢 |',10
                        db '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~',10,0 
    msjGanadorZorro     db  'El ganador es el Zorro!',10,0; podemos poner el nombre del jugador sino

    tablero2             db  ' ', ' ',' 1',' 2',' 3',' 4',' 5',' 6',' 7',' ',10,
                        db  ' ', '🟫','🟫','🟫','🟫','🟫','🟫','🟫','🟫','🟫',10, ; los emojis ocupan 4 bytes
                        db  '1', '🟫','🟫','🟫','🦢','🦢','🦢','🟫','🟫','🟫',10,
                        db  '2', '🟫','🟫','🟫','🦢','🦢','🦢','🟫','🟫','🟫',10,
                        db  '3', '🟫','🦢','🦢','🦢','🦢','🦢','🦢','🦢','🟫',10,
                        db  '4', '🟫','🦢','⬛','⬛','⬛','⬛','⬛','🦢','🟫',10,
                        db  '5', '🟫','🦢','⬛','⬛','🦊','⬛','⬛','🦢','🟫',10,
                        db  '6', '🟫','🟫','🟫','⬛','⬛','⬛','🟫','🟫','🟫',10,
                        db  '7', '🟫','🟫','🟫','⬛','⬛','⬛','🟫','🟫','🟫',10,
                        db  ' ', '🟫','🟫','🟫','🟫','🟫','🟫','🟫','🟫','🟫',10
    largo2              equ $- tablero2
         
     tablero            db  -1,-1, 1, 1, 1,-1,-1,
                        db  -1,-1, 1, 1, 1,-1,-1,
                        db   1, 1, 1, 1, 1, 1, 1,
                        db  1, 0, 0, 0, 0, 0, 1,
                        db   1, 0, 0, 2, 0, 0, 1,
                        db  -1,-1, 0, 0, 0,-1,-1,
                        db  -1,-1, 0, 0, 0,-1,-1,
    largo               equ $- tablero               
    filaZorro           db  5; fil y columna actual del zorro
    columnaZorro        db  4
    ocasComidas         db  0
    posNueva            db  0
    posOcaComida1       db  0
    posOcaComida2       db  0
    desplazamiento      db  0
    desplazamientotablero2      db  0
    posOca1tab2         db  0
    posOca2tab2         db  0
   
section .bss

section .text
main:
    mov         rdi,msjBienvenida
    imprimir

    sub         rsp,8
    call        config_jugadores
    add         rsp,8

turnoZorro:
    ;calculo el dezplazamiento para luego cambiar la posicion del zorro
    ;como tenemos dos tableros con distintos elementos lo calculo para ambos
    mov     bx,[filaZorro]
    dec     bx
    imul    bx,bx,7
    mov     [desplazamiento],bx

    mov     bx,[columnaZorro]
    dec     bx
    add     [desplazamiento],bx

    mov     bx,[filaZorro]
    dec     bx
    imul    bx,bx,44; el 10 cuenta como columna?
    mov     [desplazamientotablero2 ],bx

    mov     bx,[columnaZorro]
    imul    bx,bx,4
    dec     bx
    add     [desplazamientotablero2 ],bx    

    ;ahora empieza el turno
    mov         rsi,[filaZorro]
    mov         rdx, [columnaZorro]
    sub         rdi,rdi
    lea         rdi,tablero
    sub         rsp,8
    call        entrada_zorro
    add         rsp,8
    
    mov         [posNueva], rax
    mov         [filaZorro], rcx 
    mov         [columnaZorro], rdx
    mov         [posOcaComida1], r8
    mov         [posOcaComida2], r9
    mov         [posOca1tab2 ],r10
    mov         [posOca2tab2 ],r11
    
    add         byte[ocasComidas],bl; si no comio nada  suma cero
    cmp         bl,1
    je          manejoOcasComidas1
    cmp         bl,2
    je          manejoOcasComidas2
continuar:    
    ;cambio de posicion al zorro
    xor         rbx,rbx
    xor         rcx,rcx
    mov         ebx,[posNueva]
    movzx       ecx,bl 
    sub         eax,eax
    mov         rdx,[tablero]
    add         rdx,rcx
    mov         rax,rdx

    mov         byte[rax],2

    mov         ebx,[desplazamiento]
    movzx       ecx,bl 
    sub         eax,eax
    mov         rdx,[tablero]
    add         rdx,rcx
    mov         rax,rdx

    mov         byte[rax],0
    
    mov         ebx,[desplazamientotablero2]
    movzx       ecx,bl 
    sub         eax,eax
    mov         rax, [tablero2]
    add         rax,rcx
    mov         dword[rax],'⬛'
    
    mov         bx,[filaZorro]
    dec         bx
    imul        bx,bx,44
    mov         [desplazamientotablero2 ],bx

    mov         bx,[columnaZorro]
    dec         bx
    imul        bx,bx,4
    add         [desplazamientotablero2 ],bx
    
    mov         ebx,[desplazamientotablero2]
    movzx       ecx,bl 
    mov         rax,[tablero2]
    add         rax,rcx
    mov         dword[rax],'🦊'

    mostrar_tablero

    cmp     byte[ocasComidas],12
    je      ganadorZorro


turnoOcas:
    lea         rdi,tablero
    sub         rsp,8
    call        oca_a_mover
    add         rsp,8

    ret


manejoOcasComidas1:
    mov     rbx, [posOcaComida1]
    movzx   ecx, bl
    sub     eax,eax
    mov     rax,[tablero]
    add     rax,rcx
    mov     byte[rax], 0

    mov     rbx,[posOca1tab2]
    movzx   ecx, bl
    sub     eax,eax
    mov     rax,[tablero2]
    add     rax,rcx
    mov     dword[rax],'⬛'
    jmp     continuar
manejoOcasComidas2:
    mov     rbx, [posOcaComida1]
    movzx   ecx, bl
    sub     eax,eax
    mov     rax,[tablero]
    add     rax,rcx
    mov     byte[rax], 0

    mov     rbx,[posOca1tab2]
    movzx   ecx, bl
    sub     eax,eax
    mov     rax,[tablero2]
    add     rax,rcx
    mov     dword[rax],'⬛'
    
    mov     rbx, [posOcaComida2]
    movzx   ecx, bl
    sub     eax,eax
    mov     rax,[tablero]
    add     rax,rcx
    mov     byte[rax], 0

    mov     rbx,[posOca2tab2]
    movzx   ecx, bl
    sub     eax,eax
    mov     rax,[tablero2]
    add     rax,rcx
    mov     dword[rax],'⬛'
    jmp     continuar 

ganadorZorro:
    mov     rdi,msjGanadorZorro
    imprimir
    ret
