; Modo 1 RPN


SECTION .text
global _first_rpn

_first_rpn:
    mov     byte [isFirst], 1  ; Indica que aún no se ha ingresado el primer número

input_loop1RPN:
    ; Solicitar el primer número si es la primera iteración
    cmp     byte [isFirst], 1
    je      get_first_number1RPN

    mov     ecx, [n1]

    ; Solicitar el siguiente número
    mov     eax, msg_n
    call    strPrint
    mov     ebx, n2
    call    strInput

    ; Solicitar el operador
    mov     eax, msg_op
    call    strPrint
    mov     ebx, Op
    call    strInput

    ; Comprobar si se debe salir
    mov     esi, Op
    mov     al, [esi]
    cmp     al, 'q'
    je      quit1RPN

    ; Convertir el segundo número a entero
    mov     eax, n2
    call    str_to_int
    mov     ebx, eax

    ; Realizar la operación correspondiente
    jmp     operar1RPN

get_first_number1RPN:
    mov     byte [isFirst], 0  ; Indica que se ha ingresado el primer número

    ; Solicitar el primer número
    mov     eax, msg_n
    call    strPrint
    mov     ebx, n1
    call    strInput

    ; Convertir el primer número a entero
    mov     eax, n1
    call    str_to_int
    mov     ecx, eax

    mov     [n1], ecx


operar1RPN:
    mov     esi, Op
    mov     al, [esi]       ; Obtiene el símbolo
    ;-----------------------------------------
    cmp     al, '+'
    je      Add_1RPN
    cmp     al, '-'
    je      Sus_1RPN
    cmp     al, 'x'
    je      Mult_1RPN
    cmp     al, '/'
    je      Div_1RPN
    jmp     input_loop1RPN       ; Volver a solicitar entrada si no se reconoce el operador

Add_1RPN:
    push    ebx
    push    ecx

    mov     eax, msg_res
    call    strPrint

    add     ecx, ebx

    mov     eax, ecx
    call    printIntLn

    mov     [n1], ecx

    pop     ecx
    pop     ebx

    jmp     input_loop1RPN       ; Volver a solicitar entrada


Sus_1RPN:
    push    ebx
    push    ecx

    mov     eax, msg_res
    call    strPrint

    sub     ecx, ebx

    mov     eax, ecx
    call    printIntLn

    mov     [n1], ecx

    pop     ecx
    pop     ebx

    jmp     input_loop1RPN  

Mult_1RPN:
    push    ebx
    push    ecx

    mov     eax, msg_res
    call    strPrint

    imul     ecx, ebx

    mov     eax, ecx
    call    printIntLn

    mov     [n1], ecx

    pop     ecx
    pop     ebx

    jmp     input_loop1RPN 

Div_1RPN:
        push    ebx
        push    ecx

        mov     eax, msg_res     
        call    strPrint

        mov     eax, ecx
        mov     esi, ebx
        div     esi            ;eax = eax/registro entera   ebx = sobrante
        call    printIntLn

        mov     [n1], eax

        pop     ecx
        pop     ebx

        jmp     input_loop1RPN 

quit1RPN:
    ; Salir del programa
    call    Quit