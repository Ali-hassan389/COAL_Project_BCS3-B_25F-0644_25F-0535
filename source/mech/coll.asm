;Ye subroutine generic block bump routine hai; block hit hone par uska effect apply karti hai.
check_block_bump_generic:
    push bp
    mov bp,sp
    push ax
    push bx
    push cx
    push dx
    push si
    mov si,[bp+6]
    push word [bp+10]
    push word [bp+8]
    call check_bump_target
    jnc near .done
    cmp byte [cs:si],1
    je near .done
    mov byte [cs:si],1
    cmp word [bp+4],0
    jne near .coin
    mov bx,[bp+10]
    mov cx,[bp+8]
    call spawn_shroom_at
    jmp near .done
.coin:
    push word [bp+10]
    push word [bp+8]
    call spawn_coin
.done:
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret 8

;Ye subroutine pehle question/block ke sath Mario ka bump check karti hai.
check_block1_bump:
    push Block1X
    push Block1Y
    push block1Hit
    push 0
    call check_block_bump_generic
    ret

check_block2_bump:
    push Block2X
    push Block2Y
    push block2Hit
    push 1
    call check_block_bump_generic
    ret
check_block3_bump:
    push Block3X
    push Block3Y
    push block3Hit
    push 1
    call check_block_bump_generic
    ret
check_block4_bump:
    push Block4X
    push Block4Y
    push block4Hit
    push 1
    call check_block_bump_generic
    ret

;Ye subroutine generic brick bump routine hai; brick hit hone par relevant state update karti hai.
check_brick_bump_generic:
    push bp
    mov bp,sp
    push ax
    push bx
    push cx
    push si
    mov si,[bp+4]
    cmp byte [cs:si],1
    je near .done
    push word [bp+8]
    push word [bp+6]
    call check_bump_target
    jnc near .done
    cmp byte [cs:isSuperMario],1
    jne near .done
    mov byte [cs:si],1
    mov ax,50
    mov bx,[bp+8]
    mov cx,[bp+6]
    call score_event
.done:
    pop si
    pop cx
    pop bx
    pop ax
    pop bp
    ret 6
check_brick1_bump:
    push Brick1X
    push Brick1Y
    push brick1Hit
    call check_brick_bump_generic
    ret
check_brick2_bump:
    push Brick2X
    push Brick2Y
    push brick2Hit
    call check_brick_bump_generic
    ret
check_brick3_bump:
    push Brick3X
    push Brick3Y
    push brick3Hit
    call check_brick_bump_generic
    ret
check_standing_on_blocks:
    cmp word [velocityY], 0
    jge near .start_check
    ret

.start_check:
    push Stair1X
    push Stair1Y
    call check_land_on_target
    jc near .landed

    push Stair2X
    push Stair2Y
    call check_land_on_target
    jc near .landed

    push Stair3X
    push Stair3Y
    call check_land_on_target
    jc near .landed

    push Stair4X
    push Stair4Y
    call check_land_on_target
    jc near .landed

    push FlagBaseX
    push FlagBaseY
    call check_land_on_target
    jc near .landed

    call check_row_landing
    jc near .landed

    push Block1X
    push Block1Y
    call check_land_on_target
    jc near .landed
    push Block2X
    push Block2Y
    call check_land_on_target
    jc near .landed
    push Block3X
    push Block3Y
    call check_land_on_target
    jc near .landed
    push Block4X
    push Block4Y
    call check_land_on_target
    jc near .landed

    cmp byte [cs:brick1Hit], 1
    je near .c_b2
    push Brick1X
    push Brick1Y
    call check_land_on_target
    jc near .landed
.c_b2:
    cmp byte [cs:brick2Hit], 1
    je near .c_b3
    push Brick2X
    push Brick2Y
    call check_land_on_target
    jc near .landed
.c_b3:
    cmp byte [cs:brick3Hit], 1
    je near .c_pipes
    push Brick3X
    push Brick3Y
    call check_land_on_target
    jc near .landed

.c_pipes:
    push Pipe1X
    push Pipe1Y
    call check_land_on_pipe
    jc near .landed
    push Pipe2X
    push Pipe2Y
    call check_land_on_pipe
    jc near .landed

    ; Island blocks (solid on top)
    cmp byte [cs:islandBrick1Hit], 1
    je near .c_iblk
    push IslandBrick1X
    push IslandFloatY
    call check_land_on_target
    jc near .landed
