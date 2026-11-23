; QUESTION BLOCK (Active State)
block_question_sprite:
    db bd, bd, bd, bd, bd, bd, bd, bd, bd, bd, bd, bd, bd, bd, bd, bd
    db bd, bo, bo, bo, bo, bo, bo, bo, bo, bo, bo, bo, bo, bo, bo, bd
    db bd, bo, bd, bo, bo, bo, bo, bo, bo, bo, bo, bo, bo, bd, bo, bd
    db bd, bo, bo, bo, bo, bo, wh, wh, wh, wh, wh, bo, bo, bo, bo, bd
    db bd, bo, bo, bo, bo, wh, wh, bo, bo, bo, wh, wh, bo, bo, bo, bd
    db bd, bo, bo, bo, bo, bo, bo, bo, bo, bo, wh, wh, bo, bo, bo, bd
    db bd, bo, bo, bo, bo, bo, bo, bo, bo, wh, wh, bo, bo, bo, bo, bd
    db bd, bo, bo, bo, bo, bo, bo, bo, wh, wh, bo, bo, bo, bo, bo, bd
    db bd, bo, bo, bo, bo, bo, bo, wh, wh, bo, bo, bo, bo, bo, bo, bd
    db bd, bo, bo, bo, bo, bo, bo, bo, bo, bo, bo, bo, bo, bo, bo, bd
    db bd, bo, bo, bo, bo, bo, bo, wh, wh, bo, bo, bo, bo, bo, bo, bd
    db bd, bo, bo, bo, bo, bo, bo, wh, wh, bo, bo, bo, bo, bo, bo, bd
    db bd, bo, bo, bo, bo, bo, bo, bo, bo, bo, bo, bo, bo, bo, bo, bd
    db bd, bo, bd, bo, bo, bo, bo, bo, bo, bo, bo, bo, bo, bd, bo, bd
    db bd, bo, bo, bo, bo, bo, bo, bo, bo, bo, bo, bo, bo, bo, bo, bd
    db bd, bd, bd, bd, bd, bd, bd, bd, bd, bd, bd, bd, bd, bd, bd, bd
; USED BLOCK (Empty State)
block_used_sprite:
    db bd, bd, bd, bd, bd, bd, bd, bd, bd, bd, bd, bd, bd, bd, bd, bd
    db bd, ub, ub, ub, ub, ub, ub, ub, ub, ub, ub, ub, ub, ub, ub, bd
    db bd, ub, bd, ub, ub, ub, ub, ub, ub, ub, ub, ub, ub, bd, ub, bd
    db bd, ub, ub, ub, ub, ub, ub, ub, ub, ub, ub, ub, ub, ub, ub, bd
    db bd, ub, ub, ub, ub, ub, ub, ub, ub, ub, ub, ub, ub, ub, ub, bd
    db bd, ub, ub, ub, ub, ub, ub, ub, ub, ub, ub, ub, ub, ub, ub, bd
    db bd, ub, ub, ub, ub, ub, ub, ub, ub, ub, ub, ub, ub, ub, ub, bd
    db bd, ub, ub, ub, ub, ub, ub, ub, ub, ub, ub, ub, ub, ub, ub, bd
    db bd, ub, ub, ub, ub, ub, ub, ub, ub, ub, ub, ub, ub, ub, ub, bd
    db bd, ub, ub, ub, ub, ub, ub, ub, ub, ub, ub, ub, ub, ub, ub, bd
    db bd, ub, ub, ub, ub, ub, ub, ub, ub, ub, ub, ub, ub, ub, ub, bd
    db bd, ub, ub, ub, ub, ub, ub, ub, ub, ub, ub, ub, ub, ub, ub, bd
    db bd, ub, ub, ub, ub, ub, ub, ub, ub, ub, ub, ub, ub, ub, ub, bd
    db bd, ub, bd, ub, ub, ub, ub, ub, ub, ub, ub, ub, ub, bd, ub, bd
    db bd, ub, ub, ub, ub, ub, ub, ub, ub, ub, ub, ub, ub, ub, ub, bd
    db bd, bd, bd, bd, bd, bd, bd, bd, bd, bd, bd, bd, bd, bd, bd, bd

; DrawBlockSprite
;   [BP+8]=X, [BP+6]=Y, [BP+4]=State (0=Active, 1=Used)
DrawBlockSprite:
    push bp
    mov bp, sp
    cmp word [bp+4], 0
    jne .used
    push block_question_sprite
    jmp .draw
.used:
    push block_used_sprite
.draw:
    push 256
    push 16
    push 16
    push word [bp+6]
    push word [bp+8]
    call DrawBitmapSprite
    pop bp
    ret 6
