str_lcTitle   db 'LEVEL COMPLETE!', 0
str_lcScore   db 'SCORE', 0
str_lcCoins   db 'COINS', 0
str_lcTime    db 'TIME LEFT', 0
str_lcBonus   db 'TIME BONUS', 0
str_lcFinal   db 'FINAL SCORE', 0
str_lcTimes   db ' * 50 = ', 0
str_lcPlus    db '+ ', 0
str_lcHint    db 'PRESS ENTER TO CONTINUE', 0

lcSeconds   dw 0
lcBonus     dw 0
lcPreLo     dw 0
lcPreHi     dw 0

;Ye level complete screen display karti hai aur bonus/result show karti hai.
screen_level_complete:
    push ax
    push bx
    push cx
    push dx
    push si

    mov [cs:lcSeconds], ax
    mov ax, [cs:scoreLo]                
    mov [cs:lcPreLo], ax
    mov ax, [cs:scoreHi]
    mov [cs:lcPreHi], ax

    mov ax, [cs:lcSeconds]
    call award_time_bonus              
    mov ax, [cs:lcSeconds]
    mov cx, 50
    mul cx
    mov [cs:lcBonus], ax

    mov al, Color_Black
    call clear_buffer
    mov byte [cs:frColor], Color_Yellow
    mov ax, 10
    mov bx, 8
    mov cx, 300
    mov dx, 184
    call draw_frame

    mov si, str_lcTitle
    mov bx, 22
    mov cl, 3
    mov dl, Color_Yellow
    call draw_text_center

   
    mov ax, 36
    mov cl, 2
    mov dl, Color_White
    mov si, str_lcScore
    mov bx, 60
    call draw_text
    mov si, str_lcCoins
    mov bx, 80
    call draw_text
    mov si, str_lcTime
    mov bx, 100
    call draw_text
    mov si, str_lcBonus
    mov bx, 120
    call draw_text
    mov si, str_lcFinal
    mov bx, 140
    call draw_text

   
    mov ax, [cs:lcPreLo]
    mov dx, [cs:lcPreHi]
    mov cl, 6
    call fmt_dec
    mov ax, 156
    mov bx, 60
    mov cl, 2
    mov dl, Color_White
    call draw_text

    
    mov si, str_mult1
    mov ax, 156
    mov bx, 80
    call draw_text
    xor ah, ah
    mov al, [cs:coins]
    xor dx, dx
    mov cl, 1
    call fmt_dec
    call draw_text_cont
    mov ax, [cs:lcSeconds]
    xor dx, dx
    mov cl, 1
    call fmt_dec
    mov ax, 156
    mov bx, 100
    mov cl, 2
    mov dl, Color_White
    call draw_text
    mov si, str_lcTimes
    call draw_text_cont
    mov ax, [cs:lcBonus]
    xor dx, dx
    mov cl, 1
    call fmt_dec
    call draw_text_cont
    mov si, str_lcPlus
    mov ax, 156
    mov bx, 120
    mov cl, 2
    mov dl, Color_White
    call draw_text
    mov ax, [cs:lcBonus]
    xor dx, dx
    mov cl, 1
    call fmt_dec
    call draw_text_cont

    mov ax, [cs:scoreLo]
    mov dx, [cs:scoreHi]
    mov cl, 6
    call fmt_dec
    mov ax, 156
    mov bx, 140
    mov cl, 2
    mov dl, Color_Yellow
    call draw_text

    mov si, str_lcHint
    mov bx, 168
    mov cl, 2
    mov dl, Color_Grass
    call draw_text_center

    call present_screen
    mov al, Key_Enter
    call wait_key_press

    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret

str_mult1   db '* ', 0
