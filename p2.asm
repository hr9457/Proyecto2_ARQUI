                                                               ; ----------- macro para limpiar la pantalla 
LIMPIAR_PANTALLA macro
	mov ah,00h
	mov al,03h
	int 10h
endm
; - - - - - - - - - - - - - -- - - - - - - - - - - - - - - - - - - - - - - - -




; -------- macro para poner una espera en pantalla
PAUSA_PANTALLA macro
    mov ah,08
	int 21h
endm
; - - - - - - - - - - - - - -- - - - - - - - - - - - - - - - - - - - - - - - -




;---------- macro para imprimir un caracter 
PRINT macro cadena
    mov ah,09h
    lea dx,cadena
    int 21h 
endm
; - - - - - - - - - - - - - -- - - - - - - - - - - - - - - - - - - - - - - - -
        
        
        
;-------------- macro para impresion de caracteres por pantalla
PRINT_CARACTER macro caracter
    mov ah,02h 
    mov dl,caracter               
    int 21h
endm  
; - - - - - - - - - - - - - -- - - - - - - - - - - - - - - - - - - - - - - - -  


;-------------- macro para comparar con los comandos validos en el programa
SWITCH_CASE_CADENAS macro 
    
    local diferentes
    
    
    mov si,0
    mov di,0 

    ;push ES
    mov ax,ds
    mov ES,ax 
    
    
    ; -> comparacion con el token cprom
    mov cx,5 
    lea si,comando_entrada
    lea di,tk_cprom
    repe cmpsb
    je comando_cprom
    ;pop ES
    
    
    ; -> comparacion con el token cmediana 
    mov cx,8 
    lea si,comando_entrada
    lea di,tk_cmediana
    repe cmpsb
    je comando_cmediana
    ;pop ES
    
    
    ; -> comparacion con el token cmoda
    mov cx,5
    lea si,comando_entrada
    lea di,tk_cmoda
    repe cmpsb
    je comando_cmoda
    ;pop ES
    
    ; -> comparacion con el token cmax
    mov cx,4
    lea si,comando_entrada
    lea di,tk_cmax
    repe cmpsb
    je comando_cmax
    ;pop ES
    
    ; -> comparacion con el token cmin
    mov cx,4  
    lea si,comando_entrada
    lea di,tk_cmin
    repe cmpsb
    je comando_cmin
    ;pop ES
    
    ; -> comparacion con el token gbarra_asc 
    mov cx,10
    lea si,comando_entrada
    lea di,tk_gbarra_asc 
    repe cmpsb
    je comando_gbarra_asc
    ;pop ES
                                            
    ; -> comparacion con el token gbarra_desc
    mov cx,11 
    lea si,comando_entrada
    lea di,tk_gbarra_desc 
    repe cmpsb
    je comando_gbarra_desc
    ;pop ES 
          
          
    ; -> comparacion con el token ghist
    mov cx,5
    lea si,comando_entrada
    lea di,tk_ghist
    repe cmpsb
    je comando_ghist
    ;pop ES      
          
    ; -> comparacion con el token glinea
    mov cx,6 
    lea si,comando_entrada
    lea di,tk_glinea
    repe cmpsb
    je comando_glinea
    ;pop ES 
    
    ; -> comparacion con el token limpiar
    mov cx,7 
    lea si,comando_entrada
    lea di,tk_limpiar 
    repe cmpsb
    je comando_limpiar
    ;pop ES
    
    ; -> comparacion con el token reporte
    mov cx,7 
    lea si,comando_entrada
    lea di,tk_reporte 
    repe cmpsb
    je comando_reporte
    ;pop ES
    
    ; -> comparacion con el token info
    mov cx,4 
    lea si,comando_entrada
    lea di,tk_info
    repe cmpsb 
    je comando_informacion
    ;pop ES      


    ; -> comparacion con el token de lectura del archivo
    mov cx,6
    lea si,comando_entrada
    lea di,tk_abrir
    repe cmpsb
    je comando_abrir

    
    ; -> comparacion con el token salir
    mov cx,5 
    lea si,comando_entrada
    lea di,tk_salir
    repe cmpsb
    ;jne diferente
    je salir
    ;pop ES     
    
    
    diferentes:
        PRINT msg_diferentes
        jmp ingreso_comando
    
endm
; - - - - - - - - - - - - - -- - - - - - - - - - - - - - - - - - - - - - - - - 


; =============== macro para obtner un caracter de un vector
GET_CARACTER_VECTOR macro vector,posicion,variable

    mov bx,0
    mov bl,posicion
    mov si,bx
    mov bl,vector[si] 
    mov variable,bl
    
endm  
; - - - - - - - - - - - - - -- - - - - - - - - - - - - - - - - - - - - - - - -



; =============== macro enviar a un vector la ruta del archivo
SET_CARACTER_VECTOR macro vector,posicion,caracter_ruta

    mov bx,0
    mov bl,posicion
    mov si,bx
    mov bl,caracter_ruta
    mov vector[si],bl

endm
; - - - - - - - - - - - - - -- - - - - - - - - - - - - - - - - - - - - - - - - 




; =============== macro para imprimir un numero de 16 bits
PRINT_NUMBER16 macro numero
    
    mov ah,02h
    mov dx,numero
    add dx,30h
    int 21h
    
endm
; - - - - - - - - - - - - - -- - - - - - - - - - - - - - - - - - - - - - - - - 


; =============== macro para imprimir un numero dw
PRINTNUMEROS MACRO numero 
    
    local lRes, eFinCalcN, impRes,eFinPNum,eFinPNum2
    
    mov ax,0
    mov dx,0
    mov cx,0
    mov dx,0

 ; Ciclo que nos sirve para poder separar el resultado en valores individuales 

    MOV AX, numero
    MOV numero_aux_entrada, AX  ; numero que ingreso  
    MOV cantidad_numero_en_pila, 0  ; Contador auxiliar que nos servira m??s adelante para sacar los valores de la pila 
    
    lRes:
        CMP AX, 0
        JE efinCalcN ; al cumplirse la condicion salimos del ciclo
        
        ; Dividimos entre 10
        MOV AX, numero_aux_entrada
        MOV resultado_division, 10D
        CWD
        DIV resultado_division

        PUSH DX ; Agregamos el residuo
        MOV numero_aux_entrada, AX ; Asignamos el cociente que nos servira en la proxima iteraci??n
        INC cantidad_numero_en_pila ; Incrementamos en 1 que luego nos servira para sacar los valores de la pila
        ;PAUSA
    JMP lRes    
    
    eFinCalcN:    
    ; Ciclo para imprimir el resultado de la operaci??n
    MOV CX, cantidad_numero_en_pila
    CMP CX, 0D
    JE eFinPnum2
           
    impRes:
        POP DX
        PRINT_NUMBER16 DX
        CMP CX, 0D
        JE eFinPNum
    loop impRes
    
    CMP CX, 0D
    JE eFinPNum
    
    eFinPNum2:
    PRINT_NUMBER16 0D
    
    
    eFinPNum: 
    
ENDM     
; - - - - - - - - - - - - - -- - - - - - - - - - - - - - - - - - - - - - - - - 



; =============== macro para recorrer el vector
IMPRIMIRVECTOR MACRO vector, size_vector
    local ImpV, finImp
    
    MOV contImpVector, 0  
    ImpV:
        mov cx,0 ; limpieza del cx
        mov cx, size_vector ; Asignamos el tamanio del vector a cl
        CMP contImpVector, CX
        JGE finImp
        ;MOV SI, contImpVector
        MOV auxRegAX, ax
        MOV auxRegCX, CX
        MOV AX, contImpVector
        MOV CX, 2
        MUL CX
        MOV SI, AX
        MOV AX, auxRegAX
        MOV CX, auxRegCX
        PRINTNUMEROS vector[si] 
        
        PRINT_CARACTER '-' 
        
        inc contImpVector
    jmp ImpV
    finImp:
ENDM
; - - - - - - - - - - - - - -- - - - - - - - - - - - - - - - - - - - - - - - - 


; =============== macro obtener un valor en cierta posicion del vector
GET_NUMBER_BINARY macro vector,posicion,variable

    mov bx,0
    mov ax,0
    mov ax,posicion
    mov cx,2
    mul cx
    mov si,ax
    mov bx,vector[si]
    mov variable,bx
    
endm  
; - - - - - - - - - - - - - -- - - - - - - - - - - - - - - - - - - - - - - - -  


  
; =============== macro enviar un numero en cierta posicion del vector
SET_VECTOR_BINARY macro vector,posicion,variable
    
    ;mov respaldo_registro_ax,ax
    mov ax,0
    mov cx,0
    mov ax,posicion
    mov cx,2
    mul cx
    mov si,ax
    mov ax,variable
    mov vector[si],ax  
    
endm
; - - - - - - - - - - - - - -- - - - - - - - - - - - - - - - - - - - - - - - - 



