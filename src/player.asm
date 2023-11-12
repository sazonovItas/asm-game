proc Player.Constructor uses edi,\
    pPlayer, width, height, pPosition

    mov     edi, [pPlayer]

    mov     eax, [width]
    mov     [edi + Player.camera + Camera.width], eax
    mov     eax, [height]
    mov     [edi + Player.camera + Camera.height], eax

    push    edi
    add     edi, Player.Position
    stdcall Vector3.Copy, edi, [pPosition] 
    pop     edi

    push    edi
    add     edi, Player.camera
    add     edi, Camera.camPosition
    stdcall Vector3.Copy, edi, [pPosition] 
    pop     edi

    push    edi
    add     edi, Player.prevPosition
    stdcall Vector3.Copy, edi, [pPosition] 
    pop     edi

    mov     [edi + Player.Acceleration + Vector3.x], 0.0
    fld     [EARTH_GRAVITY]
    fstp    [edi + Player.Acceleration + Vector3.y]
    mov     [edi + Player.Acceleration + Vector3.z], 0.0

    mov     [edi + Player.camera + Camera.pitch], 0.0
    mov     [edi + Player.camera + Camera.yaw], -1.57

    stdcall Camera.Direction, edi
    stdcall Player.Direction, edi

    mov     [edi + Player.camera + Camera.Up + Vector3.x], 0.0
    mov     [edi + Player.camera + Camera.Up + Vector3.y], 1.0
    mov     [edi + Player.camera + Camera.Up + Vector3.z], 0.0

    mov     [edi + Player.speed], 0.01
    mov     [edi + Player.jumpVeloc], 0.055
    mov     [edi + Player.camera + Camera.sensitivity], 0.0005
    mov     [edi + Player.Condition], JUMP_CONDITION

    ; Able to change field of view
    mov     [edi + Player.camera + Camera.fovDeg], 90.0
    mov     [edi + Player.camera + Camera.nearPlane], 0.01
    mov     [edi + Player.camera + Camera.farPlane], 1000.0

    ; chasingRadius of camera
    mov     [edi + Player.chasingRadius], 0.5 

    ; translate coordinates 
    mov     [edi + Player.camera + Camera.radius], 4.5 
    mov     [edi + Player.maxCamRadius], 6.0
    mov     [edi + Player.minCamRadius], 0.2
    mov     [edi + Player.curCamRadius], 4.5
    mov     [edi + Player.camera + Camera.translate + Vector3.x], 0.0
    mov     [edi + Player.camera + Camera.translate + Vector3.y], 0.0
    mov     [edi + Player.camera + Camera.translate + Vector3.z], 0.0 

    ; Camera chasing easing
    mov     [edi + Player.camera + Camera.moving + Easing.ptrEasingFun], dword Easing.easeOutQuort
    mov     [edi + Player.camera + Camera.moving + Easing.duration], 500 
    mov     [edi + Player.camera + Camera.moving + Easing.startTime], 0
    mov     [edi + Player.camera + Camera.moving + Easing.start], false
    mov     [edi + Player.camera + Camera.moving + Easing.done], false
    mov     [edi + Player.camera + Camera.moving + Easing.orinVec + Vector3.x], 0.0
    mov     [edi + Player.camera + Camera.moving + Easing.orinVec + Vector3.y], 0.0
    mov     [edi + Player.camera + Camera.moving + Easing.orinVec + Vector3.z], 0.0

    ; Camera texture easing 
    mov     [edi + Player.camTexture + Easing.ptrEasingFun], dword Easing.easeOutQuort
    mov     [edi + Player.camTexture + Easing.duration], 200 
    mov     [edi + Player.camTexture + Easing.startTime], 0
    mov     [edi + Player.camTexture + Easing.start], false
    mov     [edi + Player.camTexture + Easing.done], false
    mov     [edi + Player.camTexture + Easing.orinVec + Vector3.x], 0.0
    mov     [edi + Player.camTexture + Easing.orinVec + Vector3.y], 0.0
    mov     [edi + Player.camTexture + Easing.orinVec + Vector3.z], 0.0

    ; Animation functions
    ; Forward ani
    mov     [edi + Player.forwAni + Easing.ptrEasingFun], dword Easing.easeOutQuort
    mov     [edi + Player.forwAni + Easing.duration], 500 
    mov     [edi + Player.forwAni + Easing.startTime], 0
    mov     [edi + Player.forwAni + Easing.start], false
    mov     [edi + Player.forwAni + Easing.done], false
    mov     [edi + Player.forwAni + Easing.orinVec + Vector3.x], 0.0
    mov     [edi + Player.forwAni + Easing.orinVec + Vector3.y], 0.0
    mov     [edi + Player.forwAni + Easing.orinVec + Vector3.z], 0.0


    ; Backward ani
    mov     [edi + Player.backAni + Easing.ptrEasingFun], dword Easing.easeOutQuort
    mov     [edi + Player.backAni + Easing.duration], 500 
    mov     [edi + Player.backAni + Easing.startTime], 0
    mov     [edi + Player.backAni + Easing.start], false
    mov     [edi + Player.backAni + Easing.done], false
    mov     [edi + Player.backAni + Easing.orinVec + Vector3.x], 0.0
    mov     [edi + Player.backAni + Easing.orinVec + Vector3.y], 0.0
    mov     [edi + Player.backAni + Easing.orinVec + Vector3.z], 0.0

    ; left  ani
    mov     [edi + Player.leftAni + Easing.ptrEasingFun], dword Easing.easeOutQuort
    mov     [edi + Player.leftAni + Easing.duration], 500 
    mov     [edi + Player.leftAni + Easing.startTime], 0
    mov     [edi + Player.leftAni + Easing.start], false
    mov     [edi + Player.leftAni + Easing.done], false
    mov     [edi + Player.leftAni + Easing.orinVec + Vector3.x], 0.0
    mov     [edi + Player.leftAni + Easing.orinVec + Vector3.y], 0.0
    mov     [edi + Player.leftAni + Easing.orinVec + Vector3.z], 0.0

    ; right  ani
    mov     [edi + Player.rightAni + Easing.ptrEasingFun], dword Easing.easeOutQuort
    mov     [edi + Player.rightAni + Easing.duration], 500 
    mov     [edi + Player.rightAni + Easing.startTime], 0
    mov     [edi + Player.rightAni + Easing.start], false
    mov     [edi + Player.rightAni + Easing.done], false
    mov     [edi + Player.rightAni + Easing.orinVec + Vector3.x], 0.0
    mov     [edi + Player.rightAni + Easing.orinVec + Vector3.y], 0.0
    mov     [edi + Player.rightAni + Easing.orinVec + Vector3.z], 0.0

    ; slow Forward ani
    mov     [edi + Player.bforwAni + Easing.ptrEasingFun], dword Easing.easeSlow
    mov     [edi + Player.bforwAni + Easing.duration], 250 
    mov     [edi + Player.bforwAni + Easing.startTime], 0
    mov     [edi + Player.bforwAni + Easing.start], false
    mov     [edi + Player.bforwAni + Easing.done], false
    mov     [edi + Player.bforwAni + Easing.orinVec + Vector3.x], 0.0
    mov     [edi + Player.bforwAni + Easing.orinVec + Vector3.y], 0.0
    mov     [edi + Player.bforwAni + Easing.orinVec + Vector3.z], 0.0

    ; slow Backward ani
    mov     [edi + Player.bbackAni + Easing.ptrEasingFun], dword Easing.easeSlow
    mov     [edi + Player.bbackAni + Easing.duration], 250 
    mov     [edi + Player.bbackAni + Easing.startTime], 0
    mov     [edi + Player.bbackAni + Easing.start], false
    mov     [edi + Player.bbackAni + Easing.done], false
    mov     [edi + Player.bbackAni + Easing.orinVec + Vector3.x], 0.0
    mov     [edi + Player.bbackAni + Easing.orinVec + Vector3.y], 0.0
    mov     [edi + Player.bbackAni + Easing.orinVec + Vector3.z], 0.0

    ; slow left  ani
    mov     [edi + Player.bleftAni + Easing.ptrEasingFun], dword Easing.easeSlow
    mov     [edi + Player.bleftAni + Easing.duration], 250 
    mov     [edi + Player.bleftAni + Easing.startTime], 0
    mov     [edi + Player.bleftAni + Easing.start], false
    mov     [edi + Player.bleftAni + Easing.done], false
    mov     [edi + Player.bleftAni + Easing.orinVec + Vector3.x], 0.0
    mov     [edi + Player.bleftAni + Easing.orinVec + Vector3.y], 0.0
    mov     [edi + Player.bleftAni + Easing.orinVec + Vector3.z], 0.0

    ; slow right  ani
    mov     [edi + Player.brightAni + Easing.ptrEasingFun], dword Easing.easeSlow
    mov     [edi + Player.brightAni + Easing.duration], 250 
    mov     [edi + Player.brightAni + Easing.startTime], 0
    mov     [edi + Player.brightAni + Easing.start], false
    mov     [edi + Player.brightAni + Easing.done], false
    mov     [edi + Player.brightAni + Easing.orinVec + Vector3.x], 0.0
    mov     [edi + Player.brightAni + Easing.orinVec + Vector3.y], 0.0
    mov     [edi + Player.brightAni + Easing.orinVec + Vector3.z], 0.0

    ; fall ani
    mov     [edi + Player.fallAni + Easing.ptrEasingFun], dword Easing.easeLine
    mov     [edi + Player.fallAni + Easing.duration], 2500 
    mov     [edi + Player.fallAni + Easing.startTime], 0
    mov     [edi + Player.fallAni + Easing.start], false
    mov     [edi + Player.fallAni + Easing.done], false
    mov     [edi + Player.fallAni + Easing.orinVec + Vector3.x], 0.0
    mov     [edi + Player.fallAni + Easing.orinVec + Vector3.y], -1.0
    mov     [edi + Player.fallAni + Easing.orinVec + Vector3.z], 0.0

    ; jump ani
    mov     [edi + Player.jumpAni + Easing.ptrEasingFun], dword Easing.easeInCos
    mov     [edi + Player.jumpAni + Easing.duration], 250
    mov     [edi + Player.jumpAni + Easing.startTime], 0
    mov     [edi + Player.jumpAni + Easing.start], false
    mov     [edi + Player.jumpAni + Easing.done], false
    mov     [edi + Player.jumpAni + Easing.orinVec + Vector3.x], 0.0
    mov     [edi + Player.jumpAni + Easing.orinVec + Vector3.y], 1.0
    mov     [edi + Player.jumpAni + Easing.orinVec + Vector3.z], 0.0

    ; size of player collision
    mov     [edi + Player.sizeBlockCol], 0.5 

    invoke SetCursorPos, cursorPosX, cursorPosY
    invoke GetCursorPos, lastCursorPos
    
    ret
