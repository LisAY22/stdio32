; Lectura de datos desde el teclado y almacenamiento en memoria
; Autor: lis
; Fecha: 20240308

%include 'stdio32.asm'

SECTION .data
        msg1    db      'Ingrese su nombre: ', 0
        msg2    db      'Hola ', 0

SECTION .bss
        nombre  resb    20

SECTION .text
        global _start

_start:
        mov     eax, msg1
        call    strPrint

	mov     edx, 20
        mov     ecx, nombre
        mov     ebx, 0				; ebx = entrada estandar
        mov     eax, 3                          ; SYS_READ
        int     80h

        mov     eax, msg2
        call    strPrint

        mov     eax, nombre
        call    strPrint

        call    Quit
