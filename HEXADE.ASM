PAGE 60,132
TITLE HEXA-DEC

DATOS SEGMENT PARA 'DATA'
      LET1 DB 'INTRODUZCA EL NUMERO HEXADECIMAL A CONVERTIR',0AH,0DH,'$'
     ; NUMERO DB 0
DATOS ENDS

STACKSG SEGMENT PARA STACK 'STACK'
      DW 60 DUP(0)
STACKSG ENDS

CODIGO SEGMENT PARA 'CODE'
        ASSUME DS:DATOS,SS:STACKSG,CS:CODIGO
BEGIN PROC FAR

        PUSH DS
        XOR AX,AX
        PUSH AX

        MOV AX,DATOS
        MOV DS,AX

        MOV AH,09H
        LEA DX,LET1
        INT 21H


        MOV AH,04CH
        MOV AL,00H
        INT 21H

BEGIN ENDP
CODIGO ENDS
     END BEGIN
