global config_jugadores
extern printf, sscanf, puts
extern gets

%macro imprimir 0
    xor rax, rax
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
    msjNombreJugador1   db  'Ingresá el nombre del Jugador 1 - Zorro: ',0
    msjNombreJugador2   db  'Ingresá el nombre del Jugador 2 - Ocas: ',0

    msjEmojis           db  'Seleccioná el estilo de emojis:',10
                        db  '1. Zorro: 🦊 | Ocas: 🦢',10
                        db  '2. Zorro: 🐒 | Ocas: 🍌',10
                        db  '3. Zorro: 🐈 | Ocas: 🐀',10
                        db  'Opción: ',0

    formatoOpcion       db  '%hi',0
    msjErrorEmoji       db  'Opción inválida. Ingresá un número entre 1 y 3',10,0
    iconosZorro         db  '🦊','🐒','🐈',0
    iconosOca           db  '🦢','🍌','🐀',0

    zorroSeleccionado   db   0, 0, 0, 0, 0
    ocaSeleccionada     db   0, 0, 0, 0, 0 

    msjJugadoresOK      db  'Personalización de jugadores correcta! %s será el Zorro %s y %s jugará con las Ocas %s',10,0
    
    msjPartidaOK        db  'La partida fue configurada correctamente!',10
                        db  '',10
                        db  ' ~~~~~~~~~~~~~~~~~',10
                        db  ' | %s A jugar %s |',10
                        db  ' ~~~~~~~~~~~~~~~~~',10
                        db  '',10,0

section .bss
    Jugador1            resb 256
    Jugador2            resb 256

    OpcionEmojis        resb 1
    OpcionValida        resb 1 

    OpcionTablero       resb 1
    OpcionValidaTablero resb 1        
    
section .text

config_jugadores:
    mov		    rdi,msjNombreJugador1
    imprimir
    mov		    rdi,Jugador1	
    leerInput

    mov		    rdi,msjNombreJugador2
    imprimir
    mov		    rdi,Jugador2	
    leerInput

config_emojis:
    mov         rdi, msjEmojis
    imprimir
    mov         rdi, OpcionEmojis
    leerInput

    sub         rsp,8
    call        validar_opcion 
    add         rsp,8

    cmp         byte [OpcionValida], 'S'
    je          emojis_seleccionados

    mov         rdi, msjErrorEmoji
    imprimir

    jmp         config_emojis

validar_opcion:
    mov         byte[OpcionValida],'N'

    mov         rdi,OpcionEmojis
    mov         rsi,formatoOpcion
    mov         rdx,OpcionEmojis
    
    sub		    rsp,8
	call	    sscanf
	add		    rsp,8    

    cmp         rax,1
    jl          invalido

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

    mov         rdi, msjJugadoresOK
    mov         rsi, Jugador1
    mov         rdx, zorroSeleccionado
    mov         rcx, Jugador2
    mov         r8, ocaSeleccionada
    imprimir

mensajeFinal:
    mov         rdi, msjPartidaOK
    mov         rsi,zorroSeleccionado
    mov         rdx,ocaSeleccionada
    imprimir

    ret

invalido:
    ret