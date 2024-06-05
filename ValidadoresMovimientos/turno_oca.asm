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

section .text
oca_a_mover:
    mov     rdi,msjIngOca
    imprimir

    mov		rdi,inputFilCol
    leerInput

    sub     rsp,8
    call    validarFyC
    add     rsp,8

    

entrada_oca:
    mov     rdi,msjIngFilCol
    imprimir

    mov		rdi,inputFilCol	
	leerInput

    sub     rsp,8
    call    validarFyC
    add     rsp,8

    cmp     byte[inputValido],'🦢'
    cmp     byte[inputValido],'S'
    je      continuar

    mov     rdi,msjErrorInput
    imprimir

    jmp     entrada_oca

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


invalido:
    ret