endp

proc Player.Direction uses edi,\
    pPlayer 

    locals 
        null        dd      0.0
    endl

    mov     edi, [pPlayer]

    ; Ox camera direction
    fld     [null]
    fcos    
    fld     [edi + Player.camera + Camera.yaw]
    fcos 
    fmulp
    fstp    [edi + Player.Dir + Vector3.x]

    ; Oy camera direction
    fld     [null]
    fsin    
    fstp    [edi + Player.Dir + Vector3.y]

    ; Oz camera direction
    fld     [null]
    fcos    
    fld     [edi + Player.camera + Camera.yaw]
    fsin 
    fmulp
    fstp    [edi + Player.Dir + Vector3.z]

    ret
endp

proc Player.EasingMove uses edi esi ebx,\
    pPlayer, dt, sizeMap, pMap

    locals 
        deltaPos        Vector3         ?
        div2            dd              2.0
        collision       dd              0
    endl

    mov     edi, [pPlayer]

    push    edi
    mov     esi, edi
    add     edi, Player.Position
    add     esi, Player.prevPosition
    stdcall Vector3.Copy, esi, edi
    pop     edi

    lea     ebx, [deltaPos]
        
    push    edi
    add     edi, Player.Velocity
    stdcall Vector3.Copy, ebx, edi
    pop     edi

    stdcall Vector3.MultOnNumber, ebx, [dt]

    lea     ebx, [deltaPos]
    fld     [edi + Player.Position + Vector3.y]
    fadd    [ebx + Vector3.y]
    fstp    [edi + Player.Position + Vector3.y]

    ; Y collision
    lea     ebx, [collision]
    stdcall Collision.MapDetection, [pPlayer], [sizeMap], [pMap], ebx, Y_COLLISION
    cmp     eax, NO_COLLISION
    je      .SkipWalkCondition

    mov     eax, [edi + Player.prevPosition + Vector3.y]
    mov     [edi + Player.Position + Vector3.y], eax

    lea     ebx, [deltaPos]
    stdcall Collision.BinSearch, [pPlayer], [sizeMap], [pMap], Y_COLLISION, (Player.Position + Vector3.y),\
                (Player.prevPosition + Vector3.y), [ebx + Vector3.y]

    cmp     [collision], DIR_Y_MAX
    je      .DownY

    cmp     [collision], DIR_Y_MIN
    je      .UpY

    jmp     .BothY

    .DownY:

        mov     [edi + Player.Condition], WALK_CONDITION
    
        mov     [edi + Player.fallAni + Easing.start], false
        mov     [edi + Player.fallAni + Easing.done], false

        mov     [edi + Player.jumpAni + Easing.start], false
        mov     [edi + Player.jumpAni + Easing.done], false

        jmp     .SkipY

    .UpY:

        mov     [edi + Player.Condition], JUMP_CONDITION

        mov     [edi + Player.fallAni + Easing.start], false
        mov     [edi + Player.fallAni + Easing.done], false

        mov     [edi + Player.jumpAni + Easing.start], false
        mov     [edi + Player.jumpAni + Easing.done], false
        
        jmp     .SkipY

    .BothY:

        mov     [edi + Player.Condition], WALK_CONDITION

        mov     [edi + Player.fallAni + Easing.start], false
        mov     [edi + Player.fallAni + Easing.done], false

        mov     [edi + Player.jumpAni + Easing.start], false
        mov     [edi + Player.jumpAni + Easing.done], false

        jmp     .SkipY

    .SkipY:

    jmp     .SkipYCollision

    .SkipWalkCondition:

    mov     [edi + Player.Condition], JUMP_CONDITION

    .SkipYCollision:

    lea     ebx, [deltaPos]
    fld     [edi + Player.Position + Vector3.x]
    fadd    [ebx + Vector3.x]
    fstp    [edi + Player.Position + Vector3.x]

    ; X collision
    lea     ebx, [collision]
    stdcall Collision.MapDetection, [pPlayer], [sizeMap], [pMap], ebx, X_COLLISION
    cmp     eax, NO_COLLISION
    je      .SkipXCollision

    mov     eax, [edi + Player.prevPosition + Vector3.x]
    mov     [edi + Player.Position + Vector3.x], eax

    lea     ebx, [deltaPos]
    stdcall Collision.BinSearch, [pPlayer], [sizeMap], [pMap], Y_COLLISION, (Player.Position + Vector3.x),\
                (Player.prevPosition + Vector3.x), [ebx + Vector3.x]

    .SkipXCollision:

    lea     ebx, [deltaPos]
    fld     [edi + Player.Position + Vector3.z]
    fadd    [ebx + Vector3.z]
    fstp    [edi + Player.Position + Vector3.z]

    ; Z collision
    lea     ebx, [collision]
    stdcall Collision.MapDetection, [pPlayer], [sizeMap], [pMap], ebx, Z_COLLISION
    cmp     eax, NO_COLLISION
    je      .SkipZCollision

    mov     eax, [edi + Player.prevPosition + Vector3.z]
    mov     [edi + Player.Position + Vector3.z], eax

    lea     ebx, [deltaPos]
    stdcall Collision.BinSearch, [pPlayer], [sizeMap], [pMap], Y_COLLISION, (Player.Position + Vector3.z),\
                (Player.prevPosition + Vector3.z), [ebx + Vector3.z]

    .SkipZCollision:

    stdcall Player.EasingMoveCamera, [pPlayer], [dt], [sizeMap], [pMap]

