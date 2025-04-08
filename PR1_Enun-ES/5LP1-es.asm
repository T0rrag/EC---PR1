section .note.GNU-stack noalloc noexec nowrite progbits
section .data               
;Cambiar Nombre y Apellido por vuestros datos.
developer db "Angel Torres",0

;Constante que también está definida en C.
DIMMATRIX equ 10
STONESYMBOLPLAYER1 equ 'X'
STONESYMBOLPLAYER2 equ 'O'

section .text            
;Variables definidas en ensamblador.
global developer                        

;Subrutinas de ensamblador que se llaman desde C.
global posCurBoardP1, showStonePosP1, moveCursorP1, checkAroundP1,
global insertStoneP1, checkEndP1, playP1

;Variables globales definidas en C.
extern charac, rowScreen, colScreen, row, col, mBoard, dirLines
extern neighbors, stoneSymbol, posCursor, state, newState

;Funciones de C que se llaman desde ensamblador.
extern gotoxyP1_C, printchP1_C, getchP1_C
extern printMessageP1_C

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ATENCIÓN: Recordad que en ensamblador las variables y los parámetros 
;;   de tipo 'char' deben asignarse a registros de tipo  
;;   BYTE (1 byte): al, ah, bl, bh, cl, ch, dl, dh, sil, dil, ..., r15b
;;   los de tipo 'short' deben asignarse a registros de tipo 
;;   WORD (2 bytes): ax, bx, cx, dx, si, di, ...., r15w
;;   los de tipo 'int' deben asignarse a registros de tipo 
;;   DWORD (4 bytes): eax, ebx, ecx, edx, esi, edi, ...., r15d
;;   los de tipo 'long' deben asignarse a registros de tipo 
;;   QWORD (8 bytes): rax, rbx, rcx, rdx, rsi, rdi, ...., r15
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Las subrutinas en ensamblador que debéis implementar son:
;;   posCurBoardP1, showStonePosP1, moveCursorP1
;;   checkAroundP1, insertStoneP1, checkEndP1
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Esta subrutina se proporciona ya hecha. NO LA PODÉIS MODIFICAR.
; Posicionar el cursor en la fila indicada por la variable (rowScreen) y 
; en la columna indicada por la variable (colScreen) de la pantalla,
; llamando a la función gotoxyP1_C.
; 
; Variables globales utilizadas:   
; (rowScreen): Fila de la pantalla donde posicionamos el cursor.
; (colScreen): Columna de la pantalla donde posicionamos el cursor.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
gotoxyP1:
   push rbp
   mov  rbp, rsp
   ;guardamos el estado de los registros del procesador porque
   ;las funciones de C no mantienen el estado de los registros.
   push rax
   push rbx
   push rcx
   push rdx
   push rsi
   push rdi
   push r8
   push r9
   push r10
   push r11
   push r12
   push r13
   push r14
   push r15

   call gotoxyP1_C
 
   ;restaurar el estado de los registros que se han guardado en la pila.
   pop r15
   pop r14
   pop r13
   pop r12
   pop r11
   pop r10
   pop r9
   pop r8
   pop rdi
   pop rsi
   pop rdx
   pop rcx
   pop rbx
   pop rax

   mov rsp, rbp
   pop rbp
   ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Esta subrutina se proporciona ya hecha. NO LA PODÉIS MODIFICAR.
