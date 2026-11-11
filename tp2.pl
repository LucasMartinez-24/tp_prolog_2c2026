:- use_module(popong).

% ----------------
% Ejercicio 1
% ----------------

% esMatriz(+ListaDeListas)
esMatriz([]).
esMatriz(M):- nth0(0,M,M0), length(M0,L), todasMiden(M,L).

todasMiden([],_).
todasMiden([M|MS],L):- length(M,L), todasMiden(MS,L).

% ----------------
% Ejercicio 2
% ----------------

% tamaño(+Matriz, -Filas, -Columnas)
% Precondicion: esMatriz(Matriz)
tamaño([],0,0).
tamaño(M,F,C):- length(M,F), nth0(0,M,L), length(L,C).

% ----------------
% Ejercicio 3
% ----------------

% coordenadaEnRango(+Matriz, +Coordenada)
% Precondicion: esMatriz(Matriz)
% Reversibilidad: no es reversible en ninguno de sus argumentos.
% - Coordenada: si (I,J) no esta instanciada, las comparaciones aritmeticas (<, =<)
%   requieren que ambos lados esten instanciados, por lo que se produce un error
%   de instanciacion en lugar de generar las coordenadas validas.
% - Matriz: si no esta instanciada, length/2 dentro de tamaño/3 genera infinitas
%   listas candidatas: para una cantidad fija de filas prueba infinitos largos de la
%   primera fila, por lo que nunca avanza a mas filas y no termina (ademas, solo
%   restringe la primera fila, asi que no generaria matrices).
coordenadaEnRango(M, (I,J)) :- tamaño(M,F,C), 0 < I, I =< F, 0 < J, J =< C.

% ----------------
% Observadores de tablero.
% ----------------

% valorEnCoordenada(+Tablero, ?Coordenada, ?Valor)
% Posibles usos:
% - (+T, +Coordenada, -V): Instancia en V el valor en las coordenadas Coordenada del tablero T.
% - (+T, -Coordenada, +V): Instancia en Coordenada todas las coordenadas del tablero T que tienen el valor V.
% - (+T, -Coordenada, -V): Instancia en Coordenada todas las coordenadas del tablero T y en V sus correspondientes valores.
% Precondicion: esMatriz(Tablero), coordenadaEnRango(Tablero, Coordenada).
valorEnCoordenada(T, (I,J), V) :-
  nth1(I, T, Fila),
  nth1(J, Fila, V).

% coordenada(+Tablero, -Coordenada)
% Instancia en Coordenada todas las coordenadas del tablero Tablero.
% Precondicion: esMatriz(Tablero).
coordenada(T, Coordenada) :-
  valorEnCoordenada(T, Coordenada, _).

% libre(+Tablero, ?Coordenada)
% Instancia en Coordenada todas las coordenadas libres del tablero Tablero (o verifica si la coordenada Coordenada está libre en Tablero).
% Precondicion: esMatriz(Tablero), coordenadaEnRango(Tablero, Coordenada).
libre(T, Coordenada) :-
  valorEnCoordenada(T, Coordenada, libre).

% color(+Tablero, +Color, ?Coordenada)
% Instancia en Coordenada todas las coordenadas del tablero Tablero que tienen el color Color (o verifica si la coordenada Coordenada tiene color Color en Tablero).
% Precondicion: esMatriz(Tablero), coordenadaEnRango(Tablero, Coordenada).
color(T, Color, Coordenada) :-
  color(Color),
  valorEnCoordenada(T, Coordenada, Color).

% ----------------
% Ejercicio 4.a)
% ----------------

% tableroConPosiciónLiberada(+Tablero, +Coordenada, -TableroLiberado)
% Precondicion: esMatriz(Tablero), coordenadaEnRango(Tablero, Coordenada), not(libre(Tablero, Coordenada)).
tableroConPosiciónLiberada(T,(I,J),L):-
  nth1(I,T,Fila,OtrasFilas),
  nth1(J,Fila,_,OtrasCols),
  nth1(J,FilaLibre,libre,OtrasCols),
  nth1(I,L,FilaLibre,OtrasFilas).

% ----------------
% Ejercicio 4.b)
% ----------------

% tableroConPosicionesLiberadas(+Tablero, +Posiciones, -TableroLiberado)
% Precondicion: esMatriz(Tablero).
% Precondicion: para cada Coordenada en Posiciones: coordenadaEnRango(Tablero, Coordenada), not(libre(Tablero, Coordenada)).
tableroConPosicionesLiberadas(T,[],T).

