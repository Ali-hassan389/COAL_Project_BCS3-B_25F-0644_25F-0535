txX     dw 0
txY     dw 0
txColor db 0
txScale db 1
curY    dw 0
txBits  db 0
txVrep  db 0
txRows  db 0
txPtr   dw 0
txLen   dw 0


; DrawText
;   SI = string offset (in CS)   CX = length
;   AX = X pixel                 BX = Y pixel
;   DL = color                   DH = scale (1-3)
DrawText:
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    push es
    push fs

    mov [txX], ax
    mov [txY], bx
    mov [txColor], dl
    mov [txScale], dh
    mov [txPtr], si
    mov [txLen], cx
    mov es, [bufferSeg]
    mov fs, [fontSeg]

.next:
    cmp word [txLen], 0
    je near .done
    mov si, [txPtr]
    mov al, [si]
    call DrawGlyph
    mov al, [txScale]
    xor ah, ah
    shl ax, 3                 
    add [txX], ax
    inc word [txPtr]
    dec word [txLen]
    jmp .next

.done:
    pop fs
    pop es
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret

; Ye given text ko horizontal center alignment ke sath draw karti hai.
DrawTextCentered:
    push dx
    mov al, dh
    xor ah, ah
    shl ax, 3
    mul cx                     
    neg ax
    add ax, ScreenWidth
    shr ax, 1                 
    pop dx
    call DrawText
    ret


;Ye font ka ek glyph/pattern screen par draw karti hai.
DrawGlyph:
    xor ah, ah
    shl ax, 4                 
    add ax, [fontOff]
    mov si, ax
    mov ax, [txY]
    mov [curY], ax
    mov byte [txRows], 16

.row:
    mov al, [fs:si]
    inc si
    mov [txBits], al
    mov al, [txScale]
    mov [txVrep], al

.vrep:
    mov ax, [curY]
    mov dx, 320
    mul dx
    add ax, [txX]
    mov di, ax
    mov dl, [txBits]
    mov cx, 8

.bit:
    shl dl, 1
    mov ah, [txScale]
    jnc near .skip
    mov al, [txColor]
.wr:
    mov [es:di], al
    inc di
    dec ah
    jnz near .wr
    jmp .nextbit
.skip:
    mov bl, ah
    xor bh, bh
    add di, bx
.nextbit:
    loop .bit

    inc word [curY]
    dec byte [txVrep]
    jnz near .vrep
    dec byte [txRows]
    jnz near .row
    ret
