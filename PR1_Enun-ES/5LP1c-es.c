/**
 * Implementación en C de la práctica, para que tengáis una
 * versión funcional en alto nivel de todas las funciones que debéis 
 * implementar en ensamblador.
 * Desde este código se realizan las llamadas a las subrutinas de ensamblador. 
 * ESTE CÓDIGO NO SE PUEDE MODIFICAR Y NO SE DEBE ENTREGAR.
 **/

#include <stdio.h>
#include <termios.h>    //termios, TCSANOW, ECHO, ICANON
#include <unistd.h>     //STDIN_FILENO

/**
 * Constantes.
 **/
#define DIMMATRIX 10
#define STONESYMBOLPLAYER1 'X'
#define STONESYMBOLPLAYER2 'O'


/**
 * Definición de variables globales.
 **/
extern int developer;//Variable declarada en assemblador que indica el nom del programador

char charac;      //Carácter leído del teclado y para escribir en pantalla.
int  rowScreen;   //Fila para posicionar el cursor en la pantalla.
int  colScreen;   //Columna para posicionar el cursor en la pantalla

int  row;         //Fila de la matriz mBoard.
int  col;         //Columna de la matriz mBoard.

int   neighbors ;
char  stoneSymbol;   //Símbolo de la ficha del jugador que está jugando.
long  posCursor = 44;//Posición donde està el cursor [0..6]
short state = 1;     // Estado del juego
                     // 0: Se ha pulsado ESC para salir   
                     // 1: Juega el jugador 1.
                     // 2: Juega el jugador 2.
                     // 3: El jugador 1 ha hecho 4 en línea. (en la P2)
                     // 4: El jugador 2 ha hecho 4 en línea. (en la P2)
                     // 5: El tablero está lleno. Empate.
short newState = 1;

//Matriz 10x10 que contiene el estado del tablero   0   1   2   3   4   5   6   7   8   9
char mBoard[DIMMATRIX][DIMMATRIX] =   {     /*0*/ {' ',' ',' ',' ',' ',' ',' ',' ',' ',' '},
                                            /*1*/ {' ',' ',' ',' ',' ',' ',' ',' ',' ',' '},
                                            /*2*/ {' ',' ',' ',' ',' ',' ',' ',' ',' ',' '},
                                            /*3*/ {' ',' ',' ',' ',' ',' ',' ',' ',' ',' '},
                                            /*4*/ {' ',' ',' ',' ','X','O',' ',' ',' ',' '},
                                            /*5*/ {' ',' ',' ',' ','O','X',' ',' ',' ',' '},
                                            /*6*/ {' ',' ',' ',' ',' ',' ',' ',' ',' ',' '},
                                            /*7*/ {' ',' ',' ',' ',' ',' ',' ',' ',' ',' '},
                                            /*8*/ {' ',' ',' ',' ',' ',' ',' ',' ',' ',' '},
                                            /*9*/ {' ',' ',' ',' ',' ',' ',' ',' ',' ',' '}};
//Modificación de la posición actual para buscar las líneas
long dirLines[8] = { -DIMMATRIX-1, +DIMMATRIX+1, +DIMMATRIX-1, -DIMMATRIX+1, -DIMMATRIX, +DIMMATRIX, -1, 1}; //pos modification


/**
 * Definición de las funciones en C.
 **/
void clearScreen_C();
void gotoxyP1_C();
void printchP1_C();
void getchP1_C();
void printMenuP1_C();
void printBoardP1_C();

void posCurBoardP1_C();
void showStonePosP1_C();
void moveCursorP1_C();
void checkAroundP1_C();
void insertStoneP1_C();
void checkEndP1_C();

void printMessageP1_C();      
void playP1_C();              

/**
 * Definición de las subrutinas en ensamblador que se llaman desde C.
 **/
void posCurBoardP1();                                           
void showStonePosP1();                 
void moveCursorP1();
void checkAroundP1();
void insertStoneP1();
void checkEndP1();

void printMessageP1();
void playP1();


/**
 * Borrar la pantalla
 * 
 * Variables globales utilizadas:   
 * Ninguna.
 * 
 * Esta función no se llama desde ensamblador
 * y no hay definida una subrutina en ensamblador equivalente.
 **/
void clearScreen_C(){
   
    printf("\x1B[2J");
    
}


