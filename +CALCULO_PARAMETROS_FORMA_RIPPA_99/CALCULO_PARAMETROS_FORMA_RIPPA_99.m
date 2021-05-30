function [c,E]=CALCULO_PARAMETROS_FORMA_RIPPA_99(c_ini,c_paso,c_fin,c_vect,F,d,Forzamiento,M,PC,Forz_input, SC, OF, var)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% CALCULO_PARAMETROS_FORMA_RIPPA_99
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%_________________________________________________________________________
% 
% Descripcion: Funcion que calcula el par�metro de forma �ptimo para las
% Radial Basis Function (RBF) a partir de los valores de elevaci�n de la
% muestra.
%
% Datos de entrada:
% 1. c_ini: Valor inicial del vector de c de entre los cuales se obtiene el
% �ptimo
% 2. c_paso: Valor de paso de c del vector de c de entre los cuales se obtiene el
% �ptimo
% 3. c_fin: Valor final del vector de c de entre los cuales se obtiene el
% �ptimo
% 4. c_vect: Vector de c
% 5. F: Valor de elevaci�n en el punto de control elegido para cada valor
% de los forzamientos contenidos en la muestra de tama�o M y seleccionados
% mediante el m�todo MDA. Por cada punto de la muestra, una simulaci�n y
% un valor de elevaci�n en el punto de control elegido.
% 6. d: Matriz con n�mero de columnas igual al n�mero de forzamientos
% considerados y n�mero de filas igual al n�mero de puntos de la muestra
% (M). d contiene los valores de la muestra seleccionados mediante el MDA y
% normalizados
% 7. Forzamiento: Estructura con las series temporales de los forzamientos 
% considerados
% 8. M: N�mero de puntos que se quiere que tenga la muestra
% 9. PC: Punto de control elegido
% 10. Forz_input: Estructura que indica con 1 los forzamientos a considerar
% y con 0 el resto%
%
%
% Datos de salida:
% 1. c: Valor �ptimo del par�metro de forma
% 2. E: Error asociado a dicho valor �ptimo del par�mtro de forma
%
%
%
%                                              Granada, 15 de marzo de 2016
%                                                     Juan del Rosal Salido
%                                   Grupo de Din�mica de Flujos Ambientales 
%                                                    Universidad de Granada
%__________________________________________________________________________

VAR = var;
[c_WL,E_WL]=PARAMETRO_FORMA_RIPPA_99(c_ini,c_paso,c_fin,c_vect,VAR,F,d,Forzamiento,M,PC,Forz_input, SC, OF, var);
c=c_WL;
E=E_WL;
    

end