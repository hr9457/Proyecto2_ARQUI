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




;--------------------------------------------------------------- programa general ----------------------------------------------------------------------
.model small
.stack
.data


    ; --> para imprimir un salto de liena por consola
    salto_linea db ' ',10,13,'$' 


    ; --> comando para mostara por consola
    comando_consola db 'consolap2> ','$'



    ; --> arranque del programa
    inicio:



    ; --> opcion de salida
    salir:
        .exit


end