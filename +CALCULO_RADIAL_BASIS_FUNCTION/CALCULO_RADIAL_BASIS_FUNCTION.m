function S=CALCULO_RADIAL_BASIS_FUNCTION(Forzamiento,c,F,M,PC,d,X,Forz_input, sim, SC, OF, var)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% CALCULO_RADIAL_BASIS_FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%_________________________________________________________________________
% 
% Descripcion: Funcion que interpola la serie total de elevaciones debidas
% a los forzamientos elegidos a partir de la serie de forzamientos, la
% muestra de M puntos de elevaciones contenida en F y el parámetro de forma
% obtenido por el método de Rippa.
%
% Datos de entrada:
% 1. Forzamiento: Estructura con las series temporales de los forzamientos 
% considerados
% 2. c: Valor óptimo del parámetro de forma
% 3. F: Valor de elevación en el punto de control elegido para cada valor
% de los forzamientos contenidos en la muestra de tamaño M y seleccionados
% mediante el método MDA. Por cada punto de la muestra, una simulación y
% un valor de elevación en el punto de control elegido.
% 4. M: Número de puntos que se quiere que tenga la muestra
% 5. PC: Punto de control elegido
% 6. d: Matriz con número de columnas igual al número de forzamientos
% considerados y número de filas igual al número de puntos de la muestra
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
% F y el parámetro de forma obtenido por el método de Rippa.
%
%
%
%                                              Granada, 15 de marzo de 2016
%                                                     Juan del Rosal Salido
%                                   Grupo de Dinámica de Flujos Ambientales 
%                                                    Universidad de Granada
%__________________________________________________________________________

VAR = var;
S_WL=RADIAL_BASIS_FUNCTION(Forzamiento,c,F,M,PC,VAR,d,X,Forz_input, sim, SC, OF, var);
S=S_WL;
    
    
    
    
end