; =============== macro para ordenar el vector forma ascendente
ORDENAMIENTO_BURBUJA_ASC macro vector,size_vector
    
   local for_burbuja,for_burbuja_j,intercambio,fin_burbuja_j,fin_burbuja

    ;-------------- limpieza y copia de variables
    mov i,0d
    mov j,0d
    mov temporal,0d
    mov valor_en_posicion_j,0d   
    mov valor_en_posicion_j_masUno,0d
    mov volor_en_posicion_i, 0d 
    mov siguiente_j,1d

    mov ax,0
    mov ax,size_vector 
    mov size_copia2,ax
    dec size_copia2
    mov cx,0
    mov dx,0 
    mov bx,0
    mov ax,0
    mov cx,size_vector
    mov dx,size_copia2
    
    
    
    for_burbuja:
            
            ;-- condicion de salida
            ;-- salta si i es mayor a dx
            mov cx,size_vector
            cmp i,cx
            jnle fin_burbuja              
            
            ;---- for interno
            for_burbuja_j:
                
                ;---- condicion de salida
                mov dx,size_copia2  
                cmp j,dx
                jnl fin_burbuja_j
                
                
                ;--- if vector[j] > vector[j+1] 
                GET_NUMBER_BINARY vector_entrada,j,valor_en_posicion_j
                GET_NUMBER_BINARY vector_entrada,siguiente_j,valor_en_posicion_j_masUno 
                
                
                mov ax,valor_en_posicion_j
                mov bx,valor_en_posicion_j_masUno
                
                ;--- si el numero vector[j] > a vector[j+1]
                cmp valor_en_posicion_j,bx
                jg  intercambio  
                
                
                ;--- regresa 
                inc j
                inc siguiente_j
                jmp for_burbuja_j
                
                
                ;-- intercambio de posiciones
                intercambio:
                    
                    ;--- temporal = vector[j]
                    GET_NUMBER_BINARY vector_entrada,j,temporal
                    
                    ;--- vector[j] = vector[j+1] 
                    SET_VECTOR_BINARY vector_entrada,j,valor_en_posicion_j_masUno
                    
                    
                    ;--- vector[j+1] = temporal 
                    SET_VECTOR_BINARY vector_entrada,siguiente_j,temporal
                
                    
                    ;--- regresa 
                    inc j ;j++
                    inc siguiente_j ;j+1 ++
                    jmp for_burbuja_j               
                
                
                
            fin_burbuja_j:
                inc i ;i++
                mov j,0d 
                mov siguiente_j,1d
                mov temporal,0
                mov valor_en_posicion_j_masUno,0
                mov valor_en_posicion_j,0   
                jmp for_burbuja        
        
            
            
        ;-> fin del ciclo burbuja   
        fin_burbuja:
    

endm
; - - - - - - - - - - - - - -- - - - - - - - - - - - - - - - - - - - - - - - - 




; =============== macro para ordenar el vector de forma descendte
ORDENAMIENTO_BURBUJA_DES macro vector,size_vector
    
   local for_burbuja_des,intercambio_des,for_burbuja_j_des,fin_burbuja_j_des,fin_burbuja_des

    ;-------------- limpieza y copia de variables
    mov i,0d
    mov j,0d
    mov temporal,0d
    mov valor_en_posicion_j,0d   
    mov valor_en_posicion_j_masUno,0d
    mov volor_en_posicion_i, 0d 
    mov siguiente_j,1d

    mov ax,0
    mov ax,size_vector 
    mov size_copia2,ax
    dec size_copia2
    mov cx,0
    mov dx,0 
    mov bx,0
    mov ax,0
    mov cx,size_vector
    mov dx,size_copia2
    
    
    
    for_burbuja_des:
            
            ;-- condicion de salida
            ;-- salta si i es mayor a dx
            mov cx,size_vector
            cmp i,cx
            jnle fin_burbuja_des              
            
            ;---- for interno
            for_burbuja_j_des:
                
                ;---- condicion de salida
                mov dx,size_copia2  
                cmp j,dx
                jnl fin_burbuja_j_des
                
                
                ;--- if vector[j] > vector[j+1] 
                GET_NUMBER_BINARY vector_entrada,j,valor_en_posicion_j
                GET_NUMBER_BINARY vector_entrada,siguiente_j,valor_en_posicion_j_masUno 
                
                
                mov ax,valor_en_posicion_j
                mov bx,valor_en_posicion_j_masUno
                
                ;--- si el numero vector[j] < a vector[j+1]
                cmp valor_en_posicion_j,bx
                jng  intercambio_des  
                
                
                ;--- regresa 
                inc j
                inc siguiente_j
                jmp for_burbuja_j_des
                
                
                ;-- intercambio de posiciones
                intercambio_des:
                    
                    ;--- temporal = vector[j]
                    GET_NUMBER_BINARY vector_entrada,j,temporal
                    
                    ;--- vector[j] = vector[j+1] 
                    SET_VECTOR_BINARY vector_entrada,j,valor_en_posicion_j_masUno
                    
                    
                    ;--- vector[j+1] = temporal 
                    SET_VECTOR_BINARY vector_entrada,siguiente_j,temporal
                
                    
                    ;--- regresa 
                    inc j ;j++
                    inc siguiente_j ;j+1 ++
                    jmp for_burbuja_j_des               
                
                
                
            fin_burbuja_j_des:
                inc i ;i++
                mov j,0d 
                mov siguiente_j,1d
                mov temporal,0
                mov valor_en_posicion_j_masUno,0
                mov valor_en_posicion_j,0   
                jmp for_burbuja_des        
        
            
            
        ;-> fin del ciclo burbuja   
        fin_burbuja_des:
    

endm
; - - - - - - - - - - - - - -- - - - - - - - - - - - - - - - - - - - - - - - - 




; ========== macro para convertir un numero binario a ASCII
NUMBER_BINARY_ASCII macro numero

    local DOWHILE,ESCRIBIR_ASCII,FIN_ESCRIBIR_ASCII

    ;-> limpieza 
    ;-> limpieza 
        mov contador_de_decimales,0D
        mov dx,0d
        mov ax,0d
    
        mov ax,numero 
        
    
        DOWHILE:
            
            mov dx,0D
            mov cx,10D
            div cx
    
            ;-> empuje a la pila y aumento numeros en pila
            push dx
            inc contador_de_decimales
    
            ;-> comparamos el resultado del cociente
            cmp ax,0
            jnle DOWHILE 
            
    
    
        ;-> sacado de la pila 
        mov ax,0          
        
    
        ESCRIBIR_ASCII:
    
            ;-> condicion de salida
            ;-> salta si el contador es igual a 0
            cmp contador_de_decimales,0
            je FIN_ESCRIBIR_ASCII
    
    
            pop dx
            mov numero_en_pila,dx 
            ;add numero_en_pila,30h
            dec contador_de_decimales
    
            ;-> se escribe en el archivo
            ;WRITE_IN_FILE numero_en_pila,1d 
            PRINT_NUMBER16 numero_en_pila
            
    
            ;-> repite el ciclo 
            jmp ESCRIBIR_ASCII
    
    
        FIN_ESCRIBIR_ASCII:



endm
; - - - - - - - - - - - - - -- - - - - - - - - - - - - - - - - - - - - - - - -  






; =============== macro para ordenar la frecuencia  descendentemente
FRECUENCIA_DES macro vector_frecuencia,vector_valor,size_vector
    
   local for_frecuencia_des,intercambio_frecuencia_des,for_frecuencia_j_des,fin_fre_j_des,fin_frecuencia_des

    ;-------------- limpieza y copia de variables
    mov i,0d
    mov j,0d
    mov temporal,0d
    mov valor_en_posicion_j,0d   
    mov valor_en_posicion_j_masUno,0d
    mov volor_en_posicion_i, 0d 
    mov siguiente_j,1d

    mov ax,0
    mov ax,size_vector 
    mov size_copia2,ax
    dec size_copia2
    mov cx,0
    mov dx,0 
    mov bx,0
    mov ax,0
    mov cx,size_vector
    mov dx,size_copia2
    
    
    
    for_frecuencia_des:
            
            ;-- condicion de salida
            ;-- salta si i es mayor a dx
            mov cx,size_vector
            cmp i,cx
            jnle fin_frecuencia_des              
            
            ;---- for interno
            for_frecuencia_j_des:
                
                ;---- condicion de salida
                mov dx,size_copia2  
                cmp j,dx
                jnl fin_fre_j_des
                
                
                ;--- if vector[j] > vector[j+1] 
                GET_NUMBER_BINARY vector_frecuencia,j,valor_en_posicion_j
                GET_NUMBER_BINARY vector_frecuencia,siguiente_j,valor_en_posicion_j_masUno 

                ;-----valor de referencia de la frecuenca de j+1
                GET_NUMBER_BINARY vector_valor,siguiente_j,numero_en_posicion_j_masUno
                
                
                mov ax,valor_en_posicion_j
                mov bx,valor_en_posicion_j_masUno
                
                ;--- si el numero vector[j] < a vector[j+1]
                cmp valor_en_posicion_j,bx
                jng  intercambio_frecuencia_des  
                
                
                ;--- regresa 
                inc j
                inc siguiente_j
                jmp for_frecuencia_j_des
                
                
                ;-- intercambio de posiciones relativos en la frecuencia
                intercambio_frecuencia_des:
                    
                    ;---- INTERCAMBIA EL VALOR DE FRECUENCIAS
                    ;--- temporal = vector[j]
                    GET_NUMBER_BINARY vector_frecuencia,j,temporal
                    
                    ;--- vector[j] = vector[j+1] 
                    SET_VECTOR_BINARY vector_frecuencia,j,valor_en_posicion_j_masUno                    
                    
                    ;--- vector[j+1] = temporal 
                    SET_VECTOR_BINARY vector_frecuencia,siguiente_j,temporal


                    ;----- INTERCAMBIA EL VALOR DE REFERENCIA DE ESA FRECUENCIA
                    ;--- temporal = vector[j]
                    GET_NUMBER_BINARY vector_valor,j,temporal

                    ; ;--- vector[j] = vector[j+1] 
                    SET_VECTOR_BINARY vector_valor,j,numero_en_posicion_j_masUno  

                    ; ;--- vector[j+1] = temporal 
                    SET_VECTOR_BINARY vector_valor,siguiente_j,temporal


                
                    
                    ;--- regresa 
                    inc j ;j++
                    inc siguiente_j ;j+1 ++
                    jmp for_frecuencia_j_des               
                
                
                
            fin_fre_j_des:
                inc i ;i++
                mov j,0d 
                mov siguiente_j,1d
                mov temporal,0
                mov valor_en_posicion_j_masUno,0
                mov valor_en_posicion_j,0   
                jmp for_frecuencia_des        
        
            
            
        ;-> fin del ciclo burbuja   
        fin_frecuencia_des:
    

