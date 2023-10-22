proc Player.Constructor uses edi,\
    pPlayer, width, height, pPosition

    mov     edi, [pPlayer]

    mov     eax, [width]
    mov     [edi + Player.width], eax
    mov     eax, [height]
    mov     [edi + Player.height], eax

    push    edi
    add     edi, Player.Position
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

    mov     [edi + Player.Velocity + Vector3.x], 0.0
    mov     [edi + Player.Velocity + Vector3.y], 0.0
    mov     [edi + Player.Velocity + Vector3.z], 0.0

    mov     [edi + Player.pitch], 0.0
    mov     [edi + Player.yaw], -1.57

    stdcall Camera.Direction, edi
    stdcall Player.OrinDirection, edi

    mov     [edi + Player.Up + Vector3.x], 0.0
    mov     [edi + Player.Up + Vector3.y], 1.0
    mov     [edi + Player.Up + Vector3.z], 0.0

    mov     [edi + Player.speed], 0.02
    mov     [edi + Player.jumpVeloc], 0.1
    mov     [edi + Player.sensitivity], 0.0005
    mov     [edi + Player.Condition], JUMP_CONDITION

    ; Able to change field of view
    mov     [edi + Player.fovDeg], 90.0
    mov     [edi + Player.nearPlane], 0.001
    mov     [edi + Player.farPlane], 1000.0

    ; translate camera for the player
    mov     [edi + Player.translate + Vector3.x], 0.0
    mov     [edi + Player.translate + Vector3.y], 0.0
    mov     [edi + Player.translate + Vector3.z], 0.0

    ; Animation functions
    ; Forward ani
    mov     [edi + Player.forwAni + Easing.ptrEasingFun], dword Easing.easeOutQuort
    mov     [edi + Player.forwAni + Easing.duration], 500 
    mov     [edi + Player.forwAni + Easing.startTime], 0
    mov     [edi + Player.forwAni + Easing.start], false
    mov     [edi + Player.forwAni + Easing.done], false

    ; Backward ani
    mov     [edi + Player.backAni + Easing.ptrEasingFun], dword Easing.easeOutQuort
    mov     [edi + Player.backAni + Easing.duration], 500 
    mov     [edi + Player.backAni + Easing.startTime], 0
    mov     [edi + Player.backAni + Easing.start], false
    mov     [edi + Player.backAni + Easing.done], false

    ; left  ani
    mov     [edi + Player.leftAni + Easing.ptrEasingFun], dword Easing.easeOutQuort
    mov     [edi + Player.leftAni + Easing.duration], 500 
    mov     [edi + Player.leftAni + Easing.startTime], 0
    mov     [edi + Player.leftAni + Easing.start], false
    mov     [edi + Player.leftAni + Easing.done], false

    ; right  ani
    mov     [edi + Player.rightAni + Easing.ptrEasingFun], dword Easing.easeOutQuort
    mov     [edi + Player.rightAni + Easing.duration], 500 
    mov     [edi + Player.rightAni + Easing.startTime], 0
    mov     [edi + Player.rightAni + Easing.start], false
    mov     [edi + Player.rightAni + Easing.done], false

    ; fall ani
    mov     [edi + Player.fallAni + Easing.ptrEasingFun], dword Easing.easeLine
    mov     [edi + Player.fallAni + Easing.duration], 2500 
    mov     [edi + Player.fallAni + Easing.startTime], 0
    mov     [edi + Player.fallAni + Easing.start], false
    mov     [edi + Player.fallAni + Easing.done], false

    ; jump ani
    mov     [edi + Player.jumpAni + Easing.ptrEasingFun], dword Easing.easeOutQuort
    mov     [edi + Player.jumpAni + Easing.duration], 200
    mov     [edi + Player.jumpAni + Easing.startTime], 0
    mov     [edi + Player.jumpAni + Easing.start], false
    mov     [edi + Player.jumpAni + Easing.done], false

    ; size of player collision
    mov     [edi + Player.sizeBlockCol], 0.5 

    invoke SetCursorPos, cursorPosX, cursorPosY
    invoke GetCursorPos, lastCursorPos
    
    ret
endp

