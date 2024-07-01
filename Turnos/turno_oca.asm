global oca_a_mover

extern gets, printf, sscanf
extern direccion

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
    msjIngOca           db  "¿Qué oca desea mover? ",10
                        db  "~ Ingrese fila y columna, separados por un espacio, de la oca a mover, o 'S' para salir: ",0
    msjIngFilCol        db	"¿A dónde desea mover a la oca? ",0
    formatInputFilCol	db	"%hi %hi",0
    msjErrorInput       db  "La casilla ingresada es inválida ✖️  Intente nuevamente.",0
    msjInputOK          db  "Casilla ingresada correctamente ✔️",10,0
    salir               db  'N'

section .bss
	filaOca             resw    1
    columnaOca          resw    1
    inputFilCol		    resb	50
    inputFilColAMover   resb	50
   	fila			    resw	1
	columna			    resw	1 	
    inputValido         resb    1   ;S valido N invalido
    inputValido2        resb    1
    desplaz			    resw	1
    desplazOca          resw    1
    deltax              resb    1
    deltay              resb    1
    matriz              resq    1
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
    je     entrada_oca
    cmp     byte[inputFilCol],'S'
    je      fin
    
    mov     rdi,msjErrorInput
    imprimir
    jmp     oca_a_mover

entrada_oca:
    mov     rdi,msjIngFilCol
    imprimir

    mov		rdi,inputFilColAMover		
	leerInput

    sub     rsp,8
    call    validarFyCADondeMover
    add     rsp,8

    cmp     byte[inputValido2],'S'
    je      continuar
    cmp     byte[inputFilColAMover],'S'
    je      fin

    mov     rdi,msjErrorInput
    imprimir

    jmp     entrada_oca

continuar:
    mov     rdi,msjInputOK
    imprimir

    mov     r9w,[desplazOca]
    mov     byte[r15 + r9]," "
    
    mov     r9w,[desplaz]
    mov     byte[r15 + r9],"O"
    
fin:
    mov     dil,[salir]    
    ret

finPartida:
    mov     byte[salir],'S'
    mov     rdi,[salir]
    ret

validarFyC:
    mov     byte[inputValido],'N'
    cmp     byte[inputFilCol],'S'
    je      finPartida

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

validarPosicion:
    xor     rbx,rbx
    mov     bx,[fila]
    dec     bx
    imul    bx,bx,9
    mov     [desplazOca],bx

    mov     bx,[columna]
    dec     bx
    add     [desplazOca],bx
    
    mov     ebx,[desplazOca]
    movzx   ecx,bl
    sub     eax,eax 
    mov     [matriz],r15
    mov     rdx,[matriz]
    add     rdx,rcx

    mov     rax,[rdx]
    
    cmp     al,'O'
    jne     invalido
    mov     byte[inputValido],'S'
    
    mov     rdi,msjInputOK
    imprimir
    ret


validarFyCADondeMover:
    mov     byte[inputValido2],'N'
    cmp     byte[inputFilCol],'S'
    je      finPartida

    mov     rdi,inputFilColAMover	
    mov     rsi,formatInputFilCol
    mov     rdx,filaOca
    mov     rcx,columnaOca
	sub		rsp,8
	call	sscanf
	add		rsp,8    

    cmp     rax,2
    jl      invalido

    cmp     word[filaOca],1
    jl      invalido
    cmp     word[filaOca],7
    jg      invalido

    cmp     word[columnaOca],1
    jl      invalido
    cmp     word[columnaOca],7
    jg      invalido
    

validarRango:
    mov     bx,[filaOca]
    dec     bx
    imul    bx,bx,9
    mov     [desplaz],bx

    mov     bx,[columnaOca]
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
    
    mov     dl,[fila]
    sub     dl,[filaOca]
    mov     [deltax],dl

    sub     rdi,rdi
    mov     dl,[columna]
    sub     dl,[columnaOca]
    mov     [deltay],dl

    cmp     byte[deltax],0
    je      verificarSalto

    cmp     byte[deltay],0
    je      verificarSalto

    jmp     invalido

verificarSalto:
    
    mov     cl,[desplaz]
    mov     al,[desplazOca]
    sub     cl,al
    cmp     byte[direccion],cl
    je      invalido
    
    jmp     movimientoValido
    

movimientoValido:
    mov     byte[inputValido2],'S'
    ret
invalido:
    ret