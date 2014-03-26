page     60,132
title    prog 02

stack    segment para stack 'pila'
         db 20 dup(0)
stack    ends

dseg     segment para public 'datos'
         vector db 15,14,13,12,11,10,9,8,7,6,5,4,3,2,1
dseg     ends

cseg     segment para public 'codigo'
         assume cs:cseg, ds:dseg, ss:stack

main     proc far

         push ds
         xor ax,ax
         push ax

         mov ax,dseg
         mov ds,ax
         mov cx,0
         mov ax,0
         lea si,vector
         mov ax,[si]

ciclo:
         cmp cx,0fh
         je salir
         cmp ax,[si]
         jle incrementa
         mov ax,[si]

incrementa:
         inc si
         inc cx
         jmp ciclo
salir:
         mov bx,ax

         mov ah,4ch
         mov al,00
         int 21h

main     endp
cseg     ends
         end main
