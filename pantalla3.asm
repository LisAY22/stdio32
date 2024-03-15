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

	; ----- Posicion del cursor -----
	mov	eax, 0C1F
	call 	gotoxy

	; ----- Imprimir cadena de mensaje -----
	mov	eax, msg
	call	strPrintLn

	; ----- Posicionar cursor al final -----
	mov	eax, 1801h
	call	gotoxy

	call 	Quit
