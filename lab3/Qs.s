Data           DCD     10, 12, 8, 1, 5, 7, 11, 6, 8 ; Example data array

               ;       R0 - Base address of the array
               ;       R1 - Low index
               ;       R2 - High index
               ;       R3 - pivot value and return pivot position
               ;       R4 - In Quicksort: stores pivot index. In Partition: i index
               ;       R5 - In Partition: j index

MAIN           
               LDR     R0, =Data ; Load base address of array into R0
               MOVS    R1, #0 ; Initialize low index to 0
               MOVS    R2, #8 ; Set high index (array length - 1)
               BL      QUICKSORT ; Call QuickSort function
               End

QUICKSORT      
               CMP     R1, R2
               MOVGE   PC,LR

               ;       Save registers and link register for recursive calls
               STMFD   SP!, {R1-R4, LR}

               BL      PARTITION ; Call partition function
               MOV     R4, R3 ; Save pivot index in R4

               ;       Sort left partition
               STMFD   SP!, {R1-R2} ; Save current bounds
               SUB     R2, R4, #1 ; high = pivot - 1
               BL      QUICKSORT ; Recursive call for left part
               LDMFD   SP!, {R1-R2} ; Restore original bounds

               ;       Sort right partition
               ADD     R1, R4, #1 ; low = pivot + 1
               BL      QUICKSORT ; Recursive call for right part

               LDMFD   SP!, {R1-R4, PC} ; Return and restore registers

PARTITION      
               LDR     R3, [R0, R2, LSL #2] ; pivot value (last element)
               MOV     R4, R1 ; Initialize i = low
               SUB     R4, R4, #1 ; i = low - 1

               MOV     R5, R1 ; Initialize j = low
PARTITION_LOOP 
               CMP     R5, R2 ; Check if j < high
               BGE     PARTITION_END

               LDR     R6, [R0, R5, LSL #2] ; Load array[j]
               CMP     R6, R3 ; Compare with pivot
               BGE     CONTINUE ; If array[j] >= pivot

               ADD     R4, R4, #1 ;  i++
               LDR     R7, [R0, R4, LSL #2] ; Perform swap of elements
               STR     R6, [R0, R4, LSL #2]
               STR     R7, [R0, R5, LSL #2]

CONTINUE       
               ADD     R5, R5, #1 ;  j++
               B       PARTITION_LOOP

PARTITION_END  
               ADD     R4, R4, #1 ;  i++
               LDR     R6, [R0, R4, LSL #2] ; Swap pivot to its final position
               STR     R3, [R0, R4, LSL #2]
               STR     R6, [R0, R2, LSL #2]

               MOV     R3, R4 ; Return pivot position
               MOV     PC,LR
