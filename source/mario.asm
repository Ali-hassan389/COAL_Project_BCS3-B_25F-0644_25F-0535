org 100h
%include "source/include/const.inc"
gameStateNum dw ST_TITLE

state_table:
    dw st_title, st_playing, st_paused, st_dying, st_lifelost
    dw st_win, st_complete, st_gameover, st_exit

;Ye program ka entry point hai; memory reserve, video mode aur keyboard/timer setup karke game start karta hai.
start:
    mov bx, 3000h
    mov ah, 4Ah
    int 21h
    jc near nomem                  

    mov bx, 0FA0h
    mov ah, 48h
    int 21h
    jc near nomem                   
    mov [bufferSeg], ax

    mov bx, 0FA0h
    mov ah, 48h
    int 21h
    jc near nomem                  
    mov [bgSeg], ax

    mov ax, cs
    mov ds, ax
    mov es, ax
    cld
    call switchToVGA               
    call setupPalette
    call installkeyboard            
    call installtimer              

    mov word [gameStateNum], ST_TITLE

; Ye central game loop hai; gameStateNum dekh kar title, playing, pause, death ya win wali state chalata hai.
mainloop:
    mov bx, [gameStateNum]
    shl bx, 1
    jmp word [state_table + bx]


; Ye title screen state hai; start screen dikhakar naya game initialize karti hai.
st_title:
    mov byte [quitflag], 0          
    call show_start_screen         
    call new_game_init
    call timer_resync
    mov word [gameStateNum], ST_PLAYING
    jmp near mainloop

; Ye normal gameplay state hai; har frame update karti hai aur death, win, pause ya quit ko check karti hai.
st_playing:
    call play_frame
    cmp byte [quitflag], 1
    je near quit_to_title
    cmp byte [deathPending], 1
    je near .to_dying
    cmp byte [flagDown], 1
    je near .to_win
    cmp byte [keyp], 1
    je near .to_pause
    jmp near mainloop
.to_dying:
    mov word [gameStateNum], ST_DYING
    jmp near mainloop
.to_win:
    mov word [gameStateNum], ST_WIN
    jmp near mainloop
.to_pause:
    mov word [gameStateNum], ST_PAUSED
    jmp near mainloop

; Ye pause state hai; pause screen dikhati hai aur resume ya title par wapas jane ka intezam karti hai.
st_paused:
    call screen_pause
    call timer_resync
    cmp byte [quitflag], 1
    je near quit_to_title
    mov word [gameStateNum], ST_PLAYING
    jmp near mainloop

; Ye Mario ki death state hai; death animation chalakar life kam karti hai aur agla state select karti hai.
st_dying:
    mov byte [deathPending], 0
    cmp word [marioY], 192          
    jge near .no_anim
    call death_animation
.no_anim:
    dec byte [lives]
    jz near .no_lives
    mov word [gameStateNum], ST_LIFELOST
    jmp near mainloop
.no_lives:
    mov word [gameStateNum], ST_GAMEOVER
    jmp near mainloop

;Ye life-lost state hai; timer reset karke level ki position dobara initialize karti hai.
st_lifelost:
    cmp word [timeLeft], 0         
    jne near .keep_time
    mov word [timeLeft], StartTime
.keep_time:
    call screen_life_lost
    call reset_level_state
    mov word [gameStateNum], ST_PLAYING
    jmp near mainloop

; Ye win state hai; flag aur win animation complete hone ka wait karti hai.
st_win:
    call play_frame
    cmp byte [levelDone], 1
    jne near mainloop
    mov word [gameStateNum], ST_COMPLETE
    jmp near mainloop

; Ye level-complete state hai; completion screen dikhakar game ko title state mein bhejti hai.
st_complete:
    mov byte [levelDone], 0
    mov ax, [timeLeft]
    call screen_level_complete
    call new_game_init
    mov word [gameStateNum], ST_TITLE
    jmp near mainloop

; Ye game-over state hai; game-over screen dikhakar naya game start karne ke liye title par jati hai.
st_gameover:
    call screen_game_over
    call new_game_init
    mov word [gameStateNum], ST_TITLE
    jmp near mainloop

; Ye exit state hai; game ko safely close karne wali routine par jump karti hai.
st_exit:
    jmp near exitgame

; Ye quit request handle karti hai; current game reset karke title screen par le jati hai.
quit_to_title:
    mov byte [quitflag], 0
    call new_game_init
    mov word [gameStateNum], ST_TITLE
    jmp near mainloop


;Ye ek gameplay frame ka complete sequence chalati hai: input, physics, camera, level drawing aur screen render.
play_frame:
    call checkinput                
    call applyphysics               
    call UpdateCamera
    call drawlevel                  

    cmp byte [deathPending], 1      
    je near .pf_done
    cmp byte [winPhase], 3
    je near .pf_wait               
    mov ax, 200
    sub ax, [marioH]
    cmp [marioY], ax
    jg near .pf_wait               
    push word [screenX]
    push word [marioY]
    call DrawMarioSprite
.pf_wait:
    call WaitTick                   
    call RenderBuffer               ;
.pf_done:
    ret

; Ye cleanup routine hai; timer aur keyboard hooks remove karke text mode aur DOS exit call karti hai.
exitgame:
    call uninstalltimer           
    call uninstallkeyboard        
    call exitText                   
    mov ax, 4C00h
    int 21h

; Ye memory error handle karti hai; message show karke program ko error code ke sath band karti hai.
nomem:
    mov dx, nomemmsg
    mov ah, 09h
    int 21h
    mov ax, 4C01h
    int 21h

nomemmsg db 'Not enough memory.$'

%include "source/level/level.asm"
%include "source/level/level2.asm"
%include "source/gfx/colors.inc"
%include "source/gfx/stairgfx.asm"
%include "source/level/level3.asm"
%include "source/mech/score.asm"
%include "source/ui/font.asm"
%include "source/ui/Hud.asm"
%include "source/mech/game.asm"
%include "source/ui/pause.asm"
%include "source/ui/life.asm"
%include "source/ui/over.asm"
%include "source/ui/comple.asm"
%include "source/gfx/pipegfx.asm"
%include "source/mech/move.asm"
%include "source/mech/coll.asm"
%include "source/mech/camera.asm"
%include "source/gfx/drw.asm"
%include "source/gfx/coingfx.asm"
%include "source/mech/coin.asm"
%include "source/mech/coin2.asm"
%include "source/gfx/shrmgfx.asm"
%include "source/mech/shroom.asm"
%include "source/gfx/brkgfx.asm"
%include "source/gfx/blkgfx.asm"
%include "source/gfx/googfx.asm"
%include "source/mech/goomba.asm"
%include "source/gfx/trtegfx.asm"
%include "source/mech/turtle.asm"
%include "source/ui/text.asm"
%include "source/ui/start.asm"
%include "source/mech/input.asm"
%include "source/mech/timer.asm"
%include "source/gfx/margfx.asm"
%include "source/gfx/gfx_vid.asm"    
