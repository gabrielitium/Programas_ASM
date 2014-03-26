DATOS SEGMENT PARA 'DATA'
        TIT DB 'ESTE PROGRAMA ENCUENTRA NUMEROS "1" EN UN ARREGLO ',0AH,0DH,'$'
        LET DB 0AH,0DH,'NUMERO: $'
        VECTOR DB 9 DUP(0)
        LET2 DB 0AH,0DH,'NUMEROS "1" ENCONTRADOS: $'
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
                        LEA DX,TIT
                        INT 21H
        MOV AL,0
        LEA SI,VECTOR
         MOV CL,0

CICLO:  CMP CL,9
        JE FIN

        MOV AH,09H
        LEA DX,LET
        INT 21H

        MOV AH,01H
        INT 21H
        SUB AL,30H
        MOV [SI],AL
        INC SI
        INC CL
        JMP CICLO
FIN:

        MOV AH,09H
        LEA DX,LET2
        INT 21H

        MOV CL,0
        MOV AL,0
        LEA DI,VECTOR

CICLO2:  CMP CL,09H
        JE SALIR
        MOV BL,[DI]
        INC DI
        INC CL
        CMP BL,01H
        JNE CICLO2
        ADD AL,01H
        JMP CICLO2
SALIR:  NOP

        MOV DL,AL
        CALL IMPRIMIR ;LLAMADO A FUNCI„N

        MOV AH,04CH
        MOV AL,00H
        INT 21H

BEGIN ENDP

IMPRIMIR PROC

        ADD DL,30H
        MOV AH,02H
        INT 21H
        RET
IMPRIMIR ENDP

CODIGO ENDS
      END BEGIN
