function F=EXTRACCION_VALOR_DE_F(PC,M,Forzamiento,Forzamiento_3h,pos,Forz_input,SC, OF, var)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% EXTRACCION_VALOR_DE_F
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%_________________________________________________________________________
% 
% Descripcion: Funcion que extrae de cada simulación generada para Delft3D 
% los valores de elevación en los puntos de control que se elijan. Por cada
% valor de la muestra elegido mediante el MDA se tendrá una simulación en
% Delft3D y un valor de elevación en cada punto de control.
%
% Datos de entrada:
% 1. PC: Punto de control elegido
% 2. Forzamiento_norm: Estructura con las series temporales de los 
% forzamientos considerados normalizados
% 3. M: Número de puntos que se quiere que tenga la muestra
% 4. pos: Posiciones de cada uno de los puntos de la muestra en las series 
% temporales completas.
% 5. Forz_input: Estructura que indica con 1 los forzamientos a considerar
% y con 0 el resto
%
%
% Datos de salida:
% 1. F: Valor de elevación en el punto de control elegido para cada valor
% de los forzamientos contenidos en la muestra de tamaño M y seleccionados
% mediante el método MDA. Por cada punto de la muestra, una simulación y
% un valor de elevación en el punto de control elegido.
%
%
%
%
%                                              Granada, 15 de marzo de 2016
%                                                     Juan del Rosal Salido
%                                   Grupo de Dinámica de Flujos Ambientales 
%                                                    Universidad de Granada
%__________________________________________________________________________