endm
; - - - - - - - - - - - - - -- - - - - - - - - - - - - - - - - - - - - - - - - 




; =============== macro para ordenar la frecuencia  descendentemente
FRECUENCIA_ASC macro vector_frecuencia,vector_valor,size_vector
    
   local for_frecuencia_asc, intercambio_frecuencia_asc, for_frecuencia_j_asc, fin_fre_j_asc, fin_frecuencia_asc

    ;-------------- limpieza y copia de variables
    mov i,0d
    mov j,0d
    mov temporal,0d
    mov valor_en_posicion_j,0d   
    mov valor_en_posicion_j_masUno,0d
    mov volor_en_posicion_i, 0d 
    mov siguiente_j,1d

    mov ax,0
    mov ax,size_vector 
    mov size_copia2,ax
    dec size_copia2
    mov cx,0
    mov dx,0 
    mov bx,0
    mov ax,0
    mov cx,size_vector
    mov dx,size_copia2
    
    
    
    for_frecuencia_asc:
            
            ;-- condicion de salida
            ;-- salta si i es mayor a dx
            mov cx,size_vector
            cmp i,cx
            jnle fin_frecuencia_asc              
            
            ;---- for interno
            for_frecuencia_j_asc:
                
                ;---- condicion de salida
                mov dx,size_copia2  
                cmp j,dx
                jnl fin_fre_j_asc
                
                
                ;--- if vector[j] > vector[j+1] 
                GET_NUMBER_BINARY vector_frecuencia,j,valor_en_posicion_j
                GET_NUMBER_BINARY vector_frecuencia,siguiente_j,valor_en_posicion_j_masUno 

                ;-----valor de referencia de la frecuenca de j+1
                GET_NUMBER_BINARY vector_valor,siguiente_j,numero_en_posicion_j_masUno
                
                
                mov ax,valor_en_posicion_j
                mov bx,valor_en_posicion_j_masUno
                
                ;--- si el numero vector[j] < a vector[j+1]
                cmp valor_en_posicion_j,bx
                jg  intercambio_frecuencia_asc  
                
                
                ;--- regresa 
                inc j
                inc siguiente_j
                jmp for_frecuencia_j_asc
                
                
                ;-- intercambio de posiciones relativos en la frecuencia
                intercambio_frecuencia_asc:
                    
                    ;---- INTERCAMBIA EL VALOR DE FRECUENCIAS
                    ;--- temporal = vector[j]
                    GET_NUMBER_BINARY vector_frecuencia,j,temporal
                    
                    ;--- vector[j] = vector[j+1] 
                    SET_VECTOR_BINARY vector_frecuencia,j,valor_en_posicion_j_masUno                    
                    
                    ;--- vector[j+1] = temporal 
                    SET_VECTOR_BINARY vector_frecuencia,siguiente_j,temporal


                    ;----- INTERCAMBIA EL VALOR DE REFERENCIA DE ESA FRECUENCIA
                    ;--- temporal = vector[j]
                    GET_NUMBER_BINARY vector_valor,j,temporal

                    ; ;--- vector[j] = vector[j+1] 
                    SET_VECTOR_BINARY vector_valor,j,numero_en_posicion_j_masUno  

                    ; ;--- vector[j+1] = temporal 
                    SET_VECTOR_BINARY vector_valor,siguiente_j,temporal


                
                    
                    ;--- regresa 
                    inc j ;j++
                    inc siguiente_j ;j+1 ++
                    jmp for_frecuencia_j_asc                
                
                
                
            fin_fre_j_asc:
                inc i ;i++
                mov j,0d 
                mov siguiente_j,1d
                mov temporal,0
                mov valor_en_posicion_j_masUno,0
                mov valor_en_posicion_j,0   
                jmp for_frecuencia_asc         
        
            
            
        ;-> fin del ciclo burbuja   
        fin_frecuencia_asc:
    

endm
; - - - - - - - - - - - - - -- - - - - - - - - - - - - - - - - - - - - - - - - 









; ========== macro para escribir en archivo de reporte
WRITE_IN_FILE macro cadena,tamanio_cadena

    mov ah,40h
    mov bx,handler2
    mov cx,tamanio_cadena
    mov dx,0
    mov dx,offset cadena 
    int 21h 

endm 
; - - - - - - - - - - - - - -- - - - - - - - - - - - - - - - - - - - - - - - - 







; ========== macro para escribir numero en el reporte txt
DATE_WRITE_IN_FILE macro numero,contador

    local DOWHILE,ESCRIBIR_ASCII_TXT,FIN_ESCRIBIR_ASCII_TXT

    ;->limpieza
    mov contador,0D
    mov dx,0d
    mov ax,0d

    mov al,numero 

    DOWHILE:

        MOV DX,0D
        MOV CX,10D
        DIV CX 

        ;-> empuje a la pila y aumento numero en pila
        PUSH DX
        INC contador

        ;-> comparamo el resultado del cociente
        CMP Al,0
        JNLE DOWHILE

    
    ;-> scando de la pila para escirbir en el archivo de txt
    MOV AX,0

    ESCRIBIR_ASCII_TXT:

        ;-> condicion de salida
        ;-> salta si el contador es igual a 0
        CMP contador,0
        JE FIN_ESCRIBIR_ASCII_TXT

        POP DX
        MOV numero_ingresador_en_pila,dx
        ADD numero_ingresador_en_pila,30h
        DEC contador

        ;->ESCRIBE ENEL ARCHIVO DE TEXTO
        WRITE_IN_FILE numero_ingresador_en_pila,1D


        ;-> repite el ciclo 
        JMP ESCRIBIR_ASCII_TXT


    ;-> finalizacion del ciclo 
    FIN_ESCRIBIR_ASCII_TXT:

endm 
; - - - - - - - - - - - - - -- - - - - - - - - - - - - - - - - - - - - - - - - 







; ========== macro para escribir numero en el reporte txt
NUMBERS_WRITE_IN_FILE macro numero,contador

    local DOWHILE2,ESCRIBIR_ASCII_TXT2,FIN_ESCRIBIR_ASCII_TXT2

    ;->limpieza
    mov contador,0D
    mov dx,0d
    mov ax,0d

    mov ax,numero 

    DOWHILE2:

        MOV DX,0D
        MOV CX,10D
        DIV CX 

        ;-> empuje a la pila y aumento numero en pila
        PUSH DX
        INC contador

        ;-> comparamo el resultado del cociente
        CMP Al,0
        JNLE DOWHILE2

    
    ;-> scando de la pila para escirbir en el archivo de txt
    MOV AX,0

    ESCRIBIR_ASCII_TXT2:

        ;-> condicion de salida
        ;-> salta si el contador es igual a 0
        CMP contador,0
        JE FIN_ESCRIBIR_ASCII_TXT2

        POP DX
        MOV numero_ingresador_en_pila,dx
        ADD numero_ingresador_en_pila,30h
        DEC contador

        ;->ESCRIBE ENEL ARCHIVO DE TEXTO
        WRITE_IN_FILE numero_ingresador_en_pila,1D


        ;-> repite el ciclo 
        JMP ESCRIBIR_ASCII_TXT2


    ;-> finalizacion del ciclo 
    FIN_ESCRIBIR_ASCII_TXT2:

endm 
; - - - - - - - - - - - - - -- - - - - - - - - - - - - - - - - - - - - - - - - 



; ========== macro para pintar un pixel en pantalla
PINTAR macro posicionX,posiscionY,color
    mov ax,0D
    mov cx,0D
    mov dx,0D
    mov al,color
    mov cx,posicionX
    mov dx,479D
    sub dx,posiscionY
    mov ah,0ch
    int 10h
endm 
; - - - - - - - - - - - - - -- - - - - - - - - - - - - - - - - - - - - - - - - 



; ========== macro para pintar un rectangulo
PINTAR_BARRA macro X,Y,ancho,alto,color
    local for_barra,finFor_barra,for2_barra,finFor2_barra
    
    ; limpieza de los registros
    mov ax,0D
    mov bx,0D
    mov cx,0D
    mov dx,0D

    mov contador4,0d
    
    for_barra:
        mov ax,alto
        cmp contador4,ax
        jge finFor_barra
        
        mov contador5,0d
        
        for2_barra:
            mov ax,ancho
            cmp contador5,ax
            jge finFor2_barra
            
            mov ax,contador5
            add ax,X
            mov posicionX,ax
            
            mov ax,contador4
            add ax,Y
            mov posicionY,ax
            
            PINTAR posicionX,posicionY,color
            
            inc contador5   
            jmp for2_barra
            
         finFor2_barra:
         
         
         inc contador4
         jmp for_barra
         
         
     finFor_barra:


