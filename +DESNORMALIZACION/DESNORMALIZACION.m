function D=DESNORMALIZACION(Forzamiento,pos, slr_sc)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% DESNORMALIZACIÓN
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%_________________________________________________________________________
% 
% Descripcion: Función que desnormaliza la matriz d de los puntos de la
% muestra
%
% Datos de entrada:
% 1. Forzamiento: Estructura con las series temporales de los forzamientos 
% considerados
% 2. pos: Posiciones de cada uno de los puntos de la muestra en las series 
% temporales completas.
%
% Datos de salida:
% 1. D: Matriz con las posiciones de cada uno de los puntos de la muestra 
% sin normalizar.
%
%
%
%                                              Granada, 15 de marzo de 2016
%                                                     Juan del Rosal Salido
%                                   Grupo de Dinámica de Flujos Ambientales 
%                                                    Universidad de Granada
%__________________________________________________________________________

%Obtengo los forzamientos que se han elegido
names = fieldnames(Forzamiento);
l=length(names);

fold_name='';
for j=1:l
   fold_name=[fold_name char(names(j)),'_']; 
end

%Generación del vector D en función de los forzamientos elegidos
D=[];
for j=1:l
    
   forz=Forzamiento.(names{j});
   var=fieldnames(Forzamiento.(names{j}));
   
   comp_oleaje=strcmp(names{j},'O');
   comp_Oleaje_desembocadura=strcmp(names{j},'OD');  
   comp_Oleaje_desembocadura_sin_viento=strcmp(names{j},'ODSV'); 
   comp_m_meteo=strcmp(names{j},'MM');
   if comp_oleaje
      h=Forzamiento.(names{j}).(var{1}); 
      tp=Forzamiento.(names{j}).(var{2});
      d_o=Forzamiento.(names{j}).(var{3});
      D=[D  h  tp  d_o];
      
   elseif comp_Oleaje_desembocadura
      Hs=Forzamiento.(names{j}).(var{1})'; 
      Tp=Forzamiento.(names{j}).(var{2})';
      Do=Forzamiento.(names{j}).(var{3})';
      D=[D  Hs  Tp  Do];
      
   elseif comp_Oleaje_desembocadura_sin_viento
      Hs=Forzamiento.(names{j}).(var{1}); 
      Tp=Forzamiento.(names{j}).(var{2});
      Do=Forzamiento.(names{j}).(var{3});
      D=[D  Hs  Tp  Do];
   
   elseif comp_m_meteo
      if strcmp(fold_name,'O_MM_')
       vv=Forzamiento.(names{j}).(var{1}); 
       d_v=Forzamiento.(names{j}).(var{2});
       D=[D  vv d_v];
      else
       vv=Forzamiento.(names{j}).(var{1}); 
       d_v=Forzamiento.(names{j}).(var{2});
       pnm=Forzamiento.(names{j}).(var{4}); 
       D=[D  vv' d_v' pnm];               
      end
       
   else
      var=Forzamiento.(names{j}).(var{1});
      D=[D  var];
   end
    
end

% Me quedo únicamente con los valores de los forzamientos que corresponden
% a las posiciones elegidas
D=D(pos,:);