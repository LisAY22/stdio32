; Hola Mundo con Funciones Externas
; Autor: lis
; Fecha: 20240308

%include 'stdio32.asm'

SECTION .data
	msg1	db	'Hola Mundo!', 0Ah, 0Dh
	msg2 	db	'Arquitectura en llamas xd', 0Ah, 0Dh

SECTION .text
	global _start

_start:
	mov	eax, msg1
	call	strPrint

	mov	eax, msg2
	call 	strPrint

	call 	Quit
