Data                DCD     10, 12, 8, 1, 5, 7, 11, 6, 8
                    MOVS    R12, #0x08
MAIN                LDR     R0, =Data
                    MOVS    R10, #0x00
                    BL      QUICKSORT


QUICKSORT           CMP     R10, R12
                    BGT     NOTHING
                    STMFD   R8!, {R0, R10, R12, LR}
                    BL      PARTITION
                    MOV     R9, R0 ;low index (first)
                    MOV     R5, R12 ;high index (last)


                    SUB     R12,R9,#1 ;HIGH = PI-1
                    BL      QUICKSORT

                    LDMFD   R8!, {R0, R10, R12, LR} ;RESTORE CURRENT DATA
                    ADD     R10, R9, #1 ; LOW = PI + 1
                    BL      QUICKSORT

                    LDMFD   R8!, {R0, R10, R12, LR} ;RESTORE LINK REGISTER
                    MOV     PC, LR


PARTITION           STMFD   R8!, {R4, R5, R6, LR}
                    MOV     R4, R0 ;base address
                    MOV     R5, R12 ;high index
                    LDR     R9, [R4, R5, LSL #2] ;PIVOT =ARR[HIGH]

                    MOV     R2, R10 ;j = LOW
                    MOV     R3, R10 ;i = LOW

PARTITION_LOOP      CMP     R2,R5 ; j > HIGH
                    BGT     SWAP

                    LDR     R7, [R4, R2, LSL #2] ;ARR[J]
                    CMP     R7,R9 ;IF (ARR[J] > PIVOT)
                    BLE     LESS_OR_EQUAL_PIVOT ; SWAP(ARR[R2], ARR[R3])

                    ADD     R2,R2,#1 ;J++
                    B       PARTITION_LOOP

LESS_OR_EQUAL_PIVOT LDR     R6, [R4, R3, LSL #2] ; temp = ARR[i]
                    STR     R7, [R4, R3, LSL #2] ; ARR[i] = ARR[j]
                    STR     R6, [R4, R2, LSL #2] ; ARR[j] = temp
                    ADD     R3, R3, #1 ; i++
                    ADD     R2, R2, #1 ; j++
                    B       PARTITION_LOOP

SWAP                LDR     R7, [R4, R3, LSL #2]
                    STR     R9, [R4, R3, LSL #2]
                    STR     R7, [R4, R5, LSL #2]
                    MOV     R0, R3
                    LDMFD   R8!, {R4, R5, R6, LR}
                    MOV     PC, LR



NOTHING             MOV     PC, LR


