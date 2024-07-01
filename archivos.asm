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
    msjErrorCargar      db 'Error al cargar la partida ✖️  Verificá que exista un archivo "partidaGuardada.dat" e intenta nuevamente.',10,0

    saltoLinea          db 10,0

    tablero             db  ' ',' ',' ',' ',' ',' ',' ',' ',' ',
                        db  ' ',' ',' ',' ',' ',' ',' ',' ',' ',
                        db  ' ',' ',' ',' ',' ',' ',' ',' ',' ',
                        db  ' ',' ',' ',' ',' ',' ',' ',' ',' ',
                        db  ' ',' ',' ',' ',' ',' ',' ',' ',' ',
                        db  ' ',' ',' ',' ',' ',' ',' ',' ',' ',
                        db  ' ',' ',' ',' ',' ',' ',' ',' ',' ',
                        db  ' ',' ',' ',' ',' ',' ',' ',' ',' ',
                        db  ' ',' ',' ',' ',' ',' ',' ',' ',' '
    emoji_zorro         db '🦊'
    emoji_oca           db '🦊'
    turno               db 0
    v_direccion         db 0
    movimientos         db 0, 0, 0, 0, 0, 0, 0, 0

section .bss
    fileHandle          resq 1 

section .text

; --------------- Función guardar partida ---------------
; Registros que utiliza:
; r15, r14, r13

; Escribe en el archivo 'partidaGuardada.dat' los datos de la partida
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
    escribir 1

    mov     rdi, r12
    escribir 8


cerrar:
    ; Cierro el archivo
    mov     rdi, [fileHandle]
    sub     rsp,8
    call    fclose 
    add     rsp,8

    ret ; por las dudas

; --------------- Función cargar partida ---------------
; Registros que utiliza:
; r15, r14, r13

; Escribe en el archivo 'partidaGuardada.dat' los datos de la partida
cargar:
    xor rax, rax
    add al, 2
    lea rdi, [nombreArchivo]
    xor rsi, rsi
    syscall    

    ;cmp rax, 0 ; si no existe el archivo
    ;je errorLectura

    mov rdi, rax
    sub sp, 0xfff
    lea rsi, [rsp]
    xor rdx, rdx
    mov dx, 0x200
    xor rax, rax
    syscall

    ;cmp rsi, 0 ; si está vacío el archivo
    ;je errorLectura

    lea rdi, [tablero]
    mov rcx, 81
    rep movsb
    lea r15, tablero

    add rsi, 1
    lea rdi, [emoji_zorro]
    mov rcx, 4
    rep movsb
    lea r13, [emoji_zorro]

    add rsi, 1
    lea rdi, [emoji_oca]
    mov rcx, 4
    rep movsb
    lea r14, [emoji_oca]

    add rsi, 1
    lea rdi, turnoActual
    mov rcx, 1
    rep movsb

    add rsi, 1
    lea rdi, direccion
    mov rcx, 1
    rep movsb

    add rsi, 1
    lea rdi, [movimientos]
    mov rcx, 8
    rep movsb
    lea r12, [movimientos]

    xor rax,rax
    add al, 6
    syscall

errorLectura:
    ret

fin:
    ret