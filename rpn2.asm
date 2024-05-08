; Modo 2 RPN



SECTION .text
global _second_rpn

_second_rpn:
    ; pop	    ecx			    ; primer valor en pila = Num_Args
    ; mov     [vP], ecx

    ; Obtener el nombre del archivo
    ; pop     eax
  
    ; Obtener el primer argumento de la línea de comandos
    pop     eax
    call    str_to_int
    mov     ecx, eax

    mov     [n1], ecx

    mov     edx, [vP]
    dec	    edx
    dec	    edx
    mov     [vP], edx


cicloExtraer2RPN:
    mov     ecx, [n1]
    mov     edx, [vP]
	cmp	    edx, 0h			; si(ecx ==0)
	jz	    noMasArg2RPN		; entonces salta a noMasArg

    pop	    eax				; sino extrae el siguiente argumento en pila
    
    call    str_to_int
    mov     ebx, eax
    dec     edx
    dec	    edx
    mov     [vP], edx
    

    pop     eax
    mov     ecx, [n1]

    jmp     operar2RPN

	jmp	    cicloExtraer2RPN

noMasArg2RPN:
    mov     eax, msg_res
    call    strPrint

    mov     eax, ecx
    call    printIntLn

	call	Quit

operar2RPN:
    ;mov     [Op], eax
    ;mov     esi, [Op]
    ;mov     al, [esi]       ; Obtiene el símbolo
    ;-----------------------------------------
    cmp     byte[eax], '+'
    je      Add_2RPN
    cmp     byte[eax], '-'
    je      Sus_2RPN
    cmp     byte[eax], 'x'
    je      Mult_2RPN
    cmp     byte[eax], '/'
    je      Div_2RPN
    jmp     cicloExtraer2RPN       ; Volver a solicitar entrada si no se reconoce el operador


Add_2RPN:
    push    ebx
    push    ecx


    add     ecx, ebx

    mov     [n1], ecx

    pop     ecx
    pop     ebx

    jmp     cicloExtraer2RPN      ; Volver a solicitar entrada


Sus_2RPN:
    push    ebx
    push    ecx

    sub     ecx, ebx

    mov     [n1], ecx

    pop     ecx
    pop     ebx

    jmp     cicloExtraer2RPN  

Mult_2RPN:
    push    ebx
    push    ecx

    imul     ecx, ebx

    mov     [n1], ecx

    pop     ecx
    pop     ebx

    jmp     cicloExtraer2RPN

Div_2RPN:
    push    ebx
    push    ecx
    push    edx
    
    mov     edx, 0
    mov     eax, ecx
    mov     esi, ebx
    div     esi            ;eax = eax/registro entera   ebx = sobrante
    
    mov     [n1], eax

    pop     edx
    pop     ecx
    pop     ebx

    jmp     cicloExtraer2RPN