tableroConPosicionesLiberadas(T,[P|PS],L):-
  tableroConPosicionesLiberadas(T,PS,LSiguiente),
  tableroConPosiciónLiberada(LSiguiente,P,L).

% ----------------
% Operaciones sobre coordenadas.
% ----------------

% direccion(?Direccion)
% Instacia en Direccion todas las posibles direcciones (o verifica que Direccion sea una direccion).
direccion(norte).
direccion(este).
direccion(sur).
direccion(oeste).

% direcciones(-Direcciones)
% Instancia en Direcciones una lista con todas las direcciones.
direcciones([norte, este, sur, oeste]).

% vecinaEnDir(+Coordenada, ?Direccion, -Vecina)
% Instancia en Vecina la coordenada vecina a Coordenada en la direccion Direccion (o instancia cada par direccion-vecina en Direccion y Vecina, respectivamente).
vecinaEnDir((I,J), norte, (I2, J)) :- I2 is I-1.
vecinaEnDir((I,J), este, (I, J2)) :- J2 is J+1.
vecinaEnDir((I,J), sur, (I2, J)) :- I2 is I+1.
vecinaEnDir((I,J), oeste, (I, J2)) :- J2 is J-1.

% hayOcupadaAl(+Tablero, +(I, J), +Direccion)
% Precondicion: esMatriz(Tablero), coordenadaEnRango(Tablero, (I,J)).
hayOcupadaAl(T, (I, J), D) :-
  vecinaEnDir((I, J), D, V),
  coordenadaEnRango(T, V),
  color(T, _, V).
hayOcupadaAl(T, (I, J), D) :-
  vecinaEnDir((I, J), D, V),
  coordenadaEnRango(T, V),
  libre(T, V),
  hayOcupadaAl(T, V, D).

% ocupadaEnLíneaRectaAl(+Tablero, +(I, J), +Direccion, -Ocupada)
% Precondicion: esMatriz(Tablero), coordenadaEnRango(Tablero, (I,J)), hayOcupadaAl(Tablero, (I, J), Direccion).
ocupadaEnLíneaRectaAl(T, (I, J), D, O) :-
  vecinaEnDir((I, J), D, O),
  color(T, _, O).
ocupadaEnLíneaRectaAl(T, (I, J), D, O) :-
  vecinaEnDir((I, J), D, V),
  libre(T, V),
  ocupadaEnLíneaRectaAl(T, V, D, O).

% ocupadasEnLíneaRecta(+Tablero, +(I, J), -PosicionesOcupadas)
% Precondicion: esMatriz(Tablero), coordenadaEnRango(Tablero, (I,J)).
ocupadasEnLíneaRecta(T, (I, J), Ocupadas) :-
  direcciones(Direcciones),
  ocupadasPorDirecciones(T, (I, J), Direcciones, Ocupadas).

% ocupadasPorDirecciones(+Tablero, +(I, J), +Direcciones, -PosicionesOcupadas)
% Precondicion: esMatriz(Tablero), coordenadaEnRango(Tablero, (I,J)).
ocupadasPorDirecciones(_, _, [], []).
ocupadasPorDirecciones(T, (I, J), [D|Ds], [O|Os]) :-
  hayOcupadaAl(T, (I, J), D),
  ocupadaEnLíneaRectaAl(T, (I, J), D, O),
  ocupadasPorDirecciones(T, (I, J), Ds, Os).
ocupadasPorDirecciones(T, (I, J), [D|Ds], Os) :-
  not(hayOcupadaAl(T, (I, J), D)),
  ocupadasPorDirecciones(T, (I, J), Ds, Os).

% ----------------
% Obtencion de los colores predominantes desde una coordenada.
% ----------------

% coloresPredominantes(+Tablero, +(I, J), -Colores, -Coordenadas)
% Instancia en Colores la lista con los colores que son predominantes en el tablero Tablero desde la coordenada (I,J), y en Coordenadas las coordenadas correspondientes a dichos colores..
% Precondicion: esMatriz(Tablero), coordenadaEnRango(Tablero, (I,J)), libre(Tablero, (I, J)).
coloresPredominantes(T, (I, J), ColoresPredominantes, Coordenadas) :-
  ocupadasEnLíneaRecta(T, (I, J), Os),
  posicionesAColores(T, Os, ColoresOcupadas),
  soloPredominantesEn(ColoresOcupadas, ColoresOcupadas, Os, ColoresPredominantes, Coordenadas).

