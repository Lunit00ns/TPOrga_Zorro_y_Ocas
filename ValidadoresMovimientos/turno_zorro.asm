global entrada_zorro

extern gets, printf, sscanf

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
    posOca2             db 0


section .bss
    inputFilCol         resb 50
    fila                resw 1
    columna             resw 1     
    inputValido         resb 1   ; S valido N invalido
    desplaz             resw 1
    filaActul           resb 1
    colactu             resb 1
    matrizTab           resq 1
    deltax              resb 1
    deltay              resb 1
    
    oca_x               resb 1
    oca_y               resb 1

section .text
entrada_zorro:
    mov     [filaActul],rsi
    mov     [colactu],rdx
    mov     [matrizTab],rdi


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
    mov     rdi,msjInputOK
    imprimir
    xor     rdi,rdi
    ;aca hago copias para pasarlo al main y editar el tablero original
    mov     rax,[desplaz]
    mov     rbx,[seComioOca]
    mov     rcx,[fila]
    mov     rdx,[columna]
    mov     r8,[posOca1]
    mov     r9,[posOca2]
    ret

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

   
    cmp     word[fila],1
    jl      invalido
    cmp     word[fila],7
    jg      invalido

    cmp     word[columna],1
    jl      invalido
    cmp     word[columna],7
    jg      invalido

   
validarRango:
    ;primero calculo dez y veo si esta vacia
    ;luego verifico si es posible el movimiento segun las reglas

    mov     bx,[fila]
    dec     bx
    imul    bx,bx,8
    mov     [desplaz],bx

    mov     bx,[columna]
    dec     bx
    add     [desplaz],bx
    
    mov     ebx,[desplaz]
    movzx   ecx,bl 
    sub     eax,eax
    mov     rdx,[matrizTab]
    add     rdx,rcx

    mov     rax,[rdx]
    
   
    cmp     al,0
    jne     invalido


verificarMovimientoRecto:
    sub     rax,rax
    sub     rcx,rcx
    sub     rdi,rdi
    mov     rdi,[filaActul]
    sub     rdi,[fila]
    mov     [deltax],rdi

    sub     rdi,rdi
    mov     rdi,[colactu]
    sub     rdi,[columna]
    mov     [deltay],rdi

    sub     rdi,rdi
    cmp     byte[deltax],0
    je      verificarSalto

    cmp     byte[deltay],0
    je      verificarSalto

    ;verificacion movimiento en diagonal
    mov     al, byte[deltax]
    mov     cl, byte[deltay]
    cmp     al,cl
    je      verificarSalto
    jmp     invalido

verificarSalto:

    ;primero verifico si es un movimiento de una casilla
    cmp     byte[deltax], 1
    je      movimientoValido
    cmp     byte[deltax], -1
    je      movimientoValido
    cmp     byte[deltay], 1
    je      movimientoValido
    cmp     byte[deltay], -1
    je      movimientoValido

    ;ahora verifico si es un salto de una celda (osea se mueve dos casillas para comer una oca)
    
    cmp     byte[deltax], 2
    je      saltoSimple
    cmp     byte[deltax], -2
    je      saltoSimple
    cmp     byte[deltay], 2
    je      saltoSimple
    cmp     byte[deltay], -2
    je      saltoSimple

    ;ahora verifico si es un salto de dos celdas (osea se mueve tres casillas para comer dos ocas)
    
    cmp     byte[deltax], 3
    je      saltoMultiple
    cmp     byte[deltax], -3
    je      saltoMultiple
    cmp     byte[deltay], 3
    je      saltoMultiple
    cmp     byte[deltay], -3
    je      saltoMultiple

;verifico si es posible que el zorro salte, para eso debe haber una oca en las posiciones correspondientes
;para verificar si hay una oca, calculo la posicion intermedi entre el salto y la posicion del zorro
saltoSimple:
    
    mov     bx,[fila]
    add     bx,[filaActul]
    xor     rdx,rdx
    mov     ax,bx
    mov     si,2
    div     si
    mov     bx,ax
    
    dec     bx
    imul    bx,bx,8
    mov     [posOca1],bx
    
    mov     bx,[columna]
    add     bx,[colactu]
    div     si
    dec     ax

    add     [posOca1],ax
 

    mov     ebx,[posOca1]   
    movzx   ecx,bl 
    sub     eax,eax
    mov     rdx,[matrizTab]
    add     rdx,rcx

    mov     rax,[rdx]

    cmp     al,1
    jne     invalido  
    add     byte[seComioOca],1
    jmp     movimientoValido

saltoMultiple:;aca tengo que calcular dos posiciones intermedias
    mov     bx,[fila]
    add     bx,[filaActul]
    xor     rdx,rdx
    mov     ax,bx
    mov     si,2
    div     si
    mov     bx,ax
    mov     [oca_x],bx
    dec     bx
    imul    bx,bx,8
    mov     [posOca1],bx

    sub     rbx,rbx
    mov     bx,[columna]
    add     bx,[colactu]
    div     si
    mov     [oca_y],bx
    dec     ax

    add     [posOca1],ax

    mov     ebx,[posOca1]   
    movzx   ecx,bl 
    sub     eax,eax
    mov     rdx,[matrizTab]
    add     rdx,rcx
    mov     rax,[rdx]

    cmp     al,1
    jne     invalido   
    add     byte[seComioOca],1
    jmp     movimientoValido

    xor     rax,rax
    xor     rbx,rbx
    mov     bx,[filaActul]
    add     bx,[oca_x]
    xor     rdx,rdx
    mov     ax,bx
    mov     si,2
    div     si
    mov     bx,ax
    dec     bx
    imul    bx,bx,8
    mov     [posOca2],bx

    sub     rbx,rbx
    mov     bx,[colactu]
    add     bx,[oca_y]
    div     si
    dec     ax

    add     [posOca2],ax 

    mov     ebx,[posOca2]
    movzx   ecx,bl 
    sub     eax,eax
    mov     rdx,[matrizTab]
    add     rdx,rcx

    mov     rax,[rdx]

    cmp     al,1
    jne     invalido  
    add     byte[seComioOca],2
    jmp     movimientoValido     

invalido:
    ret

movimientoValido:
    mov     byte[inputValido],'S'
    ret