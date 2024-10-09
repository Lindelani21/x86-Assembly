; author: MLL Ragedi
.386
.MODEL FLAT ; Flat memory model
.STACK 4096 ; 4096 bytes
INCLUDE io.inc

; Exit function
ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

; The data section stores all global variables
.DATA
    searchChar BYTE '$'  
    replaceChar BYTE ',' 
    inputString BYTE 100 DUP(?) ; Input string, "inputStr" is used by io.inc
    reversedStr BYTE 100 DUP(?) ; Reversed string 
    promptStringInput BYTE "Enter a string: ",0
    promptReverse BYTE "Reversed string: ",0
    newLineChar BYTE 10,0

; The code section may contain multiple tags such as _start, which is the entry
; point of this assembly program
.CODE
_start:
    ; Main procedure call
    CALL main

    ; Exit process
    INVOKE ExitProcess, 0

        ; Main Function,  
        main PROC
            ; Prompt user for string input
            INVOKE OutputStr, ADDR promptStringInput
            INVOKE InputStr, ADDR inputString, 100
            
            ; Call function to replace characters
            CALL replaceCharacters
            
            ; Call function to reverse the string
            CALL reverseString
            
            ; Output the reversed string
            INVOKE OutputStr, ADDR promptReverse
            INVOKE OutputStr, ADDR reversedStr
            INVOKE OutputStr, ADDR newLineChar
            
            RET
        main ENDP

        ; Function that replaces the characters
        replaceCharacters PROC
            MOV esi, OFFSET inputString 
            MOV ecx, 100 ;for the buffer lenth
            
            replace_loop:
                LEA eax, inputString
                CMP bl, 0 
                JE end_replace 
                
                CMP bl, searchChar 
                JNE next_char 
                
                MOV bl, replaceChar 
                MOV [esi-1], bl 
                
            next_char:
                LOOP replace_loop ; Repeat for all characters
                
            end_replace:

            RET
        replaceCharacters ENDP

        ; Function to reverses the input string
        reverseString PROC
            MOV esi, OFFSET inputString
            MOV edi, OFFSET reversedStr
            MOV ecx, 0
            
            find_lenth:
                CMP BYTE PTR [esi+ecx], 0 
                JE begin_reverse
                INC ecx
                JMP find_lenth

            begin_reverse:
                DEC ecx 
                
            reversing_loop:
                MOV bl, [esi+ecx] 
                MOV [edi], bl 
                DEC ecx 
                INC edi 
                CMP ecx, -1 
                JG reversing_loop
                MOV BYTE PTR [edi], 0

            RET
        reverseString ENDP

exit_program:
; Exit the program
INVOKE ExitProcess, 0

Public _start
END
