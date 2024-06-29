global		main
extern		puts
extern		fopen
extern		fclose
extern      fwrite

%macro calcular_largo 0
    xor     rsi, rsi                ; Inicializa rsi en 0
%%calcular_largo2:
    cmp     byte [rcx + rsi], 0     ; Compara el byte actual con 0 (fin de cadena)
    je      %%fin                   ; Si es 0, finaliza
    inc     rsi                     ; Incrementa rsi para la siguiente posición
    jmp     %%calcular_largo2       ; Repite el proceso
%%fin: ; rsi contendrá la longitud del elemento
%endmacro

%macro escribir_archivo 0
    mov     rdx, 1                 ; Tamaño de cada elemento
    mov     rcx, [fileHandle]      ; Descriptor del archivo
    call    fwrite 
    mov     rdi, saltoLinea        ; Siempre agrego un salto de línea al final
    mov     rsi, 1
    mov     rdx, 1                 ; Tamaño de cada elemento
    mov     rcx, [fileHandle] 
    call    fwrite
%endmacro

section .data
    nombreArchivo       db 'partidaGuardada.txt',0
    modo                db 'w',0  ; modo escritura de texto 

    msjTodoOK           db 'Partida guardada correctamente',0
    msjErrOpen          db 'Error en apertura de archivo',0

    tableroDerecha      db  '-','-','-','-','-','-','-','-','-',
                        db  '-','-','-','O','O','O','-','-','-',
                        db  '-','-','-','O','O','O','-','-','-',
                        db  '-','O','O','O','O','O','O','O','-',
                        db  '-','O',' ',' ',' ',' ',' ','O','-',
                        db  '-','O',' ',' ','X',' ',' ','O','-',
                        db  '-','-','-',' ',' ',' ','-','-','-',
                        db  '-','-','-',' ',' ',' ','-','-','-',
                        db  '-','-','-','-','-','-','-','-','-'
    nombreZorro         db  'Zorro',0 ; --> TIENE QUE TENER EL ,0 !
    nombreOca           db  'Ocas',0

    turno               db  'Z',0

    saltoLinea          db  10, 0

section .bss
    fileHandle          resq 1  ; Descriptor del archivo
    
section .text

main:
    sub     rsp,8
    mov     rdi,nombreArchivo
    mov     rsi,modo
    call    fopen

    cmp     rax,0
    jg      archivoAbierto 

    mov		rdi,msjErrOpen
	call	puts
	jmp		fin 

archivoAbierto:
    mov     [fileHandle], rax

    ; Escribo el tablero 
    mov     rdi, tableroDerecha     ; --> Acá iría r15
    mov     rsi, 81                 ; Tamaño del tablero
    escribir_archivo

    ; Escribo el nombre del Zorro
    mov     rdi, nombreZorro 
    mov     rcx, rdi    
    calcular_largo                  ; debería quedar en el rsi el largo del elemento del rdi 
    escribir_archivo

    ; Escribo el nombre del jugador de las Ocas
    mov     rdi, nombreOca
    mov     rcx, rdi    
    calcular_largo
    escribir_archivo

    ; Escribo el turno actual
    mov     rdi, turno
    mov     rcx, rdi    
    calcular_largo
    escribir_archivo

cerrar:
;	Cierro el archivo
	mov		rdi,[fileHandle]	
	call	fclose	

fin:
	add		rsp,8
	ret