.c_iblk:
    push IslandBlock1X
    push IslandFloatY
    call check_land_on_target
    jc near .landed
    cmp byte [cs:islandBrick2Hit], 1
    je near .none
    push IslandBrick2X
    push IslandFloatY
    call check_land_on_target
    jc near .landed
.none:
    ret
.landed:
    ret

;Ye subroutine target object par landing detect karke Mario ki vertical position set karti hai.
check_land_on_target:
    push bp
    mov bp, sp
    push ax
    push bx
   
    mov ax, [marioX]
    add ax, [marioW]
    sub ax, 4                  
    cmp ax, [bp+6]
    jl near .miss
    
    mov ax, [marioX]
    add ax, 4                  
    mov bx, [bp+6]
    add bx, TileSize
    cmp ax, bx
    jg near .miss
    
    mov ax, [marioY]
    add ax, [marioH]
    mov bx, [bp+4]
    cmp ax, bx
    jl near .miss
    add bx, 14
    cmp ax, bx
    jg near .miss
    
    mov ax, [bp+4]
    sub ax, [marioH]
    mov [marioY], ax
    mov word [velocityY], 0
    mov word [isJumping], 0
    mov byte [cs:stompChain], 0       
    pop bx
    pop ax
    pop bp
    stc                        
    ret 4
.miss:
    pop bx
    pop ax
    pop bp
    clc                        
    ret 4

;Ye subroutine pipe par landing detect karti hai aur Mario ko pipe top par place karti hai.
check_land_on_pipe:
    push bp
    mov bp, sp
    push ax
    push bx
    
   
    mov ax, [marioX]
    add ax, [marioW]
    sub ax, 4                  
    cmp ax, [bp+6]
    jl near .p_miss
    
   
    mov ax, [marioX]
    add ax, 4                  
    mov bx, [bp+6]
    add bx, 32                 
    cmp ax, bx
    jg near .p_miss
    
    mov ax, [marioY]
    add ax, [marioH]
    mov bx, [bp+4]
    cmp ax, bx
    jl near .p_miss
    add bx, 14
    cmp ax, bx
    jg near .p_miss
    
    mov ax, [bp+4]
    sub ax, [marioH]
    mov [marioY], ax
    mov word [velocityY], 0
    mov word [isJumping], 0
    mov byte [cs:stompChain], 0       
    pop bx
    pop ax
    pop bp
    stc                        
    ret 4
.p_miss:
    pop bx
    pop ax
    pop bp
    clc                        
    ret 4


;Ye subroutine island ke blocks aur surfaces se Mario ki collision check karti hai.
check_island_bumps:
    cmp byte [cs:islandBrick1Hit], 1
    je near .ib2
    push IslandBrick1X
    push IslandFloatY
    call check_bump_target
    jnc near .ib2
    cmp byte [cs:isSuperMario], 1
    jne near .ib2
    mov byte [cs:islandBrick1Hit], 1
    mov ax, 50
    mov bx, IslandBrick1X
    mov cx, IslandFloatY
    call score_event

.ib2:
    cmp byte [cs:islandBrick2Hit], 1
    je near .iblk
    push IslandBrick2X
    push IslandFloatY
    call check_bump_target
    jnc near .iblk
    cmp byte [cs:isSuperMario], 1
    jne near .iblk
    mov byte [cs:islandBrick2Hit], 1
    mov ax, 50
    mov bx, IslandBrick2X
    mov cx, IslandFloatY
    call score_event

.iblk:
    push IslandBlock1X
    push IslandFloatY
    call check_bump_target
    jnc near .no_iblk

    cmp byte [cs:islandBlockHit], 0
    jne near .no_iblk
    mov byte [cs:islandBlockHit], 1
    mov bx, IslandBlock1X
    mov cx, IslandFloatY
    call spawn_shroom_at             
.no_iblk:
    ret

