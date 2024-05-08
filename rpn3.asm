; Modo 3 RPN


section .data
    msgRespuestas       db      10, 'Contenido en respuestas.txt: ', 0
    listfile            db      'listado.txt', 0

section .bss

section .text
    global   _third_rpn

_third_rpn:
    ; section to get parametres and execute
    pop         eax
    cmp         eax, 2
    jne         configurarArchivo3RPN

    mov         esi, dword [esp + 4]
    jmp         operar3RPN

configurarArchivo3RPN:
    mov         esi, listfile

operar3RPN:
    call        read_file_c_str           

    call        create_file_c_str

    mov         eax, msgRespuestas
    call        strPrintLn

    call        exec_calc

    call        Quit