.Ret:
    ret
endp

proc Player.EasingInputsKeys uses edi esi ebx,\
    pPlayer, sizeMap, pMap

    locals 
        velocity        dd          0.0
        negConst        dd          -1.0
        tmp             Vector3     ?
        ok              db          0
        boost           dd          1.5
    endl

    mov     edi, [pPlayer]

    ; Zeroing Velocity
    push    edi
    add     edi, Player.Velocity
    stdcall memzero, edi, 3 * 4
    pop     edi

    stdcall Player.EasingHandlerJump, [pPlayer]

    ; Calculate Velocity that depends on animations
    ; Forward animation
    push    edi 
    add     edi, Player.Dir
    stdcall Vector3.Copy, orinVec, edi
    pop     edi

    push    edi
    add     edi, Player.forwAni
    movzx   eax, [pl_forward]
    stdcall Player.EasingHandlerBasicMoves, [pPlayer], edi, eax
    pop     edi

    ; Backward animation
    push    edi 
    add     edi, Player.Dir
    stdcall Vector3.Copy, orinVec, edi
    pop     edi

    stdcall Vector3.MultOnNumber, orinVec, [negConst]

    push    edi
    add     edi, Player.backAni
    movzx   eax, [pl_backward]
    stdcall Player.EasingHandlerBasicMoves, [pPlayer], edi, eax
    pop     edi

    ; Left animation
    lea     ebx, [tmp]
    push    edi
    add     edi, Player.Dir
    stdcall Vector3.Copy, ebx, edi
    pop     edi

    push    edi
    add     edi, (Player.camera + Camera.Up)
    stdcall Vector3.Copy, upVec, edi
    pop     edi

    stdcall Vector3.Cross, upVec, ebx, orinVec

    push    edi
    add     edi, Player.leftAni
    movzx   eax, [pl_left]
    stdcall Player.EasingHandlerBasicMoves, [pPlayer], edi, eax
    pop     edi

    ; right animation
    lea     ebx, [tmp]
    push    edi
    add     edi, Player.Dir
    stdcall Vector3.Copy, ebx, edi
    pop     edi

    push    edi
    add     edi, (Player.camera + Camera.Up)
    stdcall Vector3.Copy, upVec, edi
    pop     edi

    stdcall Vector3.Cross, ebx, upVec, orinVec

    push    edi
    add     edi, Player.rightAni
    movzx   eax, [pl_right]
    stdcall Player.EasingHandlerBasicMoves, [pPlayer], edi, eax
    pop     edi

    ; Slowing animation
    ; Forward animation
    push    edi 
    add     edi, Player.Dir
    stdcall Vector3.Copy, orinVec, edi
    pop     edi

    push    edi
    add     edi, Player.bforwAni
    movzx   eax, [pl_forward]
    xor     eax, 1
    stdcall Player.EasingHandlerBasicMoves, [pPlayer], edi, eax
    pop     edi

    ; Backward animation
    push    edi 
    add     edi, Player.Dir
    stdcall Vector3.Copy, orinVec, edi
    pop     edi

    stdcall Vector3.MultOnNumber, orinVec, [negConst]

    push    edi
    add     edi, Player.bbackAni
    movzx   eax, [pl_backward]
    xor     eax, 1
    stdcall Player.EasingHandlerBasicMoves, [pPlayer], edi, eax
    pop     edi

    ; Left animation
    lea     ebx, [tmp]
    push    edi
    add     edi, Player.Dir
    stdcall Vector3.Copy, ebx, edi
    pop     edi

    push    edi
    add     edi, (Player.camera + Camera.Up)
    stdcall Vector3.Copy, upVec, edi
    pop     edi

    stdcall Vector3.Cross, upVec, ebx, orinVec

    push    edi
    add     edi, Player.bleftAni
    movzx   eax, [pl_left]
    xor     eax, 1
    stdcall Player.EasingHandlerBasicMoves, [pPlayer], edi, eax
    pop     edi

    ; right animation
    lea     ebx, [tmp]
    push    edi
    add     edi, Player.Dir
    stdcall Vector3.Copy, ebx, edi
    pop     edi

    push    edi
    add     edi, (Player.camera + Camera.Up)
    stdcall Vector3.Copy, upVec, edi
    pop     edi

    stdcall Vector3.Cross, ebx, upVec, orinVec

    push    edi
    add     edi, Player.brightAni
    movzx   eax, [pl_right]
    xor     eax, 1
    stdcall Player.EasingHandlerBasicMoves, [pPlayer], edi, eax
    pop     edi

    ; Shift -> boost to speed
    cmp     [pl_run], false
    je      @F
    
    mov     [edi + Player.speed], 0.015

    jmp     .SkipRun

    @@:

    mov    [edi + Player.speed], 0.01

    .SkipRun:

    stdcall Player.EasingHandlerCamera, [pPlayer], [sizeMap], [pMap]

