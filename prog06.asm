page 60,132
title palindromo

stack   segment para stack 'pila'
        dw 64 dup (0)
stack   ends

dseg    segment para public 'datos'
        let1    db  10,13,'Proporciona una frase(longitud maxima 13 caracteres):'
                db  10,13,'$'
        let2    db  10,13,'Es palindromo: $'
        let3    db  10,13,'No es palindromo: $'
        cad     db  16 dup (00)
                db  (36)
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
        call palmo

        mov ah,4ch
        mov al,00
        int 21h

palmo   proc near

        mov si,offset cad
        mov di,offset cad
        add di,[ndig]
        sub di,01h


sigdig:
        mov ah,[si]
        mov al,[di]
        cmp ah,al
        jne nopal
        inc si
        dec di
        cmp di,offset cad
        jae sigdig

        mov ah,09h
        mov dx,offset let2
        int 21h
        mov dx,offset cad
        int 21h

        jmp finpal

nopal:
        mov ah,09h
        mov dx,offset let3
        int 21h
        mov dx,offset cad
        int 21h
        jmp finpal

finpal:


        
        ret
palmo   endp

carac   proc near
        mov si,offset cad
        mov ndig,0
otro:
        mov ah,00h
        int 16h

        cmp al,61h
        jb  prin
        sub al,27h

prin:
        cmp al,0dh
        je  fin
        cmp al,' '
        je  espacio
        cmp al,30h
        jb  otro
        cmp al,53h
        ja  otro


espacio:
        mov ah,02h
        mov dl,al
        cmp dl,39h
        jb  imp
        add dl,07h
imp:
        int 21h

        mov [si],dl
        inc si
        inc ndig
        cmp ndig,0dh
        je  fin
        jmp otro

fin:
        ret
carac   endp
main    endp
cseg    ends
        end main