endm 
; - - - - - - - - - - - - - -- - - - - - - - - - - - - - - - - - - - - - - - -








;--------------------------------------------------------------- programa general ----------------------------------------------------------------------
.model small
.stack
.data


    ; --> para imprimir un salto de liena por consola
    salto_linea db ' ',10,13,'$' 


    ; --> comando para mostara por consola
    comando_consola db 'consolap2> ','$'

    ; --> vector para guardar el comando por entrada
    comando_entrada db 100 dup ('$')
    contador db 0

    ; --> palabras reservadas
    tk_cprom db 'cprom','$';5
    tk_cmediana db 'cmediana','$';8
    tk_cmoda db 'cmoda','$';5
    tk_cmax db 'cmax','$';4
    tk_cmin db 'cmin','$';4
    tk_gbarra_asc db 'gbarra_asc','$';10
    tk_gbarra_desc db 'gbarra_desc','$';11
    tk_ghist db 'ghist','$';5
    tk_glinea db 'glinea','$';'6
    tk_limpiar db 'limpiar','$';7
    tk_reporte db 'reporte','$';7
    tk_info db 'info','$';4
    tk_salir db 'salir','$';5
    tk_abrir db 'abrir_','$';6


    ; -> informacion para mostar por pantalla
    msg_informacion db 'ARQUITECTURA DE COMPUTADORES Y ENSAMBLADORES 1',13,10
                    db 'SECCION A',13,10
                    db 'PRIMER SEMESTRE 2021',10,13
                    db 'HECTOR JOSUE OROZCO SALAZAR',10,13
                    db '201314296',10,13
                    db 'PROYECTO 2 ASSEMBLER',10,13,'$'
    
    
    
    msg_diferentes db 'El comando no se reconoce',10,13,'$'
    msg_iguales db 'Los comando son iguales',10,13,'$'


    ;--------- utilidades para la apertura del archivo
    msg_apertura_archivo db 'Ingrese la ruta del archivo: ','$'
    posicion_en_comando db 6d  
    caracter db 0  
    nombre_archivo db 100 dup('$') 
    posicion_nombre_archivo db 0
    
    handler dw ?
    msg_error1 db 'Error no se puede abrir el archvo',10,13,'$'
    msg_error2 db 'Error no se puede leer el archivo',10,13,'$'
    fragmento db 2 dup('$') 
    contador_numeros_entrada db 0



    ; ------ utilidades para guardar los archivos de entrada
    vector_entrada dw 500 dup('$')  
    posicion_vector_entrada dw 0  
    aux_unidades db 0    
    respaldo_registro_ax dw 0 
    respaldo_registro_cx dw 0
    size_vector dw 0   
    inicio_vector dw 0

    
    ; ------ utilidades para imprimir los numeros del vector binario 
    cantidad_numero_en_pila dw 0
    resultado_division dw 0
    numero_aux_entrada dw 0 
    contImpVector dw 0 
    auxRegAX dw 0  ;respaldos ax
    auxRegCX dw 0  ; respaldo de cx



    ; ------ utilidades para el ordenamiento burbuja
    i dw 0
    j dw 0
    temporal dw 0  
    size_copia2 dw 0  
    valor_en_posicion_j dw 0   
    valor_en_posicion_j_masUno dw 0
    volor_en_posicion_i dw 0 
    siguiente_j dw 1


    ; ------- utilidades para saber el menor numero
    valor_minimo dw 0
                           
                           
    ; ------- utilidades para saber el mayor numero 
    valor_maximo dw 0


    ; ------- utilidades para la impresion del valor de una variable
    contador_de_decimales db 0  
    numero_en_pila dw 0 
    
    
    ; ------- utilidades para econtrar el promedio
    numero_a_sumar dw 0
    posicion_valor dw 0
    suma_total dw 0
    decimales dw 0
    copia_size dw 0
    
    
    aux_unidades2 dw 0 
    
    contador_decimales dw 0
    parte_entera dw 0
    residuo dw 0 
    decimal dw 0 
    


    ; ---------- utilidades para la tabla de frecuencias
    vector_frecuencia dw 500 dup('$')
    numero_frecuencia dw 500 dup('$')
    tamanio_vector_frecuencia dw 0D
    
    cantidad_frecuencia dw 1D
    contador_frecuencia dw 0d
    valor_para_frecuencia dw 0d 
    valor_para_frecuencia_siguiente dw 0d 
    posicion_valor_vector_entrada dw 0d
    posicion_vector_frecuencia dw 0d
    copia_size2 dw 0d
    
  
    ;--------------- variables extras para el orden DES de la frecuencia
    numero_en_posicion_j_masUno dw 0    
    
    
    ;----------------- para el calcula de la moda
    moda dw 0
    moda2 dw 0

    
    ;------------------ utilidades para calcular la mediana 
    mediana dw 0 
    mediana_siguiente dw 0
    
    cociente_mediana dw 0
    residuo_mediana dw 0 
    copia_size3 dw 0d  
    
    posicion_de_mediana dw 0 
    posicion_de_mediana_siguiente dw 0    
    suma_mediana dw 0    
    
    decimales_mediana dw 0 
    decimal_mediana dw 0


    ; ------------------ utilidades para crear el reporte txt
    archivo_reporte db 'reporte.txt',0
    handler2 dw ?
    contador_pila dw 0 
    numero_ingresador_en_pila dw 0
    


    dia db 0
    mes db 0 
    anio dw 0 
    txt_anio_2021 db '2021','$';4
    txt_separador_fecha db '-','$';1


    hora db 0
    minutos db 0
    segundos db 0 
    txt_separador_tiempo db ':','$';1


    ;separador par decimales
    txt_punto_decimal db '.','$';1

    ; PARA AGREGAR DECIMALES AL ARCHIVO DE TEXTO
    decimal_txt dw 0

    ;promedio
    promedio_parte_entera dw 0
    promedio_residuo  dw 0 

    ;mediana
    mediana_parte_entera dw 0
    mediana_parte_decimal dw 0 


    ;CONTADOR PARA ESCRIBIR LA FRECUENCIA
    contador_escritura_frecuencia dw 0
    numero_frecuencia_a_escribir dw 0
    valor_de_frecuencia_a_escribir dw 0


    txt_separador_frecuencia db '<---->','$';6


    txt_nueva_linea db ' ',13,10,'$';2

    txt_encabezado  db "Universidad de San Carlos de Guatemala",13,10;39
                    db "Facultad de Ingenieria",13,10;23				
                    db "Arquitectura de Computadores y Ensambladores 1",13,10;47
                    db "Primer Semestre 2021",13,10;21
                    db "Seccion A",13,10;10
                    db "Hector Josue Orozco Salazar",13,10;28
                    db "201314296",13,10,'$';10

    txt_promedio    db "Promedio: ",'$';10
    txt_mediana     db "Mediana: ",'$';9
    txt_moda        db "Moda: ",'$';6
    txt_maximo      db "Maximo: ",'$';8
    txt_minimo      db "Minimo: ",'$';8

    txt_tabla_frecuencia    db  "Tabla de Frecuenicas: ",13,10,'$';23 



    msg_error_creacion_archivo db 'Error: No se puede crear el archivo',10,13,'$'
    msg_error_escritura_archivo db 'Error: No se pudo escribir en el archivo',10,13,'$'
    msg_exito_reporte db 'Reporte creado con exito',10,13,'$'




    ;------------------------- utilidade para pintar un barra
    ancho_barra dw 0d
    alto_barra dw 0d
    contadorRectangulos dw 0d
    contadorImpresion dw 0d
    contador3 dw 0d 
    contador4 dw 0d
    contador5 dw 0d 
    contador6 dw 0d  
    posicionX dw 0d
    posicionY dw 0d
    contador7 dw 0d
    espacio_inicial dw 10d
    alto_barra_pintar dw 0d
    alto_barra_rescalada dw 0d
    valor_mas_alto_frecuencia dw 0d

    posicion_valor_mas_alto_frecuencia dw 0d
    
    ; para imprimir los valores de la barras de la asc 
    contador8 dw 0d 
    numero_imprimir_modo_video dw 0d
    posicionX_numero_modo_video db 0d




  