proc Player.OrinDirection uses edi,\
    pPlayer 

    locals 
        null        dd      0.0
    endl

    mov     edi, [pPlayer]

    ; Ox camera direction
    fld     [null]
    fcos    
    fld     [edi + Player.yaw]
    fcos 
    fmulp
    fstp    [edi + Player.Direction + Vector3.x]

    ; Oy camera direction
    fld     [null]
    fsin    
    fstp    [edi + Player.Direction + Vector3.y]

    ; Oz camera direction
    fld     [null]
    fcos    
    fld     [edi + Player.yaw]
    fsin 
    fmulp
    fstp    [edi + Player.Direction + Vector3.z]

    ret
endp

proc Player.EasingMove uses edi esi ebx,\
    pPlayer, dt, sizeMap, pMap

    locals 
        deltaPos        Vector3         ?
        div2            dd              2.0
        step            dd              0.001 
        trueStep        dd              ?
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

    fild    [dt]
    fstp    [dt]
    stdcall Vector3.MultOnNumber, ebx, [dt]

    ; push    edi
    ; add     edi, Player.Position
    ; stdcall Vector3.Add, edi, ebx
    ; pop     edi

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

    .SkipZCollision:

    lea     ebx, [deltaPos]
    fld     [edi + Player.Position + Vector3.y]
    fadd    [ebx + Vector3.y]
    fstp    [edi + Player.Position + Vector3.y]

    ; Y collision
    lea     ebx, [collision]
    stdcall Collision.MapDetection, [pPlayer], [sizeMap], [pMap], ebx, Y_COLLISION
    cmp     eax, NO_COLLISION
    je      .SkipYCollision

    mov     eax, [edi + Player.prevPosition + Vector3.y]
    mov     [edi + Player.Position + Vector3.y], eax

    cmp     [collision], DIR_Y_MAX
    je      .UpY

    cmp     [collision], DIR_Y_MIN
    je      .DownY

    jmp     .BothY

    .DownY:

        mov     [edi + Player.Condition], WALK_CONDITION
    
        mov     [edi + Player.fallAni + Easing.start], false
        mov     [edi + Player.fallAni + Easing.done], false

        mov     [edi + Player.jumpAni + Easing.start], false
        mov     [edi + Player.jumpAni + Easing.done], false

        jmp     .SkipY

    .UpY:


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

    .SkipYCollision:
    

.Ret:
    ret
endp

proc Player.EasingInputsKeys uses edi esi ebx,\
    pPlayer

    locals 
        velocity        dd          0.0
        negConst        dd          -1.0
        tmp             Vector3     ?
    endl

    mov     edi, [pPlayer]

    ; Zeroing Velocity
    push    edi
    add     edi, Player.Velocity
    stdcall memzero, edi, 3 * 4
    pop     edi

    ; Calculate Velocity that depends on animations
    ; Forward animation
    push    edi 
    add     edi, Player.Direction
    stdcall Vector3.Copy, orinVec, edi
    pop     edi

    push    edi
    add     edi, Player.forwAni
    movzx   eax, [pl_forward]
    stdcall Player.InputKeysHorizontAni, [pPlayer], edi, eax
    pop     edi

    ; Backward animation
    push    edi 
    add     edi, Player.Direction
    stdcall Vector3.Copy, orinVec, edi
    pop     edi

    stdcall Vector3.MultOnNumber, orinVec, [negConst]

    push    edi
    add     edi, Player.backAni
    movzx   eax, [pl_backward]
    stdcall Player.InputKeysHorizontAni, [pPlayer], edi, eax
    pop     edi

    ; Left animation
    lea     ebx, [tmp]
    push    edi
    add     edi, Player.Direction
    stdcall Vector3.Copy, ebx, edi
    pop     edi

    push    edi
    add     edi, Player.Up
    stdcall Vector3.Copy, upVec, edi
    pop     edi

    stdcall Vector3.Cross, upVec, ebx, orinVec

    push    edi
    add     edi, Player.leftAni
    movzx   eax, [pl_left]
    stdcall Player.InputKeysHorizontAni, [pPlayer], edi, eax
    pop     edi

    ; right animation
    lea     ebx, [tmp]
    push    edi
    add     edi, Player.Direction
    stdcall Vector3.Copy, ebx, edi
    pop     edi

    push    edi
    add     edi, Player.Up
    stdcall Vector3.Copy, upVec, edi
    pop     edi

    stdcall Vector3.Cross, ebx, upVec, orinVec

    push    edi
    add     edi, Player.rightAni
    movzx   eax, [pl_right]
    stdcall Player.InputKeysHorizontAni, [pPlayer], edi, eax
    pop     edi


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

    cmp     [pl_jump], false
    je     .SkipUpdateJumpAni

    cmp     [esi + Easing.done], true
    je     .SkipDoneJumpAni

    cmp     [esi + Easing.start], true
    je      .SkipStartJumpAni

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

    fld     [edi + Player.Velocity + Vector3.y]
    fadd    [velocity]
    fstp    [edi + Player.Velocity + Vector3.y]

    jmp     .SkipJumpAni

    .SkipDoneJumpAni:

    stdcall [esi + Easing.ptrEasingFun], [esi + Easing.duration] 
    mov     [velocity], eax 

    fld     [edi + Player.jumpVeloc]
    fmul    [velocity]
    fstp    [velocity]

    fld     [edi + Player.Velocity + Vector3.y]
    fadd    [velocity]
    fstp    [edi + Player.Velocity + Vector3.y]

    jmp     .SkipJumpAni

    .SkipUpdateJumpAni:

    cmp     [esi + Easing.start], false
    je      .SkipJumpAni

    mov     [esi + Easing.start], false
    mov     [esi + Easing.done], false

    invoke  GetTickCount
    sub     eax, 5
    mov     [edi + Player.fallAni + Easing.startTime], eax

    .SkipJumpAni:



