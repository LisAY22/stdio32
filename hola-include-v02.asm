; Hola Mundo con Funciones Externas
; Autor: lis
; Fecha: 20240308

%include 'stdio32.asm'

SECTION .data
        msg1    db      'Hola Mundo!', 0
        msg2    db      'Arquitectura en llamas xd', 0
        msg3    db      'Lis', 0

SECTION .text
        global _start

_start:
        mov eax, msg1
        call strPrintLn

        mov eax, msg2
        call strPrint

        mov eax, msg3
        call strPrintLn

        call Quit