.Ret:
    ret
endp

proc Player.EasingHandlerBasicMoves uses edi esi,\
    pPlayer, pAni, trigger

    locals 
        velocity        dd      0.0
    endl

    mov     edi, [pPlayer]
    mov     esi, [pAni]

    ; Forward animation
    cmp     [trigger], false
    je      .SkipUpdateAni

    cmp     [esi + Easing.done], true
    je     .SkipDoneAni

    cmp     [esi + Easing.start], true
    je      .SkipStartAni

    mov     [esi + Easing.start], true
    invoke  GetTickCount
    mov     [esi + Easing.startTime], eax

    .SkipStartAni:

    invoke  GetTickCount
    sub     eax, [esi + Easing.startTime]
    cmp     eax, [esi + Easing.duration]
    ja      .SkipDoneAni

    stdcall [esi + Easing.ptrEasingFun], eax
    mov     [velocity], eax 

    fld     [edi + Player.speed]
    fmul    [velocity]
    fstp    [velocity]

    stdcall Vector3.MultOnNumber, orinVec, [velocity]

    fld     [edi + Player.Velocity + Vector3.x]
    fadd    [orinVec + Vector3.x]
    fstp    [edi + Player.Velocity + Vector3.x]
    fld     [edi + Player.Velocity + Vector3.z]
    fadd    [orinVec + Vector3.z]
    fstp    [edi + Player.Velocity + Vector3.z]

    jmp     .SkipAni

    .SkipDoneAni:

    mov     [esi + Easing.done], true

    stdcall [esi + Easing.ptrEasingFun], [esi + Easing.duration]
    mov     [velocity], eax

    fld     [edi + Player.speed]
    fmul    [velocity]
    fstp    [velocity]

    stdcall Vector3.MultOnNumber, orinVec, [velocity]

    fld     [edi + Player.Velocity + Vector3.x]
    fadd    [orinVec + Vector3.x]
    fstp    [edi + Player.Velocity + Vector3.x]
    fld     [edi + Player.Velocity + Vector3.z]
    fadd    [orinVec + Vector3.z]
    fstp    [edi + Player.Velocity + Vector3.z]

    jmp     .SkipAni

    .SkipUpdateAni:

    cmp     [esi + Easing.start], false
    je      .SkipAni

    mov     [esi + Easing.start], false
    mov     [esi + Easing.done], false

    .SkipAni:

    .Ret: 
    ret
