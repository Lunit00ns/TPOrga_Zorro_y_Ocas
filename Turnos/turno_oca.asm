global oca_a_mover

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
    msjIngOca           db  "¿Qué oca desea mover? ",0xA
                        db  "Ingrese fila (1 a 7) y columna (1 a 7), separados por un espacio, de la oca a mover: ",0
    msjIngFilCol        db	"¿A dónde desea mover la oca de la posición (%hi, %hi)? ",0xA
                        db  "Ingrese fila (1 a 7) y columna (1 a 7) separados por un espacio: ",0
    formatInputFilCol	db	"%hi %hi",0
    msjErrorInput       db  "La casilla ingresada es inválida. Intente nuevamente.",0
    msjInputOK          db  "Casilla ingresada correctamente!",0xA,0

section .bss
	filaOca             resw    1
    columnaOca          resw    1
    inputFilCol		    resb	50
   	fila			    resw	1
	columna			    resw	1 	
    inputValido         resb    1   ;S valido N invalido
    desplaz			    resw	1
    desplazOca          resw    1
    deltax              resb 1
    deltay              resb 1
section .text

oca_a_mover:
    mov     rdi,msjIngOca
    imprimir

    mov		rdi,inputFilCol
    leerInput

    sub     rsp,8
    call    validarFyC
    add     rsp,8
    cmp     byte[inputValido],'S'
    je      validarPosicion

continuar_oca_a_mover:    
    cmp     byte[inputValido],'S'
    je      entrada_oca
    mov     rdi,msjErrorInput
    imprimir
    jmp     oca_a_mover

entrada_oca:
    mov     rdi,msjIngFilCol
    imprimir

    mov		rdi,inputFilCol	
	leerInput

    sub     rsp,8
    call    validarFyC
    add     rsp,8

    cmp     byte[inputValido],'S'
    je      validarRango

continuar_entrada_oca:
    cmp     byte[inputValido],'S'
    je      continuar

    mov     rdi,msjErrorInput
    imprimir

    jmp     entrada_oca

continuar:
    mov     rdi,msjInputOK
    lea         r8, [r15]
    add         r8,[desplaz]
    mov     r8,"O"
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

validarPosicion:
    mov     byte[inputValido],'N'
    mov     bx,[fila]
    dec     bx
    imul    bx,bx,9
    mov     [desplazOca],bx

    mov     bx,[columna]
    dec     bx
    add     [desplazOca],bx
    
    lea         r8, [r15]
    add         r8,[desplazOca]
    cmp         r8,"O"
    jne     continuar_oca_a_mover
    mov     byte[inputValido],'S'
    
    mov     r8," "
    mov     al, byte[fila]
    mov     [filaOca],al
    mov     al,[columna]
    mov     [columnaOca], al
    jmp     continuar_oca_a_mover 

validarRango:

    mov     byte[inputValido],'N'
    mov     bx,[fila]
    dec     bx
    imul    bx,bx,9
    mov     [desplaz],bx

    mov     bx,[columna]
    dec     bx
    add     [desplaz],bx
    
    lea         r8, [r15]
    add         r8,[desplaz]
    
   
    cmp     r8," "
    jne     continuar_entrada_oca
verificarMovimientoRecto:
    sub     rax,rax
    sub     rcx,rcx
    sub     rdi,rdi
    mov     rdi,[filaOca]
    sub     rdi,[fila]
    mov     [deltax],rdi

    sub     rdi,rdi
    mov     rdi,[columnaOca]
    sub     rdi,[columna]
    mov     [deltay],rdi

    sub     rdi,rdi
    cmp     byte[deltax],0
    je      verificarSalto

    cmp     byte[deltay],0
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
    jmp     continuar_entrada_oca

movimientoValido:
    mov     byte[inputValido],'S'
    jmp     continuar_entrada_oca
invalido:
    ret