;	Author:  MLL Ragedi
.386
.MODEL FLAT ; Flat memory model
.STACK 4096 ; 4096 bytes

; Exit function
ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

; The data section stores all global variables
.DATA
ahr 	 DWORD 161
duration DWORD 109
steps  	 DWORD 12323
Calories DWORD ?



; The main program code section 
.CODE
_start:

    mov eax,ahr
    imul eax,duration
    mov ebx,100
    cdq
    idiv ebx

    mov Calories,eax
    add eax,steps
    mov ebx,20
    cdq
    idiv ebx
    
    add eax,Calories
    mov Calories,eax

	
	INVOKE ExitProcess, 0
Public _start
END
