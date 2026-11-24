;Ye Mario ki movement aur gravity apply karti hai; walls, ground, pits aur jump collisions ko bhi handle karti hai.
applyphysics:
    cmp byte [winPhase], 0
    je near .play
    call win_sequence             
    ret
.play:
    call resolve_pipe_walls
    call resolve_stair_walls
    call resolve_block_walls         
    call check_flag_touch

    cmp word [velocityY], 0
    jge near .no_cut
    cmp byte [keyjump], 1
    je near .no_cut
    cmp word [velocityY], JumpCutSpeed
    jge near .no_cut                
    mov word [velocityY], JumpCutSpeed
.no_cut:

    mov ax, [marioYFrac]
    add ax, [velocityY]
    mov bx, ax
    sar bx, 8                       
    and ax, 0FFh
    mov [marioYFrac], ax
    mov ax, [marioY]
    add ax, bx
    cmp ax, HudHeight           
    jge near .no_ceiling
    mov ax, HudHeight
    mov word [velocityY], 0
.no_ceiling:
    mov [marioY], ax

    mov ax, [velocityY]
    add ax, GravityFP              
    cmp ax, MaxFallSpeed
    jle near .fall_ok
    mov ax, MaxFallSpeed            
.fall_ok:
    mov [velocityY], ax

    cmp word [velocityY], 0
    jl near .check_head_bump

    call check_standing_on_blocks
    jmp .check_ground

.check_head_bump:
    call check_block1_bump
    call check_block2_bump
    call check_block3_bump
    call check_block4_bump
    call check_brick1_bump
    call check_brick2_bump
    call check_brick3_bump
    call check_island_bumps
    call check_row_bumps

.check_ground:
    ; Pit 1 Check
    mov ax, [marioX]
    mov bx, [marioW]
    shr bx, 1
    add ax, bx
    cmp ax, Pit1X
    jl near .normal_ground
    cmp ax, Pit1End
    jl near .in_pit

    ; Pit 2 Check
    cmp ax, Pit2X
    jl near .normal_ground
    mov bx, Pit2X
    add bx, Pit2Width
    cmp ax, bx
    jl near .in_pit

    ; Pit 3 Check
    cmp ax, Pit3X
    jl near .normal_ground
    mov bx, Pit3X
    add bx, Pit3Width
    cmp ax, bx
    jl near .in_pit
    jmp near .normal_ground

.in_pit:
    mov ax, [marioY]
    cmp ax, ScreenHeight + 16
    jl near .done
    mov byte [cs:deathPending], 1  
    jmp near .done             

.normal_ground:
    mov ax, [marioY]
    mov bx, [groundY]
    cmp byte [cs:isSuperMario], 1
    jne near .check_landing
    sub bx, 16                  

.check_landing:
    cmp ax, bx
    jl near .done
    mov [marioY], bx
    mov word [velocityY], 0
    mov word [isJumping], 0
    mov byte [cs:stompChain], 0       

.done:
    ret


