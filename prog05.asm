page    60,132
title   calculadora

stack   segment para stack 'pila'
        dw 64 dup (0)
stack   ends

dseg    segment para public 'datos'
        let1    db  13,10,'Programa que simula una calculadora'
        sum     db  13,10,'1.-Suma$'
        res     db  13,10,'2.-Resta$'
        mul     db  13,10,'3.-Multiplicacion$'
        div     db  13,10,'4.-Divicion$'
        exit    db  13,10,'5.-Salir$'
        let2    db  13,10,'Elige una opcion: $'
        let3    db  13,10,'ออออออออออออออออออออนSUMAฬออออออออออออออออออออ$'
        let4    db  13,10,'ออออออออออออออออออออนRESTAฬออออออออออออออออออออ$'
        let5    db  13,10,'ออออออออออออออออออออนMULTIPLICACIONฬออออออออออออออออออออ$'
        let6    db  13,10,'ออออออออออออออออออออนDIVICIONฬออออออออออออออออออออ$'
        let7    db  13,10,'Tamaคo maximo del numero 4 digitos $'
        let8    db  13,10,'Si un numero es igual a ffff el otro no puede ser mayor a 8000$'
        op      db  (00)
        numa    dw  (0000)
        numb    dw  (0000)
dseg    ends

cseg    segment para public 'codigo'
        assume cs:cseg, ds:dseg, ss:stack

main    proc far
        push ds
        xor ax,ax
        push ax

        mov ax,dseg
        mov ds,ax

        call calculadora

        ret

menu    proc near
        ;call limpia
        mov ah,09h
        mov dx,offset let1
        int 21h

        mov dx,offset sum
        int 21h

        mov dx,offset res
        int 21h

        mov dx,offset mul
        int 21h

        mov dx,offset div
        int 21h

        mov dx,offset exit
        int 21h

        call opcion

        ret

menu    endp

leeop   proc near

invalido:
        mov ah,00
        int 16h

        cmp al,31h
        jb invalido
        cmp al,35h
        ja invalido

        mov ah,02h
        mov dl,al
        int 21h

        sub dl,30h
        mov op,dl

        ret

leeop   endp

opcion  proc near

ciclo:
        call leeop
        mov al,op

        cmp al,01
        jne oresta
        call suma
        jmp ciclo


oresta:
        cmp al,02
        jne multiplicacion
        call resta
        jmp ciclo

omultiplicacion:
        cmp al,03
        jne divicion
        call multi
        jmp ciclo

odivicion:
        cmp al,04
        jne salida
        call divicion
        jmp ciclo

salida:
        ret

opcion  endp

suma    proc near
        mov ah,09h
        mov dx,offset let3
        int 21h
        call leenumero
        mov si,offset numa+2
        mov di.offset numb+2

        mov cx,02
        clc

syte:
        mov ax,[si]
        adc [di],ax
        mov resultado,[di]
        sub [resultado],02h
        sub si,02
        sub di,02
        loop syte

        call desempaqueta
        mov ah,09h

        mov dx,offset resultado
        int 21h

        ret
suma    enp

resta   proc near

        mov ah,09h
        mov dx,offset let4
        int 21h
        call leenumero
        mov si,offset numa+2
        mov di,offset numb+2

        mov cx,02
        clc

syte2:
        mov ax,[si]
        sub [di],ax
        mov resulatado,[di]
        sub [resulatdo],02h
        sub si,02h
        sub di,02h
        loop syte2
        call desempaqueta

       mov ah,09h
       mov dx,offset resulatdo
       int 21h
       ret

resta   endp

multiplicacion proc near
        
        mov ah,09h
        mov dx,offset let5
        int 21h

        call leenumero

        mov dx,0
        mov ax,numa
        mob bx,numb

        mul bx

        mov si,offset resulatado
        mov [si],dx
        add si,02
        mov [si],ax
        call desempaqueta

        mov ah,09h
        mov dx,offset resulatdo
        int 21h

        ret
multiplicacion  endp

divicion        proc near
        
        mov ah,09h
        mov dx,offset let6
        int 21h
        call leenumero
        mov si,offset numa
        mov di,offset numb

        mov ax,[si]

        mov dx,[di]
        mov dx,0
        div bx
        mov si,offset resulatdo
        mov [si],ax
        call desempaqueta
        mov ah,09h
        mov dx,offset resulatdo
        int 21h

divicion        endp

desempaqueta    proc near
        mov di,offset resulatdo2+6
        mov si,offset resulatdo+6
        mov cx,03

cdes:
        mov ax,[si]
        sub si,02
        push cx
        push ax
        push ax
        push ax

        mov cx,04
        and al,0fh
        mov bh,al

        pop ax
        and al,0f0h
        sar al,cl
        mov bl,al

        pop ax
        and ah,0fh
        mov dh,ah

        pop ax

        and ah,0fh
        sar ah,cl
        mov dl,ah
        pop cx
        add bx,3030h
        add dx,3030h
        cmp bh,39h
        jbe dos
        add bh,07h

dos:
        cmp bl,39h
        jbe ters
        add bl,02h

tres:
        cmp dh,39h
        jbe cuatro
        add dh,02h

cuatro:
        cmp dl,39h
        jbe almacena
        add al,02h

almacena:
        mov [di],bx
        sub di,02h
        mov [di],dx
        sub di,02h

        loop cdes

        ret
desempaqueta    endp

leer    proc near
        push ax
        push dx
        push cx

        mov bx,0
digit:
        mov ah,00h
        int 16h
        cmp al,0dh
        je cuatroend
        