endp

proc Player.EasingHandlerJump uses edi esi ebx,\
    pPlayer

    locals 
        velocity        dd          0.0
    endl

    mov     edi, [pPlayer]

    ; Fall animation
    mov     esi, edi 
    add     esi, Player.fallAni

    cmp     [edi + Player.Condition], JUMP_CONDITION
    jne     .SkipUpdateFallAni

    cmp     [esi + Easing.done], true
    je     .SkipDoneFallAni

    cmp     [esi + Easing.start], true
    je      .SkipStartFallAni

    mov     [esi + Easing.start], true
    invoke  GetTickCount
    mov     [esi + Easing.startTime], eax

    .SkipStartFallAni:

    invoke  GetTickCount
    sub     eax, [esi + Easing.startTime]
    cmp     eax, [esi + Easing.duration]
    ja      .SkipDoneFallAni

    stdcall [esi + Easing.ptrEasingFun], eax
    mov     [velocity], eax 

    fld     [edi + Player.Acceleration + Vector3.y]
    fmul    [velocity]
    fstp    [velocity]

    fld     [edi + Player.Velocity + Vector3.y]
    fadd    [velocity]
    fstp    [edi + Player.Velocity + Vector3.y]

    jmp     .SkipFallAni

    .SkipDoneFallAni:

    stdcall [esi + Easing.ptrEasingFun], [esi + Easing.duration] 
    mov     [velocity], eax 

    fld     [edi + Player.Acceleration + Vector3.y]
    fmul    [velocity]
    fstp    [velocity]

    fld     [edi + Player.Velocity + Vector3.y]
    fadd    [velocity]
    fstp    [edi + Player.Velocity + Vector3.y]

    jmp     .SkipFallAni

    .SkipUpdateFallAni:

    cmp     [esi + Easing.start], false
    je      .SkipFallAni

    mov     [esi + Easing.start], false
    mov     [esi + Easing.done], false

    .SkipFallAni:


    ; Jump animation
    mov     esi, edi 
    add     esi, Player.jumpAni

    cmp     [esi + Easing.done], true
    je     .SkipDoneJumpAni

    cmp     [esi + Easing.start], true
    je      .SkipStartJumpAni

    cmp     [pl_jump], false
    je     .SkipUpdateJumpAni

    cmp     [edi + Player.Condition], JUMP_CONDITION
    je     .SkipUpdateJumpAni

    mov     [edi + Player.Condition], JUMP_CONDITION
    mov     [esi + Easing.start], true
    invoke  GetTickCount
    mov     [esi + Easing.startTime], eax

    .SkipStartJumpAni:

    invoke  GetTickCount
    sub     eax, [esi + Easing.startTime]
    cmp     eax, [esi + Easing.duration]
    ja      .SkipDoneJumpAni

    stdcall [esi + Easing.ptrEasingFun], eax
    mov     [velocity], eax 

    fld     [edi + Player.jumpVeloc]
    fmul    [velocity]
    fstp    [velocity]

    push    esi
    add     esi, Easing.orinVec
    stdcall Vector3.Copy, orinVec, esi
    stdcall Vector3.MultOnNumber, orinVec, [velocity]
    pop     esi

    fld     [edi + Player.Velocity + Vector3.x]
    fadd    [orinVec + Vector3.x]
    fstp    [edi + Player.Velocity + Vector3.x]
    fld     [edi + Player.Velocity + Vector3.y]
    fadd    [orinVec + Vector3.y]
    fstp    [edi + Player.Velocity + Vector3.y]
    fld     [edi + Player.Velocity + Vector3.z]
    fadd    [orinVec + Vector3.z]
    fstp    [edi + Player.Velocity + Vector3.z]

    jmp     .SkipJumpAni

    .SkipDoneJumpAni:

    stdcall [esi + Easing.ptrEasingFun], [esi + Easing.duration] 
    mov     [velocity], eax 

    fld     [edi + Player.jumpVeloc]
    fmul    [velocity]
    fstp    [velocity]

    push    esi
    add     esi, Easing.orinVec
    stdcall Vector3.Copy, orinVec, esi
    stdcall Vector3.MultOnNumber, orinVec, [velocity]
    pop     esi

    fld     [edi + Player.Velocity + Vector3.x]
    fadd    [orinVec + Vector3.x]
    fstp    [edi + Player.Velocity + Vector3.x]
    fld     [edi + Player.Velocity + Vector3.y]
    fadd    [orinVec + Vector3.y]
    fstp    [edi + Player.Velocity + Vector3.y]
    fld     [edi + Player.Velocity + Vector3.z]
    fadd    [orinVec + Vector3.z]
    fstp    [edi + Player.Velocity + Vector3.z]


    jmp     .SkipJumpAni

    .SkipUpdateJumpAni:

    cmp     [esi + Easing.start], false
    je      .SkipJumpAni

    mov     [esi + Easing.start], false
    mov     [esi + Easing.done], false

    .SkipJumpAni:


