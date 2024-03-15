; Abrir archivo en algun modo de operacion
; 0 : O_RDONLY, 1 ; O_WRONLY, 2: O_RDWR
; Autor: lis
; Fecha: 20240313

%include 'stdio32.asm'

SECTION .data
	filename	db	'leame.txt', 0
	contenido	db	'Hola mundo!', 0

SECTION .bss
	strLectura	resb	255

SECTION .text
	global _start

_start:
	; ---------- Creacion del archivo ----------
	mov	ecx, 0777o
	mov	ebx, filename
	mov	eax, 8
	int	80h

	; ---------- Escribir contenido en el archivo ----------
	mov	edx, 12
	mov	ecx, contenido
	mov	ebx, eax		; Descriptor del archivo
	mov	eax, 4
	int	80h

	; ---------- Modo Lectura ----------
	mov	ecx, 0			; Bandera de solo lectura O_RDONLY
	mov	ebx, filename
	mov	eax, 5			; SYS_OPEN
	int 	80h

	; ----------
	; Este bloque se utilizo para mostrar el descriptor del archivo
	; call 	printIntLn
	; call	Quit
	; ----------

	; ---------- Leer el contenido del archivo ----------
	mov	edx, 12			; Longitud de cadena a leer
	mov	ecx, strLectura		; Variable a utilizar
	mov	ebx, eax		; Descritor del archivo
	mov	eax, 3
	int	80h

	; ---------- Imprimir cadena leida ----------
	mov	eax, strLectura
	call	strPrintLn

	; ---------- Cerrar el archivo ----------
	mov	ebx, ebx
	mov	eax, 6
	int	80h

	call 	Quit
