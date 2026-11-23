bufferSeg dw 0                 ; Segment of off-screen buffer
fontOff   dw 0                
fontSeg   dw 0                 
;Ye subroutine display ko 320x200 VGA mode mein switch karti hai taake game graphics draw ho saken.
switchToVGA:
    mov ax, 0013h
    int 10h
    push bp
    push es
    mov ax, 1130h
    mov bh, 6
    int 10h
    mov [cs:fontOff], bp
    mov [cs:fontSeg], es
    pop es
    pop bp
    ret
;Ye subroutine graphics mode se text mode mein wapas aati hai taake DOS screen safely restore ho.
exitText:
    mov ax, 0003h
    int 10h
    ret

;Ye subroutine VGA palette ko game ke required colors se configure karti hai.
setupPalette:
    push ax
    push cx
    push dx
    push si
    mov dx, 03C8h
    mov al, 40                 
    out dx, al
    inc dx                     
    mov si, paletteTable
    mov cx, 24 * 3           
    cld
    rep outsb                 
    pop si
    pop dx
    pop cx
    pop ax
    ret

; R, G, B values (0-63),
paletteTable:
    db 63, 44, 34              ; 40 skn
    db 22, 10,  0              ; 41 dd
    db 49, 29,  2              ; 42 co
    db 62, 49,  4              ; 43 cg
    db 63, 58, 36              ; 44 cc
    db 50, 19,  3              ; 45 br
    db 63, 47, 44              ; 46 mo
    db 23, 37, 63              ; 47 nts
    db  0, 42,  0              ; 48 tg
    db 43, 25,  8              ; 49 td
    db 34, 19,  0              ; 50 gb 
    db 63, 55, 42              ; 51 gs  
    db  1,  1,  1              ; 52 gx
    db 52, 10,  1              ; 53 sr  
    db 63, 55, 42              ; 54 st  
    db 23, 10,  0              ; 55 bd   
    db 63, 40, 17              ; 56 bo 
    db 34, 25, 13              ; 57 ub   
    db 62, 40, 25              ; 58 bh
    db  0, 24,  0              ; 59 pd  
    db  1, 39,  1              ; 60 pm    
    db 24, 49, 19              ; 61 pl  
    db  2, 28,  2              ; 62 ps 
    db 63, 55,  8              ; 63 ky
	
;Ye subroutine vertical sync ka wait karti hai taake screen tearing kam ho aur drawing smooth rahe.
WaitVSync:
    push ax
    push dx
    mov dx, 03DAh
.wait_end:
    in al, dx
    test al, 8
    jnz near .wait_end
.wait_start:
    in al, dx
    test al, 8
    jz near .wait_start
    pop dx
    pop ax
    ret

;Ye subroutine screen par ek pixel ki position aur color set karti hai.
PutPixel:
    push bp
    mov bp, sp
    push ax
    push bx
    push dx
    push di
    push es
    mov es, [cs:bufferSeg]
    mov ax, [bp+6]
    mov bx, 320
    mul bx
    add ax, [bp+8]
    mov di, ax
    mov al, [bp+4]
    mov [es:di], al
    pop es
    pop di
    pop dx
    pop bx
    pop ax
    pop bp
    ret 6
;Ye subroutine given position, width, height aur color se screen par rectangle fill karti hai.
FillRect:
    push bp
    mov bp, sp
    push ax
    push cx
    push dx
    push di
    push es
    mov es, [cs:bufferSeg]
    mov ax, [bp+10]
    mov dx, 320
    mul dx
    add ax, [bp+12]
    mov di, ax
    mov dl, [bp+4]
    mov dh, [bp+6]
    cld
 
.row_loop:
    mov cx, [bp+8]
    push di
    mov al, dl
    rep stosb
    pop di
    add di, 320
    dec dh
    jnz near .row_loop
    pop es
    pop di
    pop dx
    pop cx
    pop ax
    pop bp
    ret 10

;Ye subroutine off-screen buffer ko VGA screen par copy karti hai; is se frame ek sath display hota hai.
RenderBuffer:
    push ax
    push ds
    push es
    push si
    push di
    push cx
    mov ds, [cs:bufferSeg]
    xor si, si
    mov ax, VGASegment
    mov es, ax
    xor di, di
    mov cx, 16000
    cld
    rep movsd
    pop cx
    pop di
    pop si
    pop es
    pop ds
    pop ax
    ret
