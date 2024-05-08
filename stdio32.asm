; Bloque de funciones para entrada y salida estandar
; Autor: lis
; Fecha: 20240308

SECTION .data
    msg_not_number      db      "El valor no contiene valores validos para numero", 0H
    clear_str           db      1Bh, '[2J', 1Bh, '[3J', 0h
    goto_xy_str     	db      1Bh, '[01;01H', 0h

;--------- int strLen(cadena)---------
; recibe cadena en eax y devuelve longitud en eax




strLen:
	push    ebx             ; Save ebx value on the stack
    mov     ebx, eax        ; ebx = eax | ebx = memory address of eax

    .next_char:
        cmp     byte[eax], 0        ; Is msg[eax] == 0?
        jz      .next_char_end      ; GOTO .next_char_end when there are no more characters
        inc     eax                 ; Increment eax for loop
        jmp     .next_char          ; Continue loop

    .next_char_end:
        sub     eax, ebx                ; Length of the string = eax - ebx
        pop     ebx                     ; Restore ebx value
        ret


; -------strPrint(cadena)-------
; imprime cadena en pantalla, recibe cadena en eax

strPrint:
	; Register values backup
    push    eax             ; Restore value at the end
    push    edx
    push    ecx
    push    ebx
    push    eax             ; strLen modifies eax

    call    strLen          ; Calculate the length of the string
    mov     edx, eax        ; edx = eax, eax currently holds the length
    pop     eax             ; Restore the value to be printed

    mov     ecx, eax        ; ecx -> points to eax's memory address
    mov     ebx, 1          ; 1 = STDOUT
    mov     eax, 4          ; SYS_WRITE
    int     80h             ; System call

    ; Restore values
    pop     ebx
    pop     ecx
    pop     edx
    pop     eax             ; Restore the value
    ret

;--------strPrintLn---------
; Imprime cadena en pantalla, la cadena se escribe en ax
; agrega salto de linea en la impresion
strPrintLn:
	call	strPrint

	push	eax
	mov	    eax, 0Ah		; eax = 0Ah
	push	eax			; colocamos el valor de eax en pila
	mov	    eax, esp		; eax apunta a esp (posicion de inicio en pila)
	call	strPrint
    pop	    eax
	pop	    eax
	ret

; Rutina para leer una cadena de entrada desde la consola y almacenarla en un búfer
; Entradas:
; bx: Puntero al búfer donde se almacenará la entrada
strInput:
    push	edx
	push	ecx
	push	ebx
	push	eax

    mov	edx, 255		; edx = espacio de memoria para lectura
	mov	ecx, ebx	; ecx = direccion de memoria para almacenar
	mov	ebx, 0		; leer desde STDIN (teclado)
	mov	eax, 3		; servicio SYS_READ (sistema de lectura)
	int	80h

	pop	eax
	pop	ebx
	pop	ecx
	pop	edx
	ret

upCase:

        UCCicle:
                mov     al, [esi]
                cmp     al, 0
                je      finStr
                cmp     al, 'a'
                jl      noMinus

                cmp     al, 'z'
                jg      noMinus

                jmp     Minus
	noMinus:
                mov     [edi], al
                inc     edi
                jmp     nextUCh

        Minus:
                sub     al, 32
                mov     [edi], al
                inc     edi
        nextUCh:
                inc     esi
                jmp     UCCicle

lowCase:

        LCCicle:
                mov     al, [esi]
                cmp     al, 0
                je      finStr
                cmp     al, 'A'
                jl      noMayus
                cmp     al, 'Z'
                jg      noMayus
                jmp     Mayus

        noMayus:
                mov     [edi], al
                inc     edi
                jmp     nextLCh
        Mayus:
                add     al, 32
                mov     [edi], al
                inc     edi

        nextLCh:
                inc     esi
                jmp     LCCicle


finStr:
        ret


strInvert:

        invertCicle:
                mov     al, [esi]
                cmp     al, 0
                je      finStr
                mov     [edi], al
                inc     esi
                dec     edi
                loop    invertCicle

Quit:
	mov	ebx, 0
	mov	eax, 1
	int	80h
	ret



printIntLn:
    call        printInt     ; imprimimos el numero
    ; imprimimos el salto de linea
    push        eax

    mov         eax, 0Ah    ;
    push        eax
    mov         eax, esp
    call        strPrint
    pop         eax

    pop         eax
    ret                     ; regresamos a la funcion origen

; imprime un numero entero que este en eax
printInt:
    ; backup de los registros
    push        eax
    push        ecx
    push        edx
    push        esi

    mov         ecx, 0      ; iniciamos el contador en 0
    .div_loop:
        inc         ecx         ; conteo de digitos
        mov         edx, 0      ; limpiar hsb de la division
        mov         esi, 10     ; esi [divisor] = 10
        idiv        esi         ; <edx:eax>/ esi
        add         edx, 48     ; + 0 int incial
        push        edx         ; residuo -> stack
        cmp         eax, 0
        jnz         .div_loop

    ; fin .div_loop
    .print_loop:
        dec         ecx         ; decrementamos en la pila
        mov         eax, esp    ;
        call        strPrint
        pop         eax         ; residuo ecx = eax
        cmp         ecx, 0      ; aun hay datos
        jnz         .print_loop ; saltamos

    ; restauramos valores
    pop         esi
    pop         edx
    pop         ecx
    pop         eax         ;
    ret


str_to_int:
    .backup:
        push    edx             ; Save edx
        push    ecx             ; Save ecx
        push    ebx             ; Save ebx
        push    esi             ; Save esi

    mov     ebx, 0             ; Accumulator
    mov     esi, eax           ; esi -> *eax, string

    .loop:
        movzx   edx, byte[esi]  ; Load the next byte of the string into edx
        cmp     dl, 0           ; End of string?
        je      .done
        cmp     dl, 48          ; Is it less than '0'?
        jl      .invalid
        cmp     dl, 57          ; Is it greater than '9'?
        jg      .invalid

        sub     dl, 48          ; dl -= ASCII('0')
        imul    ebx, 10         ; Multiply the accumulator by 10
        add     ebx, edx        ; Add the numeric value to the accumulator

        inc     esi             ; Continue the loop
        jmp     .loop

    .invalid:
        push    eax
        mov     eax, msg_not_number ; Move the address of msg_not_number into eax
        call    strPrintLn         ; Call the println function
        pop     eax
        xor     dl, dl

    .done:
        mov     eax, ebx        ; Move the value in ebx to eax

    .restore:
        pop     esi             ; Restore esi
        pop     ebx             ; Restore ebx
        pop     ecx             ; Restore ecx
        pop     edx             ; Restore edx
    ret

clrscr:
        mov             eax, clear_str
        call            strPrint
        ret

gotoxy:
        mov             eax, goto_xy_str
        mov             ebx, eax
    .goto_xy_loop:
        cmp             byte [ebx], 0       ; revisamos si es null
        jz              .goto_xy_loop_end
        cmp             byte [ebx], '['
        je              .goto_xy_set_x
        cmp             byte [ebx], ';'
        je              .goto_xy_set_y
        inc             ebx
        jmp             .goto_xy_loop
    .goto_xy_set_y:
        add             ebx, 2
        mov             byte [ebx], dl
        jmp             .goto_xy_loop
    .goto_xy_set_x:
        add             ebx, 2
        mov             byte [ebx], dh
        jmp             .goto_xy_loop
    .goto_xy_loop_end:
        call            strPrint
        int             80h
        ret