; Mostrar un carácter guardado en la variable (charac) en la pantalla, 
; en la posición donde está el cursor, llamando a la función printchP1_C.
; 
; Variables globales utilizadas:   
; (charac): Carácter que queremos mostrar.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
printchP1:
   push rbp
   mov  rbp, rsp
   ;guardamos el estado de los registros del procesador porque
   ;las funciones de C no mantienen el estado de los registros.
   push rax
   push rbx
   push rcx
   push rdx
   push rsi
   push rdi
   push r8
   push r9
   push r10
   push r11
   push r12
   push r13
   push r14
   push r15

   call printchP1_C
 
   ;restaurar el estado de los registros que se han guardado en la pila.
   pop r15
   pop r14
   pop r13
   pop r12
   pop r11
   pop r10
   pop r9
   pop r8
   pop rdi
   pop rsi
   pop rdx
   pop rcx
   pop rbx
   pop rax

   mov rsp, rbp
   pop rbp
   ret
   

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Esta subrutina se proporciona ya hecha. NO LA PODÉIS MODIFICAR.
; Leer una tecla y guardar el carácter asociado en la variable (charac)
; sin mostrarlo en pantalla, llamando a la función getchP1_C. 
; 
; Variables globales utilizadas:   
; (charac): Carácter que leemos del teclado.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
getchP1:
   push rbp
   mov  rbp, rsp
   ;guardamos el estado de los registros del procesador porque
   ;las funciones de C no mantienen el estado de los registros.
   push rax
   push rbx
   push rcx
   push rdx
   push rsi
   push rdi
   push r8
   push r9
   push r10
   push r11
   push r12
   push r13
   push r14
   push r15

   call getchP1_C
 
   ;restaurar el estado de los registros que se han guardado en la pila.
   pop r15
   pop r14
   pop r13
   pop r12
   pop r11
   pop r10
   pop r9
   pop r8
   pop rdi
   pop rsi
   pop rdx
   pop rcx
   pop rbx
   pop rax
   
   mov rsp, rbp
   pop rbp
   ret 


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Posiciona el cursor en el tablero en la posición del cursor.
; Posicionar el cursor en el tablero en función de la variable
; (posCursor) llamando la subrutina gotoxyP1.
; La fila donde posicionamos el cursor (rowScreen) se calcula con la fórmula:
; (rowScreen = 7 + (posCursor/DIMMATRIX))*2
; La columna donde posicionamos el cursor (colScreen) se calcula con la fórmula:
; (colScreen = 8 + (posCursor%DIMMATRIX))*4
;  
; Variables globales utilizadas:	
; (rowScreen): Fila de la pantalla donde posicionamos el cursor.
; (colScreen): Columna de la pantalla donde posicionamos el cursor.
; (posCusor) : Posición del cursor dentro de la matriz mBoard.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; EX1
; Iniciamos la subrutina
posCurBoardP1:
   push rbp						;guardamos registro base en pila
   mov  rbp, rsp				;rbp = rsp
   ;guardar el estado de los registros que se modifican en esta 
   ;subrutina y que no se utilizan para devolver valores.
   push rax						;guardamos rax en pila (no es retornable) ya que lo modificaremos
   push rbx						;guardamos rbx en pila (no es retornable) ya que lo modificaremos
   push rdx						;guardamos rdx en pila (para preservar)
   
   ;cargar posición cursor en rax. Lo que indica posición en matriz.
   mov rax, [posCursor]
   
   ;Calculo de ancho de pantalla
   mov rbx, DIMMATRIX			;cargamos el valor DIMMATRIX (dimensión) en rbx
   xor rdx, rdx					;Ponemos rdx a 0 para almacenar valores
   div rbx						;dividimos rax/rbx
   shl rax, 1					;Multiplicamos rax*2 (1bit desplazado)
   add rax, 7					;SUmamos 7 para completar la fórmula pedida rowScreen 7 + (posCUrsor/Dimmatrix)*2
   mov [rowScreen], eax			;Almacenamos el valor en rowscreen usando eax (32b) porque el tamaño puede ser variable
   
   ;Calculo de alto de pantalla
   mov rax, rdx					;Usamos el resto de dividir rdx en rax. SErá nuestro posCurso % DIMMATRIX
   shl rax, 2					;Multiplicamos rax *4 (2bits desplazados)
   add rax, 8         			;SUmamos 8 al resultado para colScreen = 8 + (poscursor % DIMMATRIX)*4
   mov [colScreen], eax			;Almacenamos el valor en colscreen usando eax (32b) porque el tamaño puede ser variable
   
   ;posicionamiento de cursor con gotoxy
   call gotoxyP1				;COn go - to - x|y posicionamos el cursor en pantalla en base a rowScreen y colScreen
   
   posCurBoardP1_end:  			;final de subrutina
   ;restaurar el estado de los registros que se han guardado en la pila.
   pop rdx						;restaura rdx desde pila
   pop rbx 						;restaura rbx desde pila
   pop rax						;restaura rax desde pila
   mov rsp, rbp					;restaura rsp al valor de rbp
   pop rbp						;restaura rbp desde pila
   ret							;retornar (end)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Muestra en el tablero el símbolo del jugador (stoneSymbol) de la ficha
