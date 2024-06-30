global  gano_Oca, gano_Zorro

extern printf

%macro imprimir 0
    xor rax,rax
    sub rsp,8 
    call printf
    add rsp,8 
%endmacro

section .data
    msjGanadorZorro     db  '¡Gana %s! El Zorro logró comer 12 Ocas.',10,0
    msjGanadorOcas      db  '¡Gana %s! Las Ocas acorralaron al Zorro.',10,0

    cantMovRectos       db '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~',10
                        db '| Estadísiticas de movimientos |',10
                        db '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~',10
                        db '- Movimientos rectos: Arriba - %d | Derecha - %d | Abajo - %d | Izquierda - %d',10,0
    cantMovDiagonales   db '- Movimientos diagonales: Arriba-Derecha - %d | Abajo-Derecha - %d | Abajo-Izquierda - %d | Arriba-Izquierda - %d',10,0
section .bss
section .text

gano_Zorro:
    mov     rdi, msjGanadorZorro
    call    imprimir_estadisticas

gano_Oca:
    mov     rdi, msjGanadorOcas
    call    imprimir_estadisticas
    
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
