; Walking Turtle Frame 
koopa_walk_sprite:
    db tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr
    db tr, tr, tr, tr, tr, tr, ky, ky, tr, tr, tr, tr, tr, tr, tr, tr
    db tr, tr, tr, tr, tr, ky, wh, ky, ky, tr, tr, tr, tr, tr, tr, tr
    db tr, tr, tr, tr, tr, ky, bk, ky, ky, tr, tr, tr, tr, tr, tr, tr
    db tr, tr, tr, tr, tr, tr, ky, ky, tr, tr, tr, tr, tr, tr, tr, tr
    db tr, tr, tr, tr, pd, pd, pd, pd, pd, pd, tr, tr, tr, tr, tr, tr
    db tr, tr, tr, pd, pl, pl, pd, pd, pl, pl, pd, tr, tr, tr, tr, tr
    db tr, tr, pd, pd, pl, pl, pd, pd, pl, pl, pd, pd, tr, tr, tr, tr
    db tr, tr, pd, pd, pd, pd, pd, pd, pd, pd, pd, pd, tr, tr, tr, tr
    db tr, tr, pd, pd, pd, pd, pd, pd, pd, pd, pd, pd, tr, tr, tr, tr
    db tr, tr, wh, wh, wh, wh, wh, wh, wh, wh, wh, wh, tr, tr, tr, tr
    db tr, tr, tr, tr, ky, ky, ky, ky, ky, ky, tr, tr, tr, tr, tr, tr
    db tr, tr, tr, tr, ky, ky, ky, ky, ky, ky, tr, tr, tr, tr, tr, tr
    db tr, tr, ky, ky, ky, ky, tr, tr, ky, ky, ky, ky, tr, tr, tr, tr
    db tr, tr, ky, ky, ky, ky, tr, tr, ky, ky, ky, ky, tr, tr, tr, tr
    db tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr
; Shell Frame
koopa_shell_sprite:
    db tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr
    db tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr
    db tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr
    db tr, tr, tr, tr, tr, pd, pd, pd, pd, pd, tr, tr, tr, tr, tr, tr
    db tr, tr, tr, tr, pd, pl, pl, pd, pl, pl, pd, tr, tr, tr, tr, tr
    db tr, tr, tr, pd, pd, pl, pl, pd, pl, pl, pd, pd, tr, tr, tr, tr
    db tr, tr, tr, pd, pd, pd, pd, pd, pd, pd, pd, pd, pd, tr, tr, tr
    db tr, tr, tr, pd, pd, pd, pd, pd, pd, pd, pd, pd, pd, tr, tr, tr
    db tr, tr, wh, wh, wh, wh, wh, wh, wh, wh, wh, wh, wh, wh, tr, tr
    db tr, wh, wh, wh, wh, wh, wh, wh, wh, wh, wh, wh, wh, wh, wh, tr
    db tr, tr, wh, bk, wh, wh, wh, wh, wh, wh, wh, wh, bk, wh, tr, tr
    db tr, wh, wh, wh, wh, wh, wh, wh, wh, wh, wh, wh, wh, wh, wh, tr
    db tr, tr, wh, wh, wh, wh, wh, wh, wh, wh, wh, wh, wh, wh, tr, tr
    db tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr
    db tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr
    db tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr
	
; DrawKoopaSprite (Stack: [BP+8]=X, [BP+6]=Y, [BP+4]=State (0=Walk, 1=Shell))
DrawKoopaSprite:
    push bp
    mov bp, sp
    mov si, koopa_walk_sprite
    cmp word [bp+4], 0
    je .selected
    mov si, koopa_shell_sprite
.selected:
    push si
    push 0
    push 16
    push 16
    mov ax, [bp+6]
    inc ax
    push ax
    push word [bp+8]
    call DrawBitmapSprite
    pop bp
    ret 6
