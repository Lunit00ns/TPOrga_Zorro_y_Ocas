global entrada_zorro

extern busqueda_tablero, imprimir_tablero, agregar_movimiento
extern gets, printf, sscanf
extern pos_zorro

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
    msjIngFilCol        db "¿Dónde desea mover al zorro?",10
                        db "~ Ingrese fila y columna separados por un espacio, o 'S' para salir: ",0
    msjErrorInput       db "La casilla ingresada es inválida ✖️ Intente nuevamente.",10,0
    msjInputOK          db "Casilla ingresada correctamente ✔️",10,0
    msjTurnoExtra       db '----- Comiste una oca %s Tenes un movimiento extra -----',10,0

    formatInputFilCol   db "%hi %hi",0
    seComioOca          db 0
    posOca1             db 0
    salir               db 'N'
    turno               db 1

    b_fila              db 0
    b_columna           db 0

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
    mov     byte[turno],1
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
    cmp     byte[inputFilCol],'S'
    je      fin

    mov     rdi,msjErrorInput
    imprimir

    jmp     pedirMov

continuar:
    call        obtenerDireccion
    mov         rdi,msjInputOK
    imprimir    
    
    xor         rdi,rdi
cambiarposiciones:
    sub         rsp, 8
    call        pos_zorro
    add         rsp, 8

    ;no se si funciona
    mov     r9w,[desplaz]
    mov     byte[r15 + r9],"X"
    
    dec         rbx
    imul        rbx,rbx,9

    dec         rcx
    add         rbx,rcx

    mov     byte[r15 + rbx]," "

    ;tiene turno extra?
    cmp         byte[seComioOca],1
    je          cambiarposicionesOca
    
    
fin:    
    mov     rbx,[seComioOca]
    mov     dil,byte[inputFilCol]
    mov     byte[seComioOca],0
    mov     byte[turno],1
    ret

cambiarposicionesOca:
    mov     byte[seComioOca],0
    mov     r9w,[posOca1]
    mov     byte[r15 + r9]," "
    cmp     byte[turno],2
    je      invalido
    mov     byte[turno],2
    call    imprimir_tablero
    
    mov     rdi, msjTurnoExtra
    mov     rsi, r14
    imprimir

    jmp       pedirMov
    ret


validarFyC:
    mov     byte[inputValido],'N'
    cmp     byte[inputFilCol],'S'
    je      invalido

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

    sub     bl,[fila]

    sub     cl,[columna]

    cmp     bl,0
    je      verificarSalto

    cmp     cl,0
    je      verificarSalto


    ;verificacion movimiento en diagonal
    cmp     bl,-2
    je     invalido
    cmp     bl,2
    je     invalido
    cmp     cl,-2
    je     invalido
    cmp     cl,2
    je     invalido
verificarSalto:
    xor    rdi,rdi
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
    je      saltoSimpleArriba
    cmp     bl, -2
    je      saltoSimpleAbajo
    cmp     cl, 2
    je      saltoSimpleIzq
    cmp     cl, -2
    je      saltoSimpleDerecha
    
    jmp     invalido

;verifico si es posible que el zorro salte, para eso debe haber una oca en las posiciones correspondientes
;para verificar si hay una oca, calculo la posicion intermedia entre el salto y la posicion del zorro
saltoSimpleAbajo: 

    mov     bx,[fila]
    sub     bx,2
    imul    bx,bx,9
    mov     [posOca1],bx

    mov     bx,[columna]
    sub     bx,1
    add     [posOca1],bx


    mov     ebx,[posOca1]   
    movzx   ecx,bl 
    sub     eax,eax
    mov     [matriz],r15
    mov     rdx,[matriz]
    add     rdx,rcx
    mov     rax,[rdx]
    cmp     al,'O'

    jne     invalido  
    add     byte[seComioOca],1
    jmp     movimientoValido
   

