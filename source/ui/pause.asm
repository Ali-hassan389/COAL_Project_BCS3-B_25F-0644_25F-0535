str_paused  db 'P A U S E D', 0
str_resume  db 'Press P to resume', 0

; Ye pause screen draw karti hai aur pause se resume ya quit ka input leti hai.
screen_pause:
    push ax
    push bx
    push cx
    push dx
    push si

    call grab_screen                    ;
    mov byte [cs:frColor], Color_White
    mov ax, 60
    mov bx, 62
    mov cx, 200
    mov dx, 64
    call draw_frame
    mov byte [cs:frColor], Color_Black
    mov ax, 62
    mov bx, 64
    mov cx, 196
    mov dx, 60
    call fill_rect

    mov si, str_paused
    mov bx, 74
    mov cl, 3
    mov dl, Color_Yellow
    call draw_text_center

    mov si, str_resume
    mov bx, 104
    mov cl, 2
    mov dl, Color_White
    call draw_text_center

    call present_screen
.sp_up:
    cmp byte [cs:keyp], 1
    je near .sp_up
.sp_wait:
    cmp byte [cs:quitflag], 1
    je near .sp_out
    cmp byte [cs:keyp], 1
    jne near .sp_wait
.sp_rel:
    cmp byte [cs:keyp], 1
    je near .sp_rel
.sp_out:

    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
