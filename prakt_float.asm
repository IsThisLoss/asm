.386
.model flat, stdcall
option casemap :none   ; case sensitive
;-------------------------------------------------
include 	\masm32\include\windows.inc
include 	\masm32\include\user32.inc
include 	\masm32\include\kernel32.inc
include 	\masm32\include\fpu.inc   
include 	\masm32\include\masm32.inc
includelib  \masm32\lib\user32.lib
includelib  \masm32\lib\kernel32.lib
includelib  \masm32\lib\fpu.lib    
includelib 	\masm32\lib\masm32
;-------------------------------------------------

.data
	A		DQ	-9806.23
	B		DQ	+2.0
	S		DQ	0
	SixTeen DQ	+16.0

	sOut	DB	64 dup (0)
	sTitle	DB "Title", 0
.code
start:
	FLD		A 							; push A to ST(0)
	FADD	B 							; ST(0) = ST(0) + B
	FDIV	SixTeen 					; ST(0) = ST(0) / SixTeen
	FCHS								; ST(0) = -ST(0)
	FSTP	S 							; S = ST(0)
	invoke FloatToStr, S, ADDR sOut
	invoke MessageBox, NULL, ADDR sOut, ADDR sTitle, MB_OK		
	invoke ExitProcess, NULL
end start
