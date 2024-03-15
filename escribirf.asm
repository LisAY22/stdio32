; Creacion y Escritura en archivos
; Autor: lis
; Fecha: 20240311

%include 'stdio32.asm'

SECTION .data
	nombrearch	db	'leame.txt', 0
	cadena		db	'este es el contenido a agregar', 0

SECTION .text
	global _start

_start:
	; ----- Creacion de archivo -----
	mov	ecx, 0777o			; configurando permisos rwx 4aall
	mov	ebx, nombrearch			; nombre del archivo a crear
	mov	eax, 8				; SYS_CREATE
	int 	80h
	; ----- Escritura en archivo -----
	mov	ebx, eax
	mov	eax, cadena
	call	strLen

	mov	edx, eax			; longitud de la cadena en edx
	mov	ecx, cadena			; contenido a agregar en ecx
	mov	eax, 4				; Invoca a SYS_WRITE
	int	80h

	call 	Quit
