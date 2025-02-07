
Data                DCD     10, 12, 8, 1, 5, 7, 11, 6, 8 ; Example data

MAIN                LDR     R0, =Data ; Load address of data into R0
                    MOVS    R1, #0x00 ; Initialize low index to 0
                    MOVS    R2, #0x08 ; Number of elements - 1

                    BL      QUICKSORT ; Call QuickSort
                    B       EXIT

QUICKSORT           
                    CMP     R1, R2 ; If low >= high, return
                    BGT     NOTHING
                    STMFD   R12!, {R3, LR} ; Save registers

                    BL      PARTITION ; Call partition

                    SUB     R2, R3, #1 ; HIGH = PI - 1
                    BL      QUICKSORT ; Sort left partition

                    LDMFD   R12!, {R3, LR} ; Restore registers
                    ADD     R1, R3, #1 ; LOW = PI + 1
                    BL      QUICKSORT ; Sort right partition

                    LDMFD   R12!, {R3, LR} ; Restore before returning
                    MOV     PC, LR ; Return

PARTITION           
                    STMFD   R12!, {R6, R7, R8, LR} ; Save registers
                    LDR     R3, [R0, R2, LSL #2] ; PIVOT = ARR[HIGH]
                    SUB     R8, R2, #1 ;

                    MOV     R4, R1 ; j = LOW
                    MOV     R5, R1 ; i = LOW

PARTITION_LOOP      
                    CMP     R4, R8 ; while j <= HIGH - 1
                    BGT     SWAP ; End loop if j > high

                    LDR     R6, [R0, R4, LSL #2] ; ARR[J]
                    CMP     R6, R3 ; IF (ARR[J] <= PIVOT)
                    BLE     LESS_OR_EQUAL_PIVOT ; Swap(ARR[j], ARR[i])

                    ADD     R4, R4, #1 ; J++
                    B       PARTITION_LOOP ; Repeat loop

LESS_OR_EQUAL_PIVOT 
                    LDR     R7, [R0, R5, LSL #2] ; temp = ARR[i]
                    STR     R6, [R0, R5, LSL #2] ; ARR[i] = ARR[j]
                    STR     R7, [R0, R4, LSL #2] ; ARR[j] = temp
                    ADD     R5, R5, #1 ; i++
                    ADD     R4, R4, #1 ; j++
                    B       PARTITION_LOOP ; Repeat loop

SWAP                
                    LDR     R6, [R0, R5, LSL #2] ; R6 = ARR[i]
                    STR     R3, [R0, R5, LSL #2] ; R3 -> Arr[i]
                    STR     R6, [R0, R2, LSL #2] ; R6 -> Arr[high]
                    MOV     R3, R5 ; Return pivot index
                    LDMFD   R12!, {R6, R7, R8, LR} ; Restore registers
                    MOV     PC, LR ; Return

NOTHING             
                    MOV     PC, LR ; Return if nothing to sort

EXIT                