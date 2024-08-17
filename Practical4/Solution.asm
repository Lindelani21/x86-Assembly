; Author: MLL Ragedi
.386
.MODEL FLAT ; Flat memory model
.STACK 4096 ; 4096 bytes
include io.inc

; Exit function
ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

; The data section stores all global variables
.DATA

; global variables
HR         DWORD 3 DUP (?)   ; heart rate during activity array
HRF        DWORD 3 DUP (?)   ; heart rate factor array

; local variables
strAge BYTE "Please enter the age: ", 0
strHR  BYTE "Please enter heart rate ", 0
strRHR BYTE "Please enter resting heart rate: ", 0
strCMul BYTE "Please enter calorie heart rate multiplier: ", 0
strHRF BYTE "The calculated HRF values are: ", 10, 0
strNL       BYTE 10, 0
strLoop     BYTE "Do you want to process another set of data? (Choose 0 for exit , Choose 1 for YES): ", 0
strComma    BYTE ", ", 0
strSBL      BYTE "[", 0 ; square bracket left
strSBR      BYTE "]", 0 ; square bracket right
strSemiColon    BYTE ": ", 0 ; Added missing string for colon

.CODE
_start:
    ; Most of your initial code will be under the _start tag.
    ; The _start tag is just a memory address referenced by the Public indicator
    ; highlighting which functions are available to calling functions.
    ; _start gets called by the operating system to start this process.

startLoop:
    PUSH ebp        ; Save base pointer
    MOV ebp, esp    ; Create Stack Frame
    SUB esp, 16     ; Reserve 4 DWORDS on stack

    ; input age
    INVOKE OutputStr, ADDR strAge
    INVOKE InputInt
    MOV [ebp-4], eax ; Save age in local variable

    ; input resting heart rate
    INVOKE OutputStr, ADDR strRHR
    INVOKE InputInt
    MOV [ebp-8], eax ; Save RHR in local variable

    ; input CMul
    INVOKE OutputStr, ADDR strCMul
    INVOKE InputInt
    MOV [ebp-12], eax ; Save CMul in local variable

    ; input HR values
    MOV ecx, 0      ; Counter for HR values
inputHRLoop:
    CMP ecx, 3
    JAE completeHRInputs
    INVOKE OutputStr, ADDR strHR
    INVOKE OutputInt, ecx
    INVOKE OutputStr, ADDR strSemiColon
    INVOKE InputInt
    MOV [HR + ecx*4], eax  ; Store HR value
    INC ecx
    JMP inputHRLoop

completeHRInputs:

    ;  Calculate HRF
    MOV ecx, 0      ; Counter for HRF values
calculateHRFLoop:
    CMP ecx, 3
    JAE doneCalculatingHRF

    ; Load HR value
    MOV eax, [HR + ecx*4] ; Load HR value
    MOV ebx, [ebp-8] ; Load RHR
    SUB eax, ebx    ; HRi - RHR
    MOV ebx, [ebp-12] ; Load CMul
    IMUL eax, ebx   ; (HRi - RHR) * CMul
    MOV ebx, [ebp-4] ; Load age
    MOV ebx, 220
    SUB ebx, [ebp-4] ; 220 - age
    SUB ebx, [ebp-8] ; ((220 - age) - RHR)
    CDQ
    DIV ebx         ; (result / ((220 - age) - RHR))
    MOV [HRF + ecx*4], eax ; Store HRF in array

    INC ecx
    JMP calculateHRFLoop
doneCalculatingHRF:

    ; Displaying HRF array
    INVOKE OutputStr, ADDR strHRF
    INVOKE OutputStr, ADDR strSBL

    ; Display HRF values
    MOV ecx, 0
displayHRF:
    CMP ecx, 3
    JAE doneDisplayingHRF
    MOV eax, [HRF + ecx*4]
    INVOKE OutputInt, eax
    INVOKE OutputStr, ADDR strComma
    INC ecx
    JMP displayHRF

doneDisplayingHRF:
    INVOKE OutputStr, ADDR strSBR
    INVOKE OutputStr, ADDR strNL

    MOV esp, ebp    ; Destroy stack frame
    POP ebp         ; Restore ebp

    ; Continually ask the user if they want to process another set of data
    INVOKE OutputStr, ADDR strLoop
    INVOKE InputInt
    CMP eax, 0
    JNE startLoop

    ; We call the Operating System ExitProcess system call to close the process.
    INVOKE ExitProcess, 0
Public _start
END
