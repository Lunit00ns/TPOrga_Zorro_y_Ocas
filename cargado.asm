global		main
extern		printf
extern		puts
extern		fopen
extern		fgets
extern		fputs
extern		fclose

%macro imprimir 0
    mov     rcx,registro
    xor     rbx, rbx

%%calcular_longitud:
    ; Calculo la longitud de la cadena
    cmp     byte [rcx + rbx], 0
    je      %%imprimir_linea
    inc     rbx
    jmp     %%calcular_longitud

%%imprimir_linea:
    ; Imprimir el registro en pantalla usando la syscall write
    mov rax, 1
    mov rdi, 1
    mov rsi, registro
    mov rdx, rbx   ; Longitud de la cadena leída
    syscall
%endmacro

section .data
    nombreArchivo       db 'partidaGuardada.txt',0
    modo                db 'r',0  ; modo lectura de texto
    msjErrOpen	        db  "Error en apertura de archivo '%s'",0
    formatoImprimir     db  "%s", 10, 0

section .bss
    fileHandle          resq 1  ; Descriptor del archivo
    registro            resb 82  ; Espacio extra para el terminador nulo

section .text
main:
    sub     rsp, 8
    ; Abro archivo para lectura
    mov     rdi, nombreArchivo
    mov     rsi, modo
    call    fopen

    cmp     rax, 0  ; ¿Error en apertura?
    jg      archivoAbierto

    ; Error lectura
    mov		rdi, msjErrOpen
    mov     rsi, nombreArchivo
    imprimir
    jmp     fin

archivoAbierto:
	mov	    [fileHandle], rax

leer:
    mov     rdi, registro
    mov     rsi, 81  ; Leer hasta 81 caracteres, incluyendo el terminador nulo
    mov     rdx, [fileHandle]
    call    fgets

	cmp		rax, 0					; ¿Fin de archivo?
	jle		cerrar

    imprimir

    jmp		leer

cerrar:
    mov     rdi, [fileHandle]
    call    fclose

fin:
	add		rsp, 8
	ret