.Ret:
    ret
endp

proc Player.EasingHandlerCamera uses edi esi ebx,\
    pPlayer, sizeMap, pMap

    locals 
        camchasingRadius        dd              ?
        velocity                dd              0.0
        tmpDist                 dd              0.05
        trigger                 dd              false
        tmp                     Vector3         ?
        tmpVel                  dd              ?
        conNum                  dd              3.0
    endl

    mov     edi, [pPlayer]

    ; Zeroing Velocity
    push    edi
    add     edi, (Player.camera + Camera.camVelocity)
    stdcall memzero, edi, 3 * 4
    pop     edi

    push    edi
    mov     esi, edi
    add     edi, Player.Position
    add     esi, (Player.camera + Camera.camPosition)
    stdcall Vector3.Distance, edi, esi
    pop     edi

    mov     [camchasingRadius], eax
    fld     [camchasingRadius]
    fcomp   [edi + Player.chasingRadius]
    fstsw   ax
    sahf
    jb      @F

    mov     [trigger], true

    @@: 

    cmp     [pl_stop_cam_chasing], true
    je      .SkipCamChasing

    push    edi
    mov     esi, edi
    add     esi, (Player.camera + Camera.camPosition)
    add     edi, Player.Position
    stdcall Vector3.Copy, orinVec, edi
    stdcall Vector3.Sub, orinVec, esi
    pop     edi

    mov     esi, edi
    add     esi, (Player.camera + Camera.moving)

    ; Cam animation
    cmp     [trigger], false
    je      .SkipUpdateChasingAni

    cmp     [esi + Easing.done], true
    je     .SkipDoneChasingAni

    cmp     [esi + Easing.start], true
    je      .SkipStartChasingAni

    mov     [esi + Easing.start], true
    invoke  GetTickCount
    mov     [esi + Easing.startTime], eax

    .SkipStartChasingAni:

    invoke  GetTickCount
    sub     eax, [esi + Easing.startTime]
    cmp     eax, [esi + Easing.duration]
    ja      .SkipDoneChasingAni

    stdcall [esi + Easing.ptrEasingFun], eax
    mov     [velocity], eax 

    fld     [edi + Player.speed]
    fmul    [velocity]
    fstp    [velocity]

    stdcall Vector3.MultOnNumber, orinVec, [velocity]

    fld     [edi + Player.camera + Camera.camVelocity + Vector3.x]
    fadd    [orinVec + Vector3.x]
    fstp    [edi + Player.camera + Camera.camVelocity + Vector3.x]
    fld     [edi + Player.camera + Camera.camVelocity + Vector3.y]
    fadd    [orinVec + Vector3.y]
    fstp    [edi + Player.camera + Camera.camVelocity + Vector3.y]
    fld     [edi + Player.camera + Camera.camVelocity + Vector3.z]
    fadd    [orinVec + Vector3.z]
    fstp    [edi + Player.camera + Camera.camVelocity + Vector3.z]

    jmp     .SkipChasingAni

    .SkipDoneChasingAni:

    mov     [esi + Easing.done], true

    stdcall [esi + Easing.ptrEasingFun], [esi + Easing.duration]
    mov     [velocity], eax

    fld     [edi + Player.speed]
    fmul    [velocity]
    fstp    [velocity]

    stdcall Vector3.MultOnNumber, orinVec, [velocity]

    fld     [edi + Player.camera + Camera.camVelocity + Vector3.x]
    fadd    [orinVec + Vector3.x]
    fstp    [edi + Player.camera + Camera.camVelocity + Vector3.x]
    fld     [edi + Player.camera + Camera.camVelocity + Vector3.y]
    fadd    [orinVec + Vector3.y]
    fstp    [edi + Player.camera + Camera.camVelocity + Vector3.y]
    fld     [edi + Player.camera + Camera.camVelocity + Vector3.z]
    fadd    [orinVec + Vector3.z]
    fstp    [edi + Player.camera + Camera.camVelocity + Vector3.z]

    jmp     .SkipChasingAni

    .SkipUpdateChasingAni:

    cmp     [esi + Easing.start], false
    je      .SkipChasingAni

    mov     [esi + Easing.start], false
    mov     [esi + Easing.done], false

    .SkipChasingAni:

    .SkipCamChasing:


    ; texture easing
    mov     [edi + Player.camTextureVel], 0.0

    ; texture radius
    cmp     [pl_stop_cam_tex], true
    je      .SkipCamTex

    stdcall Collision.RayDetection, [pPlayer], [sizeMap], [pMap]
    mov     [edi + Player.curCamRadius], eax

    fld     [edi + Player.curCamRadius]
    fsub    [edi + Player.camera + Camera.radius]
    fstp    [tmpVel]

    mov     esi, edi
    add     esi, Player.camTexture

    cmp     [esi + Easing.done], true
    je     .SkipDoneTextureAni

    cmp     [esi + Easing.start], true
    je      .SkipStartTextureAni

    mov     [esi + Easing.start], true
    invoke  GetTickCount
    mov     [esi + Easing.startTime], eax

    .SkipStartTextureAni:

    invoke  GetTickCount
    sub     eax, [esi + Easing.startTime]
    cmp     eax, [esi + Easing.duration]
    ja      .SkipDoneTextureAni

    stdcall [esi + Easing.ptrEasingFun], eax
    mov     [velocity], eax 

    fld     [edi + Player.speed]
    fmul    [velocity]
    fstp    [velocity]

    fld     [tmpVel]
    fmul    [velocity]
    fstp    [edi + Player.camTextureVel]

    jmp     .SkipTextureAni

    .SkipDoneTextureAni:

    mov     [esi + Easing.done], true

    stdcall [esi + Easing.ptrEasingFun], [esi + Easing.duration]
    mov     [velocity], eax

    fld     [edi + Player.speed]
    fmul    [velocity]
    fstp    [velocity]

    fld     [tmpVel]
    fmul    [velocity]
    fstp    [edi + Player.camTextureVel]

    jmp     .SkipTextureAni

    .SkipUpdateTextureAni:

    cmp     [esi + Easing.start], false
    je      .SkipTextureAni

    mov     [esi + Easing.start], false
    mov     [esi + Easing.done], false

    .SkipTextureAni:

    .SkipCamTex:


    ret