.Ret:
    ret
endp

proc Player.InputKeysHorizontAni uses edi esi,\
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

    ; mov     eax, [orinVec + Vector3.x]
    ; mov     [edi + Player.Velocity + Vector3.x], eax 
    ; mov     eax, [orinVec + Vector3.z]
    ; mov     [edi + Player.Velocity + Vector3.z], eax 

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

    ; mov     eax, [orinVec + Vector3.x]
    ; mov     [edi + Player.Velocity + Vector3.x], eax 
    ; mov     eax, [orinVec + Vector3.z]
    ; mov     [edi + Player.Velocity + Vector3.z], eax 

    jmp     .SkipAni

    .SkipUpdateAni:

    cmp     [esi + Easing.start], false
    je      .SkipAni

    mov     [esi + Easing.start], false
    mov     [esi + Easing.done], false

    ; mov     [edi + Player.Velocity + Vector3.x], 0.0 
    ; mov     [edi + Player.Velocity + Vector3.z], 0.0 

    .SkipAni:

    .Ret: 
    ret
endp

proc Player.EasingHandler uses edi esi ebx,\
    pPlayer, dt

.Ret:
    ret
endp

proc Player.Move uses edi esi ebx,\
    pPlayer, dt, fixDt

    locals 
        delta           Vector3 
        colDet          dd          ?    
        curPlayerPos    Vector3     
        div_2           dd          2.0
        example         dd          0.2

    endl

    mov     edi, [pPlayer]

    fild    [dt]
    fidiv   [fixDt]
    fstp    [dt]

    push    edi
    add     edi, Player.Position
    lea     ebx, [delta]
    stdcall Vector3.Copy, ebx, edi
    pop     edi
    push    edi
    add     edi, Player.prevPosition
    stdcall Vector3.Sub, ebx, edi
    pop     edi

    mov     esi, edi
    push    edi
    add     edi, Player.prevPosition
    add     esi, Player.Position
    stdcall Vector3.Copy, edi, esi
    pop     edi

    fld     [edi + Player.Velocity + Vector3.x]
    fchs
    ; ; fdiv    [edi + Player.Velocity + Vector3.x]
    fmul    [example]
    fstp    [edi + Player.Acceleration + Vector3.x]

    fld     [edi + Player.Velocity + Vector3.z]
    fchs
    ; ; fdiv    [edi + Player.Velocity + Vector3.y]
    fmul    [example]
    fstp    [edi + Player.Acceleration + Vector3.z]


    ; X    
    mov     [colDet], 0
    
    push    edi

    fld     [edi + Player.Position + Vector3.x]
    fld     [edi + Player.Velocity + Vector3.x]
    fmul    [dt]
    faddp
    fld     [edi + Player.Acceleration + Vector3.x]
    fmul    [dt]
    fmul    [dt]
    fdiv    [div_2]
    faddp
    fstp    [edi + Player.Position + Vector3.x]

    fld     [edi + Player.Velocity + Vector3.x]
    fld     [edi + Player.Acceleration + Vector3.x]
    fmul    [dt]
    faddp   
    fstp    [edi + Player.Velocity + Vector3.x]

    lea     eax, [colDet]
    stdcall Collision.MapDetection, [pPlayer], [sizeBlocksMapTry], blocksMapTry, eax, dword X_COLLISION

    cmp     [colDet], NO_COLLISION 
    je      @F
    
    mov     eax, [edi + Player.prevPosition + Vector3.x]
    mov     [edi + Player.Position + Vector3.x], eax

    fld     [edi + Player.Velocity + Vector3.x]
    fdiv    [div_2]
    fstp    [edi + Player.Velocity + Vector3.x]
    mov     [edi + Player.Acceleration + Vector3.x], 0.0

    mov     [edi + Player.Condition], SLIDE_CONDITION

    jmp     .SkipSlideConditionX

    @@:
        
    .SkipSlideConditionX:

    pop     edi

    ; Z
    mov     [colDet], 0
    
    push    edi

    fld     [edi + Player.Position + Vector3.z]
    fld     [edi + Player.Velocity + Vector3.z]
    fmul    [dt]
    faddp
    fld     [edi + Player.Acceleration + Vector3.z]
    fmul    [dt]
    fmul    [dt]
    fdiv    [div_2]
    faddp
    fstp    [edi + Player.Position + Vector3.z]

    fld     [edi + Player.Velocity + Vector3.z]
    fld     [edi + Player.Acceleration + Vector3.z]
    fmul    [dt]
    faddp   
    fstp    [edi + Player.Velocity + Vector3.z]

    lea     eax, [colDet]
    stdcall Collision.MapDetection, [pPlayer], [sizeBlocksMapTry], blocksMapTry, eax, dword Z_COLLISION

    cmp     [colDet], NO_COLLISION
    je      @F
    
    mov     eax, [edi + Player.prevPosition + Vector3.z]
    mov     [edi + Player.Position + Vector3.z], eax

    fld     [edi + Player.Velocity + Vector3.z]
    fdiv    [div_2]
    fstp    [edi + Player.Velocity + Vector3.z]
    mov     [edi + Player.Acceleration + Vector3.z], 0.0

    mov     [edi + Player.Condition], SLIDE_CONDITION

    jmp     .SkipSlideConditionZ

    @@:

    .SkipSlideConditionZ:

    pop     edi

    ; Y
    mov     [colDet], 0
    
    push    edi

    ; Position
    fld     [edi + Player.Position + Vector3.y]
    fld     [edi + Player.Velocity + Vector3.y]
    fmul    [dt]
    faddp
    fld     [edi + Player.Acceleration + Vector3.y]
    fmul    [dt]
    fmul    [dt]
    
    
    cmp     [edi + Player.Condition], SLIDE_CONDITION
    jne     .SkipPositionSlide    

    fdiv    [div_2]
    fdiv    [div_2]
    fdiv    [div_2]

    .SkipPositionSlide:

    faddp
    fstp    [edi + Player.Position + Vector3.y]

    ; Velocity
    fld     [edi + Player.Velocity + Vector3.y]
    fld     [edi + Player.Acceleration + Vector3.y]
    fmul    [dt]

    cmp     [edi + Player.Condition], SLIDE_CONDITION
    jne     .SkipVelocitySlide    

    fdiv    [div_2]
    fdiv    [div_2]

    .SkipVelocitySlide:

    faddp   
    fstp    [edi + Player.Velocity + Vector3.y]

    lea     eax, [colDet]
    stdcall Collision.MapDetection, [pPlayer], [sizeBlocksMapTry], blocksMapTry, eax, dword Y_COLLISION

    cmp     [colDet], NO_COLLISION 
    je     @F
    
    mov     eax, [edi + Player.prevPosition + Vector3.y]
    mov     [edi + Player.Position + Vector3.y], eax
    
    fld     [edi + Player.Velocity + Vector3.y]
    fdiv    [div_2]
    fstp    [edi + Player.Velocity + Vector3.y]

    mov     [edi + Player.Condition], WALK_CONDITION

    jmp     .SkipOtherConditions

    @@:

    .SkipOtherConditions:

    pop     edi

    ret
