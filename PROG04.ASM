page    60,132
title   pantalla

stack   segment para stack 'pila'
        dw 64 dup (0)
stack   ends

dseg    segment para public 'datos'
        let1    db 13,10,'Proporciona una cadena (maxima longitud 15 digitos)'
                db 13,10,': $'
        let2    db 13,10,'Recuerda para salir del ciclo presiona <<<control>>> $'
        apun    dw (0000)
        ndig    db (00)

        cad     db  15 dup (00)
                db  (32)
        hora    dw  (0000)
                db  (58)
        min     dw  (0000)
                db  (58)
        segu    dw  (0000)
                db  (32)
                dw  ('$$')
        am      db  'AM$'
        pm      db  'PM$'
        posic   dw  (0000)
        x1      db  (00)

dseg    ends

cseg    segment para public 'codigo'
        assume cs:cseg, ds:dseg, ss:stack

main    proc far

        push ds
        xor ax,ax
        push ax

        mov ax,dseg
        mov ds,ax

        call muestra

        ret

muestra proc near
        mov ah,09h
        mov dx,offset let2
        int 21h

        mov dx,offset let1
        int 21h

        call leecad
        call bucle

        ret

muestra endp

leecad  proc near
        mov si,offset cad
        mov ndig,01h

otro:
        mov ah,00
        int 16h

        cmp al,61h
        jb prin
        sub al,20h

prin:
        cmp al,0dh
        je fin
        cmp al,' '
        je espacio
        cmp al,41h
        jb otro
        cmp al,5ah
        ja otro

espacio:
        mov ah,02h
        mov dl,al
        int 21h

        mov [si],dl
        inc si
        inc ndig
        cmp ndig,10h
        jae fin
        jmp otro

fin:
        ret

leecad  endp
        
hour    proc near
        push ax
        push bx
        push cx
        push dx
        push si
        push di
        pushf
        call hor

        mov si,offset min
        mov ah,2ch
        int 21h
        call digitos

        mov si,offset segu
        mov ah,2ch
        int 21h
        mov cl,dh
        call digitos

        popf
        pop di
        pop si
        pop dx
        pop cx
        pop bx
        pop ax
        ret
hour    endp

hor     proc near
        push ax
        push bx
        push cx
        push dx
        push si
        push di
        pushf

        mov si,offset hora
        mov apun,offset am
        mov ah,2ch
        int 21h

        cmp ch,0bh
        jb  men12
        mov apun,offset pm
        sub ch,0ch

men12:
        cmp ch,00
        jne hor12
        mov ch,0ch

hor12:
        mov ax,0
        mov al,ch
        aaa
        add ax,3030h
        xchg ah,al
        mov [si],ax

        popf
        pop di
        pop si
        pop dx
        pop cx
        pop bx
        pop ax


        ret
hor    endp


digitos proc near
        cmp cl,32h
        jb et1
        add cl,1eh
        jmp et5

et1:
        cmp cl,28h
        jb et2
        add cl,18h
        jmp et5

et2:
        cmp cl,1eh
        jb et3
        add cl,12h
        jmp et5

et3:
        cmp cl,14h
        jb et4
        add cl,0ch
        jmp et5

et4:
        cmp cl,0ah
        jb et5
        add cl,06h


et5:
        mov ch,cl

        and ch,0f0h
        and cl,0fh
        sar ch,1
        sar ch,1
        sar ch,1
        sar ch,1

        add cx,3030h
        xchg cl,ch
        mov [si],cx

        ret

digitos endp

bucle   proc near

        mov posic,offset cad
        mov x1,0

continua:
        call hour
        call pantalla

        call pausa

        mov ah,00h
        mov al,03h
        int 10h


        inc posic
        inc x1

        cmp x1,53
        jb sig1
        mov x1,0

sig1:
        mov si,offset cad
        add si,0fh
        cmp si,posic
        ja sig2
        mov posic,offset cad

sig2:
        mov ah,02h
        int 16h

        and al,04h
        cmp al,04h
        je finbucle
        jmp continua

finbucle:

        ret
bucle   endp

pantalla proc near
        mov ah,00h
        mov al,03h
        int 10h

        mov ah,02h
        mov dh,0ch
        mov dl,x1
        int 10h

        mov ah,09h
        mov dx,posic
        int 21h

        mov ah,09h
        mov dx,apun
        int 21h

        ret
pantalla  endp

pausa   proc near

        push cx
        mov cx,06h
op1:
        call pausin
        call pausin
        call pausin
        call pausin
        loop  op1
        pop cx

        ret
pausa   endp

pausin  proc near

        push cx
        mov cx,0ffffh

cpin:
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop

        loop cpin

        pop cx
        ret
pausin  endp

main    endp
cseg    ends
        end main
