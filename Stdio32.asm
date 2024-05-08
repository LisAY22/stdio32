; Autores: Elisa Ajxup, Estuardo Gutierrez, Wilder Menchu

SECTION .data
    msg_not_number      db      "El valor no contiene valores validos para numero", 0H
    msg_suma            db      'Suma: ', 0
    msg_resta           db      'Resta: ', 0
    msg_multi           db      'Multiplicacion: ', 0
    msg_div             db      'Division: ', 0
    msg_residuo         db      ' residuo: ', 0
    msg_res             db      ': ', 0
    flotante            dd      0
    newline             db      10, 0
    resultfile          db      'respuestas.txt', 0
    strCls		        db	    1Bh, '[2J', 1Bh, '[3J', 0
    goto_xy_str	        db	    1Bh, '[12;31H', 0
    msg_n               db      ': ', 0
    msg_op              db      ': ', 0

    


SECTION .bss
    buffer              resb    255
    numb_div_base       resd    1
    Op                  resb    1
    dec_str:            resb    512
    expressions         resb    256
    stack               resd    25
    content             resb    256

    fd_out              resb    1
    fd_in               resb    1
    n1                  resd    1
    n2                  resd    1
    result              resd    1
    isFirst             resb    1
    vP                  resd    1


SECTION .text

;--------- int strLen(cadena)---------
; recibe cadena en eax y devuelve longitud en eax
strLength:
    mov     [esi], ecx        ; Puntero al inicio de la cadena
    xor     ecx, ecx        ; Contador de longitud inicializado a cero

.loop:
    cmp     byte [esi], 0   ; Verificar si se alcanzó el final de la cadena
    je      .done           ; Si es así, salir del bucle
    inc     ecx             ; Incrementar el contador de longitud
    inc     esi             ; Avanzar al siguiente carácter
    jmp     .loop           ; Volver al inicio del bucle

.done:
    mov     eax, ecx        ; Colocar la longitud en eax
    ret

strLen:
	push	ebx
	mov	ebx, eax

sigCaracter:
	cmp	byte [eax], 0
	jz	finstrLen
	inc	eax
	jmp	sigCaracter

finstrLen:
	sub	eax, ebx
	pop	ebx
	ret


; -------strPrint(cadena)-------
; imprime cadena en pantalla, recibe cadena en eax

strPrint:
	push	edx
	push	ecx
	push	ebx
	push	eax

	call	strLen
	mov	edx, eax
	pop	eax
	mov	ecx, eax
	mov	ebx, 1
	mov	eax, 4
	int	80h

	pop	ebx
	pop	ecx
	pop	edx
	ret

;--------strPrintLn---------
; Imprime cadena en pantalla, la cadena se escribe en ax
; agrega salto de linea en la impresion
strPrintLn:
	call	strPrint
	push	eax
	mov	eax, 0Ah		; eax = 0Ah
	push	eax			; colocamos el valor de eax en pila
	mov	eax, esp		; eax apunta a esp (posicion de inicio en pila)
	call	strPrint
	pop	eax
	pop	eax
	ret

;-----------------Lectura del teclado------------------
;---------------strInput(cadena)
; captura el input de cadena del teclado
strInput:
	push	edx
	push	ecx
	push	ebx
	push	eax

        mov	edx, 255	; edx = espacio de memoria para lectura
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

