G_ACTIVE equ 0
G_X equ 2
G_Y equ 4
G_DIR equ 6
G_SPEED equ 8
G_TIMER equ 10
G_MINX equ 12
G_MAXX equ 14
G_SIZE equ 16

goomba_data:
goomba1: db 1,0
    dw 200,130
    db 1,0
    dw 1,0,16,240
goomba2: db 1,0
    dw 100,130
    db 0,0
    dw 1,0,16,240
goomba3: db 1,0
    dw 424,130
    db 0,0
    dw 1,0,Pipe1X + PipeSize,Pipe2X - 16
goomba4: db 1,0
    dw 640,130
    db 0,0
    dw 1,0,RowMinX,RowMaxX

goombaActive equ goomba1 + G_ACTIVE
goombaX equ goomba1 + G_X
goombaY equ goomba1 + G_Y
goombaDir equ goomba1 + G_DIR
goombaSpeed equ goomba1 + G_SPEED
squishTimer equ goomba1 + G_TIMER
goomba2Active equ goomba2 + G_ACTIVE
goomba2X equ goomba2 + G_X
goomba2Y equ goomba2 + G_Y
goomba2Dir equ goomba2 + G_DIR
goomba2Speed equ goomba2 + G_SPEED
squishTimer2 equ goomba2 + G_TIMER
goomba3Active equ goomba3 + G_ACTIVE
goomba3X equ goomba3 + G_X
goomba3Y equ goomba3 + G_Y
goomba3Dir equ goomba3 + G_DIR
goomba3Speed equ goomba3 + G_SPEED
squishTimer3 equ goomba3 + G_TIMER
goomba4Active equ goomba4 + G_ACTIVE
goomba4X equ goomba4 + G_X
goomba4Y equ goomba4 + G_Y
goomba4Dir equ goomba4 + G_DIR
goomba4Speed equ goomba4 + G_SPEED
squishTimer4 equ goomba4 + G_TIMER

;Ye pehle Goomba ko move, collision-check aur draw karti hai.
update_and_draw_goomba:
    mov si,goomba1
    call update_one_goomba
    ret
update_and_draw_goomba2:
    call goombas_bump_check
    mov si,goomba2
    call update_one_goomba
    ret
update_and_draw_goomba3:
    mov si,goomba3
    call update_one_goomba
    mov si,goomba4
    call update_one_goomba
    ret
update_one_goomba:
    push ax
    push bx
    push cx
    push dx
    push si
    cmp byte [cs:si+G_ACTIVE],0
    je near .done
    cmp byte [cs:si+G_ACTIVE],1
    jne near .state
    mov ax,[cs:si+G_X]
    sub ax,[cameraX]
    cmp ax,-32
    jg near .gate_right
    mov byte [cs:si+G_ACTIVE],0
    jmp near .done
.gate_right:
    cmp ax,ScreenWidth+16
    jl near .state
    jmp near .done
.state:
    cmp byte [cs:si+G_ACTIVE],2
    je near .squashed
    mov ax,[cs:si+G_X]
    cmp byte [cs:si+G_DIR],0
    je near .right
    sub ax,[cs:si+G_SPEED]
    cmp ax,[cs:si+G_MINX]
    jg near .store
    mov ax,[cs:si+G_MINX]
    mov byte [cs:si+G_DIR],0
    jmp near .store
.right:
    add ax,[cs:si+G_SPEED]
    cmp ax,[cs:si+G_MAXX]
    jl near .store
    mov ax,[cs:si+G_MAXX]
    mov byte [cs:si+G_DIR],1
.store:
    mov [cs:si+G_X],ax
    mov word [cs:si+G_Y],130
    call check_mario_goomba_generic
.render:
    xor ax,ax
    cmp byte [cs:si+G_ACTIVE],2
    jne near .draw
    inc word [cs:si+G_TIMER]
    cmp word [cs:si+G_TIMER],20
    jl near .draw
    mov byte [cs:si+G_ACTIVE],0
    jmp near .done
.draw:
    mov bx,[cs:si+G_X]
    sub bx,[cameraX]
    cmp bx,-16
    jle near .done
    cmp bx,ScreenWidth
    jge near .done
    xor ax,ax
    cmp byte [cs:si+G_ACTIVE],2
    jne near .call_draw
    inc ax
.call_draw:
    push bx
    push word [cs:si+G_Y]
    push ax
    call DrawGoombaSprite
.done:
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
.squashed:
    jmp near .render

goombas_bump_check:
    cmp byte [cs:goomba1+G_ACTIVE],1
    jne near .done
    cmp byte [cs:goomba2+G_ACTIVE],1
    jne near .done
    mov ax,[cs:goomba1+G_X]
    mov bx,[cs:goomba2+G_X]
    sub ax,bx
    jns near .abs
    neg ax
.abs:
    cmp ax,14
    jae near .done
    xor byte [cs:goomba1+G_DIR],1
    xor byte [cs:goomba2+G_DIR],1
    mov ax,[cs:goomba1+G_X]
    cmp ax,[cs:goomba2+G_X]
    jl near .left
    add word [cs:goomba1+G_X],3
    sub word [cs:goomba2+G_X],3
    ret
.left:
    sub word [cs:goomba1+G_X],3
    add word [cs:goomba2+G_X],3
.done:
    ret
check_mario_goomba_generic:
    mov ax,[marioX]
    add ax,[marioW]
    cmp ax,[cs:si+G_X]
    jl near .no
    mov ax,[marioX]
    mov bx,[cs:si+G_X]
    add bx,16
    cmp ax,bx
    jg near .no
    mov ax,[marioY]
    add ax,[marioH]
    cmp ax,[cs:si+G_Y]
    jl near .no
    mov ax,[marioY]
    mov bx,[cs:si+G_Y]
    add bx,16
    cmp ax,bx
    jg near .no
    cmp word [velocityY],0
    jg near .stomp
    cmp byte [cs:invincTimer],0
    jne near .no
    cmp byte [cs:stompGrace],0
    jne near .no
    cmp byte [cs:isSuperMario],1
    je near .shrink
    mov byte [cs:deathPending],1
    ret
.shrink:
    mov byte [cs:isSuperMario],0
    mov word [marioH],16
    add word [marioY],16
    mov byte [cs:invincTimer],60
    ret
.stomp:
    mov bx,[cs:si+G_X]
    mov cx,[cs:si+G_Y]
    call stomp_score
    mov word [velocityY],StompBounceSpeed
    mov byte [cs:si+G_ACTIVE],2
    mov word [cs:si+G_TIMER],0
.no:
    ret

check_mario_goomba_collision equ check_mario_goomba_generic
check_mario_goomba2_collision equ check_mario_goomba_generic
check_mario_goomba3_collision equ check_mario_goomba_generic
check_mario_goomba4_collision equ check_mario_goomba_generic
