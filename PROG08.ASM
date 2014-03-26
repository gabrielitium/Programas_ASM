page 60,132
title adivina_el_numero

stack   segment para stack 'pila'
        dw      64  dup (0)
stack   ends

dseg    segment para public 'datos'
        let1    db 13,10,09,09,09,'"Adivina el numero"$'
        let2    db 13,10,'Proporciona un numero entre 1-100(Hexadecimal): $'
        let3    db 13,10,'¨Adivina el que tengo?: $'
        let4    db 13,10,09,'************ Exelente adivinaste **************$'
        let5    db 13,10,'Suerte para la proxima$'
        num1    dw (0000)
        num2    dw (0000)
        cont    db (00)
        vec     db (00)
dseg    ends

cseg segment para public 'codigo'
        assume  cs:cseg, ds:dseg, ss:stack

main    proc far
        push ds
        xor ax,ax
        push ax

        mov ax,dseg
        mov ds,ax

        mov si,offset num1
        mov di,offset num2

        mov ah,09h
        mov dx,offset let1
        int 21h

        call numalea
        call compara

        mov ah,4ch
        mov al,00
        int 21h

compara proc near

        mov ah,09h
        mov dx,offset let2
        int 21h

otcom:
        inc vec
        cmp vec,04h
        je  fincom2
        call leenum
        mov bx,[si]
        mov cx,[di]

        cmp bx,cx
        jne otcom
        mov ah,09h
        mov dx,offset let4
        int 21h
        jmp fincom

fincom2:
        mov ah,09h
        mov dx,offset let5
        int 21h
        jmp fincom

fincom:

        ret
compara endp

leenum  proc near
        mov cont,00
        mov bx,3030h

        mov ah,09h
        mov dx,offset let3
        int 21h
        jmp digit

uno1:
        mov bh,al
        jmp continua
dos2:
        mov bl,al
        jmp continua


digit:

        mov ah,00h
        int 16h

        cmp al,61h
        jb  prin
        sub al,27h

prin:
        cmp al,30h
        jb  digit
        cmp al,03fh
        ja  digit

        mov ah,02h
        mov dl,al

        cmp dl,39h
        jbe  pinta
        add dl,07
pinta:
        int 21h


        inc cont
        cmp cont,01h
        je  uno1
        cmp cont,02h
        je  dos2
continua:


        cmp cont,02h
        jb finlee
        jmp finlee2

finlee:
        jmp digit
finlee2:
        mov [di],bx

        ret
leenum  endp
numalea proc near

        mov ah,2ch
        int 21h

        mov bx,0
        mov cx,4

        mov bh,dl
        mov bl,dl

        and bh,0f0h
        sar bh,cl
        and bl,0fh
        
        add bx,3030h
        xchg bh,bl
        cmp bh,39h
        jbe uno
        add bh,07h
uno:
        cmp bl,39h
        jbe dos
        add bl,07h
dos:
        
        mov [si],bx

        ret
numalea endp
main    endp
cseg    ends
        end main
