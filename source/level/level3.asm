;Ye subroutine level 1-3 ke stairs, blocks, flagpole aur related collision objects ko draw karti hai.
draw_level3:
    call draw_pit3                  
    mov ax, Stair1X
    push ax
    push Stair1Y
    call DrawClippedStair

    mov ax, Stair2X
    push ax
    push Stair2Y
    call DrawClippedStair
    mov ax, Stair2X
    push ax
    push Stair2Y + 16
    call DrawClippedStair

    mov ax, Stair3X
    push ax
    push Stair3Y
    call DrawClippedStair
    mov ax, Stair3X
    push ax
    push Stair3Y + 16
    call DrawClippedStair
    mov ax, Stair3X
    push ax
    push Stair3Y + 32
    call DrawClippedStair

    mov ax, Stair4X
    push ax
    push Stair4Y
    call DrawClippedStair
    mov ax, Stair4X
    push ax
    push Stair4Y + 16
    call DrawClippedStair
    mov ax, Stair4X
    push ax
    push Stair4Y + 32
    call DrawClippedStair
    mov ax, Stair4X
    push ax
    push Stair4Y + 48
    call DrawClippedStair

    call draw_row_blocks
    call draw_flag
    ret

rowB1Hit    db 0                    
rowB2Hit    db 0
rowB3Hit    db 0
rowB4Hit    db 0
rowLHit     db 0                   

;Ye subroutine level ke row blocks aur lucky block ko camera position ke mutabiq draw karti hai.
draw_row_blocks:
    ; Brick 1
    cmp byte [cs:rowB1Hit], 1
    je near .db_b2
    mov ax, RowB1X
    sub ax, [cameraX]
    cmp ax, 0
    jl near .db_b2
    cmp ax, 304
    jg near .db_b2
    push ax                        
    push RowY
    call DrawBrickSprite           

.db_b2:
    ; Brick 2
    cmp byte [cs:rowB2Hit], 1
    je near .db_b3
    mov ax, RowB2X
    sub ax, [cameraX]
    cmp ax, 0
    jl near .db_b3
    cmp ax, 304
    jg near .db_b3
    push ax                         
    push RowY
    call DrawBrickSprite           

.db_b3:
    ; Brick 3
    cmp byte [cs:rowB3Hit], 1
    je near .db_b4
    mov ax, RowB3X
    sub ax, [cameraX]
    cmp ax, 0
    jl near .db_b4
    cmp ax, 304
    jg near .db_b4
    push ax                        
    push RowY
    call DrawBrickSprite           

.db_b4:
    ; Brick 4
    cmp byte [cs:rowB4Hit], 1
    je near .db_lucky
    mov ax, RowB4X
    sub ax, [cameraX]
    cmp ax, 0
    jl near .db_lucky
    cmp ax, 304
    jg near .db_lucky
    push ax                        
    push RowY
    call DrawBrickSprite           

.db_lucky:
    ; lucky block ( state 0 = active, 1 = used)
    mov ax, RowLX
    sub ax, [cameraX]
    cmp ax, 0
    jl near .db_done
    cmp ax, 304
    jg near .db_done
    push ax                        
    push RowY
    xor bx, bx
    mov bl, [cs:rowLHit]
    push bx                        
    call DrawBlockSprite
.db_done:
    ret


;Ye subroutine check karti hai ke Mario row blocks ya lucky block par land hua hai ya nahi.
check_row_landing:
    ; Brick 1
    cmp byte [cs:rowB1Hit], 1
    je near .rl_b2
    push RowB1X
    push RowY
    call check_land_on_target
    jc near row_landed

.rl_b2:
    ; Brick 2
    cmp byte [cs:rowB2Hit], 1
    je near .rl_b3
    push RowB2X
    push RowY
    call check_land_on_target
    jc near row_landed

.rl_b3:
    ; Brick 3
    cmp byte [cs:rowB3Hit], 1
    je near .rl_b4
    push RowB3X
    push RowY
    call check_land_on_target
    jc near row_landed

.rl_b4:
    ; Brick 4
    cmp byte [cs:rowB4Hit], 1
    je near .rl_lucky
    push RowB4X
    push RowY
    call check_land_on_target
    jc near row_landed

.rl_lucky:
    push RowLX
    push RowY
    call check_land_on_target
    jc near row_landed
    clc
    ret
row_landed:
    stc
    ret

;Ye subroutine row ke blocks se head bump/collision check karti hai.
check_row_bumps:
    ; Brick 1
    cmp byte [cs:rowB1Hit], 1
    je near .rb_b2
    push RowB1X
    push RowY
    call check_bump_target
    jnc near .rb_b2
    cmp byte [cs:isSuperMario], 1
    jne near .rb_b2
    mov byte [cs:rowB1Hit], 1
    mov ax, 50
    mov bx, RowB1X
    mov cx, RowY
    call score_event

.rb_b2:
    ; Brick 2
    cmp byte [cs:rowB2Hit], 1
    je near .rb_b3
    push RowB2X
    push RowY
    call check_bump_target
    jnc near .rb_b3
    cmp byte [cs:isSuperMario], 1
    jne near .rb_b3
    mov byte [cs:rowB2Hit], 1
    mov ax, 50
    mov bx, RowB2X
    mov cx, RowY
    call score_event

