; Division entre enteros
; Autor: lis
; Fecha: 20240309

%include 'stdio32.asm'

SECTION .text
        global _start

_start:
        mov     eax, 45
        mov     esi, 5
        idiv    esi             ; eax/esi

        call    printIntLn
        call    Quit

