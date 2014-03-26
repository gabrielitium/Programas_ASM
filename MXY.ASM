page    60,132
title   mouse

stack   segment para stack 'pila'
        dw 64 dup (0)
stack   ends

dseg    segment para public 'datos'
        cad     db 00,00,00,00,'    $'
        num     dw 0000        ;num contiene el numero a trasformar
        video   db 012h
        intall  db 10,13,'Mouse instalado'
                db 10,13,'ออออออออออออออออออออออออออออออออออออออออ'
                db        'อออออออออออออออออออออออออออออออออออออออ$'
        nmous   db 10,13,'Mouse no instalado$'
        grafi   db 13,09,09,09,' MODO GRAFICO 640x480$'
        corx    db 13,'X: $'
        cory    db 09,'Y: $',09
        der     db 'DERECHO   $'
        izq     db 'IZQUIERDO $'
        dos     db 'IZQ Y DER $'
        nada    db '               $'
        ent     db 10,13,'$'
        mdo     dw 0000
        pag     dw 0000
        px      dw 0000
        py      dw 0000
        colori  db 09h
        colord  db 0ah
        color   db 00
        boton   dw 0000
dseg    ends

cseg    segment para public 'codigo'
        assume cs:cseg, ds:dseg, ss:stack

main    proc far

        push ds
        xor ax,ax
        push ax

        mov ax,dseg
        mov ds,ax
        call modo
        call mouse
        call enter

mainciclo:
        call plano
        mov ah,02
        int 16h
        and al,04
        cmp al,04
        je  salir
        jmp mainciclo

salir:
        mov ah,00
        mov al,02
        int 10h

        ret
enter   proc near
        push ax
        push dx

        mov ah,09
        mov dx,offset ent
        int 21h

        pop dx
        pop ax

        ret
enter   endp

punto   proc near
        push ax
        push bx
        push cx
        push dx
        pushf

        mov ah,0ch
        mov al,color
        mov bh,00       ;pagina de video a escribir el punto grafico
        mov cx,px       ;coordenada x
        mov dx,py       ;coordenada y
        int 10h

        popf
        pop dx
        pop cx
        pop bx
        pop ax


        ret
punto   endp


plano   proc near
        push ax
        push bx
        push cx
        push dx



        mov ah,09
        mov dx,offset corx
        int 21h

        mov ax,03
        int 33h

        mov boton,bx
        mov px,cx
        mov py,dx
        inc cx
        mov num,cx
        call muestra

        mov ah,09
        mov dx,offset cory
        int 21h

        mov dx,py
        inc dx
        mov num,dx

        call muestra

        mov bx,boton
        cmp bx,01
        JNE OTR2
        MOV AH,09
        MOV DX,OFFSET izq
        INT 21H
        mov dl,colori
        mov color,dl
        call punto
        call punto
        JMP TERM

OTR2:
        CMP BX,02
        JNE OTR3
        MOV AH,09
        MOV DX,OFFSET der
        INT 21H
        mov dl,colord
        mov color,dl
        call punto
        call punto
        JMP TERM

OTR3:
        CMP BX,03
        JNE TERM
        MOV AH,09
        MOV DX,OFFSET DOS
        INT 21H

TERM:
        mov ah,09
        mov dx,offset nada
        int 21h


        pop dx
        pop cx
        pop bx
        pop ax


        ret
plano   endp

limpia  proc near
        push cx
        push si

        mov si,offset cad
        mov cx,04

ciclolimpia:
        mov cad[si],00
        inc si
        loop ciclolimpia

        pop si
        pop cx

        ret
limpia  endp

modo    proc near
        push ax
        push dx

        mov ah,00
        mov al,video
        int 10h

        mov dx,offset grafi
        mov ah,09
        int 21h

        pop dx
        pop ax
        

        ret
modo    endp

mouse   proc near
        push ax
        push bx
        push cx
        push dx

        mov ax,00
        int 33h

        cmp ax,-1
        je  sihay
        mov dx,offset nmous
        mov ah,09
        int 21h
        jmp finmouse

sihay:
        mov ax,01
        int 33h

        mov ah,09
        mov dx,offset intall
        int 21h

finmouse:


        pop dx
        pop cx
        pop bx
        pop ax

        ret
mouse   endp

muestra proc near
        call limpia
        mov si,offset cad
        add si,03h


        mov ax,num
        mov bl,0ah

ciclo:
        cmp ax,0ah
        jl  fin
        div bl
        add ah,30h
        mov cad[si],ah
        dec si
        mov ah,0
        jmp ciclo

fin:
        add al,30h
        mov cad[si],al

        mov ah,09h
        mov dx,offset cad
        int 21h

        ret
muestra endp

main    endp
cseg    ends
        end main