.rb_b3:
    ; Brick 3
    cmp byte [cs:rowB3Hit], 1
    je near .rb_b4
    push RowB3X
    push RowY
    call check_bump_target
    jnc near .rb_b4
    cmp byte [cs:isSuperMario], 1
    jne near .rb_b4
    mov byte [cs:rowB3Hit], 1
    mov ax, 50
    mov bx, RowB3X
    mov cx, RowY
    call score_event

.rb_b4:
    ; Brick 4
    cmp byte [cs:rowB4Hit], 1
    je near .rb_lucky
    push RowB4X
    push RowY
    call check_bump_target
    jnc near .rb_lucky
    cmp byte [cs:isSuperMario], 1
    jne near .rb_lucky
    mov byte [cs:rowB4Hit], 1
    mov ax, 50
    mov bx, RowB4X
    mov cx, RowY
    call score_event

.rb_lucky:
    push RowLX
    push RowY
    call check_bump_target
    jnc near .rb_done
    cmp byte [cs:rowLHit], 0
    jne near .rb_done
    mov byte [cs:rowLHit], 1
    push RowLX
    push RowY
    call spawn_coin
.rb_done:
    ret

;Ye subroutine third pit ko screen par clipped form mein draw karti hai.
draw_pit3:
    mov byte [cs:frColor], Color_Sky
    mov ax, Pit3X
    sub ax, [cameraX]
    mov bx, 146                    
    mov cx, Pit3Width
    mov dx, ScreenHeight - 146
    call fill_rect
    ret


flagY        dw FlagStartY
flagDown     db 0                
frColor      db 0
flagRow      dw 0


; Ye subroutine flagpole aur moving flag ko current win animation position par draw karti hai.
draw_flag:
    mov ax, FlagPoleX
    sub ax, [cameraX]             
    cmp ax, -20
    jle near .df_done
    cmp ax, 320
    jge near .df_done

    mov ax, FlagBaseX
    push ax
    push FlagBaseY
    call DrawClippedStair
    mov ax, FlagPoleX
    sub ax, [cameraX]               
    mov byte [cs:frColor], Color_Grass
    mov bx, FlagTopY
    mov cx, 2
    mov dx, FlagBaseY - FlagTopY
    call fill_rect
    mov ax, FlagPoleX
    sub ax, [cameraX]
    dec ax
    mov bx, FlagTopY - 4
    mov cx, 4
    mov dx, 4
    call fill_rect

   
    cmp byte [cs:flagDown], 0
    je near .df_flag
    cmp word [cs:flagY], FlagEndY
    jge near .df_flag
    add word [cs:flagY], 2

.df_flag:
    mov byte [cs:frColor], Color_White
    mov word [cs:flagRow], 0
.df_row:
    mov cx, 12
    mov ax, [cs:flagRow]
    shl ax, 1                       
    sub cx, ax                     
    mov ax, FlagPoleX
    sub ax, [cameraX]
    sub ax, cx                      
    mov bx, [cs:flagY]
    add bx, [cs:flagRow]
    add bx, [cs:flagRow]            
    mov dx, 2
    call fill_rect
    inc word [cs:flagRow]
    cmp word [cs:flagRow], 5
    jl near .df_row

.df_done:
    ret

; Ye subroutine level drawing ke liye rectangle fill karti hai; wrapper routine ke tor par FillRect jaisa kaam karti hai.
fill_rect:
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    push es

    mov es, [cs:bufferSeg]
    mov si, ax                      

.fr_row:
    cmp bx, 0
    jl near .fr_next
    cmp bx, 199
    jg near .fr_done

    push dx
    mov ax, 320
    mul bx                          
    pop dx
    mov di, ax

    push cx
    push si
.fr_px:
    cmp si, 0
    jl near .fr_skip
    cmp si, 319
    jg near .fr_skip
    mov al, [cs:frColor]
    push di                       
    add di, si
    mov [es:di], al
    pop di
.fr_skip:
    inc si
    dec cx
    jnz near .fr_px
    pop si
    pop cx

.fr_next:
    inc bx
    dec dx
    jnz near .fr_row

.fr_done:
    pop es
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret


;Ye subroutine check karti hai ke Mario flag ke contact point tak pohanch gaya hai ya nahi.
check_flag_touch:
    cmp byte [cs:flagDown], 1
    je near .cf_done

    mov ax, [marioX]
    add ax, [marioW]
    cmp ax, FlagBaseX              
    jl near .cf_done
    cmp word [marioX], FlagPoleX + 2
    jge near .cf_done
    mov byte [cs:flagDown], 1
    call flag_score                 
    mov ax, FlagPoleX + 2
    sub ax, [marioW]
    mov [marioX], ax               
    mov word [velocityY], 0
    mov word [velX], 0
    mov byte [winPhase], 1         
.cf_done:
    ret

;Ye subroutine stair ko visible screen area ke andar clip karke draw karti hai.
DrawClippedStair:
    push bp
    mov bp, sp
    push ax
    push bx

    mov bx, [bp+6]          
    sub bx, [cameraX]
    cmp bx, 0
    jl near .skip_stair
    cmp bx, 304
    jg near .skip_stair

    push bx                
    push word [bp+4]       
    call near DrawStairSprite

.skip_stair:
    pop bx
    pop ax
    pop bp
    ret 4
