global main
;extern puts
extern mostrar

section .data
    tablero db  '░░','░░','░░','░░','░░','░░','░░','░░','░░',10,
            db  '░░','░░','░░','🦢','🦢','🦢','░░','░░','░░',10,
            db  '░░','░░','░░','🦢','🦢','🦢','░░','░░','░░',10,
            db  '░░','🦢','🦢','🦢','🦢','🦢','🦢','🦢','░░',10,
            db  '░░','🦢','. ','. ','. ','. ','. ','🦢','░░',10,
            db  '░░','. ','. ','. ','🦊','. ','. ','. ','░░',10,
            db  '░░','░░','░░','. ','. ','. ','░░','░░','░░',10,
            db  '░░','░░','░░','. ','. ','. ','░░','░░','░░',10,
            db  '░░','░░','░░','░░','░░','░░','░░','░░','░░',10
            ; '░' utiliza 3 bytes
            ; cada emoji utilizan
    largo equ $- tablero
    zorro db    'Z', '🦊' ; Los emojis ocupan 2 espacios
    oca db      'O', '🦢'

section .bss

section .text

main:

    ; Menú del juego
    ; - Cargar la partida (si es posible)
    ; - Configurar tablero (nueva partida)
    
    ; 1) Mostrar tablero
    mov r8,tablero
    mov r9,largo
    sub rsp,8
    call mostrar
    add rsp,8
    ; 2) Esperar instrucción (mover zorro)
    ; 3) Verificar que la instrucción sea válida
    ; 4) Verificar casilla del zorro
    ; -> De lo contrario, volver al paso 2
    ; 5) Mover al zorro en el tablero
    ; 6) "Pasar turno"
    ; 7) Guardar partida
    
    ; 1) Mostrar tablero
    ; 2) Esperar instrucción (seleccionar oca)
    ; 3) Verificar que la instrucción sea válida
    ; 4) Esperar instrucción (mover oca)
    ; 5) Verificar casilla y movimiento
    ; -> De lo contrario, volver al paso 4
    ; 6) Mover la oca en el tablero
    ; 7) "Pasar turno"
    ; 8) Guardar partida
    ret

; Seleccionar ocas
; 1) Cuadrícula en el tablero
; 2) Hacer un tablero2 o (de alguna forma) reemplazar en el tablero las ocas por números
; 'o¹','o²','o³'
; '01','02','03'