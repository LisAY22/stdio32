; Llamada de comandos del sistema
; Autor: lis
; Fecha: 20240308

%include 'stdio32.asm'

SECTION .data
	comando		db	'/bin/echo', 0		; comando a ejecutar
	mensaje 	db	'Hola mundo!', 0	; cadena a desplegar
	argumentos	dd	comando			; creacion de sruct
			dd	mensaje			;
			dd 	0			; fin de struct
	entorno		dd	0			; parametro a trasladar

SECTION .text
	global _start

_start:
	mov	edx, entorno				; direccion de vars, de entorno
	mov 	ecx, argumentos				; argumentosa pasar a la linea de comandos 
	mov 	ebx, comando				; comando a ejecutar
	mov 	eax, 11					; SYS_EXECVE
	int 	80h

	call 	Quit
