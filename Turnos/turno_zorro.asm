global entrada_zorro

extern busqueda_tablero
extern gets, printf, sscanf
extern  pos_zorro

%macro imprimir 0
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
    msjIngFilCol        db "¿Dónde desea mover al zorro? ",0xA
                        db "Ingrese fila (1 a 7) y columna (1 a 7) separados por un espacio: ",0
    formatInputFilCol   db "%hi %hi",0
    msjErrorInput       db "La casilla ingresada es inválida. Intente nuevamente.",0
    msjInputOK          db "Casilla ingresada correctamente!",0xA,0
    seComioOca          db 0
    posOca1             db 0
    formato             db "%hi",0


section .bss
    inputFilCol         resb 50     
    inputValido         resb 1   ; S valido N invalido
    desplaz             resw 1
    oca_x               resb 1
    oca_y               resb 1
    fila                resw 1
    columna             resw 1
    matriz              resq 1

section .text
entrada_zorro:

pedirMov:
    mov     rdi,msjIngFilCol
    imprimir

    mov		rdi,inputFilCol	
	leerInput

    sub     rsp,8
    call    validarFyC
    add     rsp,8

    cmp     byte[inputValido],'S'
    je      continuar

    mov     rdi,msjErrorInput
    imprimir

    jmp     pedirMov

continuar:

    mov         rdi,msjInputOK
    imprimir
    
    xor         rdi,rdi
    ;tiene turno extra?
    cmp         byte[seComioOca],1
    je          cambiarposicionesOca

cambiarposiciones:
    sub         rsp, 8
    call        pos_zorro
    add         rsp, 8

    ;no se si funciona
    lea         r8, [r15]
    add         r8,[desplaz]

    mov         r8,"X"
    
    dec         rbx
    imul        rbx,rbx,9

    dec         rcx
    add         rbx,rcx

    lea         r8, [r15]
    add         r8,rbx
    mov         r8," "


terminarTurno:
    cmp         byte[seComioOca],1
    je          pedirMov
    mov         rbx,[seComioOca]
    ret

cambiarposicionesOca:
    ;no se si funciona
    lea         r8,[r15]
    add         r8,[posOca1]

    mov         r8,"O"
    
    jmp         cambiarposiciones

validarFyC:
    mov     byte[inputValido],'N'

    mov     rdi,inputFilCol
    mov     rsi,formatInputFilCol
    mov     rdx,fila
    mov     rcx,columna
	sub		rsp,8
	call	sscanf
	add		rsp,8

    cmp     rax,2
    jl      invalido

   
    cmp     word[fila],2
    jl      invalido
    cmp     word[fila],8
    jg      invalido

    cmp     word[columna],2
    jl      invalido
    cmp     word[columna],8
    jg      invalido

validarRango:
    ;primero calculo dez y veo si esta vacia
    ;luego verifico si es posible el movimiento segun las reglas
    mov     bx,[fila]
    dec     bx
    imul    bx,bx,9
    mov     [desplaz],bx

    mov     bx,[columna]
    dec     bx
    add     [desplaz],bx

    mov     ebx,[desplaz]
    movzx   ecx,bl 
    sub     eax,eax
    mov     [matriz],r15
    mov     rdx,[matriz]
    add     rdx,rcx

    mov     rax,[rdx]
    
    cmp     al,' '
    jne     invalido

verificarMovimientoRecto:
    sub         rsp, 8
    call        pos_zorro   ; rcx(col), rbx(fil)5 6
    add         rsp, 8


    sub     rbx,[fila]

    sub     rcx,[columna]

    cmp     bl,0
    je      verificarSalto

    cmp     cl,0
    je      verificarSalto


    ;verificacion movimiento en diagonal
    cmp     bl,cl
    je      verificarSalto
    jmp     invalido

verificarSalto:
    mov         rdi,msjInputOK
    imprimir
    ;primero verifico si es un movimiento de una casilla
    cmp     bl, 1
    je      movimientoValido
    cmp     bl, -1
    je      movimientoValido
    cmp     cl, 1
    je      movimientoValido
    cmp     cl, -1
    je      movimientoValido

    ;ahora verifico si es un salto de una celda (osea se mueve dos casillas para comer una oca)
    
    cmp     bl, 2
    je      saltoSimple
    cmp     bl, -2
    je      saltoSimple
    cmp     cl, 2
    je      saltoSimple
    cmp     cl, -2
    je      saltoSimple
    
    jmp     invalido

;verifico si es posible que el zorro salte, para eso debe haber una oca en las posiciones correspondientes
;para verificar si hay una oca, calculo la posicion intermedia entre el salto y la posicion del zorro
saltoSimple:
    ;espero que funcione :)
    cmp     bl,cl
    jne     invalido
    
    xor rbx,rbx
    xor rcx,rcx
    sub         rsp, 8
    call        pos_zorro
    add         rsp, 8


    add     rbx,[fila]
    xor     rdx,rdx
    mov     ax,bx
    mov     si,2
    div     si
    mov     bx,ax
    
    dec     bx
    imul    bx,bx,9
    mov     [posOca1],bx
    
    add     rcx,[columna]
    mov     ax,cx
    div     si
    dec     ax

    add     [posOca1],ax
    
    lea r8, [r15]
    add r8,[desplaz]

    cmp     r8,"O"
    jne     invalido  
    add     byte[seComioOca],1
    jmp     movimientoValido
   

invalido:
    ret

movimientoValido:
    mov     byte[inputValido],'S'
    ret