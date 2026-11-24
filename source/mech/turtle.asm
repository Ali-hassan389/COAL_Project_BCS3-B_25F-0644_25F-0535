KoopaWakeFrames  equ 175     
KoopaGraceFrames equ 8        
KoopaWalkSpeed   equ 1
KoopaSlideSpeed  equ 3


K_ACTIVE equ 0                
K_DIR    equ 1              
K_X      equ 2               
K_Y      equ 4              
K_MINX   equ 6                
K_MAXX   equ 8               
K_TIMER  equ 10               
K_GRACE  equ 12               
K_PITX   equ 14               
                              

; Turtle 1: walks on top of the LEFT pipe of the island
koopa1:
    db 1, 0
    dw Pipe1X + 8, Pipe1Y - 16, Pipe1X, Pipe1X + PipeSize - 16, 0, 0, 0

; Turtle 2: walks on the ground between the two pipes
koopa2:
    db 1, 1
    dw 412, 130, Pipe1X + PipeSize, Pipe2X - 16, 0, 0, 0

; Turtle 3: walks on the ground under the block row, after the 2nd pit
koopa3:
    db 1, 1
    dw 700, 130, RowMinX, RowMaxX, 0, 0, Pit2X + Pit2Width

; Ye Koopa ki movement, animation aur collision state update karke usay draw karti hai.
update_and_draw_koopa:
    push si
    mov si, koopa1
    call update_one_koopa
    mov si, koopa2
    call update_one_koopa
    mov si, koopa3
    call update_one_koopa
    pop si
    ret


;Ye ek Koopa ki movement aur direction boundaries ke mutabiq update karti hai.
update_one_koopa:
    cmp byte [cs:si+K_ACTIVE], 0
    je near .done

    mov ax, [cs:si+K_X]
    sub ax, [cameraX]
    cmp ax, -32
    jg near .act_right
    mov byte [cs:si+K_ACTIVE], 0
    ret
.act_right:
    cmp byte [cs:si+K_ACTIVE], 1
    jne near .activated
    cmp ax, ScreenWidth + 16
    jge near .done                  
.activated:

    cmp word [cs:si+K_GRACE], 0
    je near .state
    dec word [cs:si+K_GRACE]

.state:
    cmp byte [cs:si+K_ACTIVE], 4
    je near .shell_fall
    cmp byte [cs:si+K_ACTIVE], 5
    je near .shell_drop
    cmp byte [cs:si+K_ACTIVE], 1
    je near .walk
    cmp byte [cs:si+K_ACTIVE], 2
    je near .shell_idle
    jmp near .shell_slide

.walk:
    mov ax, [cs:si+K_X]
    cmp byte [cs:si+K_DIR], 0
    je near .walk_right
    sub ax, KoopaWalkSpeed
    jmp near .walk_clamp
.walk_right:
    add ax, KoopaWalkSpeed
.walk_clamp:
    call koopa_bounce
    jmp near .col

.shell_idle:
    inc word [cs:si+K_TIMER]
    cmp word [cs:si+K_TIMER], KoopaWakeFrames
    jl near .col
    mov byte [cs:si+K_ACTIVE], 1     
    jmp near .col

.shell_slide:
    inc word [cs:si+K_TIMER]
    cmp word [cs:si+K_TIMER], KoopaWakeFrames
    jl near .slide_move
    mov byte [cs:si+K_ACTIVE], 1     
    jmp near .col
.slide_move:
    mov ax, [cs:si+K_X]
    cmp byte [cs:si+K_DIR], 0
    je near .slide_right
    sub ax, KoopaSlideSpeed
    cmp word [cs:si+K_PITX], 0        
    je near .slide_clamp
    mov [cs:si+K_X], ax              
    mov bx, [cs:si+K_PITX]
    sub bx, 8                        
    cmp ax, bx
    jge near .slide_hit
    mov byte [cs:si+K_ACTIVE], 4      
    jmp near .col
.slide_right:
    add ax, KoopaSlideSpeed
.slide_clamp:
    cmp word [cs:si+K_Y], 130        
    jge near .sc_ground
    cmp ax, [cs:si+K_MINX]
    jl near .leave_left
    cmp ax, [cs:si+K_MAXX]
    jg near .leave_right
.sc_ground:
    call koopa_bounce
.slide_hit:
    call check_shell_goomba_kill
    jmp near .col

.leave_left:                        
    mov word [cs:si+K_X], Pipe1X - 16
    mov byte [cs:si+K_DIR], 1
    mov word [cs:si+K_MINX], Pit1End  
    mov word [cs:si+K_MAXX], Pipe1X - 16
    mov byte [cs:si+K_ACTIVE], 5
    jmp near .render
.leave_right:
    mov word [cs:si+K_X], Pipe1X + PipeSize
    mov byte [cs:si+K_DIR], 0
    mov word [cs:si+K_MINX], Pipe1X + PipeSize
    mov word [cs:si+K_MAXX], Pipe2X - 16   
    mov byte [cs:si+K_ACTIVE], 5
    jmp near .render

.shell_drop:                          
    add word [cs:si+K_Y], 4
    cmp word [cs:si+K_Y], 130
    jl near .render
    mov word [cs:si+K_Y], 130
    mov byte [cs:si+K_ACTIVE], 3     
    jmp near .render

