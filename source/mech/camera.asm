cameraX       dw 0
screenX       dw 0
MAX_CAMERA_X  equ 640        

;Ye subroutine cameraX ko Mario ki movement ke mutabiq update karti hai aur level ki scrolling ko limit mein rakhti hai.
UpdateCamera:
    ; Calculate screen_x = marioX - cameraX
    mov ax, [marioX]
    sub ax, [cameraX]
    mov [screenX], ax
    ; Check if Mario is past the center (160 pixels)
    cmp ax, 160
    jle .CheckLeftWall
    ; Calculate new_camera = marioX - 160
    mov ax, [marioX]
    sub ax, 160
    ; Limit camera to the end of the level
    cmp ax, MAX_CAMERA_X
    jle .ApplyCameraMax
    mov ax, MAX_CAMERA_X

.ApplyCameraMax:
    ; cameraX = max(cameraX, new_camera)
    cmp ax, [cameraX]
    jle .CheckLeftWall
    mov [cameraX], ax

.CheckLeftWall:
    ; Invisible left wall: marioX < cameraX
    mov ax, [marioX]
    cmp ax, [cameraX]
    jge .CameraUpdateDone

    ; Force Mario back to the camera's left edge
    mov ax, [cameraX]
    mov [marioX], ax
    mov word [velX], 0         

.CameraUpdateDone:
    ; Recalculate screenX in case the left wall pushed Mario
    mov ax, [marioX]
    sub ax, [cameraX]
    mov [screenX], ax
    ret
