shroom_sprite:
    db tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr
    db tr, tr, tr, tr, tr, tr, sr, sr, sr, sr, tr, tr, tr, tr, tr, tr
    db tr, tr, tr, tr, sr, sr, wh, wh, wh, wh, sr, sr, tr, tr, tr, tr
    db tr, tr, tr, sr, sr, wh, wh, wh, wh, wh, wh, sr, sr, tr, tr, tr
    db tr, tr, tr, sr, sr, wh, wh, wh, wh, wh, wh, sr, sr, tr, tr, tr
    db tr, tr, sr, sr, sr, sr, wh, wh, wh, wh, sr, sr, sr, sr, tr, tr
    db tr, tr, sr, wh, wh, sr, sr, sr, sr, sr, sr, wh, wh, sr, tr, tr
    db tr, sr, sr, wh, wh, sr, sr, sr, sr, sr, sr, wh, wh, sr, sr, tr
    db tr, sr, sr, sr, sr, sr, sr, sr, sr, sr, sr, sr, sr, sr, sr, tr
    db tr, tr, sr, sr, sr, sr, sr, sr, sr, sr, sr, sr, sr, sr, tr, tr
    db tr, tr, tr, st, st, st, st, st, st, st, st, st, st, tr, tr, tr
    db tr, tr, tr, st, st, gx, st, st, st, st, gx, st, st, tr, tr, tr
    db tr, tr, tr, tr, st, gx, st, st, st, st, gx, st, tr, tr, tr, tr
    db tr, tr, tr, tr, tr, st, st, st, st, st, st, tr, tr, tr, tr, tr
    db tr, tr, tr, tr, tr, tr, st, st, st, st, tr, tr, tr, tr, tr, tr
    db tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr, tr
; DrawShroomSprite (Stack: [BP+6]=X, [BP+4]=Y)
DrawShroomSprite:
    push bp
    mov bp, sp
    push shroom_sprite
    push 0
    push 16
    push 16
    push word [bp+4]
    push word [bp+6]
    call DrawBitmapSprite
    pop bp
    ret 4
