; ANIMATION & DIRECTION STATE VARIABLES
marioDir    db 0                ; 0 = Right, 1 = Left
marioFrame  db 0                ; 0 = Standing, 1 = Walking Frame
invincTimer db 0                ; Blinking invincibility timer (in frames)

; FRAME 0 (Standing)
mario_stand_frame:
    db tr,tr,tr,tr,tr,rd,rd,rd,rd,rd,tr,tr,tr,tr,tr,tr
    db tr,tr,tr,tr,rd,rd,rd,rd,rd,rd,rd,rd,rd,tr,tr,tr
    db tr,tr,tr,tr,dr,dr,dr,sn,sn,dr,sn,tr,tr,tr,tr,tr
    db tr,tr,tr,dr,sn,dr,sn,sn,sn,dr,sn,sn,sn,tr,tr,tr
    db tr,tr,tr,dr,sn,dr,dr,sn,sn,sn,dr,sn,sn,sn,tr,tr
    db tr,tr,tr,dr,dr,sn,sn,sn,sn,dr,dr,dr,dr,tr,tr,tr
    db tr,tr,tr,tr,tr,sn,sn,sn,sn,sn,sn,sn,tr,tr,tr,tr
    db tr,tr,tr,tr,rd,rd,bu,rd,rd,rd,tr,tr,tr,tr,tr,tr
    db tr,tr,tr,rd,rd,rd,bu,rd,rd,bu,rd,rd,rd,tr,tr,tr
    db tr,tr,rd,rd,rd,rd,bu,bu,bu,bu,rd,rd,rd,rd,tr,tr
    db tr,tr,sn,sn,rd,bu,yl,bu,bu,yl,bu,rd,sn,sn,tr,tr
    db tr,tr,sn,sn,sn,bu,bu,bu,bu,bu,bu,sn,sn,sn,tr,tr
    db tr,tr,tr,sn,bu,bu,bu,bu,bu,bu,bu,bu,sn,tr,tr,tr
    db tr,tr,tr,tr,bu,bu,bu,tr,tr,bu,bu,bu,tr,tr,tr,tr
    db tr,tr,tr,dr,dr,dr,tr,tr,tr,tr,dr,dr,dr,tr,tr,tr
    db tr,tr,dr,dr,dr,dr,tr,tr,tr,tr,dr,dr,dr,dr,tr,tr
; FRAME 1 (Walking)
mario_walk_frame:
   db tr, tr, tr, tr, tr, rd, rd, rd, rd, rd, tr, tr, tr, tr, tr, tr
   db tr, tr, tr, tr, rd, rd, rd, rd, rd, rd, rd, rd, rd, tr, tr, tr
   db tr, tr, tr, tr, dr, dr, dr, sn, sn, dr, sn, tr, tr, tr, tr, tr
   db tr, tr, tr, dr, sn, dr, sn, sn, sn, dr, sn, sn, sn, tr, tr, tr
   db tr, tr, tr, dr, sn, dr, dr, sn, sn, sn, dr, sn, sn, sn, tr, tr
   db tr, tr, tr, dr, dr, sn, sn, sn, sn, dr, dr, dr, dr, tr, tr, tr
   db tr, tr, tr, tr, tr, sn, sn, sn, sn, sn, sn, sn, tr, tr, tr, tr
   db tr, tr, tr, rd, rd, rd, bu, rd, rd, rd, tr, tr, tr, tr, tr, tr
   db tr, tr, rd, rd, rd, rd, bu, rd, rd, bu, rd, rd, tr, tr, tr, tr
   db tr, tr, sn, sn, rd, rd, bu, bu, bu, bu, rd, rd, tr, tr, tr, tr
   db tr, tr, tr, sn, rd, bu, yl, bu, bu, yl, bu, rd, sn, tr, tr, tr
   db tr, tr, tr, tr, bu, bu, bu, bu, bu, bu, bu, sn, sn, tr, tr, tr
   db tr, tr, tr, tr, bu, bu, bu, bu, bu, bu, bu, tr, tr, tr, tr, tr
   db tr, tr, tr, dr, dr, dr, bu, bu, bu, dr, dr, dr, tr, tr, tr, tr
   db tr, tr, dr, dr, dr, dr, tr, tr, tr, dr, dr, dr, dr, tr, tr, tr
   db tr, tr, dr, dr, dr, tr, tr, tr, tr, tr, dr, dr, dr, tr, tr, tr

; DrawMarioSprite
; Stack parameters: [BP+6] = X, [BP+4] = Y
DrawMarioSprite:
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    push es
    push ds
    ; FAST BLINKING & INVINCIBILITY 
    cmp byte [cs:invincTimer], 0
    je near .start_draw
    dec byte [cs:invincTimer]
    test byte [cs:invincTimer], 2
    jz near .start_draw
    jmp near .skip_draw
.start_draw:
    push cs
    pop ds
    mov es, [cs:bufferSeg]
    mov si, mario_stand_frame
    cmp byte [cs:marioFrame], 0
    je near .frame_selected
    mov si, mario_walk_frame
.frame_selected:
    mov ax, [bp+4]             
    mov dx, 320
    mul dx
    add ax, [bp+6]              
    mov di, ax
    mov dh, 16
.row_loop:
    mov cx, 16
    push di
    cmp byte [cs:marioDir], 0
    je near .draw_right
.draw_left:
    add di, 15
.col_loop_left:
    lodsb
    cmp al, tr
    je near .skip_left
    cmp byte [cs:invincTimer], 0
    je near .write_l
    cmp al, rd
    jne near .write_l
    mov al, dr
.write_l:
    mov [es:di], al
    cmp byte [cs:isSuperMario], 1
    jne near .skip_left
    mov [es:di + 320], al
.skip_left:
    dec di
    loop .col_loop_left
    jmp .next_row
.draw_right:
.col_loop_right:
    lodsb
    cmp al, tr
    je near .skip_right
    cmp byte [cs:invincTimer], 0
    je near .write_r
    cmp al, rd
    jne near .write_r
    mov al, dr
.write_r:
    mov [es:di], al
    cmp byte [cs:isSuperMario], 1
    jne near .skip_right
    mov [es:di + 320], al
.skip_right:
    inc di
    loop .col_loop_right
.next_row:
    pop di
    add di, 320
    cmp byte [cs:isSuperMario], 1
    jne near .normal_step
    add di, 320
.normal_step:
    dec dh
    jnz near .row_loop
.skip_draw:
    pop ds
    pop es
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret 4
