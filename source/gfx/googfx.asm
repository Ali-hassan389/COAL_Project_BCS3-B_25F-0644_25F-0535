; NORMAL ALIVE GOOMBA 
goomba_walk_frame:
    db tr, tr, tr, tr, tr, tr, gx, gx, gx, gx, tr, tr, tr, tr, tr, tr
    db tr, tr, tr, tr, gx, gx, gb, gb, gb, gb, gx, gx, tr, tr, tr, tr
    db tr, tr, tr, gx, gb, gb, gb, gb, gb, gb, gb, gb, gx, tr, tr, tr
    db tr, tr, gx, gb, gb, gb, gb, gb, gb, gb, gb, gb, gb, gx, tr, tr
    db tr, gx, gb, gb, wh, wh, gb, gb, gb, gb, wh, wh, gb, gb, gx, tr
    db tr, gb, gb, gb, wh, gx, gb, gb, gb, gb, gx, wh, gb, gb, gb, tr
    db tr, gb, gb, gb, wh, gx, gb, gb, gb, gb, gx, wh, gb, gb, gb, tr
    db gb, gb, gb, gb, wh, wh, gb, gb, gb, gb, wh, wh, gb, gb, gb, gb
    db gb, gb, gb, gb, gb, gb, gb, gb, gb, gb, gb, gb, gb, gb, gb, gb
    db tr, gb, gb, gb, gb, gb, gb, gb, gb, gb, gb, gb, gb, gb, gb, tr
    db tr, tr, tr, gp, gp, gp, gp, gp, gp, gp, gp, gp, gp, tr, tr, tr
    db tr, tr, gp, gp, gp, wh, wh, wh, wh, wh, wh, gp, gp, gp, tr, tr
    db tr, tr, gx, gx, gx, gp, gp, gp, gp, gp, gp, gx, gx, gx, tr, tr
    db tr, gx, gx, gx, gx, gx, tr, tr, tr, tr, gx, gx, gx, gx, gx, tr
    db tr, tr, gx, gx, gx, tr, tr, tr, tr, tr, tr, gx, gx, gx, tr, tr
; FLATTENED GOOMBA 
goomba_squished_frame:
    db tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr
	db tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr
	db tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr
	db tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr
	db tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr
	db tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr
	db tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr
	db tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr
	db tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr
	db tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr
	db tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr
    db tr, tr, tr, tr, gx, gb, gb, gb, gb, gb, gb, gx, tr, tr, tr, tr
    db tr, tr, gx, gb, gb, wh, gx, gb, gb, gx, wh, gb, gb, gx, tr, tr
    db tr, gb, gb, gb, gb, gb, gb, gb, gb, gb, gb, gb, gb, gb, gb, tr
    db tr, tr, gp, gp, gp, gp, gp, gp, gp, gp, gp, gp, gp, gp, tr, tr
    db tr, tr, gx, gx, gx, tr, tr, tr, tr, tr, tr, gx, gx, gx, tr, tr
; DrawGoombaSprite
;   [BP+8] = X, [BP+6] = Y, [BP+4] = State (0=Normal, 1=Squashed)
DrawGoombaSprite:
    push bp
    mov bp, sp
    mov si, goomba_walk_frame
    cmp word [bp+4], 0
    je .selected
    mov si, goomba_squished_frame
.selected:
    push si
    push 0
    push 16
    push 16
    push word [bp+6]
    push word [bp+8]
    call DrawBitmapSprite
    pop bp
    ret 6
