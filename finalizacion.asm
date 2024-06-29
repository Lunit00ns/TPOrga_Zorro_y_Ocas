global  gano_Zorro
global  gano_oca

%macro imprimir 0
    xor rax,rax
    sub rsp,8 
    call printf
    add rsp,8 
%endmacro

section .data
    msjGanadorZorro     db  '¡Gana %s! El Zorro logró comer 12 Ocas.',10,0
    msjGanadorOcas      db  '¡Gana %s! Las Ocas acorralaron al Zorro.',10,0
section .bss
section .text

gano_Zorro:
    mov     rdi, msjGanadorZorro
    imprimir
    call    estadisticas

gano_Oca:
    mov     rdi, msjGanadorOcas
    imprimir
    call    estadisticas
    
estadisticas: