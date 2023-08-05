proc Draw

        locals
                currentTime     dd      ?
                verticesCount   dd      ?
                coord           dd      3.0
        endl

        invoke  GetTickCount
        mov     [currentTime], eax

        sub     eax, [time]
        cmp     eax, 18
        jle     .Skip

        mov     eax, [currentTime]
        mov     [time], eax

        fld     [angle]                 ; angle
        fsub    [step]                  ; angle + step
        fstp    [angle]                 ;

.Skip:

        invoke  glClearColor, 0.22, 0.22, 0.22, 1.0
        invoke  glClear, GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT

        invoke  glMatrixMode, GL_MODELVIEW
        invoke  glLoadIdentity

        ;invoke  gluLookAt, double 10.0, double 10.0, double 0.0,\
        ;                double 0.0, double 0.0, double 0.0,\
        ;                double 0.0, double 1.0, double 0.0
        stdcall Matrix.LookAt, cameraPosition, targetPosition, upVector 

        invoke  glLightfv, GL_LIGHT1, GL_POSITION, light1Position
        invoke  glLightfv, GL_LIGHT0, GL_POSITION, light0Position
    
        invoke  glBindTexture, GL_TEXTURE_2D, [texture]

        invoke  glPushMatrix
                invoke  glTranslatef, [light0Position.x], [light0Position.y], [light0Position.z]
                stdcall DrawMesh, drawCubeMesh
        invoke  glPopMatrix

        invoke  glPushMatrix
                invoke  glTranslatef, [light1Position.x], [light1Position.y], [light1Position.z]
                stdcall DrawMesh, drawCubeMesh
        invoke  glPopMatrix

        invoke  glRotatef, [angle], 0.0, 1.0, 0.0
        stdcall DrawMesh, drawCubeMesh
        stdcall DrawMesh, drawPlaneMesh

        invoke  SwapBuffers, [hdc]

        ret
endp

proc DrawMesh uses esi,\
    mesh

        mov     esi, [mesh]

        invoke  glEnableClientState, GL_VERTEX_ARRAY
        invoke  glEnableClientState, GL_COLOR_ARRAY
        invoke  glEnableClientState, GL_NORMAL_ARRAY
        invoke  glEnableClientState, GL_TEXTURE_COORD_ARRAY

        invoke  glVertexPointer, 3, GL_FLOAT, ebx, [esi + Mesh.vertices]
        invoke  glColorPointer, 3, GL_FLOAT, ebx, [esi + Mesh.colors]
        invoke  glNormalPointer, GL_FLOAT, ebx, [esi + Mesh.normals]
        invoke  glTexCoordPointer, 2, GL_FLOAT, ebx, [esi + Mesh.textures]
        invoke  glDrawArrays, GL_TRIANGLES, ebx, [esi + Mesh.verticesCount]

        invoke  glDisableClientState, GL_VERTEX_ARRAY
        invoke  glDisableClientState, GL_COLOR_ARRAY
        invoke  glDisableClientState, GL_NORMAL_ARRAY
        invoke  glDisableClientState, GL_TEXTURE_COORD_ARRAY

        ret
endp