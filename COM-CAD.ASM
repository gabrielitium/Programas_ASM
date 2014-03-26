DATOS SEGMENT PARA 'DATA'
      LET1 DB 'INTRODUZCA 10 NUMEROS A EL ARREGLO "A"',0AH,0DH,'$'
      LET2 DB 'EL ARREGLO "A" SE COPIO EN EL ARREGLO "B":',0AH,0DH,'$'
      ENT  DB 0AH,0DH,'$'
      NUM1 DB 10 DUP (0)
      NUM2 DB 10 DUP (0)
DATOS ENDS
STACKSG SEGMENT PARA STACK 'STACK'
      DW 40 DUP(0)
STACKSG ENDS
CODIGO SEGMENT PARA 'CODE'
        ASSUME DS:DATOS,SS:STACKSG, CS:CODIGO
BEGIN PROC FAR
        PUSH DS
        XOR AX,AX
        PUSH AX
        MOV AX,DATOS
        MOV DS,AX
                    MOV AH,09H
                    LEA DX,LET1
                    INT 21H
        MOV CX,0AH
        LEA SI,NUM1
CICLO:  MOV AH,01H
        INT 21H
        SUB AL,30H
        MOV [SI],AL
        INC SI
        CALL FIN_LIN ;LLAMADO A FUNCION
        LOOP CICLO

          CALL FIN_LIN
        MOV CX,0AH
        LEA SI,NUM1
        LEA DI,NUM2

CICLO2: MOV BL,[SI]
        MOV [DI],BL                        
        INC SI
        INC DI
        LOOP CICLO2
                      MOV AH,09H
                      LEA DX,LET2
                      INT 21H
        MOV CX,0AH
        LEA DI,NUM2
CICLO3: MOV BL,[DI]
        ADD BL,30H
        MOV AH,02H
        MOV DL,BL 
        INT 21H
        INC DI
        CALL FIN_LIN ;LLAMADO A FUNCION
        LOOP CICLO3




        MOV AH,04CH
        MOV AL,00H
        INT 21H
BEGIN ENDP
FIN_LIN PROC
        MOV AH,09H
        LEA DX,ENT
        INT 21H
        RET
FIN_LIN ENDP
CODIGO ENDS
        END BEGIN
