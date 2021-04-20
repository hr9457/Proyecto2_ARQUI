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
    MOV cantidad_numero_en_pila, 0  ; Contador auxiliar que nos servira más adelante para sacar los valores de la pila 
    
    lRes:
        CMP AX, 0
        JE efinCalcN ; al cumplirse la condicion salimos del ciclo
        
        ; Dividimos entre 10
        MOV AX, numero_aux_entrada
        MOV resultado_division, 10D
        CWD
        DIV resultado_division

        PUSH DX ; Agregamos el residuo
        MOV numero_aux_entrada, AX ; Asignamos el cociente que nos servira en la proxima iteración
        INC cantidad_numero_en_pila ; Incrementamos en 1 que luego nos servira para sacar los valores de la pila
        ;PAUSA
    JMP lRes    
    
    eFinCalcN:    
    ; Ciclo para imprimir el resultado de la operación
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
    mov vector_entrada[si],ax  
    
endm
; - - - - - - - - - - - - - -- - - - - - - - - - - - - - - - - - - - - - - - - 



; =============== macro para recorrer el vector
ORDENAMIENTO_BURBUJA_ASC macro vector,size_vector
    
   local for_burbuja,intercambio,fin_burbuja_j,fin_burbuja

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



.code 


    mov ax,@data
    mov ds,ax


    ; --> limpieza de la pantalla para empezar el programa
    LIMPIAR_PANTALLA


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
       

        
    ; -> cuando los token no coniciden    
    diferente:
        PRINT msg_diferentes
        .exit              
       
    ; -> se a ingresado el comando cprom
    comando_cprom:
        PRINT msg_iguales
        jmp ingreso_comando
        
        
    ; -> se a ingreado el comando cmediana
    comando_cmediana:
        PRINT msg_iguales
        jmp ingreso_comando               
        
    ; -> se a ingreado el comando cmoda
    comando_cmoda:
        PRINT msg_iguales
        jmp ingreso_comando    
        
                           
    ; -> se a ingreado el comando cmax
    comando_cmax:
        PRINT msg_iguales
        jmp ingreso_comando                       
    
    ; -> se a ingresado el comando cmin
    comando_cmin:
        PRINT msg_iguales
        jmp ingreso_comando
    
        
    ; -> se a ingresado el comando gbarra_asc
    comando_gbarra_asc:
        PRINT msg_iguales
        jmp ingreso_comando
            
        
    ; -> se a ingresado el comando gbrarra_des
    comando_gbarra_desc:
        PRINT msg_iguales
        jmp ingreso_comando    
        
        
    ; -> se a ingresado el comando ghist
    comando_ghist:
        PRINT msg_iguales
        jmp ingreso_comando    
        
    ; -> se a ingreado el comando glinea
    comando_glinea:
        PRINT msg_iguales
        jmp ingreso_comando
            
   
    ; -> se a ingresado el comando para limpiar
    comando_limpiar:
        LIMPIAR_PANTALLA
        jmp ingreso_comando
    
    
    ; -> se a ingresado para creacion de reportes
    comando_reporte:
        PRINT msg_iguales
        jmp ingreso_comando
    

    ; -> se a ingresado el comando para ver la informacion por pantalla
    comando_informacion:
        PRINT salto_linea
        PRINT msg_informacion
        PRINT salto_linea
        jmp ingreso_comando



    ; -> se a ingresado el comando para abrir un archivo
    comando_abrir:
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
            
            
        
        es_numero: 
            PRINT fragmento
            inc contador_numeros_entrada
            
            ;-> se toma el fragmento y se empuja a la pila
            mov bl,fragmento
            push bx
            ;PAUSA_PANTALLA
            
            jmp leer
            
            
        no_es_numero:
            jmp leer
            
            
        separador:
         
            ; -> contador de numeros leidos 
            cmp contador_numeros_entrada,0
            je leer
            
            PRINT_CARACTER '-'
            
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
        
        
        tres_unidades: 
        
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
           
        
        ; -> prueba para ver el ordenamiento burbuja ascendente
        ORDENAMIENTO_BURBUJA_ASC vector_entrada,size_vector
        PRINT salto_linea
        IMPRIMIRVECTOR vector_entrada,size_vector
        ;->*****************************************************


        ; -> salida para pedir otro comando
        PRINT salto_linea
        PRINT salto_linea
        jmp ingreso_comando
    

    ; --> opcion de salida
    salir:  
        .exit


end