endp

proc Player.InputsKeys uses edi esi ebx,\
    pPlayer

    locals 
        speed           dd          ?
        reverseSpeed    dd          ?
        dGrav           dd          0.0001
    endl

    mov     edi, [pPlayer]

    fld     [edi + Player.speed] 
    ; fimul   [deltaTime]
    fst     [speed]
    fchs 
    fstp    [reverseSpeed]

    push    edi
    add     edi, Player.Direction
    stdcall Vector3.Copy, orinVec, edi
    pop     edi

    push    edi
    add     edi, Player.Up
    stdcall Vector3.Copy, upVec, edi
    pop     edi

    .KeyDown:

        cmp     [pl_forward], true
        jne     @F

        stdcall Vector3.MultOnNumber, orinVec, [speed]
        
        push    edi
        add     edi, Player.Velocity
        stdcall Vector3.Add, edi, orinVec
        pop     edi

        @@:

        cmp     [pl_backward], true
        jne     @F

        stdcall Vector3.MultOnNumber, orinVec, [reverseSpeed] 
        
        push    edi
        add     edi, Player.Velocity
        stdcall Vector3.Add, edi, orinVec
        pop     edi

        @@:

        cmp     [pl_right], true
        jne     @F

        stdcall Vector3.Cross, orinVec, upVec, crossVec
        stdcall Vector3.MultOnNumber, crossVec, [speed] 
        
        push    edi
        add     edi, Player.Velocity
        stdcall Vector3.Add, edi, crossVec
        pop     edi

        @@:
        
        cmp     [pl_left], true
        jne     @F

        stdcall Vector3.Cross, orinVec, upVec, crossVec
        stdcall Vector3.MultOnNumber, crossVec, [reverseSpeed] 
        
        push    edi
        add     edi, Player.Velocity
        stdcall Vector3.Add, edi, crossVec
        pop     edi

        @@:
        
        cmp     [pl_jump], true
        jne     @F

        stdcall Vector3.MultOnNumber, upVec, [edi + Player.jumpVeloc] 
        
        cmp     [edi + Player.Condition], WALK_CONDITION
        jne      .notWalkJumpSkip

        push    edi
        add     edi, Player.Velocity
        stdcall Vector3.Add, edi, upVec
        pop     edi

        mov     [edi + Player.Condition], JUMP_CONDITION

        .notWalkJumpSkip:

        cmp     [edi + Player.Condition], SLIDE_CONDITION
        jne     .notSlideJumpSkip

        push    edi
        add     edi, Player.Velocity
        stdcall Vector3.MultOnNumber, upVec, 0.080
        stdcall Vector3.Add, edi, upVec
        pop     edi

        fld     [edi + Player.Velocity + Vector3.y]
        fcomp   [maxClimbSpeed]
        fstsw   ax
        sahf
        jb      .notMaxVelocity

        fld    [maxClimbSpeed]    
        fstp   [edi + Player.Velocity + Vector3.y]
    
        .notMaxVelocity:

        mov     [edi + Player.Condition], JUMP_CONDITION 

        .notSlideJumpSkip:

        @@:

        cmp     [pl_normal_grav], true
        jne     @F

        fld     [EARTH_GRAVITY]
        fstp    [edi + Player.Acceleration + Vector3.y]

        @@:
        
        cmp     [pl_enhance_grav], true
        jne     @F

        fld     [dGrav]
        fchs
        fadd    [edi + Player.Acceleration + Vector3.y]
        fstp    [edi + Player.Acceleration + Vector3.y]

        @@:

        cmp     [pl_weak_grav], true
        jne     @F

        fld     [dGrav]
        fadd    [edi + Player.Acceleration + Vector3.y]
        fstp    [edi + Player.Acceleration + Vector3.y]

        @@:

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
        fmul    [edi + Player.sensitivity]
        fstp    [xoffset]

        fild    [yoffset]
        fmul    [edi + Player.sensitivity]
        fstp    [yoffset]

        fld     [edi + Player.yaw]
        fadd    [xoffset]
        fstp    [edi + Player.yaw]

        fld     [edi + Player.pitch]
        fadd    [yoffset]
        fstp    [edi + Player.pitch]

        fld     [edi + Player.pitch]
        fcomp   [maxPlayerPitch]
        fstsw   ax
        sahf 
        jb      @F

        mov     eax, [maxPlayerPitch]    
        mov     [edi + Player.pitch], eax

        @@:

        fld     [maxPlayerPitch]
        fchs
        fcomp   [edi + Player.pitch]
        fstsw   ax
        sahf 
        jb      @F

        fld     [maxPlayerPitch]
        fchs
        fstp    [edi + Player.pitch]
        
        @@:

        stdcall Camera.Direction, edi
        stdcall Player.OrinDirection, edi
        stdcall Camera.NormalizeCursor, lastCursorPos

    ret
endp