Coin2Count equ 17
coin2_data:
    ; 2 in the first goomba path 
    dw 224, 128
    dw 240, 128
    ; 3 in the sky over pit 1 
    dw 264, 96
    dw 288, 84
    dw 312, 96
    ;  1 on the top platform (the upper "?" block) 
    dw 160, 32
    ; 2 between the pipes (raised: jump to grab them) 
    dw 410, 96
    dw 434, 96
    ;  3 in the sky over pit 2 
    dw 548, 96
    dw 572, 84
    dw 596, 96
    ; 2 on the ground under the block row 
    dw 672, 128
    dw 696, 128
    ;  1 on top of EACH staircase column 
    dw 816, 114
    dw 832, 98
    dw 848, 82
    dw 864, 66

coin2_got   times Coin2Count db 0   


;Ye subroutine doosray coin group ke records ko level start wali state par reset karti hai.
coin2_reset:
    push ax
    push cx
    push di
    push es
    push cs
    pop es
    mov di, coin2_got
    mov cx, Coin2Count
    xor al, al
    cld
    rep stosb
    pop es
    pop di
    pop cx
    pop ax
    ret

;Ye subroutine doosray coin group ki state update karke coins ko draw karti hai.
update_and_draw_coin2:
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    push bp

    mov si, coin2_data
    mov di, coin2_got
    mov bp, Coin2Count
.c2_loop:
    cmp byte [cs:di], 0
    jne near .c2_next                  

    mov ax, [marioX]
    add ax, [marioW]
    mov bx, [cs:si]
    add bx, 3
    cmp ax, bx
    jl near .c2_draw
    mov ax, [marioX]
    mov bx, [cs:si]
    add bx, 13
    cmp ax, bx
    jg near .c2_draw
    mov ax, [marioY]
    add ax, [marioH]
    mov bx, [cs:si+2]
    add bx, 1
    cmp ax, bx
    jl near .c2_draw
    mov ax, [marioY]
    mov bx, [cs:si+2]
    add bx, 15
    cmp ax, bx
    jg near .c2_draw

    mov byte [cs:di], 1                
    mov bx, [cs:si]
    mov cx, [cs:si+2]
    add cx, 16                         
    call award_coin                    
    jmp near .c2_next

.c2_draw:
    mov ax, [cs:si]
    sub ax, [cameraX]                    
    cmp ax, 0
    jl near .c2_next                    
    cmp ax, 304
    jg near .c2_next                   
    push ax
    push word [cs:si+2]
    call DrawCoinSprite

.c2_next:
    add si, 4
    inc di
    dec bp
    jnz near .c2_loop

    pop bp
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
