page    60,132
title   vocales

stack   segment para stack 'pila'
        dw 64 dup (0)
stack   ends

dseg    segment para public 'datos'
        let1    db  13,10,'Proporciona la frase(longitud maxima 13 digitos):'
                db  13,10,': $'
        let2    db  13,10,'El numero de vocales es: $'
        frase   db  16  dup (00)
        cvoc    db  (00)
        ndig    dw  (0000)
dseg    ends

cseg    segment para public 'codigo'
        assume cs:cseg, ds:dseg, ss:stack

main    proc far

        push ds
        xor ax,ax
        push ax

        mov ax,dseg
        mov ds,ax

        mov ah,09h
        mov dx,offset let1
        int 21h

        call carac
        call cuenta

        mov ah,4ch
        mov al,00
        int 21h

cuenta  proc near
        mov si,offset frase
        mov cvoc,0
        cmp ndig,0
        je  finvo

conti:
        mov bl,[si]
        cmp dl,41h
        jne
        call contabiliza



finvo:
        mov ah,00
        mov al,cvoc
        aaa
        add ax,3030h
        xchg bx,ax
        mov ah,09h
        mov dx,offset let2
        int 21h
        mov ah,02h
        mov dl,bh
        int 21h
        mov dl,bl
        int 21h

        ret
cuenta  endp

carac   proc near
        mov si,offset frase
        mov ndig,0
otro:
        mov ah,00h
        int 16h

        cmp al,61h
        jb  prin
        sub al,20h

prin:
        cmp al,0dh
        je  fin
        cmp al,' '
        je  espacio
        cmp al,41h
        jb  otro
        cmp al,5ah
        ja  otro


espacio:
        mov ah,02h
        mov dl,al
        int 21h

        mov [si],dl
        inc si
        inc ndig
        cmp ndig,0fh
        je  fin
        jmp otro

fin:
        mov cx,ndig
        
        ret
carac   endp

main    endp
cseg    ends
        end main
