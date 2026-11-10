:- begin_tests(tp2).
:- ensure_loaded(tp2).

% Tablero auxiliar de 3x3 que se puede vaciar en dos jugadas.
tableroChico([
  [rojo,  libre, rojo],
  [libre, libre, libre],
  [azul,  libre, azul]
]).

% Ejercicio 1: esMatriz

test(esMatriz, [nondet]) :-
    esMatriz([]).

test(esMatriz, [nondet]) :-
    esMatriz([[1],[-1]]).

test(esMatriz, [nondet]) :-
    esMatriz([[a,b],[c,d]]).

test(esMatriz, fail) :-
    esMatriz([[1,2,3],[1,2]]).

% Ejercicio 2: tamaño

test(tamaño, [nondet]) :-
    tamaño([],Filas,Columnas),
    Filas =@= 0,
    Columnas =@= 0.

test(tamaño, [nondet]) :-
    tamaño([[a,b,c],[d,e,f]],Filas,Columnas),
    Filas =@= 2,
    Columnas =@= 3.

% Ejercicio 3: coordenadaEnRango

test(coordenadaEnRango, [nondet]) :-
    coordenadaEnRango([[a,b,c],[d,e,f]], (1,1)).

test(coordenadaEnRango, [nondet]) :-
    coordenadaEnRango([[a,b,c],[d,e,f]], (2,3)).

test(coordenadaEnRango, fail) :-
    coordenadaEnRango([[a,b,c],[d,e,f]], (0,1)).

test(coordenadaEnRango, fail) :-
    coordenadaEnRango([[a,b,c],[d,e,f]], (3,1)).

test(coordenadaEnRango, fail) :-
    coordenadaEnRango([[a,b,c],[d,e,f]], (1,4)).

% Ejercicio 4.a: tableroConPosiciónLiberada

test(tableroConPosiciónLiberada, [nondet]) :-
    tableroConPosiciónLiberada([[rojo,azul],[verde,rojo]], (2,1), T),
    T =@= [[rojo,azul],[libre,rojo]].

% Ejercicio 4.b: tableroConPosicionesLiberadas

test(tableroConPosicionesLiberadas, [nondet]) :-
    tableroConPosicionesLiberadas([[rojo,azul],[verde,rojo]], [], T),
    T =@= [[rojo,azul],[verde,rojo]].

test(tableroConPosicionesLiberadas, [nondet]) :-
    tableroConPosicionesLiberadas([[rojo,azul],[verde,rojo]], [(1,1),(2,2)], T),
    T =@= [[libre,azul],[verde,libre]].

% hayOcupadaAl

test(hayOcupadaAl, [nondet]) :-
    tablero(1, T),
    hayOcupadaAl(T, (1,2), sur).

test(hayOcupadaAl, fail) :-
    tablero(1, T),
    hayOcupadaAl(T, (1,2), norte).

test(hayOcupadaAl, fail) :-
    tablero(2, T),
    hayOcupadaAl(T, (1,2), sur).

% ocupadaEnLíneaRectaAl

test(ocupadaEnLíneaRectaAl, [nondet]) :-
    tablero(1, T),
    ocupadaEnLíneaRectaAl(T, (1,2), oeste, O),
    O =@= (1,1).

test(ocupadaEnLíneaRectaAl, [nondet]) :-
    tablero(1, T),
    ocupadaEnLíneaRectaAl(T, (1,2), sur, O),
    O =@= (3,2).

% ocupadasEnLíneaRecta

test(ocupadasEnLíneaRecta, [nondet]) :-
    tablero(1, T),
    ocupadasEnLíneaRecta(T, (1,2), Os),
    msort(Os, OsOrdenadas),
    OsOrdenadas =@= [(1,1),(1,3),(3,2)].

test(ocupadasEnLíneaRecta, [nondet]) :-
    tablero(3, T),
    ocupadasEnLíneaRecta(T, (2,2), Os),
    Os =@= [].

% Ejercicio 5.a: jugarPosición

