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
