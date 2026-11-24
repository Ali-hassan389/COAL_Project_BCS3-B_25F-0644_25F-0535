timeLeft    dw StartTime         
timeLast    dw 0                  
timeAcc     dw 0                 

lbl_score   db 'SCORE', 0
lbl_coins   db 'COINS', 0
lbl_world   db 'WORLD', 0
lbl_time    db 'TIME', 0
lbl_lives   db 'LIVES', 0
lbl_health  db 'HEALTH', 0
txt_world   db '1-1', 0
txt_mult    db '*', 0

heart_bits:
    dw 0C6h, 1EFh, 1FFh, 1FFh, 0FEh, 07Ch, 038h, 010h

; Ye heart/health icon ka bitmap screen par draw karti hai.
draw_heart:
    push ax
    push cx
    push dx
    push si
    push di
    push es
    mov es, [cs:bufferSeg]
    mov si, heart_bits
    mov dh, 8
.hr_row:
    mov ax, [cs:si]
    add si, 2
    mov cx, 100h
    push di
.hr_col:
    test ax, cx
    jz near .hr_skip
    mov [es:di], bl
.hr_skip:
    inc di
    shr cx, 1
    jnz near .hr_col
    pop di
    add di, 320
    dec dh
    jnz near .hr_row
    pop es
    pop di
    pop si
    pop dx
    pop cx
    pop ax
    ret

;Ye top HUD draw karti hai jisme score, coins, world, time, lives aur health show hoti hai.
draw_hud:
    push ax
    push bx
    push cx
    push dx
    push si
    push di

    mov byte [cs:frColor], Color_Black
    xor ax, ax
    xor bx, bx
    mov cx, 320
    mov dx, HudHeight
    call fill_rect
    mov cl, 1
    mov dl, Color_Yellow
    mov bx, 3
    mov si, lbl_score
    mov ax, 6
    call draw_text
    mov si, lbl_coins
    mov ax, 62
    call draw_text
    mov si, lbl_world
    mov ax, 104
    call draw_text
    mov si, lbl_time
    mov ax, 148
    call draw_text
    mov si, lbl_lives
    mov ax, 190
    call draw_text
    mov si, lbl_health
    mov ax, 240
    call draw_text

    mov bx, 10
    mov cl, 2
    mov dl, Color_White

    mov ax, [cs:scoreLo]               
    mov dx, [cs:scoreHi]
    push cx
    mov cl, 6
    call fmt_dec
    pop cx
    mov dl, Color_White
    mov ax, 6
    call draw_text

    mov si, txt_mult                    
    mov ax, 62
    call draw_text
    xor ah, ah
    mov al, [cs:coins]
    xor dx, dx
    push cx
    mov cl, 2
    call fmt_dec
    pop cx
    mov dl, Color_White
    call draw_text_cont

    mov si, txt_world                   
    mov ax, 104
    call draw_text

    mov ax, [cs:timeLeft]               
    xor dx, dx
    push cx
    mov cl, 3
    call fmt_dec
    pop cx
    mov dl, Color_White
    mov ax, 148
    call draw_text

    mov si, txt_mult                    
    mov ax, 190
    call draw_text
    xor ah, ah
    mov al, [cs:lives]
    xor dx, dx
    push cx
    mov cl, 1
    call fmt_dec
    pop cx
    mov dl, Color_White
    call draw_text_cont

    mov bl, Color_Red
    mov di, 11 * 320 + 240
    call draw_heart
    mov bl, Color_Grey
    cmp byte [cs:isSuperMario], 1
    jne near .hd_second
    mov bl, Color_Red
.hd_second:
    mov di, 11 * 320 + 253
    call draw_heart

    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret


;Ye game timer ka reference tick current tick par set karti hai taake pause/resume ke baad timing sahi rahe.
timer_resync:
    push ax
    mov ax, [cs:tickCount]
    mov [cs:timeLast], ax
    mov word [cs:timeAcc], 0
    pop ax
    ret

;Ye elapsed ticks ko seconds/timer units mein convert karke timeLeft kam karti hai; time zero par death trigger hoti hai.
timer_update:
    push ax
    push cx
    mov ax, [cs:tickCount]
    mov cx, ax
    sub ax, [cs:timeLast]               
    mov [cs:timeLast], cx
    cmp byte [cs:flagDown], 1
    je near .tu_done                    
    cmp ax, 100
    jbe near .tu_ok
    xor ax, ax                          
.tu_ok:
    add [cs:timeAcc], ax
.tu_tick:
    cmp word [cs:timeAcc], TimerHz      
    jb near .tu_done
    sub word [cs:timeAcc], TimerHz
    cmp word [cs:timeLeft], 0
    je near .tu_tick
    dec word [cs:timeLeft]
    jnz near .tu_tick
    mov byte [cs:deathPending], 1      
    jmp near .tu_tick
.tu_done:
    pop cx
    pop ax
    ret