/**
 * Situar el cursor en la fila indicada por la variable (rowScreen) y en 
 * la columna indicada por la variable (colScreen) de la pantalla.
 * 
 * Variables globales utilizadas:   
 * (rowScreen): Fila de la pantalla donde posicionamos el cursor.
 * (colScreen): Columna de la pantalla donde posicionamos el cursor.
 * 
 * Se ha definido una subrutina en ensamblador equivalente 'gotoxyP1' para 
 * poder llamar a esta función guardando el estado de los registros del 
 * procesador. Esto se hace porque las funciones de C no mantienen 
 * el estado de los registros.
 **/
void gotoxyP1_C(){
   
   printf("\x1B[%d;%dH",rowScreen,colScreen);
   
}


/**
 * Mostrar un carácter guardado en la variable (charac) en la pantalla, 
 * en la posición donde está el cursor.
 * 
 * Variables globales utilizadas:   
 * (charac): Carácter que queremos mostrar.
 * 
 * Se ha definido una subrutina en ensamblador equivalente 'printchP1' para
 * poder llamar a esta función guardando el estado de los registros del 
 * procesador. Esto se hace porque las funciones de C no mantienen 
 * el estado de los registros.
 **/
void printchP1_C(){

   printf("%c",charac);
   
}


/**
 * Leer una tecla y guardar el carácter asociado en la variable (charac)
 * sin mostrarlo en pantalla. 
 * 
 * Variables globales utilizadas:   
 * (charac): Carácter que leemos del teclado.
 * 
 * Se ha definido una subrutina en ensamblador equivalente 'getchP1' para
 * poder llamar a esta función guardando el estado de los registros del 
 * procesador. Esto se hace porque las funciones de C no mantienen 
 * el estado de los registros.
 **/
void getchP1_C(){

   static struct termios oldt, newt;

   /*tcgetattr obtener los parámetros del terminal
   STDIN_FILENO indica que se escriban los parámetros de la entrada estándar (STDIN) sobre oldt*/
   tcgetattr( STDIN_FILENO, &oldt);
   /*se copian los parámetros*/
   newt = oldt;

   /* ~ICANON para tratar la entrada del teclado carácter a carácter no como una línea completa acabada con /n
      ~ECHO para que no muestre el carácter leído*/
   newt.c_lflag &= ~(ICANON | ECHO);          

   /*Fijar los nuevos parámetros del terminal para la entrada estándar (STDIN)
   TCSANOW indica a tcsetattr que cambie los parámetros inmediatamente. **/
   tcsetattr( STDIN_FILENO, TCSANOW, &newt);

   /*Leer un carácter*/
   charac = (char) getchar();                 
    
   /*restaurar los parámetros originales*/
   tcsetattr( STDIN_FILENO, TCSANOW, &oldt);
   
}


/**
 * Mostrar en la pantalla el menú del juego y pedir una opción.
 * Solo acepta una de las opciones correctas del menú ('0'-'8')
 * 
 * Variables globales utilizadas:   
 * (developer):((char;)&developer): variable definida en el código ensamblador.
 * (rowScreen): Fila de la pantalla donde posicionamos el cursor.
 * (colScreen): Columna de la pantalla donde posicionamos el cursor.
 * (charac)   : Opción elegida del menú, leída del teclado.
 * 
 * Esta función no se llama desde ensamblador
 * y no hay definida una subrutina en ensamblador equivalente.
 **/
void printMenuP1_C(){
	
  clearScreen_C();
  rowScreen = 1;
  colScreen = 1;
  gotoxyP1_C();
  printf("                            \n");
  printf("      Developed by:         \n");
  printf("     ( %s )    \n",(char *)&developer);
  printf(" __________________________ \n");
  printf("|                          |\n");
  printf("|   MENU 5 IN a ROW  v1.0  |\n");
  printf("|__________________________|\n");
  printf("|                          |\n");
  printf("|     1.  posCurScreen     |\n");
  printf("|     2.  showStonePos     |\n");
  printf("|     3.  MoveCursor       |\n");
  printf("|     4.  checkAround      |\n");
  printf("|     5.  InsertStone      |\n");
  printf("|     6.  -(new in P2)-    |\n");
  printf("|     7.  CheckEnd         |\n");
  printf("|     8.  Play Game        |\n");
  printf("|     9.  Play Game C      |\n");
  printf("|     0.  Exit             |\n");
  printf("|                          |\n");
  printf("|         OPTION:          |\n");
  printf("|__________________________|\n"); 
  
  charac =' ';
  while ((charac < '0' || charac > '9') && charac!=27) {
	rowScreen = 20;
	colScreen = 19;
    gotoxyP1_C();
    getchP1_C();   
  }
   
}


