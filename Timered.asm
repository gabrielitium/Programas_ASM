page 60,132
title interrup
DATOS SEGMENT PARA 'DATA'
        LET DB ' PRACTICAS DE INTERRUPCION ',0DH,0AH,'$'
        LET1 DB 0DH,0AH,'NOMBRE: $'
        LET2 DB 0DH,0AH,'ESE NOMBRE NO ES LA CLAVE ',0DH,0AH,'$'
        RECLEN EQU 10
        CTA DB 00
        VO1CO DW 1 DUP (?)      ; OFFSET
        VO1CS DW 1 DUP (?)      ; SEGMENTO
        LET3 DB 0DH,0AH,'HA LLEGADO A LOS DIEZ SEGUNDOS $'
        DIEZ EQU 182
        LET4 DB 0DH,0AH,'** HASTA LA VISTA INVETIL **  $'
        MAX_LP EQU 6
        BUFF DB 36 DUP (' ')
        ARR_P_R DB 'EEV_C' ; CLAVE
        COL1 DB 0DH,0AH,'ROJO $'
        COL2 DB 0DH,0AH,'VERDE $'
        COL3 DB 0DH,0AH,'AMARILLO $'
        VAR DB 00
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

                PUSH BX
                PUSH ES
                LEA DX,LET  ;IMPRIME EL PRIMER LETRERO
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

         LECTU: LEA DX,LET1
                CALL SUB
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
        SALIDA: LEA DX,LET2
                CALL SUB
                JMP LECTU
                RET
       ENCONTRO:LEA DX,LET3
                CALL SUB
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
        LEA DX,COL1
        MOV AH,09H
        INT 21H
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



                


