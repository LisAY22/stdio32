; Imprimir numeros enteros en pantalla
; Autor: lis
; Fecha: 20240309

%include 'stdio32.asm'

SECTION .data
        msg1    db      'printIntLn: ', 0
        msg2    db      'printInt: ', 0

SECTION .text
        global _start

_start:
        mov     eax, msg1
        call    strPrintLn

        mov     ebx, 2678
        call    printIntLn

        mov     eax, msg2
        call    strPrintLn

        mov     ebx, 1500
        call    printInt

        call    Quit
