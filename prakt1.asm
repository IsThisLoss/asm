.386
.model flat, stdcall
option casemap :none   

include \masm32\include\windows.inc
include \masm32\include\user32.inc
include \masm32\include\kernel32.inc
includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib

.data
	AA DD 20
	BB DD 20
	CC DD 50

	titleStr db "��������� ���������",0
	trueStr db "�����",0
	falseStr db "�� �����",0

.code
	start:				;����� ������ ���������
		MOV EDX, AA		;���������� ���������� AA � ������� EDX
		ADD EDX, BB 	;EDX = EDX + BB (��� EDX = AA + BB)

		CMP EDX, CC		;���������� EDX � CC
		JL LESS			;���� EDX < CC ��������� �� ����� LESS
						;����� ��������� ��������� ������
		invoke MessageBox, NULL, addr falseStr, addr titleStr, MB_OK
		JMP STOP 		;������� ����� � ����������� ���������
		
		LESS:
			invoke MessageBox, NULL, addr trueStr, addr titleStr, MB_OK
		
		STOP:
			invoke ExitProcess, NULL	;����� ���������, ����������� ������ ���������
	end start                        	;����� ���������