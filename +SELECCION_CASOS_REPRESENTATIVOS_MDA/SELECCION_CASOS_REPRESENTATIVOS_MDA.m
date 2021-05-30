function [d,X]=SELECCION_CASOS_REPRESENTATIVOS_MDA(Forzamiento_norm,M)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% SELECCION_CASOS_REPRESENTATIVOS_MDA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%_________________________________________________________________________
% 
% Descripcion: Funcion que aplica el método de la máxima dissimilaridad
% (MDA) para la selección de los casos representativos a partir de los
% cuales se realizará la interpolación.
%
% Datos de entrada:
% 1. Forzamiento_norm: Estructura con las series temporales de los 
% forzamientos considerados normalizados
% 2. M: Número de puntos que se quiere que tenga la muestra
%
% Datos de salida:
% 1. d: Matriz con número de columnas igual al número de forzamientos
% considerados y número de filas igual al número de puntos de la muestra
% (M). d contiene los valores de la muestra seleccionados mediante el MDA y
% normalizados
% 2. X: Almacena en cada columna la serie temporal completa de cada uno de
% los forzamientos considerados sin normalizar.
%
%
%
%
%                                              Granada, 15 de marzo de 2016
%                                                     Juan del Rosal Salido
%                                   Grupo de Dinámica de Flujos Ambientales 
%                                                    Universidad de Granada
%__________________________________________________________________________


%Obtengo los forzamientos que se han elegido
names = fieldnames(Forzamiento_norm);
l=length(names);

%Creo una carpeta diferente para cada combinación de agentes en la que voy
%a guardar los puntos de la muestra para no tener que calcularlos cada vez
fold_name='';
for j=1:l
   fold_name=[fold_name char(names(j)),'_']; 
end

