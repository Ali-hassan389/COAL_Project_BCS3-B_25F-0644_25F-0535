font3x5:
    db 7,5,5,5,7, 2,6,2,2,7, 7,1,7,4,7, 7,1,7,1,7
    db 5,5,7,1,1, 7,4,7,1,7, 7,4,7,5,7, 7,1,1,1,1
    db 7,5,7,5,7, 7,5,7,1,7, 2,5,7,5,5, 6,5,6,5,6
    db 3,4,4,4,3, 6,5,5,5,6, 7,4,6,4,7, 7,4,6,4,4
    db 3,4,5,5,3, 5,5,7,5,5, 7,2,2,2,7, 1,1,1,5,2
    db 5,5,6,5,5, 4,4,4,4,7, 5,7,7,5,5, 6,5,5,5,5
    db 7,5,5,5,7, 7,5,7,4,4, 7,5,5,7,1, 6,5,6,5,5
    db 3,4,2,1,6, 7,2,2,2,2, 5,5,5,5,7, 5,5,5,5,2
    db 5,5,7,7,5, 5,5,2,5,5, 5,5,2,2,2, 7,1,2,4,7
    db 0,0,0,0,0, 0,0,7,0,0, 0,2,0,2,0, 2,2,2,0,2
    db 0,2,7,2,0, 0,7,0,7,0, 0,5,2,5,0, 0,0,0,0,2
sym_chars   db ' -:!+=*.', 0

ftX         dw 0                 
ftY         dw 0
ftScale     db 1
ftColor     db 15

numBuf      times 12 db 0        
fdLo        dw 0
fdHi        dw 0
fdMin       db 0
fdPtr       dw 0

;Ye text/font drawing ke liye block ya character pattern buffer mein place karti hai.
put_block:
    push ax
    push dx
    push di
    mov dx, cx
.pb_row:
    push di
    mov ax, cx
.pb_col:
    mov [es:di], bl
    inc di
    dec ax
    jnz near .pb_col
    pop di
    add di, 320
    dec dx
    jnz near .pb_row
    pop di
    pop dx
    pop ax
    ret

;Ye chhote font glyph ko pixel pattern se screen par draw karti hai.
draw_glyph:
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    push es

    mov es, [cs:bufferSeg]
    xor ah, ah
    cmp al, 'a'
    jb near .g_up
    cmp al, 'z'
    ja near .g_up
    sub al, 32                         
.g_up:
    cmp al, '0'
    jb near .g_sym
    cmp al, '9'
    jbe near .g_digit
    cmp al, 'A'
    jb near .g_sym
    cmp al, 'Z'
    ja near .g_sym
    sub al, 'A' - 10
    jmp near .g_have
.g_digit:
    sub al, '0'
    jmp near .g_have
.g_sym:
    mov bl, al
    mov si, sym_chars
    mov al, 36
.g_sl:
    cmp byte [cs:si], 0
    je near .g_blank
    cmp [cs:si], bl
    je near .g_have
    inc si
    inc al
    jmp near .g_sl
.g_blank:
    mov al, 36
.g_have:
    xor ah, ah
    mov si, ax
    shl si, 1
    shl si, 1
    add si, ax                          
    add si, font3x5

    mov ax, [cs:ftY]
    mov dx, 320
    mul dx
    add ax, [cs:ftX]
    mov di, ax                         
    mov bl, [cs:ftColor]
    mov cl, [cs:ftScale]
    xor ch, ch
    mov dh, 5                          
.g_row:
    mov al, [cs:si]
    inc si
    mov dl, 4                           
    push di
.g_col:
    test al, dl
    jz near .g_skip
    call put_block
.g_skip:
    add di, cx
    shr dl, 1
    jnz near .g_col
    pop di
    push dx
    mov ax, 320
    mul cx
    add di, ax                         
    pop dx
    dec dh
    jnz near .g_row

    mov al, [cs:ftScale]
    xor ah, ah
    shl ax, 1
    shl ax, 1                           
    add [cs:ftX], ax

    pop es
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret

;Ye string ko character by character screen par draw karti hai.
draw_text:
    mov [cs:ftX], ax
    mov [cs:ftY], bx
    mov [cs:ftScale], cl
    mov [cs:ftColor], dl
;Ye existing text position se agla text draw karna continue karti hai.
draw_text_cont:
    push ax
    push si
.dt_next:
    mov al, [cs:si]
    test al, al
    jz near .dt_done
    call draw_glyph
    inc si
    jmp near .dt_next
.dt_done:
    pop si
    pop ax
    ret
;Ye text ki length calculate karke usay screen ke center mein draw karti hai.
draw_text_center:
    push ax
    push dx
    push si
    xor ax, ax