saltoSimpleArriba:
    ;espero que funcione :)
    cmp     bl,cl
    je     invalido


    mov     bx,[fila]
    imul    bx,bx,9
    mov     [posOca1],bx

    mov     bx,[columna]
    sub     bx,1
    add     [posOca1],bx


    mov     ebx,[posOca1]   
    movzx   ecx,bl 
    sub     eax,eax
    mov     [matriz],r15
    mov     rdx,[matriz]
    add     rdx,rcx
    mov     rax,[rdx]
    cmp     al,'O'

    jne     invalido  
    add     byte[seComioOca],1
    jmp     movimientoValido

saltoSimpleIzq:
    ;espero que funcione :)
    cmp     bl,cl
    je     invalido


    mov     bx,[fila]
    dec     bx
    imul    bx,bx,9
    mov     [posOca1],bx

    mov     bx,[columna]
    add     [posOca1],bx


    mov     ebx,[posOca1]   
    movzx   ecx,bl 
    sub     eax,eax
    mov     [matriz],r15
    mov     rdx,[matriz]
    add     rdx,rcx
    mov     rax,[rdx]
    cmp     al,'O'

    jne     invalido  
    add     byte[seComioOca],1
    jmp     movimientoValido

saltoSimpleDerecha:
    ;espero que funcione :)
    cmp     bl,cl
    je     invalido


    mov     bx,[fila]
    dec     bx
    imul    bx,bx,9
    mov     [posOca1],bx

    mov     bx,[columna]
    sub     bx,2
    add     [posOca1],bx


    mov     ebx,[posOca1]   
    movzx   ecx,bl 
    sub     eax,eax
    mov     [matriz],r15
    mov     rdx,[matriz]
    add     rdx,rcx
    mov     rax,[rdx]
    cmp     al,'O'

    jne     invalido  
    add     byte[seComioOca],1
    jmp     movimientoValido
invalido:
    ret

movimientoValido:
    mov     byte[inputValido],'S'
    ret
obtenerDireccion:
    sub rsp, 8
    call pos_zorro
    add rsp, 8

    sub     bl,[fila]

    sub     cl,[columna]  
    
    cmp     bl,0;si la diferencia de fila es 0 => se movio a uno de los costados
    je      izqoder

    cmp     cl,0;si la diferencia de columna es 0 => se m3ovio a arriba o abajo
    je      arribaoabajo

    ;si ninugno es cero => es en diagonal
    cmp     bl,1;si la diferencia de fila es 1 => se movio en diagonal para arriba
    je      diagonalArribaIzqoDer

    jmp     diagonalAbajoIzqoDer; el unico caso que queda es diagonal para abajo

diagonalAbajoIzqoDer:
    cmp     cl,1
    je     seMOvioparaDiagonalAbajoIzq
    jmp      seMovioparaDiagonalAbajoDer
    

diagonalArribaIzqoDer:
    cmp     cl,1
    je      seMovioparaDiagonalArribaIzq
    jmp     seMovioparaDiagonalArribaDer
arribaoabajo:  
    cmp     bl,1
    je     seMovioparaAbajo
    jmp      seMovioparaArriba
    
izqoder:
    cmp     cl,1
    je    seMovioparaDer
    jmp      seMovioparaIzq
    
    
    
seMovioparaDiagonalArribaIzq:
    add byte[r12 + 0], 1
    ret
seMovioparaArriba:
    add byte[r12 + 1], 1
    ret
seMovioparaDiagonalArribaDer:
    add byte[r12 + 2], 1
    ret
seMovioparaIzq:
    add byte[r12 + 3], 1
    ret
seMovioparaDer:
    add byte[r12 + 4], 1
    ret
seMOvioparaDiagonalAbajoIzq:
    add byte[r12 + 5], 1
    ret
seMovioparaAbajo:
    add byte[r12 + 6], 1
    ret
seMovioparaDiagonalAbajoDer:
    add byte[r12 + 7], 1
    ret

; Función que incrementa el contador en la posición indicada en el r8
incrementar: 
    push    rbp
    mov     rbp, rsp

    ; Calcula la dirección del elemento a incrementar
    mov     rcx, r12        ; Carga la dirección base del vector de movimientos en rcx
    add     rcx, [r8]        ; Suma el índice para obtener la dirección del elemento

    ; Incrementa el valor en la dirección calculada
    inc     byte [rcx]
    pop     rbp