/**
 * Mostrar el tablero de juego en la pantalla. Las líneas del tablero.
 * 
 * Variables globales utilizadas:	
 * (rowScreen): Fila de la pantalla donde posicionamos el cursor.
 * (colScreen): Columna de la pantalla donde posicionamos el cursor.
 * 
 * Esta función no se llama desde ensamblador
 * y no hay definida una subrutina en ensamblador equivalente.
 **/
void printBoardP1_C(){
   int i;

   clearScreen_C();
   rowScreen = 1;
   colScreen = 1;
   gotoxyP1_C();                                                 //ScreenRows   
   printf(" _________________________________________________ \n"); //01
   printf("|                                                 |\n"); //02
   printf("|                   5 IN a ROW                    |\n"); //03
   printf("|         Insert one stone next to another        |\n"); //04
   printf("|                                                 |\n"); //05
//Screen Columns  08  12  16  20  24  28  32  36  40  44   
   printf("|    +---+---+---+---+---+---+---+---+---+---+    |\n"); //06
   printf("|  0 |   |   |   |   |   |   |   |   |   |   |    |\n"); //07
   printf("|    +---+---+---+---+---+---+---+---+---+---+    |\n"); //08
   printf("|  1 |   |   |   |   |   |   |   |   |   |   |    |\n"); //09
   printf("|    +---+---+---+---+---+---+---+---+---+---+    |\n"); //10
   printf("|  2 |   |   |   |   |   |   |   |   |   |   |    |\n"); //11
   printf("|    +---+---+---+---+---+---+---+---+---+---+    |\n"); //12
   printf("|  3 |   |   |   |   |   |   |   |   |   |   |    |\n"); //13
   printf("|    +---+---+---+---+---+---+---+---+---+---+    |\n"); //14
   printf("|  4 |   |   |   |   |   |   |   |   |   |   |    |\n"); //15
   printf("|    +---+---+---+---+---+---+---+---+---+---+    |\n"); //16
   printf("|  5 |   |   |   |   |   |   |   |   |   |   |    |\n"); //17
   printf("|    +---+---+---+---+---+---+---+---+---+---+    |\n"); //18   
   printf("|  6 |   |   |   |   |   |   |   |   |   |   |    |\n"); //19
   printf("|    +---+---+---+---+---+---+---+---+---+---+    |\n"); //20
   printf("|  7 |   |   |   |   |   |   |   |   |   |   |    |\n"); //21
   printf("|    +---+---+---+---+---+---+---+---+---+---+    |\n"); //22
   printf("|  8 |   |   |   |   |   |   |   |   |   |   |    |\n"); //23
   printf("|    +---+---+---+---+---+---+---+---+---+---+    |\n"); //24
   printf("|  9 |   |   |   |   |   |   |   |   |   |   |    |\n"); //25
   printf("|    +---+---+---+---+---+---+---+---+---+---+    |\n"); //26   
   printf("|      0   1   2   3   4   5   6   7   8   9      |\n"); //27
   printf("|                                                 |\n"); //28
   printf("|     (ESC) Exit         (Space) Insert Stone     |\n"); //29
   printf("|     (i) Up   (j) Left  (k) Down   (l) Right     |\n"); //30
   printf("|_________________________________________________|\n"); //31
   printf("|                                                 |\n"); //32
   printf("|                                                 |\n"); //33
   printf("|_________________________________________________|\n"); //34
   
}


/**
 * Posiciona el cursor en el tablero en la posición del cursor.
 * Posicionar el cursor en el tablero en función de la variable
 * (posCursor) llamando la función gotoxyP1_C.
 * La fila donde posicionamos el cursor (rowScreen) se calcula con la fórmula:
 * (rowScreen = 7 + (posCursor/DIMMATRIX))*2
 * La columna donde posicionamos el cursor (colScreen) se calcula con la fórmula:
 * (colScreen = 8 + (posCursor%DIMMATRIX))*4
 *  
 * Variables globales utilizadas:	
 * (rowScreen): Fila de la pantalla donde posicionamos el cursor.
 * (colScreen): Columna de la pantalla donde posicionamos el cursor.
 * (posCusor) : Posición del cursor dentro de la matriz mBoard.
 * 
 * Esta función no se llama desde ensamblador.
 * Hay una subrutina en ensamblador equivalente 'posCurBoardP1'.
 **/
