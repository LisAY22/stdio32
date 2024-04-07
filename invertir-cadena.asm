; Invertir cadena
; autor: lis
; fecha: 20240306

%include 'stdio32.asm'

SECTION .data
        msg1        db      'Ingrese la cadena a invertir: ', 0
        msg2        db      'Cadena invertida: ', 0

        len1        equ     $-msg1
        len2        equ     $-msg2

SECTION .bss
        cadena              resb        100
        cadenaInvertida     resb        100

SECTION .text
        global _start

_start:
        mov     eax, msg1
        call    strPrint
        mov     edx, len1

        mov     eax, 3
        mov     ebx, 0
        mov     ecx, cadena
        mov     edx, 100
        int     80h

        mov     esi, cadena
        call    strLen2

	mov     esi, cadena
        mov     edi, cadenaInvertida
        add     edi, eax
        call    reverseString

        mov     eax, msg2
        call    strPrint
        mov     edx, len2

        mov     eax, cadenaInvertida
        call    strPrintLn

        call    Quit

strLen2:
        xor     ecx, ecx
CicloLen:
        cmp     byte [esi + ecx], 0
        je      returnLen
        inc     ecx
        jmp     CicloLen

returnLen:
        mov     eax, ecx
        ret

reverseString:
        mov     edx, eax
        dec     edi

CicloReverse:
        mov     al, [esi]
        mov     [edi], al
        inc     esi
        dec     edi
        loop    CicloReverse
        ret
