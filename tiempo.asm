; Devuelve el numero de segundos desde el 1 de enero de 1970
; Autor: lis
; Fecha: 20240311

%include 'stdio32.asm'

SECTION .data
	msg	db	'Segundos desde el 1 de enero de 1970: ', 0

SECTION .text
	global _start

_start:
	mov	eax, msg
	call	strPrint

	mov	eax, 13				; SYS_TIME
	int	80h

	call 	printIntLn

	call	Quit
