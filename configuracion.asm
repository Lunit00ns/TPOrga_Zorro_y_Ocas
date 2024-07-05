global direccion
global config_jugadores
extern printf, sscanf, puts
extern gets

%macro imprimir 0
    xor rax, rax
    sub rsp,8 
    call printf
    add rsp,8 
%endmacro

%macro leerInput 1
    mov rdi, %1
    sub rsp,8
    call gets
    add rsp,8
%endmacro

section .data
    msjPersonalizar     db  '¿Desea personalizar la partida? s/n: ',0
    msjPersoOK          db  '----- Se eligió la opción de personalizar el juego -----',10,0
    msjPersoDefault     db  '----- Se utilizará una configuración de juego predeterminada -----',10,0
    msjPartidaOK        db  '✔️ La partida fue configurada correctamente ✔️',10,0

    msjErrorPerso       db  'Opción inválida ✖️ Ingresá "s" para personalizar o "n" para una configuarción predeterminada.',10,0
    msjErrorEmoji       db  'Opción inválida ✖️ Ingresá un número entre 1 y 3',10,0
    msjErrorTablero     db  'Opción inválida ✖️ Ingresá un número entre 1 y 4',10,0

    msjFinal            db  '',10
                        db  ' ~~~~~~~~~~~~~~~~~',10
                        db  ' | %s A jugar %s |',10
                        db  ' ~~~~~~~~~~~~~~~~~',10
                        db  '',10,0

    msjEmojis           db  '~ Seleccioná el estilo de emojis:',10
                        db  '1. Zorro: 🦊 | Ocas: 🦢',10
                        db  '2. Zorro: 🐒 | Ocas: 🍌',10
                        db  '3. Zorro: 🐈 | Ocas: 🐀',10
                        db  'Opción: ',0

    msjTablero          db  '~ Elegí la orientación del tablero:',10
                        db  '1. Arriba',10
                        db  '2. Derecha',10
                        db  '3. Abajo',10
                        db  '4. Izquierda',10
                        db  'Opción: ',0

    iconosZorro         db  '🦊','🐒','🐈',0
    iconosOca           db  '🦢','🍌','🐀',0

    zorroSeleccionado   db  '🦊',0
    ocaSeleccionada     db  '🦢',0

    tableroArriba       db  '-','-','-','-','-','-','-','-','-',
                        db  '-','-','-','O','O','O','-','-','-',
                        db  '-','-','-','O','O','O','-','-','-',
                        db  '-','O','O','O','O','O','O','O','-',
                        db  '-','O',' ',' ',' ',' ',' ','O','-',
                        db  '-','O',' ',' ','X',' ',' ','O','-',
                        db  '-','-','-',' ',' ',' ','-','-','-',
                        db  '-','-','-',' ',' ',' ','-','-','-',
                        db  '-','-','-','-','-','-','-','-','-'

    tableroDerecha      db  '-','-','-','-','-','-','-','-','-',
                        db  '-','-','-','O','O','O','-','-','-',
                        db  '-','-','-',' ',' ','O','-','-','-',
                        db  '-',' ',' ',' ',' ','O','O','O','-',
                        db  '-',' ',' ','X',' ','O','O','O','-',
                        db  '-',' ',' ',' ',' ','O','O','O','-',
                        db  '-','-','-',' ',' ','O','-','-','-',
                        db  '-','-','-','O','O','O','-','-','-',
                        db  '-','-','-','-','-','-','-','-','-'

    tableroAbajo        db  '-','-','-','-','-','-','-','-','-',
                        db  '-','-','-',' ',' ',' ','-','-','-',
                        db  '-','-','-',' ',' ',' ','-','-','-',
                        db  '-','O',' ',' ','X',' ',' ','O','-',
                        db  '-','O',' ',' ',' ',' ',' ','O','-',
                        db  '-','O','O','O','O','O','O','O','-',
                        db  '-','-','-','O','O','O','-','-','-',
                        db  '-','-','-','O','O','O','-','-','-',
                        db  '-','-','-','-','-','-','-','-','-'

    tableroIzquierda    db  '-','-','-','-','-','-','-','-','-',
                        db  '-','-','-','O','O','O','-','-','-',
                        db  '-','-','-','O',' ',' ','-','-','-',
                        db  '-','O','O','O',' ',' ',' ',' ','-',
                        db  '-','O','O','O',' ','X',' ',' ','-',
                        db  '-','O','O','O',' ',' ',' ',' ','-',
                        db  '-','-','-','O',' ',' ','-','-','-',
                        db  '-','-','-','O','O','O','-','-','-',
                        db  '-','-','-','-','-','-','-','-','-'

    tableroPrueba       db  '-','-','-','-','-','-','-','-','-',
                        db  '-','-','-',' ',' ',' ','-','-','-',
                        db  '-','-','-',' ','O',' ','-','-','-',
                        db  '-',' ','O',' ',' ',' ','O',' ','-',
                        db  '-',' ',' ',' ','O',' ',' ',' ','-',
                        db  '-',' ',' ','O','X','O',' ',' ','-',
                        db  '-','-','-',' ','O',' ','-','-','-',
                        db  '-','-','-',' ',' ',' ','-','-','-',
                        db  '-','-','-','-','-','-','-','-','-'

    formatoOpcion       db  '%hi',0
    movimientos         db  48,48,48,48,48,48,48,48
    direccion           db  48

