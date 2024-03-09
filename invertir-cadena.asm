; Invertir cadena
; Autor: lis
; Fecha: 20240306

%include 'stdio32.asm'

SECTION .data
	msg	 db      'Ingrese una cadena: ', 0
        msg2     db      'Cadena invertida: ', 0

SECTION .bss
	cadena             	resb        100
        cadenaInvertida		resb        100

SECTION .text
        global _start

_start:
	mov	eax, msg
	call 	strPrint

	mov 	eax, cadena
	mov	esi, cadena
	mov 	edi, cadenaInvertida
	call	strInput

	mov	eax, cadena
	call 	strInvert

	mov	eax, cadenaInvertida
	call	strPrintLn

	call	Quit
