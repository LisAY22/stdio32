; Impresion de Digitos en Pantalla
; Autor: lis
; Fecha: 20240309

%include 'stdio32.asm'

SECTION .text
        global _start

_start:
	mov	ecx, 0

sigNumero:
	mov	eax, ecx
        add     eax, 48
        push    eax
        mov     eax, esp
        call    strPrintLn
	pop 	eax
	inc	ecx
	cmp	ecx, 10
	jne	sigNumero

        call    Quit