% posicionesAColores(+Tablero, +Posiciones, -Colores)
% Instancia en Colores los colores de las coordenadas Posiciones en el tablero Tablero.
% Precondicion: esMatriz(Tablero).
% Precondicion: para cada Coordenada en Posiciones: coordenadaEnRango(Tablero, Coordenada), not(libre(Tablero, Coordenada)).
posicionesAColores(_, [], []).
posicionesAColores(T, [P | Ps], [C | Cs]) :-
  color(T, C, P),
  posicionesAColores(T, Ps, Cs).

% soloPredominantesEn(+ColoresOcupadasCompleta, +ColoresOcupadasRestantes, +CoordenadasOcupadas, -ColoresPredominantes, -CoordenadasPredominantes).
% Instancia en ColoresPredominantes los colores de la lista ColoresOcupadasRestantes que son predominantes en ColoresOcupadasCompleta.
soloPredominantesEn(_, [], [], [], []).
soloPredominantesEn(COC, [CO | COs], [Cr | Crs], CPs, [Cr | Coord]) :-
  soloPredominantesEn(COC, COs, Crs, CPs, Coord),
  member(CO, CPs).
soloPredominantesEn(COC, [CO | COs], [Cr | Crs], [CO | CPs], [Cr | Coord]) :-
  soloPredominantesEn(COC, COs, Crs, CPs, Coord),
  not(member(CO, CPs)),
  esPredominante(CO, COC).
soloPredominantesEn(COC, [CO | COs], [_ | Crs], CPs, Coord) :-
  soloPredominantesEn(COC, COs, Crs, CPs, Coord),
  not(member(CO, CPs)),
  not(esPredominante(CO, COC)).

% esPredominante(+Color, +Colores)
% Indica si el color Color es predominante en Colores.
esPredominante(C, Cs) :-
  cantApariciones(C, Cs, K),
  not(hayColorConMasPresencia(Cs, K, Cs)), !.

% cantApariciones(+Elemento, +Lista, -Cantidad)
% Instancia en Cantidad la cantidad de veces que aparece el elemento Elemento en la lista Lista.
cantApariciones(_, [], 0).
cantApariciones(X, [X|Xs], N) :-
  cantApariciones(X, Xs, N2),
  N is N2 + 1.
cantApariciones(X, [Y|Xs], N) :-
  X \= Y,
  cantApariciones(X, Xs, N).

% hayColorConMasPresencia(+ListaCompleta, +Cantidad, +ListaRestante)
% Indica si hay algún color de la lista ListaRestante que aparezca en ListaCompleta mas de Cantidad veces.
hayColorConMasPresencia([C|_], K, CC) :-
  cantApariciones(C, CC, K2), K2 > K.
hayColorConMasPresencia([_|Cs], K, CC) :-
  hayColorConMasPresencia(Cs, K, CC).

% jugadaPosible(+Tablero, ?Jugada)
% Precondicion: esMatriz(Tablero).
% Tiene éxito si la posicion Jugada tiene colores vecinos repetidos
jugadaPosible(T, (I, J)) :-
  libre(T, (I, J)),
  ocupadasEnLíneaRecta(T, (I, J), Os),
  posicionesAColores(T, Os, Cs),
  not(is_set(Cs)).

% ----------------
% Ejercicio 5.a)
% ----------------

% jugarPosición(+TableroInicial, +Coordenada, -TableroResultante)
% Precondicion: esMatriz(TableroInicial), coordenadaEnRango(TableroInicial, Coordenada), libre(TableroInicial, Coordenada).
jugarPosición(TI, Pos, TRes) :-
  jugadaPosible(TI,Pos),
  coloresPredominantes(TI,Pos,_,Coordenadas),
  tableroConPosicionesLiberadas(TI,Coordenadas,TRes).

% ----------------
% Ejercicio 5.b)
% ----------------

% jugarPosiciones(+TableroInicial, +Jugadas, -TableroResultante)
% Precondicion: esMatriz(TableroInicial).
% Precondicion: para cada Coordenada en Jugadas: coordenadaEnRango(TableroInicial, Coordenada).
jugarPosiciones(TI, [], TI).

