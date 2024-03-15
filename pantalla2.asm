; Limpiar pantalla y despliegue de cadena en posicion especifica
; Autor: lis
; Fecha: 202040315

%include 'stdio32.asm'

SECTION .data
	msg		db	'Hola Arquitectura!', 0
	strCls		db	1Bh, '[2J', 1Bh, '[3J', 0
	strPosXY	db	1Bh, '[12;31H', 0
	strFinpantalla	db	1Bh, '[24;1H', 0

SECTION .text
	global _start

_start:
	; ----- Limpiar pantalla -----
	mov	eax, strCls
	call	strPrint

	; ----- Posicion del cursor -----
	mov	eax, strPosXY
	call 	strPrint

	; ----- Imprimir cadena de mensaje -----
	mov	eax, msg
	call	strPrintLn

	; ----- Posicionar cursor al final -----
	mov	eax, strFinpantalla
	call	strPrint

	call 	Quit
