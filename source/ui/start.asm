gameState db 0                
menuSel   db 0               

; --- STRING DATA ---
strTitle1 db 'SUPER MARIO'
lenTitle1 equ $ - strTitle1
strTitle2 db 'E N G I N E'
lenTitle2 equ $ - strTitle2
strStart  db 'START GAME'
lenStart  equ $ - strStart
strExit   db 'EXIT'
lenExit   equ $ - strExit
strArrow  db '>'
lenArrow  equ $ - strArrow
strGroup  db 'Group #001 | Ali Hassan, AbdurRehman'
lenGroup  equ $ - strGroup


; Ye title/start screen show karke player ke start input ka wait karti hai.
show_start_screen:
    mov byte [menuSel], 0
    call draw_title_screen
    call RenderBuffer

.loop:
    call WaitVSync

    cmp byte [quitflag], 1
    jne near .nokey
    jmp exitgame

.nokey:
    mov al, [menuSel]
    cmp byte [keyup], 1
    jne near .nu
    mov al, 0
.nu:
    cmp byte [keydown], 1
    jne near .nd
    mov al, 1
.nd:
    cmp al, [menuSel]
    je near .nochange
    mov [menuSel], al
    call draw_title_screen
    call RenderBuffer

.nochange:
    cmp byte [keyenter], 1
    je near .select
    cmp byte [keyjump], 1
    je near .select
    jmp .loop

.select:
   
.release:
    call WaitVSync
    cmp byte [keyenter], 0
    jne near .release
    cmp byte [keyjump], 0
    jne near .release

    cmp byte [menuSel], 0
    je near .start_game
    jmp exitgame

.start_game:
    mov byte [gameState], 1
    ret

; Ye title screen ka background, logo aur menu graphics draw karti hai.
draw_title_screen:
    call draw_bricks

    push 16
    push 16
    push 288
    push 136
    push Color_TSky
    call FillRect

    push 16
    push 152
    push 288
    push 4
    push Color_TGrass
    call FillRect

    push 16
    push 156
    push 288
    push 28
    push Color_TDirt
    call FillRect

    call draw_floor_speckles

    mov byte [marioDir], DIR_RIGHT
    mov byte [marioFrame], 0
    push mario_stand_frame
    push 0
    push 16
    push 16
    push 136
    push 28
    call DrawBitmapSprite

   
    push 276                  
    push 136                   
    push 0                    
    call DrawGoombaSprite

    call draw_menu_box
    call print_title_text
    ret


; Ye title ya UI screen par brick pattern draw karti hai.
draw_bricks:
    xor si, si                
    xor bx, bx                 
.row:
    push 0
    push si
    push ScreenWidth
    push 7
    push Color_Brick
    call FillRect

    mov ax, si
    add ax, 7
    push 0
    push ax
    push ScreenWidth
    push 1
    push Color_Mortar
    call FillRect

    xor cx, cx
    test bx, 1
    jz near .joint
    mov cx, 8                  
.joint:
    push cx
    push si
    push 1
    push 7
    push Color_Mortar
    call FillRect
    add cx, 16
    cmp cx, ScreenWidth
    jl near .joint

    add si, 8
    inc bx
    cmp si, ScreenHeight
    jl near .row
    ret

;Ye floor ke decorative pixels/speckles draw karti hai.
draw_floor_speckles:
    mov cx, 20
.speck:
    push cx
    push 157
    push 2
    push 2
    push Color_DarkDirt
    call FillRect

    mov ax, cx
    add ax, 8
    push ax
    push 180
    push 2
    push 2
    push Color_DarkDirt
    call FillRect

    add cx, 16
    cmp cx, 296
    jl near .speck
    ret

; Ye menu option ke around box/border draw karti hai.
draw_menu_box:
    push 90                    
    push 106
    push 140
    push 44
    push Color_White
    call FillRect

    push 92                   
    push 108
    push 136
    push 40
    push Color_Black
    call FillRect
    ret

; Ye title screen ka text labels ke sath draw karti hai.
print_title_text:
    mov si, strTitle1
    mov cx, lenTitle1
    mov ax, 31
    mov bx, 23
    mov dl, Color_Black
    mov dh, 3
    call DrawText

    mov si, strTitle1
    mov cx, lenTitle1
    mov ax, 28
    mov bx, 20
    mov dl, Color_LightRed
    mov dh, 3
    call DrawText

   
    mov si, strTitle2
    mov cx, lenTitle2
    mov bx, 70
    mov dl, Color_White
    mov dh, 2
    call DrawTextCentered

    mov dl, Color_White
    cmp byte [menuSel], 0
    jne near .startcol
    mov dl, Color_Yellow
.startcol:
    mov si, strStart
    mov cx, lenStart
    mov ax, 124
    mov bx, 111
    mov dh, 1
    call DrawText

   
    mov dl, Color_White
    cmp byte [menuSel], 1
    jne near .exitcol
    mov dl, Color_Yellow
.exitcol:
    mov si, strExit
    mov cx, lenExit
    mov ax, 124
    mov bx, 129
    mov dh, 1
    call DrawText

    
    mov bx, 111
    cmp byte [menuSel], 0
    je near .cursor
    mov bx, 129
.cursor:
    mov si, strArrow
    mov cx, lenArrow
    mov ax, 102
    mov dl, Color_Yellow
    mov dh, 1
    call DrawText
    mov si, strGroup
    mov cx, lenGroup
    mov bx, 161
    mov dl, Color_White
    mov dh, 1
    call DrawTextCentered
    ret
