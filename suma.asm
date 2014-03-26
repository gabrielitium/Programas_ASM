
DATOS SEGMENT PARA 'DATA'
        LET1 DB 0ah,0dh,'PROPORCIONE UN VALOR ',0AH,0DH,'$' 
        DATO1 DB 0                                                   
        DATO2 DB 0
        RESULTADO DB 0
DATOS ENDS

STACK SEGMENT PARA STACK 'STACK' 
        DW 20 DUP(0)
STACK ENDS

CODIGO SEGMENT PARA 'CODE'
        ASSUME DS:DATOS, SS:STACK, CS:CODIGO
LECTURA PROC FAR
                       
        PUSH DS         ;-------|
        XOR AX,AX              ;|
        PUSH AX
                       ;| PROTOCOLO
        MOV AX,DATOS           ;|
        MOV DS,AX       ;-------|
        
        ;MI PROGRAMA
        MOV AH,09H
        LEA DX,LET1
        INT 21H
        MOV AH,01H
        INT 21H
        SUB AL,30H
        MOV DATO1,AL

        MOV AH,09H 
        LEA DX,LET1
        INT 21H
        MOV AH,01H
        INT 21H
        SUB AL,30H
        MOV DATO2,AL
        ADD AL,DATO1
        
        ;IMPRIME RESULTADO
        ADD AL,30H
        MOV DL,AL
        MOV AH,02H
        INT 21H

        MOV AH,04CH
        MOV AL,00H
        INT 21H

MUES    PROC NEAR



        RET
MUES    ENDP

    LECTURA ENDP
   CODIGO ENDS
END LECTURA
