; Impresion en pantalla con envio de argumentos
; Autor: lis
; Fecha: 20240308

%include 'stdio32.asm'

SECTION .text
        global _start

_start:
        pop     ecx

cicloExtrae:
        cmp     ecx, 0h
        jz      noMasArg
        pop     eax
        call    strPrintLn
        dec     ecx				; Decrementa en 1
        jmp     cicloExtrae

noMasArg:
        call    Quit



