;%include "funciones.asm"

global gana_oca, gana_zorro,abandono

extern printf

%macro imprimir 0
   xor rax,rax
   sub rsp,8 
   call printf
   add rsp,8 
%endmacro

section .data
    msjGanadorZorro     db  '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~',10
                        db  '|       Gana el Zorro %s       |',10
                        db  '| El Zorro logró comer 12 Ocas |',10
                        db  '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~',10,0

    msjGanadorOcas      db  '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~',10
                        db  '|       Ganan las Ocas %s       |',10
                        db  '| Las Ocas acorralaron al Zorro |',10
                        db  '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~',10,0

    msAbandono          db  'Abandonaste la partida 😢',10,0

    cantMovRectos       db '----- Estadísiticas de movimientos del zorro -----',10
                        db '- Movimientos rectos:',10
                        db '    Arriba - %d',10
                        db '    Derecha - %d',10
                        db '    Abajo - %d',10
                        db '    Izquierda - %d',10,0

    cantMovDiagonales   db '- Movimientos diagonales:',10
                        db '    Arriba-Derecha - %d',10
                        db '    Abajo-Derecha - %d',10
                        db '    Abajo-Izquierda - %d',10
                        db '    Arriba-Izquierda - %d',10,0

section .bss
section .text

gana_zorro:
    mov     rdi, msjGanadorZorro
    mov     rsi, [r13]
    imprimir
    call    imprimir_estadisticas

gana_oca:
    mov     rdi, msjGanadorOcas
    mov     rsi, [r14]
    imprimir
    call    imprimir_estadisticas

abandono:
    mov     rdi,msAbandono
    imprimir
    ret

imprimir_estadisticas:
    mov rdi, cantMovRectos
    movzx rsi, byte [r12 + 0]   ; Arriba
    movzx rdx, byte [r12 + 2]   ; Derecha
    movzx rcx, byte [r12 + 4]   ; Abajo
    movzx r8, byte [r12 + 6]    ; Izquierda
    imprimir

    mov rdi, cantMovDiagonales
    movzx rsi, byte [r12 + 1]   ; Arriba-Derecha
    movzx rdx, byte [r12 + 3]   ; Abajo-Derecha
    movzx rcx, byte [r12 + 5]   ; Abajo-Izquierda
    movzx r8, byte [r12 + 7]    ; Arriba-Izquierda
    imprimir

    ret