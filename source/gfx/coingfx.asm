coin_sprite:
    db tr, tr, tr, tr, tr, tr, co, co, co, co, tr, tr, tr, tr, tr, tr
    db tr, tr, tr, tr, co, co, cg, cg, cg, cg, co, co, tr, tr, tr, tr
    db tr, tr, tr, co, cg, cg, cg, cc, cc, cg, cg, cg, cg, tr, tr, tr
    db tr, tr, co, cg, cg, cc, cc, cc, cc, cc, cc, cg, cg, co, tr, tr
    db tr, tr, co, cg, cg, cc, cc, cc, cc, cc, cc, cg, cg, co, tr, tr
    db tr, co, cg, cg, cc, cc, cc, cc, cc, cc, cc, cc, cg, cg, co, tr
    db tr, co, cg, cg, cc, cc, cc, cc, cc, cc, cc, cc, cg, cg, co, tr
    db tr, co, cg, cg, cc, cc, cc, cc, cc, cc, cc, cc, cg, cg, co, tr
    db tr, co, cg, cg, cc, cc, cc, cc, cc, cc, cc, cc, cg, cg, co, tr
    db tr, co, cg, cg, cc, cc, cc, cc, cc, cc, cc, cc, cg, cg, co, tr
    db tr, co, cg, cg, cc, cc, cc, cc, cc, cc, cc, cc, cg, cg, co, tr
    db tr, tr, cg, cg, cg, cc, cc, cc, cc, cc, cc, cg, cg, co, tr, tr
    db tr, tr, co, cg, cg, cc, cc, cc, cc, cc, cc, cg, cg, co, tr, tr
    db tr, tr, tr, co, cg, cg, cg, cc, cc, cg, cg, cg, co, tr, tr, tr
    db tr, tr, tr, tr, co, co, cg, cg, cg, cg, co, co, tr, tr, tr, tr
    db tr, tr, tr, tr, tr, tr, co, co, co, co, tr, tr, tr, tr, tr, tr

; DrawCoinSprite
; Stack parameters: [BP+6] = X, [BP+4] = Y
DrawCoinSprite:
    push bp
    mov bp, sp
    push coin_sprite
    push 0
    push 16
    push 16
    push word [bp+4]
    push word [bp+6]
    call DrawBitmapSprite
    pop bp
    ret 4
