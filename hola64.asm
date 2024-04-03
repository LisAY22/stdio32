; Hola mundo con arquitectura de 64 bits
; Creador: lis
; Fecha: 20240318

SECTION .data
	msg	db	'HOla mundo!', 0Ah, 0

SECTION .text
	global _start

_start:
	mov	rdx, 12
	mov	rsi, msg
	mov	rdi, 1				; stdout
	mov	rax, 1
	syscall

	mov	rax, 60
	xor	rdi, rdi
	syscall
