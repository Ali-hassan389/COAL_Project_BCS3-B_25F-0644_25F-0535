str_gameover  db 'G A M E   O V E R', 0
str_finalsc   db 'FINAL SCORE: ', 0
str_goCoins   db 'COINS: ', 0
str_goTime    db 'TIME: ', 0
str_goHint    db 'PRESS ENTER FOR THE TITLE', 0

;Ye game over screen display karti hai aur title par return ka wait karti hai.
screen_game_over:
    push ax
    push bx
    push cx
    push dx
    push si

    mov al, Color_Black
    call clear_buffer

    mov byte [cs:frColor], Color_LightRed
    mov ax, 10
    mov bx, 10
    mov cx, 300
    mov dx, 180
    call draw_frame

    mov si, str_gameover
    mov bx, 45
    mov cl, 3
    mov dl, Color_LightRed
    call draw_text_center

    ; Final Score: 001250
    mov si, str_finalsc
    mov ax, 84
    mov bx, 95
    mov cl, 2
    mov dl, Color_White
    call draw_text
    mov ax, [cs:scoreLo]
    mov dx, [cs:scoreHi]
    mov cl, 6
    call fmt_dec
    call draw_text_cont

    mov si, str_goCoins
    mov ax, 52
    mov bx, 125
    mov cl, 2
    mov dl, Color_Yellow
    call draw_text
    xor ah, ah
    mov al, [cs:coins]
    xor dx, dx
    mov cl, 1
    call fmt_dec
    call draw_text_cont

    mov si, str_goTime
    mov ax, 176
    mov bx, 125
    mov cl, 2
    mov dl, Color_Yellow
    call draw_text
    mov ax, [cs:timeLeft]
    xor dx, dx
    mov cl, 3
    call fmt_dec
    call draw_text_cont

    mov si, str_goHint
    mov bx, 160
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