void  posCurBoardP1_C(){

   rowScreen = 7 + (posCursor/DIMMATRIX)*2;
   colScreen = 8 + (posCursor%DIMMATRIX)*4;
   gotoxyP1_C();
   
}


/**
 * Muestra en el tablero el símbolo del jugador (stoneSymbol) de la ficha
 * jugada en la posición actual del cursor (posCursor).
 * Obtener el símbolo que se debe mostrar de la matriz (mBoard)
 * [mBoart+posCursor] = mBoard[row][col], donde row=posCursor/DIMMATRIX
 * y col=posCursor%DIMMATRIX.
 * Mostrar el símbolo (stoneSymbol) llamando a la función printchP1_C.
 *  
 * Variables globales utilizadas:
 * (row)        : Fila de la matriz mBoard.
 * (col)        : Columna de la matriz mBoard.
 * (posCursor)  : Posición del cursor dentro de la matriz mBoard.
 * (mBoard)     : Dirección de la matriz donde guardamos las fichas introducidas. 
 * (stoneSymbol): Símbolo de la ficha del jugador que está jugando.
 * (charac)     : Carácter que queremos mostrar.
 * 
 * Esta función no se llama desde ensamblador.
 * Hay una subrutina en ensamblador equivalente 'showStonePosP1'.
 **/
void showStonePosP1_C(){ 

  row = (posCursor/DIMMATRIX);   //En ensamblador, no es necesario calcular
  col = (posCursor%DIMMATRIX);   //(row) y (col), (posCursor) ya indica
  stoneSymbol = mBoard[row][col];//la posición dentro de la matriz (mBoard).
  charac = stoneSymbol;
  printchP1_C();
  
}
 
 
/**
 * Actualizar la posición donde está el cursor (posCursor) según
 * el carácter (charac) leído de teclado:
 * 'i' Arriba, 'j' Izquierda, 'k' Abajo, 'l' Derecha.
 * Actualizar la posición del cursor (posCursor)
 * controlando que no salga del tablero [0..(DIMMATRX*DIMMATRIX-1)].
 * (row) [0..(DIMMATRX-1] - (col) [0..(DIMMATRX-1]
 *  
 * Variables globales utilizadas:
 * (row)        : Fila de la matriz mBoard.
 * (col)        : Columna de la matriz mBoard.
 * (posCursor)  : Posición del cursor dentro de la matriz mBoard.
 * (charac)     : Carácter que queremos mostrar.
 * 
 * Esta función no se llama desde ensamblador.
 * Hay una subrutina en ensamblador equivalente 'moveCursorP1'.
 **/
void moveCursorP1_C(){
	
   row = (posCursor/DIMMATRIX);
   col = (posCursor%DIMMATRIX);
   if ((charac=='i') && (row>0)){             
      posCursor = posCursor-DIMMATRIX;
   } else
   if ((charac=='j') && (col>0)){             
      posCursor--;
   } else
   if ((charac=='k') && (row<(DIMMATRIX-1))){
      posCursor = posCursor+DIMMATRIX;
   } else
   if ((charac=='l') && (col<(DIMMATRIX-1))){             
      posCursor++;
   }
   
}


