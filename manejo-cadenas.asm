; Manejo de cadena, convertir a mayuscula y minuscula
; Autor: lis
; Fecha: 20240303

%include 'stdio32.asm'

SECTION .data
        msg1    db      'Ingrese una cadena: ', 0
        msg2    db      'Mayuscula: ', 0
        msg3    db      'Minuscula: ',0

SECTION .bss
        cadena          resb    20
        cadenaUpCase    resb    20
        cadenaLowCase   resb    20

SECTION .text
        global _start

_start:
        mov     eax, msg1
        call    strPrint

        mov     ebx, cadena
        call    strInput

        mov     esi, cadena                             ; esi = puntero de origen
        mov     edi, cadenaUpCase                       ; edi = puntero de destino
        call    upCase
        mov     byte [edi], 0

	mov     eax, msg2
        call    strPrint
        mov     eax, cadenaUpCase
        call    strPrint

        mov     esi, cadena
        mov     edi, cadenaLowCase
        call    loCase
        mov     byte [edi], 0

        mov     eax, msg3
        call    strPrint
        mov     eax, cadenaLowCase
        call    strPrintLn

	call 	Quit
