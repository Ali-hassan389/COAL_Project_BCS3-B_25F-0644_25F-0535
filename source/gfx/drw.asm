; ye subroutine bitmap bytes ko read karke sprite ko screen buffer par draw karti hai aur transparent color skip karti hai.
DrawBitmapSprite:
    push bp
    mov bp, sp
    sub sp, 12
    mov ax, [bp+14]
    mov [bp-2], ax          
    mov ax, [bp+4]
    mov [bp-4], ax         
    mov ax, [bp+6]
    mov [bp-6], ax         
    mov ax, [bp+8]
    mov [bp-8], ax          
    mov ax, [bp+10]
    mov [bp-10], ax         
    mov ax, [bp+12]
    mov [bp-12], ax         
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    push es
    push ds
    push cs
    pop ds
    mov si, [bp-2]
    mov es, [cs:bufferSeg]
    xor bx, bx             
.row:
    cmp bx, [bp-10]
    jge near .done
    mov ax, [bp-6]
    add ax, bx
    cmp ax, 0
    jl near .skip_row
    cmp ax, ScreenHeight
    jge near .done
    mov dx, 320
    mul dx
    add ax, [bp-4]
    mov di, ax
    mov cx, [bp-8]
    push di
.col:
    lodsb
    cmp word [bp-12], 256
    je near .write
    cmp al, byte [bp-12]
    je near .skip
.write:
    mov dx, [bp-8]
    sub dx, cx
    add dx, [bp-4]
    cmp dx, 0
    jl near .skip
    cmp dx, ScreenWidth-1
    jg near .skip
    mov [es:di], al
.skip:
    inc di
    loop .col
    pop di
    inc bx
    jmp near .row
.skip_row:
    mov ax, [bp-8]
    add si, ax
    inc bx
    jmp near .row
.done:
    pop ds
    pop es
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    add sp, 12
    pop bp
    ret 12
