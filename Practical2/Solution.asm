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
str0 BYTE "Input first heart rate",10,0
HR0 DWORD ?
str1 BYTE "Input second heart rate",10,0
HR1 DWORD ?
str2 BYTE "Input third heart rate",10,0
HR2 DWORD ?
str3 BYTE "Input fourth heart rate",10,0
HR3 DWORD ?
str4 BYTE "Input fifth heart rate",10,0
HR4 DWORD ?
str5 BYTE "This is the average",10,0
AVG DWORD ? ;Average
str6 BYTE "This is the rounded average",10,0
RAVG DWORD ? ;Rounded avearge
str7 BYTE "This is the maximum heart rate",10,0
MAXV DWORD ? ;Maximum value

; The code section may contain multiple tags such as _start, which is the entry
; point of this assembly program
.CODE
_start:
main_loop:
    INVOKE OutputStr, ADDR str0 ;diplaying second prompt
    INVOKE InputInt ;Taking the first heart rate from the user
    mov HR0, eax

    INVOKE OutputStr, ADDR str1 ;diplaying second prompt
    INVOKE InputInt ;Taking the second heart rate from the user
    mov HR1, eax

    INVOKE OutputStr, ADDR str2 ;diplaying third prompt
    INVOKE InputInt ;Taking the third heart rate from the user
    mov HR2, eax

    INVOKE OutputStr, ADDR str3 ;diplaying fourth prompt
    INVOKE InputInt ;Taking the fourth heart rate from the user
    mov HR3, eax

    INVOKE OutputStr, ADDR str4 ;diplaying fifth prompt
    INVOKE InputInt ;Taking the fifth heart rate from the user
    mov HR4, eax

    ;calculating the average
    mov eax, HR0
    add eax, HR1
    add eax, HR2
    add eax, HR3
    add eax, HR4
    mov ebx, 5
    cdq
    idiv ebx
    mov AVG, eax
    INVOKE OutputStr, ADDR str5 ;diplaying sixth prompt
    INVOKE OutputInt, AVG
    INVOKE OutputStr, ADDR DOT
    INVOKE OutputInt, edx

    ;calculating the rounded up average
    mov eax, HR0
    add eax, HR1
    add eax, HR2
    add eax, HR3
    add eax, HR4
    add eax, 4
    mov ebx, 5
    cdq
    idiv ebx
    mov AVG, eax
    INVOKE OutputStr, ADDR str5 ;diplaying seventh prompt
    INVOKE OutputInt, AVG
    INVOKE OutputStr, ADDR DOT
    INVOKE OutputInt, edx

    ;evaluating maximum value 
    mov eax, HR0  
    mov ebx, HR1   
    cmp eax, ebx   
    jge skip1      
    mov eax, ebx   
skip1:

    mov ebx, HR2   
    cmp eax, ebx   
    jge skip2      
    mov eax, ebx   
skip2:

    mov ebx, HR3   
    cmp eax, ebx   
    jge skip3      
    mov eax, ebx   
skip3:

    mov ebx, HR4   
    cmp eax, ebx   
    jge skip4      
    mov eax, ebx   
skip4:

    mov MAXV, eax   
    INVOKE OutputStr, ADDR str7 ;diplaying eighth prompt
    INVOKE OutputInt, MAXV
 
    jmp main_loop

exit_program:
; Exit the program
INVOKE ExitProcess, 0

Public _start
END