test(jugarPosición, [nondet]) :-
    tablero(1, T),
    jugarPosición(T, (1,2), TR),
    TR =@= [
      [libre, libre, azul,  rojo],
      [azul,  libre, azul,  rojo],
      [verde, libre, azul,  verde],
      [libre, libre, libre, rojo]
    ].

test(jugarPosición, [nondet]) :-
    % empate: se liberan las vecinas de ambos colores
    not(jugarPosición([[rojo,libre,azul]], (1,2), _)).

% Ejercicio 5.b: jugarPosiciones

test(jugarPosiciones, [nondet]) :-
    tableroChico(T),
    jugarPosiciones(T, [], TR),
    TR =@= T.

test(jugarPosiciones, [nondet]) :-
    tableroChico(T),
    jugarPosiciones(T, [(1,2),(3,2)], TR),
    TR =@= [[libre,libre,libre],[libre,libre,libre],[libre,libre,libre]].

% jugarNaive

test(jugarNaive, [nondet]) :-
    tablero(3, T),
    jugarNaive(T, TF),
    TF =@= T.

test(jugarNaive, [nondet]) :-
    jugarNaive([[rojo,libre,rojo]], TF),
    TF =@= [[libre,libre,libre]].

test(jugarNaive, [nondet]) :-
    tableroChico(T),
    jugarNaive(T, [[libre,libre,libre],[libre,libre,libre],[libre,libre,libre]]).

% Ejercicio 6.a: jugadasNaive

test(jugadasNaive, [nondet]) :-
    tablero(3, T),
    jugadasNaive(T, Js),
    Js =@= [].

test(jugadasNaive, [nondet]) :-
    jugadasNaive([[rojo,libre,rojo]], Js),
    Js =@= [(1,2)].

test(jugadasNaive, [nondet]) :-
    tableroChico(T),
    jugadasNaive(T, [(3,2),(1,2)]).

% Ejercicio 7.a: victoriaConJugadas

test(victoriaConJugadas, [nondet]) :-
    tableroChico(T),
    victoriaConJugadas(T, [(1,2),(3,2)]).

test(victoriaConJugadas, fail) :-
    tableroChico(T),
    victoriaConJugadas(T, [(1,2)]).

% Ejercicio 7.b: juegoNaiveVictorioso

test(juegoNaiveVictorioso, [nondet]) :-
    tableroChico(T),
    setof(Js, juegoNaiveVictorioso(T, Js), L),
    L =@= [[(1,2),(3,2)],[(3,2),(1,2)]].

test(juegoNaiveVictorioso, fail) :-
    juegoNaiveVictorioso([[rojo,libre,azul,libre,rojo]], _).

% Ejercicio 7.c: mejorJuegoNaive

test(mejorJuegoNaive, [nondet]) :-
    setof(Js, mejorJuegoNaive([[libre,rojo,libre],[rojo,libre,rojo]], Js), L),
    L =@= [[(2,2)]].

test(mejorJuegoNaive, [nondet]) :-
    setof(Js, mejorJuegoNaive(  [[libre,rojo,rojo],
                                 [rojo,rojo,libre]], Js), L),
    L =@= [[(1,1),(1,2)], [(1,1),(2,3)], [(2,3),(1,1)], [(2,3),(2,2)]]. 

test(mejorJuegoNaive, [nondet]) :-
    setof(Js, mejorJuegoNaive(  [[libre, rojo,  libre],
                                 [rojo,  libre, rojo ],
                                 [libre, rojo,  libre]], Js), L),
    L =@= [[(2,2)]]. 

% Ejercicio 8: tableroEnElQueNaiveGanaEmpezandoPor
% Comentar para no incluir

test(tableroEnElQueNaiveGanaEmpezandoPor, [nondet]) :-
    with_output_to(string(_), once(tableroEnElQueNaiveGanaEmpezandoPor(T, (1,2)))),
    juegoNaiveVictorioso(T, [(1,2)|_]).

:- end_tests(tp2).
