stair_sprite:
    db ub, ub, ub, ub, ub, ub, ub, ub, ub, ub, ub, ub, ub, ub, ub, ub
    db ub, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, ub
    db ub, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, ub
    db ub, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, ub
    db ub, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, ub
    db ub, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, ub
    db ub, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, ub
    db ub, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, ub
    db ub, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, ub
    db ub, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, ub
    db ub, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, ub
    db ub, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, ub
    db ub, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, ub
    db ub, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, ub
    db ub, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, ub
    db ub, ub, ub, ub, ub, ub, ub, ub, ub, ub, ub, ub, ub, ub, ub, ub
DrawStairSprite:
    push bp
    mov bp, sp
    push stair_sprite
    push 256
    push 16
    push 16
    push word [bp+4]
    push word [bp+6]
    call DrawBitmapSprite
    pop bp
    ret 4
