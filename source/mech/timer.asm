tickCount   dw 0                
oldint8off  dw 0
oldint8seg  dw 0

; Ye timer interrupt install karti hai taake game ticks aur timing update hoti rahe.
installtimer:
    push ax
    push bx
    push dx
    push es

    mov ax, 3508h              
    int 21h
    mov [oldint8off], bx
    mov [oldint8seg], es

    cli
    mov dx, newint8handler      
    mov ax, 2508h
    int 21h

    mov al, 36h               
    out 43h, al
    mov ax, PitDivisor
    out 40h, al
    mov al, ah
    out 40h, al
    sti

    pop es
    pop dx
    pop bx
    pop ax
    ret

;Ye custom timer interrupt remove karke original timer handler restore karti hai.
uninstalltimer:
    push ax
    push dx
    push ds

    cli
    mov al, 36h
    out 43h, al
    xor al, al                 
    out 40h, al
    out 40h, al

    mov dx, [cs:oldint8off]
    mov ax, [cs:oldint8seg]
    mov ds, ax
    mov ax, 2508h
    int 21h
    sti

    pop ds
    pop dx
    pop ax
    ret

;Ye timer interrupt handler hai; tick count barhakar time based events ke liye clock provide karta hai.
newint8handler:
    inc word [cs:tickCount]
    jmp far [cs:oldint8off]    


;Ye timer tick ka wait karti hai taake game ki speed consistent rahe.
WaitTick:
    push ax
    mov ax, [cs:tickCount]
.wt_loop:
    hlt                         
    cmp ax, [cs:tickCount]
    je near .wt_loop
    pop ax
    ret
