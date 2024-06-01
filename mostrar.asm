global mostrar
extern puts

section .data
    renglon db "------------------", 10

section .text

mostrar:
    mov       rax, 1
    mov       rdi, 1
    mov       rsi, renglon
    mov       rdx, 19
    syscall

    mov       rax, 1
    mov       rdi, 1
    mov       rsi, r8
    mov       rdx, r9
    syscall

    mov       rax, 60
    xor       rdi, rdi
    syscall
    
    ; mov rdi,[renglon]
    ; sub rsp,8
    ; call puts
    ; add rsp,8
    ; ret

    ; mov rdi,r8
    ; sub rsp,8
    ; call puts
    ; add rsp,8
    