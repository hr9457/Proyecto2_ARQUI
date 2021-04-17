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


    ; -> informacion para mostar por pantalla
    msg_informacion db 'ARQUITECTURA DE COMPUTADORES Y ENSAMBLADORES 1',13,10
                    db 'SECCION A',13,10
                    db 'PRIMER SEMESTRE 2021',10,13
                    db 'HECTOR JOSUE OROZCO SALAZAR',10,13
                    db '201314296',10,13
                    db 'PROYECTO 2 ASSEMBLER',10,13,'$'
    
    
    
    msg_diferentes db 'El comando no se reconoce',10,13,'$'
    msg_iguales db 'Los comando son iguales',10,13,'$'


.code 


    mov ax,@data
    mov ds,ax



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
    

    ; --> opcion de salida
    salir:  
        .exit


end