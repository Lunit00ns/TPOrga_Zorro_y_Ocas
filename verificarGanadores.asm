global vericar_ganadores

extern  pos_zorro, gano_Zorro, gano_Oca, turno

%macro ifDosParametros 2
    cmp %1, %2
    jg bucle_externo     ; Salta a bucle_externo si %1 > %2
    jl aumenta_externo   ; Salta a aumenta_externo si %1 < %2
    je bucle_externo     ; Salta a bucle_externo si %1 == %2
%endmacro

section .data
ocasComidas         db  0
zorro               db  0
contador_apariciones    db 0
section .bss
section .text

vericar_ganadores:
call ganador_zorro

ganador_zorro:
    mov     rdx, -1
    mov     r8,r15
    call hayOcas

hayOcas:
    inc     rdx
    cmp     rdx,81
    je      comparacion_ocas
    add     r8,rdx
    cmp     r8,'O'
    je      aumentaOcas
    

aumentaOcas:
    mov     rax,ocasComidas
    add     rax,1
    mov     [ocasComidas],rax
    call    hayOcas

comparacion_ocas:
    cmp         byte[ocasComidas],0
    je          gano_Zorro
    call        ganador_oca
    
ganador_oca:
    call    turno
;     sub     rsp, 8
;     call pos_zorro       ; rcx(col), rbx(fil)
;     add     rsp,8

;     dec rbx
;     imul rbx, rbx, 9
;     dec rcx
;     add rbx, rcx
    
;     sub rbx,10
;     call    bucle_cuadrado
    


; bucle_cuadrado:

;     mov     r8,[r15 + rbx]
;     inc     rbx
;     cmp     r8,'O'
;     je      incrementa
;     cmp     r8,'-'
;     je      incrementa
;     ;si no hay pared y oca a donde va 

; incrementa:
;     inc     byte[contador_apariciones]

;     cmp     byte[contador_apariciones],3
;     je      incrementar_rbx_en_7 ;llego a la iesquina superio derecha

;     cmp     byte[contador_apariciones],4
;     je      incrementar_rbx_en_1 ;salta para no contar el zorro

;     cmp     byte[contador_apariciones],5  ;va a la final de abajo
;     je      incrementar_rbx_en_7

;     cmp     byte[contador_apariciones],8
;     je      comparacion_externa  ;termino

;     call    bucle_cuadrado  ;no termino de revisar el cuadrado

; incrementar_rbx_en_7:
;     add     rbx,7
;     call    bucle_cuadrado

; incrementar_rbx_en_1:
;     inc     rbx
;     call    bucle_cuadrado


;  comparacion_externa:
;     sub     rsp, 8
;     call pos_zorro       ; rcx(col), rbx(fil)
;     add     rsp,8

;     dec rbx
;     imul rbx, rbx, 9
;     dec rcx
;     add rbx, rcx

;     mov [zorro], rbx   ;gurdo pocion
    
;     sub rbx,18
    
;     ifDosParametros byte[rbx], 0

; bucle_externo:
;     mov     r8,[r15 + rbx]
;     cmp     r8,'O'
;     je      aumenta_externo
;     cmp     r8,'-'
;     je      aumenta_externo
;     ;si no hay pared y oca a donde va 

; aumenta_externo:
;     cmp     rdx,[zorro - 18]    ;arriba
;     je      incrementar_rbx_en_16
;     cmp     rdx,[zorro - 2]     ;izquierda
;     je      incrementar_rbx_en_4
;     cmp     rdx,[zorro + 2]     ;derecha
;     je      incrementar_rbx_en_16
;     cmp     rdx,[zorro + 18]    ;abajo
;     je      gano_Oca    ;exito gano oca

; incrementar_rbx_en_16:
;     add     rdx,16
;     call    bucle_externo

; incrementar_rbx_en_4:
;     add     rdx,4
;     call    bucle_externo

