Data      DCD     10, 12, 8, 1, 5, 7, 11, 6, 8 ; Example data
          ;R0:    Base address register
          ;R1:    Low index
          ;R2:    High index
          ;R3:    store and return the pivot position
          ;R4:    - In PARTITION: i
          ;       - In QUICKSORT: pivot position
          ;R5:    j
          ;R6:    - arr[j]
          ;       - Swap operations
          ;R7:    - In QUICKSORT: saves original low index
          ;       - In PARTITION: temp swap
          ;R8:    In QUICKSORT: saves original high index
MAIN      
          LDR     R0, =Data ; Load address of data into R0
          MOV     R1, #0 ; Initialize low index to 0
          MOV     R2, #8 ; High index (number of elements - 1)
          BL      QUICKSORT ; Call QuickSort
          END

QUICKSORT 
          CMP     R1, R2 ; Compare low and high indices
          MOVGE   PC, LR ; If low > high, return

          STMFD   SP!, {R4,R7,R8, LR} ; Save pivot,low,high index
          MOV     R7, R1 ; Save original low
          MOV     R8, R2 ; Save original high

          BL      PARTITION ; Call partition, returns pivot in R3
          MOV     R4, R3 ; Save pivot position

          ;       Left partition
          MOV     R2, R4 ; high = pivot - 1
          SUB     R2, R2, #1
          BL      QUICKSORT

          ;       Right partition
          ADD     R1, R4, #1 ; low = pivot + 1
          MOV     R2, R8 ; Restore original high
          BL      QUICKSORT

          LDMFD   SP!, {R4,R7,R8, PC} ; Restore pivot,low,high index and return

PARTITION 
          LDR     R3, [R0, R2, LSL #2] ; pivot = arr[high]
          SUB     R4, R1, #1 ; i = low - 1
          MOV     R5, R1 ; j = low

PartLoop  
          CMP     R5, R2 ; while j < high
          BGE     EndLoop

          LDR     R6, [R0, R5, LSL #2] ; arr[j]
          CMP     R6, R3 ; arr[j] <= pivot
          BGT     Next

          ;       Swap
          ADD     R4, R4, #1 ; i++
          LDR     R7, [R0, R4, LSL #2] ; temp = arr[i]
          STR     R6, [R0, R4, LSL #2] ; arr[i] = arr[j]
          STR     R7, [R0, R5, LSL #2] ; arr[j] = temp

Next      
          ADD     R5, R5, #1 ; j++
          B       PartLoop

EndLoop   
          ADD     R4, R4, #1 ; i++
          LDR     R6, [R0, R4, LSL #2] ; temp = arr[i]
          STR     R3, [R0, R4, LSL #2] ; arr[i] = pivot
          STR     R6, [R0, R2, LSL #2] ; arr[high] = temp
          MOV     R3, R4 ; Return pivot index
          MOV     PC, LR
          END