if strcmp(var, 'eta')

    %Primera comprobación ¿Existe oleaje como forzamiento?
    comp_oleaje=isfield(Forzamiento,'O');
    comp_oleaje_desembocadura=isfield(Forzamiento,'OD');
    comp_oleaje_desembocadura_sin_viento=isfield(Forzamiento,'ODSV');
    comp_m_meteo=isfield(Forzamiento,'MM');
    comp_m_astro = (isfield(Forzamiento,'MA_95_85') || isfield(Forzamiento,'MA_05_45'));
    comp_descarga_fluvial=isfield(Forzamiento,'Q');
    comp_slr = (isfield(Forzamiento,'SLR_95_85') || isfield(Forzamiento,'SLR_05_45'));

    if  comp_oleaje==0 && comp_m_meteo==0 && comp_oleaje_desembocadura==0 && comp_oleaje_desembocadura_sin_viento==0 % Caso 1 no hay ni olejae ni m.meteo

        %% Extraccion de SLR
        if comp_slr == 1 && Forz_input.MA==0 && Forz_input.Q==0
            
        %En primer lugar compruebo si ya existe el valor de F guardado para
        %ese forzamiento y punto de control
        if exist(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\SLR\' SC '\' OF '\' 'SLR_M=' num2str(M) '_PC_' num2str(PC(2,1)) '_' num2str(PC(2,2)) '.mat'])==2
            %Si existe lo cargo
            load(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\SLR\' SC '\' OF '\' 'SLR_M=' num2str(M) '_PC_' num2str(PC(2,1)) '_' num2str(PC(2,2)) '.mat'])

        else %Si no existe pasamos a la segunda fase en dónde intetaremos optimziar la extraccion de F 

                %1º Vemos si existe la carpeta           
                if ~exist(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\SLR\' SC '\' OF],'dir')
                    mkdir(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\SLR\' SC '\' OF])
                end

                %1º Vemos que archivos tengo en la carpeta
                s = what(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\SLR\' SC '\' OF]);           
                % Compruebo si no hay archivos, en cuyo caso calculo F
                files=s(1,1).mat;
                s=size(files);
                s=s(1);

                if s==0
                    ini=1;
                    [F]=EXTRACCION_VALOR_DE_F_SLR(Forzamiento,Forzamiento_3h,PC,M,pos,ini,SC,OF,var);
                    save(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\SLR\' SC '\' OF '\' 'SLR_M=' num2str(M) '_PC_' num2str(PC(2,1)) '_' num2str(PC(2,2)) '.mat'],'F')

                else

                s = what(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\SLR\' SC '\' OF]);           
                % Compruebo si no hay archivos, en cuyo caso calculo F            
                files=s(1,1).mat;
                s=size(files);
                s=s(1);

            %2º Hacemos una lista de los archivos de F en mi punto de
            %control

            %Almaceno el número de valores de la muestra de cada fichero
            for j=1:s
                Str=char(files(j)); 
                Key   = '_';            
                Index = strfind(Str, Key);
                pos_pc1(j) = sscanf(Str(Index(end-1) + length(Key):end), '%g', 1);
                pos_pc2(j) = sscanf(Str(Index(end) + length(Key):end), '%g', 1);
                Key_value = '=';
                Index = strfind(Str, Key_value);
                Value(j) = sscanf(Str(Index(1) + length(Key_value):end), '%g', 1);
            end

            % Busco las posiciones de mi punto de control
            val=find(pos_pc1==PC(1) & pos_pc2==PC(2));

            %Busco los valores de M en dichas posiciones
            Value=Value(val);

            % Busco el máximo y su posición
            [maximo val]=max(Value);           

            %Posibilidad 1º: No tengo archivos --> Calculo el valor de F
            if isempty(files) 
                ini=1;
                [F]=EXTRACCION_VALOR_DE_F_SLR(Forzamiento,Forzamiento_3h,PC,M,pos,ini,SC,OF,var);
                save(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\SLR\' SC '\' OF '\' 'SLR_M=' num2str(M) '_PC_' num2str(PC(2,1)) '_' num2str(PC(2,2)) '.mat'],'F')

            %Posibilidad 2ª: Hay archivos, pero ninguno es de mi punto de
            %control --> Calculo F
            elseif isempty(val)
                ini=1;
                [F]=EXTRACCION_VALOR_DE_F_SLR(Forzamiento,Forzamiento_3h,PC,M,pos,ini,SC,OF,var);
                save(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\SLR\' SC '\' OF '\' 'SLR_M=' num2str(M) '_PC_' num2str(PC(2,1)) '_' num2str(PC(2,2)) '.mat'],'F')

            %3ª Posibilidad Hay archivos en mi punto de control
            elseif isempty(val)==0

                %Tengo dos opciones: 
                if maximo>=M %Si el archivo en mi punto de control es mayor o igual que la M que busco
                    %En este caso tomo los M primeros valores                
                    load(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\SLR\' SC '\' OF '\' 'SLR_M=' num2str(maximo) '_PC_' num2str(PC(2,1)) '_' num2str(PC(2,2)) '.mat'])

                    %Me quedo únicamente con los M primeros valores
                    F.SLR.WL=F.SLR.WL(1:M);
                    F.SLR.t_WL=F.SLR.t_WL(1:M,:);
                    save(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\SLR\' SC '\' OF '\' 'SLR_M=' num2str(M) '_PC_' num2str(PC(2,1)) '_' num2str(PC(2,2)) '.mat'],'F')    


                elseif maximo<M %El archivo en mi punto de control es menor que la M que busco.

                    %En este caso cargo el archivo, tomo los maximo
                    %primeros valores y el resto los calculo.
                    load(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\SLR\' SC '\' OF '\' 'SLR_M=' num2str(maximo) '_PC_' num2str(PC(2,1)) '_' num2str(PC(2,2)) '.mat'])

                    ini=maximo+1;
                    [F]=EXTRACCION_VALOR_DE_F_SLR(Forzamiento,Forzamiento_3h,PC,M,pos,ini,SC,OF,var);

                    %Me cargo las posiciones no validas
                    F_nuevo.SLR.WL(1:maximo)=[];
                    F_nuevo.SLR.t_WL(1:maximo,:)=[];

                    %Lo junto todo
                    F.SLR.WL=[F.SLR.WL F_nuevo.SLR.WL];
                    F.SLR.t_WL=[F.SLR.t_WL; F_nuevo.SLR.t_WL];

                    save(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\SLR\' SC '\' OF '\' 'SLR_M=' num2str(M) '_PC_' num2str(PC(2,1)) '_' num2str(PC(2,2)) '.mat'],'F')
                end
            end
            end   
        end
            
            
        end
        
        
        %% En el caso 1, sólo puedo tener MA o Q o ambos
        if Forz_input.MA==1 && Forz_input.Q==0 %Caso 1 Opción 1: Tengo sólo MA

            %En primer lugar compruebo si ya existe el valor de F guardado para
            %ese forzamiento y punto de control
            if exist(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\MA\' 'MA_M=' num2str(M) '_PC_' num2str(PC(1)) '_' num2str(PC(2)) '.mat'])==2
                %Si existe lo cargo
                load(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\MA\' 'MA_M=' num2str(M) '_PC_' num2str(PC(1)) '_' num2str(PC(2)) '.mat'])

            else %Si no existe pasamos a la segunda fase en dónde intetaremos optimziar la extraccion de F 

                %1º Vemos si existe la carpeta           
                if ~exist(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\MA'],'dir')
                    mkdir(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\MA'])
                end


                %1º Vemos que archivos tengo en la carpeta
                s = what(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\MA']);           
                % Compruebo si no hay archivos, en cuyo caso calculo F
                files=s(1,1).mat;
                s=size(files);
                s=s(1);

                if s==0
                    ini=1;
                    [F]=EXTRACCION_VALOR_DE_F_MA(Forzamiento,PC,M,pos,ini);
                    save(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\MA\' 'MA_M=' num2str(M) '_PC_' num2str(PC(1)) '_' num2str(PC(2)) '.mat'],'F')

                else

                s = what(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\MA']);           
                % Compruebo si no hay archivos, en cuyo caso calculo F            
                files=s(1,1).mat;
                s=size(files);
                s=s(1);

                %2º Hacemos una lista de los archivos de F en mi punto de
                %control

                %Almaceno el número de valores de la muestra de cada fichero
                for j=1:s
                    Str=char(files(j)); 
                    Key   = '_';            
                    Index = strfind(Str, Key);
                    pos_pc1(j) = sscanf(Str(Index(3) + length(Key):end), '%g', 1);
                    pos_pc2(j) = sscanf(Str(Index(4) + length(Key):end), '%g', 1);
                    Key_value = '=';
                    Index = strfind(Str, Key_value);
                    Value(j) = sscanf(Str(Index(1) + length(Key_value):end), '%g', 1);
                end

                % Busco las posiciones de mi punto de control
                val=find(pos_pc1==PC(1) & pos_pc2==PC(2));

                %Busco los valores de M en dichas posiciones
                Value=Value(val);

                % Busco el máximo y su posición
                [maximo val]=max(Value);           

                %Posibilidad 1º: No tengo archivos --> Calculo el valor de F
                if isempty(files) 
                    ini=1;
                    [F]=EXTRACCION_VALOR_DE_F_MA(Forzamiento,PC,M,pos,ini);
                    save(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\MA\' 'MA_M=' num2str(M) '_PC_' num2str(PC(1)) '_' num2str(PC(2)) '.mat'],'F')

                %Posibilidad 2ª: Hay archivos, pero ninguno es de mi punto de
                %control --> Calculo F
                elseif isempty(val)
                    ini=1;
                    [F]=EXTRACCION_VALOR_DE_F_MA(Forzamiento,PC,M,pos,ini);
                    save(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\MA\' 'MA_M=' num2str(M) '_PC_' num2str(PC(1)) '_' num2str(PC(2)) '.mat'],'F')

                %3ª Posibilidad Hay archivos en mi punto de control
                elseif isempty(val)==0

                    %Tengo dos opciones: 
                    if maximo>=M %Si el archivo en mi punto de control es mayor o igual que la M que busco
                        %En este caso tomo los M primeros valores                
                        load(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\MA\' 'MA_M=' num2str(maximo) '_PC_' num2str(PC(1)) '_' num2str(PC(2)) '.mat'])

                        %Me quedo únicamente con los M primeros valores
                        F.MA.WL=F.MA.WL(1:M);
                        F.MA.t_WL=F.MA.t_WL(1:M,:);
                        save(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\MA\' 'MA_M=' num2str(M) '_PC_' num2str(PC(1)) '_' num2str(PC(2)) '.mat'],'F')    


                    elseif maximo<M %El archivo en mi punto de control es menor que la M que busco.

                        %En este caso cargo el archivo, tomo los maximo
                        %primeros valores y el resto los calculo.
                        load(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\MA\' 'MA_M=' num2str(maximo) '_PC_' num2str(PC(1)) '_' num2str(PC(2)) '.mat'])

                        ini=maximo+1;
                        [F_nuevo]=EXTRACCION_VALOR_DE_F_MA(Forzamiento,PC,M,pos,ini);

                        %Me cargo las posiciones no validas
                        F_nuevo.MA.WL(1:maximo)=[];
                        F_nuevo.MA.t_WL(1:maximo,:)=[];

                        %Lo junto todo
                        F.MA.WL=[F.MA.WL F_nuevo.MA.WL];
                        F.MA.t_WL=[F.MA.t_WL; F_nuevo.MA.t_WL];                    

                        save(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\MA\' 'MA_M=' num2str(M) '_PC_' num2str(PC(1)) '_' num2str(PC(2)) '.mat'],'F')
                    end
                end
                end
            end

        %% En el caso 1, sólo puedo tener MA o Q o ambos
        elseif Forz_input.MA_DESPLAZ==1 && Forz_input.Q==0 %Caso 1 Opción 1: Tengo sólo MA_DESPLAZ

            %En primer lugar compruebo si ya existe el valor de F guardado para
            %ese forzamiento y punto de control
            if exist(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\MA_DESPLAZ\' 'MA_DESPLAZ_M=' num2str(M) '_PC_' num2str(PC(1)) '_' num2str(PC(2)) '.mat'])==2
                %Si existe lo cargo
                load(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\MA_DESPLAZ\' 'MA_DESPLAZ_M=' num2str(M) '_PC_' num2str(PC(1)) '_' num2str(PC(2)) '.mat'])

            else %Si no existe pasamos a la segunda fase en dónde intetaremos optimziar la extraccion de F 

                %1º Vemos que archivos tengo en la carpeta
                s = what(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\MA_DESPLAZ']);           
                % Compruebo si no hay archivos, en cuyo caso calculo F
                files=s(1,1).mat;
                s=size(files);
                s=s(1);

                if s==0
                    ini=1;
                    [F]=EXTRACCION_VALOR_DE_F_MA_DESPLAZ(Forzamiento,PC,M,pos,ini);
                    save(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\MA_DESPLAZ\' 'MA_DESPLAZ_M=' num2str(M) '_PC_' num2str(PC(1)) '_' num2str(PC(2)) '.mat'],'F')

                else

                s = what(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\MA_DESPLAZ']);           
                % Compruebo si no hay archivos, en cuyo caso calculo F            
                files=s(1,1).mat;
                s=size(files);
                s=s(1);

                %2º Hacemos una lista de los archivos de F en mi punto de
                %control

                %Almaceno el número de valores de la muestra de cada fichero
                for j=1:s
                    Str=char(files(j)); 
                    Key   = '_';            
                    Index = strfind(Str, Key);
                    pos_pc1(j) = sscanf(Str(Index(3) + length(Key):end), '%g', 1);
                    pos_pc2(j) = sscanf(Str(Index(4) + length(Key):end), '%g', 1);
                    Key_value = '=';
                    Index = strfind(Str, Key_value);
                    Value(j) = sscanf(Str(Index(1) + length(Key_value):end), '%g', 1);
                end

                % Busco las posiciones de mi punto de control
                val=find(pos_pc1==PC(1) & pos_pc2==PC(2));

                %Busco los valores de M en dichas posiciones
                Value=Value(val);

                % Busco el máximo y su posición
                [maximo val]=max(Value);           

                %Posibilidad 1º: No tengo archivos --> Calculo el valor de F
                if isempty(files) 
                    ini=1;
                    [F]=EXTRACCION_VALOR_DE_F_MA_DESPLAZ(Forzamiento,PC,M,pos,ini);
                    save(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\MA_DESPLAZ\' 'MA_DESPLAZ_M=' num2str(M) '_PC_' num2str(PC(1)) '_' num2str(PC(2)) '.mat'],'F')

                %Posibilidad 2ª: Hay archivos, pero ninguno es de mi punto de
                %control --> Calculo F
                elseif isempty(val)
                    ini=1;
                    [F]=EXTRACCION_VALOR_DE_F_MA_DESPLAZ(Forzamiento,PC,M,pos,ini);
                    save(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\MA_DESPLAZ\' 'MA_DESPLAZ_M=' num2str(M) '_PC_' num2str(PC(1)) '_' num2str(PC(2)) '.mat'],'F')

                %3ª Posibilidad Hay archivos en mi punto de control
                elseif isempty(val)==0

                    %Tengo dos opciones: 
                    if maximo>=M %Si el archivo en mi punto de control es mayor o igual que la M que busco
                        %En este caso tomo los M primeros valores                
                        load(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\MA_DESPLAZ\' 'MA_DESPLAZ_M=' num2str(maximo) '_PC_' num2str(PC(1)) '_' num2str(PC(2)) '.mat'])

                        %Me quedo únicamente con los M primeros valores
                        F.MA_DESPLAZ.WL=F.MA_DESPLAZ.WL(1:M);
                        F.MA_DESPLAZ.t_WL=F.MA_DESPLAZ.t_WL(1:M,:);
                        save(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\MA_DESPLAZ\' 'MA_DESPLAZ_M=' num2str(M) '_PC_' num2str(PC(1)) '_' num2str(PC(2)) '.mat'],'F')    


                    elseif maximo<M %El archivo en mi punto de control es menor que la M que busco.

                        %En este caso cargo el archivo, tomo los maximo
                        %primeros valores y el resto los calculo.
                        load(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\MA_DESPLAZ\' 'MA_DESPLAZ_M=' num2str(maximo) '_PC_' num2str(PC(1)) '_' num2str(PC(2)) '.mat'])

                        ini=maximo+1;
                        [F_nuevo]=EXTRACCION_VALOR_DE_F_MA_DESPLAZ(Forzamiento,PC,M,pos,ini);

                        %Me cargo las posiciones no validas
                        F_nuevo.MA_DESPLAZ.WL(1:maximo)=[];
                        F_nuevo.MA_DESPLAZ.t_WL(1:maximo,:)=[];

                        %Lo junto todo
                        F.MA_DESPLAZ.WL=[F.MA_DESPLAZ.WL F_nuevo.MA_DESPLAZ.WL];
                        F.MA_DESPLAZ.t_WL=[F.MA_DESPLAZ.t_WL; F_nuevo.MA_DESPLAZ.t_WL];                    

                        save(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\MA_DESPLAZ\' 'MA_DESPLAZ_M=' num2str(M) '_PC_' num2str(PC(1)) '_' num2str(PC(2)) '.mat'],'F')
                    end
                end
                end
            end

        %% Caso 1 Opción 2: Tengo sólo Q
        elseif Forz_input.MA==0 && Forz_input.Q==1 
            %En primer lugar compruebo si ya existe el valor de F guardado para
            %ese forzamiento y punto de control
            if exist(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\Q\' 'Q_M=' num2str(M) '_PC_' num2str(PC(1)) '_' num2str(PC(2)) '.mat'])==2
                %Si existe lo cargo
                load(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\Q\' 'Q_M=' num2str(M) '_PC_' num2str(PC(1)) '_' num2str(PC(2)) '.mat'])

            else %Si no existe pasamos a la segunda fase en dónde intetaremos optimziar la extraccion de F 

                %1º Vemos si existe la carpeta           
                if ~exist(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\Q'],'dir')
                    mkdir(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\Q'])
                end


                %1º Vemos que archivos tengo en la carpeta
                s = what(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\Q']);           
                % Compruebo si no hay archivos, en cuyo caso calculo F
                files=s(1,1).mat;
                s=size(files);
                s=s(1);

                if s==0
                    ini=1;
                    [F]=EXTRACCION_VALOR_DE_F_Q(Forzamiento,PC,M,pos,ini);
                    save(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\Q\' 'Q_M=' num2str(M) '_PC_' num2str(PC(1)) '_' num2str(PC(2)) '.mat'],'F')

                else

                s = what(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\Q']);           
                % Compruebo si no hay archivos, en cuyo caso calculo F            
                files=s(1,1).mat;
                s=size(files);
                s=s(1);

                %2º Hacemos una lista de los archivos de F en mi punto de
                %control

                %Almaceno el número de valores de la muestra de cada fichero
                for j=1:s
                    Str=char(files(j)); 
                    Key   = '_';            
                    Index = strfind(Str, Key);
                    pos_pc1(j) = sscanf(Str(Index(3) + length(Key):end), '%g', 1);
                    pos_pc2(j) = sscanf(Str(Index(4) + length(Key):end), '%g', 1);
                    Key_value = '=';
                    Index = strfind(Str, Key_value);
                    Value(j) = sscanf(Str(Index(1) + length(Key_value):end), '%g', 1);
                end

                % Busco las posiciones de mi punto de control
                val=find(pos_pc1==PC(1) & pos_pc2==PC(2));

                %Busco los valores de M en dichas posiciones
                Value=Value(val);

                % Busco el máximo y su posición
                [maximo val]=max(Value);           

                %Posibilidad 1º: No tengo archivos --> Calculo el valor de F
                if isempty(files) 
                    ini=1;
                    [F]=EXTRACCION_VALOR_DE_F_Q(Forzamiento,PC,M,pos,ini)
                    save(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\Q\' 'Q_M=' num2str(M) '_PC_' num2str(PC(1)) '_' num2str(PC(2)) '.mat'],'F')

                %Posibilidad 2ª: Hay archivos, pero ninguno es de mi punto de
                %control --> Calculo F
                elseif isempty(val)
                    ini=1;
                    [F]=EXTRACCION_VALOR_DE_F_Q(Forzamiento,PC,M,pos,ini)
                    save(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\Q\' 'Q_M=' num2str(M) '_PC_' num2str(PC(1)) '_' num2str(PC(2)) '.mat'],'F')

                %3ª Posibilidad Hay archivos en mi punto de control
                elseif isempty(val)==0

                    %Tengo dos opciones: 
                    if maximo>=M %Si el archivo en mi punto de control es mayor o igual que la M que busco
                        %En este caso tomo los M primeros valores                
                        load(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\Q\' 'Q_M=' num2str(maximo) '_PC_' num2str(PC(1)) '_' num2str(PC(2)) '.mat'])

                        %Me quedo únicamente con los M primeros valores
                        F.Q.WL=F.Q.WL(1:M);
                        F.Q.t_WL=F.Q.t_WL(1:M,:);
                        save(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\Q\' 'Q_M=' num2str(M) '_PC_' num2str(PC(1)) '_' num2str(PC(2)) '.mat'],'F')    


                    elseif maximo<M %El archivo en mi punto de control es menor que la M que busco.

                        %En este caso cargo el archivo, tomo los maximo
                        %primeros valores y el resto los calculo.
                        load(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\Q\' 'Q_M=' num2str(maximo) '_PC_' num2str(PC(1)) '_' num2str(PC(2)) '.mat'])

                        ini=maximo+1;
                        [F_nuevo]=EXTRACCION_VALOR_DE_F_Q(Forzamiento,PC,M,pos,ini);

                        %Me cargo las posiciones no validas
                        F_nuevo.Q.WL(1:maximo)=[];
                        F_nuevo.Q.t_WL(1:maximo,:)=[];

                        %Lo junto todo
                        F.Q.WL=[F.Q.WL F_nuevo.Q.WL]
                        F.Q.t_WL=[F.Q.t_WL; F_nuevo.Q.t_WL]

                        save(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\Q\' 'Q_M=' num2str(M) '_PC_' num2str(PC(1)) '_' num2str(PC(2)) '.mat'],'F')
                    end
                end
                end
            end
        end

    elseif  comp_oleaje==0 && comp_m_meteo==1 && comp_oleaje_desembocadura==0 && comp_oleaje_desembocadura_sin_viento==0 % Caso 2 Sólo tengo Marea Meteorológica
        %% Caso 2 Opción 1. Tengo sólo marea meteorológica
        %En primer lugar compruebo si ya existe el valor de F guardado para
        %ese forzamiento y punto de control
        if exist(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\MM\' 'MM_M=' num2str(M) '_PC_' num2str(PC(1)) '_' num2str(PC(2)) '.mat'])==2
            %Si existe lo cargo
            load(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\MM\' 'MM_M=' num2str(M) '_PC_' num2str(PC(1)) '_' num2str(PC(2)) '.mat'])

        else %Si no existe pasamos a la segunda fase en dónde intetaremos optimziar la extraccion de F 

                %1º Vemos si existe la carpeta           
                if ~exist(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\MM'],'dir')
                    mkdir(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\MM'])
                end


                %1º Vemos que archivos tengo en la carpeta
                s = what(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\MM']);           
                % Compruebo si no hay archivos, en cuyo caso calculo F
                files=s(1,1).mat;
                s=size(files);
                s=s(1);

                if s==0
                    ini=1;
                    [F]=EXTRACCION_VALOR_DE_F_MM(Forzamiento,PC,M,pos,ini);
                    save(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\MM\' 'MM_M=' num2str(M) '_PC_' num2str(PC(1)) '_' num2str(PC(2)) '.mat'],'F')

                else

                s = what(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\MM']);           
                % Compruebo si no hay archivos, en cuyo caso calculo F            
                files=s(1,1).mat;
                s=size(files);
                s=s(1);
            %2º Hacemos una lista de los archivos de F en mi punto de
            %control

            %Almaceno el número de valores de la muestra de cada fichero
            for j=1:s
                Str=char(files(j)); 
                Key   = '_';            
                Index = strfind(Str, Key);
                pos_pc1(j) = sscanf(Str(Index(3) + length(Key):end), '%g', 1);
                pos_pc2(j) = sscanf(Str(Index(4) + length(Key):end), '%g', 1);
                Key_value = '=';
                Index = strfind(Str, Key_value);
                Value(j) = sscanf(Str(Index(1) + length(Key_value):end), '%g', 1);
            end

            % Busco las posiciones de mi punto de control
            val=find(pos_pc1==PC(1) & pos_pc2==PC(2));

            %Busco los valores de M en dichas posiciones
            Value=Value(val);

            % Busco el máximo y su posición
            [maximo val]=max(Value);           

            %Posibilidad 1º: No tengo archivos --> Calculo el valor de F
            if isempty(files) 
                ini=1;
                [F]=EXTRACCION_VALOR_DE_F_MM(Forzamiento,PC,M,pos,ini)
                save(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\MM\' 'MM_M=' num2str(M) '_PC_' num2str(PC(1)) '_' num2str(PC(2)) '.mat'],'F')

            %Posibilidad 2ª: Hay archivos, pero ninguno es de mi punto de
            %control --> Calculo F
            elseif isempty(val)
                ini=1;
                [F]=EXTRACCION_VALOR_DE_F_MM(Forzamiento,PC,M,pos,ini)
                save(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\MM\' 'MM_M=' num2str(M) '_PC_' num2str(PC(1)) '_' num2str(PC(2)) '.mat'],'F')

            %3ª Posibilidad Hay archivos en mi punto de control
            elseif isempty(val)==0

                %Tengo dos opciones: 
                if maximo>=M %Si el archivo en mi punto de control es mayor o igual que la M que busco
                    %En este caso tomo los M primeros valores                
                    load(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\MM\' 'MM_M=' num2str(maximo) '_PC_' num2str(PC(1)) '_' num2str(PC(2)) '.mat'])

                    %Me quedo únicamente con los M primeros valores
                    F.MM.WL=F.MM.WL(1:M);
                    F.MM.t_WL=F.MM.t_WL(1:M,:);
                    save(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\MM\' 'MM_M=' num2str(M) '_PC_' num2str(PC(1)) '_' num2str(PC(2)) '.mat'],'F')    


                elseif maximo<M %El archivo en mi punto de control es menor que la M que busco.

                    %En este caso cargo el archivo, tomo los maximo
                    %primeros valores y el resto los calculo.
                    load(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\MM\' 'MM_M=' num2str(maximo) '_PC_' num2str(PC(1)) '_' num2str(PC(2)) '.mat'])

                    ini=maximo+1;
                    [F_nuevo]=EXTRACCION_VALOR_DE_F_MM(Forzamiento,PC,M,pos,ini)

                    %Me cargo las posiciones no validas
                    F_nuevo.MM.WL(1:maximo)=[];
                    F_nuevo.MM.t_WL(1:maximo,:)=[];

                    %Lo junto todo
                    F.MM.WL=[F.MM.WL F_nuevo.MM.WL];
                    F.MM.t_WL=[F.MM.t_WL; F_nuevo.MM.t_WL];

                    save(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\MM\' 'MM_M=' num2str(M) '_PC_' num2str(PC(1)) '_' num2str(PC(2)) '.mat'],'F')
                end
            end
        end
        end



    %% Caso 3 Sólo tengo Oleaje en la desembocadura sin viento
    elseif  comp_oleaje==0 && comp_m_meteo==0 && comp_oleaje_desembocadura==0 && comp_oleaje_desembocadura_sin_viento==1 

        %En primer lugar compruebo si ya existe el valor de F guardado para
        %ese forzamiento y punto de control
        if exist(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\ODSV\' 'ODSV_M=' num2str(M) '_PC_' num2str(PC(1)) '_' num2str(PC(2)) '.mat'])==2
            %Si existe lo cargo
            load(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\ODSV\' 'ODSV_M=' num2str(M) '_PC_' num2str(PC(1)) '_' num2str(PC(2)) '.mat'])

        else %Si no existe pasamos a la segunda fase en dónde intetaremos optimziar la extraccion de F 


                %1º Vemos si existe la carpeta           
                if ~exist(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\ODSV'],'dir')
                    mkdir(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\ODSV'])
                end

                %1º Vemos que archivos tengo en la carpeta
                s = what(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\ODSV']);           
                % Compruebo si no hay archivos, en cuyo caso calculo F
                files=s(1,1).mat;
                s=size(files);
                s=s(1);

                if s==0
                    ini=1;
                    [F]=EXTRACCION_VALOR_DE_F_ODSV(Forzamiento,PC,M,pos,ini);
                    save(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\ODSV\' 'ODSV_M=' num2str(M) '_PC_' num2str(PC(1)) '_' num2str(PC(2)) '.mat'],'F')

                else

                s = what(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\ODSV']);           
                % Compruebo si no hay archivos, en cuyo caso calculo F            
                files=s(1,1).mat;
                s=size(files);
                s=s(1);

            %2º Hacemos una lista de los archivos de F en mi punto de
            %control

            %Almaceno el número de valores de la muestra de cada fichero
            for j=1:s
                Str=char(files(j)); 
                Key   = '_';            
                Index = strfind(Str, Key);
                pos_pc1(j) = sscanf(Str(Index(3) + length(Key):end), '%g', 1);
                pos_pc2(j) = sscanf(Str(Index(4) + length(Key):end), '%g', 1);
                Key_value = '=';
                Index = strfind(Str, Key_value);
                Value(j) = sscanf(Str(Index(1) + length(Key_value):end), '%g', 1);
            end

            % Busco las posiciones de mi punto de control
            val=find(pos_pc1==PC(1) & pos_pc2==PC(2));

            %Busco los valores de M en dichas posiciones
            Value=Value(val);

            % Busco el máximo y su posición
            [maximo val]=max(Value);           

            %Posibilidad 1º: No tengo archivos --> Calculo el valor de F
            if isempty(files) 
                ini=1;
                [F]=EXTRACCION_VALOR_DE_F_ODSV(Forzamiento,PC,M,pos,ini);
                save(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\ODSV\' 'ODSV_M=' num2str(M) '_PC_' num2str(PC(1)) '_' num2str(PC(2)) '.mat'],'F')

            %Posibilidad 2ª: Hay archivos, pero ninguno es de mi punto de
            %control --> Calculo F
            elseif isempty(val)
                ini=1;
                [F]=EXTRACCION_VALOR_DE_F_ODSV(Forzamiento,PC,M,pos,ini);
                save(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\ODSV\' 'ODSV_M=' num2str(M) '_PC_' num2str(PC(1)) '_' num2str(PC(2)) '.mat'],'F')

            %3ª Posibilidad Hay archivos en mi punto de control
            elseif isempty(val)==0

                %Tengo dos opciones: 
                if maximo>=M %Si el archivo en mi punto de control es mayor o igual que la M que busco
                    %En este caso tomo los M primeros valores                
                    load(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\ODSV\' 'ODSV_M=' num2str(maximo) '_PC_' num2str(PC(1)) '_' num2str(PC(2)) '.mat'])

                    %Me quedo únicamente con los M primeros valores
                    F.ODSV.eta=F.ODSV.eta(1:M);
                    F.ODSV.Hs= F.ODSV.Hs(1:M);
                    F.ODSV.WL=F.ODSV.WL(1:M);
                    F.ODSV.t_WL=F.ODSV.t_WL(1:M,:);
                    save(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\ODSV\' 'ODSV_M=' num2str(M) '_PC_' num2str(PC(1)) '_' num2str(PC(2)) '.mat'],'F')    


                elseif maximo<M %El archivo en mi punto de control es menor que la M que busco.

                    %En este caso cargo el archivo, tomo los maximo
                    %primeros valores y el resto los calculo.
                    load(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\ODSV\' 'ODSV_M=' num2str(maximo) '_PC_' num2str(PC(1)) '_' num2str(PC(2)) '.mat'])

                    ini=maximo+1;
                    [F_nuevo]=EXTRACCION_VALOR_DE_F_ODSV(Forzamiento,PC,M,pos,ini);

                    %Me cargo las posiciones no validas
                    F_nuevo.ODSV.eta(1:maximo)=[];
                    F_nuevo.ODSV.Hs(1:maximo)=[];
                    F_nuevo.ODSV.WL(1:maximo)=[];
                    F_nuevo.ODSV.t_WL(1:maximo,:)=[];

                    %Lo junto todo
                    F.ODSV.eta=[F.ODSV.eta F_nuevo.ODSV.eta];
                    F.ODSV.Hs=[F.ODSV.Hs F_nuevo.ODSV.Hs];
                    F.ODSV.WL=[F.ODSV.WL F_nuevo.ODSV.WL];
                    F.ODSV.t_WL=[F.ODSV.t_WL; F_nuevo.ODSV.t_WL];

                    save(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\ODSV\' 'ODSV_M=' num2str(M) '_PC_' num2str(PC(1)) '_' num2str(PC(2)) '.mat'],'F')
                end
            end
        end 
        end

    %% Caso 2-3 Tengo marea meteo + oleaje en la desembocadura
    elseif  comp_oleaje==0 && comp_m_meteo==1 && comp_oleaje_desembocadura==1 && comp_oleaje_desembocadura_sin_viento==0 && comp_m_astro==0 && comp_descarga_fluvial==0 

        %En primer lugar compruebo si ya existe el valor de F guardado para
        %ese forzamiento y punto de control
        if exist(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\MM_OD\' 'MM_OD_M=' num2str(M) '_PC_' num2str(PC(1)) '_' num2str(PC(2)) '.mat'])==2
            %Si existe lo cargo
            load(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\MM_OD\' 'MM_OD_M=' num2str(M) '_PC_' num2str(PC(1)) '_' num2str(PC(2)) '.mat'])

        else %Si no existe pasamos a la segunda fase en dónde intetaremos optimziar la extraccion de F 

                %1º Vemos si existe la carpeta           
                if ~exist(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\MM_OD'],'dir')
                    mkdir(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\MM_OD'])
                end

                %1º Vemos que archivos tengo en la carpeta
                s = what(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\MM_OD']);           
                % Compruebo si no hay archivos, en cuyo caso calculo F
                files=s(1,1).mat;
                s=size(files);
                s=s(1);

                if s==0
                    ini=1;
                    [F]=EXTRACCION_VALOR_DE_F_MM_OD(Forzamiento,PC,M,pos,ini);
                    save(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\MM_OD\' 'MM_OD_M=' num2str(M) '_PC_' num2str(PC(1)) '_' num2str(PC(2)) '.mat'],'F')

                else

                s = what(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\MM_OD']);           
                % Compruebo si no hay archivos, en cuyo caso calculo F            
                files=s(1,1).mat;
                s=size(files);
                s=s(1);

            %2º Hacemos una lista de los archivos de F en mi punto de
            %control

            %Almaceno el número de valores de la muestra de cada fichero
            for j=1:s
                Str=char(files(j)); 
                Key   = '_';            
                Index = strfind(Str, Key);
                pos_pc1(j) = sscanf(Str(Index(end-1) + length(Key):end), '%g', 1);
                pos_pc2(j) = sscanf(Str(Index(end) + length(Key):end), '%g', 1);
                Key_value = '=';
                Index = strfind(Str, Key_value);
                Value(j) = sscanf(Str(Index(1) + length(Key_value):end), '%g', 1);
            end

            % Busco las posiciones de mi punto de control
            val=find(pos_pc1==PC(1) & pos_pc2==PC(2));

            %Busco los valores de M en dichas posiciones
            Value=Value(val);

            % Busco el máximo y su posición
            [maximo val]=max(Value);           

            %Posibilidad 1º: No tengo archivos --> Calculo el valor de F
            if isempty(files) 
                ini=1;
                [F]=EXTRACCION_VALOR_DE_F_MM_OD(Forzamiento,PC,M,pos,ini);
                save(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\MM_OD\' 'MM_OD_M=' num2str(M) '_PC_' num2str(PC(1)) '_' num2str(PC(2)) '.mat'],'F')

            %Posibilidad 2ª: Hay archivos, pero ninguno es de mi punto de
            %control --> Calculo F
            elseif isempty(val)
                ini=1;
                [F]=EXTRACCION_VALOR_DE_F_MM_OD(Forzamiento,PC,M,pos,ini);
                save(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\MM_OD\' 'MM_OD_M=' num2str(M) '_PC_' num2str(PC(1)) '_' num2str(PC(2)) '.mat'],'F')

            %3ª Posibilidad Hay archivos en mi punto de control
            elseif isempty(val)==0

                %Tengo dos opciones: 
                if maximo>=M %Si el archivo en mi punto de control es mayor o igual que la M que busco
                    %En este caso tomo los M primeros valores                
                    load(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\MM_OD\' 'MM_OD_M=' num2str(maximo) '_PC_' num2str(PC(1)) '_' num2str(PC(2)) '.mat'])

                    %Me quedo únicamente con los M primeros valores
                    F.MM_OD.eta=F.MM_OD.eta(1:M);
                    F.MM_OD.Hs= F.MM_OD.Hs(1:M);
                    F.MM_OD.WL=F.MM_OD.WL(1:M);
                    F.MM_OD.t_WL=F.MM_OD.t_WL(1:M,:);
                    save(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\MM_OD\' 'MM_OD_M=' num2str(M) '_PC_' num2str(PC(1)) '_' num2str(PC(2)) '.mat'],'F')    


                elseif maximo<M %El archivo en mi punto de control es menor que la M que busco.

                    %En este caso cargo el archivo, tomo los maximo
                    %primeros valores y el resto los calculo.
                    load(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\MM_OD\' 'MM_OD_M=' num2str(maximo) '_PC_' num2str(PC(1)) '_' num2str(PC(2)) '.mat'])

                    ini=maximo+1;
                    [F_nuevo]=EXTRACCION_VALOR_DE_F_MM_OD(Forzamiento,PC,M,pos,ini);

                    %Me cargo las posiciones no validas
                    F_nuevo.MM_OD.eta(1:maximo)=[];
                    F_nuevo.MM_OD.Hs(1:maximo)=[];
                    F_nuevo.MM_OD.WL(1:maximo)=[];
                    F_nuevo.MM_OD.t_WL(1:maximo,:)=[];

                    %Lo junto todo
                    F.MM_OD.eta=[F.MM_OD.eta F_nuevo.MM_OD.eta];
                    F.MM_OD.Hs=[F.MM_OD.Hs F_nuevo.MM_OD.Hs];
                    F.MM_OD.WL=[F.MM_OD.WL F_nuevo.MM_OD.WL];
                    F.MM_OD.t_WL=[F.MM_OD.t_WL; F_nuevo.MM_OD.t_WL];

                    save(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\MM_OD\' 'MM_OD_M=' num2str(M) '_PC_' num2str(PC(1)) '_' num2str(PC(2)) '.mat'],'F')
                end
            end
            end   
        end

    %% Caso 4 Todo junto
    elseif  comp_oleaje==0 && comp_m_meteo==1 && comp_oleaje_desembocadura==1 && comp_oleaje_desembocadura_sin_viento==0 && comp_m_astro==1 && comp_descarga_fluvial==1 

        %En primer lugar compruebo si ya existe el valor de F guardado para
        %ese forzamiento y punto de control
        if exist(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\MA_Q_MM_OD\' SC '\' OF '\' 'MA_Q_MM_OD_M=' num2str(M) '_PC_' num2str(PC(2,1)) '_' num2str(PC(2,2)) '.mat'])==2
            %Si existe lo cargo
            load(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\MA_Q_MM_OD\' SC '\' OF '\' 'MA_Q_MM_OD_M=' num2str(M) '_PC_' num2str(PC(2,1)) '_' num2str(PC(2,2)) '.mat'])

        else %Si no existe pasamos a la segunda fase en dónde intetaremos optimziar la extraccion de F 

                %1º Vemos si existe la carpeta           
                if ~exist(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\MA_Q_MM_OD\' SC '\' OF],'dir')
                    mkdir(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\MA_Q_MM_OD\' SC '\' OF])
                end

                %1º Vemos que archivos tengo en la carpeta
                s = what(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\MA_Q_MM_OD\' SC '\' OF]);           
                % Compruebo si no hay archivos, en cuyo caso calculo F
                files=s(1,1).mat;
                s=size(files);
                s=s(1);

                if s==0
                    ini=1;
                    [F]=EXTRACCION_VALOR_DE_F_MA_Q_MM_OD(Forzamiento,Forzamiento_3h,PC,M,pos,ini,SC,OF,var);
                    save(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\MA_Q_MM_OD\' SC '\' OF '\' 'MA_Q_MM_OD_M=' num2str(M) '_PC_' num2str(PC(2,1)) '_' num2str(PC(2,2)) '.mat'],'F')

                else

                s = what(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\MA_Q_MM_OD\' SC '\' OF]);           
                % Compruebo si no hay archivos, en cuyo caso calculo F            
                files=s(1,1).mat;
                s=size(files);
                s=s(1);

            %2º Hacemos una lista de los archivos de F en mi punto de
            %control

            %Almaceno el número de valores de la muestra de cada fichero
            for j=1:s
                Str=char(files(j)); 
                Key   = '_';            
                Index = strfind(Str, Key);
                pos_pc1(j) = sscanf(Str(Index(end-1) + length(Key):end), '%g', 1);
                pos_pc2(j) = sscanf(Str(Index(end) + length(Key):end), '%g', 1);
                Key_value = '=';
                Index = strfind(Str, Key_value);
                Value(j) = sscanf(Str(Index(1) + length(Key_value):end), '%g', 1);
            end

            % Busco las posiciones de mi punto de control
            val=find(pos_pc1==PC(1) & pos_pc2==PC(2));

            %Busco los valores de M en dichas posiciones
            Value=Value(val);

            % Busco el máximo y su posición
            [maximo val]=max(Value);           

            %Posibilidad 1º: No tengo archivos --> Calculo el valor de F
            if isempty(files) 
                ini=1;
                [F]=EXTRACCION_VALOR_DE_F_MA_Q_MM_OD(Forzamiento,Forzamiento_3h,PC,M,pos,ini,SC,OF,var);
                save(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\MA_Q_MM_OD\' SC '\' OF '\' 'MA_Q_MM_OD_M=' num2str(M) '_PC_' num2str(PC(2,1)) '_' num2str(PC(2,2)) '.mat'],'F')

            %Posibilidad 2ª: Hay archivos, pero ninguno es de mi punto de
            %control --> Calculo F
            elseif isempty(val)
                ini=1;
                [F]=EXTRACCION_VALOR_DE_F_MA_Q_MM_OD(Forzamiento,Forzamiento_3h,PC,M,pos,ini,SC,OF,var);
                save(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\MA_Q_MM_OD\' SC '\' OF '\' 'MA_Q_MM_OD_M=' num2str(M) '_PC_' num2str(PC(2,1)) '_' num2str(PC(2,2)) '.mat'],'F')

            %3ª Posibilidad Hay archivos en mi punto de control
            elseif isempty(val)==0

                %Tengo dos opciones: 
                if maximo>=M %Si el archivo en mi punto de control es mayor o igual que la M que busco
                    %En este caso tomo los M primeros valores                
                    load(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\MA_Q_MM_OD\' SC '\' OF '\' 'MA_Q_MM_OD_M=' num2str(maximo) '_PC_' num2str(PC(2,1)) '_' num2str(PC(2,2)) '.mat'])

                    %Me quedo únicamente con los M primeros valores
                    F.MA_Q_MM_OD.eta=F.MA_Q_MM_OD.eta(1:M);
                    F.MA_Q_MM_OD.Hs= F.MA_Q_MM_OD.Hs(1:M);
                    F.MA_Q_MM_OD.WL=F.MA_Q_MM_OD.WL(1:M);
                    F.MA_Q_MM_OD.t_WL=F.MA_Q_MM_OD.t_WL(1:M,:);
                    save(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\MA_Q_MM_OD\' SC '\' OF '\' 'MA_Q_MM_OD_M=' num2str(M) '_PC_' num2str(PC(2,1)) '_' num2str(PC(2,2)) '.mat'],'F')    


                elseif maximo<M %El archivo en mi punto de control es menor que la M que busco.

                    %En este caso cargo el archivo, tomo los maximo
                    %primeros valores y el resto los calculo.
                    load(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\MA_Q_MM_OD\' SC '\' OF '\' 'MA_Q_MM_OD_M=' num2str(maximo) '_PC_' num2str(PC(2,1)) '_' num2str(PC(2,2)) '.mat'])

                    ini=maximo+1;
                    [F]=EXTRACCION_VALOR_DE_F_MA_Q_MM_OD(Forzamiento,Forzamiento_3h,PC,M,pos,ini,SC,OF,var);

                    %Me cargo las posiciones no validas
                    F_nuevo.MA_Q_MM_OD.eta(1:maximo)=[];
                    F_nuevo.MA_Q_MM_OD.Hs(1:maximo)=[];
                    F_nuevo.MA_Q_MM_OD.WL(1:maximo)=[];
                    F_nuevo.MA_Q_MM_OD.t_WL(1:maximo,:)=[];

                    %Lo junto todo
                    F.MA_Q_MM_OD.eta=[F.MA_Q_MM_OD.eta F_nuevo.MA_Q_MM_OD.eta];
                    F.MA_Q_MM_OD.Hs=[F.MA_Q_MM_OD.Hs F_nuevo.MA_Q_MM_OD.Hs];
                    F.MA_Q_MM_OD.WL=[F.MA_Q_MM_OD.WL F_nuevo.MA_Q_MM_OD.WL];
                    F.MA_Q_MM_OD.t_WL=[F.MA_Q_MM_OD.t_WL; F_nuevo.MA_Q_MM_OD.t_WL];

                    save(['DATOS\VALORES DE F\ELEVACIONES_GAUDALETE\MA_Q_MM_OD\' SC '\' OF '\' 'MA_Q_MM_OD_M=' num2str(M) '_PC_' num2str(PC(2,1)) '_' num2str(PC(2,2)) '.mat'],'F')
                end
            end
            end   
        end


    %% CASO 5: PROPAGACIÓN DEL RÉGIMEN MEDIO: SÓLO OLEAJE SIN VIENTO    
    elseif comp_oleaje==1 && comp_m_meteo==0 && comp_oleaje_desembocadura==0 && comp_oleaje_desembocadura_sin_viento==0 % CASO 5: PROPAGACIÓN DEL RÉGIMEN MEDIO: SÓLO OLEAJE SIN VIENTO

        %En primer lugar compruebo si ya existe el valor de F guardado para
        %ese forzamiento y punto de control
        if exist(['DATOS\VALORES DE F\PROPAGACION_REGIMEN_MEDIO\O_\O_M=' num2str(M) '_PC=' num2str(PC) '.mat'])==2
            %Si existe lo cargo
            load(['DATOS\VALORES DE F\PROPAGACION_REGIMEN_MEDIO\O_\O_M=' num2str(M) '_PC=' num2str(PC) '.mat'])

        else %Si no existe pasamos a la segunda fase en dónde intetaremos optimziar la extraccion de F 

                %1º Vemos si existe la carpeta           
                if ~exist(['DATOS\VALORES DE F\PROPAGACION_REGIMEN_MEDIO\O_'],'dir')
                    mkdir(['DATOS\VALORES DE F\PROPAGACION_REGIMEN_MEDIO\O_'])
                end

                %1º Vemos que archivos tengo en la carpeta
                s = what(['DATOS\VALORES DE F\PROPAGACION_REGIMEN_MEDIO\O_']);           
                % Compruebo si no hay archivos, en cuyo caso calculo F
                files=s(1,1).mat;
                s=size(files);
                s=s(1);

                if s==0
                    ini=1;
                    [F]=EXTRACCION_VALOR_F_PROPAGACION_OLEAJE(PC,M,ini,Forzamiento,pos);
                    save(['DATOS\VALORES DE F\PROPAGACION_REGIMEN_MEDIO\O_\O_M=' num2str(M) '_PC=' num2str(PC) '.mat'],'F')

                else

                s = what(['DATOS\VALORES DE F\PROPAGACION_REGIMEN_MEDIO\O_']);           
                % Compruebo si no hay archivos, en cuyo caso calculo F            
                files=s(1,1).mat;
                s=size(files);
                s=s(1);

            %2º Hacemos una lista de los archivos de F en mi punto de
            %control

            %Almaceno el número de valores de la muestra de cada fichero
            for j=1:s
                Str=char(files(j)); 
                Key   = '=';            
                Index = strfind(Str, Key);
                pos_pc(j) = sscanf(Str(Index(end) + length(Key):end), '%g', 1);
                Key_value = '_';
                Index = strfind(Str, Key_value);
                Value(j) = sscanf(Str(Index(1)+2 + length(Key_value):end), '%g', 1);
            end

            % Busco las posiciones de mi punto de control
            val=find(pos_pc==PC);

            %Busco los valores de M en dichas posiciones
            Value=Value(val);

            % Busco el máximo y su posición
            [maximo val]=max(Value);

            %Posibilidad 1º: No tengo archivos --> Calculo el valor de F
            if isempty(files) 
                ini=1;
                [F]=EXTRACCION_VALOR_F_PROPAGACION_OLEAJE(PC,M,ini,Forzamiento,pos);
                save(['DATOS\VALORES DE F\PROPAGACION_REGIMEN_MEDIO\O_\O_M=' num2str(M) '_PC=' num2str(PC) '.mat'],'F')

            %Posibilidad 2ª: Hay archivos, pero ninguno es de mi punto de
            %control --> Calculo F
            elseif isempty(val)
                ini=1;
                [F]=EXTRACCION_VALOR_F_PROPAGACION_OLEAJE(PC,M,ini,Forzamiento,pos);
                save(['DATOS\VALORES DE F\PROPAGACION_REGIMEN_MEDIO\O_\O_M=' num2str(M) '_PC=' num2str(PC) '.mat'],'F')

            %3ª Posibilidad Hay archivos en mi punto de control
            elseif isempty(val)==0

                %Tengo dos opciones: 
                if maximo>=M %Si el archivo en mi punto de control es mayor o igual que la M que busco
                    %En este caso tomo los M primeros valores                
                    load(['DATOS\VALORES DE F\PROPAGACION_REGIMEN_MEDIO\O_\O_M=' num2str(maximo) '_PC=' num2str(PC) '.mat'])

                    %Me quedo únicamente con los M primeros valores
                    F.Oleaje.Hs=F.Oleaje.Hs(1:M);
                    F.Oleaje.Tp=F.Oleaje.Tp(1:M);
                    F.Oleaje.d_o=F.Oleaje.d_o(1:M);                

                    save(['DATOS\VALORES DE F\PROPAGACION_REGIMEN_MEDIO\O_\O_M=' num2str(M) '_PC=' num2str(PC) '.mat'],'F')


                elseif maximo<M %El archivo en mi punto de control es menor que la M que busco.

                    %En este caso cargo el archivo, tomo los maximo
                    %primeros valores y el resto los calculo.
                    load(['DATOS\VALORES DE F\PROPAGACION_REGIMEN_MEDIO\O_\O_M=' num2str(maximo) '_PC=' num2str(PC) '.mat'])

                    ini=maximo+1;
                    [F_nuevo]=EXTRACCION_VALOR_F_PROPAGACION_OLEAJE(PC,M,ini,Forzamiento,pos);

                    %Me cargo las posiciones no validas
                    F_nuevo.Oleaje.Hs(1:maximo)=[];
                    F_nuevo.Oleaje.Tp(1:maximo)=[];
                    F_nuevo.Oleaje.d_o(1:maximo)=[];

                    %Lo junto todo
                    F.Oleaje.Hs=[F.Oleaje.Hs F_nuevo.Oleaje.Hs];
                    F.Oleaje.Tp=[F.Oleaje.Tp F_nuevo.Oleaje.Tp];
                    F.Oleaje.d_o=[F.Oleaje.d_o F_nuevo.Oleaje.d_o];

                    save(['DATOS\VALORES DE F\PROPAGACION_REGIMEN_MEDIO\O_\O_M=' num2str(M) '_PC=' num2str(PC) '.mat'],'F')
                end
            end
            end
        end
    %% CASO 6: PROPAGACIÓN DEL RÉGIMEN MEDIO: OLEAJE CON VIENTO 
    elseif comp_oleaje==1 && comp_m_meteo==1 && comp_oleaje_desembocadura==0 && comp_oleaje_desembocadura_sin_viento==0 % CASO 6: PROPAGACIÓN DEL RÉGIMEN MEDIO: OLEAJE CON VIENTO

        %En primer lugar compruebo si ya existe el valor de F guardado para
        %ese forzamiento y punto de control
        if exist(['DATOS\VALORES DE F\PROPAGACION_REGIMEN_MEDIO\O_MM_\O_MM_M=' num2str(M) '_PC=' num2str(PC) '.mat'])==2
            %Si existe lo cargo
            load(['DATOS\VALORES DE F\PROPAGACION_REGIMEN_MEDIO\O_MM_\O_MM_M=' num2str(M) '_PC=' num2str(PC) '.mat'])

        else %Si no existe pasamos a la segunda fase en dónde intetaremos optimziar la extraccion de F 

                %1º Vemos si existe la carpeta           
                if ~exist(['DATOS\VALORES DE F\PROPAGACION_REGIMEN_MEDIO\O_MM_'],'dir')
                    mkdir(['DATOS\VALORES DE F\PROPAGACION_REGIMEN_MEDIO\O_MM_'])
                end

                %1º Vemos que archivos tengo en la carpeta
                s = what(['DATOS\VALORES DE F\PROPAGACION_REGIMEN_MEDIO\O_MM_']);           
                % Compruebo si no hay archivos, en cuyo caso calculo F
                files=s(1,1).mat;
                s=size(files);
                s=s(1);

                if s==0
                    ini=1;
                    [F]=EXTRACCION_VALOR_F_PROPAGACION_OLEAJE_CON_VIENTO(PC,M,ini,Forzamiento,pos);
                    save(['DATOS\VALORES DE F\PROPAGACION_REGIMEN_MEDIO\O_MM_\O_MM_M=' num2str(M) '_PC=' num2str(PC) '.mat'],'F')

                else

                s = what(['DATOS\VALORES DE F\PROPAGACION_REGIMEN_MEDIO\O_MM_']);           
                % Compruebo si no hay archivos, en cuyo caso calculo F            
                files=s(1,1).mat;
                s=size(files);
                s=s(1);

            %2º Hacemos una lista de los archivos de F en mi punto de
            %control

            %Almaceno el número de valores de la muestra de cada fichero
            for j=1:s
                Str=char(files(j)); 
                Key   = '=';            
                Index = strfind(Str, Key);
                pos_pc(j) = sscanf(Str(Index(end) + length(Key):end), '%g', 1);
                Key_value = '_';
                Index = strfind(Str, Key_value);
                Value(j) = sscanf(Str(Index(2)+2 + length(Key_value):end), '%g', 1);
            end

            % Busco las posiciones de mi punto de control
            val=find(pos_pc==PC);

            %Busco los valores de M en dichas posiciones
            Value=Value(val);

            % Busco el máximo y su posición
            [maximo val]=max(Value);

            %Posibilidad 1º: No tengo archivos --> Calculo el valor de F
            if isempty(files) 
                ini=1;
                [F]=EXTRACCION_VALOR_F_PROPAGACION_OLEAJE_CON_VIENTO(PC,M,ini,Forzamiento,pos);
                save(['DATOS\VALORES DE F\PROPAGACION_REGIMEN_MEDIO\O_MM_\O_MM_M=' num2str(M) '_PC=' num2str(PC) '.mat'],'F')
            %Posibilidad 2ª: Hay archivos, pero ninguno es de mi punto de
            %control --> Calculo F
            elseif isempty(val)
                ini=1;
                [F]=EXTRACCION_VALOR_F_PROPAGACION_OLEAJE_CON_VIENTO(PC,M,ini,Forzamiento,pos);
                save(['DATOS\VALORES DE F\PROPAGACION_REGIMEN_MEDIO\O_MM_\O_MM_M=' num2str(M) '_PC=' num2str(PC) '.mat'],'F')

            %3ª Posibilidad Hay archivos en mi punto de control
            elseif isempty(val)==0

                %Tengo dos opciones: 
                if maximo>=M %Si el archivo en mi punto de control es mayor o igual que la M que busco
                    %En este caso tomo los M primeros valores                
                    load(['DATOS\VALORES DE F\PROPAGACION_REGIMEN_MEDIO\O_MM_\O_MM_M=' num2str(maximo) '_PC=' num2str(PC) '.mat'])

                    %Me quedo únicamente con los M primeros valores
                    F.Oleaje.Hs=F.Oleaje.Hs(1:M);
                    F.Oleaje.Tp=F.Oleaje.Tp(1:M);
                    F.Oleaje.d_o=F.Oleaje.d_o(1:M);                

                    save(['DATOS\VALORES DE F\PROPAGACION_REGIMEN_MEDIO\O_MM_\O_MM_M=' num2str(M) '_PC=' num2str(PC) '.mat'],'F')


                elseif maximo<M %El archivo en mi punto de control es menor que la M que busco.

                    %En este caso cargo el archivo, tomo los maximo
                    %primeros valores y el resto los calculo.
                    load(['DATOS\VALORES DE F\PROPAGACION_REGIMEN_MEDIO\O_MM_\O_MM_M=' num2str(maximo) '_PC=' num2str(PC) '.mat'])

                    ini=maximo+1;
                    [F_nuevo]=EXTRACCION_VALOR_F_PROPAGACION_OLEAJE_CON_VIENTO(PC,M,ini,Forzamiento,pos);

                    %Me cargo las posiciones no validas
                    F_nuevo.Oleaje.Hs(1:maximo)=[];
                    F_nuevo.Oleaje.Tp(1:maximo)=[];
                    F_nuevo.Oleaje.d_o(1:maximo)=[];

                    %Lo junto todo
                    F.Oleaje.Hs=[F.Oleaje.Hs F_nuevo.Oleaje.Hs];
                    F.Oleaje.Tp=[F.Oleaje.Tp F_nuevo.Oleaje.Tp];
                    F.Oleaje.d_o=[F.Oleaje.d_o F_nuevo.Oleaje.d_o];

                    save(['DATOS\VALORES DE F\PROPAGACION_REGIMEN_MEDIO\O_MM_\O_MM_M=' num2str(M) '_PC=' num2str(PC) '.mat'],'F')
                end
            end
            end
        end  



    end
    
elseif strcmp(var, 'v_x')
    %En primer lugar compruebo si ya existe el valor de F guardado para
    %ese forzamiento y punto de control
    if exist(['DATOS\VALORES DE F\CORRIENTE_X_GAUDALETE\MA_Q_MM_OD\' SC '\' OF '\' 'MA_Q_MM_OD_M=' num2str(M) '_PC_' num2str(PC(2,1)) '_' num2str(PC(2,2)) '.mat'])==2
        %Si existe lo cargo
        load(['DATOS\VALORES DE F\CORRIENTE_X_GAUDALETE\MA_Q_MM_OD\' SC '\' OF '\' 'MA_Q_MM_OD_M=' num2str(M) '_PC_' num2str(PC(2,1)) '_' num2str(PC(2,2)) '.mat'])

    else %Si no existe pasamos a la segunda fase en dónde intetaremos optimziar la extraccion de F 

            %1º Vemos si existe la carpeta           
            if ~exist(['DATOS\VALORES DE F\CORRIENTE_X_GAUDALETE\MA_Q_MM_OD\' SC '\' OF],'dir')
                mkdir(['DATOS\VALORES DE F\CORRIENTE_X_GAUDALETE\MA_Q_MM_OD\' SC '\' OF])
            end

            %1º Vemos que archivos tengo en la carpeta
            s = what(['DATOS\VALORES DE F\CORRIENTE_X_GAUDALETE\MA_Q_MM_OD\' SC '\' OF]);           
            % Compruebo si no hay archivos, en cuyo caso calculo F
            files=s(1,1).mat;
            s=size(files);
            s=s(1);

            if s==0
                ini=1;
                [F]=EXTRACCION_VALOR_DE_F_MA_Q_MM_OD(Forzamiento,Forzamiento_3h,PC,M,pos,ini,SC,OF,var);
                save(['DATOS\VALORES DE F\CORRIENTE_X_GAUDALETE\MA_Q_MM_OD\' SC '\' OF '\' 'MA_Q_MM_OD_M=' num2str(M) '_PC_' num2str(PC(2,1)) '_' num2str(PC(2,2)) '.mat'],'F')

            else

            s = what(['DATOS\VALORES DE F\CORRIENTE_X_GAUDALETE\MA_Q_MM_OD\' SC '\' OF]);           
            % Compruebo si no hay archivos, en cuyo caso calculo F            
            files=s(1,1).mat;
            s=size(files);
            s=s(1);

        %2º Hacemos una lista de los archivos de F en mi punto de
        %control

        %Almaceno el número de valores de la muestra de cada fichero
        for j=1:s
            Str=char(files(j)); 
            Key   = '_';            
            Index = strfind(Str, Key);
            pos_pc1(j) = sscanf(Str(Index(end-1) + length(Key):end), '%g', 1);
            pos_pc2(j) = sscanf(Str(Index(end) + length(Key):end), '%g', 1);
            Key_value = '=';
            Index = strfind(Str, Key_value);
            Value(j) = sscanf(Str(Index(1) + length(Key_value):end), '%g', 1);
        end

        % Busco las posiciones de mi punto de control
        val=find(pos_pc1==PC(1) & pos_pc2==PC(2));

        %Busco los valores de M en dichas posiciones
        Value=Value(val);

        % Busco el máximo y su posición
        [maximo val]=max(Value);           

        %Posibilidad 1º: No tengo archivos --> Calculo el valor de F
        if isempty(files) 
            ini=1;
            [F]=EXTRACCION_VALOR_DE_F_MA_Q_MM_OD(Forzamiento,Forzamiento_3h,PC,M,pos,ini,SC,OF,var);
            save(['DATOS\VALORES DE F\CORRIENTE_X_GAUDALETE\MA_Q_MM_OD\' SC '\' OF '\' 'MA_Q_MM_OD_M=' num2str(M) '_PC_' num2str(PC(2,1)) '_' num2str(PC(2,2)) '.mat'],'F')

        %Posibilidad 2ª: Hay archivos, pero ninguno es de mi punto de
        %control --> Calculo F
        elseif isempty(val)
            ini=1;
            [F]=EXTRACCION_VALOR_DE_F_MA_Q_MM_OD(Forzamiento,Forzamiento_3h,PC,M,pos,ini,SC,OF,var);
            save(['DATOS\VALORES DE F\CORRIENTE_X_GAUDALETE\MA_Q_MM_OD\' SC '\' OF '\' 'MA_Q_MM_OD_M=' num2str(M) '_PC_' num2str(PC(2,1)) '_' num2str(PC(2,2)) '.mat'],'F')

        %3ª Posibilidad Hay archivos en mi punto de control
        elseif isempty(val)==0

            %Tengo dos opciones: 
            if maximo>=M %Si el archivo en mi punto de control es mayor o igual que la M que busco
                %En este caso tomo los M primeros valores                
                load(['DATOS\VALORES DE F\CORRIENTE_X_GAUDALETE\MA_Q_MM_OD\' SC '\' OF '\' 'MA_Q_MM_OD_M=' num2str(maximo) '_PC_' num2str(PC(2,1)) '_' num2str(PC(2,2)) '.mat'])

                %Me quedo únicamente con los M primeros valores
                F.MA_Q_MM_OD.v_x=F.MA_Q_MM_OD.v_x(1:M);

                save(['DATOS\VALORES DE F\CORRIENTE_X_GAUDALETE\MA_Q_MM_OD\' SC '\' OF '\' 'MA_Q_MM_OD_M=' num2str(M) '_PC_' num2str(PC(2,1)) '_' num2str(PC(2,2)) '.mat'],'F')    


            elseif maximo<M %El archivo en mi punto de control es menor que la M que busco.

                %En este caso cargo el archivo, tomo los maximo
                %primeros valores y el resto los calculo.
                load(['DATOS\VALORES DE F\CORRIENTE_X_GAUDALETE\MA_Q_MM_OD\' SC '\' OF '\' 'MA_Q_MM_OD_M=' num2str(maximo) '_PC_' num2str(PC(2,1)) '_' num2str(PC(2,2)) '.mat'])

                ini=maximo+1;
                [F]=EXTRACCION_VALOR_DE_F_MA_Q_MM_OD(Forzamiento,Forzamiento_3h,PC,M,pos,ini,SC,OF,var);

                %Me cargo las posiciones no validas
                F_nuevo.MA_Q_MM_OD.v_x(1:maximo)=[];

                %Lo junto todo
                F.MA_Q_MM_OD.v_x=[F.MA_Q_MM_OD.v_x F_nuevo.MA_Q_MM_OD.v_x];

                save(['DATOS\VALORES DE F\CORRIENTE_X_GAUDALETE\MA_Q_MM_OD\' SC '\' OF '\' 'MA_Q_MM_OD_M=' num2str(M) '_PC_' num2str(PC(2,1)) '_' num2str(PC(2,2)) '.mat'],'F')
            end
        end
        end   
    end
    
    
elseif strcmp(var, 'v_y')
    %En primer lugar compruebo si ya existe el valor de F guardado para
    %ese forzamiento y punto de control
    if exist(['DATOS\VALORES DE F\CORRIENTE_Y_GAUDALETE\MA_Q_MM_OD\' SC '\' OF '\' 'MA_Q_MM_OD_M=' num2str(M) '_PC_' num2str(PC(2,1)) '_' num2str(PC(2,2)) '.mat'])==2
        %Si existe lo cargo
        load(['DATOS\VALORES DE F\CORRIENTE_Y_GAUDALETE\MA_Q_MM_OD\' SC '\' OF '\' 'MA_Q_MM_OD_M=' num2str(M) '_PC_' num2str(PC(2,1)) '_' num2str(PC(2,2)) '.mat'])

    else %Si no existe pasamos a la segunda fase en dónde intetaremos optimziar la extraccion de F 

            %1º Vemos si existe la carpeta           
            if ~exist(['DATOS\VALORES DE F\CORRIENTE_Y_GAUDALETE\MA_Q_MM_OD\' SC '\' OF],'dir')
                mkdir(['DATOS\VALORES DE F\CORRIENTE_Y_GAUDALETE\MA_Q_MM_OD\' SC '\' OF])
            end

            %1º Vemos que archivos tengo en la carpeta
            s = what(['DATOS\VALORES DE F\CORRIENTE_Y_GAUDALETE\MA_Q_MM_OD\' SC '\' OF]);           
            % Compruebo si no hay archivos, en cuyo caso calculo F
            files=s(1,1).mat;
            s=size(files);
            s=s(1);

            if s==0
                ini=1;
                [F]=EXTRACCION_VALOR_DE_F_MA_Q_MM_OD(Forzamiento,Forzamiento_3h,PC,M,pos,ini,SC,OF,var);
                save(['DATOS\VALORES DE F\CORRIENTE_Y_GAUDALETE\MA_Q_MM_OD\' SC '\' OF '\' 'MA_Q_MM_OD_M=' num2str(M) '_PC_' num2str(PC(2,1)) '_' num2str(PC(2,2)) '.mat'],'F')

            else

            s = what(['DATOS\VALORES DE F\CORRIENTE_Y_GAUDALETE\MA_Q_MM_OD\' SC '\' OF]);           
            % Compruebo si no hay archivos, en cuyo caso calculo F            
            files=s(1,1).mat;
            s=size(files);
            s=s(1);

        %2º Hacemos una lista de los archivos de F en mi punto de
        %control

        %Almaceno el número de valores de la muestra de cada fichero
        for j=1:s
            Str=char(files(j)); 
            Key   = '_';            
            Index = strfind(Str, Key);
            pos_pc1(j) = sscanf(Str(Index(end-1) + length(Key):end), '%g', 1);
            pos_pc2(j) = sscanf(Str(Index(end) + length(Key):end), '%g', 1);
            Key_value = '=';
            Index = strfind(Str, Key_value);
            Value(j) = sscanf(Str(Index(1) + length(Key_value):end), '%g', 1);
        end

        % Busco las posiciones de mi punto de control
        val=find(pos_pc1==PC(1) & pos_pc2==PC(2));

        %Busco los valores de M en dichas posiciones
        Value=Value(val);

        % Busco el máximo y su posición
        [maximo val]=max(Value);           

        %Posibilidad 1º: No tengo archivos --> Calculo el valor de F
        if isempty(files) 
            ini=1;
            [F]=EXTRACCION_VALOR_DE_F_MA_Q_MM_OD(Forzamiento,Forzamiento_3h,PC,M,pos,ini,SC,OF,var);
            save(['DATOS\VALORES DE F\CORRIENTE_Y_GAUDALETE\MA_Q_MM_OD\' SC '\' OF '\' 'MA_Q_MM_OD_M=' num2str(M) '_PC_' num2str(PC(2,1)) '_' num2str(PC(2,2)) '.mat'],'F')

        %Posibilidad 2ª: Hay archivos, pero ninguno es de mi punto de
        %control --> Calculo F
        elseif isempty(val)
            ini=1;
            [F]=EXTRACCION_VALOR_DE_F_MA_Q_MM_OD(Forzamiento,Forzamiento_3h,PC,M,pos,ini,SC,OF,var);
            save(['DATOS\VALORES DE F\CORRIENTE_Y_GAUDALETE\MA_Q_MM_OD\' SC '\' OF '\' 'MA_Q_MM_OD_M=' num2str(M) '_PC_' num2str(PC(2,1)) '_' num2str(PC(2,2)) '.mat'],'F')

        %3ª Posibilidad Hay archivos en mi punto de control
        elseif isempty(val)==0

            %Tengo dos opciones: 
            if maximo>=M %Si el archivo en mi punto de control es mayor o igual que la M que busco
                %En este caso tomo los M primeros valores                
                load(['DATOS\VALORES DE F\CORRIENTE_Y_GAUDALETE\MA_Q_MM_OD\' SC '\' OF '\' 'MA_Q_MM_OD_M=' num2str(maximo) '_PC_' num2str(PC(2,1)) '_' num2str(PC(2,2)) '.mat'])

                %Me quedo únicamente con los M primeros valores
                F.MA_Q_MM_OD.v_y=F.MA_Q_MM_OD.v_y(1:M);

                save(['DATOS\VALORES DE F\CORRIENTE_Y_GAUDALETE\MA_Q_MM_OD\' SC '\' OF '\' 'MA_Q_MM_OD_M=' num2str(M) '_PC_' num2str(PC(2,1)) '_' num2str(PC(2,2)) '.mat'],'F')    


            elseif maximo<M %El archivo en mi punto de control es menor que la M que busco.

                %En este caso cargo el archivo, tomo los maximo
                %primeros valores y el resto los calculo.
                load(['DATOS\VALORES DE F\CORRIENTE_Y_GAUDALETE\MA_Q_MM_OD\' SC '\' OF '\' 'MA_Q_MM_OD_M=' num2str(maximo) '_PC_' num2str(PC(2,1)) '_' num2str(PC(2,2)) '.mat'])

                ini=maximo+1;
                [F]=EXTRACCION_VALOR_DE_F_MA_Q_MM_OD(Forzamiento,Forzamiento_3h,PC,M,pos,ini,SC,OF,var);

                %Me cargo las posiciones no validas
                F_nuevo.MA_Q_MM_OD.v_y(1:maximo)=[];

                %Lo junto todo
                F.MA_Q_MM_OD.v_y=[F.MA_Q_MM_OD.v_y F_nuevo.MA_Q_MM_OD.v_y];

                save(['DATOS\VALORES DE F\CORRIENTE_Y_GAUDALETE\MA_Q_MM_OD\' SC '\' OF '\' 'MA_Q_MM_OD_M=' num2str(M) '_PC_' num2str(PC(2,1)) '_' num2str(PC(2,2)) '.mat'],'F')
            end
        end
        end   
    end
    
elseif strcmp(var, 'hs')
    %En primer lugar compruebo si ya existe el valor de F guardado para
    %ese forzamiento y punto de control
    if exist(['DATOS\VALORES DE F\HS\MA_Q_MM_OD\' SC '\' OF '\' 'MA_Q_MM_OD_M=' num2str(M) '_PC_' num2str(PC(2,1)) '_' num2str(PC(2,2)) '.mat'])==2
        %Si existe lo cargo
        load(['DATOS\VALORES DE F\HS\MA_Q_MM_OD\' SC '\' OF '\' 'MA_Q_MM_OD_M=' num2str(M) '_PC_' num2str(PC(2,1)) '_' num2str(PC(2,2)) '.mat'])

    else %Si no existe pasamos a la segunda fase en dónde intetaremos optimziar la extraccion de F 

            %1º Vemos si existe la carpeta           
            if ~exist(['DATOS\VALORES DE F\HS\MA_Q_MM_OD\' SC '\' OF],'dir')
                mkdir(['DATOS\VALORES DE F\HS\MA_Q_MM_OD\' SC '\' OF])
            end

            %1º Vemos que archivos tengo en la carpeta
            s = what(['DATOS\VALORES DE F\HS\MA_Q_MM_OD\' SC '\' OF]);           
            % Compruebo si no hay archivos, en cuyo caso calculo F
            files=s(1,1).mat;
            s=size(files);
            s=s(1);

            if s==0
                ini=1;
                [F]=EXTRACCION_VALOR_DE_F_MA_Q_MM_OD(Forzamiento,Forzamiento_3h,PC,M,pos,ini,SC,OF,var);
                save(['DATOS\VALORES DE F\HS\MA_Q_MM_OD\' SC '\' OF '\' 'MA_Q_MM_OD_M=' num2str(M) '_PC_' num2str(PC(2,1)) '_' num2str(PC(2,2)) '.mat'],'F')

            else

            s = what(['DATOS\VALORES DE F\HS\MA_Q_MM_OD\' SC '\' OF]);           
            % Compruebo si no hay archivos, en cuyo caso calculo F            
            files=s(1,1).mat;
            s=size(files);
            s=s(1);

        %2º Hacemos una lista de los archivos de F en mi punto de
        %control

        %Almaceno el número de valores de la muestra de cada fichero
        for j=1:s
            Str=char(files(j)); 
            Key   = '_';            
            Index = strfind(Str, Key);
            pos_pc1(j) = sscanf(Str(Index(end-1) + length(Key):end), '%g', 1);
            pos_pc2(j) = sscanf(Str(Index(end) + length(Key):end), '%g', 1);
            Key_value = '=';
            Index = strfind(Str, Key_value);
            Value(j) = sscanf(Str(Index(1) + length(Key_value):end), '%g', 1);
        end

        % Busco las posiciones de mi punto de control
        val=find(pos_pc1==PC(1) & pos_pc2==PC(2));

        %Busco los valores de M en dichas posiciones
        Value=Value(val);

        % Busco el máximo y su posición
        [maximo val]=max(Value);           

        %Posibilidad 1º: No tengo archivos --> Calculo el valor de F
        if isempty(files) 
            ini=1;
            [F]=EXTRACCION_VALOR_DE_F_MA_Q_MM_OD(Forzamiento,Forzamiento_3h,PC,M,pos,ini,SC,OF,var);
            save(['DATOS\VALORES DE F\HS\MA_Q_MM_OD\' SC '\' OF '\' 'MA_Q_MM_OD_M=' num2str(M) '_PC_' num2str(PC(2,1)) '_' num2str(PC(2,2)) '.mat'],'F')

        %Posibilidad 2ª: Hay archivos, pero ninguno es de mi punto de
        %control --> Calculo F
        elseif isempty(val)
            ini=1;
            [F]=EXTRACCION_VALOR_DE_F_MA_Q_MM_OD(Forzamiento,Forzamiento_3h,PC,M,pos,ini,SC,OF,var);
            save(['DATOS\VALORES DE F\HS\MA_Q_MM_OD\' SC '\' OF '\' 'MA_Q_MM_OD_M=' num2str(M) '_PC_' num2str(PC(2,1)) '_' num2str(PC(2,2)) '.mat'],'F')

        %3ª Posibilidad Hay archivos en mi punto de control
        elseif isempty(val)==0

            %Tengo dos opciones: 
            if maximo>=M %Si el archivo en mi punto de control es mayor o igual que la M que busco
                %En este caso tomo los M primeros valores                
                load(['DATOS\VALORES DE F\HS\MA_Q_MM_OD\' SC '\' OF '\' 'MA_Q_MM_OD_M=' num2str(maximo) '_PC_' num2str(PC(2,1)) '_' num2str(PC(2,2)) '.mat'])

                %Me quedo únicamente con los M primeros valores
                F.MA_Q_MM_OD.hs=F.MA_Q_MM_OD.hs(1:M);

                save(['DATOS\VALORES DE F\HS\MA_Q_MM_OD\' SC '\' OF '\' 'MA_Q_MM_OD_M=' num2str(M) '_PC_' num2str(PC(2,1)) '_' num2str(PC(2,2)) '.mat'],'F')    


            elseif maximo<M %El archivo en mi punto de control es menor que la M que busco.

                %En este caso cargo el archivo, tomo los maximo
                %primeros valores y el resto los calculo.
                load(['DATOS\VALORES DE F\HS\MA_Q_MM_OD\' SC '\' OF '\' 'MA_Q_MM_OD_M=' num2str(maximo) '_PC_' num2str(PC(2,1)) '_' num2str(PC(2,2)) '.mat'])

                ini=maximo+1;
                [F]=EXTRACCION_VALOR_DE_F_MA_Q_MM_OD(Forzamiento,Forzamiento_3h,PC,M,pos,ini,SC,OF,var);

                %Me cargo las posiciones no validas
                F_nuevo.MA_Q_MM_OD.hs(1:maximo)=[];

                %Lo junto todo
                F.MA_Q_MM_OD.hs=[F.MA_Q_MM_OD.hs F_nuevo.MA_Q_MM_OD.hs];

                save(['DATOS\VALORES DE F\HS\MA_Q_MM_OD\' SC '\' OF '\' 'MA_Q_MM_OD_M=' num2str(M) '_PC_' num2str(PC(2,1)) '_' num2str(PC(2,2)) '.mat'],'F')
            end
        end
        end   
    end
    
elseif strcmp(var, 'tp')
    %En primer lugar compruebo si ya existe el valor de F guardado para
    %ese forzamiento y punto de control
    if exist(['DATOS\VALORES DE F\TP\MA_Q_MM_OD\' SC '\' OF '\' 'MA_Q_MM_OD_M=' num2str(M) '_PC_' num2str(PC(2,1)) '_' num2str(PC(2,2)) '.mat'])==2
        %Si existe lo cargo
        load(['DATOS\VALORES DE F\TP\MA_Q_MM_OD\' SC '\' OF '\' 'MA_Q_MM_OD_M=' num2str(M) '_PC_' num2str(PC(2,1)) '_' num2str(PC(2,2)) '.mat'])

    else %Si no existe pasamos a la segunda fase en dónde intetaremos optimziar la extraccion de F 

            %1º Vemos si existe la carpeta           
            if ~exist(['DATOS\VALORES DE F\TP\MA_Q_MM_OD\' SC '\' OF],'dir')
                mkdir(['DATOS\VALORES DE F\TP\MA_Q_MM_OD\' SC '\' OF])
            end

            %1º Vemos que archivos tengo en la carpeta
            s = what(['DATOS\VALORES DE F\TP\MA_Q_MM_OD\' SC '\' OF]);           
            % Compruebo si no hay archivos, en cuyo caso calculo F
            files=s(1,1).mat;
            s=size(files);
            s=s(1);

            if s==0
                ini=1;
                [F]=EXTRACCION_VALOR_DE_F_MA_Q_MM_OD(Forzamiento,Forzamiento_3h,PC,M,pos,ini,SC,OF,var);
                save(['DATOS\VALORES DE F\TP\MA_Q_MM_OD\' SC '\' OF '\' 'MA_Q_MM_OD_M=' num2str(M) '_PC_' num2str(PC(2,1)) '_' num2str(PC(2,2)) '.mat'],'F')

            else

            s = what(['DATOS\VALORES DE F\TP\MA_Q_MM_OD\' SC '\' OF]);           
            % Compruebo si no hay archivos, en cuyo caso calculo F            
            files=s(1,1).mat;
            s=size(files);
            s=s(1);

        %2º Hacemos una lista de los archivos de F en mi punto de
        %control

        %Almaceno el número de valores de la muestra de cada fichero
        for j=1:s
            Str=char(files(j)); 
            Key   = '_';            
            Index = strfind(Str, Key);
            pos_pc1(j) = sscanf(Str(Index(end-1) + length(Key):end), '%g', 1);
            pos_pc2(j) = sscanf(Str(Index(end) + length(Key):end), '%g', 1);
            Key_value = '=';
            Index = strfind(Str, Key_value);
            Value(j) = sscanf(Str(Index(1) + length(Key_value):end), '%g', 1);
        end

        % Busco las posiciones de mi punto de control
        val=find(pos_pc1==PC(1) & pos_pc2==PC(2));

        %Busco los valores de M en dichas posiciones
        Value=Value(val);

        % Busco el máximo y su posición
        [maximo val]=max(Value);           

        %Posibilidad 1º: No tengo archivos --> Calculo el valor de F
        if isempty(files) 
            ini=1;
            [F]=EXTRACCION_VALOR_DE_F_MA_Q_MM_OD(Forzamiento,Forzamiento_3h,PC,M,pos,ini,SC,OF,var);
            save(['DATOS\VALORES DE F\TP\MA_Q_MM_OD\' SC '\' OF '\' 'MA_Q_MM_OD_M=' num2str(M) '_PC_' num2str(PC(2,1)) '_' num2str(PC(2,2)) '.mat'],'F')

        %Posibilidad 2ª: Hay archivos, pero ninguno es de mi punto de
        %control --> Calculo F
        elseif isempty(val)
            ini=1;
            [F]=EXTRACCION_VALOR_DE_F_MA_Q_MM_OD(Forzamiento,Forzamiento_3h,PC,M,pos,ini,SC,OF,var);
            save(['DATOS\VALORES DE F\TP\MA_Q_MM_OD\' SC '\' OF '\' 'MA_Q_MM_OD_M=' num2str(M) '_PC_' num2str(PC(2,1)) '_' num2str(PC(2,2)) '.mat'],'F')

        %3ª Posibilidad Hay archivos en mi punto de control
        elseif isempty(val)==0

            %Tengo dos opciones: 
            if maximo>=M %Si el archivo en mi punto de control es mayor o igual que la M que busco
                %En este caso tomo los M primeros valores                
                load(['DATOS\VALORES DE F\TP\MA_Q_MM_OD\' SC '\' OF '\' 'MA_Q_MM_OD_M=' num2str(maximo) '_PC_' num2str(PC(2,1)) '_' num2str(PC(2,2)) '.mat'])

                %Me quedo únicamente con los M primeros valores
                F.MA_Q_MM_OD.tp=F.MA_Q_MM_OD.tp(1:M);

                save(['DATOS\VALORES DE F\TP\MA_Q_MM_OD\' SC '\' OF '\' 'MA_Q_MM_OD_M=' num2str(M) '_PC_' num2str(PC(2,1)) '_' num2str(PC(2,2)) '.mat'],'F')    


            elseif maximo<M %El archivo en mi punto de control es menor que la M que busco.

                %En este caso cargo el archivo, tomo los maximo
                %primeros valores y el resto los calculo.
                load(['DATOS\VALORES DE F\TP\MA_Q_MM_OD\' SC '\' OF '\' 'MA_Q_MM_OD_M=' num2str(maximo) '_PC_' num2str(PC(2,1)) '_' num2str(PC(2,2)) '.mat'])

                ini=maximo+1;
                [F]=EXTRACCION_VALOR_DE_F_MA_Q_MM_OD(Forzamiento,Forzamiento_3h,PC,M,pos,ini,SC,OF,var);

                %Me cargo las posiciones no validas
                F_nuevo.MA_Q_MM_OD.tp(1:maximo)=[];

                %Lo junto todo
                F.MA_Q_MM_OD.tp=[F.MA_Q_MM_OD.hs F_nuevo.MA_Q_MM_OD.tp];

                save(['DATOS\VALORES DE F\TP\MA_Q_MM_OD\' SC '\' OF '\' 'MA_Q_MM_OD_M=' num2str(M) '_PC_' num2str(PC(2,1)) '_' num2str(PC(2,2)) '.mat'],'F')
            end
        end
        end   
    end
    
elseif strcmp(var, 'do')
    %En primer lugar compruebo si ya existe el valor de F guardado para
    %ese forzamiento y punto de control
    if exist(['DATOS\VALORES DE F\DO\MA_Q_MM_OD\' SC '\' OF '\' 'MA_Q_MM_OD_M=' num2str(M) '_PC_' num2str(PC(2,1)) '_' num2str(PC(2,2)) '.mat'])==2
        %Si existe lo cargo
        load(['DATOS\VALORES DE F\DO\MA_Q_MM_OD\' SC '\' OF '\' 'MA_Q_MM_OD_M=' num2str(M) '_PC_' num2str(PC(2,1)) '_' num2str(PC(2,2)) '.mat'])

    else %Si no existe pasamos a la segunda fase en dónde intetaremos optimziar la extraccion de F 

            %1º Vemos si existe la carpeta           
            if ~exist(['DATOS\VALORES DE F\DO\MA_Q_MM_OD\' SC '\' OF],'dir')
                mkdir(['DATOS\VALORES DE F\DO\MA_Q_MM_OD\' SC '\' OF])
            end

            %1º Vemos que archivos tengo en la carpeta
            s = what(['DATOS\VALORES DE F\DO\MA_Q_MM_OD\' SC '\' OF]);           
            % Compruebo si no hay archivos, en cuyo caso calculo F
            files=s(1,1).mat;
            s=size(files);
            s=s(1);

            if s==0
                ini=1;
                [F]=EXTRACCION_VALOR_DE_F_MA_Q_MM_OD(Forzamiento,Forzamiento_3h,PC,M,pos,ini,SC,OF,var);
                save(['DATOS\VALORES DE F\DO\MA_Q_MM_OD\' SC '\' OF '\' 'MA_Q_MM_OD_M=' num2str(M) '_PC_' num2str(PC(2,1)) '_' num2str(PC(2,2)) '.mat'],'F')

            else

            s = what(['DATOS\VALORES DE F\DO\MA_Q_MM_OD\' SC '\' OF]);           
            % Compruebo si no hay archivos, en cuyo caso calculo F            
            files=s(1,1).mat;
            s=size(files);
            s=s(1);

        %2º Hacemos una lista de los archivos de F en mi punto de
        %control

        %Almaceno el número de valores de la muestra de cada fichero
        for j=1:s
            Str=char(files(j)); 
            Key   = '_';            
            Index = strfind(Str, Key);
            pos_pc1(j) = sscanf(Str(Index(end-1) + length(Key):end), '%g', 1);
            pos_pc2(j) = sscanf(Str(Index(end) + length(Key):end), '%g', 1);
            Key_value = '=';
            Index = strfind(Str, Key_value);
            Value(j) = sscanf(Str(Index(1) + length(Key_value):end), '%g', 1);
        end

        % Busco las posiciones de mi punto de control
        val=find(pos_pc1==PC(1) & pos_pc2==PC(2));

        %Busco los valores de M en dichas posiciones
        Value=Value(val);

        % Busco el máximo y su posición
        [maximo val]=max(Value);           

        %Posibilidad 1º: No tengo archivos --> Calculo el valor de F
        if isempty(files) 
            ini=1;
            [F]=EXTRACCION_VALOR_DE_F_MA_Q_MM_OD(Forzamiento,Forzamiento_3h,PC,M,pos,ini,SC,OF,var);
            save(['DATOS\VALORES DE F\DO\MA_Q_MM_OD\' SC '\' OF '\' 'MA_Q_MM_OD_M=' num2str(M) '_PC_' num2str(PC(2,1)) '_' num2str(PC(2,2)) '.mat'],'F')

        %Posibilidad 2ª: Hay archivos, pero ninguno es de mi punto de
        %control --> Calculo F
        elseif isempty(val)
            ini=1;
            [F]=EXTRACCION_VALOR_DE_F_MA_Q_MM_OD(Forzamiento,Forzamiento_3h,PC,M,pos,ini,SC,OF,var);
            save(['DATOS\VALORES DE F\DO\MA_Q_MM_OD\' SC '\' OF '\' 'MA_Q_MM_OD_M=' num2str(M) '_PC_' num2str(PC(2,1)) '_' num2str(PC(2,2)) '.mat'],'F')

        %3ª Posibilidad Hay archivos en mi punto de control
        elseif isempty(val)==0

            %Tengo dos opciones: 
            if maximo>=M %Si el archivo en mi punto de control es mayor o igual que la M que busco
                %En este caso tomo los M primeros valores                
                load(['DATOS\VALORES DE F\DO\MA_Q_MM_OD\' SC '\' OF '\' 'MA_Q_MM_OD_M=' num2str(maximo) '_PC_' num2str(PC(2,1)) '_' num2str(PC(2,2)) '.mat'])

                %Me quedo únicamente con los M primeros valores
                F.MA_Q_MM_OD.do=F.MA_Q_MM_OD.do(1:M);

                save(['DATOS\VALORES DE F\DO\MA_Q_MM_OD\' SC '\' OF '\' 'MA_Q_MM_OD_M=' num2str(M) '_PC_' num2str(PC(2,1)) '_' num2str(PC(2,2)) '.mat'],'F')    


            elseif maximo<M %El archivo en mi punto de control es menor que la M que busco.

                %En este caso cargo el archivo, tomo los maximo
                %primeros valores y el resto los calculo.
                load(['DATOS\VALORES DE F\DO\MA_Q_MM_OD\' SC '\' OF '\' 'MA_Q_MM_OD_M=' num2str(maximo) '_PC_' num2str(PC(2,1)) '_' num2str(PC(2,2)) '.mat'])

                ini=maximo+1;
                [F]=EXTRACCION_VALOR_DE_F_MA_Q_MM_OD(Forzamiento,Forzamiento_3h,PC,M,pos,ini,SC,OF,var);

                %Me cargo las posiciones no validas
                F_nuevo.MA_Q_MM_OD.do(1:maximo)=[];

                %Lo junto todo
                F.MA_Q_MM_OD.do=[F.MA_Q_MM_OD.do F_nuevo.MA_Q_MM_OD.do];

                save(['DATOS\VALORES DE F\DO\MA_Q_MM_OD\' SC '\' OF '\' 'MA_Q_MM_OD_M=' num2str(M) '_PC_' num2str(PC(2,1)) '_' num2str(PC(2,2)) '.mat'],'F')
            end
        end
        end   
    end
    

end