clrscr:
        mov             eax, strCls
        call            strPrintLn
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
        push    edx             ; Guardar edx
        push    ecx             ; Guardar ecx
        push    ebx             ; Guardar ebx
        push    esi             ; Guardar esi

    mov     ebx, 0             ; Acumulador
    mov     esi, eax           ; esi -> *eax, cadena

    .loop:
        movzx   edx, byte[esi]  ; Cargar el siguiente byte de la cadena en edx
        cmp     dl, 0           ; ¿Fin de la cadena?
        je      .done
        cmp     dl, 48          ; ¿Es menor que '0'?
        jl      .invalid
        cmp     dl, 57          ; ¿Es mayor que '9'?
        jg      .invalid

        sub     dl, 48          ; dl -= ASCII('0')
        imul    ebx, 10         ; Multiplicar el acumulador por 10
        add     ebx, edx        ; Sumar el valor numérico al acumulador

        inc     esi             ; Continuar el bucle
        jmp     .loop

    .invalid:
        push    eax
        ; mov     eax, msg_not_number ; Mover la dirección de msg_not_number a eax
        ; call    strPrintLn         ; Llamar a la función println
        pop     eax

    .done:
        mov     eax, ebx        ; Mover el valor en ebx a eax

    .restore:
        pop     esi             ; Restaurar esi
        pop     ebx             ; Restaurar ebx
        pop     ecx             ; Restaurar ecx
        pop     edx             ; Restaurar edx
    ret       


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
        cmp     al, 'x'
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
        
        mov	eax, edx
	call	printIntLn

        pop     ecx
        pop     ebx
        
        mov     esi, Op
        mov     al, [esi]
        cmp     al, '/'
        je      Quit
        ret


int_to_str:
    .backup:
        push    edx             ; Guardar edx
        push    ecx             ; Guardar ecx
        push    ebx             ; Guardar ebx
        push    esi             ; Guardar esi
    .start:
        mov     esi, [buffer]     ; Almacenar valores en el buffer
        xor     ecx, ecx        ; Reiniciar el contador

        .loop:
            cmp     eax, 0      ; ¿Terminaron los números?
            jle     .invert     ; Fin del bucle

            xor     edx, edx    ; Borrar el bit más significativo de la división

            mov     ebx, [numb_div_base] ; Mover la dirección de numb_div_base a ebx
            div     ebx         ; Dividir
            add     dl, 48      ; Sumar 48 a dl
            mov     [esi], dl   ; Almacenar dl en esi
            inc     esi         ; Incrementar esi
            jmp     .loop       ; Continuar bucle

        .invert:
            push    esi
            .calclen:           ; Calcular la longitud de la cadena
                mov     eax, [buffer] ; Mover la dirección de buffer a eax
                call    strLength     ; Llamar a la función strLen
                mov     edi, eax    ; edi = longitud de la cadena

            mov     esi, [buffer]     ; esi -> apunta al principio de la cadena
            lea     edi, [esi+edi-1] ; edi -> apunta al final de la cadena

            .loopi:
                mov     al, [esi]  ; Cargar el primer carácter
                xchg    al, [edi]  ; Intercambiar los primeros y últimos valores
                mov     [esi], al  ; Almacenar el carácter en el último lugar
                inc     esi         ; Incrementar esi
                dec     edi         ; Decrementar edi
                cmp     esi, edi    ; Comparar esi y edi
                jl      .loopi

        .end:
            pop     esi         ; Desapilar esi
            mov     byte[esi], 0H ; La cadena termina en null
            mov     eax, [buffer] ; eax -> buffer

    .restore:
        pop     esi             ; Restaurar esi
        pop     ebx             ; Restaurar ebx
        pop     ecx             ; Restaurar ecx
        pop     edx             ; Restaurar edx
    ret                         ; Retorno


create_file:
    .backup:                ; Respaldo de datos
        push        ebx
        push        ecx
        push        esi
    ; Crear archivo
    mov     ecx, 0755o      ; Permisos RW
    mov     ebx, eax        ; ebx = nombre de archivo
    mov     eax, 8          ; SYS_CREATE
    int     80h             ; Llamada al kernel

    mov esi, eax            ; esi -> descriptor

    mov ebx, esi            ; ebx -> esi
    mov eax, 6              ; SYS_CLOSE
    int 80H                 ; Llamada al kernel

    .restore:               ; Restaurar datos
        pop         ebx
        pop         ecx
        pop         esi

    ret


