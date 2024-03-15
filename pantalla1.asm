; Limpiar pantalla y despliegue de cadena
; Autor: lis
; Fecha: 202040315

%include 'stdio32.asm'

SECTION .data
	msg	db	'Hola Arquitectura!', 0
	strCls	db	1Bh, '[2J', 1Bh, '[3J', 0

SECTION .text
	global _start

_start:
	; ----- Limpiar pantalla -----
	mov	eax, strCls
	call	strPrint

	mov	eax, msg
	call	strPrintLn

	call 	Quit
