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

section .bss
    inputFilCol         resb 50
    fila                resw 1
    columna             resw 1     
    inputValido         resb 1   ; S valido N invalido
    desplaz             resw 1
    primerElemTablero   resb 1
    filaActul             resb 1
    colactu             resb 1
    matrizTab           resb 121
    deltax              resb 1
    deltay              resb 1

section .text
entrada_zorro:
    mov     [filaActul],rsi
    mov     [colactu],rbx
    mov     [matrizTab],rdx
    mov     rax,[rdi]
    mov     [primerElemTablero],rax

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

    jmp     entrada_zorro

continuar:
    mov     rdi,msjInputOK
    imprimir

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

    mov     byte[inputValido],'S'

   
validarRango:
    ;primero calculo dez y veo si esta vacia
    ;luego verifico si es posible el movimiento segun las reglas

    mov     ax,[fila]
    imul    ax,11

    mov     dx,[columna]
    add     ax,dx

    lea     bx, [matrizTab]
    add     bx,ax
    
    cmp     bx,0
    jne     pedirMov

    
verificarMovimientoRecto:
    sub     rdi,rdi
    mov     rdi,[filaActul]
    sub     rdi,[fila]
    mov     [deltax],rdi

    sub     rdi,rdi
    mov     rdi,[colactu]
    sub     rdi,[columna]
    mov     [deltay],rdi

    
    cmp     byte[deltax],0
    je      verificarSalto

    cmp     byte[deltay],0
    je      verificarSalto

    ;verificacion movimiento en diagonal
    mov     ax,[deltax]
    mov     cx,[deltay]
    xor     ax,cx 
    jnz     pedirMov;verifico que tienen mismo signo
    cmp     ax,cx 
    je      verificarSalto
    jmp     pedirMov

verificarSalto:
    ;primero verifico si es un movimiento de una casilla
    cmp     ax, 1
    je      movimientoValido
    cmp     ax, -1
    je      movimientoValido
    cmp     cx, 1
    je      movimientoValido
    cmp     cx, -1
    je      movimientoValido

    ;ahora verifico si es un salto de una celda (osea se mueve dos casillas para comer una oca)
    
    cmp     ax, 2
    je      saltoSimple
    cmp     ax, -2
    je      saltoSimple
    cmp     cx, 2
    je      saltoSimple
    cmp     cx, -2
    je      saltoSimple

    ;ahora verifico si es un salto de dos celdas (osea se mueve tres casillas para comer dos ocas)
    
    cmp     ax, 3
    je      saltoMultiple
    cmp     ax, -3
    je      saltoMultiple
    cmp     cx, 3
    je      saltoMultiple
    cmp     cx, -3
    je      saltoMultiple

;verifico si es posible que el zorro salte, para eso debe haber una oca en las posiciones correspondientes
;para verificar si hay una oca, calculo la posicion intermedi entre el salto y la posicion del zorro
saltoSimple:
    mov     rax,[fila]
    add     rax,[filaActul]
    mov     rdi,2
    div     rdi
    mov     rbx,rax

    mov     rax,columna
    add     rax,colactu
    div     rdi

    imul    rbx,11



    add     rbx,rax   
    lea     rbx, [matrizTab]
    add     rcx,rbx

    cmp     rcx,1
    jne     pedirMov    
    add     byte[seComioOca],1
    jmp     movimientoValido

saltoMultiple:;aca tengo que calcular dos posiciones intermedias
    mov     rax,fila
    add     rax,filaActul
    mov     rdi,2
    div     rdi
    mov     rbx,rax

    mov     rax,columna
    add     rax,colactu
    div     rdi

    mov     rdx,rbx
    imul    rdx,11

    mov     rcx,rax

    add     rdx,rcx
    lea     rbx,[matrizTab]
    add     rbx,rdx
    cmp     rbx,1
    jne     pedirMov   

    mov     rsi,rax
    add     rbx,filaActul
    mov     rax,rbx
    mov     rdi,2
    div     rdi
    mov     rbx,rax

    add     rsi,colactu
    mov     rax,rsi
    div     rdi

    imul    rbx,11

    imul    rax,1

    add     rbx,rax
    lea     r8,[matrizTab]
    add     r8,rbx
    cmp     r8,1
    jne     pedirMov  
    add     byte[seComioOca],2
    jmp     movimientoValido     

invalido:
    ret

movimientoValido:

    mov     rax,[desplaz]
    mov     rbx,[seComioOca]
    mov     rcx,[fila];esto no se si es legal, pero no se me ocurre como hacerlo ajaja
    mov     rdx,[columna]
    jmp     continuar