; [BP+6] = tile X, [BP+4] = tile Y
check_bump_target:
    push bp
    mov bp, sp
    push ax
    push bx

    mov ax, [marioX]
    add ax, [marioW]
    sub ax, 4
    cmp ax, [bp+6]
    jl near .bt_miss
    mov ax, [marioX]
    add ax, 4
    mov bx, [bp+6]
    add bx, TileSize
    cmp ax, bx
    jg near .bt_miss

    mov ax, [marioY]
    mov bx, [bp+4]
    cmp ax, bx
    jl near .bt_miss
    add bx, TileSize
    cmp ax, bx
    jg near .bt_miss

    mov ax, [bp+4]
    add ax, TileSize
    mov [marioY], ax
    mov word [velocityY], 1
    pop bx
    pop ax
    pop bp
    stc
    ret 4
.bt_miss:
    pop bx
    pop ax
    pop bp
    clc
    ret 4

;Ye subroutine pipe walls ke sath collision resolve karke Mario ko wall ke andar jane se rokti hai.
resolve_pipe_walls:
    push Pipe1X
    push Pipe1Y
    call push_out_of_pipe
    push Pipe2X
    push Pipe2Y
    call push_out_of_pipe
    ret

; [BP+6] = pipe X, [BP+4] = pipe Y
push_out_of_pipe:
    push bp
    mov bp, sp
    push ax
    push bx

    
    mov ax, [marioY]
    add ax, [marioH]
    cmp ax, [bp+4]
    jle near .pw_done

   
    mov ax, [marioX]
    add ax, [marioW]
    cmp ax, [bp+6]
    jle near .pw_done

  
    mov ax, [marioX]
    mov bx, [bp+6]
    add bx, 32                 
    cmp ax, bx
    jge near .pw_done

    
    mov ax, [marioW]
    shr ax, 1
    add ax, [marioX]          
    mov bx, [bp+6]
    add bx, 16                
    cmp ax, bx
    jge near .push_right

    mov ax, [bp+6]           
    sub ax, [marioW]
    mov [marioX], ax
    jmp near .pw_done

.push_right:
    mov ax, [bp+6]           
    add ax, 32               
    mov [marioX], ax

.pw_done:
    pop bx
    pop ax
    pop bp
    ret 4

;Ye subroutine stairs ki sides ke sath collision resolve karti hai.
resolve_stair_walls:
    push Stair1X
    push Stair1Y
    call push_out_of_stair
    push Stair2X
    push Stair2Y
    call push_out_of_stair
    push Stair3X
    push Stair3Y
    call push_out_of_stair
    push Stair4X
    push Stair4Y
    call push_out_of_stair
    push FlagBaseX
    push FlagBaseY
    call push_out_of_stair
    ret

;[BP+6] = stair X, [BP+4] = stair Y (Top block)
push_out_of_stair:
    push bp
    mov bp, sp
    push ax
    push bx
    mov ax, [marioY]
    add ax, [marioH]
    cmp ax, [bp+4]
    jle near .sw_done

    mov ax, [marioX]
    add ax, [marioW]
    cmp ax, [bp+6]
    jle near .sw_done

    mov ax, [marioX]
    mov bx, [bp+6]
    add bx, TileSize
    cmp ax, bx
    jge near .sw_done

   
    mov ax, [marioW]
    shr ax, 1
    add ax, [marioX]         
    mov bx, [bp+6]
    add bx, TileSize / 2      
    cmp ax, bx
    jge near .sw_push_right

    mov ax, [bp+6]           
    sub ax, [marioW]
    mov [marioX], ax
    jmp near .sw_done

.sw_push_right:
    mov ax, [bp+6]           
    add ax, TileSize
    mov [marioX], ax

.sw_done:
    pop bx
    pop ax
    pop bp
    ret 4
	
resolve_block_walls:
    push Block1X
    push Block1Y
    call push_out_of_block

    push Block2X
    push Block2Y
    call push_out_of_block

    push Block3X
    push Block3Y
    call push_out_of_block

    push Block4X
    push Block4Y
    call push_out_of_block

    cmp byte [cs:brick1Hit], 1
    je near .bw_b2
    push Brick1X
    push Brick1Y
    call push_out_of_block
.bw_b2:

    cmp byte [cs:brick2Hit], 1
    je near .bw_b3
    push Brick2X
    push Brick2Y
    call push_out_of_block
.bw_b3:

    cmp byte [cs:brick3Hit], 1
    je near .bw_ib1
    push Brick3X
    push Brick3Y
    call push_out_of_block
