.386
.model flat, stdcall
option casemap :none   

include \masm32\include\windows.inc
include \masm32\include\user32.inc
include \masm32\include\kernel32.inc
includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib

.data
	A		DD 	1, 2, 3, 0,
		 		4, 5, 6, 0,
		 		7, 8, 9, 0,
	B 		DD 	0, 0, 0, 0, 0
	rows 	DD 	4
	columns	DD 	4
	midrow  DD 	0
	midcol 	DD 	0
	two 	DD  2

	off  	DD  16
	sRes 	DB 	50 dup (0)
	format	DB 	"Over: %d, Under: %d, on: %d", 10, "On middle column %d, on middle row %d", 0
	sTitle	DB "title", 0
.code
start:
; #####################  init middle row  ###################
	MOV 	midrow, -1
	XOR 	EDX, EDX
	MOV 	EAX, rows
	DIV 	two
	CMP 	EDX, 0
	JZ 		skip_midrow
	MOV 	midrow, EAX 		; set index of mid row = EAX if the number of rows is odd, otherwise it remains -1
skip_midrow:
	
; ################## init middle column  ###################
	MOV 	midcol, -1
	XOR 	EDX, EDX
	MOV 	EAX, columns
	DIV 	two
	CMP 	EDX, 0
	JZ 		skip_midcol
	MOV 	midcol, EAX			; set index of mid column = EAX if the number of colums is odd, otherwise it remains -1
skip_midcol:

; ######################### main ############################
; ---------------- external loop begin ---------------------- 
	XOR		EBX, EBX 	; EBX = 0
	MOV		ECX, rows 	
for_rows:
	MOV		EDX, columns
	XCHG	ECX, EDX
	XOR 	ESI, ESI
for_columns:
; ---------------- inner loop begin ------------------------ 
	MOV 	EDI, rows 			
	SUB 	EDI, EDX			; set EDX = index of current row 
	CMP 	ESI, EDI			; if construction
	JG 		over				
	JL		under
	JE 		main
check_mid_col:					; check if current element is on middle column
	CMP 	ESI, midcol
	JE 		on_mid_col
check_mid_row:					; check if current element is on middle row
	CMP 	EDI, midrow
	JE 		on_mid_row
next_iter:						
	INC 	ESI
	LOOP 	for_columns
; ---------------- inner loop end --------------------------
	ADD 	EBX, off			; go to the next line
	XCHG 	ECX, EDX
	LOOP 	for_rows
; ---------------- external loop end -----------------------

	
	invoke wsprintf, ADDR sRes, ADDR format, B[0], B[4], B[8], B[12], B[16] ; output to string
	invoke MessageBox, NULL, ADDR sRes, ADDR sTitle, MB_OK					; output to messagebox
	invoke ExitProcess, NULL												; exit

; ######################### --- ############################
; A[EBX + ESI*4] is ALWAYS current element of array
over:
	MOV EAX, B[0]
	ADD EAX, A[EBX + ESI*4]
	MOV B[0], EAX
	JMP check_mid_col

under:
	MOV EAX, B[4]
	ADD EAX, A[EBX + ESI*4]
	MOV B[4], EAX
	JMP check_mid_col

main:
	MOV EAX, B[8]
	ADD EAX, A[EBX + ESI*4]
	MOV B[8], EAX
	JMP check_mid_col

; if midrow have set to -1, we never reach this code  
on_mid_col:
	MOV EAX, B[12]
	ADD EAX, A[EBX + ESI*4]
	MOV B[12], EAX
	JMP check_mid_row

; the same thing
on_mid_row:
	MOV EAX, B[16]
	ADD EAX, A[EBX + ESI*4]
	MOV B[16], EAX
	JMP next_iter
	
end start