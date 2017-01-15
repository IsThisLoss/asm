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

	titleStr db "Результат программы",0
	trueStr db "Верно",0
	falseStr db "Не верно",0

.code
	start:				;Метка начала программы
		MOV EDX, AA		;Записываем переменную AA в регистр EDX
		ADD EDX, BB 	;EDX = EDX + BB (или EDX = AA + BB)

		CMP EDX, CC		;Сравниваем EDX и CC
		JL LESS			;Если EDX < CC переходим на метку LESS
						;Иначе выполняем следующую строку
		invoke MessageBox, NULL, addr falseStr, addr titleStr, MB_OK
		JMP STOP 		;Вызывем метку с завершением программы
		
		LESS:
			invoke MessageBox, NULL, addr trueStr, addr titleStr, MB_OK
		
		STOP:
			invoke ExitProcess, NULL	;Вызов процедуры, завершающей работу программы
	end start                        	;Конец программы