/**
 * Contar cuántas casillas están ocupadas (!=' ') alrededor de la
 * posición actual del cursor (posCursor) en la matriz (mBoard), en todas
 * las direcciones, indicadas en el vector (dirLines) con el valor que
 * debemos modificar la posición actual para seguir aquella dirección.
 * dirección: 0           1             2             3             4           5        6   7
 *    { -DIMMATRIX-1, +DIMMATRIX+1, +DIMMATRIX-1, -DIMMATRIX+1, -DIMMATRIX, +DIMMATRIX, -1, +1}
 *       superior      inferior      inferior      superior      superior    inferior  izq. derecha
 *       izquierda     derecha       izquierda     derecha
 * Mientras no hayamos mirado todas las direcciones (dir<8) hacer:
 *   Obtenemos la posición de la casilla que queremos mirar (nextPos) con
 *   el incremento indicado en la matriz (dirLines) de la dirección que
 *   estamos mirando (dir) (nextPos = posCursor + dirLines[dir]).
 *   Si la fila y la columna están dentro del tablero
 *   ((nextRow > 0) && (nextRow < DIMMATRIX)) ((nextCol>=0 && (col-nextCol) >= -1) && ((col-nextCol) <= 1))
 *   y aquella casilla de la matriz (mBoard) no está vacía (!=' ')
 *     Incrementamos (neighbors++).
 *   Incrementamos (decir) para mirar en la siguiente dirección.
 * Actualizamos (neighbors) para indicar cuántas casillas ocupadas
 * hay alrededor de la posición actual.
 * 
 * 
 * Variables globales utilizadas:	
 * (neighbors): Indica cuantas casillas ocupadas hay alrededor de la posición actual.
 * (row)      : Fila de la matriz mBoard.
 * (col)      : Columna de la matriz mBoard.
 * (posCursor): Posición del cursor dentro de la matriz mBoard.
 * (mBoard)   : Dirección de la matriz donde guardamos las fichas introducidas. 
 * (dirLines) : Dirección de la matriz que indica el incremento que se debe hacer a la posición actual para seguir una dirección.
 * 
 * Esta función no se llama desde ensamblador.
 * Hay una subrutina en ensamblador equivalente 'checkAroundP1'.
 **/
void checkAroundP1_C(){
  
  long nextPos;
  long nextRow;
  long nextCol;
  neighbors  = 0;
  row = (posCursor/DIMMATRIX);    
  col = (posCursor%DIMMATRIX);
  long dir = 0;
  while (dir < 8){
	nextPos = posCursor + dirLines[dir];
	nextRow = nextPos/DIMMATRIX;
    nextCol = nextPos%DIMMATRIX;
	if (((nextRow >= 0) && (nextRow < DIMMATRIX)) &&
	    (nextCol>=0 && (col-nextCol) >= -1) && ((col-nextCol) <= 1)) {
	  if ( mBoard[nextRow][nextCol] != ' ' ) {
	    neighbors++;
      }
	}
	dir++;
  }
  
}


/**
 * Insertar la ficha (stoneSymbol) del jugador, indicado por la
 * variable (state), en la posición donde está el cursor (posCursor)
 * en la matriz (mBoard), si la posición está vacía (' ') y
 * las casillas de alrededor no están vacías.
 * Si en la posición actual del cursor (posCursor) no hay ninguna ficha
 * (mBoard[row][col]==' ') miramos si las casillas de alrededor de la posición
 * actual (posCursor) no están vacías llamando a la función checkAroundP1_C().
 * Si podemos introducir la ficha (neighbors > 0):
 *   Si el estado del juego es (state==1) el (stoneSymbol = STONESYMBOLPLAYER1),
 *   si el estado del juego es (state==2) el (stoneSymbol = STONESYMBOLPLAYER2).
 *   Poner el símbolo (stoneSymbol) en la matriz (mBoard) en la posición
 *   donde está el cursor (posCursor).
 *   Cambiamos de jugador, de jugador 1 a jugador 2 y de jugador 2 a judador 1
 *   (state = 3 - state).
 * 
 * Variables globales utilizadas:	
 * (row)        : Fila de la matriz mBoard.
 * (col)        : Columna de la matriz mBoard.
 * (posCursor)  : Posición del cursor dentro de la matriz mBoard.
 * (stoneSymbol): Símbolo de la ficha del jugador que está jugando.
 * (mBoard)     : Dirección de la matriz donde guardamos las fichas introducidas. 
 * (state)      : Estado del juego.
 * (newState)   : Estado del juego.
 * 
 * Esta función no se llama desde ensamblador.
 * Hay una subrutina en ensamblador equivalente 'insertStoneP1'.
 **/
void  insertStoneP1_C(){

  row = (posCursor/DIMMATRIX);   //En ensamblador, no hay que calcular
  col = (posCursor%DIMMATRIX);   //(row)y (col), (posCursor) ya indica
  stoneSymbol = mBoard[row][col];//la posición dentro de la matriz (mBoard).
  if (stoneSymbol==' ') {
    checkAroundP1_C();
    if (neighbors > 0) {
      if (state == 1) stoneSymbol = STONESYMBOLPLAYER1; else stoneSymbol = STONESYMBOLPLAYER2;
      mBoard[row][col]=stoneSymbol;
      newState = 3 - state;
	}
  }
  
}


