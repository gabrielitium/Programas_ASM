page 60,132
title interrup
DATOS SEGMENT PARA 'DATA'
        RECLEN EQU 10
        CTA DB 00
        VO1CO DW 1 DUP (?)      ; OFFSET
        VO1CS DW 1 DUP (?)      ; SEGMENTO
        DIEZ EQU 182
        MAX_LP EQU 6
        BUFF DB 36 DUP (' ')
        ARR_P_R DB 'EEV_C' ; CLAVE
        LET1 DB 0FH,09H,' PROGRAMA DE EXAMEN ',0DH,0AH,'$'
        COL1 DB 0FH,09H,'ROJO ',0DH,0AH,'$'
        COL2 DB 0FH,09H,'VERDE ',0DH,0AH,'$'
        COL3 DB 0FH,09H,'AMARILLO ',0DH,0AH,'$'
        VAR DB 01
DATOS ENDS

STACKSG SEGMENT PARA STACK 'STACK'
        DW 1000 DUP (?)
STACKSG ENDS
CODIGO SEGMENT PARA 'CODE'
        ASSUME DS:DATOS,SS:STACKSG,CS:CODIGO,ES:DATOS
TIMER PROC FAR
        PUSH DS
        XOR AX,AX
        PUSH AX
        MOV AX,DATOS
        MOV DS,AX
        MOV ES,AX

        LEA DX,LET1
        CALL SUB

                ;SALVAR EL VECTOR ORIGINAL PARA INT 1CH
                MOV AH,35H   ;SE SALVA EL VECTOR
                MOV AL,1CH
                INT 21H
                ;EN ES: CODIGO DE SEGMENTO
                ;BX:OFFSET
                MOV VO1CO,BX ;SALVAR EL OFFSET EN VO1CO
                MOV BX,ES
                MOV VO1CS,BX ;SALVAR EL CODIGO DEL SEGMENTO
                ;ESTABLECER EN LA TABLA DE VECTORES EL VECTOR SER1C
                PUSH DS
                PUSH DX
                PUSH AX
                MOV DX,OFFSET SERV1C   
                MOV AX,SEG SERV1C  ;DS:DX = VECTOR
                MOV DS,AX
                CLI       ;NO SE ACEPTAN INTERRUPCIONES DE AQUI EN ADELANTE
                XOR AX,AX
                MOV AH,25H
                MOV AL,1CH
                INT 21H
                STI  ;YA SE ACEPTAN INTERRUPCIONES
                POP AX
                POP DX
                POP es
                POP BX

         LECTU:
;                LEA DX,LET1
;                CALL SUB
                MOV CX,6
         TA:    MOV AH,0
                INT 16H
              
                MOV BUFF + 2,AL
                CMP CX,0
                INC CX
                INC BUFF
                JNE TA
       
                MOV BX,MAX_LP
        CICLO:  ADD BX,MAX_LP
                JA SALIDA
                MOV CX,MAX_LP
                LEA DI,ARR_P_R
               
                LEA SI,BUFF + 2; INCREMENTO
                REPE CMPSB
                JE ENCONTRO
        SALIDA: 
                
                JMP LECTU
                RET
       ENCONTRO:
                ;ESTABLECER EL VECTOR
                ;EN LA TABLA DE VECTORES

                MOV DS,VO1CS
                MOV DX,VO1CO
                CLI
                MOV AH,25H
                MOV AL,1CH
                INT 21H
                STI
                RET
TIMER ENDP
SERV1C PROC NEAR
        PUSH DS
        PUSH AX
        PUSH DX
        MOV AX,DATOS
        MOV DS,AX
VUELTA: INC [CTA]
        MOV AL,[CTA]
        CMP AL,DIEZ
        JNE SAL
        CLI

        CMP VAR,01
        JNE SIGUE2
        LEA DX,COL1
        CALL SUB
        JMP TER
SIGUE2: CMP VAR,02
        JNE SIGUE3
        LEA DX,COL2
        CALL SUB
        JMP TER
SIGUE3: CMP VAR,03
        JE TER
        LEA DX,COL3
        CALL SUB
        MOV VAR,00H
TER:    ADD VAR,01

        ;MOV AH,09H
        ;INT 21H
        MOV [CTA],0
        STI
SAL:    POP DX
        POP AX
        POP DS
        IRET
SERV1C ENDP

SUB PROC
        MOV AH,09H
        INT 21H
        RET
SUB ENDP
CODIGO ENDS
        END TIMER



                


