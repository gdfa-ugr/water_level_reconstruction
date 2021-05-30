function pos=BUSQUEDA_POSICIONES(d,X)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% BUSQUEDA_POSICIONES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%_________________________________________________________________________
% 
% Descripcion: Función que obtiene las posiciones que ocupan cada uno de 
% los puntos de la muestra seleccionados mediante el MDA en la serie
% temporal completa de los forzamientos (X)
%
% Datos de entrada:
% 1. d: Matriz con número de columnas igual al número de forzamientos
% considerados y número de filas igual al número de puntos de la muestra
% (M). d contiene los valores de la muestra seleccionados mediante el MDA y
% normalizados
% 2. X: Almacena en cada columna la serie temporal completa de cada uno de
% los forzamientos considerados sin normalizar.
%
% Datos de salida:
% 1. pos: Posiciones de cada uno de los puntos de la muestra en las series 
% temporales completas.
%
%
%
%
%                                              Granada, 15 de marzo de 2016
%                                                     Juan del Rosal Salido
%                                   Grupo de Dinámica de Flujos Ambientales 
%                                                    Universidad de Granada
%__________________________________________________________________________

tam=length(d(1,:));

if tam==1
    for j=1:length(d(:,1))
       val=find(X(:,1)==d(j,1)); 
       pos(j)=val(1);
    end
end

if tam==2
    for j=1:length(d(:,1))
       val=find(X(:,1)==d(j,1) & X(:,2)==d(j,2)); 
       pos(j)=val(1);
    end
end

if tam==3
    for j=1:length(d(:,1))
       val=find(X(:,1)==d(j,1) & X(:,2)==d(j,2) & X(:,3)==d(j,3)); 
       pos(j)=val(1);
    end
end

if tam==4
    for j=1:length(d(:,1))
       val=find(X(:,1)==d(j,1) & X(:,2)==d(j,2) & X(:,3)==d(j,3) & X(:,4)==d(j,4)); 
       pos(j)=val(1);
    end
end

if tam==5
    for j=1:length(d(:,1))
       val=find(X(:,1)==d(j,1) & X(:,2)==d(j,2) & X(:,3)==d(j,3) & X(:,4)==d(j,4) & X(:,5)==d(j,5)); 
       pos(j)=val(1);
    end
end

if tam==6
    for j=1:length(d(:,1))
       val=find(X(:,1)==d(j,1) & X(:,2)==d(j,2) & X(:,3)==d(j,3) & X(:,4)==d(j,4) & X(:,5)==d(j,5) & X(:,6)==d(j,6)); 
       pos(j)=val(1);
    end
end

if tam==7
    for j=1:length(d(:,1))
       val=find(X(:,1)==d(j,1) & X(:,2)==d(j,2) & X(:,3)==d(j,3) & X(:,4)==d(j,4) & X(:,5)==d(j,5) & X(:,6)==d(j,6) & X(:,7)==d(j,7)); 
       pos(j)=val(1);
    end
end

if tam==8
    for j=1:length(d(:,1))
       val=find(X(:,1)==d(j,1) & X(:,2)==d(j,2) & X(:,3)==d(j,3) & X(:,4)==d(j,4) & X(:,5)==d(j,5) & X(:,6)==d(j,6) & X(:,7)==d(j,7) & X(:,8)==d(j,8)); 
       pos(j)=val(1);
    end
end