%Creo la carpeta dentro de datos
%addpath('\DATOS\MUESTRA')
if ~exist(['DATOS\MUESTRA\' fold_name],'dir')
    mkdir(['DATOS\MUESTRA\' fold_name])
end
addpath(['DATOS\MUESTRA\' fold_name])

%Busco si existe un fichero con M puntos de la muestra o más
file_name=[fold_name 'M=' num2str(M)];

% Compruebo si hay archivos en la carpeta, si los hay los cargo para ver si
% son mayores al número de valores de la muestra que deseo. Si no hay o el
% número de valores es menor aplico el proceso de selección mediante MDA
s = what(['DATOS\MUESTRA\' fold_name]);
files=s(1,1).mat;

if isempty(files)    
    
    %Generación del vector x en función de los forzamientos elegidos
    x=[];
    for j=1:l

       forz=Forzamiento_norm.(names{j});
       var=fieldnames(Forzamiento_norm.(names{j}));

       comp_oleaje=strcmp(names{j},'O');
       comp_Oleaje_desembocadura=strcmp(names{j},'OD');   
       comp_Oleaje_desembocadura_sin_viento=strcmp(names{j},'ODSV'); 
       comp_m_meteo=strcmp(names{j},'MM');
       if comp_oleaje
          h_norm=Forzamiento_norm.(names{j}).(var{1}); 
          tp_norm=Forzamiento_norm.(names{j}).(var{2});
          d_o_norm=Forzamiento_norm.(names{j}).(var{3});
          x=[x  h_norm  tp_norm  d_o_norm];
          
       elseif comp_Oleaje_desembocadura
          Hs_norm=Forzamiento_norm.(names{j}).(var{1}); 
          Tp_norm=Forzamiento_norm.(names{j}).(var{2});
          Do_norm=Forzamiento_norm.(names{j}).(var{3});
          x=[x  Hs_norm  Tp_norm  Do_norm];
          
       elseif comp_Oleaje_desembocadura_sin_viento
          Hs_norm=Forzamiento_norm.(names{j}).(var{1}); 
          Tp_norm=Forzamiento_norm.(names{j}).(var{2});
          Do_norm=Forzamiento_norm.(names{j}).(var{3});
          x=[x  Hs_norm  Tp_norm  Do_norm];

       elseif comp_m_meteo
           if strcmp(fold_name,'O_MM_')
            vv_norm=Forzamiento_norm.(names{j}).(var{1}); 
            d_v_norm=Forzamiento_norm.(names{j}).(var{2});
            x=[x  vv_norm  d_v_norm];
           else
            vv_norm=Forzamiento_norm.(names{j}).(var{1}); 
            d_v_norm=Forzamiento_norm.(names{j}).(var{2});
            pnm_norm=Forzamiento_norm.(names{j}).(var{6}); 
            x=[x  vv_norm  d_v_norm  pnm_norm];               
           end

       else
          var=Forzamiento_norm.(names{j}).(var{1});
          x=[x  var];
       end

    end

    X=x; %Guardo mis forzamientos normalizados en una variable X porque a x le
    % voy a ir quitando elementos.

    % Elijo el primer valor de la muestra
    [x,d]=SELECCION_PRIMER_VALOR(x,Forzamiento_norm);

    % Elijo el segundo valor de la muestra
    [x,d]=SELECCION_SEGUNDO_VALOR(x,d,Forzamiento_norm);

    % Se eligen el resto de valores de la muestra hasta M
    progressbar('Total valores',['Valor n']) 
    for m=3:M         
        progressbar([],0) % Reset 2nd bar
        [x,d]=SELECCION_RESTO_VALORES(x,d,m,Forzamiento_norm);
        
        %Voy guardando automaticamente cada 100 puntos
        if m==100 || m==200 || m==300 || m==400 || m==500 || ...
                m==600 || m==700 || m==800 || m==900 || m==1000
            file_name_prov=[fold_name 'M=' num2str(m)];
            save(['DATOS\MUESTRA\' fold_name '\' file_name_prov '.mat'],'d','X')   
        end
        
        progressbar(m/M) % Update 1st bar
    end

        save(['DATOS\MUESTRA\' fold_name '\' file_name '.mat'],'d','X')
    
else   
    
    s=size(files);
    s=s(1);

    %Almaceno el número de valores de la muestra de cada fichero
    for j=1:s
        Str=char(files(j)); 
        Key   = '=';
        Index = strfind(Str, Key);
        Value(j) = sscanf(Str(Index(1) + length(Key):end), '%g', 1);
    end

    % Busco el máximo y su posición
    [maximo pos]=max(Value);

    if maximo>=M %Si maximo es mayor o igual que M me quedo con el fichero

        %Si el máximo es mayor o igual a M me quedo con el fichero
        file_name=[fold_name 'M=' num2str(maximo)];
        load(['DATOS\MUESTRA\' fold_name '\' file_name '.mat'])

        %Me quedo únicamente con los M primeros valores
        d=d(1:M,:);
        
    elseif maximo<M % Si el número de puntos de la muestra es menor al deseado.
        %En este caso cargo el archivo, tomo los maximo
        %primeros valores y el resto los calculo.
        file_name=[fold_name 'M=' num2str(maximo)];
        load(['DATOS\MUESTRA\' fold_name '\' file_name '.mat'])
        
        %Inicializo el vector x
        x=X;
        
        %Voy eliminando de x los valores de d
        [~,indx]=ismember(d,x,'rows');
        x(indx,:)=[]; 
        
        % Se eligen el resto de valores de la muestra hasta M
        progressbar('Total valores',['Valor n']) 
        for m=maximo+1:M         
            progressbar([],0) % Reset 2nd bar
            [x,d]=SELECCION_RESTO_VALORES(x,d,m,Forzamiento_norm);  
            progressbar(m/M) % Update 1st bar
            
            %Voy guardando automaticamente cada 100 puntos
            if m==100 || m==200 || m==300 || m==400 || m==500 || ...
                    m==600 || m==700 || m==800 || m==900 || m==1000
                file_name_prov=[fold_name 'M=' num2str(m)];
                save(['DATOS\MUESTRA\' fold_name '\' file_name_prov '.mat'],'d','X')   
            end
        end       

        
    end
    
    file_name=[fold_name 'M=' num2str(M)];
    save(['DATOS\MUESTRA\' fold_name '\' file_name '.mat'],'d','X')
        
%    
%         
%     %Generación del vector x en función de los forzamientos elegidos
% x=[];
%     for j=1:l
% 
%        forz=Forzamiento_norm.(names{j});
%        var=fieldnames(Forzamiento_norm.(names{j}));
% 
%        comp_oleaje=strcmp(names{j},'O');
%        comp_Oleaje_desembocadura=strcmp(names{j},'OD');   
%        comp_Oleaje_desembocadura_sin_viento=strcmp(names{j},'ODSV'); 
%        comp_m_meteo=strcmp(names{j},'MM');
%        if comp_oleaje
%           h_norm=Forzamiento_norm.(names{j}).(var{1}); 
%           tp_norm=Forzamiento_norm.(names{j}).(var{2});
%           d_o_norm=Forzamiento_norm.(names{j}).(var{3});
%           x=[x  h_norm'  tp_norm'  d_o_norm'];
%           
%        elseif comp_Oleaje_desembocadura
%           Hs_norm=Forzamiento_norm.(names{j}).(var{1}); 
%           Tp_norm=Forzamiento_norm.(names{j}).(var{2});
%           Do_norm=Forzamiento_norm.(names{j}).(var{3});
%           x=[x  Hs_norm'  Tp_norm'  Do_norm'];
%           
%        elseif comp_Oleaje_desembocadura_sin_viento
%           Hs_norm=Forzamiento_norm.(names{j}).(var{1}); 
%           Tp_norm=Forzamiento_norm.(names{j}).(var{2});
%           Do_norm=Forzamiento_norm.(names{j}).(var{3});
%           x=[x  Hs_norm'  Tp_norm'  Do_norm'];
% 
%        elseif comp_m_meteo
%           vv_norm=Forzamiento_norm.(names{j}).(var{1}); 
%           d_v_norm=Forzamiento_norm.(names{j}).(var{2});
%           x=[x  vv_norm'  d_v_norm'];
% 
%        else
%           var=Forzamiento_norm.(names{j}).(var{1});
%           x=[x  var'];
%        end
% 
%     end
% 
%     X=x; %Guardo mis forzamientos normalizados en una variable X porque a x le
%     % voy a ir quitando elementos.
% 
%     % Elijo el primer valor de la muestra
%     [x,d]=SELECCION_PRIMER_VALOR(x,Forzamiento_norm);
% 
%     % Elijo el segundo valor de la muestra
%     [x,d]=SELECCION_SEGUNDO_VALOR(x,d,Forzamiento_norm);
% 
%     % Se eligen el resto de valores de la muestra hasta M
%     progressbar('Total valores',['Valor n']) 
%     for m=3:M         
%         progressbar([],0) % Reset 2nd bar
%         [x,d]=SELECCION_RESTO_VALORES(x,d,m,Forzamiento_norm);  
%         progressbar(m/M) % Update 1st bar
%     end    
% 
% 
%     save(['DATOS\MUESTRA\' fold_name '\' file_name '.mat'],'d','X')  
%         
%         
% 
%     end

end


end