endp

proc Player.EasingMoveCamera uses edi esi ebx,\
    pPlayer, dt, sizeMap, pMap

    locals 
        deltaPos        Vector3         ?
        deltaRadius     GLfloat         ?
    endl

    mov     edi, [pPlayer]

    fld     [edi + Player.camTextureVel]
    fmul    [dt]
    fstp    [deltaRadius]

    fld     [edi + Player.camera + Camera.radius]
    fadd    [deltaRadius]
    fstp    [edi + Player.camera + Camera.radius]

    push    edi
    lea     ebx, [deltaPos]
    add     edi, (Player.camera + Camera.camVelocity)
    stdcall Vector3.Copy, ebx, edi
    pop     edi

    stdcall Vector3.MultOnNumber, ebx, [dt]

    push    edi
    add     edi, (Player.camera + Camera.camPosition)
    stdcall Vector3.Add, edi, ebx
    pop     edi

    ret
endp

proc Player.CameraRadiusHandler uses edi esi ebx,\

.Ret:
    ret
endp

proc Player.InputsMouse uses edi esi ebx,\
    pPlayer, wParam, lParam

    locals 
        sensetivity     dd          ?
        xoffset         dd          ?
        yoffset         dd          ?
    endl

    mov     edi, [pPlayer]

    .MouseMove:

        mov     eax, [lastCursorPos.x]
        mov     ebx, [lastCursorPos.y]

        push    eax
        invoke  GetCursorPos, lastCursorPos
        pop     eax
        
        sub     eax, [lastCursorPos.x]
        neg     eax
        sub     ebx, [lastCursorPos.y]

        mov     [xoffset], eax
        mov     [yoffset], ebx

        fild    [xoffset]
        fmul    [edi + Player.camera + Camera.sensitivity]
        fstp    [xoffset]

        fild    [yoffset]
        fmul    [edi + Player.camera + Camera.sensitivity]
        fstp    [yoffset]

        fld     [edi + Player.camera + Camera.yaw]
        fadd    [xoffset]
        fstp    [edi + Player.camera + Camera.yaw]

        fld     [edi + Player.camera + Camera.pitch]
        fadd    [yoffset]
        fstp    [edi + Player.camera + Camera.pitch]

        fld     [edi + Player.camera + Camera.pitch]
        fcomp   [maxPlayerPitch]
        fstsw   ax
        sahf 
        jb      @F

        mov     eax, [maxPlayerPitch]    
        mov     [edi + Player.camera + Camera.pitch], eax

        @@:

        fld     [maxPlayerPitch]
        fchs
        fcomp   [edi + Player.camera + Camera.pitch]
        fstsw   ax
        sahf 
        jb      @F

        fld     [maxPlayerPitch]
        fchs
        fstp    [edi + Player.camera + Camera.pitch]
        
        @@:

        stdcall Camera.Direction, edi
        stdcall Player.Direction, edi
        stdcall Camera.NormalizeCursor, lastCursorPos

    ret
endp