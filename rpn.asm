; 3 Funcionalidades
; Calculadora Infinita
; n1 n2 operador1 n3 operador2 ...
; Archivos de Texto
; Autores: Elisa Ajxup - Estuardo Gutierrez - Wilder Menchu

%include 'stdio32.asm'
%include 'rpn1.asm'
%include 'rpn2.asm'
%include 'rpn3.asm'


SECTION .text
global _start

_start:
    ; Identificar el número de argumentos
    pop	    ecx			    ; primer valor en pila = Num_Args
    mov     [vP], ecx


    ; Determinar qué operación realizar según el número de argumentos
    cmp     ecx, 1
    je      execute_first_rpn

    cmp     ecx, 3
    je      execute_third_rpn

    pop     eax
    jmp     _second_rpn
    jmp     quit

execute_first_rpn:
    ; Ejecutar la primera RPN
    call    _first_rpn
    jmp     quit

execute_third_rpn:
    ; Ejecutar la tercera RPN
    call    _third_rpn
    jmp     quit
    
quit:
    ; Salir del programa
    call    Quit
