page    60,132
title   factorial

stack   segment para stack 'pila'
        dw 64 dup (0)
stack   ends

dseg    segment para public 'datos'
        let1    db  13,10,'Programa que calcula el factorial(numero maximo C hexadecimal:'
                db  13,10,': $'
        let2    db  13,10,'El factorial es: $'
        let3    db  13,10,'El factorial es demaciado grande$'
        con     db  (00)
dseg    ends

cseg    segment para public 'codigo'
        assume cs:cseg, ds:dseg, ss:stack

main    proc far

        push ds
        xor ax,ax
        push ax

        mov ax,dseg
        mov ds,ax

        call leenum

        mov ah,4ch
        mov al,00
        int 21h

leenum  proc near
        mov ah,09h
        mov dx,offset let1
        int 21h

otro:
        mov ah,00
        int 16h

        cmp al,39h
        jb  prin
        sub al,027h
        jmp prin

prin:
        cmp al,30h
        jb  otro
        cmp al,03ch
        ja  otro

        mov ah,02h
        mov dl,al
        cmp dl,39h
        jb  imp
        add dl,07h
        jmp imp
imp:
        int 21h

        sub al,30h

        mov bx,0
        mov cx,0
        mov bl,al
        mov ax,0
        mov cl,bl
        dec cl
        mov al,bl
        dec bl

ciclo:
        cmp dx,0
        ja  continua
        xchg ax,bx
continua:
        mul bx
        dec bx
        loop ciclo

        ret
leenum  endp
main    endp
cseg    ends
        end main
