function [c,E]=PARAMETRO_FORMA_RIPPA_99(c_ini,c_paso,c_fin,c_vect,VAR,F,d,Forzamiento,M,PC,Forz_input, SC, OF, var)

warning('')

%Primera comprobación ¿Existe oleaje como forzamiento?
comp_oleaje=isfield(Forzamiento,'O');
comp_oleaje_desembocadura=isfield(Forzamiento,'OD');
comp_oleaje_desembocadura_sin_viento=isfield(Forzamiento,'ODSV');
comp_m_meteo=isfield(Forzamiento,'MM');
comp_descarga=isfield(Forzamiento,'Q');
comp_slr = (isfield(Forzamiento,'SLR_95_85') || isfield(Forzamiento,'SLR_05_45'));

%Obtengo los forzamientos que se han elegido
names = fieldnames(Forzamiento);
l=length(names);

if strcmp(var, 'eta')

    if  comp_oleaje==0 && comp_m_meteo==0 && comp_oleaje_desembocadura==0 && comp_oleaje_desembocadura_sin_viento==0 % Caso 1 no hay ni olejae ni m.meteo
        
                
        if comp_slr == 1 && Forz_input.MA==0 && Forz_input.Q==0
            f=F.SLR.WL;

            %Creo una carpeta diferente para cada combinación de agentes en la que voy
            %a guardar los valores de f para no tener que cargarlos cada vez
            fold_name='';
            for j=1:l
               fold_name=[fold_name char(names(j)),'_']; 
            end

            %Creo la carpeta dentro de datos
            addpath('\DATOS\PARAMETRO_FORMA_RIPPA_99\ELEVACIONES_GAUDALETE')
            mkdir(['DATOS\PARAMETRO_FORMA_RIPPA_99\ELEVACIONES_GAUDALETE\' fold_name '\' VAR '\' SC '\' OF])
            addpath(['DATOS\PARAMETRO_FORMA_RIPPA_99\ELEVACIONES_GAUDALETE\' fold_name '\' VAR '\' SC '\' OF])

            %Busco si existe un fichero con M puntos de la muestra o más
            file_name=[fold_name VAR '_' SC '_' OF '_' 'M=' num2str(M) '_PC_' num2str(PC(1)) '_' num2str(PC(2))];

            % Compruebo si hay archivos en la carpeta, si los hay los cargo para ver si
            % son mayores al número de valores de la muestra que deseo. Si no hay o el
            % número de valores es menor aplico el proceso de selección mediante MDA
            s = what(['DATOS\PARAMETRO_FORMA_RIPPA_99\ELEVACIONES_GAUDALETE\' fold_name '\' VAR '\' SC '\' OF]);
            files=s(1,1).mat;

            if exist(['DATOS\PARAMETRO_FORMA_RIPPA_99\ELEVACIONES_GAUDALETE\' fold_name '\' SC '\' OF '\' file_name '.mat'])==0 %Si no existe el archivo específico

                % Método Rippa con P(x)
                cont=1;
                progressbar('Optimización del parámetro de forma') % Init single bar
                for c=c_ini:c_paso:c_fin

                    % Cálculo de la Matriz A reducida (sin Px)
                    A_red=zeros(M,M);
                    for i=1:M
                        for j=1:M
                            dist=sqrt((d(i,1)-d(j,1))^2);
                            A_red(i,j)=exp(-((dist^2)/(2*c^2))); % A_reducida
                        end    
                    end

                    % En segundo lugar calculo la segunda parte de la Matriz A, metiendo
                    % los valores de la muestra
                    A_II=zeros(M,length([1 d(1,:)]));
                    for i=1:M
                        A_II(i,:)=[1 d(i,:)];
                    end

                    % En tercer lugar termino de calcular la matriz A introduciendo los 0
                    s=size(A_II);
                    Z=zeros(s(2),s(2));

                    A_1=[A_red;A_II'];
                    A_2=[A_II;Z];
                    A=[A_1 A_2]; %Matriz A completa

                    % Calculo los coeficientes a            
                    a=A\[f zeros(1,length(d(1,:))+1)]';

                    % Matriz identidad
                    l=length(A(:,1));
                    I=eye(l);

                    for k=1:M
                        x_k=A\I(:,k); 

                        f_k=[f zeros(1,length(d(1,:))+1)]';
                        f_k(k)=[];

                        A_k=A;
                        A_k(k,:)=[];
                        A_k(:,k)=[];

                        a_k=inv(A_k)*f_k; %Los coeficientes cambian para cada k
                        b_k=a-(a(k)/x_k(k))*x_k;
                        b_k(k)=[];

                        diferencia{cont}=abs(a_k-b_k); %Comprobacion de que se cumple la hipotesis
                        E_k(k)=a(k)/x_k(k);
                    end

                    %Calculo el error para ese valor de c
                    E(cont)=sum(abs(E_k)); %L-1 norm
                    cont=cont+1; 

                    [warnmsg, msgid] = lastwarn;
                    if strcmp(msgid,'MATLAB:nearlySingularMatrix');
                        break
                    end
                    warning('')

                    disp(c)

                progressbar(c/c_fin) % Update progress bar
                end    
                close 

                [~,pos]=min(E);
                c=c_vect(pos);

                save(['DATOS\PARAMETRO_FORMA_RIPPA_99\ELEVACIONES_GAUDALETE\' fold_name '\' VAR '\' SC '\' OF '\' file_name '.mat'],'c','E')

            else

                load(['DATOS\PARAMETRO_FORMA_RIPPA_99\ELEVACIONES_GAUDALETE\' fold_name '\' VAR '\' SC '\' OF '\' file_name '.mat'])

            end

            [~,pos]=min(E);
            figure(5)
            y = E./M*100;
            plot(c_vect(1:length(E)),y)
            hold on
            plot(c_vect(pos), y(pos),'ok')
            ylabel ('Error (cm)')
            xlabel('Par. Forma (c)')
            
        end
        
        
        
        % En el caso 1, sólo puedo tener MA o Q o ambos
        if Forz_input.MA==1 && Forz_input.Q==0 %Caso 1 Opción 1: Tengo sólo MA
            f=F.MA.WL;

            %Creo una carpeta diferente para cada combinación de agentes en la que voy
            %a guardar los valores de f para no tener que cargarlos cada vez
            fold_name='';
            for j=1:l
               fold_name=[fold_name char(names(j)),'_']; 
            end

            %Creo la carpeta dentro de datos
            addpath('\DATOS\PARAMETRO_FORMA_RIPPA_99\ELEVACIONES_GAUDALETE')
            mkdir(['DATOS\PARAMETRO_FORMA_RIPPA_99\ELEVACIONES_GAUDALETE\' fold_name '\' VAR '\' SC '\' OF])
            addpath(['DATOS\PARAMETRO_FORMA_RIPPA_99\ELEVACIONES_GAUDALETE\' fold_name '\' VAR '\' SC '\' OF])

            %Busco si existe un fichero con M puntos de la muestra o más
            file_name=[fold_name VAR '_' SC '_' OF '_' 'M=' num2str(M) '_PC_' num2str(PC(1)) '_' num2str(PC(2))];

            % Compruebo si hay archivos en la carpeta, si los hay los cargo para ver si
            % son mayores al número de valores de la muestra que deseo. Si no hay o el
            % número de valores es menor aplico el proceso de selección mediante MDA
            s = what(['DATOS\PARAMETRO_FORMA_RIPPA_99\ELEVACIONES_GAUDALETE\' fold_name '\' VAR '\' SC '\' OF]);
            files=s(1,1).mat;

            if exist(['DATOS\PARAMETRO_FORMA_RIPPA_99\ELEVACIONES_GAUDALETE\' fold_name '\' SC '\' OF '\' file_name '.mat'])==0 %Si no existe el archivo específico

                % Método Rippa con P(x)
                cont=1;
                progressbar('Optimización del parámetro de forma') % Init single bar
                for c=c_ini:c_paso:c_fin

                    % Cálculo de la Matriz A reducida (sin Px)
                    A_red=zeros(M,M);
                    for i=1:M
                        for j=1:M
                            dist=sqrt((d(i,1)-d(j,1))^2);
                            A_red(i,j)=exp(-((dist^2)/(2*c^2))); % A_reducida
                        end    
                    end

                    % En segundo lugar calculo la segunda parte de la Matriz A, metiendo
                    % los valores de la muestra
                    A_II=zeros(M,length([1 d(1,:)]));
                    for i=1:M
                        A_II(i,:)=[1 d(i,:)];
                    end

                    % En tercer lugar termino de calcular la matriz A introduciendo los 0
                    s=size(A_II);
                    Z=zeros(s(2),s(2));

                    A_1=[A_red;A_II'];
                    A_2=[A_II;Z];
                    A=[A_1 A_2]; %Matriz A completa

                    % Calculo los coeficientes a            
                    a=A\[f zeros(1,length(d(1,:))+1)]';

                    % Matriz identidad
                    l=length(A(:,1));
                    I=eye(l);

                    for k=1:M
                        x_k=A\I(:,k); 

                        f_k=[f zeros(1,length(d(1,:))+1)]';
                        f_k(k)=[];

                        A_k=A;
                        A_k(k,:)=[];
                        A_k(:,k)=[];

                        a_k=inv(A_k)*f_k; %Los coeficientes cambian para cada k
                        b_k=a-(a(k)/x_k(k))*x_k;
                        b_k(k)=[];

                        diferencia{cont}=abs(a_k-b_k); %Comprobacion de que se cumple la hipotesis
                        E_k(k)=a(k)/x_k(k);
                    end

                    %Calculo el error para ese valor de c
                    E(cont)=sum(abs(E_k)); %L-1 norm
                    cont=cont+1; 

                    [warnmsg, msgid] = lastwarn;
                    if strcmp(msgid,'MATLAB:nearlySingularMatrix');
                        break
                    end
                    warning('')

                    disp(c)

                progressbar(c/c_fin) % Update progress bar
                end    
                close 

                [~,pos]=min(E);
                c=c_vect(pos);

                save(['DATOS\PARAMETRO_FORMA_RIPPA_99\ELEVACIONES_GAUDALETE\' fold_name '\' VAR '\' SC '\' OF '\' file_name '.mat'],'c','E')

            else

                load(['DATOS\PARAMETRO_FORMA_RIPPA_99\ELEVACIONES_GAUDALETE\' fold_name '\' VAR '\' SC '\' OF '\' file_name '.mat'])

            end

            [~,pos]=min(E);
            figure(5)
            y = E./M*100;
            plot(c_vect(1:length(E)),y)
            hold on
            plot(c_vect(pos), y(pos),'ok')
            ylabel ('Error (cm)')
            xlabel('Par. Forma (c)')


        % En el caso 1, sólo puedo tener MA o Q o ambos
        elseif Forz_input.MA_DESPLAZ==1 && Forz_input.Q==0 %Caso 1 Opción 1: Tengo sólo MA_DESPLAZ
            f=F.MA_DESPLAZ.WL;

            %Creo una carpeta diferente para cada combinación de agentes en la que voy
            %a guardar los valores de f para no tener que cargarlos cada vez
            fold_name='';
            for j=1:1
               fold_name=[fold_name char(names(j)),'_']; 
            end

            %Creo la carpeta dentro de datos
            addpath('\DATOS\PARAMETRO_FORMA_RIPPA_99\ELEVACIONES_GAUDALETE')
            mkdir(['DATOS\PARAMETRO_FORMA_RIPPA_99\ELEVACIONES_GAUDALETE\' fold_name '\' VAR])
            addpath(['DATOS\PARAMETRO_FORMA_RIPPA_99\ELEVACIONES_GAUDALETE\' fold_name '\' VAR])

            %Busco si existe un fichero con M puntos de la muestra o más
            file_name=[fold_name VAR '_' 'M=' num2str(M) '_PC_' num2str(PC(1)) '_' num2str(PC(2))];

            % Compruebo si hay archivos en la carpeta, si los hay los cargo para ver si
            % son mayores al número de valores de la muestra que deseo. Si no hay o el
            % número de valores es menor aplico el proceso de selección mediante MDA
            s = what(['DATOS\PARAMETRO_FORMA_RIPPA_99\ELEVACIONES_GAUDALETE\' fold_name '\' VAR]);
            files=s(1,1).mat;

            if exist(['DATOS\PARAMETRO_FORMA_RIPPA_99\ELEVACIONES_GAUDALETE\' fold_name '\' VAR '\' file_name '.mat'])==0 %Si no existe el archivo específico

                % Método Rippa con P(x)
                cont=1;
                progressbar('Optimización del parámetro de forma') % Init single bar
                for c=c_ini:c_paso:c_fin

                    % Cálculo de la Matriz A reducida (sin Px)
                    A_red=zeros(M,M);
                    for i=1:M
                        for j=1:M
                            dist=sqrt((d(i,1)-d(j,1))^2);
                            A_red(i,j)=exp(-((dist^2)/(2*c^2))); % A_reducida
                        end    
                    end

                    % En segundo lugar calculo la segunda parte de la Matriz A, metiendo
                    % los valores de la muestra
                    A_II=zeros(M,length([1 d(1,:)]));
                    for i=1:M
                        A_II(i,:)=[1 d(i,:)];
                    end

                    % En tercer lugar termino de calcular la matriz A introduciendo los 0
                    s=size(A_II);
                    Z=zeros(s(2),s(2));

                    A_1=[A_red;A_II'];
                    A_2=[A_II;Z];
                    A=[A_1 A_2]; %Matriz A completa

                    % Calculo los coeficientes a            
                    a=A\[f zeros(1,length(d(1,:))+1)]';

                    % Matriz identidad
                    l=length(A(:,1));
                    I=eye(l);

                    for k=1:M
                        x_k=A\I(:,k); 

                        f_k=[f zeros(1,length(d(1,:))+1)]';
                        f_k(k)=[];

                        A_k=A;
                        A_k(k,:)=[];
                        A_k(:,k)=[];

                        a_k=inv(A_k)*f_k; %Los coeficientes cambian para cada k
                        b_k=a-(a(k)/x_k(k))*x_k;
                        b_k(k)=[];

                        diferencia{cont}=abs(a_k-b_k); %Comprobacion de que se cumple la hipotesis
                        E_k(k)=a(k)/x_k(k);
                    end

                    %Calculo el error para ese valor de c
                    E(cont)=sum(abs(E_k)); %L-1 norm
                    cont=cont+1; 

                    [warnmsg, msgid] = lastwarn;
                    if strcmp(msgid,'MATLAB:nearlySingularMatrix');
                        break
                    end
                    warning('')

                    disp(c)

                progressbar(c/c_fin) % Update progress bar
                end    
                close 

                [~,pos]=min(E);
                c=c_vect(pos);

                save(['DATOS\PARAMETRO_FORMA_RIPPA_99\ELEVACIONES_GAUDALETE\' fold_name '\' VAR '\' file_name '.mat'],'c','E')

            else

                load(['DATOS\PARAMETRO_FORMA_RIPPA_99\ELEVACIONES_GAUDALETE\' fold_name '\' VAR '\' file_name '.mat'])

            end

            [~,pos]=min(E);
            figure(5)
            y = E./M*100;
            plot(c_vect(1:length(E)),y)
            hold on
            plot(c_vect(pos), y(pos),'ok')
            ylabel ('Error (cm)')
            xlabel('Par. Forma (c)')

        elseif Forz_input.MA==0 && Forz_input.Q==1 %Caso 1 Opción 2: Tengo sólo Q

            f=F.Q.WL;

            %Creo una carpeta diferente para cada combinación de agentes en la que voy
            %a guardar los valores de f para no tener que cargarlos cada vez
            fold_name='';
            for j=1:l
               fold_name=[fold_name char(names(j)),'_']; 
            end

            %Creo la carpeta dentro de datos
            addpath('\DATOS\PARAMETRO_FORMA_RIPPA_99\ELEVACIONES_GAUDALETE')
            mkdir(['DATOS\PARAMETRO_FORMA_RIPPA_99\ELEVACIONES_GAUDALETE\' fold_name '\' VAR])
            addpath(['DATOS\PARAMETRO_FORMA_RIPPA_99\ELEVACIONES_GAUDALETE\' fold_name '\' VAR])

            %Busco si existe un fichero con M puntos de la muestra o más
            file_name=[fold_name VAR '_' 'M=' num2str(M) '_PC_' num2str(PC(1)) '_' num2str(PC(2))];

            % Compruebo si hay archivos en la carpeta, si los hay los cargo para ver si
            % son mayores al número de valores de la muestra que deseo. Si no hay o el
            % número de valores es menor aplico el proceso de selección mediante MDA
            s = what(['DATOS\PARAMETRO_FORMA_RIPPA_99\ELEVACIONES_GAUDALETE\' fold_name '\' VAR]);
            files=s(1,1).mat;

            if exist(['DATOS\PARAMETRO_FORMA_RIPPA_99\ELEVACIONES_GAUDALETE\' fold_name '\' VAR '\' file_name '.mat'])==0 %Si no existe el archivo específico

                % Método Rippa con P(x)
                cont=1;
                progressbar('Optimización del parámetro de forma') % Init single bar
                for c=c_ini:c_paso:c_fin

                    % Cálculo de la Matriz A reducida (sin Px)
                    A_red=zeros(M,M);
                    for i=1:M
                        for j=1:M
                            dist=sqrt((d(i,1)-d(j,1))^2);
                            A_red(i,j)=exp(-((dist^2)/(2*c^2))); % A_reducida
                        end    
                    end

                    % En segundo lugar calculo la segunda parte de la Matriz A, metiendo
                    % los valores de la muestra
                    A_II=zeros(M,length([1 d(1,:)]));
                    for i=1:M
                        A_II(i,:)=[1 d(i,:)];
                    end

                    % En tercer lugar termino de calcular la matriz A introduciendo los 0
                    s=size(A_II);
                    Z=zeros(s(2),s(2));

                    A_1=[A_red;A_II'];
                    A_2=[A_II;Z];
                    A=[A_1 A_2]; %Matriz A completa

                    % Calculo los coeficientes a            
                    a=A\[f zeros(1,length(d(1,:))+1)]';

                    % Matriz identidad
                    l=length(A(:,1));
                    I=eye(l);

                    for k=1:M
                        x_k=A\I(:,k); 

                        f_k=[f zeros(1,length(d(1,:))+1)]';
                        f_k(k)=[];

                        A_k=A;
                        A_k(k,:)=[];
                        A_k(:,k)=[];

                        a_k=inv(A_k)*f_k; %Los coeficientes cambian para cada k
                        b_k=a-(a(k)/x_k(k))*x_k;
                        b_k(k)=[];

                        diferencia{cont}=abs(a_k-b_k); %Comprobacion de que se cumple la hipotesis
                        E_k(k)=a(k)/x_k(k);
                    end

                    %Calculo el error para ese valor de c
                    E(cont)=sum(abs(E_k)); %L-1 norm
                    cont=cont+1; 

                    [warnmsg, msgid] = lastwarn;
                    if strcmp(msgid,'MATLAB:nearlySingularMatrix');
                        break
                    end
                    warning('')

                    disp(c)

                progressbar(c/c_fin) % Update progress bar
                end    


                [~,pos]=min(E);
                c=c_vect(pos);

                save(['DATOS\PARAMETRO_FORMA_RIPPA_99\ELEVACIONES_GAUDALETE\' fold_name '\' VAR '\' file_name '.mat'],'c','E')

            else

                load(['DATOS\PARAMETRO_FORMA_RIPPA_99\ELEVACIONES_GAUDALETE\' fold_name '\' VAR '\' file_name '.mat'])

            end
        end

        [~,pos]=min(E);
        figure(5)
        y = E./M*100;
        plot(c_vect(1:length(E)),y)
        hold on
        plot(c_vect(pos), y(pos),'ok')
        ylabel ('Error (cm)')
        xlabel('Par. Forma (c)')

    elseif comp_oleaje==0 && comp_m_meteo==1 && comp_oleaje_desembocadura==0 && comp_oleaje_desembocadura_sin_viento==0 % Caso 2 Sólo tengo M.Meteo
        % En el caso 2, sólo puedo tener MMeteo
        f=F.MM.WL;

        %Creo una carpeta diferente para cada combinación de agentes en la que voy
        %a guardar los valores de f para no tener que cargarlos cada vez
        fold_name='';
        for j=1:l
           fold_name=[fold_name char(names(j)),'_']; 
        end

        %Creo la carpeta dentro de datos
        addpath('\DATOS\PARAMETRO_FORMA_RIPPA_99\ELEVACIONES_GAUDALETE')
        mkdir(['DATOS\PARAMETRO_FORMA_RIPPA_99\ELEVACIONES_GAUDALETE\' fold_name '\' VAR])
        addpath(['DATOS\PARAMETRO_FORMA_RIPPA_99\ELEVACIONES_GAUDALETE\' fold_name '\' VAR])

        %Busco si existe un fichero con M puntos de la muestra o más
        file_name=[fold_name VAR '_' 'M=' num2str(M) '_PC_' num2str(PC(1)) '_' num2str(PC(2))];

        % Compruebo si hay archivos en la carpeta, si los hay los cargo para ver si
        % son mayores al número de valores de la muestra que deseo. Si no hay o el
        % número de valores es menor aplico el proceso de selección mediante MDA
        s = what(['DATOS\PARAMETRO_FORMA_RIPPA_99\ELEVACIONES_GAUDALETE\' fold_name '\' VAR]);
        files=s(1,1).mat;

        if exist(['DATOS\PARAMETRO_FORMA_RIPPA_99\ELEVACIONES_GAUDALETE\' fold_name '\' VAR '\' file_name '.mat'])==0 %Si no existe el archivo específico

            % Método Rippa con P(x)
            cont=1;
            progressbar('Optimización del parámetro de forma') % Init single bar
            for c=c_ini:c_paso:c_fin

                % Cálculo de la Matriz A reducida (sin Px)
                A_red=zeros(M,M);
                for i=1:M
                    for j=1:M
                        minimo_teta_viento=min([abs(d(i,2)-d(j,2)) 2-abs(d(i,2)-d(j,2))]);
                        dist=sqrt((d(i,1)-d(j,1))^2+minimo_teta_viento^2+(d(i,3)-d(j,3))^2);
                        A_red(i,j)=exp(-((dist^2)/(2*c^2))); % A_reducida
                    end    
                end

                % En segundo lugar calculo la segunda parte de la Matriz A, metiendo
                % los valores de la muestra
                A_II=zeros(M,length([1 d(1,:)]));
                for i=1:M
                    A_II(i,:)=[1 d(i,:)];
                end

                % En tercer lugar termino de calcular la matriz A introduciendo los 0
                s=size(A_II);
                Z=zeros(s(2),s(2));

                A_1=[A_red;A_II'];
                A_2=[A_II;Z];
                A=[A_1 A_2]; %Matriz A completa

                % Calculo los coeficientes a            
                a=A\[f zeros(1,length(d(1,:))+1)]';

                % Matriz identidad
                l=length(A(:,1));
                I=eye(l);

                for k=1:M
                    x_k=A\I(:,k); 

                    f_k=[f zeros(1,length(d(1,:))+1)]';
                    f_k(k)=[];

                    A_k=A;
                    A_k(k,:)=[];
                    A_k(:,k)=[];

                    a_k=inv(A_k)*f_k; %Los coeficientes cambian para cada k
                    b_k=a-(a(k)/x_k(k))*x_k;
                    b_k(k)=[];

                    diferencia{cont}=abs(a_k-b_k); %Comprobacion de que se cumple la hipotesis
                    E_k(k)=a(k)/x_k(k);
                end

                %Calculo el error para ese valor de c
                E(cont)=sum(abs(E_k)); %L-1 norm
                cont=cont+1; 

                [warnmsg, msgid] = lastwarn;
                if strcmp(msgid,'MATLAB:nearlySingularMatrix');
                    break
                end
                warning('')

                disp(c)

            progressbar(c/c_fin) % Update progress bar
            end    


            [~,pos]=min(E);
            c=c_vect(pos);

            save(['DATOS\PARAMETRO_FORMA_RIPPA_99\ELEVACIONES_GAUDALETE\' fold_name '\' VAR '\' file_name '.mat'],'c','E')

        else

            load(['DATOS\PARAMETRO_FORMA_RIPPA_99\ELEVACIONES_GAUDALETE\' fold_name '\' VAR '\' file_name '.mat'])

        end

        [~,pos]=min(E);
        figure(5)
        y = E./M*100;
        plot(c_vect(1:length(E)),y)
        hold on
        plot(c_vect(pos), y(pos),'ok')
        ylabel ('Error (cm)')
        xlabel('Par. Forma (c)')

    elseif comp_oleaje==0 && comp_m_meteo==0 && comp_oleaje_desembocadura==0 && comp_oleaje_desembocadura_sin_viento==1 % Caso 3 Sólo tengo Oleaje en la desembocadura sin viento

        % En el caso 3, sólo puedo tener Oleaje en la desembocadura sin viento
        f=F.ODSV.WL;

        %Creo una carpeta diferente para cada combinación de agentes en la que voy
        %a guardar los valores de f para no tener que cargarlos cada vez
        fold_name='';
        for j=1:l
           fold_name=[fold_name char(names(j)),'_']; 
        end

        %Creo la carpeta dentro de datos
        addpath('\DATOS\PARAMETRO_FORMA_RIPPA_99\ELEVACIONES_GAUDALETE')
        mkdir(['DATOS\PARAMETRO_FORMA_RIPPA_99\ELEVACIONES_GAUDALETE\' fold_name '\' VAR])
        addpath(['DATOS\PARAMETRO_FORMA_RIPPA_99\ELEVACIONES_GAUDALETE\' fold_name '\' VAR])

        %Busco si existe un fichero con M puntos de la muestra o más
        file_name=[fold_name VAR '_' 'M=' num2str(M) '_PC_' num2str(PC(1)) '_' num2str(PC(2))];

        % Compruebo si hay archivos en la carpeta, si los hay los cargo para ver si
        % son mayores al número de valores de la muestra que deseo. Si no hay o el
        % número de valores es menor aplico el proceso de selección mediante MDA
        s = what(['DATOS\PARAMETRO_FORMA_RIPPA_99\ELEVACIONES_GAUDALETE\' fold_name '\' VAR]);
        files=s(1,1).mat;

        if exist(['DATOS\PARAMETRO_FORMA_RIPPA_99\ELEVACIONES_GAUDALETE\' fold_name '\' VAR '\' file_name '.mat'])==0 %Si no existe el archivo específico

            % Método Rippa con P(x)
            cont=1;
            progressbar('Optimización del parámetro de forma') % Init single bar
            for c=c_ini:c_paso:c_fin

                % Cálculo de la Matriz A reducida (sin Px)
                A_red=zeros(M,M);
                for i=1:M
                    for j=1:M
                        minimo_teta_oleaje=min([abs(d(i,3)-d(j,3)) 2-abs(d(i,3)-d(j,3))]);
                        dist=sqrt((d(i,1)-d(j,1))^2+(d(i,2)-d(j,2))^2+minimo_teta_oleaje^2);
                        A_red(i,j)=exp(-((dist^2)/(2*c^2))); % A_reducida
                    end    
                end

                % En segundo lugar calculo la segunda parte de la Matriz A, metiendo
                % los valores de la muestra
                A_II=zeros(M,length([1 d(1,:)]));
                for i=1:M
                    A_II(i,:)=[1 d(i,:)];
                end

                % En tercer lugar termino de calcular la matriz A introduciendo los 0
                s=size(A_II);
                Z=zeros(s(2),s(2));

                A_1=[A_red;A_II'];
                A_2=[A_II;Z];
                A=[A_1 A_2]; %Matriz A completa

                % Calculo los coeficientes a            
                a=A\[f zeros(1,length(d(1,:))+1)]';

                % Matriz identidad
                l=length(A(:,1));
                I=eye(l);

                for k=1:M
                    x_k=A\I(:,k); 

                    f_k=[f zeros(1,length(d(1,:))+1)]';
                    f_k(k)=[];

                    A_k=A;
                    A_k(k,:)=[];
                    A_k(:,k)=[];

                    a_k=inv(A_k)*f_k; %Los coeficientes cambian para cada k
                    b_k=a-(a(k)/x_k(k))*x_k;
                    b_k(k)=[];

                    diferencia{cont}=abs(a_k-b_k); %Comprobacion de que se cumple la hipotesis
                    E_k(k)=a(k)/x_k(k);
                end

                %Calculo el error para ese valor de c
                E(cont)=sum(abs(E_k)); %L-1 norm
                cont=cont+1; 

                [warnmsg, msgid] = lastwarn;
                if strcmp(msgid,'MATLAB:nearlySingularMatrix');
                    break
                end
                warning('')

                disp(c)

            progressbar(c/c_fin) % Update progress bar
            end    


            [~,pos]=min(E);
            c=c_vect(pos);

            save(['DATOS\PARAMETRO_FORMA_RIPPA_99\ELEVACIONES_GAUDALETE\' fold_name '\' VAR '\' file_name '.mat'],'c','E')

        else

            load(['DATOS\PARAMETRO_FORMA_RIPPA_99\ELEVACIONES_GAUDALETE\' fold_name '\' VAR '\' file_name '.mat'])

        end

        [~,pos]=min(E);
        figure(5)
        y = E./M*100;
        plot(c_vect(1:length(E)),y)
        hold on
        plot(c_vect(pos), y(pos),'ok')
        ylabel ('Error (cm)')
        xlabel('Par. Forma (c)')

    elseif  comp_descarga==0 && comp_oleaje==0 && comp_m_meteo==1 && comp_oleaje_desembocadura==1 && comp_oleaje_desembocadura_sin_viento==0 % Caso 4 Tengo Oleaje en la desembocadura con viento más marea meteorológica    

        % En el caso 2-3, tengo MM y OD
        f=F.MM_OD.WL;

        %Creo una carpeta diferente para cada combinación de agentes en la que voy
        %a guardar los valores de f para no tener que cargarlos cada vez
        fold_name='';
        for j=1:l
           fold_name=[fold_name char(names(j)),'_']; 
        end

        %Creo la carpeta dentro de datos
        addpath('\DATOS\PARAMETRO_FORMA_RIPPA_99\ELEVACIONES_GAUDALETE')
        mkdir(['DATOS\PARAMETRO_FORMA_RIPPA_99\ELEVACIONES_GAUDALETE\' fold_name '\' VAR])
        addpath(['DATOS\PARAMETRO_FORMA_RIPPA_99\ELEVACIONES_GAUDALETE\' fold_name '\' VAR])

        %Busco si existe un fichero con M puntos de la muestra o más
        file_name=[fold_name VAR '_' 'M=' num2str(M) '_PC_' num2str(PC(1)) '_' num2str(PC(2))];

        % Compruebo si hay archivos en la carpeta, si los hay los cargo para ver si
        % son mayores al número de valores de la muestra que deseo. Si no hay o el
        % número de valores es menor aplico el proceso de selección mediante MDA
        s = what(['DATOS\PARAMETRO_FORMA_RIPPA_99\ELEVACIONES_GAUDALETE\' fold_name '\' VAR]);
        files=s(1,1).mat;

        if exist(['DATOS\PARAMETRO_FORMA_RIPPA_99\ELEVACIONES_GAUDALETE\' fold_name '\' VAR '\' file_name '.mat'])==0 %Si no existe el archivo específico

            % Método Rippa con P(x)
            cont=1;
            progressbar('Optimización del parámetro de forma') % Init single bar
            for c=c_ini:c_paso:c_fin

                % Cálculo de la Matriz A reducida (sin Px)
                A_red=zeros(M,M);
                for i=1:M
                    for j=1:M

    %                     minimo_teta_oleaje=min([abs(d(i,7)-d(j,7)) 2-abs(d(i,7)-d(j,7))]);
    %                     minimo_teta_viento=min([abs(d(i,4)-d(j,4)) 2-abs(d(i,4)-d(j,4))]);
    %                     
    %                     dist=sqrt((d(i,1)-d(j,1))^2+(d(i,2)-d(j,2))^2+(d(i,3)-d(j,3))^2+minimo_teta_viento^2+(d(i,5)-d(j,5))^2+(d(i,6)-d(j,6))^2+minimo_teta_oleaje^2+(d(i,8)-d(j,8))^2);

                        minimo_teta_oleaje=min([abs(d(i,3)-d(j,3)) 2-abs(d(i,3)-d(j,3))]);
                        minimo_teta_viento=min([abs(d(i,5)-d(j,5)) 2-abs(d(i,5)-d(j,5))]);

                        dist=sqrt((d(i,1)-d(j,1))^2+(d(i,2)-d(j,2))^2+minimo_teta_oleaje^2+(d(i,4)-d(j,4))^2+minimo_teta_viento^2+(d(i,6)-d(j,6))^2);
                        A_red(i,j)=exp(-((dist^2)/(2*c^2))); % A_reducida
                    end    
                end

                % En segundo lugar calculo la segunda parte de la Matriz A, metiendo
                % los valores de la muestra
                A_II=zeros(M,length([1 d(1,:)]));
                for i=1:M
                    A_II(i,:)=[1 d(i,:)];
                end

                % En tercer lugar termino de calcular la matriz A introduciendo los 0
                s=size(A_II);
                Z=zeros(s(2),s(2));

                A_1=[A_red;A_II'];
                A_2=[A_II;Z];
                A=[A_1 A_2]; %Matriz A completa

                % Calculo los coeficientes a            
                a=A\[f zeros(1,length(d(1,:))+1)]';

                % Matriz identidad
                l=length(A(:,1));
                I=eye(l);

                for k=1:M
                    x_k=A\I(:,k); 

                    f_k=[f zeros(1,length(d(1,:))+1)]';
                    f_k(k)=[];

                    A_k=A;
                    A_k(k,:)=[];
                    A_k(:,k)=[];

                    a_k=inv(A_k)*f_k; %Los coeficientes cambian para cada k
                    b_k=a-(a(k)/x_k(k))*x_k;
                    b_k(k)=[];

                    diferencia{cont}=abs(a_k-b_k); %Comprobacion de que se cumple la hipotesis
                    E_k(k)=a(k)/x_k(k);
                end

                %Calculo el error para ese valor de c
                E(cont)=sum(abs(E_k)); %L-1 norm
                cont=cont+1; 

                [warnmsg, msgid] = lastwarn;
                if strcmp(msgid,'MATLAB:nearlySingularMatrix');
                    break
                end
                warning('')

                %disp(c)

            progressbar(c/c_fin) % Update progress bar
            end    

            [~,pos]=min(E);
            c=c_vect(pos);

            save(['DATOS\PARAMETRO_FORMA_RIPPA_99\ELEVACIONES_GAUDALETE\' fold_name '\' VAR '\' file_name '.mat'],'c','E')

        else

            load(['DATOS\PARAMETRO_FORMA_RIPPA_99\ELEVACIONES_GAUDALETE\' fold_name '\' VAR '\' file_name '.mat'])

        end

        [~,pos]=min(E);
        figure(5)
        y = E./M*100;
        plot(c_vect(1:length(E)),y)
        hold on
        plot(c_vect(pos), y(pos),'ok')
        ylabel ('Error (cm)')
        xlabel('Par. Forma (c)')


    elseif  comp_descarga==1 && comp_oleaje==0 && comp_m_meteo==1 && comp_oleaje_desembocadura==1 && comp_oleaje_desembocadura_sin_viento==0 % Caso 4 Tengo Oleaje en la desembocadura con viento más marea meteorológica    

        % En el caso 4, lo tengo todo
        f=F.MA_Q_MM_OD.WL;

        %Creo una carpeta diferente para cada combinación de agentes en la que voy
        %a guardar los valores de f para no tener que cargarlos cada vez
        fold_name='';
        for j=1:l
           fold_name=[fold_name char(names(j)),'_']; 
        end

        %Creo la carpeta dentro de datos
        addpath('\DATOS\PARAMETRO_FORMA_RIPPA_99\ELEVACIONES_GAUDALETE')
        mkdir(['DATOS\PARAMETRO_FORMA_RIPPA_99\ELEVACIONES_GAUDALETE\' fold_name '\' VAR '\' SC '\' OF])
        addpath(['DATOS\PARAMETRO_FORMA_RIPPA_99\ELEVACIONES_GAUDALETE\' fold_name '\' VAR '\' SC '\' OF])

        %Busco si existe un fichero con M puntos de la muestra o más
        file_name=[fold_name VAR '_' SC '_' OF '_' 'M=' num2str(M) '_PC_' num2str(PC(2,1)) '_' num2str(PC(2,2))];

        % Compruebo si hay archivos en la carpeta, si los hay los cargo para ver si
        % son mayores al número de valores de la muestra que deseo. Si no hay o el
        % número de valores es menor aplico el proceso de selección mediante MDA
        s = what(['DATOS\PARAMETRO_FORMA_RIPPA_99\ELEVACIONES_GAUDALETE\' fold_name '\' VAR '\' SC '\' OF]);
        files=s(1,1).mat;

        if exist(['DATOS\PARAMETRO_FORMA_RIPPA_99\ELEVACIONES_GAUDALETE\' fold_name '\' VAR '\' SC '\' OF '\' file_name '.mat'])==0 %Si no existe el archivo específico

            % Método Rippa con P(x)
            cont=1;
            progressbar('Optimización del parámetro de forma') % Init single bar
            for c=c_ini:c_paso:c_fin
                disp(num2str(c))
                % Cálculo de la Matriz A reducida (sin Px)
                A_red=zeros(M,M);
                for i=1:M
                    for j=1:M

    %                     minimo_teta_oleaje=min([abs(d(i,7)-d(j,7)) 2-abs(d(i,7)-d(j,7))]);
    %                     minimo_teta_viento=min([abs(d(i,4)-d(j,4)) 2-abs(d(i,4)-d(j,4))]);
    %                     
    %                     dist=sqrt((d(i,1)-d(j,1))^2+(d(i,2)-d(j,2))^2+(d(i,3)-d(j,3))^2+minimo_teta_viento^2+(d(i,5)-d(j,5))^2+(d(i,6)-d(j,6))^2+minimo_teta_oleaje^2+(d(i,8)-d(j,8))^2);

                        minimo_teta_oleaje=min([abs(d(i,5)-d(j,5)) 2-abs(d(i,5)-d(j,5))]);
                        minimo_teta_viento=min([abs(d(i,7)-d(j,7)) 2-abs(d(i,7)-d(j,7))]);

                        dist=sqrt((d(i,1)-d(j,1))^2+(d(i,2)-d(j,2))^2+(d(i,3)-d(j,3))^2+(d(i,4)-d(j,4))^2+minimo_teta_oleaje^2+(d(i,6)-d(j,6))^2+minimo_teta_viento^2+(d(i,8)-d(j,8))^2);
                        A_red(i,j)=exp(-((dist^2)/(2*c^2))); % A_reducida
                    end    
                end

                % En segundo lugar calculo la segunda parte de la Matriz A, metiendo
                % los valores de la muestra
                A_II=zeros(M,length([1 d(1,:)]));
                for i=1:M
                    A_II(i,:)=[1 d(i,:)];
                end

                % En tercer lugar termino de calcular la matriz A introduciendo los 0
                s=size(A_II);
                Z=zeros(s(2),s(2));

                A_1=[A_red;A_II'];
                A_2=[A_II;Z];
                A=[A_1 A_2]; %Matriz A completa

                % Calculo los coeficientes a            
                a=A\[f zeros(1,length(d(1,:))+1)]';

                % Matriz identidad
                l=length(A(:,1));
                I=eye(l);

                for k=1:M
                    x_k=A\I(:,k); 

                    f_k=[f zeros(1,length(d(1,:))+1)]';
                    f_k(k)=[];

                    A_k=A;
                    A_k(k,:)=[];
                    A_k(:,k)=[];

                    a_k=inv(A_k)*f_k; %Los coeficientes cambian para cada k
                    b_k=a-(a(k)/x_k(k))*x_k;
                    b_k(k)=[];

                    diferencia{cont}=abs(a_k-b_k); %Comprobacion de que se cumple la hipotesis
                    E_k(k)=a(k)/x_k(k);
                end

                %Calculo el error para ese valor de c
                E(cont)=sum(abs(E_k)); %L-1 norm
                cont=cont+1; 

                [warnmsg, msgid] = lastwarn;
                if strcmp(msgid,'MATLAB:nearlySingularMatrix');
                    break
                end
                warning('')

                %disp(c)

            progressbar(c/c_fin) % Update progress bar
            end    

            [~,pos]=min(E);
            c=c_vect(pos);

            save(['DATOS\PARAMETRO_FORMA_RIPPA_99\ELEVACIONES_GAUDALETE\' fold_name '\' VAR '\' SC '\' OF '\' file_name '.mat'],'c','E')

        else

            load(['DATOS\PARAMETRO_FORMA_RIPPA_99\ELEVACIONES_GAUDALETE\' fold_name '\' VAR '\' SC '\' OF '\' file_name '.mat'])

        end

        [~,pos]=min(E);
        figure(5)
        y = E./M*100;
        plot(c_vect(1:length(E)),y)
        hold on
        plot(c_vect(pos), y(pos),'ok')
        ylabel ('Error (cm)')
        xlabel('Par. Forma (c)')

    elseif  comp_descarga==0 && comp_oleaje==0 && comp_m_meteo==1 && comp_oleaje_desembocadura==1 && comp_oleaje_desembocadura_sin_viento==0 % Caso 4 Tengo Oleaje en la desembocadura con viento más marea meteorológica    

        % En el caso 4, lo tengo todo menos descarga
        f=F.MA_OD_MM.WL;

        %Creo una carpeta diferente para cada combinación de agentes en la que voy
        %a guardar los valores de f para no tener que cargarlos cada vez
        fold_name='';
        for j=1:l
           fold_name=[fold_name char(names(j)),'_']; 
        end

        %Creo la carpeta dentro de datos
        addpath('\DATOS\PARAMETRO_FORMA_RIPPA_99\ELEVACIONES_GAUDALETE')
        mkdir(['DATOS\PARAMETRO_FORMA_RIPPA_99\ELEVACIONES_GAUDALETE\' fold_name '\' VAR])
        addpath(['DATOS\PARAMETRO_FORMA_RIPPA_99\ELEVACIONES_GAUDALETE\' fold_name '\' VAR])

        %Busco si existe un fichero con M puntos de la muestra o más
        file_name=[fold_name VAR '_' 'M=' num2str(M) '_PC_' num2str(PC(1)) '_' num2str(PC(2))];

        % Compruebo si hay archivos en la carpeta, si los hay los cargo para ver si
        % son mayores al número de valores de la muestra que deseo. Si no hay o el
        % número de valores es menor aplico el proceso de selección mediante MDA
        s = what(['DATOS\PARAMETRO_FORMA_RIPPA_99\ELEVACIONES_GAUDALETE\' fold_name '\' VAR]);
        files=s(1,1).mat;

        if exist(['DATOS\PARAMETRO_FORMA_RIPPA_99\ELEVACIONES_GAUDALETE\' fold_name '\' VAR '\' file_name '.mat'])==0 %Si no existe el archivo específico

            % Método Rippa con P(x)
            cont=1;
            progressbar('Optimización del parámetro de forma') % Init single bar
            for c=c_ini:c_paso:c_fin

                % Cálculo de la Matriz A reducida (sin Px)
                A_red=zeros(M,M);
                for i=1:M
                    for j=1:M

    %                     minimo_teta_oleaje=min([abs(d(i,7)-d(j,7)) 2-abs(d(i,7)-d(j,7))]);
    %                     minimo_teta_viento=min([abs(d(i,4)-d(j,4)) 2-abs(d(i,4)-d(j,4))]);
    %                     
    %                     dist=sqrt((d(i,1)-d(j,1))^2+(d(i,2)-d(j,2))^2+(d(i,3)-d(j,3))^2+minimo_teta_viento^2+(d(i,5)-d(j,5))^2+(d(i,6)-d(j,6))^2+minimo_teta_oleaje^2+(d(i,8)-d(j,8))^2);

                        minimo_teta_oleaje=min([abs(d(i,4)-d(j,4)) 2-abs(d(i,4)-d(j,4))]);
                        minimo_teta_viento=min([abs(d(i,6)-d(j,6)) 2-abs(d(i,6)-d(j,6))]);

                        dist=sqrt((d(i,1)-d(j,1))^2+(d(i,2)-d(j,2))^2+(d(i,3)-d(j,3))^2+minimo_teta_oleaje^2+(d(i,5)-d(j,5))^2+minimo_teta_viento^2+(d(i,7)-d(j,7))^2);

                        A_red(i,j)=exp(-((dist^2)/(2*c^2))); % A_reducida
                    end    
                end

                % En segundo lugar calculo la segunda parte de la Matriz A, metiendo
                % los valores de la muestra
                A_II=zeros(M,length([1 d(1,:)]));
                for i=1:M
                    A_II(i,:)=[1 d(i,:)];
                end

                % En tercer lugar termino de calcular la matriz A introduciendo los 0
                s=size(A_II);
                Z=zeros(s(2),s(2));

                A_1=[A_red;A_II'];
                A_2=[A_II;Z];
                A=[A_1 A_2]; %Matriz A completa

                % Calculo los coeficientes a            
                a=A\[f zeros(1,length(d(1,:))+1)]';

                % Matriz identidad
                l=length(A(:,1));
                I=eye(l);

                for k=1:M
                    x_k=A\I(:,k); 

                    f_k=[f zeros(1,length(d(1,:))+1)]';
                    f_k(k)=[];

                    A_k=A;
                    A_k(k,:)=[];
                    A_k(:,k)=[];

                    a_k=inv(A_k)*f_k; %Los coeficientes cambian para cada k
                    b_k=a-(a(k)/x_k(k))*x_k;
                    b_k(k)=[];

                    diferencia{cont}=abs(a_k-b_k); %Comprobacion de que se cumple la hipotesis
                    E_k(k)=a(k)/x_k(k);
                end

                %Calculo el error para ese valor de c
                E(cont)=sum(abs(E_k)); %L-1 norm
                cont=cont+1; 

                [warnmsg, msgid] = lastwarn;
                if strcmp(msgid,'MATLAB:nearlySingularMatrix');
                    break
                end
                warning('')

                disp(c)

            progressbar(c/c_fin) % Update progress bar
            end    

            [~,pos]=min(E);
            c=c_vect(pos);

            save(['DATOS\PARAMETRO_FORMA_RIPPA_99\ELEVACIONES_GAUDALETE\' fold_name '\' VAR '\' file_name '.mat'],'c','E')

        else

            load(['DATOS\PARAMETRO_FORMA_RIPPA_99\ELEVACIONES_GAUDALETE\' fold_name '\' VAR '\' file_name '.mat'])

        end

        [~,pos]=min(E);
        figure(5)
        y = E./M*100;
        plot(c_vect(1:length(E)),y)
        hold on
        plot(c_vect(pos), y(pos),'ok')
        ylabel ('Error (cm)')
        xlabel('Par. Forma (c)')

    elseif comp_oleaje==1 && comp_m_meteo==0 && comp_oleaje_desembocadura==0 && comp_oleaje_desembocadura_sin_viento==0 % CASO 5: PROPAGACIÓN DEL RÉGIMEN MEDIO: SÓLO OLEAJE SIN VIENTO

        if VAR=='Hs'    
            f=F.Oleaje.Hs;
        elseif VAR=='Tp'
            f=F.Oleaje.Tp;
        elseif VAR=='Do'
            f=F.Oleaje.d_o;
        end        

        %Creo una carpeta diferente para cada combinación de agentes en la que voy
        %a guardar los valores de f para no tener que cargarlos cada vez
        fold_name='';
        for j=1:l
           fold_name=[fold_name char(names(j)),'_']; 
        end

        %Creo la carpeta dentro de datos
        addpath('\DATOS\PARAMETRO_FORMA_RIPPA_99\PROPAGACION_REGIMEN_MEDIO')
        mkdir(['DATOS\PARAMETRO_FORMA_RIPPA_99\PROPAGACION_REGIMEN_MEDIO\' fold_name '\' VAR])
        addpath(['DATOS\PARAMETRO_FORMA_RIPPA_99\PROPAGACION_REGIMEN_MEDIO\' fold_name '\' VAR])

        %Busco si existe un fichero con M puntos de la muestra o más
        file_name=[fold_name VAR '_' 'M=' num2str(M) '_PC=' num2str(PC)];

        % Compruebo si hay archivos en la carpeta, si los hay los cargo para ver si
        % son mayores al número de valores de la muestra que deseo. Si no hay o el
        % número de valores es menor aplico el proceso de selección mediante MDA
        s = what(['DATOS\PARAMETRO_FORMA_RIPPA_99\PROPAGACION_REGIMEN_MEDIO\' fold_name '\' VAR]);
        files=s(1,1).mat;

        if exist(['DATOS\PARAMETRO_FORMA_RIPPA_99\PROPAGACION_REGIMEN_MEDIO\' fold_name '\' VAR '\' file_name '.mat'])==0 %Si no existe el archivo específico

            % Método Rippa con P(x)
            cont=1;
            progressbar('Optimización del parámetro de forma') % Init single bar
            for c=c_ini:c_paso:c_fin

                % Cálculo de la Matriz A reducida (sin Px)
                A_red=zeros(M,M);
                for i=1:M
                    for j=1:M
                        minimo_teta_oleaje=min([abs(d(i,3)-d(j,3)) 2-abs(d(i,3)-d(j,3))]);

                        dist=sqrt((d(i,1)-d(j,1))^2+(d(i,2)-d(j,2))^2+minimo_teta_oleaje^2);
                        A_red(i,j)=exp(-((dist^2)/(2*c^2))); % A_reducida
                    end    
                end

                % En segundo lugar calculo la segunda parte de la Matriz A, metiendo
                % los valores de la muestra
                A_II=zeros(M,length([1 d(1,:)]));
                for i=1:M
                    A_II(i,:)=[1 d(i,:)];
                end

                % En tercer lugar termino de calcular la matriz A introduciendo los 0
                s=size(A_II);
                Z=zeros(s(2),s(2));

                A_1=[A_red;A_II'];
                A_2=[A_II;Z];
                A=[A_1 A_2]; %Matriz A completa

                % Calculo los coeficientes a            
                a=A\[f zeros(1,length(d(1,:))+1)]';

                % Matriz identidad
                l=length(A(:,1));
                I=eye(l);

                for k=1:M
                    x_k=A\I(:,k); 

                    f_k=[f zeros(1,length(d(1,:))+1)]';
                    f_k(k)=[];

                    A_k=A;
                    A_k(k,:)=[];
                    A_k(:,k)=[];

                    a_k=inv(A_k)*f_k; %Los coeficientes cambian para cada k
                    b_k=a-(a(k)/x_k(k))*x_k;
                    b_k(k)=[];

                    diferencia{cont}=abs(a_k-b_k); %Comprobacion de que se cumple la hipotesis
                    E_k(k)=a(k)/x_k(k);
                end

                %Calculo el error para ese valor de c
                E(cont)=sum(abs(E_k)); %L-1 norm
                cont=cont+1; 

                [warnmsg, msgid] = lastwarn;
                if strcmp(msgid,'MATLAB:nearlySingularMatrix');
                    break
                end
                warning('')

                disp(c)

            progressbar(c/c_fin) % Update progress bar    
            end                

            [~,pos]=min(E);
            c=c_vect(pos);

            save(['DATOS\PARAMETRO_FORMA_RIPPA_99\PROPAGACION_REGIMEN_MEDIO\' fold_name '\' VAR '\' file_name '.mat'],'c','E')

        else

            load(['DATOS\PARAMETRO_FORMA_RIPPA_99\PROPAGACION_REGIMEN_MEDIO\' fold_name '\' VAR '\' file_name '.mat'])

        end

        [~,pos]=min(E);
        figure(5)
        y = E./M*100;
        plot(c_vect(1:length(E)),y)
        hold on
        plot(c_vect(pos), y(pos),'ok')
        ylabel ('Error (cm)')
        xlabel('Par. Forma (c)')

    elseif comp_oleaje==1 && comp_m_meteo==1 && comp_oleaje_desembocadura==0 && comp_oleaje_desembocadura_sin_viento==0 % CASO 6: PROPAGACIÓN DEL RÉGIMEN MEDIO: OLEAJE CON VIENTO

        if VAR=='Hs'    
            f=F.Oleaje.Hs;
        elseif VAR=='Tp'
            f=F.Oleaje.Tp;
        elseif VAR=='Do'
            f=F.Oleaje.d_o;
        end


        %Creo una carpeta diferente para cada combinación de agentes en la que voy
        %a guardar los valores de f para no tener que cargarlos cada vez
        fold_name='';
        for j=1:l
           fold_name=[fold_name char(names(j)),'_']; 
        end

        %Creo la carpeta dentro de datos
        %addpath('\DATOS\PARAMETRO_FORMA_RIPPA_99\PROPAGACION_REGIMEN_MEDIO')
        if ~exist(['DATOS\PARAMETRO_FORMA_RIPPA_99\PROPAGACION_REGIMEN_MEDIO\' fold_name '\' VAR],'dir')
            mkdir(['DATOS\PARAMETRO_FORMA_RIPPA_99\PROPAGACION_REGIMEN_MEDIO\' fold_name '\' VAR])
        end
        addpath(['DATOS\PARAMETRO_FORMA_RIPPA_99\PROPAGACION_REGIMEN_MEDIO\' fold_name '\' VAR])

        %Busco si existe un fichero con M puntos de la muestra o más
        file_name=[fold_name VAR '_' 'M=' num2str(M) '_PC=' num2str(PC)];

        % Compruebo si hay archivos en la carpeta, si los hay los cargo para ver si
        % son mayores al número de valores de la muestra que deseo. Si no hay o el
        % número de valores es menor aplico el proceso de selección mediante MDA
        s = what(['DATOS\PARAMETRO_FORMA_RIPPA_99\PROPAGACION_REGIMEN_MEDIO\' fold_name '\' VAR]);
        files=s(1,1).mat;

        if exist(['DATOS\PARAMETRO_FORMA_RIPPA_99\PROPAGACION_REGIMEN_MEDIO\' fold_name '\' VAR '\' file_name '.mat'])==0 %Si no existe el archivo específico


            % Método Rippa con P(x)
            cont=1;
            progressbar('Optimización del parámetro de forma') % Init single bar
            for c=c_ini:c_paso:c_fin

                % Cálculo de la Matriz A reducida (sin Px)
                A_red=zeros(M,M);
                for i=1:M
                    for j=1:M
                        minimo_teta_oleaje=min([abs(d(i,3)-d(j,3)) 2-abs(d(i,3)-d(j,3))]);
                        minimo_teta_viento=min([abs(d(i,5)-d(j,5)) 2-abs(d(i,5)-d(j,5))]);

                        dist=sqrt((d(i,1)-d(j,1))^2+(d(i,2)-d(j,2))^2+minimo_teta_oleaje^2+(d(i,4)-d(j,4))^2+minimo_teta_viento^2);
                        A_red(i,j)=exp(-((dist^2)/(2*c^2))); % A_reducida
                    end    
                end

                % En segundo lugar calculo la segunda parte de la Matriz A, metiendo
                % los valores de la muestra
                A_II=zeros(M,length([1 d(1,:)]));
                for i=1:M
                    A_II(i,:)=[1 d(i,:)];
                end

                % En tercer lugar termino de calcular la matriz A introduciendo los 0
                s=size(A_II);
                Z=zeros(s(2),s(2));

                A_1=[A_red;A_II'];
                A_2=[A_II;Z];
                A=[A_1 A_2]; %Matriz A completa

                % Calculo los coeficientes a            
                a=A\[f zeros(1,length(d(1,:))+1)]';

                % Matriz identidad
                l=length(A(:,1));
                I=eye(l);

                for k=1:M
                    x_k=A\I(:,k); 

                    f_k=[f zeros(1,length(d(1,:))+1)]';
                    f_k(k)=[];

                    A_k=A;
                    A_k(k,:)=[];
                    A_k(:,k)=[];

                    a_k=inv(A_k)*f_k; %Los coeficientes cambian para cada k
                    b_k=a-(a(k)/x_k(k))*x_k;
                    b_k(k)=[];

                    diferencia=abs(a_k-b_k);
    %                 if diferencia>0.001
    %                     break
    %                 end
                    E_k(k)=a(k)/x_k(k);

                end

                %Calculo el error para ese valor de c
                E(cont)=sum(abs(E_k)); %L-1 norm
                cont=cont+1;

                [warnmsg, msgid] = lastwarn;
                if strcmp(msgid,'MATLAB:nearlySingularMatrix');
                    break
                end
                warning('')
                disp(c)
            progressbar(c/c_fin) % Update progress bar   
            end                

            [~,pos]=min(E);
            c=c_vect(pos);

            save(['DATOS\PARAMETRO_FORMA_RIPPA_99\PROPAGACION_REGIMEN_MEDIO\' fold_name '\' VAR '\' file_name '.mat'],'c','E')

        else

            load(['DATOS\PARAMETRO_FORMA_RIPPA_99\PROPAGACION_REGIMEN_MEDIO\' fold_name '\' VAR '\' file_name '.mat'])        

        end  

        [~,pos]=min(E);
        figure(5)
        y = E./M*100;
        plot(c_vect(1:length(E)),y)
        hold on
        plot(c_vect(pos), y(pos),'ok')
        ylabel ('Error (cm)')
        xlabel('Par. Forma (c)')
    end
    
elseif strcmp(var, 'v_x')
        % En el caso 4, lo tengo todo
        f=F.MA_Q_MM_OD.v_x;

        %Creo una carpeta diferente para cada combinación de agentes en la que voy
        %a guardar los valores de f para no tener que cargarlos cada vez
        fold_name='';
        for j=1:l
           fold_name=[fold_name char(names(j)),'_']; 
        end

        %Creo la carpeta dentro de datos
        addpath('\DATOS\PARAMETRO_FORMA_RIPPA_99\CORRIENTE_X_GAUDALETE')
        mkdir(['DATOS\PARAMETRO_FORMA_RIPPA_99\CORRIENTE_X_GAUDALETE\' fold_name '\' VAR '\' SC '\' OF])
        addpath(['DATOS\PARAMETRO_FORMA_RIPPA_99\CORRIENTE_X_GAUDALETE\' fold_name '\' VAR '\' SC '\' OF])

        %Busco si existe un fichero con M puntos de la muestra o más
        file_name=[fold_name VAR '_' SC '_' OF '_' 'M=' num2str(M) '_PC_' num2str(PC(2,1)) '_' num2str(PC(2,2))];

        % Compruebo si hay archivos en la carpeta, si los hay los cargo para ver si
        % son mayores al número de valores de la muestra que deseo. Si no hay o el
        % número de valores es menor aplico el proceso de selección mediante MDA
        s = what(['DATOS\PARAMETRO_FORMA_RIPPA_99\CORRIENTE_X_GAUDALETE\' fold_name '\' VAR '\' SC '\' OF]);
        files=s(1,1).mat;

        if exist(['DATOS\PARAMETRO_FORMA_RIPPA_99\CORRIENTE_X_GAUDALETE\' fold_name '\' VAR '\' SC '\' OF '\' file_name '.mat'])==0 %Si no existe el archivo específico

            % Método Rippa con P(x)
            cont=1;
            progressbar('Optimización del parámetro de forma') % Init single bar
            for c=c_ini:c_paso:c_fin
                disp(num2str(c))
                % Cálculo de la Matriz A reducida (sin Px)
                A_red=zeros(M,M);
                for i=1:M
                    for j=1:M

    %                     minimo_teta_oleaje=min([abs(d(i,7)-d(j,7)) 2-abs(d(i,7)-d(j,7))]);
    %                     minimo_teta_viento=min([abs(d(i,4)-d(j,4)) 2-abs(d(i,4)-d(j,4))]);
    %                     
    %                     dist=sqrt((d(i,1)-d(j,1))^2+(d(i,2)-d(j,2))^2+(d(i,3)-d(j,3))^2+minimo_teta_viento^2+(d(i,5)-d(j,5))^2+(d(i,6)-d(j,6))^2+minimo_teta_oleaje^2+(d(i,8)-d(j,8))^2);

                        minimo_teta_oleaje=min([abs(d(i,5)-d(j,5)) 2-abs(d(i,5)-d(j,5))]);
                        minimo_teta_viento=min([abs(d(i,7)-d(j,7)) 2-abs(d(i,7)-d(j,7))]);

                        dist=sqrt((d(i,1)-d(j,1))^2+(d(i,2)-d(j,2))^2+(d(i,3)-d(j,3))^2+(d(i,4)-d(j,4))^2+minimo_teta_oleaje^2+(d(i,6)-d(j,6))^2+minimo_teta_viento^2+(d(i,8)-d(j,8))^2);
                        A_red(i,j)=exp(-((dist^2)/(2*c^2))); % A_reducida
                    end    
                end

                % En segundo lugar calculo la segunda parte de la Matriz A, metiendo
                % los valores de la muestra
                A_II=zeros(M,length([1 d(1,:)]));
                for i=1:M
                    A_II(i,:)=[1 d(i,:)];
                end

                % En tercer lugar termino de calcular la matriz A introduciendo los 0
                s=size(A_II);
                Z=zeros(s(2),s(2));

                A_1=[A_red;A_II'];
                A_2=[A_II;Z];
                A=[A_1 A_2]; %Matriz A completa

                % Calculo los coeficientes a            
                a=A\[f zeros(1,length(d(1,:))+1)]';

                % Matriz identidad
                l=length(A(:,1));
                I=eye(l);

                for k=1:M
                    x_k=A\I(:,k); 

                    f_k=[f zeros(1,length(d(1,:))+1)]';
                    f_k(k)=[];

                    A_k=A;
                    A_k(k,:)=[];
                    A_k(:,k)=[];

                    a_k=inv(A_k)*f_k; %Los coeficientes cambian para cada k
                    b_k=a-(a(k)/x_k(k))*x_k;
                    b_k(k)=[];

                    diferencia{cont}=abs(a_k-b_k); %Comprobacion de que se cumple la hipotesis
                    E_k(k)=a(k)/x_k(k);
                end

                %Calculo el error para ese valor de c
                E(cont)=sum(abs(E_k)); %L-1 norm
                cont=cont+1; 

                [warnmsg, msgid] = lastwarn;
                if strcmp(msgid,'MATLAB:nearlySingularMatrix');
                    break
                end
                warning('')

                %disp(c)

            progressbar(c/c_fin) % Update progress bar
            end    

            [~,pos]=min(E);
            c=c_vect(pos);

            save(['DATOS\PARAMETRO_FORMA_RIPPA_99\CORRIENTE_X_GAUDALETE\' fold_name '\' VAR '\' SC '\' OF '\' file_name '.mat'],'c','E')

        else

            load(['DATOS\PARAMETRO_FORMA_RIPPA_99\CORRIENTE_X_GAUDALETE\' fold_name '\' VAR '\' SC '\' OF '\' file_name '.mat'])

        end

        [~,pos]=min(E);
        figure(5)
        y = E./M*100;
        plot(c_vect(1:length(E)),y)
        hold on
        plot(c_vect(pos), y(pos),'ok')
        ylabel ('Error (cm)')
        xlabel('Par. Forma (c)')
    
    
elseif strcmp(var, 'v_y')
        % En el caso 4, lo tengo todo
        f=F.MA_Q_MM_OD.v_y;

        %Creo una carpeta diferente para cada combinación de agentes en la que voy
        %a guardar los valores de f para no tener que cargarlos cada vez
        fold_name='';
        for j=1:l
           fold_name=[fold_name char(names(j)),'_']; 
        end

        %Creo la carpeta dentro de datos
        addpath('\DATOS\PARAMETRO_FORMA_RIPPA_99\CORRIENTE_Y_GAUDALETE')
        mkdir(['DATOS\PARAMETRO_FORMA_RIPPA_99\CORRIENTE_Y_GAUDALETE\' fold_name '\' VAR '\' SC '\' OF])
        addpath(['DATOS\PARAMETRO_FORMA_RIPPA_99\CORRIENTE_Y_GAUDALETE\' fold_name '\' VAR '\' SC '\' OF])

        %Busco si existe un fichero con M puntos de la muestra o más
        file_name=[fold_name VAR '_' SC '_' OF '_' 'M=' num2str(M) '_PC_' num2str(PC(2,1)) '_' num2str(PC(2,2))];

        % Compruebo si hay archivos en la carpeta, si los hay los cargo para ver si
        % son mayores al número de valores de la muestra que deseo. Si no hay o el
        % número de valores es menor aplico el proceso de selección mediante MDA
        s = what(['DATOS\PARAMETRO_FORMA_RIPPA_99\CORRIENTE_Y_GAUDALETE\' fold_name '\' VAR '\' SC '\' OF]);
        files=s(1,1).mat;

        if exist(['DATOS\PARAMETRO_FORMA_RIPPA_99\CORRIENTE_Y_GAUDALETE\' fold_name '\' VAR '\' SC '\' OF '\' file_name '.mat'])==0 %Si no existe el archivo específico

            % Método Rippa con P(x)
            cont=1;
            progressbar('Optimización del parámetro de forma') % Init single bar
            for c=c_ini:c_paso:c_fin
                disp(num2str(c))
                % Cálculo de la Matriz A reducida (sin Px)
                A_red=zeros(M,M);
                for i=1:M
                    for j=1:M

    %                     minimo_teta_oleaje=min([abs(d(i,7)-d(j,7)) 2-abs(d(i,7)-d(j,7))]);
    %                     minimo_teta_viento=min([abs(d(i,4)-d(j,4)) 2-abs(d(i,4)-d(j,4))]);
    %                     
    %                     dist=sqrt((d(i,1)-d(j,1))^2+(d(i,2)-d(j,2))^2+(d(i,3)-d(j,3))^2+minimo_teta_viento^2+(d(i,5)-d(j,5))^2+(d(i,6)-d(j,6))^2+minimo_teta_oleaje^2+(d(i,8)-d(j,8))^2);

                        minimo_teta_oleaje=min([abs(d(i,5)-d(j,5)) 2-abs(d(i,5)-d(j,5))]);
                        minimo_teta_viento=min([abs(d(i,7)-d(j,7)) 2-abs(d(i,7)-d(j,7))]);

                        dist=sqrt((d(i,1)-d(j,1))^2+(d(i,2)-d(j,2))^2+(d(i,3)-d(j,3))^2+(d(i,4)-d(j,4))^2+minimo_teta_oleaje^2+(d(i,6)-d(j,6))^2+minimo_teta_viento^2+(d(i,8)-d(j,8))^2);
                        A_red(i,j)=exp(-((dist^2)/(2*c^2))); % A_reducida
                    end    
                end

                % En segundo lugar calculo la segunda parte de la Matriz A, metiendo
                % los valores de la muestra
                A_II=zeros(M,length([1 d(1,:)]));
                for i=1:M
                    A_II(i,:)=[1 d(i,:)];
                end

                % En tercer lugar termino de calcular la matriz A introduciendo los 0
                s=size(A_II);
                Z=zeros(s(2),s(2));

                A_1=[A_red;A_II'];
                A_2=[A_II;Z];
                A=[A_1 A_2]; %Matriz A completa

                % Calculo los coeficientes a            
                a=A\[f zeros(1,length(d(1,:))+1)]';

                % Matriz identidad
                l=length(A(:,1));
                I=eye(l);

                for k=1:M
                    x_k=A\I(:,k); 

                    f_k=[f zeros(1,length(d(1,:))+1)]';
                    f_k(k)=[];

                    A_k=A;
                    A_k(k,:)=[];
                    A_k(:,k)=[];

                    a_k=inv(A_k)*f_k; %Los coeficientes cambian para cada k
                    b_k=a-(a(k)/x_k(k))*x_k;
                    b_k(k)=[];

                    diferencia{cont}=abs(a_k-b_k); %Comprobacion de que se cumple la hipotesis
                    E_k(k)=a(k)/x_k(k);
                end

                %Calculo el error para ese valor de c
                E(cont)=sum(abs(E_k)); %L-1 norm
                cont=cont+1; 

                [warnmsg, msgid] = lastwarn;
                if strcmp(msgid,'MATLAB:nearlySingularMatrix');
                    break
                end
                warning('')

                %disp(c)

            progressbar(c/c_fin) % Update progress bar
            end    

            [~,pos]=min(E);
            c=c_vect(pos);

            save(['DATOS\PARAMETRO_FORMA_RIPPA_99\CORRIENTE_Y_GAUDALETE\' fold_name '\' VAR '\' SC '\' OF '\' file_name '.mat'],'c','E')

        else

            load(['DATOS\PARAMETRO_FORMA_RIPPA_99\CORRIENTE_Y_GAUDALETE\' fold_name '\' VAR '\' SC '\' OF '\' file_name '.mat'])

        end

        [~,pos]=min(E);
        figure(5)
        y = E./M*100;
        plot(c_vect(1:length(E)),y)
        hold on
        plot(c_vect(pos), y(pos),'ok')
        ylabel ('Error (cm)')
        xlabel('Par. Forma (c)')
        
elseif strcmp(var, 'hs')
        % En el caso 4, lo tengo todo
        f=F.MA_Q_MM_OD.hs;

        %Creo una carpeta diferente para cada combinación de agentes en la que voy
        %a guardar los valores de f para no tener que cargarlos cada vez
        fold_name='';
        for j=1:l
           fold_name=[fold_name char(names(j)),'_']; 
        end

        %Creo la carpeta dentro de datos
        addpath('\DATOS\PARAMETRO_FORMA_RIPPA_99\HS')
        mkdir(['DATOS\PARAMETRO_FORMA_RIPPA_99\HS\' fold_name '\' VAR '\' SC '\' OF])
        addpath(['DATOS\PARAMETRO_FORMA_RIPPA_99\HS\' fold_name '\' VAR '\' SC '\' OF])

        %Busco si existe un fichero con M puntos de la muestra o más
        file_name=[fold_name VAR '_' SC '_' OF '_' 'M=' num2str(M) '_PC_' num2str(PC(2,1)) '_' num2str(PC(2,2))];

        % Compruebo si hay archivos en la carpeta, si los hay los cargo para ver si
        % son mayores al número de valores de la muestra que deseo. Si no hay o el
        % número de valores es menor aplico el proceso de selección mediante MDA
        s = what(['DATOS\PARAMETRO_FORMA_RIPPA_99\HS\' fold_name '\' VAR '\' SC '\' OF]);
        files=s(1,1).mat;

        if exist(['DATOS\PARAMETRO_FORMA_RIPPA_99\HS\' fold_name '\' VAR '\' SC '\' OF '\' file_name '.mat'])==0 %Si no existe el archivo específico

            % Método Rippa con P(x)
            cont=1;
            progressbar('Optimización del parámetro de forma') % Init single bar
            for c=c_ini:c_paso:c_fin
                disp(num2str(c))
                % Cálculo de la Matriz A reducida (sin Px)
                A_red=zeros(M,M);
                for i=1:M
                    for j=1:M

    %                     minimo_teta_oleaje=min([abs(d(i,7)-d(j,7)) 2-abs(d(i,7)-d(j,7))]);
    %                     minimo_teta_viento=min([abs(d(i,4)-d(j,4)) 2-abs(d(i,4)-d(j,4))]);
    %                     
    %                     dist=sqrt((d(i,1)-d(j,1))^2+(d(i,2)-d(j,2))^2+(d(i,3)-d(j,3))^2+minimo_teta_viento^2+(d(i,5)-d(j,5))^2+(d(i,6)-d(j,6))^2+minimo_teta_oleaje^2+(d(i,8)-d(j,8))^2);

                        minimo_teta_oleaje=min([abs(d(i,5)-d(j,5)) 2-abs(d(i,5)-d(j,5))]);
                        minimo_teta_viento=min([abs(d(i,7)-d(j,7)) 2-abs(d(i,7)-d(j,7))]);

                        dist=sqrt((d(i,1)-d(j,1))^2+(d(i,2)-d(j,2))^2+(d(i,3)-d(j,3))^2+(d(i,4)-d(j,4))^2+minimo_teta_oleaje^2+(d(i,6)-d(j,6))^2+minimo_teta_viento^2+(d(i,8)-d(j,8))^2);
                        A_red(i,j)=exp(-((dist^2)/(2*c^2))); % A_reducida
                    end    
                end

                % En segundo lugar calculo la segunda parte de la Matriz A, metiendo
                % los valores de la muestra
                A_II=zeros(M,length([1 d(1,:)]));
                for i=1:M
                    A_II(i,:)=[1 d(i,:)];
                end

                % En tercer lugar termino de calcular la matriz A introduciendo los 0
                s=size(A_II);
                Z=zeros(s(2),s(2));

                A_1=[A_red;A_II'];
                A_2=[A_II;Z];
                A=[A_1 A_2]; %Matriz A completa

                % Calculo los coeficientes a            
                a=A\[f zeros(1,length(d(1,:))+1)]';

                % Matriz identidad
                l=length(A(:,1));
                I=eye(l);

                for k=1:M
                    x_k=A\I(:,k); 

                    f_k=[f zeros(1,length(d(1,:))+1)]';
                    f_k(k)=[];

                    A_k=A;
                    A_k(k,:)=[];
                    A_k(:,k)=[];

                    a_k=inv(A_k)*f_k; %Los coeficientes cambian para cada k
                    b_k=a-(a(k)/x_k(k))*x_k;
                    b_k(k)=[];

                    diferencia{cont}=abs(a_k-b_k); %Comprobacion de que se cumple la hipotesis
                    E_k(k)=a(k)/x_k(k);
                end

                %Calculo el error para ese valor de c
                E(cont)=sum(abs(E_k)); %L-1 norm
                cont=cont+1; 

                [warnmsg, msgid] = lastwarn;
                if strcmp(msgid,'MATLAB:nearlySingularMatrix');
                    break
                end
                warning('')

                %disp(c)

            progressbar(c/c_fin) % Update progress bar
            end    

            [~,pos]=min(E);
            c=c_vect(pos);

            save(['DATOS\PARAMETRO_FORMA_RIPPA_99\HS\' fold_name '\' VAR '\' SC '\' OF '\' file_name '.mat'],'c','E')

        else

            load(['DATOS\PARAMETRO_FORMA_RIPPA_99\HS\' fold_name '\' VAR '\' SC '\' OF '\' file_name '.mat'])

        end

        [~,pos]=min(E);
        figure(5)
        y = E./M*100;
        plot(c_vect(1:length(E)),y)
        hold on
        plot(c_vect(pos), y(pos),'ok')
        ylabel ('Error (cm)')
        xlabel('Par. Forma (c)')
        
elseif strcmp(var, 'tp')
        % En el caso 4, lo tengo todo
        f=F.MA_Q_MM_OD.tp;

        %Creo una carpeta diferente para cada combinación de agentes en la que voy
        %a guardar los valores de f para no tener que cargarlos cada vez
        fold_name='';
        for j=1:l
           fold_name=[fold_name char(names(j)),'_']; 
        end

        %Creo la carpeta dentro de datos
        addpath('\DATOS\PARAMETRO_FORMA_RIPPA_99\TP')
        mkdir(['DATOS\PARAMETRO_FORMA_RIPPA_99\TP\' fold_name '\' VAR '\' SC '\' OF])
        addpath(['DATOS\PARAMETRO_FORMA_RIPPA_99\TP\' fold_name '\' VAR '\' SC '\' OF])

        %Busco si existe un fichero con M puntos de la muestra o más
        file_name=[fold_name VAR '_' SC '_' OF '_' 'M=' num2str(M) '_PC_' num2str(PC(2,1)) '_' num2str(PC(2,2))];

        % Compruebo si hay archivos en la carpeta, si los hay los cargo para ver si
        % son mayores al número de valores de la muestra que deseo. Si no hay o el
        % número de valores es menor aplico el proceso de selección mediante MDA
        s = what(['DATOS\PARAMETRO_FORMA_RIPPA_99\TP\' fold_name '\' VAR '\' SC '\' OF]);
        files=s(1,1).mat;

        if exist(['DATOS\PARAMETRO_FORMA_RIPPA_99\TP\' fold_name '\' VAR '\' SC '\' OF '\' file_name '.mat'])==0 %Si no existe el archivo específico

            % Método Rippa con P(x)
            cont=1;
            progressbar('Optimización del parámetro de forma') % Init single bar
            for c=c_ini:c_paso:c_fin
                disp(num2str(c))
                % Cálculo de la Matriz A reducida (sin Px)
                A_red=zeros(M,M);
                for i=1:M
                    for j=1:M

    %                     minimo_teta_oleaje=min([abs(d(i,7)-d(j,7)) 2-abs(d(i,7)-d(j,7))]);
    %                     minimo_teta_viento=min([abs(d(i,4)-d(j,4)) 2-abs(d(i,4)-d(j,4))]);
    %                     
    %                     dist=sqrt((d(i,1)-d(j,1))^2+(d(i,2)-d(j,2))^2+(d(i,3)-d(j,3))^2+minimo_teta_viento^2+(d(i,5)-d(j,5))^2+(d(i,6)-d(j,6))^2+minimo_teta_oleaje^2+(d(i,8)-d(j,8))^2);

                        minimo_teta_oleaje=min([abs(d(i,5)-d(j,5)) 2-abs(d(i,5)-d(j,5))]);
                        minimo_teta_viento=min([abs(d(i,7)-d(j,7)) 2-abs(d(i,7)-d(j,7))]);

                        dist=sqrt((d(i,1)-d(j,1))^2+(d(i,2)-d(j,2))^2+(d(i,3)-d(j,3))^2+(d(i,4)-d(j,4))^2+minimo_teta_oleaje^2+(d(i,6)-d(j,6))^2+minimo_teta_viento^2+(d(i,8)-d(j,8))^2);
                        A_red(i,j)=exp(-((dist^2)/(2*c^2))); % A_reducida
                    end    
                end

                % En segundo lugar calculo la segunda parte de la Matriz A, metiendo
                % los valores de la muestra
                A_II=zeros(M,length([1 d(1,:)]));
                for i=1:M
                    A_II(i,:)=[1 d(i,:)];
                end

                % En tercer lugar termino de calcular la matriz A introduciendo los 0
                s=size(A_II);
                Z=zeros(s(2),s(2));

                A_1=[A_red;A_II'];
                A_2=[A_II;Z];
                A=[A_1 A_2]; %Matriz A completa

                % Calculo los coeficientes a            
                a=A\[f zeros(1,length(d(1,:))+1)]';

                % Matriz identidad
                l=length(A(:,1));
                I=eye(l);

                for k=1:M
                    x_k=A\I(:,k); 

                    f_k=[f zeros(1,length(d(1,:))+1)]';
                    f_k(k)=[];

                    A_k=A;
                    A_k(k,:)=[];
                    A_k(:,k)=[];

                    a_k=inv(A_k)*f_k; %Los coeficientes cambian para cada k
                    b_k=a-(a(k)/x_k(k))*x_k;
                    b_k(k)=[];

                    diferencia{cont}=abs(a_k-b_k); %Comprobacion de que se cumple la hipotesis
                    E_k(k)=a(k)/x_k(k);
                end

                %Calculo el error para ese valor de c
                E(cont)=sum(abs(E_k)); %L-1 norm
                cont=cont+1; 

                [warnmsg, msgid] = lastwarn;
                if strcmp(msgid,'MATLAB:nearlySingularMatrix');
                    break
                end
                warning('')

                %disp(c)

            progressbar(c/c_fin) % Update progress bar
            end    

            [~,pos]=min(E);
            c=c_vect(pos);

            save(['DATOS\PARAMETRO_FORMA_RIPPA_99\TP\' fold_name '\' VAR '\' SC '\' OF '\' file_name '.mat'],'c','E')

        else

            load(['DATOS\PARAMETRO_FORMA_RIPPA_99\TP\' fold_name '\' VAR '\' SC '\' OF '\' file_name '.mat'])

        end

        [~,pos]=min(E);
        figure(5)
        y = E./M*100;
        plot(c_vect(1:length(E)),y)
        hold on
        plot(c_vect(pos), y(pos),'ok')
        ylabel ('Error (cm)')
        xlabel('Par. Forma (c)')
        
elseif strcmp(var, 'do')
        % En el caso 4, lo tengo todo
        f=F.MA_Q_MM_OD.do;

        %Creo una carpeta diferente para cada combinación de agentes en la que voy
        %a guardar los valores de f para no tener que cargarlos cada vez
        fold_name='';
        for j=1:l
           fold_name=[fold_name char(names(j)),'_']; 
        end

        %Creo la carpeta dentro de datos
        addpath('\DATOS\PARAMETRO_FORMA_RIPPA_99\DO')
        mkdir(['DATOS\PARAMETRO_FORMA_RIPPA_99\DO\' fold_name '\' VAR '\' SC '\' OF])
        addpath(['DATOS\PARAMETRO_FORMA_RIPPA_99\DO\' fold_name '\' VAR '\' SC '\' OF])

        %Busco si existe un fichero con M puntos de la muestra o más
        file_name=[fold_name VAR '_' SC '_' OF '_' 'M=' num2str(M) '_PC_' num2str(PC(2,1)) '_' num2str(PC(2,2))];

        % Compruebo si hay archivos en la carpeta, si los hay los cargo para ver si
        % son mayores al número de valores de la muestra que deseo. Si no hay o el
        % número de valores es menor aplico el proceso de selección mediante MDA
        s = what(['DATOS\PARAMETRO_FORMA_RIPPA_99\DO\' fold_name '\' VAR '\' SC '\' OF]);
        files=s(1,1).mat;

        if exist(['DATOS\PARAMETRO_FORMA_RIPPA_99\DO\' fold_name '\' VAR '\' SC '\' OF '\' file_name '.mat'])==0 %Si no existe el archivo específico

            % Método Rippa con P(x)
            cont=1;
            progressbar('Optimización del parámetro de forma') % Init single bar
            for c=c_ini:c_paso:c_fin
                disp(num2str(c))
                % Cálculo de la Matriz A reducida (sin Px)
                A_red=zeros(M,M);
                for i=1:M
                    for j=1:M

    %                     minimo_teta_oleaje=min([abs(d(i,7)-d(j,7)) 2-abs(d(i,7)-d(j,7))]);
    %                     minimo_teta_viento=min([abs(d(i,4)-d(j,4)) 2-abs(d(i,4)-d(j,4))]);
    %                     
    %                     dist=sqrt((d(i,1)-d(j,1))^2+(d(i,2)-d(j,2))^2+(d(i,3)-d(j,3))^2+minimo_teta_viento^2+(d(i,5)-d(j,5))^2+(d(i,6)-d(j,6))^2+minimo_teta_oleaje^2+(d(i,8)-d(j,8))^2);

                        minimo_teta_oleaje=min([abs(d(i,5)-d(j,5)) 2-abs(d(i,5)-d(j,5))]);
                        minimo_teta_viento=min([abs(d(i,7)-d(j,7)) 2-abs(d(i,7)-d(j,7))]);

                        dist=sqrt((d(i,1)-d(j,1))^2+(d(i,2)-d(j,2))^2+(d(i,3)-d(j,3))^2+(d(i,4)-d(j,4))^2+minimo_teta_oleaje^2+(d(i,6)-d(j,6))^2+minimo_teta_viento^2+(d(i,8)-d(j,8))^2);
                        A_red(i,j)=exp(-((dist^2)/(2*c^2))); % A_reducida
                    end    
                end

                % En segundo lugar calculo la segunda parte de la Matriz A, metiendo
                % los valores de la muestra
                A_II=zeros(M,length([1 d(1,:)]));
                for i=1:M
                    A_II(i,:)=[1 d(i,:)];
                end

                % En tercer lugar termino de calcular la matriz A introduciendo los 0
                s=size(A_II);
                Z=zeros(s(2),s(2));

                A_1=[A_red;A_II'];
                A_2=[A_II;Z];
                A=[A_1 A_2]; %Matriz A completa

                % Calculo los coeficientes a            
                a=A\[f zeros(1,length(d(1,:))+1)]';

                % Matriz identidad
                l=length(A(:,1));
                I=eye(l);

                for k=1:M
                    x_k=A\I(:,k); 

                    f_k=[f zeros(1,length(d(1,:))+1)]';
                    f_k(k)=[];

                    A_k=A;
                    A_k(k,:)=[];
                    A_k(:,k)=[];

                    a_k=inv(A_k)*f_k; %Los coeficientes cambian para cada k
                    b_k=a-(a(k)/x_k(k))*x_k;
                    b_k(k)=[];

                    diferencia{cont}=abs(a_k-b_k); %Comprobacion de que se cumple la hipotesis
                    E_k(k)=a(k)/x_k(k);
                end

                %Calculo el error para ese valor de c
                E(cont)=sum(abs(E_k)); %L-1 norm
                cont=cont+1; 

                [warnmsg, msgid] = lastwarn;
                if strcmp(msgid,'MATLAB:nearlySingularMatrix');
                    break
                end
                warning('')

                %disp(c)

            progressbar(c/c_fin) % Update progress bar
            end    

            [~,pos]=min(E);
            c=c_vect(pos);

            save(['DATOS\PARAMETRO_FORMA_RIPPA_99\DO\' fold_name '\' VAR '\' SC '\' OF '\' file_name '.mat'],'c','E')

        else

            load(['DATOS\PARAMETRO_FORMA_RIPPA_99\DO\' fold_name '\' VAR '\' SC '\' OF '\' file_name '.mat'])

        end

        [~,pos]=min(E);
        figure(5)
        y = E./M*100;
        plot(c_vect(1:length(E)),y)
        hold on
        plot(c_vect(pos), y(pos),'ok')
        ylabel ('Error (cm)')
        xlabel('Par. Forma (c)')
    
    
end
       
    
    
end