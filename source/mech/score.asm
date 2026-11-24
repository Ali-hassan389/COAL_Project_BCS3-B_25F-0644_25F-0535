scoreLo     dw 0                  
scoreHi     dw 0
lives       db 3
coins       db 0
stompChain  db 0                  

PopupFrames equ 22                
POPUP_COUNT equ 4

popups      db 0, 0, 0, 0, 0, 0, 0, 0
            db 0, 0, 0, 0, 0, 0, 0, 0
            db 0, 0, 0, 0, 0, 0, 0, 0
            db 0, 0, 0, 0, 0, 0, 0, 0

stomp_table dw 100, 200, 400, 500, 800, 1000, 2000, 4000, 5000, 8000


; add_score   In: AX = points.  Clamps to 999,999.
;Ye score value ko increase karti hai aur score display ke liye update rakhti hai.
add_score:
    push ax
    add [cs:scoreLo], ax
    adc word [cs:scoreHi], 0
    cmp word [cs:scoreHi], 0Fh           
    jb near .as_ok
    ja near .as_clamp
    cmp word [cs:scoreLo], 423Fh
    jbe near .as_ok
.as_clamp:
    mov word [cs:scoreHi], 0Fh
    mov word [cs:scoreLo], 423Fh
.as_ok:
    pop ax
    ret

; Ye event ke type ke mutabiq score add karne wali routine call karti hai.
score_event:
    call add_score
    call add_popup
    ret


;In: AX = value, BX = world X, CX = Y.  Drops it if all busy.
;Ye temporary score/reward popup ko screen par show karne ke liye add karti hai.
add_popup:
    push dx
    push si
    mov si, popups
    mov dx, POPUP_COUNT
.ap_find:
    cmp word [cs:si+6], 0
    je near .ap_found
    add si, 8
    dec dx
    jnz near .ap_find
    jmp near .ap_done
.ap_found:
    mov [cs:si], bx
    mov [cs:si+2], cx
    mov [cs:si+4], ax
    mov word [cs:si+6], PopupFrames
.ap_done:
    pop si
    pop dx
    ret

; In: BX = enemy X, CX = enemy Y
stompGrace  db 0                

;Ye enemy stomp ke liye score aur popup reward handle karti hai.
stomp_score:
    mov byte [cs:stompGrace], 12
    push ax
    push si
    xor ah, ah
    mov al, [cs:stompChain]
    cmp al, 10
    jae near .ss_oneup
    inc byte [cs:stompChain]
    shl al, 1
    mov si, ax
    mov ax, [cs:stomp_table + si]
    call score_event
    jmp near .ss_done
.ss_oneup:
    call add_life
.ss_done:
    pop si
    pop ax
    ret
;Ye consecutive stomp count ko zero par reset karti hai.
reset_stomp_chain:
    mov byte [cs:stompChain], 0
    ret

; lives & coins
; Ye player ki lives ko increase karti hai.
add_life:
    cmp byte [cs:lives], 99
    jae near .al_done
    inc byte [cs:lives]
.al_done:
    ret

; Ye player ke coin count mein ek coin add karti hai.
add_coin:                                
    inc byte [cs:coins]
    cmp byte [cs:coins], 100
    jb near .ac_done
    mov byte [cs:coins], 0
    call add_life
.ac_done:
    ret

; Ye coin reward apply karti hai, count/score update karti hai aur feedback deti hai.
award_coin:
    push ax
    push cx
    sub cx, 16                           
    mov ax, 200
    call score_event
    call add_coin
    pop cx
    pop ax
    ret
; Ye mushroom power-up ka reward apply karke Mario ko super state deti hai.
award_mushroom:
    push ax
    push bx
    push cx
    mov ax, 1000
    mov bx, [marioX]
    mov cx, [marioY]
    sub cx, 12
    call score_event
    pop cx
    pop bx
    pop ax
    ret

; Ye flag finish ke baad score calculate karke add karti hai.
flag_score:
    push ax
    push bx
    push cx
    mov ax, [marioY]
    add ax, [marioH]                     
    sub ax, 3
    jc near .fs_top                       
    mov cl, 4
    shr ax, cl                           
    cmp ax, 3
    jbe near .fs_top
    mov bx, 2000
    cmp ax, 4
    je near .fs_give
    mov bx, 800
    cmp ax, 5
    je near .fs_give
    mov bx, 400
    cmp ax, 7
    jbe near .fs_give
    mov bx, 100
    jmp near .fs_give
.fs_top:
    mov bx, 5000
.fs_give:
    mov ax, bx
    mov bx, [marioX]
    mov cx, [marioY]
    sub cx, 12
    call score_event
    pop cx
    pop bx
    pop ax
    ret

; Ye remaining time ko bonus score mein convert karti hai.
award_time_bonus:
    cmp byte [cs:flagDown], 1
    jne near .tb_done
    push ax
    push cx
    push dx
    mov cx, 50
    mul cx                               
    test dx, dx
    jnz near .tb_big
    call add_score
    jmp near .tb_pop
.tb_big:
    mov ax, 0FFFFh
    call add_score
.tb_pop:
    pop dx
    pop cx
    pop ax
.tb_done:
    ret

; In: AL = digit, BL = colour, DI = offset.  3x5 pixels, 1x.
draw_digit_small:
    push ax
    push bx
    push dx
    push si
    push di
    push es

    mov es, [cs:bufferSeg]
    xor ah, ah
    mov si, ax
    shl si, 1
    shl si, 1
    add si, ax
    add si, font3x5

    mov dh, 5
.ds_row:
    mov al, [cs:si]
    inc si
    mov dl, 4
.ds_col:
    test al, dl
    jz near .ds_skip
    mov [es:di], bl
.ds_skip:
    inc di
    shr dl, 1
    jnz near .ds_col
    add di, 320 - 3
    dec dh
    jnz near .ds_row

    pop es
    pop di
    pop si
    pop dx
    pop bx
    pop ax
    ret
draw_decimal_small:
    push ax
    push bx
    push cx
    push dx
    push di
    xor cx, cx
    mov bx, 10
.dq_div:
    xor dx, dx
    div bx
    push dx
    inc cx
    test ax, ax
    jnz near .dq_div
.dq_out:
    pop ax
    mov bl, Color_White
    call draw_digit_small
    add di, 4
    loop .dq_out
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    ret
update_draw_popups:
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    push bp

    mov si, popups
    mov bp, POPUP_COUNT
.up_slot:
    cmp word [cs:si+6], 0
    je near .up_next
    dec word [cs:si+6]
    test word [cs:si+6], 1               
    jnz near .up_draw
    dec word [cs:si+2]

.up_draw:
    mov bx, [cs:si]
    sub bx, [cameraX]                    
    cmp bx, 0
    jl near .up_next
    cmp bx, 300
    jg near .up_next
    mov cx, [cs:si+2]
    cmp cx, 0
    jl near .up_next
    cmp cx, 188
    jg near .up_next

    mov ax, cx
    mov dx, 320
    mul dx
    add ax, bx
    mov di, ax                            
    mov ax, [cs:si+4]
    call draw_decimal_small

.up_next:
    add si, 8
    dec bp
    jnz near .up_slot

    pop bp
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