/**
 * Verifica si el tablero está lleno y no se puede seguir jugando.
 * Recorremos todo el tablero (mBoard) para mirar si está lleno,
 * DIMMATRIX*DIMMATRIX posiciones.
 *   El tablero está lleno si todas las posiciones de la matriz (mBoard)
 *   son diferentes de ' '.
 *   Si está lleno, hemos recorrido todo el tablero y no hay ningún espacio,
 *   pondremos (state=5) para indicar que el tablero está lleno
 *   y no se puede seguir jugando.
 * 
 * Variables globales utilizadas:	
 * (mBoard): Dirección de la matriz donde guardamos las fichas introducidas. 
 * (state) : Estado del juego.
 * 
 * Esta función no se llama desde ensamblador.
 * Hay una subrutina en ensamblador equivalente 'checkEndP1'.
 **/
void checkEndP1_C(){

  int i=0;
  int j=0;
  while (mBoard[i][j]!=' ' && i<DIMMATRIX){
    j++;
    if (j>=DIMMATRIX) {
      j = 0;
      i++;
	}  
  }
  if (i == DIMMATRIX) state = 5;
   
}
 

/**
 * Muestra un mensaje en la parte inferior del tablero según el 
 * valor de la variable (state).
 * (state) 0: Se ha presionado ESC para salir 
 *         1: Juega el jugador 1.
 *         2: Juega el jugador 2.
 *         3: El jugador 1 ha hecho 5 en línea.
 *         4: El jugador 2 ha hecho 5 en línea.
 *         5: El tablero está lleno. Empate.
 * 
 * Variables globales utilizadas:	
 * (state): Estat del joc.
 * 
 * Se ha definido una subrutina en ensamblador equivalente 'printMessageP1' 
 * para llamar a esta función guardando el estado de los registros del 
 * procesador. Esto se hace porque las funciones de C no mantienen 
 * el estado de los registros.
 **/
void printMessageP1_C(){

   rowScreen = 33;
   colScreen = 10;
   gotoxyP1_C();
   switch(state){
	 case 0:
       printf("         EXIT: (ESC) PRESSED       ");
     break;
     case 1: 
       printf("         Play: PLAYER 1 (%c)       ", STONESYMBOLPLAYER1);
     break;
     case 2:
       printf("         Play: PLAYER 2 (%c)       ", STONESYMBOLPLAYER2);
     break;
     case 3:
       printf("        PLAYER 1 (%c): WIN!!!      ", STONESYMBOLPLAYER1);
     break;
     case 4:
       printf("        PLAYER 2 (%c): WIN!!!      ", STONESYMBOLPLAYER2);
     break;
     case 5:
       printf("  GAME OVER: Grid Full! = DRAW = ");
     break;
   }
   
}


/**
 * Función principal del juego
 * Muestra el tablero de juego y deja hacer las jugadas de los 2 jugadores,
 * alternativamente, hasta que uno de los dos jugadores pone 5 fichas en raya
 * o el tablero queda lleno y nadie ha hecho un 5 en raya.
 *
 * Pseudo-código:
 * Mostrar un mensaje según el estado del juego (state) llamando a
 * la función printMessageP1_C.
 * Mientras estén jugando el jugador 1 (state=1) o el jugador 2 (state=2) hacer:
 *   Posicionar el cursor en el tablero en la posición indicada por la variable
 *   (posCursor) llamando a la función posCurBoardP1_C.
 *   Leer una tecla llamando a la función getchP1_C.
 *   Si la tecla leída es 'i', 'j', 'k' o 'l' mover el cursor sin
 *   salir del tablero llamando a la función moveCursorP1_C.
 *   Si la tecla leída es ' ' comprobar si la las casillas que hay
 *   alrededor de la posición actual hay alguna ficha llamando
 *   a la función checkAroundP1_C.
 *     Si hay alguna posición ocupada (neighbors>0)
 *       Insertar la ficha en el tablero (mBoard) en la posición actual del
 *       cursor (posCursor) llamando a la función insertStoneP1_C.
 *       Si se ha introducido la ficha, (state != newState)
 *         Mostrar la ficha que se ha insertado en el tablero (mBoard) en la posición
 *         actual del tablero (posCursor) llamando a la función showStonePosP1_C.
 *         Verificar si el tablero está lleno llamando la función checkEndP1_C.
 *       Si el tablero está lleno (state <= 2)
 *       actualizar el estado del juego (state = newState).
 *   Si la tecla es ESC(ASCII 27) poner (state=0) para indicarlo.
 * Mostrar un mensaje según el estado del juego (state) llamando
 * a la función printMessageP1_C.
 * Se termina el juego.
 * 
 * Variables globales utilizadas:	
 * (posCursor): Posición del cursor dentro de la matriz mBoard.	
 * (state)    : Estado del juego.
 * (newState) : Estado del juego.
 * (charac)   : Carácter leído de teclado.
 * (neighbors): Indica cuantas casillas ocupadas hay alrededor de la posición actual.
 * 
 * Esta función no se llama desde ensamblador.
 * Hay una subrutina en ensamblador equivalente 'playP1'.
 **/
