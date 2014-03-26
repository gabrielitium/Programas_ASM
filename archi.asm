page 60,132
title archivos
datos segment para 'data'
        buff db 19 dup (0)
        dta db 128 dup (0)
        fbc db 36 dup (0)
        let1 db 0dh,0ah,'Despliega: ',0dh,0ah,'$'
        let2 db 0dh,0ah,'Nombre del archivo: $'
        let3 db 0dh,0ah,'Archivo no existente ',0dh,0ah,'$'
        let4 db 0dh,0ah,'No hay detos en el registro leido ',0dh,0ah,'$'
        let5 db 0dh,0ah,'El registro tiene algunos datos',0dh,0ah,'$'
        let6 db 0dh,0ah,'** Error en la lectura ** ',0dh,0ah,'$'
        let7 db 0dh,0ah,'No se puede cerrar el archivo',0dh,0ah,'$'
        let8 db 0dh,0ah,'*** Presione enter para continuar o " f " para salir ***',0dh,0ah,'$'
        cnt1 db 24 ; contador de renglones
        cnt2 db 00
        var1 dw 00
        cte1 equ 5
datos ends
stacksg segment para stack 'stack'
         dw 100 dup (?)
stacksg ends
codigo segment para 'code'
        assume ds:datos,ss:stacksg,cs:codigo,es:datos
arch proc far
        push ds
        xor ax,ax
        push ax
        mov ax,datos
        mov ds,ax
        mov es,ax

        lea dx,let1
        call Imle

        xor dx,dx
        lea dx,buff
        mov [buff],13

        mov ah,0ah
        int 21h
        lea si,buff +2

        lea di,fbc
        mov ah,29h
        int 21h
        lea si,buff +2
        ;limpiar fcb

        mov ah,29h
        int 21h

        xor ax,ax
        lea dx,dta ; carga la direcion del dta en el registro dx
        mov ah,1ah
        int 21h
        xor ax,ax

        lea dx,fbc
        mov ah,0fh
        int 21h
        cmp al,00h
        jne letrero3      ; hubo error
repetir:      
        xor cx,cx      ;****
        mov cx,06h    ;******
ciclo:  push cx    ;********

        xor dx,dx
        lea dx,fbc
        mov ah,14h ;lectura secuencial
        int 21h

        cmp al,00        ; si al=0 hubo lectura exitosa
        je exito
        jmp comp1
comp1:   cmp al,01
        ;mov al,'f'
        je sali
       jmp comp2
comp2:   cmp al,02
        ;mov al,'f'
        je sali
        jmp comp3
comp3:  ;cmp al,03
        jmp exito 



        jmp letrero3

exito:  mov cnt2,80h
        lea si,dta

        xor cx,cx
        mov cx,80h

impc:   xor dl,dl
        mov dl,[si]
        inc si
        dec cnt2

        cmp dl,1ah
        je salida

        mov ah,02
        int 21h

        loop impc      ;******
       pop cx          ;******
      loop ciclo       ;******

        mov dx,offset let8
        call imle

        mov ah,01h
        int 21h

        jmp salto

sali:
 ;       push ax
        mov ax,'f'
     
        mov ah,010h
        int 21h
  

salto:

        cmp ax,'f'  ;***
        jne repetir ;  ** Modificado
        jmp salida  ;***


letrero3: lea dx,let3
           call imle

        mov dx,offset let2
        call imle

salida: ret
arch endp
imle proc
        mov ah,09h
        int 21h
        ret
imle endp

codigo ends
    end arch
