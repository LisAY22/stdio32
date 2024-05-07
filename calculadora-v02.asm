; Calculadora Version 2
; ./calculadora n1 n2 operador
; resultado: ...

%include 'stdio32.asm'

SECTION .data
    msg_suma        db      'Suma: ', 0
    msg_resta       db      'Resta: ', 0
    msg_multi       db      'Multiplicacion: ', 0
    msg_div         db      'Division: ', 0
    msg_residuo     db      ' residuo: ', 0

SECTION .bss
    Op              resb    1

SECTION .text
global _start

_start:
    ; Obtener el primer argumento de la línea de comandos
    pop     ecx

    pop     eax

    pop     eax
    call    str_to_int
    mov     ecx, eax

    ; Obtener el segundo argumento de la línea de comandos
    pop     eax
    call    str_to_int
    mov     ebx, eax

    ; Obtener el tercer argumento de la línea de comandos
    pop     eax
    mov     [Op], eax
    mov     eax, [Op]
    call    strPrintLn

    mov     esi, [Op]
    mov     al, [esi]
    cmp     al, '+'
    je      Add
    cmp     al, '-'
    je      Sus
    cmp     al, 'x'
    je      Mult
    cmp     al, '/'
    je      Div

Add:
    push    ebx
    push    ecx

    mov     eax, msg_suma
    call    strPrint

    add     ecx, ebx

    mov     eax, ecx
    call    printIntLn

    pop     ecx
    pop     ebx
    call    Quit

Sus:
    push    ebx
    push    ecx

    mov     eax, msg_resta
    call    strPrint

    sub     ecx, ebx

    mov     eax, ecx
    call    printIntLn

    pop     ecx
    pop     ebx
    call    Quit

Mult:
    push    ebx
    push    ecx

    mov     eax, msg_multi
    call    strPrint

    imul    ecx, ebx

    mov     eax, ecx
    call    printIntLn

    pop     ecx
    pop     ebx
    call    Quit

Div:
    push    ebx
    push    ecx

    mov     eax, msg_div
    call    strPrint

    mov     eax, ecx
    mov     esi, ebx
    div     esi            ;eax = eax/registro entera   ebx = sobrante
    call    printInt

    mov     eax, msg_residuo
    call    strPrint

    mov	    eax, edx
	call	printIntLn

    pop     ecx
    pop     ebx
    call    Quit