void playP1_C(){

  posCursor = 44;
  state = 1;  
  newState = state;
  
  printMessageP1_C();             
  while (state == 1 || state ==2  ) {
	posCurBoardP1_C();
    getchP1_C();   
    if (charac >= 'i'  && charac <= 'l') {
      moveCursorP1_C();
    } else 
    if (charac == ' ' ) {
      checkAroundP1_C();
      if (neighbors  > 0) {
        insertStoneP1_C();
        if(state != newState){//new stone inserted
		  showStonePosP1_C();
          checkEndP1_C();
          if (state <= 2) state = newState;
        }
      }
    } else 
    if (charac == 27) {
       state = 0;
    }
    printMessageP1_C();
  }
   
}


/**
 * Programa Principal
 * 
 * ATENCIÓN: Podéis probar la funcionalidad de las subrutinas que deben
 * desarrollarse quitando los comentarios de la llamada a la función 
 * equivalente implementada en C que hay debajo de cada opción.
 * Para el juego completo hay una opción para la versión en ensamblador y 
 * una opción para el juego en C.
 **/
void main(void){
   
  int op=' ';
  while (op!='0' && op!=27) {
    printMenuP1_C();	  
    op = charac;
    clearScreen_C();
    printBoardP1_C();
    int  i,j;
    rowScreen = 7;
    for (i=0;i<DIMMATRIX;i++){
	  colScreen = 8;
      for (j=0;j<DIMMATRIX;j++){
         gotoxyP1_C();
         charac = mBoard[i][j];
         printchP1_C();
         colScreen = colScreen + 4;
      }
      rowScreen = rowScreen + 2;
    }
    switch(op){
      case 27:
      case '0':
        rowScreen = 35;
	    colScreen = 0;
        gotoxyP1_C();
        break;
      case '1':
        rowScreen = 33;
	    colScreen = 4;
        gotoxyP1_C();
        posCursor = 33;
        printf("Show cursor at row(%li)-col(%li) -Press any key- ", posCursor/DIMMATRIX, posCursor%DIMMATRIX);
        //=======================================================
        posCurBoardP1();
        ///posCurBoardP1_C();
        //=======================================================
        getchP1_C();
        rowScreen = 33;
	    colScreen = 4;
        gotoxyP1_C();
        printf("                                               ");
        break;
      case '2':
        posCursor = 99;
        charac = mBoard[posCursor/DIMMATRIX][posCursor%DIMMATRIX];
        mBoard[posCursor/DIMMATRIX][posCursor%DIMMATRIX]='O';
        rowScreen = 33;
	    colScreen = 2;
        gotoxyP1_C();
        printf("Show symbol 'O' at row(%li)-col(%li) -Press any key-", posCursor/DIMMATRIX, posCursor%DIMMATRIX);
        posCurBoardP1_C();
        //=======================================================
        showStonePosP1();
        ///showStonePosP1_C();    
        //=======================================================
        mBoard[posCursor/DIMMATRIX][posCursor%DIMMATRIX]=charac;
        posCurBoardP1_C();
        getchP1_C();
        rowScreen = 33;
	    colScreen = 2;
        gotoxyP1_C();
        printf("                                                    ");
        break;
      case '3':
        rowScreen = 33;
	    colScreen = 4;
        gotoxyP1_C();
        printf("            Move cursor (ESC exit)                ");
        posCursor = 0;
        posCurBoardP1_C();
        do {
          getchP1_C();
          if (charac >= 'i' && charac <= 'l') {
            //=======================================================
            moveCursorP1();
            ///moveCursorP1_C();
            //=======================================================
            posCurBoardP1_C();
	      }
        } while (charac != 27);
        rowScreen = 33;
	    colScreen = 4;
        gotoxyP1_C();
        printf("                                                  ");
        break;
      case '4':
        posCursor = 53;
        //=======================================================
        checkAroundP1(); 
        ///checkAroundP1_C(); 
        //=======================================================
        rowScreen = 33;
	    colScreen = 4;
        gotoxyP1_C();
        printf("  Position row(%li)-col(%li) has (%i) neighbours    ", posCursor/DIMMATRIX, posCursor%DIMMATRIX, neighbors );
        rowScreen = 35;
	    colScreen = 4;
        gotoxyP1_C();
        printf("                - Press any key - ");
        posCurBoardP1_C();
        getchP1_C();
        rowScreen = 33;
	    colScreen = 4;
        gotoxyP1_C();
        printf("                                                  ");
        rowScreen = 35;
	    colScreen = 4;
        gotoxyP1_C();
        printf("                                                  ");
        break;  
      case '5':
        state = 1;
        posCursor= 44;
        do {
          printMessageP1_C(state);
          posCurBoardP1_C();
          getchP1_C();
          if (charac >= 'i' && charac <= 'l') moveCursorP1_C();
          if (charac == ' '){
            //=======================================================
            insertStoneP1();
            ///insertStoneP1_C();		
            //=======================================================
            state = newState;
            showStonePosP1_C();  
          }
        } while (charac != 27); 
        break;
      case '6': 	     
        rowScreen = 33;
	    colScreen = 10;
        gotoxyP1_C();
        printf(" This option will be developed in P2 ");
        getchP1_C();
        break;
      case '7':
        char mBoard2[DIMMATRIX][DIMMATRIX] = 
                                      { /*0*/ {'X','O','O','O','O','X','X','X','X','O'},
                                        /*1*/ {'O','X','X','X','X','O','O','O','O','X'},
                                        /*2*/ {'O','X','O','O','O','X','X','X','O','X'},
                                        /*3*/ {'O','X','O','X','X','O','O','X','O','X'},
                                        /*4*/ {'O','X','O','X','X','O','O','X','O','X'},
                                        /*5*/ {'X','O','X','O','O','X','X','O','X','O'},
                                        /*6*/ {'X','O','X','O','O','X','X','O','X','O'},
                                        /*7*/ {'X','O','X','X','X','O','O','O','X','O'},
                                        /*8*/ {'X','O','O','O','O','X','X','X','X','O'},
                                        /*9*/ {'O','X','X','X','X','0','0','0','0','X'}};
        posCursor = 44;
        state = 2; //state = 1;
        int  i,j;
        rowScreen = 7;
        for (i=0;i<DIMMATRIX;i++){
          colScreen = 8;
          for (j=0;j<DIMMATRIX;j++){
            gotoxyP1_C();
            charac = mBoard2[i][j];
            printchP1_C();
            colScreen = colScreen + 4;
            charac = mBoard[i][j];
            mBoard[i][j]=mBoard2[i][j];
            mBoard2[i][j]=charac;
          }
          rowScreen = rowScreen + 2;
        }
        //=======================================================
        checkEndP1();
        ///checkEndP1_C();
        //=======================================================
        for (i=0;i<DIMMATRIX;i++) {
		  for (j=0;j<DIMMATRIX;j++) {
            charac = mBoard2[i][j];
            mBoard2[i][j]=mBoard[i][j];
            mBoard[i][j]=charac;
          }
        }
        printMessageP1_C(state);                                               
        getchP1_C();
        rowScreen = 35;
	    colScreen = 15;
        gotoxyP1_C();
        printf("                                               ");
        break;
      case '8': 	//Juego completo en ensamblador.
        //=======================================================
        playP1();
        //=======================================================
        rowScreen = 35;
	    colScreen = 22;
        gotoxyP1_C(); 
        printf("Press any key");
        getchP1_C();	  
        break;
      case '9': 	//Juego completo en C.
        //=======================================================
        playP1_C();
        //=======================================================
        rowScreen = 35;
	    colScreen = 22;
        gotoxyP1_C(); 
        printf("Press any key");
        getchP1_C();	  
        break;
    }
  }
   
}