read_file:
    .backup:
        push    edx
        push    ecx
        push    ebx
        push    edi
        push    esi
        push    eax
    
    ; Abrir archivo
    mov     edi, esi        ; Fin de la pila -> Inicio de la pila

    mov     ecx, 0          ; Marcar como SOLO LECTURA
    mov     ebx, edi        ; ebx -> Fin de la pila
    mov     eax, 5          ; SYS_OPEN
    int     80H

    ; Guardar descriptor en esi
    mov     esi, eax         ; eax -> descriptor

    ; TODO calcular edx dinámicamente
    ; Leer una línea del archivo
    mov     edx, 256         ; Longitud máxima = 256
    pop     eax
    mov     ecx, eax         ; ecx -> Búfer de expresión
    mov     ebx, esi         ; ebx = Ruta de archivo en esi
    mov     eax, 3           ; SYS_READ
    int     80H              ; Llamada al kernel

    ; Cerrar archivo
    mov     ebx, esi         ; ebx = esi
    mov     eax, 6           ; SYS_CLOSE
    int     80H

    .restore:
        pop     esi
        pop     edi
        pop     ebx
        pop     ecx
        pop     edx
    ret

; eax = ruta de archivo -> Devolver eax: descriptor
append_file:
    .backup:
        push    ecx
        push    ebx
    
    mov     ecx, 0777       ; Permiso W
    mov     ebx, eax        ; ebx = Nombre de archivo
    mov     eax, 8          ; SYS_CREATE
    int     80H

    .restore:
        pop     ebx
        pop     ecx
    ret


double2dec:
%define CONTROL_WORD    word [ebp-2]
%define TEN             word [ebp-4]
%define TEMP            word [ebp-4]
%define INTEGER         qword [ebp-12]

    push        ebp
    mov         ebp, esp
    sub         esp, 12

    ; Modificar el modo de redondeo
    fstcw       CONTROL_WORD
    mov ax,     CONTROL_WORD
    or          ah, 0b00001100          ; Establecer RC=11: modo de redondeo truncado
    mov         TEMP, ax
    fldcw       TEMP                    ; Cargar nuevo modo de redondeo

    ; Separar partes entera y fraccionaria y convertir parte entera a ASCII
    fst
    frndint                             ; ST(0) a entero
    fsub        st1, st0                ; Parte integral en ST(0), parte fraccionaria en ST(1)
    call        fpu2bcd2dec
    fabs                                ; Hacer fracción positiva (no garantizado por fsub)

    mov         byte [edi], '.'         ; Punto decimal
    add         edi, 1

    ; Mover 10 a ST(1)
    mov         TEN, 10
    fild        TEN
    fxch

    ; Aislar dígitos de la parte fraccionaria y almacenar ASCII
    .get_fractional:
        fmul        st0, st1                       ; Multiplicar por 10 (desplazar un dígito decimal a la parte entera)
        fist        word TEMP                      ; Almacenar dígito
        fisub       word TEMP                      ; Borrar parte entera
        mov         al, byte TEMP                  ; Cargar dígito
        or          al, 0x30                       ; Convertir dígito a ASCII
        mov         byte [edi], al                 ; Agregarlo a la cadena
        add         edi, 1                         ; Incrementar puntero a la cadena

        fxam                                       ; ST0 == 0.0?
        fstsw       ax
        sahf
        jnz         .get_fractional                ; No: una vez más
        mov         byte [edi], 0                  ; Terminación nula para ASCIIZ

        ; Limpiar la FPU
        ffree       st0                            ; Vaciar ST(0)
        ffree       st1                            ; Vaciar ST(1)
        fldcw       CONTROL_WORD                   ; Restaurar el antiguo modo de redondeo

        leave
    ret                                 ; Retorno: EDI apunta a la terminación nula de la cadena