.bw_ib1:

    cmp byte [cs:islandBrick1Hit], 1
    je near .bw_iblk1
    push IslandBrick1X
    push IslandFloatY
    call push_out_of_block
.bw_iblk1:

    push IslandBlock1X
    push IslandFloatY
    call push_out_of_block

    cmp byte [cs:islandBrick2Hit], 1
    je near .bw_rb1
    push IslandBrick2X
    push IslandFloatY
    call push_out_of_block
.bw_rb1:

    cmp byte [cs:rowB1Hit], 1
    je near .bw_rb2
    push RowB1X
    push RowY
    call push_out_of_block
.bw_rb2:

    cmp byte [cs:rowB2Hit], 1
    je near .bw_rl
    push RowB2X
    push RowY
    call push_out_of_block
.bw_rl:

    push RowLX
    push RowY
    call push_out_of_block

    cmp byte [cs:rowB3Hit], 1
    je near .bw_rb4
    push RowB3X
    push RowY
    call push_out_of_block
.bw_rb4:

    cmp byte [cs:rowB4Hit], 1
    je near .bw_end
    push RowB4X
    push RowY
    call push_out_of_block
.bw_end:
    ret

; [BP+6] = block X, [BP+4] = block Y (top-left of a 16x16 block)
push_out_of_block:
    push bp
    mov bp, sp
    push ax
    push bx

   
    mov ax, [bp+4]
    add ax, TileSize
    cmp [marioY], ax
    jge near .bw_done

    mov ax, [marioY]
    add ax, [marioH]
    cmp ax, [bp+4]
    jle near .bw_done

   
    mov ax, [marioX]
    add ax, [marioW]
    cmp ax, [bp+6]
    jle near .bw_done

   
    mov ax, [marioX]
    mov bx, [bp+6]
    add bx, TileSize
    cmp ax, bx
    jge near .bw_done

   
    mov ax, [marioW]
    shr ax, 1
    add ax, [marioX]               
    mov bx, [bp+6]
    add bx, TileSize / 2           
    cmp ax, bx
    jge near .bw_right

    mov ax, [bp+6]                  
    sub ax, [marioW]
    mov [marioX], ax
    jmp near .bw_done

.bw_right:
    mov ax, [bp+6]                 
    add ax, TileSize
    mov [marioX], ax

.bw_done:
    pop bx
    pop ax
    pop bp
    ret 4


WinWalkFrames equ 30               

;Ye subroutine flag touch ke baad Mario ki win movement, flag slide aur level completion sequence chalati hai.
win_sequence:
    mov byte [stompGrace], 2       
    mov word [velX], 0
    cmp byte [winPhase], 1
    jne near .ws_p2

    
    mov ax, [marioY]
    add ax, [marioH]
    cmp ax, FlagBaseY              
    jge near .ws_slide_end
    add word [marioY], 2
    ret
.ws_slide_end:
    mov ax, 146                     
    sub ax, [marioH]
    mov [marioY], ax
    mov word [marioX], FlagPoleX + 2   
    mov byte [winPhase], 2
    mov word [winTimer], 0
    ret

.ws_p2:
    cmp byte [winPhase], 2
    jne near .ws_p3
    mov byte [marioDir], DIR_RIGHT
    inc word [marioX]
    call animate_walk
    inc word [winTimer]
    cmp word [winTimer], WinWalkFrames
    jb near .ws_ret
    mov byte [winPhase], 3
    mov word [winTimer], 0
.ws_ret:
    ret

.ws_p3:
    inc word [winTimer]
    cmp word [winTimer], WinWalkFrames
    jb near .ws_ret
    mov byte [levelDone], 1
    ret

winPhase      db 0
winTimer      dw 0

;VARIABLES 
marioX        dw 32               
marioXFrac    dw 0               
marioYFrac    dw 0
velX          dw 0               
marioY        dw 130
marioW        dw TileSize
marioH        dw TileSize

groundY       dw 130
isJumping     dw 0
velocityY     dw 0

isSuperMario  db 0

block1Hit     db 0
block2Hit     db 0
block3Hit     db 0
block4Hit     db 0
brick1Hit     db 0
brick2Hit     db 0
brick3Hit     db 0
