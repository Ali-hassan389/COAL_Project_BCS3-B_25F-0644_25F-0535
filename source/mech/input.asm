; KEY STATE VARIABLES
keyleft     db 0
keyright    db 0
keyjump     db 0
quitflag    db 0               
animTimer   db 0
keyup       db 0               
keydown     db 0
keyenter    db 0
keyshift    db 0              
keyp        db 0              


; SAVED INT 09h
oldint9off  dw 0
oldint9seg  dw 0

;Ye subroutine keyboard interrupt handler install karti hai taake key press/release game ko mil sake.
installkeyboard:
    push es
    ; Save original INT 09h vector 
    mov ax, 3509h
    int 21h
    mov [oldint9off], bx
    mov [oldint9seg], es

    ; Set new INT 09h vector 
    mov dx, newint9handler
    mov ax, 2509h
    int 21h

    pop es
    ret

; Ye custom keyboard interrupt remove karke original keyboard handler restore karti hai.
uninstallkeyboard:
    push ds
    mov dx, [oldint9off]
    mov ax, [oldint9seg]
    mov ds, ax
    mov ax, 2509h
    int 21h
    pop ds
    ret


;Ye keyboard interrupt handler hai; pressed aur released keys ke flags update karta hai.
newint9handler:
    push ax

    in al, 60h                 

    cmp al, 01h               
    jne near .notesc
    mov byte [cs:quitflag], 1
    jmp .ack
.notesc:
    cmp al, 4Bh                
    jne near .l1
    mov byte [cs:keyleft], 1
    jmp .ack
.l1:
    cmp al, 0CBh               
    jne near .r0
    mov byte [cs:keyleft], 0
    jmp .ack
.r0:
    cmp al, 4Dh                
    jne near .r1
    mov byte [cs:keyright], 1
    jmp .ack
.r1:
    cmp al, 0CDh               
    jne near .s0
    mov byte [cs:keyright], 0
    jmp .ack
.s0:
    cmp al, 39h                
    jne near .s1
    mov byte [cs:keyjump], 1
    jmp .ack
.s1:
    cmp al, 0B9h               
    jne near .u0
    mov byte [cs:keyjump], 0
    jmp .ack
.u0:
    cmp al, 48h                
    jne near .u1
    mov byte [cs:keyup], 1
    jmp .ack
.u1:
    cmp al, 0C8h              
    jne near .d0
    mov byte [cs:keyup], 0
    jmp .ack
.d0:
    cmp al, 50h                
    jne near .d1
    mov byte [cs:keydown], 1
    jmp .ack
.d1:
    cmp al, 0D0h               
    jne near .e0
    mov byte [cs:keydown], 0
    jmp .ack
.e0:
    cmp al, 1Ch                
    jne near .e1
    mov byte [cs:keyenter], 1
    jmp .ack
.e1:
    cmp al, 9Ch                
    jne near .sh0
    mov byte [cs:keyenter], 0
    jmp .ack
.sh0:
    cmp al, 2Ah                
    jne near .sh1
    mov byte [cs:keyshift], 1
    jmp .ack
.sh1:
    cmp al, 0AAh               
    jne near .p0
    mov byte [cs:keyshift], 0
    jmp .ack
.p0:
    cmp al, 19h               
    jne near .p1
    mov byte [cs:keyp], 1
    jmp .ack
.p1:
    cmp al, 99h               
    jne near .ack
    mov byte [cs:keyp], 0

.ack:
    in al, 61h                 
    or al, 80h
    out 61h, al
    and al, 7Fh
    out 61h, al

    mov al, 20h               
    out 20h, al

    pop ax
    iret

;Ye keyboard flags read karke left, right, jump, pause aur exit actions ko gameplay ke liye prepare karti hai.
checkinput:
    cmp byte [flagDown], 1
    je near .locked

    cmp byte [keyjump], 1
    jne near .nojump
    call triggerjump
.nojump:
    call update_horizontal
.locked:
    ret

;Ye left/right input ke mutabiq Mario ki horizontal speed aur position update karti hai.
update_horizontal:
    push ax
    push bx
    push cx

    mov bx, MaxWalkSpeed
    cmp byte [keyshift], 1
    jne near .limit_set
    mov bx, MaxRunSpeed
.limit_set:
    mov ax, [velX]
    mov cl, [keyleft]
    cmp cl, [keyright]
    je near .friction              
    cmp byte [keyleft], 1
    je near .go_left

    ; ---- right ----
    mov byte [marioDir], DIR_RIGHT
    cmp ax, 0
    jge near .r_acc
    add ax, AccelWalk              
.r_acc:
    add ax, AccelWalk
    cmp ax, bx
    jle near .store
    mov ax, bx
    jmp near .store

.go_left:
    mov byte [marioDir], DIR_LEFT
    neg bx
    cmp ax, 0
    jle near .l_acc
    sub ax, AccelWalk
.l_acc:
    sub ax, AccelWalk
    cmp ax, bx
    jge near .store
    mov ax, bx
    jmp near .store

.friction:
    cmp ax, 0
    jg near .fric_pos
    jl near .fric_neg
    jmp near .store
.fric_pos:
    sub ax, FrictionSpeed
    jns near .store
    xor ax, ax
    jmp near .store
.fric_neg:
    add ax, FrictionSpeed
    js near .store
    xor ax, ax

.store:
    mov [velX], ax

   
    cmp word [isJumping], 0
    jne near .pose_jump
    cmp ax, 0
    je near .pose_stand
    call animate_walk
    jmp near .move
.pose_jump:
    mov byte [marioFrame], 1        
    jmp near .move
.pose_stand:
    mov byte [marioFrame], 0
    mov byte [animTimer], 0

.move:
    mov ax, [marioXFrac]
    add ax, [velX]
    mov bx, ax
    sar bx, 8                      
    and ax, 0FFh
    mov [marioXFrac], ax
    mov ax, [marioX]
    add ax, bx

    cmp ax, 0                       
    jge near .not_left_end
    xor ax, ax
    mov word [velX], 0
.not_left_end:
    mov bx, 960                     
    sub bx, [marioW]
    cmp ax, bx
    jle near .save
    mov ax, bx
    mov word [velX], 0
.save:
    mov [marioX], ax
    mov cx, ax
    call resolve_pipe_walls
    cmp cx, [marioX]
    je near .done
    mov word [velX], 0              
.done:
    pop cx
    pop bx
    pop ax
    ret


; Ye Mario ke walking frames ko change karti hai taake movement animated lage.
animate_walk:
    inc byte [animTimer]
    cmp byte [animTimer], 3    
    jb near .done
    mov byte [animTimer], 0
    xor byte [marioFrame], 1
.done:
    ret

;Ye jump key par Mario ki vertical jump velocity set karti hai, agar Mario ground par ho.
triggerjump:
    cmp word [isJumping], 0
    jne near .donejump
    mov word [isJumping], 1
    mov word [velocityY], JumpStartSpeed
.donejump:
    ret
