; Limpiar pantalla y despliegue de cadena en posicion especifica
; Autor: lis
; Fecha: 202040315

%include 'stdio32.asm'

SECTION .data
	msg		db	'Hola Arquitectura!', 0

SECTION .text
	global _start

_start:
	call 	clrscr

	mov	dl, 57
	mov	dh, 57

	call 	gotoxy

	; ----- Imprimir cadena de mensaje -----
	mov	eax, msg
	call	strPrintLn

	call 	Quit
