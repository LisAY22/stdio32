; Calculadora Version 1
; Funcionalidad 1
; ./calculadora
; Ingrese n1:
; Ingrese n2:
; Operacion:
; Resultado ...
; Funcionalidad 2
; ./calculadora n1 n2
; Suma: ...
; Resta: ...
; Multiplicacion: ...
; Division: ...

 %include 'stdio32.asm'

SECTION .data
    msg_suma        db      'Suma: ', 0
    msg_resta       db      'Resta: ', 0
    msg_multi       db      'Multiplicacion: ', 0
    msg_div         db      'Division: ', 0
    msg_residuo     db      ' residuo: ', 0
    msg_n1          db      'Primer numero: ', 0
    msg_n2          db      'Segundo numero (no debe ser 0): ', 0
    msg_op          db      'Operacion (+, -, *, /): ', 0


SECTION .bss
    n1              resd    1
    n2              resd    1
    Op              resb    1


SECTION .text
global _start

_start:
    ; Obtener el primer argumento de la línea de comandos
    pop     ecx
    cmp     ecx, 1h                 ; comparar si los parametros son menores a 2 
    jle     .Insert

    pop     eax

    pop     eax
    call    str_to_int
    mov     ecx, eax

    ; Obtener el segundo argumento de la línea de comandos
    pop     eax
    call    str_to_int
    mov     ebx, eax

    jmp     mod1



.Insert:

        ; ------- Insertar primer numero ---------
        mov     eax, msg_n1
        call    strPrint

        mov     ebx, n1
        call    strInput

        ; ------- Insertar segundo numero --------
        mov     eax, msg_n2
        call    strPrint

        mov     ebx, n2
        call    strInput

        ; -------- Insertar operacion -----------
        mov     eax, msg_op
        call    strPrint

        mov     ebx, Op
        call    strInput

        ; -------- Convierte primer numero a int --------
        mov     eax, n1
        call    str_to_int
        mov     ecx, eax

        ; -------- Convierte segundo numero a int --------
        mov     eax, n2
        call    str_to_int
        mov     ebx, eax

        jmp     mod2


mod2:
        mov     esi, Op
        mov     al, [esi]       ; Obtiene el simbolo
        ;-----------------------------------------
        cmp     al, '+'
        je      Add
        cmp     al, '-'
        je      Sus
        cmp     al, '*'
        je      Mult
        cmp     al, '/'
        je      Div
        call    Quit


mod1:
        call    Add
        call    Sus
        call    Mult
        call    Div
        call    Quit

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

        mov     esi, Op
        mov     al, [esi]
        cmp     al, '+'
        je      Quit
        ret

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

        mov     esi, Op
        mov     al, [esi]
        cmp     al, '-'
        je      Quit
        ret

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

        mov     esi, Op
        mov     al, [esi]
        cmp     al, '*'
        je      Quit
        ret


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

        mov     esi, Op
        mov     al, [esi]
        cmp     al, '/'
        je      Quit
        ret
