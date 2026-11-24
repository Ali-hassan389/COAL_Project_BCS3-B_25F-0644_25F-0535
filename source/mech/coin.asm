c1_Active db 0
c1_Vis    db 1
c1_Land   db 0
c1_X      dw 0
c1_Y      dw 0
c1_BaseY  dw 0       
c1_VelY   dw 0
c1_Timer  dw 0

c2_Active db 0
c2_Vis    db 1
c2_Land   db 0
c2_X      dw 0
c2_Y      dw 0
c2_BaseY  dw 0
c2_VelY   dw 0
c2_Timer  dw 0

c3_Active db 0
c3_Vis    db 1
c3_Land   db 0
c3_X      dw 0
c3_Y      dw 0
c3_BaseY  dw 0
c3_VelY   dw 0
c3_Timer  dw 0

; Stack: [BP+6] = BlockX, [BP+4] = BlockY
;Ye subroutine hit block se coin create karti hai aur coin ko active state mein set karti hai.
spawn_coin:
    push bp
    mov bp, sp
    push ax
    ; Find empty slot
    cmp byte [cs:c1_Active], 0
    je near .use1
    cmp byte [cs:c2_Active], 0
    je near .use2
    jmp near .use3

.use1:
    mov byte [cs:c1_Active], 1
    mov byte [cs:c1_Vis], 1
    mov byte [cs:c1_Land], 0
    mov ax, [bp+6]
    mov [cs:c1_X], ax
    mov ax, [bp+4]
    mov [cs:c1_BaseY], ax      
    sub ax, 4                  
    mov [cs:c1_Y], ax
    mov word [cs:c1_VelY], -6
    mov word [cs:c1_Timer], 0
    jmp .done

.use2:
    mov byte [cs:c2_Active], 1
    mov byte [cs:c2_Vis], 1
    mov byte [cs:c2_Land], 0
    mov ax, [bp+6]
    mov [cs:c2_X], ax
    mov ax, [bp+4]
    mov [cs:c2_BaseY], ax
    sub ax, 4
    mov [cs:c2_Y], ax
    mov word [cs:c2_VelY], -6
    mov word [cs:c2_Timer], 0
    jmp .done

.use3:
    mov byte [cs:c3_Active], 1
    mov byte [cs:c3_Vis], 1
    mov byte [cs:c3_Land], 0
    mov ax, [bp+6]
    mov [cs:c3_X], ax
    mov ax, [bp+4]
    mov [cs:c3_BaseY], ax
    sub ax, 4
    mov [cs:c3_Y], ax
    mov word [cs:c3_VelY], -6
    mov word [cs:c3_Timer], 0

.done:
    pop ax
    pop bp
    ret 4

;Ye subroutine Mario aur coin ki position compare karke collection detect karti hai.
coin_try_collect:
    push ax
    push bx
    push cx
    cmp byte [cs:si], 0
    je near .ct_no

    mov ax, [marioX]
    add ax, [marioW]
    mov bx, [cs:si+3]
    add bx, 3
    cmp ax, bx
    jl near .ct_no

    mov ax, [marioX]
    mov bx, [cs:si+3]
    add bx, 13
    cmp ax, bx
    jg near .ct_no

    mov ax, [marioY]
    add ax, [marioH]
    mov bx, [cs:si+5]
    add bx, 1
    cmp ax, bx
    jl near .ct_no

    mov ax, [marioY]
    mov bx, [cs:si+5]
    add bx, 15
    cmp ax, bx
    jg near .ct_no

    mov byte [cs:si], 0                  
    mov bx, [cs:si+3]
    mov cx, [cs:si+5]
    add cx, 16                            
    call award_coin
.ct_no:
    pop cx
    pop bx
    pop ax
    ret

;Ye subroutinecoin ki animation update karke active coin ko draw karti hai.
update_and_draw_coin:
    cmp byte [cs:c1_Active], 0
    je near .chk2
    cmp byte [cs:c1_Land], 0
    je near .c1_air
    
    inc word [cs:c1_Timer]
    cmp word [cs:c1_Timer], 120
    jl near .c1_draw
    mov byte [cs:c1_Active], 0
    jmp .chk2
.c1_air:
    mov ax, [cs:c1_Y]
    add ax, [cs:c1_VelY]
    mov [cs:c1_Y], ax
    inc word [cs:c1_VelY]
    
    cmp word [cs:c1_VelY], 0
    jle near .c1_draw
    mov ax, [cs:c1_BaseY]
    sub ax, 16                  
    cmp [cs:c1_Y], ax
    jl near .c1_draw

    mov [cs:c1_Y], ax           
    mov word [cs:c1_VelY], 0
    mov byte [cs:c1_Land], 1
.c1_draw:
    mov si, c1_Active
    call coin_try_collect
    cmp byte [cs:c1_Active], 0
    je near .chk2
    mov ax, [cs:c1_X]
    sub ax, [cameraX]
    cmp ax, 0                 
    jl near .chk2
    cmp ax, 304                
    jg near .chk2
    push ax
    push word [cs:c1_Y]
    call DrawCoinSprite

.chk2:
    ; Update Coin 2
    cmp byte [cs:c2_Active], 0
    je near .chk3
    cmp byte [cs:c2_Land], 0
    je near .c2_air
    
    inc word [cs:c2_Timer]
    cmp word [cs:c2_Timer], 120
    jl near .c2_draw
    mov byte [cs:c2_Active], 0
    jmp .chk3
.c2_air:
    mov ax, [cs:c2_Y]
    add ax, [cs:c2_VelY]
    mov [cs:c2_Y], ax
    inc word [cs:c2_VelY]
    
    cmp word [cs:c2_VelY], 0
    jle near .c2_draw
    mov ax, [cs:c2_BaseY]
    sub ax, 16
    cmp [cs:c2_Y], ax
    jl near .c2_draw

    mov [cs:c2_Y], ax
    mov word [cs:c2_VelY], 0
    mov byte [cs:c2_Land], 1
.c2_draw:
    mov si, c2_Active
    call coin_try_collect
    cmp byte [cs:c2_Active], 0
    je near .chk3
    mov ax, [cs:c2_X]
    sub ax, [cameraX]
    cmp ax, 0                  
    jl near .chk3
    cmp ax, 304                
    jg near .chk3
    push ax
    push word [cs:c2_Y]
    call DrawCoinSprite

 

.chk3:
    cmp byte [cs:c3_Active], 0
    je near .done_all
    cmp byte [cs:c3_Land], 0
    je near .c3_air
    
    inc word [cs:c3_Timer]
    cmp word [cs:c3_Timer], 120
    jl near .c3_draw
    mov byte [cs:c3_Active], 0
    jmp .done_all
.c3_air:
    mov ax, [cs:c3_Y]
    add ax, [cs:c3_VelY]
    mov [cs:c3_Y], ax
    inc word [cs:c3_VelY]
    
    cmp word [cs:c3_VelY], 0
    jle near .c3_draw
    mov ax, [cs:c3_BaseY]
    sub ax, 16
    cmp [cs:c3_Y], ax
    jl near .c3_draw

    mov [cs:c3_Y], ax
    mov word [cs:c3_VelY], 0
    mov byte [cs:c3_Land], 1
.c3_draw:
    mov si, c3_Active
    call coin_try_collect
    cmp byte [cs:c3_Active], 0
    je near .done_all
    mov ax, [cs:c3_X]
    sub ax, [cameraX]
    cmp ax, 0                  
    jl near .done_all
    cmp ax, 304                
    jg near .done_all
    push ax
    push word [cs:c3_Y]
    call DrawCoinSprite

.done_all:
    ret