fpu2bcd2dec:
    push        ebp
    mov         ebp, esp
    sub         esp, 10                 ; 10 bytes para variable tbyte local

    fbstp       [ebp-10]

    mov         ecx, 10                 ; Contador de bucle
    lea         esi, [ebp - 1]          ; bcd + 9 (último byte)
    xor         bl, bl                  ; Verificador de ceros principales

    ; Manejar signo
    btr         word [ebp-2], 15        ; Mover el bit de signo al carry y borrarlo
    jnc         .L1                     ; ¿Negativo?
    mov         byte [edi], '-'         ; Sí: almacenar un carácter de menos
    add         edi, 1

    .L1:
        mov     al, byte [esi]
        mov     ah, al
        shr     ah, 4               ; Aislar el nibble izquierdo
        or      bl, ah              ; Comprobar ceros principales
        jz      .1
        or      ah, 30h             ; Convertir dígito a ASCII
        mov     [edi], ah
        add     edi, 1

        .1:
            and al, 0Fh             ; Aislar el nibble derecho
            or bl, al               ; Comprobar ceros principales
            jz .2
            or al, 30h              ; Convertir dígito a ASCII
            mov [edi], al
            add edi, 1
        .2:
            sub esi, 1
        loop .L1

    test        bl, bl                 ; BL permanece en 0 si todos los dígitos fueron 0
    jnz         .R1                    ; Saltar a la siguiente línea si la parte entera > 0
    mov         byte [edi], '0'
    add         edi, 1

    .R1:
        mov byte [edi], 0           ; Terminación nula para ASCIIZ
        leave
    ret                         ; Retorno: EDI apunta a la terminación nula de la cadena

exec_calc:
    pusha

    mov         esi, expressions            ; leer expresiones ordenadas

    .owhile:                                ; bucle while
        mov         edi, stack              ; edi -> pila de variables
        .iwhile:                            ; bucle while dentro de while
            cmp         byte [esi], 10      ; ASCII(LF) -> final de la línea
            je          .idone
            cmp         byte [esi], 0H      ; ¿nulo?
            je          .odone

            mov         eax, 0H             ; eax = nulo
            mov         ebx, 0H             ; eax = nulo
    .read_num:
        mov         bl, byte [esi]          ; guardar datos en esi en ebx

        ; comprobar si el valor actual es un número
        cmp         bl, '0'                 
        jl          .ioperators             ; < ASCII(0) -> número o inválido
        cmp         bl, '9'                 ; > ASCII(9) -> ignorar valor
        jg          .inext                  ; TODO mostrar error

        sub         ebx, 48                 ; ASCII(número) -> número

        mov         ecx, 10                 ; divisor decimal global
        mul         ecx                     ; eax = eax * ebx
        add         eax, ebx                ; eax = eax + ebx

        cmp         byte [esi+1], '0'       ; comprobar si número
        jl          .save_num               ; guardar número si menor a ASCII(0)

        cmp         byte [esi+1], '9'       ; comprobar si número
        jg          .save_num               ; guardar número si mayor que ASCII(9)

        inc         esi                     ; siguiente argumento
        jmp         .read_num               ; bucle.siguiente

    .save_num:                              ; guardar int.valorDe(ASCII(número))
        mov         dword [flotante], eax    ; guardado temporal del valor en flotante
        ; punto flotante a entero
        fild        dword [flotante]         ; función de la FPU https://github.com/netwide-assembler/nasm
        ; almacenar punto flotante y sacar de la pila
        fstp        dword [edi]             ; guardar flotante y sacar
        add         edi, 4                  ; pila.siguiente
        jmp         .inext                  ; bucle.siguiente

    .ioperators:                            ; comprobar operaciones
        cmp         bl, '+'
        je          .addition
        cmp         bl, '-'
        je          .subtraction
        cmp         bl, '*'
        je          .multiplication
        cmp         bl, '/'
        je          .division
        jmp         .inext                  ; por defecto

    .addition:
        call        op_add
        jmp         .inext
    .subtraction:
        call        op_sub
        jmp         .inext
    .multiplication:
        call        op_mul
        jmp         .inext
    .division:
        call        op_div
        jmp         .inext
    .inext:
        inc         esi
        jmp         .iwhile
    .idone:
        inc         esi
    .odone:
        sub         edi, 4

        pusha

        fld         dword [edi]
        mov         edi, dec_str            ; edi -> cadena decimal
        call        double2dec              ; doble a decimal

        mov         eax,4                   ; función del kernel sys-out
        mov         ebx,1                   ; Salida estándar
        mov         ecx, dec_str            ; Puntero a cadena
        mov         edx, edi                ; EDI apunta a la terminación nula de la cadena
        sub         edx, dec_str            ; Longitud de la cadena
        int         80h                    ; Llamar al kernel

        ; escribir archivo e imprimir salto de línea
        mov         edi, edx
        call        writeFile
        mov         eax, newline
        call        strPrint

        popa


    cmp             byte [esi], 0           ; no más valores en la pila
    jne             .owhile

    popa
    ret