.shell_fall:                          
    sub word [cs:si+K_X], 2
    add word [cs:si+K_Y], 4
    cmp word [cs:si+K_Y], 180
    jl near .render
    mov byte [cs:si+K_ACTIVE], 0    
    ret

.col:
    cmp word [cs:si+K_GRACE], 0
    jne near .render
    call check_mario_koopa_collision
    cmp byte [cs:si+K_ACTIVE], 0
    je near .done

.render:
    mov bx, [cs:si+K_X]
    sub bx, [cameraX]
    cmp bx, -16
    jle near .done                   
    cmp bx, 320
    jge near .done                   

    xor ax, ax                       
    cmp byte [cs:si+K_ACTIVE], 1
    je near .push_state
    mov ax, 1                         
.push_state:
    push bx
    push word [cs:si+K_Y]
    push ax
    call near DrawKoopaSprite
.done:
    ret


koopa_bounce:
    cmp ax, [cs:si+K_MINX]
    jg near .kb_chk_max
    mov ax, [cs:si+K_MINX]
    mov byte [cs:si+K_DIR], 0         
    jmp near .kb_store
.kb_chk_max:
    cmp ax, [cs:si+K_MAXX]
    jl near .kb_store
    mov ax, [cs:si+K_MAXX]
    mov byte [cs:si+K_DIR], 1         
.kb_store:
    mov [cs:si+K_X], ax
    ret
check_mario_koopa_collision:
    mov ax, [marioX]
    add ax, [marioW]
    cmp ax, [cs:si+K_X]
    jl near .k_nocol

    mov ax, [marioX]
    mov bx, [cs:si+K_X]
    add bx, 16
    cmp ax, bx
    jg near .k_nocol

    mov ax, [marioY]
    add ax, [marioH]
    cmp ax, [cs:si+K_Y]
    jl near .k_nocol

    mov ax, [marioY]
    mov bx, [cs:si+K_Y]
    add bx, 16
    cmp ax, bx
    jg near .k_nocol


    cmp word [velocityY], 0
    jle near .side_hit
    mov ax, [marioY]
    add ax, [marioH]
    mov dx, [velocityY]
    sar dx, 8                         
    sub ax, dx                        
    mov bx, [cs:si+K_Y]
    add bx, 12
    cmp ax, bx
    jle near .stomp

.side_hit:
    cmp byte [cs:si+K_ACTIVE], 2      
    je near .kick

    cmp byte [cs:invincTimer], 0
    jne near .k_nocol
    cmp byte [cs:stompGrace], 0       
    jne near .k_nocol

    cmp byte [cs:isSuperMario], 1
    je near .shrink
    mov byte [cs:deathPending], 1     
    ret

.shrink:
    mov byte [cs:isSuperMario], 0
    mov word [marioH], 16
    add word [marioY], 16
    mov byte [cs:invincTimer], 60
    jmp near .k_nocol

.kick:
    mov ax, 400                       
    mov bx, [cs:si+K_X]
    mov cx, [cs:si+K_Y]
    call score_event
    mov byte [cs:si+K_ACTIVE], 3      
    mov word [cs:si+K_TIMER], 0
    mov word [cs:si+K_GRACE], KoopaGraceFrames
    mov ax, [marioX]
    cmp ax, [cs:si+K_X]
    jl near .kick_right
    mov byte [cs:si+K_DIR], 1         
    jmp near .k_nocol
.kick_right:
    mov byte [cs:si+K_DIR], 0         
    jmp near .k_nocol

.stomp:
    mov word [velocityY], StompBounceSpeed
    mov bx, [cs:si+K_X]
    mov cx, [cs:si+K_Y]
    call stomp_score                
    cmp byte [cs:si+K_ACTIVE], 1
    jne near .stomp_kill
    mov byte [cs:si+K_ACTIVE], 2      
    mov word [cs:si+K_TIMER], 0
    mov word [cs:si+K_GRACE], KoopaGraceFrames
    jmp near .k_nocol
.stomp_kill:
    mov byte [cs:si+K_ACTIVE], 0     

.k_nocol:
    ret

koopa_overlaps:
    push ax

    mov ax, bx
    add ax, 16
    cmp ax, [cs:si+K_X]
    jl near .ko_no

    mov ax, [cs:si+K_X]
    add ax, 16
    cmp bx, ax
    jg near .ko_no

    mov ax, cx
    add ax, 16
    cmp ax, [cs:si+K_Y]
    jle near .ko_no

    mov ax, [cs:si+K_Y]
    add ax, 16
    cmp cx, ax
    jge near .ko_no

    pop ax
    stc
    ret
.ko_no:
    pop ax
    clc
    ret

check_shell_goomba_kill:
    push di
    push dx
    mov di, goomba1
    mov dx, 4
.next_goomba:
    cmp byte [cs:di+G_ACTIVE], 1
    jne near .next
    mov bx, [cs:di+G_X]
    mov cx, [cs:di+G_Y]
    call koopa_overlaps
    jnc near .next
    mov byte [cs:di+G_ACTIVE], 0
    mov ax, 500
    call score_event
.next:
    add di, G_SIZE
    dec dx
    jnz near .next_goomba
    pop dx
    pop di
    ret