section .bss
    OpcionPerso         resb 1

    OpcionEmojis        resb 1
    OpcionTablero       resb 1

    OpcionValida        resb 1 
    
section .text

config_jugadores:
    lea         r12,[movimientos]

desea_configurar:
    mov         rdi,msjPersonalizar
    imprimir
    leerInput OpcionPerso

validar_opcion_perso:
    mov         rdi,OpcionPerso
 
    cmp         word[OpcionPerso],'s'
    je          config_emojis
    cmp         word[OpcionPerso],'n'
    je          config_predeterminada

    mov         rdi, msjErrorPerso
    imprimir
    jmp         desea_configurar
    
config_emojis:
    mov         rdi,msjPersoOK
    imprimir

    mov         rdi, msjEmojis
    imprimir
    leerInput OpcionEmojis

    sub         rsp,8
    call        validar_opcion_emojis 
    add         rsp,8

    cmp         byte [OpcionValida], 'S'
    je          emojis_seleccionados

    mov         rdi, msjErrorEmoji
    imprimir

    jmp         config_emojis

validar_opcion_emojis:
    mov         byte[OpcionValida],'N'

    mov         rdi,OpcionEmojis
    mov         rsi,formatoOpcion
    mov         rdx,OpcionEmojis
    
    sub		    rsp,8
	call	    sscanf
	add		    rsp,8    

    cmp         rax,1
    jne         invalido

    cmp         word[OpcionEmojis],1
    jl          invalido
    cmp         word[OpcionEmojis],3
    jg          invalido

    mov         byte[OpcionValida],'S'
    ret

emojis_seleccionados:
    movzx       eax,byte[OpcionEmojis]
    dec         eax
    imul        eax, eax, 4

    lea         rsi, [iconosZorro + rax]
    lea         rdi, [zorroSeleccionado]
    mov         ecx, 4      
    rep movsb
    
    lea         rsi, [iconosOca + rax]
    lea         rdi, [ocaSeleccionada]
    mov         ecx, 4
    rep movsb

config_tablero:
    mov         rdi, msjTablero
    imprimir
    leerInput OpcionTablero

    sub         rsp,8
    call        validar_opcion_tablero
    add         rsp,8

    cmp         byte [OpcionValida], 'S'
    je          tablero_seleccionado

    mov         rdi, msjErrorTablero
    imprimir

    jmp         config_tablero

validar_opcion_tablero:
    mov         byte[OpcionValida],'N'

    mov         rdi,OpcionTablero
    mov         rsi,formatoOpcion
    mov         rdx,OpcionTablero
    
    sub		    rsp,8
	call	    sscanf
	add		    rsp,8

    cmp         rax,1
    jne         invalido

    cmp         word[OpcionTablero],1
    je          orientacion_arriba
    cmp         word[OpcionTablero],2
    je          orientacion_derecha
    cmp         word[OpcionTablero],3
    je          orientacion_abajo
    cmp         word[OpcionTablero],4
    je          orientacion_izquierda
    
    ret

tablero_seleccionado:
    mov         rdi,msjPartidaOK
    imprimir
    
    jmp terminar_config
    
orientacion_arriba:
    mov         byte[OpcionValida],'S'
    mov         r15, tableroArriba
    mov         byte[direccion], 48
    ret

orientacion_derecha:
    mov         byte[OpcionValida],'S'
    mov         r15, tableroDerecha
    mov         byte[direccion], 58
    ret

orientacion_abajo:
    mov         byte[OpcionValida],'S'
    mov         r15, tableroAbajo
    mov         byte[direccion], 66
    ret

orientacion_izquierda:
    mov         byte[OpcionValida],'S'
    mov         r15, tableroIzquierda
    mov         byte[direccion], 56
    ret

config_predeterminada:
    mov         r15, tableroArriba
    mov         rdi, msjPersoDefault
    imprimir

terminar_config:
    mov         r13, zorroSeleccionado
    mov         r14, ocaSeleccionada

    mov         rdi, msjFinal
    mov         rsi, zorroSeleccionado
    mov         rdx, ocaSeleccionada
    imprimir

    ret

invalido:
    ret