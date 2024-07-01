global guardar, cargar
extern puts, fopen, fclose, fwrite, printf

extern turnoActual
extern direccion

; Escribe una linea en 'partidaGuardada.txt'. En el rdi debe estar 
; el elemento a guardar y recibe el tamaño de dicho elemento
%macro escribir 1 
    mov     rsi, %1
    mov     rdx, 1
    mov     rcx, [fileHandle]
    call    fwrite
    imprimirSaltoLinea
%endmacro

; Siempre agrego un salto de linea luego de escribir cada archivo
%macro imprimirSaltoLinea 0
    mov     rdi, saltoLinea        
    mov     rsi, 1
    mov     rdx, 1                 ; Tamaño de cada elemento
    mov     rcx, [fileHandle] 
    call    fwrite
%endmacro

section .data
    nombreArchivo       db 'partidaGuardada.dat',0
    modoEscritura       db 'w',0  
    modoLectura         db 'r',0

    msjError            db 'Error en apertura de archivo.',0

    saltoLinea          db 10,0

section .bss
    fileHandle          resq 1 

section .text
guardar:
    mov     rdi,nombreArchivo
    mov     rsi,modoEscritura

    sub     rsp,8
    call    fopen
    add     rsp,8

    cmp     rax,0
    jg      archivoAbierto 

    mov     rdi,msjError
    sub     rsp,8
    call    puts
    add     rsp,8
    jmp     fin 

archivoAbierto:
    mov     [fileHandle], rax

    mov     rdi, r15 ; tablero
    escribir 81

    mov     rdi, r13 ; emoji zorro
    escribir 4

    mov     rdi, r14 ; emoji ocas
    escribir 4

    mov     rdi, turnoActual 
    escribir 1

    mov     rdi, direccion
    add     byte[rdi], 48
    escribir 1

    mov r8, r12
    mov rbx, 0

sumar_movimientos:
    cmp rbx, 8
    je continuar
    add byte[r8], 48
    inc r8
    inc rbx
    jmp sumar_movimientos

continuar:
    mov     rdi, r12
    mov     rsi, 8
    mov     rdx, 1
    mov     rcx, [fileHandle]
    call    fwrite
    imprimirSaltoLinea

    mov r8, r12
    mov rbx, 0

restar_movimientos:
    cmp rbx, 8
    je cerrar
    sub byte[r8], 48
    inc r8
    inc rbx
    jmp restar_movimientos

cerrar:
    ; Cierro el archivo
    mov     rdi, [fileHandle]
    sub     rsp,8
    call    fclose 
    add     rsp,8

fin:
    ret