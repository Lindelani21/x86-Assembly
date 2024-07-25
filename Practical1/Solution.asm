;	Author:     MLL Ragedi
.386
.MODEL FLAT ; Flat memory model
.STACK 4096 ; 4096 bytes
INCLUDE io.inc


; Exit function
ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD


; The data section stores all global variables
.DATA 
DOT BYTE 46,0
str1 BYTE "Input stride length",10,0 ;string that prompts user to input stide length
stride DWORD ?  ;stride length(provided by the user, thererfore null)
str2 BYTE "Input step count",10,0 ;string that prompts user to input step count
stepCount DWORD ? ;step count(provided by the user, thererfore null)
str3 BYTE "This is the distance in meters",10,0 ;string that displays the distance in meters
distanceM DWORD ? ;distance in meters(calculated from user input, therefore null)
str4 BYTE "This is the distance in kilometers",10,0 ;string that displays the distance in kilometers
distanceK DWORD ? ;diatnce in kilometers(calculated using distance in meters, thererfore null)



; The code section may contain multiple tags such as _start, which is the entry
.CODE
_start: 
    INVOKE OutputStr, ADDR str1 ;diplaying first prompt
    INVOKE InputInt ;Taking the stride length form the user
    MOV stride, eax

    INVOKE OutputStr, ADDR str2 ;diplaying second prompt
    INVOKE InputInt ;Taking the step count form the user
    MOV stepCount, eax

    MOV eax, stride
    IMUL eax, stepCount
    MOV ebx, 100
    CDQ
    IDIV ebx
    MOV distanceM, eax 
    INVOKE OutputStr, ADDR str3 ;diplaying the distance in meters
    INVOKE OutputInt, distanceM
    INVOKE OutputStr, ADDR DOT
    INVOKE OutputInt, edx
    
    MOV eax, distanceM
    MOV ebx, 1000
    CDQ
    IDIV ebx
    MOV distanceK, eax
    INVOKE OutputStr, ADDR str4 ;diplaying the distance in kilometers
    INVOKE OutputInt, distanceK
    INVOKE OutputStr, ADDR DOT
    INVOKE OutputInt, edx

	; We call the Operating System ExitProcess system call to close the process.
	INVOKE ExitProcess, 0
Public _start
END
