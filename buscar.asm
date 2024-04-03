; Buscar SEEK_SET = 0, SEEK_CUR = 1, SEEK_END = 2
; Autor: lis
; Fecha: 20240318

%include 'stdio32.asm'

SECTION .data
	archivo		db	'leame.txt', 0
	contenido	db	'--esto es una actualizacion--', 0

SECTION .text
	global _start

_start:
	; ---------- Abrir archivo en modo de escritura ----------
	mov	ecx, 1					; O_WRONGLY
	mov	ebx, archivo
	mov	eax, 5
	int	80h

	; ---------- Ir a fin de archivo para agregar contenido ----------
	mov	edx, 2					; SEE_END
	mov	ecx, 0					; Mover el cursor 0 bytes
	mov	ebx, eax				; Descriptor de archivo en ebx
	mov	eax, 19					; SYS_LSEEK
	int 	80h

	;----------  Agregar el contenido
	mov	edx, 29					; Cantidad de bytes a agregar
	mov	ecx, contenido				; Cadena a agregar
	mov	ebx, ebx				; Mover el descriptor
	mov	eax, 4					; SYS_WRITE
	int 	80h

	call	Quit
