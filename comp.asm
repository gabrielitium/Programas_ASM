datos segment para 'data'
    buff1 db 60 dup (00)
    buff2 db 60 dup (00)
    let db 'Proporcione una cadena de caracteres:',0dh,0ah,'$'
    ent db 0dh,0ah,'$'
datos ends
stacksg segment para stack 'stack'
     dw 40 dup (0)
stacksg ends
codigo segment para 'code'
        assume ds:datos,ss:stacksg,cs:codigo,es:datos
begin proc far
       push ds
       xor ax,ax
       push ax
       mov ax,datos
       mov ds,ax
       mov es,ax

       lea dx,let
       call impr

       lea dx,buff1
       mov [dx],100
       mov ah,0ah
       int 21h
       lea si,buff1
       inc dx

       ret
impr proc
        mov ah,09h
        int 21h
        ret
impr endp
begin endp
codigo ends
        end begin