jugarPosiciones(TI, [P|PS], TRes) :-
  jugarPosición(TI,P,TSiguiente),
  jugarPosiciones(TSiguiente,PS,TRes).

% jugarNaive(+TableroInicial, -TableroFinal)
% Precondicion: esMatriz(TableroInicial).
jugarNaive(T, T) :-
  not(jugadaPosible(T, _)).
jugarNaive(T, TF) :-
  jugadaPosible(T, J),
  jugarPosición(T, J, TI),
  jugarNaive(TI, TF).

% ----------------
% Ejercicio 6.b)
% ----------------

% jugadasNaive(+Tablero, -Jugadas)
% Precondicion: esMatriz(Tablero).
jugadasNaive(T, []):- not(jugadaPosible(T,_)).

jugadasNaive(T, [J|JS]):-
  jugadaPosible(T,J),
  jugarPosición(T,J,TSiguiente),
  jugadasNaive(TSiguiente,JS).

% ----------------
% Ejercicio 7.a)
% ----------------

% victoriaConJugadas(+Tablero, +Jugadas).
% Precondicion: esMatriz(Tablero).
% Precondicion: para cada Coordenada en Jugadas: coordenadaEnRango(Tablero, Coordenada).
% Gana si en el tablero resultante no queda ninguna posicion de ningun color (color/1 enumera todos).
victoriaConJugadas(T, JS) :-
  jugarPosiciones(T, JS, TRes),
  not(color(TRes, _, _)).

% ----------------
% Ejercicio 7.b)
% ----------------

% juegoNaiveVictorioso(+Tablero, -Jugadas)
% Precondicion: esMatriz(Tablero).
juegoNaiveVictorioso(T, JS) :- jugadasNaive(T,JS), victoriaConJugadas(T,JS).

% ----------------
% Ejercicio 7.c)
% ----------------

% mejorJuegoNaive(+Tablero, -Jugadas)
% Precondicion: esMatriz(Tablero).
mejorJuegoNaive(T, JS) :- juegoNaiveVictorioso(T, JS), length(JS,L), not((juegoNaiveVictorioso(T, JSo), length(JSo, Lo), L > Lo)).

% ----------------
% Ejercicio 8 - OPCIONAL
% ----------------

% tableroEnElQueNaiveGanaEmpezandoPor(-Tablero, +Coordenada)
tableroEnElQueNaiveGanaEmpezandoPor(_, _) :- completar("Ejercicio 8").

% ----------------
% Interfaz gráfica
% ----------------

% guiTablero(+Tablero)
%% NOTA: Si no funciona, usar en su lugar mostrarMatrizAlt.
guiTablero(T) :- mostrarMatriz(T), !.

% guiJugada(+Tablero1, +Coordenada, +Tablero2)
guiJugada(T1, J, T2) :- guiTablero(T1), write(J), write('\n'), guiTablero(T2).

% guiJugadas(+Tablero, +Jugadas)
guiJuego(T, Js) :- guiTablero(T), guiParesJugadasTableros(T, Js).

% guiParesJugadasTableros(+Tablero, +Jugadas)
guiParesJugadasTableros(_, []).
guiParesJugadasTableros(T, [J | Js]) :-
  write(J), write('\n'),
  jugarPosición(T, J, T2),
  guiTablero(T2),
  guiParesJugadasTableros(T2, Js).

% ----------------
% Tableros de ejemplo
% ----------------

% tablero(+N, -T)
tablero(1, [
  [rojo,  libre, azul,  rojo],
  [azul,  libre, azul,  rojo],
  [verde, rojo,  azul,  verde],
  [libre, libre, libre, rojo]
]).
tablero(2, [
  [libre, libre, libre, libre],
  [libre, libre, libre, libre],
  [verde, libre, libre, verde],
  [libre, libre, libre, libre]
]).
tablero(3, [
  [libre, libre, libre, libre],
  [libre, libre, libre, libre],
  [libre, libre, libre, libre],
  [libre, libre, libre, libre]
]).
tablero(4, [
  [verde, rojo, azul, verde],
  [libre, libre, libre, libre],
  [verde, rojo, azul, verde],
  [libre, libre, libre, libre]
]).

% Indica que se debe completar el predicado. Siempre falla.
completar(S) :- write("COMPLETAR: "), write(S), nl, fail.