.tc_len:
    cmp byte [cs:si], 0
    je near .tc_got
    inc ax
    inc si
    jmp near .tc_len
.tc_got:
    pop si
    shl ax, 1
    shl ax, 1                          
    xor ch, ch
    mul cx                             
    sub ax, cx                          
    mov dx, 320
    sub dx, ax
    shr dx, 1
    mov ax, dx                          
    pop dx
    call draw_text
    pop ax
    ret

; Ye numeric value ko decimal digits mein convert karke text drawing ke liye prepare karti hai.
fmt_dec:
    push ax
    push bx
    push cx
    push dx
    push di
    mov [cs:fdLo], ax
    mov [cs:fdHi], dx
    mov [cs:fdMin], cl
    mov di, numBuf + 11
    mov byte [cs:di], 0
    dec di
    xor bx, bx
.fd_loop:
    mov cx, 10
    xor dx, dx
    mov ax, [cs:fdHi]
    div cx
    mov [cs:fdHi], ax
    mov ax, [cs:fdLo]
    div cx
    mov [cs:fdLo], ax
    add dl, '0'
    mov [cs:di], dl
    dec di
    inc bl
    mov ax, [cs:fdHi]
    or ax, [cs:fdLo]
    jnz near .fd_loop
    cmp bl, [cs:fdMin]
    jb near .fd_loop
    inc di
    mov [cs:fdPtr], di
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    mov si, [cs:fdPtr]
    ret

frmX dw 0
frmY dw 0
frmW dw 0
frmH dw 0

;Ye UI frame ya border ko given coordinates par draw karti hai.
draw_frame:
    push ax
    push bx
    push cx
    push dx
    mov [cs:frmX], ax
    mov [cs:frmY], bx
    mov [cs:frmW], cx
    mov [cs:frmH], dx
    mov dx, 2                          
    call fill_rect
    mov ax, [cs:frmX]                  
    mov bx, [cs:frmY]
    add bx, [cs:frmH]
    sub bx, 2
    mov cx, [cs:frmW]
    mov dx, 2
    call fill_rect
    mov ax, [cs:frmX]                  
    mov bx, [cs:frmY]
    mov cx, 2
    mov dx, [cs:frmH]
    call fill_rect
    mov ax, [cs:frmX]                   
    add ax, [cs:frmW]
    sub ax, 2
    mov bx, [cs:frmY]
    mov cx, 2
    mov dx, [cs:frmH]
    call fill_rect
    pop dx
    pop cx
    pop bx
    pop ax
    ret

; Ye off-screen drawing buffer ko clear karti hai taa-ke naya frame clean surface par bane.
clear_buffer:
    push ax
    push cx
    push di
    push es
    mov es, [cs:bufferSeg]
    mov ah, al
    xor di, di
    mov cx, 32000
    cld
    rep stosw
    pop es
    pop di
    pop cx
    pop ax
    ret

;Ye prepared screen ko display karne ke liye final presentation step chalati hai.
present_screen:
    push ax
    push cx
    push si
    push di
    push ds
    push es
    mov ax, VGASegment
    mov es, ax
    mov ds, [cs:bufferSeg]
    xor si, si
    xor di, di
    mov cx, 32000
    cld
    rep movsw
    pop es
    pop ds
    pop di
    pop si
    pop cx
    pop ax
    ret

; Ye current screen/buffer ka data save karti hai taake baad mein restore ya display kiya ja sake.
grab_screen:
    push ax
    push cx
    push si
    push di
    push ds
    push es
    mov ax, VGASegment
    mov ds, ax
    mov es, [cs:bufferSeg]
    xor si, si
    xor di, di
    mov cx, 32000
    cld
    rep movsw
    pop es
    pop ds
    pop di
    pop si
    pop cx
    pop ax
    ret

;Ye display retrace events ka wait karti hai taake screen update safe timing par ho.
wait_retraces:
    push ax
    push cx
    push dx
    mov dx, 3DAh
.wr_next:
.wr_end:
    in al, dx
    test al, 8
    jnz near .wr_end                   
.wr_start:
    in al, dx
    test al, 8
    jz near .wr_start                   
    loop .wr_next
    pop dx
    pop cx
    pop ax
    ret

;Ye keyboard input ka wait karti hai jab screen ko next step se pehle pause rakhna ho.
wait_key_press:
    push ax
    push bx
    mov bl, al
.wk_1:
    in al, 60h
    cmp al, bl
    je near .wk_1                      
.wk_2:
    in al, 60h
    cmp al, bl
    jne near .wk_2                     
.wk_3:
    in al, 60h
    cmp al, bl
    je near .wk_3                      
    pop bx
    pop ax
    ret