.code 


    mov ax,@data
    mov ds,ax


    ; --> limpieza de la pantalla para empezar el programa
    LIMPIAR_PANTALLA


   ;************************************************************************************************************ 
   ; --> arranque del programa
   ; --> arranque del programa
    ingreso_comando:  
    

        PRINT comando_consola 
        
        mov cx,100
        mov si,0
        
         
        ; inicio de la lectura del comando 
        lectura: 
                  
            ; verificacion si el contador es igual que al tamanio del vector                  
            cmp si,cx
            jge fin_lectura
            
            ;ingreso de caracter por consola
            mov ah,01
            int 21h
            
            ; verificacion de la tecla enter 
            cmp al,13d
            je fin_lectura             
            
            
            ; guardar el caracter leido en el vector path
            mov comando_entrada[si],al
            inc si
            jmp lectura
            
                                       
                                       
        ; fin de la lectura del comando            
        fin_lectura: 
            mov comando_entrada[si],0


        ; --> analisis de la entrada    
        PRINT salto_linea    
        ;PRINT comando_entrada
        ;PRINT salto_linea
        
        ; == swith case para comparar el comando de entrada 
        ; == con las palabras reservadas acpetadas por el programa
        SWITCH_CASE_CADENAS
       

    ;************************************************************************************************************ 
    ; -> cuando los token no coniciden    
    diferente:
        PRINT msg_diferentes
        .exit  




    ;************************************************************************************************************   
    ; -> se a ingresado el comando cprom
    comando_cprom:
        
        ; reinicio de variables
        MOV suma_total,0D
        MOV posicion_valor,0D
        MOV decimales,0D
        MOV contador_decimales,0D
            
        mov ax,0
        mov bx,0  
        mov cx,0 
        mov cx,size_vector
        mov copia_size,cx
        
        ;PAUSA_PANTALLA    
            
        ;-> recorrer el vector y ir sumando sus valores
        FOR_PROMEDIO:
            
             ;->condicion de salida
             cmp copia_size,0
             je FIN_FOR_PROMEDIO
             
             
             ;-> obtener el valor que se va a sumar
             GET_NUMBER_BINARY vector_entrada,posicion_valor,numero_a_sumar
             
             ;-> se suma el valor en una variable total
             mov ax,numero_a_sumar
             add suma_total,ax 
             
             
             ;-> pasa a la siguiente posicion del vector
             inc posicion_valor                          
             
             ;-> decrementa cantidad numeros en el vector
             dec copia_size
             
             ;-> repite el ciclo
             jmp FOR_PROMEDIO
             
             
            
        FIN_FOR_PROMEDIO:
            ;->
        
        
        ;PAUSA_PANTALLA 
        
        ;-> calculo del promedio 
        mov ax,0
        mov bx,0
        
        mov ax,suma_total
        mov bx,size_vector
        div bx  
        
        
        ; -> guardo la parte entera de la divison
        mov parte_entera,ax
        
        ;-> guardo la parte entera para el reporte txt
        mov promedio_parte_entera,ax 
        
        ; -> guardo la parte para calcular los decimales
        mov residuo,dx     

        ;-> guardo el residuo para imprimirlos en el reporte txt
        mov promedio_residuo,dx
        
        
        ;-> IMPRESION DEL RESULTADO DEL PROMEDIO 
        PRINT salto_linea   
        
        ;->impresion del comando de consola
        PRINT comando_consola
        
        NUMBER_BINARY_ASCII parte_entera
        
        ;-> IMPRESION DEL PUNTO 
        PRINT_CARACTER '.'
        
        
        
        ;-> ciclo para el calculo de los decimales
        FOR_DECIMALES:
            mov ax,0D
            mov ax,residuo 
            
            ;-> condicion de salida para calcular solo tres decimales
            cmp contador_decimales,3D
            je FIN_FOR_DECIMALES   
            
            
            ;-> limpieza de registros
            mov bx,0D
            mov bx,10D
            mul bx 
            
            
            mov bx,0D
            mov bx,size_vector
            div bx
            mov decimal,ax 
            mov residuo,dx
            ;push ax  
            
            ;-> impresion del decimal
            NUMBER_BINARY_ASCII decimal
            
            ;1,1,1,4,4,5
            
            ;-> AUMENTA PARA SABER LA CANTIDAD DE DECIMALES CALCULADOS
            inc contador_decimales
                                  
            ;-> SE REPITE EL CICLO
            jmp FOR_DECIMALES
                                  
                                  
                                  
        ;-> FINALIZACION DEL CICLO
        FIN_FOR_DECIMALES:
            ;-----------
         
         
        ;->
        PRINT salto_linea  
        PRINT salto_linea         
        
        
        ;-> REGRESA PARA PEDIR EL SIGUIENTE COMANDO
        jmp ingreso_comando   
        
        
        
    ;************************************************************************************************************  
    ; -> se a ingreado el comando cmediana
    comando_cmediana:  
    
        ;-> se ordena de menor a mayor
        ;-> ordena de menor a mayor se obtiene el primer valor
        ; -> prueba para ver el ordenamiento burbuja ascendente
        ORDENAMIENTO_BURBUJA_ASC vector_entrada,size_vector
        
    
        ; PAUSA_PANTALLA

        ;-> limpiamos registro para trabajar
        mov ax,0
        mov bx,0
        mov cx,0
        mov dx,0

        ;hacemos una copia del tamanio del vector de entrada
        mov dx,size_vector

        mov copia_size3,dx 

        ; limpiamos 
        mov dx,0

        ; divimos el tamanio del vector en dos para saber si es par o impar
        mov ax,copia_size3
        mov bx,2
        div bx  
        
        
        ; comparamos el residuo para saber si el numero es par o impar
        ; dx = 0 es par
        ; dx != 0 es impar 
        
        ; si dx = 
        cmp dx,0D
        je MEDIANA_PAR 
        
        jmp MEDIANA_IMPAR 
        
        
        
        ; -> CUANDO EL NUMERO SEA PAR
        MEDIANA_PAR:                  
            ;->
            mov posicion_de_mediana,ax 
            DEC posicion_de_mediana 
            
            mov dx,0
            mov dx,posicion_de_mediana
            mov posicion_de_mediana_siguiente,dx
            INC posicion_de_mediana_siguiente 
                                                       
                                                       
            ;-> OBTENGO LOS VALORES DE ESAS POSICIONES 
            ;-> obtner la mediana del vector de entrada
            GET_NUMBER_BINARY vector_entrada,posicion_de_mediana,mediana
            
            ;-> obtner la mediana del vector de entrada
            GET_NUMBER_BINARY vector_entrada,posicion_de_mediana_siguiente,mediana_siguiente 
            
            ;-> SE REALIZA LA SUMA 
            mov ax,0
            mov ax,mediana
            add ax,mediana_siguiente
            mov mediana,ax
            
            ;-> DIVIDE ENTRE 2
            mov ax,0
            mov ax,mediana
            mov bx,2D
            div bx 
            
            mov cociente_mediana,ax 
            mov residuo_mediana,dx 
            
            
            ;-> guardo la parte entera para escribir en el reporte
            mov mediana_parte_entera,ax 

            ;->impresion del comando de consola
            PRINT comando_consola
            
            ;-> se imprime la mediana cuando es par  
            NUMBER_BINARY_ASCII cociente_mediana 
            
            
            ;-> IMPRESION DEL PUNTO 
            PRINT_CARACTER '.'  
            
            
            ;->DECIMAL DE LA MEDIANA
            FOR_DECIMAL_MEDIANA:
                mov ax,0D
                mov ax,residuo_mediana
                                     
                ;-> CONDICION DE SALIDA DE CICLO                      
                cmp decimales_mediana,1D
                je FIN_FOR_DECIMAL_MEDIANA 
                
                ;->LIMPIEZA
                mov bx,0D
                mov bx,10D
                mul bx  
                
                mov bx,0D
                mov bx,2D
                div bx
                mov decimal_mediana,ax

                ;->guardo la parte decimal para imprimir en el report txt
                mov mediana_parte_decimal,ax 
                
                NUMBER_BINARY_ASCII decimal_mediana
                
                
            
            ;->FINALIZACION DEL CICLO    
            FIN_FOR_DECIMAL_MEDIANA:
            
            
            
            PRINT salto_linea
            PRINT salto_linea
            
            
            
            
            ;-> REGRESA PARA PEDIR UN SIGUIENTE COMANDO
            jmp ingreso_comando  
            
            
            
        ;-> CUANDO EL NUMERO SEA IMPAR    
        MEDIANA_IMPAR: 
            
            ;->
            MOV posicion_de_mediana,ax
            ;INC posicion_de_mediana
            
            
            ;-> obtner la mediana del vector de entrada
            GET_NUMBER_BINARY vector_entrada,posicion_de_mediana,mediana 


            ;-> guardo la mediana cuando es para para el reporte txt
            mov cx,0
            mov cx,mediana 
            mov mediana_parte_entera,cx 
            
            ;->
            PRINT salto_linea
            
            ;->impresion del comando de consola
            PRINT comando_consola
            
            ;-> se imprime la mediana cuando es par  
            NUMBER_BINARY_ASCII mediana 
            
            PRINT salto_linea
            PRINT salto_linea
            
            
            jmp ingreso_comando
        





    ;************************************************************************************************************   
    ; -> se a ingreado el comando cmoda
    comando_cmoda:  

        MOV moda,0D       
        MOV moda2,0D
        MOV tamanio_vector_frecuencia,0D
                  
        ;-> orden de menor a mayor
        ORDENAMIENTO_BURBUJA_ASC vector_entrada,size_vector  

        ;-> calculo de la moda se usa para la tabla de frecuencias
        MOV cantidad_frecuencia,1D
        MOV contador_frecuencia,0d
        MOV valor_para_frecuencia,0d 
        MOV valor_para_frecuencia_siguiente,0d 
        MOV posicion_valor_vector_entrada,0d
        MOV posicion_vector_frecuencia,0d
        MOV copia_size2,0d
        mov ax,0
        mov bx,0
        mov cx,0
        mov dx,0
        
        
        ;-> inico del for para ir sacando la frecuencia
        FOR_FRECUENCIA:
        
            ;-> reviso el tamanio del vector de entrada    
            mov dx,size_vector 
             
            ;->condicion de salida para el for de frecuencia
            cmp copia_size2,dx 
            jge FIN_FOR_FRECUENCIA
            
            ;-> obtengo el valor para la frecuencia
            GET_NUMBER_BINARY vector_entrada,posicion_valor_vector_entrada,valor_para_frecuencia 
                         

            ;-> aumenta en uno 
            inc copia_size2
            inc posicion_valor_vector_entrada   
             

            ;-> mueve al siguiente valor del vector de entrada y compara
            GET_NUMBER_BINARY vector_entrada,posicion_valor_vector_entrada,valor_para_frecuencia_siguiente 
            
            
            ;-> comparo los dos numero obtenidos
            ;-> insertor si son iguales si no sigue leendo y contado
            mov cx,valor_para_frecuencia
            cmp valor_para_frecuencia_siguiente,cx
            jne INSERTAR_FRECUENCIA                                                      
            
            
            ;-> si no son iguales regresa para seguir con el siguiente numero del vector
            INC cantidad_frecuencia
            JMP FOR_FRECUENCIA  
            
            
            
            INSERTAR_FRECUENCIA:
            
                ;-> envio al vector de frecuencia
                SET_VECTOR_BINARY vector_frecuencia,posicion_vector_frecuencia,valor_para_frecuencia
                SET_VECTOR_BINARY numero_frecuencia,posicion_vector_frecuencia,cantidad_frecuencia 
                
                ;-> reinicio el contador de frecuencia
                mov cantidad_frecuencia,1D 
                
                ;-> incremento para la siguiente posicion del vector de frecuenicas
                INC posicion_vector_frecuencia 
                
                ;-> incremento el tamanio del vector de frecuencia
                INC tamanio_vector_frecuencia
                
                
                ;-> regresa para leer el siguiente numero del vector de entrada
                JMP FOR_FRECUENCIA
            
        ;-> termina el ciclo for para sacar la frecuenica
        FIN_FOR_FRECUENCIA:
            ;->             


        ; ------------------------ obtener la moda del vector de entrada    
        ;-> imprensiones 
        ; PRINT salto_linea
        ; PRINT salto_linea
        
        ; ;->
        ; IMPRIMIRVECTOR vector_frecuencia,tamanio_vector_frecuencia
       
        ; ;->
        ; PRINT salto_linea                                                           
                                                                   
        ; ;->
        ; IMPRIMIRVECTOR numero_frecuencia,tamanio_vector_frecuencia  
      
            
        ; PRINT salto_linea    
        ; PRINT salto_linea
        
        ;-> macro para ordenar la tabla de frecuencia segun la frecuencia de los datos de entrada
        FRECUENCIA_DES numero_frecuencia,vector_frecuencia,tamanio_vector_frecuencia 
        
        
        ; PRINT salto_linea    
        ; PRINT salto_linea
                         
        ; IMPRIMIRVECTOR vector_frecuencia,tamanio_vector_frecuencia               
                                  
                                  
        ; PRINT salto_linea    
        ; PRINT salto_linea                          
        
        ; IMPRIMIRVECTOR numero_frecuencia,tamanio_vector_frecuencia
        
        
        ; PRINT salto_linea    
        ; PRINT salto_linea    

        ;-> obtener el primer valor de la frecuencia 
        GET_NUMBER_BINARY vector_frecuencia,0,moda

        GET_NUMBER_BINARY vector_frecuencia,1D,moda2
        
        ; PRINT salto_linea    

        ;->impresion del comando de consola
        PRINT comando_consola 
                          
        NUMBER_BINARY_ASCII moda                 

        PRINT salto_linea    
        PRINT salto_linea    

        PRINT comando_consola

        NUMBER_BINARY_ASCII moda2

        PRINT salto_linea    
        PRINT salto_linea 
        
        ; -> regreso para pedir otro comando
        jmp ingreso_comando
        
        
     
    ;************************************************************************************************************  
    ; -> se a ingreado el comando cmax
    comando_cmax:
        
        ;-> ordenamiento del vector descendente 
        ORDENAMIENTO_BURBUJA_DES vector_entrada,size_vector
        ;PRINT salto_linea
        ;IMPRIMIRVECTOR vector_entrada,size_vector
        
        ;->obtiene el valor maximo = primer valor del vector
        GET_NUMBER_BINARY vector_entrada,0,valor_maximo 
        
        ;->impresion del comando de consola
        PRINT comando_consola
        
        ;-> impresion del valor minimo              
        NUMBER_BINARY_ASCII valor_maximo
                      
                      
        PRINT salto_linea 
        PRINT salto_linea
                

        jmp ingreso_comando


    
    ;************************************************************************************************************ 
    ; -> se a ingresado el comando cmin
    comando_cmin:
        
        ;-> ordena de menor a mayor se obtiene el primer valor
        ; -> prueba para ver el ordenamiento burbuja ascendente
        ORDENAMIENTO_BURBUJA_ASC vector_entrada,size_vector
        ;PRINT salto_linea
        ;IMPRIMIRVECTOR vector_entrada,size_vector
        
        ;-> obtiene el valor minimo = primer valor del vector
        GET_NUMBER_BINARY vector_entrada,0,valor_minimo  
        
        ;->impresion del comando de consola
        PRINT comando_consola
        
        ;-> impresion del valor minimo              
        NUMBER_BINARY_ASCII valor_minimo
                      
                      
        PRINT salto_linea 
        PRINT salto_linea
                
        jmp ingreso_comando


    
    ;************************************************************************************************************    
    ; -> se a ingresado el comando gbarra_asc
    comando_gbarra_asc:

        ;limpieza
        mov contador7,0d
        mov alto_barra,0d
        mov espacio_inicial,2d
        mov alto_barra_rescalada,0d
        mov valor_mas_alto_frecuencia,0d
        mov posicion_valor_mas_alto_frecuencia,0d
       
        mov numero_imprimir_modo_video,0d
        mov contador8,0d
        mov posicionX_numero_modo_video,0d

        ; limpieza de pantalla
        LIMPIAR_PANTALLA

        ; inicio del modo de vido 
        mov ah,00h
        mov al,12h
        int 10h

        ; PINTAR_BARRA 10d,5d,10d,400d,0fh    

        ; macro para ordenar la tabla de frecuencia
        ; ordenamiento de la tabla de frecuencia de forma ascendente
        FRECUENCIA_ASC numero_frecuencia,vector_frecuencia,tamanio_vector_frecuencia

        mov dx,0
        mov dx,tamanio_vector_frecuencia
        mov posicion_valor_mas_alto_frecuencia,dx 
        dec posicion_valor_mas_alto_frecuencia

        ; busco el valor mas alto de la frecuencia
        ; para hacer la operacion en la redimension
        GET_NUMBER_BINARY numero_frecuencia,posicion_valor_mas_alto_frecuencia,valor_mas_alto_frecuencia

        


        ;->recorrer la tabla de frecuencia y pintar
        recorrer_tabla_frecuencia_asc:
            mov bx,0d
            mov bx,tamanio_vector_frecuencia
            cmp contador7,bx
            jge fin_recorrer_tabla_frecuencia_asc

            ;-obtener los valores de la frecuencia para darle un alto a la barras
            GET_NUMBER_BINARY numero_frecuencia,contador7,alto_barra_pintar


            ;redimension de altura
            mov alto_barra_rescalada,0d
            mov ax,0d
            mov bx,0d
            mov ax,alto_barra_pintar
            mov bx,400d
            mul bx
            mov bx,valor_mas_alto_frecuencia
            div bx
            mov alto_barra_rescalada,ax


            ; ( POSICION X, POSICION Y, ANCHO, ALTO ,COLOR )
            PINTAR_BARRA espacio_inicial,30d,22d,alto_barra_rescalada,0eh 

            ;para posicionar al siguiente espacio
            add espacio_inicial,23d

            ;para pasar al siguiente valor de la tabla de frecuencia
            inc contador7

            ; regreso para obtener el siguiente valor
            jmp recorrer_tabla_frecuencia_asc 


        fin_recorrer_tabla_frecuencia_asc:


        recorrer_tabla_valores:
            mov bx,0d
            mov bx,tamanio_vector_frecuencia
            cmp contador8,bx
            jge fin_recorrer_tabla_valores
            ;comparacon escape de salida del ciclo for

            ;obtener el valor para pintar debajo de la pantalla
            GET_NUMBER_BINARY numero_frecuencia,contador8,numero_imprimir_modo_video

            ;posiciono el curso debajod e la barras
            ;-> reposicionar el cursos en la parte baja de la pantalla
            mov dx,0d
            mov dh,29d ; fila mas abajo de la pantalla del modo de video
            mov dl,posicionX_numero_modo_video ; columna variable
            mov bh,0
            mov ah,2
            int 10h

            ;pinto el numero
            PRINTNUMEROS numero_imprimir_modo_video


            ;correr la posicion x del numero de la barra
            add posicionX_numero_modo_video,3d

            ;paso al siguiente valor del vector
            inc contador8

            ;repite el ciclo para obtener el siguiente valor
            jmp recorrer_tabla_valores


        fin_recorrer_tabla_valores: 
            ;-

        
        ; pausa de pantalla para visualizar la imagen
        PAUSA_PANTALLA

        ; limpieza de pantalla - para limpiar el modo de video
        LIMPIAR_PANTALLA

        ; regreso al bucle normal para pedir otro comando
        ; PRINT msg_iguales
        jmp ingreso_comando




            

    ;************************************************************************************************************     
    ; -> se a ingresado el comando gbrarra_des
    comando_gbarra_desc:

        ; limpieza
        mov contador7,0d
        mov alto_barra,0d
        mov espacio_inicial,2d
        mov alto_barra_rescalada,0d
        mov valor_mas_alto_frecuencia,0d
        
        mov numero_imprimir_modo_video,0d
        mov contador8,0d
        mov posicionX_numero_modo_video,0d

        ; limpieza de pantalla
        LIMPIAR_PANTALLA

        ; inicio del modo de vido 
        mov ah,00h
        mov al,12h
        int 10h        
        
        ;-> macro para ordenar la tabla de frecuencia segun la frecuencia de los datos de entrada
        ;-> datos ordenados de la tabla de frecuencia en orden descendente 
        FRECUENCIA_DES numero_frecuencia,vector_frecuencia,tamanio_vector_frecuencia 

        ; obtener el valor mas grande la frecuencia
        GET_NUMBER_BINARY numero_frecuencia,0,valor_mas_alto_frecuencia

        
        ;->recorrer la tabla de frecuencia y pintar
        recorrer_tabla_frecuencia:
            mov bx,0d
            mov bx,tamanio_vector_frecuencia
            cmp contador7,bx
            jge fin_recorrer_tabla_frecuencia

            ;-obtener los valores de la frecuencia para darle un alto a la barras
            GET_NUMBER_BINARY numero_frecuencia,contador7,alto_barra_pintar


            ;redimension de altura
            mov alto_barra_rescalada,0d
            mov ax,0d
            mov bx,0d
            mov ax,alto_barra_pintar
            mov bx,400d
            mul bx
            mov bx,valor_mas_alto_frecuencia
            div bx
            mov alto_barra_rescalada,ax

            

            ; ( POSICION X, POSICION Y, ANCHO, ALTO ,COLOR )
            PINTAR_BARRA espacio_inicial,30d,22d,alto_barra_rescalada,0dh 

            ;para posicionar al siguiente espacio
            add espacio_inicial,23d

            ;para pasar al siguiente valor de la tabla de frecuencia
            inc contador7

            ; regreso para obtener el siguiente valor
            jmp recorrer_tabla_frecuencia


        fin_recorrer_tabla_frecuencia:


        recorrer_tabla_valores_desc:
            ; limpieza
            mov bx,0d
            mov bx,tamanio_vector_frecuencia
            ; escaque de salida del ciclo 
            cmp contador8,bx
            jge fin_recorrer_tabla_valores_desc

            ; obtener el valor para pintar debajo de las barras en la pantalla
            GET_NUMBER_BINARY numero_frecuencia,contador8,numero_imprimir_modo_video

            ;posiciono el curso debajod e la barras
            ;-> reposicionar el cursos en la parte baja de la pantalla
            mov dx,0d
            mov dh,29d ; fila mas abajo de la pantalla del modo de video
            mov dl,posicionX_numero_modo_video ; columna variable
            mov bh,0
            mov ah,2
            int 10h

            ;pintar el numero
            PRINTNUMEROS numero_imprimir_modo_video

            ;correr la posicion x del numero de la barra
            add posicionX_numero_modo_video,3d

            ;paso al siguiente valor del vector
            inc contador8

            ; repite el ciclo hasta hasta llegar el final del vector
            jmp recorrer_tabla_valores_desc


        fin_recorrer_tabla_valores_desc:
            ;--


        ; pausa de pantalla para visualizar la imagen
        PAUSA_PANTALLA

        ; limpieza de pantalla - para limpiar el modo de video
        LIMPIAR_PANTALLA

        ; regreso al bucle normal para pedir otro comando
        ; PRINT msg_iguales
        jmp ingreso_comando    




        

    ;************************************************************************************************************    
    ; -> se a ingresado el comando ghist
    comando_ghist:
        PRINT msg_iguales
        jmp ingreso_comando    


    ;************************************************************************************************************     
    ; -> se a ingreado el comando glinea
    comando_glinea:
        PRINT msg_iguales
        jmp ingreso_comando
            
   
    ;************************************************************************************************************ 
    ; -> se a ingresado el comando para limpiar
    comando_limpiar:
        LIMPIAR_PANTALLA
        jmp ingreso_comando



    
    
    ;************************************************************************************************************ 
    ; -> se a ingresado para creacion de reportes
    comando_reporte:
        
        ; Generacion y Escritura del reporte en TXT

        ; Limpieza de los registros para trabajar el reporte
        mov ax,0
        mov bx,0
        mov dx,0
        mov cx,0

        inicio_reporte:
            ;creacion del archvio
            mov ah,3ch
            mov cx,0
            mov dx,offset archivo_reporte
            int 21h


            ;si hay error en la creacion del archivo 
            jc error_creacion_archivo
            mov handler2,ax


            ; escritura del encabezado en el reporte
            WRITE_IN_FILE txt_encabezado,183D

            ;-- separacion
            WRITE_IN_FILE txt_nueva_linea,3D
            WRITE_IN_FILE txt_nueva_linea,3D
            WRITE_IN_FILE txt_nueva_linea,3D

            ;/////////////////////////////////
            ; escirtura de fecha y hora
            ;DIA MES ANIO
            mov ah,2Ah
            int 21h

            mov dia,dl;dia 
            mov mes,dh;mes

            ;->escritura de dia 
            DATE_WRITE_IN_FILE dia,contador_pila
            ;->separador
            WRITE_IN_FILE txt_separador_fecha,1D
            ;-> escritura del mes
            DATE_WRITE_IN_FILE mes,contador_pila
            ;->separador
            WRITE_IN_FILE txt_separador_fecha,1D
            ;-> escritura del anio
            WRITE_IN_FILE txt_anio_2021,4D

            ;-- separacion
            WRITE_IN_FILE txt_nueva_linea,3D

            ;///////////////////////////////////
            mov ah,2CH
            int 21h

            mov hora,ch
            mov minutos,cl
            mov segundos,dh 

            ;-> escritura de hora
            DATE_WRITE_IN_FILE hora,contador_pila
            ;->separador
            WRITE_IN_FILE txt_separador_tiempo,1D
            ;-> escritura de los minutos
            DATE_WRITE_IN_FILE minutos,contador_pila
            ;->separador
            WRITE_IN_FILE txt_separador_tiempo,1D
            ;-> escritura de los segundos
            DATE_WRITE_IN_FILE segundos,contador_pila


            ;///////////////////////////////////
            WRITE_IN_FILE txt_nueva_linea,3D
            WRITE_IN_FILE txt_nueva_linea,3D
            WRITE_IN_FILE txt_nueva_linea,3D



            ; **** escritura del promedio obtenido ****
            WRITE_IN_FILE txt_promedio,10D
            ; parte entera
            NUMBERS_WRITE_IN_FILE promedio_parte_entera,contador_pila
            ; punto 
            WRITE_IN_FILE txt_punto_decimal,1D
            
            ;//////////////////////////////////////
            ;-> escritura de parte decimal 
            mov contador_decimales,0D
            FOR_DECIMALES_TXT:
                mov ax,0D
                mov ax,promedio_residuo

                ;-> condicion de salid del ciclo
                CMP contador_decimales,3D
                je FIN_DECIMALES_TXT

                ;->limpieza
                mov bx,0D
                mov bx,10D
                mul bx

                mov bx,0D
                mov bx,size_vector
                div bx
                mov decimal_txt,ax
                mov promedio_residuo,dx 

                ;??mpresion en el archivo de texto
                NUMBERS_WRITE_IN_FILE decimal_txt,contador_pila

                inc contador_decimales

                JMP FOR_DECIMALES_TXT


            FIN_DECIMALES_TXT:
            ;/////////////////////////////////


            WRITE_IN_FILE txt_nueva_linea,3D



            ; **** escritura de la mediana obtenida ****
            WRITE_IN_FILE txt_mediana,9D
            ;impresion de la parte entera
            NUMBERS_WRITE_IN_FILE mediana_parte_entera,contador_pila
            ; punto
            WRITE_IN_FILE txt_punto_decimal,1D 
            ; parte decimal
            NUMBERS_WRITE_IN_FILE mediana_parte_decimal,contador_pila
            ;
            WRITE_IN_FILE txt_nueva_linea,3D



            ; **** escritura de la moda obtenida ****
            WRITE_IN_FILE txt_moda,6D
            ; numero de moda obtenido
            NUMBERS_WRITE_IN_FILE moda,contador_pila
            ;
            WRITE_IN_FILE txt_nueva_linea,3D



            ; **** escritura del maximo obtenido ****
            WRITE_IN_FILE txt_maximo,8D
            ;
            NUMBERS_WRITE_IN_FILE valor_maximo,contador_pila
            ;
            WRITE_IN_FILE txt_nueva_linea,3D




            ; **** escritura del minimo obtenido *****
            WRITE_IN_FILE txt_minimo,8D
            ;
            NUMBERS_WRITE_IN_FILE valor_minimo,contador_pila
            ;
            WRITE_IN_FILE txt_nueva_linea,3D


            ;-- separacion
            WRITE_IN_FILE txt_nueva_linea,3D
            WRITE_IN_FILE txt_nueva_linea,3D
            WRITE_IN_FILE txt_nueva_linea,3D




            ; escritura de la tabla de frecuencia
            WRITE_IN_FILE txt_tabla_frecuencia,23D



            MOV contador_escritura_frecuencia,0D
            ;-> escritura de tabla de frecuencia
            FOR_ESCRIBIR_TABLA_FRECUENCIA:

                MOV cx,contador_escritura_frecuencia

                ; comparacion para condicion de salida
                CMP cx,tamanio_vector_frecuencia
                JE FIN_ESCRIBIR_TABLA_FRECUENCIA


                ; obtener los valore para escribir
                GET_NUMBER_BINARY vector_frecuencia,contador_escritura_frecuencia,numero_frecuencia_a_escribir
                ;
                GET_NUMBER_BINARY numero_frecuencia,contador_escritura_frecuencia,valor_de_frecuencia_a_escribir


                ;---- escritura en el archivo de texto 

                ; numero de la frecuencia del numero
                NUMBERS_WRITE_IN_FILE numero_frecuencia_a_escribir,contador_pila

                ; SEPARADOR
                WRITE_IN_FILE txt_separador_frecuencia,6D

                ;valor de la frecuencia
                NUMBERS_WRITE_IN_FILE valor_de_frecuencia_a_escribir,contador_pila

                ;salto linea
                WRITE_IN_FILE txt_nueva_linea,3D



                ; incremento para cambiar a la siguiente posicion 
                INC contador_escritura_frecuencia

                ; repite el ciclo 
                JMP FOR_ESCRIBIR_TABLA_FRECUENCIA



            FIN_ESCRIBIR_TABLA_FRECUENCIA:





            ; si hay error en la escritura del archivo, CF=1
            jc error_escritura_reporte

            jmp fin_creacion_reporte




        ;  si s eencuentra un error en la creacion del archivo
        error_creacion_archivo: 
             PRINT salto_linea
             PRINT msg_error_creacion_archivo  
             PAUSA_PANTALLA
             jmp fin_creacion_reporte
            ;  jmp ingreso_comando 

            
            

        ; si se genera un error duarante la escirtura del archivo    
         error_escritura_reporte:
             PRINT salto_linea
             PRINT msg_error_escritura_archivo
             PAUSA_PANTALLA 
             jmp fin_creacion_reporte
            ;  jmp ingreso_comando




        ; cierre del archivo 
        fin_creacion_reporte:
            mov ah,3eh
            mov bx,handler2
            int 21h

            PRINT msg_exito_reporte
            PRINT salto_linea



        ; finalizacion de la generacion del reporte - regresa a pedir otro comando
        jmp ingreso_comando



    



    ;************************************************************************************************************ 
    ; -> se a ingresado el comando para ver la informacion por pantalla
    comando_informacion:
        PRINT salto_linea
        PRINT msg_informacion
        PRINT salto_linea
        jmp ingreso_comando






    ;************************************************************************************************************ 
    ; -> se a ingresado el comando para abrir un archivo
    comando_abrir:
        ;REINICIO DE VARIABLES PARA LA LECTURA DE UN NUEVO VECTOR 
        MOV posicion_en_comando,6D
        MOV posicion_nombre_archivo,0D
        MOV contador_numeros_entrada,0D
        MOV posicion_vector_entrada,0D
        MOV size_vector,0D

        ;PRINT msg_apertura_archivo
        ;PAUSA_PANTALLA
        ;PRINT salto_linea
        
        ; -> extraer el nombre del archivo
        for_obtener_ruta: 
        
            ;desde la posicion despues del _  
            ; parametros: vector_origen, posicion, variable donde depositar
            GET_CARACTER_VECTOR comando_entrada,posicion_en_comando,caracter
            
            ; me muevo a la siguiente posicion del comando ingresado
            inc posicion_en_comando 
            
            ; el caracter obtenido del comando
            ;PRINT caracter     
            
            ;parametros: vector origen, posicion, caracter
            SET_CARACTER_VECTOR nombre_archivo,posicion_nombre_archivo,caracter
            inc posicion_nombre_archivo
            
            
            ; condicion de salida
            cmp caracter,0
            je fin_obtener_ruta
            jmp for_obtener_ruta
            
            
        ;->se termino de obtener la ruta
        fin_obtener_ruta: 
           ;PAUSA_PANTALLA
           PRINT nombre_archivo
           PRINT salto_linea
           mov posicion_en_comando,6d ;incio de donde tiene que estar el nombre del archivo   

            
        ; - apertura y lectura del archivo
        mov ah,3dh
        mov al,0
        mov dx, offset nombre_archivo
        int 21h
        jc error1
        mov handler,ax
        

        ;-> comieza la lectura uno a uno del archivo
        leer:
            mov ah,3fh
            mov bx,handler
            mov dx,offset fragmento
            mov cx,1
            int 21h
            
            jc error2
            
            ;EOF del archivo 
            ;salta para cerrar un archivo
            cmp ax,0
            jz cerrar_archivo
            
            ; caracter < ej: <>49<L>
            cmp fragmento,60
            je separador
            
            ; mayor al rango :
            cmp fragmento,57
            jg no_es_numero
            
            ; menor al rango /
            cmp fragmento,48
            jl no_es_numero
            
            ; la lectura es un digito
            jmp es_numero
            
            
        ;-> verificaicon la lectura es un numero
        es_numero: 
            ; PRINT fragmento
            inc contador_numeros_entrada
            
            ;-> se toma el fragmento y se empuja a la pila
            mov bl,fragmento
            push bx
            ;PAUSA_PANTALLA
            
            jmp leer
            

        ;-> la lectura no es un numero    
        no_es_numero:
            jmp leer
            

        ;-> finalizacion de la lectura de un numero     
        separador:
         
            ; -> contador de numeros leidos 
            cmp contador_numeros_entrada,0
            je leer
            
            ; PRINT_CARACTER '-'
            
            ; -> union de los numeros
            ; -> comparacion para saber cuantos digitos hay que unir
            
            ; -> tres digitos leidos
            CMP contador_numeros_entrada,3d
            je tres_unidades
            
            
            ; -> dos digitos leidos
            CMP contador_numeros_entrada,2d
            je dos_unidades
            
            
            ; -> un digito leido
            CMP contador_numeros_entrada,1d
            je una_unidad  
            
            
            mov contador_numeros_entrada,0
            jmp leer
        
        
        
        ;-> numero leido del archivo de entrada es un digito
        una_unidad:
            pop bx
            sub bl,30h
            mov al,1d
            mul bl
            mov aux_unidades,al    
            
            
            mov respaldo_registro_ax,ax
            mov ax,posicion_vector_entrada
            mov cx,2
            mul cx
            mov si,ax
            mov ax,respaldo_registro_ax
            mov vector_entrada[si],ax
            
            ; incremento la posicion en el vector de entrada
            inc posicion_vector_entrada 
            
            ; incremento el size del vector
            inc size_vector
            
            ; se vuelve 0 el contador de numeros leidos en el archivo
            mov contador_numeros_entrada,0             
            
            ; salta para seguir leendo el archivo de entrada
            jmp leer
            
        
        
        ;-> numero leido del archivo de entrada es dos digitos
        dos_unidades: 
        
            pop bx
            sub bl,30h
            mov al,1d
            mul bl
            
            mov aux_unidades,al
            
            pop bx
            sub bl,30h
            mov al,10d
            mul bl
            
            ; numero de dos unidades guardado en al
            add al,aux_unidades
            
            mov respaldo_registro_ax,ax
            mov ax,posicion_vector_entrada
            mov cx,2
            mul cx
            mov si,ax
            mov ax,respaldo_registro_ax
            mov vector_entrada[si],ax
            
            ; incremento la posicion en el vector de entrada
            inc posicion_vector_entrada 
            
            ; incremento el size del vector
            inc size_vector
            
            ; se vuelve 0 el contador de numeros leidos en el archivo
            mov contador_numeros_entrada,0             
            
            ; salta para seguir leendo el archivo de entrada
            jmp leer
        
        
        ;-> numero leido del archivo de entrada es de tres digitos
        tres_unidades:  
        
            ;PAUSA_PANTALLA
        
            mov aux_unidades,0 
        
            pop bx
            sub bl,30h
            mov al,1d
            mul bl            
            mov aux_unidades,al
            
            
            pop bx
            sub bl,30h
            mov al,10d
            mul bl            
            add al,aux_unidades            
            mov aux_unidades,al
            
            
            pop bx
            sub bl,30h
            mov al,100d
            mul bl 
            
            mov cx,0
            mov cl,aux_unidades                 
            add ax,cx   ;problemas algunos numeros 
            
            mov aux_unidades2,ax
            
            ;PAUSA_PANTALLA 
            
            
            mov respaldo_registro_ax,ax
            mov ax,posicion_vector_entrada
            mov cx,2
            mul cx
            mov si,ax
            mov ax,respaldo_registro_ax
            mov vector_entrada[si],ax
            
            ; incremento la posicion en el vector de entrada
            inc posicion_vector_entrada
            
            ; incremento el size del vector
            inc size_vector
            
            ; se vuelve 0 el contador de numeros leidos en el archivo
            mov contador_numeros_entrada,0
            
            ; salta para seguir leendo el archivo de entrada
            jmp leer
        
        
            
        ;-> error en la apertura de un archivo    
        error1:
            PRINT salto_linea
            PRINT msg_error1
            PAUSA_PANTALLA
            jmp ingreso_comando
            
        
        ;-> error en la lectura de un archivo    
        error2:
            PRINT salto_linea
            PRINT msg_error2
            PAUSA_PANTALLA
            
            
        ;->cierre de un archivo    
        cerrar_archivo:
            mov ah,3eh
            mov bx,handler
            int 21h
                                                  
                                                  
        ; -> finalizacion de la lectura del archivo de entrada
        ; -> impresion de prueba de los numeros almacenados en el vector binario
        PAUSA_PANTALLA 
        PRINT salto_linea
        
        ; -> imprimir vector donde se guardo la lectura
        IMPRIMIRVECTOR vector_entrada,size_vector
           
        

        ; -> salida para pedir otro comando
        PRINT salto_linea
        PRINT salto_linea
        jmp ingreso_comando
    

    ;************************************************************************************************************ 
    ; --> opcion de salida
    salir:  
        .exit


end