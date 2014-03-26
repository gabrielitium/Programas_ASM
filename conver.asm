DATOS SEGMENT PARA 'DATA'
      LET1 DB 'INTRODUZCA EL NUMERO HEXADECIMAL A CONVERTIR',0AH,0DH,'$'
DATOS ENDS
STACKSG SEGMENT PARA STACK 'STACK'
     DW 40 DUP (0)
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

             MOV BX,5AH
             MOV CX,0AH
             MOV DX,0H

      CICLO:    CMP BX,CX
                JGE INCREMENTO
                ADD BX,DX
                MOV AH,02H
                MOV DX,BX
                INT 21H
                JMP SALIR

      INCREMENTO:ADD CX,0AH
                 ADD DX,06H
                 JMP CICLO

      SALIR:

        MOV AH,04CH
        MOV AL,00H
        INT 21H
BEGIN ENDP
CODIGO ENDS
        END BEGIN