; jugada en la posición actual del cursor (posCursor).
; Obtener el símbolo que se debe mostrar de la matriz (mBoard)
; [mBoart+posCursor] = mBoard[row][col], donde row=posCursor/DIMMATRIX
; y col=posCursor%DIMMATRIX.
; Mostrar el símbolo (stoneSymbol) llamando a la subrutina printchP1.
;  
; Variables globales utilizadas:
; (row)        : Fila de la matriz mBoard.
; (col)        : Columna de la matriz mBoard.guardamos rax en pila (no es retornable) ya que lo modificaremos
; (posCursor)  : Posición del cursor dentro de la matriz mBoard.
; (mBoard)     : Dirección de la matriz donde guardamos las fichas introducidas. 
; (stoneSymbol): Símbolo de la ficha del jugador que está jugando.
; (charac)     : Carácter que queremos mostrar.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;EX 2

showStonePosP1:					;inicio de subrutina
   push rbp						;guardamos registro base en pila
   mov  rbp, rsp				;igualamos rbp a rsp
   ;guardar el estado de los registros que se modifican en esta 
   ;subrutina y que no se utilizan para devolver valores.
   push rax						;guardamos rax en pila (no es retornable) ya que lo modificaremos
   push rbx						;guardamos rax en pila (no es retornable) ya que lo modificaremos
   
   ;cargar posCursor
   mov rax, [posCursor]							;cargamos posición de cursor en rax para indicar la posición en el tablero	
   
   ;Asignar símbolos en mBoard
   mov rbx, mBoard								;cargamos tablero en rbx
   mov bl, [rbx + rax]							;usamos el símbolo almacenado anteriormente y lo pasamos a bl (rbx lowest)
   mov [stoneSymbol], bl						;pasamos dicho bit obtenido a la variable stoneSymbol.
   
   ;llevar ese símbolo a caracteres y mostrar en pantalla
   mov al, [stoneSymbol]						;cargamos stoneSymbol en al (rax lowest) para usarlo
   mov [charac], al								;lo almacenamos en la variable global charac(ter) para mostrar en pantalla el símbolo X-0.
   
   ;print
   call printchP1								;print el character almacenado en la posCUrsor actual
    
   showStonePosP1_end:  						;fin de rutina
   ;restaurar el estado de los registros que se han guardado en la pila.
   pop rbx						;restaura rbx desde pila
   pop rax						;restaura rax desde pila
   mov rsp, rbp					;restaura rsp al valor de rbp
   pop rbp						;restaura rbp desde pila
   ret							;retornar (end)
 
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Actualizar la posición donde está el cursor (posCursor) según
; el carácter (charac) leído de teclado:
; 'i' Arriba, 'j' Izquierda, 'k' Abajo, 'l' Derecha.
; Actualizar la posición del cursor (posCursor)
; controlando que no salga del tablero [0..(DIMMATRX*DIMMATRIX-1)].
; (row) [0..(DIMMATRX-1] - (col) [0..(DIMMATRX-1]
;  
; Variables globales utilizadas:
; (row)        : Fila de la matriz mBoard.
; (col)        : Columna de la matriz mBoard.
; (posCursor)  : Posición del cursor dentro de la matriz mBoard.
; (charac)     : Carácter que queremos mostrar.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;EX 3
moveCursorP1:							;inicio subrutina
   push rbp								;guardamos valor de registro base en pila
   mov  rbp, rsp						;gualamos rbp a rsp
   ; Guardar registros que se modifican
   push rax								;guardamos rax en pila (no es retornable) ya que lo modificaremos
   push rbx								;guardamos rbx en pila (no es retornable) ya que lo modificaremos
   push rdx								;guardamos rdx en pila (no es retornable) ya que lo modificaremos

   ;Cargar caracteres y posición de cursor
   mov al, [charac]						;cargamos el character que se introducirá
   mov rbx, [posCursor]					;cargamos la posición del cursor en rbx

   ;PUnto de comparación 'i' (arriba)
   ;puntos considerados, si i>=10 (incluye row0)
   ;if menor = no mover
   ;else y+10
   cmp al, 'i'
   jne moveCursorP1_check_j
   cmp rbx, DIMMATRIX
   jl moveCursorP1_end
   sub rbx, DIMMATRIX  
   jmp moveCursorP1_update

moveCursorP1_check_k:
   ;PUnto de comparación 'k' (abajo)
   ;si poscursor < 9 (fila)
   ;y-1
   ;else, no mover
   cmp al, 'k'
   jne moveCursorP1_check_l
   cmp rbx, DIMMATRIX * (DIMMATRIX - 1)
   jge moveCursorP1_end
   add rbx, DIMMATRIX 
   jmp moveCursorP1_update

moveCursorP1_check_j:
   ;PUnto de comparación 'j' (izquierda)
   ;rax = posición cursor || rdx = posCUrsor /100
   ;si columna = 0, no mover
   ;else X-1
   cmp al, 'j'
   jne moveCursorP1_check_k
   mov rax, rbx
   xor rdx, rdx
   mov rbx, DIMMATRIX
   idiv rbx
   cmp rdx, 0
   je moveCursorP1_end
   mov rbx, [posCursor]
   dec rbx
   jmp moveCursorP1_update

moveCursorP1_check_l:
   ;PUnto de comparación 'l' (derecha)
   ;rax = posición cursor || rdx = posCUrsor /100
   ;si columna = 9, no mover
   ;else X+1
   cmp al, 'l'
   jne moveCursorP1_end
   mov rax, rbx 
   xor rdx, rdx
   mov rbx, DIMMATRIX
   idiv rbx
   cmp rdx, DIMMATRIX - 1 
   je moveCursorP1_end
   mov rbx, [posCursor]
   inc rbx 
   jmp moveCursorP1_update

moveCursorP1_update:
   mov [posCursor], rbx			;Actualizar posCursor si el movimiento es válido

moveCursorP1_end:
   ; Restaurar registros
   pop rdx						;restaura rdx desde pila
   pop rbx 						;restaura rbx desde pila
   pop rax						;restaura rax desde pila
   mov rsp, rbp					;restaura rsp al valor de rbp
   pop rbp						;restaura rbp desde pila
   ret							;retornar (end)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Contar cuántas casillas están ocupadas (!=' ') alrededor de la
; posición actual del cursor (posCursor) en la matriz (mBoard), en todas
; las direcciones, indicadas en el vector (dirLines) con el valor que
; debemos modificar la posición actual para seguir aquella dirección.
; dirección: 0           1             2             3             4           5        6   7
;    { -DIMMATRIX-1, +DIMMATRIX+1, +DIMMATRIX-1, -DIMMATRIX+1, -DIMMATRIX, +DIMMATRIX, -1, +1}
;       superior      inferior      inferior      superior      superior    inferior  izq. derecha
;       izquierda     derecha       izquierda     derecha
; Mientras no hayamos mirado todas las direcciones (dir<8) hacer:
;   Obtenemos la posición de la casilla que queremos mirar (nextPos) con
;   el incremento indicado en la matriz (dirLines) de la dirección que
;   estamos mirando (dir) (nextPos = posCursor + dirLines[dir]).
;   Si la fila y la columna están dentro del tablero
;   ((nextRow > 0) && (nextRow < DIMMATRIX)) ((nextCol>=0 && (col-nextCol) >= -1) && ((col-nextCol) <= 1))
;   y aquella casilla de la matriz (mBoard) no está vacía (!=' ')
;     Incrementamos (neighbors++).
;   Incrementamos (decir) para mirar en la siguiente dirección.
; Actualizamos (neighbors) para indicar cuántas casillas ocupadas
; hay alrededor de la posición actual.
; 
; 
; Variables globales utilizadas:	
; (neighbors): Indica cuantas casillas ocupadas hay alrededor de la posición actual.
; (row)      : Fila de la matriz mBoard.
; (col)      : Columna de la matriz mBoard.
; (posCursor): Posición del cursor dentro de la matriz mBoard.
; (mBoard)   : Dirección de la matriz donde guardamos las fichas introducidas. 
; (dirLines) : Dirección de la matriz que indica el incremento que se debe hacer a la posición actual para seguir una dirección.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;EX 4

checkAroundP1:
   push rbp					;guardamos registro base rbp en pila
   mov  rbp, rsp			;igualamos rbp a rsp
   push rax					;guardamos rax en pila
   push rbx					;guardamos rbx en pila
   push rcx					;guardamos rcx en pila -nuestro counter-
   push rdx					;guardamos rdx en pila
   push rsi					;guardamos rsi en pila

   xor ecx, ecx				;ponemos ecx a 0 para iniciar el contador.
   mov DWORD [neighbors], 0 ;inicializar vecinos a 0, guardo aquí el nº de vecinos

checkAroundP1_loop:			;inicio de bucle
   cmp ecx, 8				;comparamos ecx con las direcciones (8)
   jge checkAroundP1_end	;si ecx >= 8 el bucle termina

   mov rax, [posCursor]		;cargamos la posición del cursor en rax
   mov rbx, dirLines		;cargamos dirección de desplzamientos
   mov rsi, rcx				;copiamos counter ecx a rsi
   shl rsi, 3				;desplazamos 3 bits
   add rax, [rbx + rsi]		;sumamos el desplazamiento a la dirección actual

   mov rbx, DIMMATRIX		;cargamos dimmatrix en rbx para dividir
   xor rdx, rdx				;limpiamos valores de rdx (a 0)
   div rbx					;dividimos rax/DIMMATRIX (rax = fila || rdx = columna)

   cmp rax, 0				;comparamos fila con 0
   jl checkAroundP1_next	;si fila < 0 pasamos a la siguiente
   cmp rax, DIMMATRIX-1		;si fila
   jg checkAroundP1_next	;        > DIMMATRIX-1 saltamos a la siguiente
   cmp rdx, 0				;comparamos columna con 0
   jl checkAroundP1_next	;si columna < 0, pasamos a la siguiente
   cmp rdx, DIMMATRIX-1		;si columna
   jg checkAroundP1_next	;			> DIMMATRIX-1 saltamos a la siguiente

   mov rbx, mBoard			;cargamos board en rbx
   mov rsi, rax				;copia fila a rsi para calcular index en board
   imul rsi, DIMMATRIX		;multiplicamos rsi por DIMMATRIX para tener desplazamiento de fila
   add rsi, rdx				;suma columna rdx a desplazamiento (índice lineal)
   cmp BYTE [rbx + rsi], ' ';comparamos byte en board con espacio
   je checkAroundP1_next	;si es espacio (no neighbors) siguiente
   inc DWORD [neighbors]	;si no hay espacio (neighbors) counter +1

checkAroundP1_next:			;siguiente iteración del bucle
   inc ecx					;incrementa el contador
   jmp checkAroundP1_loop	;salto al inicio de bucle para continuar

checkAroundP1_end:			;final de subrutina
   pop rsi					;restaura rsi desde pila
   pop rdx					;restaura rdx desde pila
   pop rcx					;restaura rcx desde pila
   pop rbx					;restaura rbx desde pila
   pop rax					;restaura rax desde pila
   mov rsp, rbp				;restaura rsp a valor de rbp
   pop rbp					;restaura rbp desde pila
   ret						;retorna(end)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Insertar la ficha (stoneSymbol) del jugador, indicado por la
; variable (state), en la posición donde está el cursor (posCursor)
; en la matriz (mBoard), si la posición está vacía (' ') y
; las casillas de alrededor no están vacías.
; Si en la posición actual del cursor (posCursor) no hay ninguna ficha
; (mBoard[row][col]==' ') miramos si las casillas de alrededor de la posición
; actual (posCursor) no están vacías llamando a la subrutina checkAroundP1().
; Si podemos introducir la ficha (neighbors > 0):
;   Si el estado del juego es (state==1) el (stoneSymbol = STONESYMBOLPLAYER1),
;   si el estado del juego es (state==2) el (stoneSymbol = STONESYMBOLPLAYER2).
;   Poner el símbolo (stoneSymbol) en la matriz (mBoard) en la posición
;   donde está el cursor (posCursor).
;   Cambiamos de jugador, de jugador 1 a jugador 2 y de jugador 2 a judador 1
;   (state = 3 - state).
; 
; Variables globales utilizadas:	
; (row)        : Fila de la matriz mBoard.
; (col)        : Columna de la matriz mBoard.
; (posCursor)  : Posición del cursor dentro de la matriz mBoard.
; (stoneSymbol): Símbolo de la ficha del jugador que está jugando.
; (mBoard)     : Dirección de la matriz donde guardamos las fichas introducidas. 
; (state)      : Estado del juego.
; (newState)   : Estado del juego.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;EX 5

insertStoneP1:				;inicio de subrutina	
   push rbp					;guardamos valor de registro base en pila
   mov  rbp, rsp			;rbp = rsp
   push rax					;guardamos rax en pila
   push rbx					;guardams rbx en pila

   mov rbx, mBoard						;carga board en brbx
   mov rax, [posCursor]					;carga posición cursor en rax
   cmp BYTE [rbx + rax], ' '			;compara byte en board con espacio (si vacío)
   jne insertStoneP1_end				;SI no está vacío pasamos al final

   call checkAroundP1					;llamada a función checkaround para comprobar vecinos
   cmp DWORD [neighbors], 0				;comparamos los vecinos con 0
   jle insertStoneP1_end				;si vecinos <=0 pasamos al final

   mov ax, [state]						;cargamos el estado del juego actual en ax (jugador)
   cmp ax, 1							;compara state 1 con player 1
   jne insertStoneP1_p2					;else player 2
   mov al, STONESYMBOLPLAYER1			;carga símbolo player 1
   jmp insertStoneP1_set				;salta a la dirección del símbolo
insertStoneP1_p2:						;etiqueta de player 2
   mov al, STONESYMBOLPLAYER2			;carga símbolo player 2
insertStoneP1_set:						;poner símbolo en matriz
   mov [rbx + rax], al					;almacena símbolo en board
   mov [stoneSymbol], al				;guarda símbolo en variable global (stoneSymbol)

   mov ax, 3							;carga 3 en ax para calcular nuevo estado
   sub ax, [state]						;resta al estado actual 3.
   mov [newState], ax					;el resultado es el nuevo estado (newState)

insertStoneP1_end:				;final de subrutina
   pop rbx						;restaura valor original rbx desde pila
   pop rax						;restaura valor original rax desde pila
   mov rsp, rbp					;el valor de rsp pasa al valor de rbp
   pop rbp						;restaura valor original rbp desde pila
   ret							;fin de subrutina

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Verifica si el tablero está lleno y no se puede seguir jugando.
; Recorremos todo el tablero (mBoard) para mirar si está lleno,
; DIMMATRIX*DIMMATRIX posiciones.
;   El tablero está lleno si todas las posiciones de la matriz (mBoard)
;   son diferentes de ' '.
;   Si está lleno, hemos recorrido todo el tablero y no hay ningún espacio,
;   pondremos (state=5) para indicar que el tablero está lleno
;   y no se puede seguir jugando.
; 
; Variables globales utilizadas:	
; (mBoard): Dirección de la matriz donde guardamos las fichas introducidas. 
; (state) : Estado del juego.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;EX 6	
checkEndP1:							;inicio subrutina
   push rbp							;guardamos valor de registro base en pila
   mov  rbp, rsp					;rbp = rsp
   ;guardar el estado de los registros que se modifican en esta 
   ;subrutina y que no se utilizan para devolver valores.
   push rax							;guardamos rax en pila
   push rbx							;guardams rbx en pila
   push rcx							;guardams rcx en pila
   
   ;init counter
   xor rcx, rcx						;ponemos a 0 el counter (rcx)
   
   checkEndP1_loop:					;inicio bucle
   cmp rcx, DIMMATRIX * DIMMATRIX	;comparamos rcx con tamaño de matriz
   jge checkEndP1_full				;si rcx >= tamaño total = tablero lleno pasamos a checkENdP1_full
  
  ;check si tiene espacio
  mov rbx, mBoards					;cargamos dirección board en rbx
  mov al, [rbx + rcx]				;cargamos posición actual en al
  cmp al, ' '						;comparamos con espacio
  je checkEndP1_end					;si hay espacio pasamos a siguiente instrucción
  
  inc rcx							;incremento rcx para pasar a siguiente posición en matriz
  jmp checkEndP1_loop				;salto al inicio del bucle para seguir revisando
  
  checkEndP1_full:					;si el tablero está lleno, pasamos a state 5
  mov WORD [state], 5				;var global a state 5 (full)
  
   checkEndP1_end:					;fin de subrutina
   ;restaurar el estado de los registros que se han guardado en la pila.
   pop rcx							;restaura valor original rcx desde pila
   pop rbx							;restaura valor original rbx desde pila
   pop rax							;restaura valor original rax desde pila
   mov rsp, rbp						;el valor de rsp pasa al valor de rbp
   pop rbp							;restaura valor original rbp desde pila
   ret								;fin de subrutina

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  Muestra un mensaje en la parte inferior del tablero según el 
; valor de la variable (state).
; (state) 0: Se ha presionado ESC para salir 
;         1: Juega el jugador 1.
;         2: Juega el jugador 2.
;         3: El jugador 1 ha hecho 5 en línea.
;         4: El jugador 2 ha hecho 5 en línea.
;         5: El tablero está lleno. Empate.
; 
; Variables globales utilizadas:	
; (state): Estat del joc.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
printMessageP1:
   push rbp
   mov  rbp, rsp
   ;guardamos el estado de los registros del procesador porque
   ;las funciones de C no mantienen el estado de los registros.
   push rax
   push rbx
   push rcx
   push rdx
   push rsi
   push rdi
   push r8
   push r9
   push r10
   push r11
   push r12
   push r13
   push r14
   push r15

   call printMessageP1_C
 
   ;restaurar el estado de los registros que se han guardado en la pila.
   pop r15
   pop r14
   pop r13
   pop r12
   pop r11
   pop r10
   pop r9
   pop r8
   pop rdi
   pop rsi
   pop rdx
   pop rcx
   pop rbx
   pop rax

   mov rsp, rbp
   pop rbp
   ret



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Subrutina principal del juego
; Muestra el tablero de juego y deja hacer las jugadas de los 2 jugadores,
; alternativamente, hasta que uno de los dos jugadores pone 5 fichas en raya
; o el tablero queda lleno y nadie ha hecho un 5 en raya.
;
; Pseudo-código:
; Mostrar un mensaje según el estado del juego (state) llamando a
; la subrutina printMessageP1.
; Mientras estén jugando el jugador 1 (state=1) o el jugador 2 (state=2) hacer:
;   Posicionar el cursor en el tablero en la posición indicada por la variable
;   (posCursor) llamando a la subrutina posCurBoardP1.
;   Leer una tecla llamando a la subrutina getchP1.
;   Si la tecla leída es 'i', 'j', 'k' o 'l' mover el cursor sin
;   salir del tablero llamando a la subrutina moveCursorP1.
;   Si la tecla leída es ' ' comprobar si la las casillas que hay
;   alrededor de la posición actual hay alguna ficha llamando
;   a la subrutina checkAroundP1.
;     Si hay alguna posición ocupada (neighbors>0)
;       Insertar la ficha en el tablero (mBoard) en la posición actual del
;       cursor (posCursor) llamando a la subrutina insertStoneP1.
;       Si se ha introducido la ficha, (state != newState)
;         Mostrar la ficha que se ha insertado en el tablero (mBoard) en la posición
;         actual del tablero (posCursor) llamando a la subrutina showStonePosP1.
;         Verificar si el tablero está lleno llamando la subrutina checkEndP1.
;       Si el tablero está lleno (state <= 2)
;       actualizar el estado del juego (state = newState).
;   Si la tecla es ESC(ASCII 27) poner (state=0) para indicarlo.
; Mostrar un mensaje según el estado del juego (state) llamando
; a la subrutina printMessageP1.
; Se termina el juego.
; 
; Variables globales utilizadas:	
; (posCursor): Posición del cursor dentro de la matriz mBoard.	
; (state)    : Estado del juego.
; (newState) : Estado del juego.
; (charac)   : Carácter leído de teclado.
; (neighbors): Indica cuantas casillas ocupadas hay alrededor de la posición actual.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
playP1:
   push rbp
   mov  rbp, rsp
   ;guardar el estado de los registros que se modifican en esta 
   ;subrutina y que no se utilizan para devolver valores.
   push rax
   push rbx
   push rcx
   push rdx
   push r8
   push r9
   push r10
   push r11
   
   mov QWORD[posCursor], 44   ;long  posCursor = 44; 
   mov WORD[state], 1         ;short state = 1; // Estado del juego
   mov bx, WORD[state]        ;// 0: Se ha presionado ESC para salir 
                              ;// 1: Juega el jugador 1.
                              ;// 2: Juega el jugador 2.
                              ;// 3: El jugador 1 ha hecho 5 en línea.
                              ;// 4: El jugador 2 ha hecho 5 en línea.
                              ;// 5: El tablero está lleno. Empate. 
   mov WORD[newState], bx     ;newState = state; 
                      
   call printMessageP1        ;printMessageP1_C();
   playP1_while:
   cmp bx, 1                  ;while (state == 1 
   je  playP1_loop
     cmp bx, 2                ;|| state ==2  ) {
     jne playP1_end
     playP1_loop:
       call posCurBoardP1     ;posCurBoardP1_C();
       call getchP1           ;getchP1_C();
       mov al, BYTE[charac]  
       playP1_move:
       cmp al, 'i'            ;if (charac >= 'i'  
       jl  playP1_insert
         cmp al, 'l'          ;&& charac <= 'l') {
         jg playP1_insert
           call moveCursorP1  ;moveCursorP1_C(c);
       jmp playP1_endwhile;}
       playP1_insert:      
       cmp al, ' '            ;if (charac == ' ' ) {
       jne playP1_esc
         call checkAroundP1   ;checkAroundP1_C();
         cmp DWORD[neighbors], 0;if (neighbors  > 0) {
         jle playP1_noneighbours
           call insertStoneP1  ;insertStoneP1_C();
           cmp bx, WORD[newState];if(state != newState){ //new stone inserted
           je  playP1_notinserted
             call showStonePosP1;showStonePosP1_C();
             call checkEndP1  ;checkEndP1_C();
             mov bx, WORD[state]
           playP1_notinserted:;}
           cmp bx, 2          ;if (state <= 2) 
           jg  playP1_newstate
             mov bx, WORD[newState];state = newState;
             playP1_newstate: ;}
         playP1_noneighbours: ;}
       jmp playP1_endwhile    
       playP1_esc:
       cmp al, 27             ;if (charac == 27) {
       jne playP1_noesc
         mov bx, 0           ;state = 0;
       playP1_noesc:         ;} 
     playP1_endwhile:        ;}
     mov WORD[state], bx
     call printMessageP1     ;printMessageP1_C();  
     jmp playP1_while 
   playP1_end: 
  ;restaurar el estado de los registros que se han guardado en la pila.
   pop r10
   pop r9
   pop r8
   pop rdx
   pop rcx
   pop rbx
   pop rax

   mov rsp, rbp
   pop rbp
   ret
