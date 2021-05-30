function S=CALCULO_RADIAL_BASIS_FUNCTION(Forzamiento,c,F,M,PC,d,X,Forz_input, sim, SC, OF, var)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% CALCULO_RADIAL_BASIS_FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%_________________________________________________________________________
% 
% Descripcion: Funcion que interpola la serie total de elevaciones debidas
% a los forzamientos elegidos a partir de la serie de forzamientos, la
% muestra de M puntos de elevaciones contenida en F y el par�metro de forma
% obtenido por el m�todo de Rippa.
%
% Datos de entrada:
% 1. Forzamiento: Estructura con las series temporales de los forzamientos 
% considerados
% 2. c: Valor �ptimo del par�metro de forma
% 3. F: Valor de elevaci�n en el punto de control elegido para cada valor
% de los forzamientos contenidos en la muestra de tama�o M y seleccionados
% mediante el m�todo MDA. Por cada punto de la muestra, una simulaci�n y
% un valor de elevaci�n en el punto de control elegido.
% 4. M: N�mero de puntos que se quiere que tenga la muestra
% 5. PC: Punto de control elegido
% 6. d: Matriz con n�mero de columnas igual al n�mero de forzamientos
% considerados y n�mero de filas igual al n�mero de puntos de la muestra
% (M). d contiene los valores de la muestra seleccionados mediante el MDA y
% normalizados
% 7. Forz_input: Estructura que indica con 1 los forzamientos a considerar
% y con 0 el resto
% 8. X: Almacena en cada columna la serie temporal completa de cada uno de
% los forzamientos considerados sin normalizar.
%
%
% Datos de salida:
% 1. S: serie total de elevaciones obtenidas mediante RBF a partir de la 
% serie de forzamientos, la muestra de M puntos de elevaciones contenida en
% F y el par�metro de forma obtenido por el m�todo de Rippa.
%
%
%
%                                              Granada, 15 de marzo de 2016
%                                                     Juan del Rosal Salido
%                                   Grupo de Din�mica de Flujos Ambientales 
%                                                    Universidad de Granada
%__________________________________________________________________________

VAR = var;
S_WL=RADIAL_BASIS_FUNCTION(Forzamiento,c,F,M,PC,VAR,d,X,Forz_input, sim, SC, OF, var);
S=S_WL;
    
    
    
    
end