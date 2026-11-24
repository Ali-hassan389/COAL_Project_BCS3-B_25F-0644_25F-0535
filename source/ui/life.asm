str_llWorld   db 'WORLD 1-1', 0
str_llMult    db '*', 0
str_llLeft    db 'LIVES LEFT', 0

life_mario_sprite:
%define c0 Color_Trans
%define c1 Color_LightRed
%define c2 Color_Dirt
%define c3 Color_Skin
%define c4 Color_Blue
%define c5 Color_Yellow

    db c0, c0, c0, c0, c1, c1, c1, c1, c1, c0, c0, c0, c0, c0, c0, c0, c0, c1, c1, c1, c1, c1, c1, c1, c1, c1, c0, c0
    db c0, c0, c0, c2, c2, c2, c3, c3, c2, c3, c0, c0, c0, c0, c0, c0, c2, c3, c2, c3, c3, c3, c2, c3, c3, c3, c0, c0
    db c0, c0, c2, c3, c2, c2, c3, c3, c3, c2, c3, c3, c3, c0, c0, c0, c2, c2, c3, c3, c3, c3, c2, c2, c2, c2, c0, c0
    db c0, c0, c0, c0, c3, c3, c3, c3, c3, c3, c3, c0, c0, c0, c0, c0, c0, c1, c1, c4, c1, c1, c1, c0, c0, c0, c0, c0
    db c0, c0, c1, c1, c1, c4, c1, c1, c4, c1, c1, c1, c0, c0, c0, c1, c1, c1, c1, c4, c4, c4, c4, c1, c1, c1, c1, c0
    db c0, c3, c3, c1, c4, c5, c4, c4, c5, c4, c1, c3, c3, c0, c0, c3, c3, c3, c4, c4, c4, c4, c4, c4, c3, c3, c3, c0
    db c0, c3, c3, c4, c4, c4, c4, c4, c4, c4, c4, c3, c3, c0, c0, c0, c0, c4, c4, c4, c0, c0, c4, c4, c4, c0, c0, c0
    db c0, c0, c2, c2, c2, c0, c0, c0, c0, c2, c2, c2, c0, c0, c0, c2, c2, c2, c2, c0, c0, c0, c0, c2, c2, c2, c2, c0
draw_life_mario:
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    push es

    mov es, [cs:bufferSeg]
    mov si, life_mario_sprite
    mov di, ax
    mov ax, bx
    mov dx, 320
    mul dx
    add di, ax                          
    xor ch, ch
    mov dh, 16
.lm_row:
    push di
    mov dl, 14
.lm_col:
    mov bl, [cs:si]
    inc si
    test bl, bl
    jz near .lm_skip
    call put_block
.lm_skip:
    add di, cx
    dec dl
    jnz near .lm_col
    pop di
    push dx
    mov ax, 320
    mul cx
    add di, ax
    pop dx
    dec dh
    jnz near .lm_row

    pop es
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret

; Ye life lost message/screen display karti hai aur user input ka wait karti hai.
screen_life_lost:
    push ax
    push bx
    push cx
    push dx
    push si

    mov al, Color_Black
    call clear_buffer

    mov si, str_llWorld
    mov bx, 30
    mov cl, 3
    mov dl, Color_White
    call draw_text_center

    mov ax, 96
    mov bx, 80
    mov cl, 2
    call draw_life_mario

    mov si, str_llMult                  
    mov ax, 150
    mov bx, 88
    mov cl, 4
    mov dl, Color_White
    call draw_text
    xor ah, ah
    mov al, [cs:lives]
    xor dx, dx
    mov cl, 1
    call fmt_dec
    mov ax, 190
    mov bx, 88
    mov cl, 4
    mov dl, Color_White
    call draw_text

    mov si, str_llLeft
    mov bx, 148
    mov cl, 2
    mov dl, Color_Yellow
    call draw_text_center

    call present_screen
    mov cx, 140                        
    call wait_retraces

    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
