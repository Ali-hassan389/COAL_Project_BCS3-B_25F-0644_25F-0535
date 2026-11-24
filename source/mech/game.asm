
deathPending db 0
levelDone    db 0
 
koopa1_init:
    db 1, 0
    dw Pipe1X + 8, Pipe1Y - 16, Pipe1X, Pipe1X + PipeSize - 16, 0, 0, 0
koopa2_init:
    db 1, 1
    dw 412, 130, Pipe1X + PipeSize, Pipe2X - 16, 0, 0, 0
koopa3_init:
    db 1, 1
    dw 700, 130, RowMinX, RowMaxX, 0, 0, Pit2X + Pit2Width

;Ye subroutine game ke background events update karti hai, jaise stomp grace timer aur game timer.
handle_game_events:
    cmp byte [cs:stompGrace], 0
    je near .no_grace
    dec byte [cs:stompGrace]
.no_grace:
    call timer_update
    ret

DeathHopSpeed equ 0FB00h            

bgSeg       dw 0                   
deathY      dw 0
deathFrac   dw 0
deathVel    dw 0

;Y subroutinee Mario ke marne ki animation chalati hai; background restore karke character ko jump/fall effect deti hai.
death_animation:
    push ax
    push bx
    push cx
    push si
    push di
    push ds
    push es
    mov ax, [cs:bufferSeg]
    mov ds, ax
    mov ax, [cs:bgSeg]
    mov es, ax
    xor si, si
    xor di, di
    mov cx, 16000
    cld
    rep movsd

    push cs
    pop ds
    mov byte [invincTimer], 0
    mov byte [marioFrame], 1         
    mov ax, [marioY]
    mov [deathY], ax
    mov word [deathFrac], 0
    mov word [deathVel], DeathHopSpeed

.da_frame:
    push ds
    mov ax, [cs:bgSeg]
    mov ds, ax
    mov es, [cs:bufferSeg]
    xor si, si
    xor di, di
    mov cx, 16000
    rep movsd
    pop ds

    mov ax, [deathY]
    cmp ax, 0
    jl near .da_nodraw
    mov bx, ax
    add bx, [marioH]
    cmp bx, ScreenHeight
    jg near .da_nodraw
    push word [screenX]
    push ax
    call DrawMarioSprite
.da_nodraw:
    call WaitTick
    call RenderBuffer

    mov ax, [deathFrac]
    add ax, [deathVel]
    mov bx, ax
    sar bx, 8
    and ax, 0FFh
    mov [deathFrac], ax
    add [deathY], bx
    add word [deathVel], 60h       
    cmp word [deathY], ScreenHeight
    jl near .da_frame

    pop es
    pop ds
    pop di
    pop si
    pop cx
    pop bx
    pop ax
    ret

; Ye subroutine new game initialize karti hai; score, lives, coins aur complete world state reset karti hai.
new_game_init:
    mov word [cs:scoreLo], 0
    mov word [cs:scoreHi], 0
    mov byte [cs:lives], 3
    mov byte [cs:coins], 0
    call reset_world_full
    ret

;Ye subroutine enemies, blocks, coins, timer aur level objects ko initial game state par reset karti hai.
reset_world_full:
    push cx
    push di
    push es
    mov byte [cs:goombaActive], 1
    mov word [cs:goombaY], 130
    mov byte [cs:goomba2Active], 1
    mov word [cs:goomba2Y], 130
    mov byte [cs:goomba3Active], 1
    mov word [cs:goomba3Y], 130
    mov byte [cs:goomba4Active], 1
    mov word [cs:goomba4Y], 130
    mov byte [cs:koopa1 + K_ACTIVE], 1
    mov byte [cs:koopa2 + K_ACTIVE], 1
    mov byte [cs:koopa3 + K_ACTIVE], 1
    mov byte [cs:block1Hit], 0
    mov byte [cs:block2Hit], 0
    mov byte [cs:block3Hit], 0
    mov byte [cs:block4Hit], 0
    mov byte [cs:brick1Hit], 0
    mov byte [cs:brick2Hit], 0
    mov byte [cs:brick3Hit], 0
    mov byte [cs:islandBrick1Hit], 0
    mov byte [cs:islandBrick2Hit], 0
    mov byte [cs:islandBlockHit], 0
    mov byte [cs:rowB1Hit], 0
    mov byte [cs:rowB2Hit], 0
    mov byte [cs:rowB3Hit], 0
    mov byte [cs:rowB4Hit], 0
    mov byte [cs:rowLHit], 0
    mov byte [cs:shroomActive], 0
    mov byte [cs:c1_Active], 0
    mov byte [cs:c2_Active], 0
    mov byte [cs:c3_Active], 0
    call coin2_reset
    mov word [cs:timeLeft], StartTime

    pop es
    pop di
    pop cx
    call reset_level_state
    ret

; Stack: [BP+4]=record, [BP+6]=initial X, [BP+8]=direction..
reset_one_goomba:
    push bp
    mov bp,sp
    push si
    mov si,[bp+4]
    cmp byte [cs:si+G_ACTIVE],1
    jne near .dead
    cmp word [cs:si+G_Y],130
    jne near .dead
    mov ax,[bp+6]
    mov [cs:si+G_X],ax
    mov al,[bp+8]
    mov [cs:si+G_DIR],al
    jmp short .done
.dead:
    mov byte [cs:si+G_ACTIVE],0
.done:
    pop si
    pop bp
    ret 6

; Stack: [BP+4]=record, [BP+6]=initial record.
reset_one_koopa:
    push bp
    mov bp,sp
    push ax
    push cx
    push si
    push di
    mov di,[bp+4]
    mov al,[cs:di+K_ACTIVE]
    test al,al
    jz near .dead
    cmp al,4
    je near .dead
    mov si,[bp+6]
    mov cx,16
    rep movsb
    jmp short .done
.dead:
    mov byte [cs:di+K_ACTIVE],0
.done:
    pop di
    pop si
    pop cx
    pop ax
    pop bp
    ret 4

reset_level_state:
    push ax
    push cx
    push si
    push di
    push ds
    push es

    mov word [cs:marioX], 32         
    mov word [cs:marioXFrac], 0
    mov word [cs:marioYFrac], 0
    mov word [cs:velX], 0
    mov byte [cs:winPhase], 0
    mov word [cs:marioY], 130
    mov word [cs:marioH], TileSize
    mov word [cs:velocityY], 0
    mov word [cs:isJumping], 0
    mov byte [cs:isSuperMario], 0
    mov byte [cs:invincTimer], 0
    mov word [cameraX], 0
    push 1
    push 200
    push goomba1
    call reset_one_goomba
    push 0
    push 100
    push goomba2
    call reset_one_goomba
    push 0
    push 424
    push goomba3
    call reset_one_goomba
    push 0
    push 640
    push goomba4
    call reset_one_goomba

    push cs
    pop ds
    push cs
    pop es
    cld

    push koopa1
    push koopa1_init
    call reset_one_koopa
    push koopa2
    push koopa2_init
    call reset_one_koopa
    push koopa3
    push koopa3_init
    call reset_one_koopa

    mov byte [cs:flagDown], 0
    mov word [cs:flagY], FlagStartY
    mov byte [cs:stompChain], 0
    mov di, popups
    mov cx, POPUP_COUNT * 8
    xor al, al
    rep stosb
    mov byte [cs:deathPending], 0
    mov byte [cs:levelDone], 0
    call timer_resync

    pop es
    pop ds
    pop di
    pop si
    pop cx
    pop ax
    ret
