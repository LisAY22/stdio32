; Hola Mundo con Calculo de Longitud de Cadena - Usando Funciones
; Autor: lis
; Fecha: 20240308

%include 'stdio32.asm'

SECTION .data
	msg	db	'Hola Mundo!', 0Ah, 0Dh

SECTION .text
	global _start

_start:
	mov	eax, msg
	call 	strLen

	mov	ebx, msg
	call	strPrint

	call	Quit
