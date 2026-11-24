shroomActive  db 0               ; 0 = Inactive, 1 = Emerging, 2 = Walking
shroomX       dw Block1X
shroomY       dw Block1Y
shroomTop     dw Block1Y - 16    
shroomVelX    dw 1

ShroomWorldMax equ 800           
shroom_floors:
    dw Block1X,           Block1X + 16,        Block1Y - 16     
    dw Pipe1X,            Pipe1X + PipeSize,   Pipe1Y - 16     
    dw Pipe2X,            Pipe2X + PipeSize,   Pipe2Y - 16
    dw IslandBrick1X,     IslandBrick2X + 16,  IslandFloatY - 16 
    dw 0,                 Pit1X,               130             
    dw Pit1End,           Pit2X,               130
    dw Pit2X + Pit2Width, Pit3X,               130
    dw Pit3X + Pit3Width, 1000,                130
ShroomFloorCount equ 8

;Ye mushroom power-up ko active karke uski initial position set karti hai.
spawn_shroom:                    
    push bx
    push cx
    mov bx, Block1X
    mov cx, Block1Y
    call spawn_shroom_at
    pop cx
    pop bx
    ret

; Ye specified position par mushroom power-up spawn karti hai.
spawn_shroom_at:
    cmp byte [cs:shroomActive], 0
    jne near .ss_done            
    mov byte [cs:shroomActive], 1
    mov [cs:shroomX], bx
    mov [cs:shroomY], cx
    sub cx, 16
    mov [cs:shroomTop], cx
    mov word [cs:shroomVelX], 1
.ss_done:
    ret

;Ye mushroom ki movement/state update karke uska sprite draw karti hai.
update_and_draw_shroom:
    cmp byte [cs:shroomActive], 0
    jne near .active
    ret

.active:
    cmp byte [cs:shroomActive], 1
    jne near .phase_move

    ;  PHASE 1: EMERGING OUT OF THE BLOCK 
    dec word [cs:shroomY]
    mov ax, [cs:shroomY]
    cmp ax, [cs:shroomTop]
    jg near .render
    mov byte [cs:shroomActive], 2
    jmp near .render

    ; PHASE 2: WALK + GRAVITY 
.phase_move:
    mov ax, [cs:shroomX]
    mov dx, ax                      
    add ax, [cs:shroomVelX]
    cmp ax, 4
    jg near .not_left
    mov word [cs:shroomVelX], 1
    mov ax, dx
.not_left:
    cmp ax, ShroomWorldMax
    jl near .not_right
    mov word [cs:shroomVelX], -1
    mov ax, dx
.not_right:
    cmp word [cs:shroomY], Pipe1Y - 15
    jl near .no_pipes
    mov bx, ax
    add bx, 16
    cmp bx, Pipe1X
    jle near .p2
    cmp ax, Pipe1X + PipeSize
    jge near .p2
    jmp near .hit_wall
.p2:
    cmp bx, Pipe2X
    jle near .no_pipes
    cmp ax, Pipe2X + PipeSize
    jge near .no_pipes
.hit_wall:
    neg word [cs:shroomVelX]
    mov ax, dx
.no_pipes:
    mov [cs:shroomX], ax

    
    mov si, shroom_floors
    mov cx, ShroomFloorCount
    mov di, 1000                     
.floor_loop:
    mov bx, [cs:shroomX]
    add bx, 16
    cmp bx, [cs:si]                 
    jle near .floor_next
    mov bx, [cs:shroomX]
    cmp bx, [cs:si+2]                
    jge near .floor_next
    mov bx, [cs:si+4]
    mov ax, [cs:shroomY]
    sub ax, 2
    cmp bx, ax
    jl near .floor_next             
    cmp bx, di
    jge near .floor_next
    mov di, bx
.floor_next:
    add si, 6
    dec cx
    jnz near .floor_loop

    mov ax, [cs:shroomY]
    cmp ax, di
    jge near .snap
    add ax, 2
    cmp ax, di
    jle near .store_y
.snap:
    cmp di, 1000
    je near .store_y                 
    mov ax, di
.store_y:
    mov [cs:shroomY], ax
    cmp ax, 180
    jl near .check_col
    mov byte [cs:shroomActive], 0    
    ret

.check_col:
    call check_mario_shroom_collision
    cmp byte [cs:shroomActive], 0
    je near .done

.render:
    mov ax, [cs:shroomX]
    sub ax, [cameraX]
    cmp ax, 0
    jl near .done
    cmp ax, 304
    jg near .done
    push ax
    push word [cs:shroomY]
    call near DrawShroomSprite
.done:
    ret

; Ye Mario aur mushroom ki collision check karke power-up apply karti hai.
check_mario_shroom_collision:
    mov ax, [marioX]
    add ax, [marioW]
    cmp ax, [cs:shroomX]
    jl near .nocol

    mov ax, [marioX]
    mov bx, [cs:shroomX]
    add bx, 16
    cmp ax, bx
    jg near .nocol

    mov ax, [marioY]
    add ax, [marioH]
    cmp ax, [cs:shroomY]
    jl near .nocol

    mov ax, [marioY]
    mov bx, [cs:shroomY]
    add bx, 16
    cmp ax, bx
    jg near .nocol

    ; CONSUME MUSHROOM -> GROW TO SUPER MARIO!
    mov byte [cs:shroomActive], 0
    call award_mushroom            
    cmp byte [cs:isSuperMario], 1
    je near .nocol                 
    mov byte [cs:isSuperMario], 1
    mov word [marioH], 32
    sub word [marioY], 16

.nocol:
    ret