writeFile:
    pusha

    call        save_file_content_c_str ; guardar datos actuales del archivo de resultados
    call        append_file_str         ; actualizar datos del archivo de resultados
    mov         esi, eax                ; esi -> descriptor
    mov         eax, content            ; eax -> contenido del archivo
    call        strLen                  ; eax = longitud de eax
    mov         edx, eax                ; edx -> eax

    mov         eax, 4
    mov         ebx, esi
    mov         ecx, content
    mov         edx, edx
    int         80H

    cmp         edx, 0
    je          skipnewline

    mov         eax, 4
    mov         ebx, esi
    mov         ecx, newline
    mov         edx, 1
    int         80H

skipnewline:

    mov         eax, 4
    mov         ebx, esi
    mov         ecx, dec_str
    mov         edx, edi
    int         80H

    mov         eax, 6
    mov         ebx, esi
    int         80H

    popa
    ret


op_add:
   sub         edi, 8
   fld         dword [edi]
   add         edi, 4
   fld         dword [edi]
   add         edi, 4
   sub         edi, 8
   faddp       st1, st0
   fstp        dword [edi]
   add         edi, 4
   ret
op_sub:
   sub         edi, 8
   fld         dword [edi]
   add         edi, 4
   fld         dword [edi]
   add         edi, 4
   
   sub         edi, 8
   fsubp       st1, st0
   fstp        dword [edi]
   add         edi, 4
   ret
op_mul:
   sub         edi, 8
   fld         dword [edi]
   add         edi, 4
   fld         dword [edi]
   add         edi, 4
   
   sub         edi, 8
   fmulp       st1, st0
   fstp        dword [edi]
   add         edi, 4
   ret
op_div:
   sub         edi, 8
   fld         dword [edi]
   add         edi, 4
   fld         dword [edi]
   add         edi, 4
   
   sub         edi, 8
   fdivp       st1, st0
   fstp        dword [edi]
   add         edi, 4
   ret

; save the content onto file and return descriptor on eax
save_file_content_c_str:
   .backup:
      push     ebx
    ; open the file

    mov     eax, content    ; eax -> content
    mov     ebx, resultfile ; eax -> result file
    call    save_to_content      ; write ebx onto eax file

   .restore:
      pop      ebx
    ret

; create a file and return descriptor on eax
create_file_c_str:
    mov     eax, resultfile
    call    create_file
    ret

; append data and return descriptor on eax
append_file_str:
   mov      eax, resultfile
   call     append_file
   ret

; read the file onto eax and return the data on eax
read_file_c_str:
    pusha

    mov     eax, expressions
    call    read_file

    popa
    ret

save_to_content:
    .backup:
        push    edx
        push    ecx
        push    ebx

    ; open file
    mov         ecx, 0       ; flag READ_ONLY
    mov         ebx, ebx     ; ebx = filename
    mov         eax, 5       ; SYS_OPEN
    int         80H          ; kernel

    mov         esi, eax     ; esi -> descriptor

    ; TODO      calc length
    ; overwrite file
    mov         edx, 256     ; max_lenght to write
    mov         ecx, content ; ecx = content to write
    mov         ebx, esi     ; ebx -> descriptor
    mov         eax, 3       ; SYS_READ
    int         80H          ; kernel

    ; close the file
    mov         ebx, esi     ; ebx -> descriptor
    mov         eax, 6       ; SYS_CLOSE
    int         80H

    .restore:
        pop     ebx
        pop     ecx
        pop     edx
    ret
