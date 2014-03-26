;ESTE PROGRAMA PARTICIONA EL NUMERO 23H Y LOS INTRODUCE EN AL Y BL
PAGE 60,132
TITLE SEPARA_NUM
DATOS SEGMENT PARA 'DATA'
       LET1 DB 'PARTICION DE CIFRAS DE 8 BITS',0AH,0DH,'$'
       LET2 DB 'PROPORCIONE NUMERO: $'
       LET3 DB 0AH,0DH,'REGISTRO AL:  $'
       LET4 DB 0AH,0DH,'REGISTRO BL:  $'
DATOS ENDS
STACKSG SEGMENT PARA STACK 'STACK'
      DW 30 DUP(0)
STACKSG ENDS
CODIGO SEGMENT PARA 'CODE'
        ASSUME DS:DATOS,SS:STACKSG,CS:CODIGO
BEGIN PROC FAR
    PUSH DS
    XOR AX,AX
    PUSH AX
    MOV AX,DATOS
    MOV DS,AX
        MOV AX,0
        MOV BX,0
                        MOV AH,09H
                        LEA DX,LET1
                        INT 21H
                        MOV AH,09
                        LEA DX,LET2
                        INT 21H

                        MOV AH,01H
                        INT 21H
                        SUB AL,30H
                        MOV BL,AL
                        MOV CL,4
                        SHL BL,CL
                        MOV AH,01H
                        INT 21H
                        SUB AL,30H
                        MOV BH,AL
                        ADD BL,BH
                        MOV BH,00
        MOV AX,BX
        MOV BX,AX
        AND AL,0FH

        MOV CL,4
        SHR BL,CL
        MOV BH,AL
                        MOV AH,09H
                        LEA DX,LET3
                        INT 21H
        MOV AL,BH
        ADD AL,30H
                        MOV AH,02H
                        MOV DL,AL
                        INT 21H
                        MOV AH,09H
                        LEA DX,LET4
                        INT 21H
        ADD BL,30H
                        MOV AH,02H
                        MOV DL,BL
                        INT 21H
     MOV AH,04CH
     MOV AL,00H
     INT 21H
BEGIN ENDP
CODIGO ENDS
        END BEGIN

