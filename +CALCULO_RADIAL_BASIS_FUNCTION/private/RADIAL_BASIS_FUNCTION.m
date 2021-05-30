function S=RADIAL_BASIS_FUNCTION(Forzamiento,c,F,M,PC,VAR,d,X,Forz_input, sim, SC, OF, var)

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
            addpath('\DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE')
            mkdir(['DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE\' fold_name '\' VAR])
            addpath(['DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE\' fold_name '\' VAR])

            %Busco si existe un fichero con M puntos de la muestra o más
            file_name=[fold_name VAR '_' 'M=' num2str(M) '_PC_' num2str(PC(2, 1)) '_' num2str(PC(2, 2)) '_sim_' num2str(sim,'%04.f')];

            % Compruebo si hay archivos en la carpeta, si los hay los cargo para ver si
            % son mayores al número de valores de la muestra que deseo. Si no hay o el
            % número de valores es menor aplico el proceso de selección mediante MDA
            s = what(['DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE\' fold_name '\' VAR]);
            files=s(1,1).mat;

            if exist(['DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE\' fold_name '\' VAR '\' file_name '.mat'])==0 %Si no existe el archivo específico
                % En primer lugar calculo la primera parte de la matriz A (A_reducida)
                for i=1:M
                    for j=1:M
                        dist=sqrt((d(i,1)-d(j,1))^2);
                        A_red(i,j)=exp(-((dist^2)/(2*c^2))); % A_reducida
                    end    
                end

                % En segundo lugar calculo la segunda parte de la Matriz A, metiendo
                % los valores de la muestra
                for i=1:M
                    A_II(i,:)=[1 d(i,:)];
                end

                % En tercer lugar termino de calcular la matriz A introduciendo los 0
                s=size(A_II);
                Z=zeros(s(2),s(2));

                A_1=[A_red;A_II'];
                A_2=[A_II;Z];
                A=[A_1 A_2];

                % Calculo los coeficientes a
                a=inv(A)*[f zeros(1,length(d(1,:))+1)]';

    %             % Calculo la RBF en cada punto
    %             progressbar('Interpolación mediante RBF') % Init single bar
    %             for k=1:length(X(:,1))    
    %                 for j=1:M
    %                    dist=sqrt((X(k,1)-d(j,1))^2); 
    %                    elem(j)= a(j)*exp(-((dist^2)/(2*c^2))); 
    %                 end    
    % 
    %                 S(k)=a(M+1)+a(M+2)*X(k,1)+sum(elem);   %normalizada
    %                 progressbar(k/length(X(:,1))) % Update progress bar
    %             end

                % Modo vectorial II
                % Calculo la RBF en cada punto
                X_1 = X(1:round(length(X)/2), :);
                X_2 = X(round(length(X)/2) + 1:end, :);

                dist= pdist2(X_1,d);
                elem2 = a(1:M).*exp(-((dist.^2)/(2*c^2)))'; 
                S_1=a(M+1)+a(M+2)*X_1(:,1)+sum(elem2)';   %normalizada
                clear dist elem2

                dist= pdist2(X_2,d);
                elem2 = a(1:M).*exp(-((dist.^2)/(2*c^2)))'; 
                S_2=a(M+1)+a(M+2)*X_2(:,1)+sum(elem2)';   %normalizada
                clear dist elem2

                S = [S_1; S_2];

               save(['DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE\' fold_name '\' VAR '\' file_name '.mat'],'S')

            else

                load(['DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE\' fold_name '\' VAR '\' file_name '.mat'])     

            end 
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
            addpath('\DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE')
            mkdir(['DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE\' fold_name '\' VAR])
            addpath(['DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE\' fold_name '\' VAR])

            %Busco si existe un fichero con M puntos de la muestra o más
            file_name=[fold_name VAR '_' 'M=' num2str(M) '_PC_' num2str(PC(1)) '_' num2str(PC(2)) '_sim_' num2str(sim,'%04.f')];

            % Compruebo si hay archivos en la carpeta, si los hay los cargo para ver si
            % son mayores al número de valores de la muestra que deseo. Si no hay o el
            % número de valores es menor aplico el proceso de selección mediante MDA
            s = what(['DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE\' fold_name '\' VAR]);
            files=s(1,1).mat;

            if exist(['DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE\' fold_name '\' VAR '\' file_name '.mat'])==0 %Si no existe el archivo específico
                % En primer lugar calculo la primera parte de la matriz A (A_reducida)
                for i=1:M
                    for j=1:M
                        dist=sqrt((d(i,1)-d(j,1))^2);
                        A_red(i,j)=exp(-((dist^2)/(2*c^2))); % A_reducida
                    end    
                end

                % En segundo lugar calculo la segunda parte de la Matriz A, metiendo
                % los valores de la muestra
                for i=1:M
                    A_II(i,:)=[1 d(i,:)];
                end

                % En tercer lugar termino de calcular la matriz A introduciendo los 0
                s=size(A_II);
                Z=zeros(s(2),s(2));

                A_1=[A_red;A_II'];
                A_2=[A_II;Z];
                A=[A_1 A_2];

                % Calculo los coeficientes a
                a=inv(A)*[f zeros(1,length(d(1,:))+1)]';

    %             % Calculo la RBF en cada punto
    %             progressbar('Interpolación mediante RBF') % Init single bar
    %             for k=1:length(X(:,1))    
    %                 for j=1:M
    %                    dist=sqrt((X(k,1)-d(j,1))^2); 
    %                    elem(j)= a(j)*exp(-((dist^2)/(2*c^2))); 
    %                 end    
    % 
    %                 S(k)=a(M+1)+a(M+2)*X(k,1)+sum(elem);   %normalizada
    %                 progressbar(k/length(X(:,1))) % Update progress bar
    %             end

                % Modo vectorial II
                % Calculo la RBF en cada punto
                X_1 = X(1:round(length(X)/2), :);
                X_2 = X(round(length(X)/2) + 1:end, :);

                dist= pdist2(X_1,d);
                elem2 = a(1:M).*exp(-((dist.^2)/(2*c^2)))'; 
                S_1=a(M+1)+a(M+2)*X_1(:,1)+sum(elem2)';   %normalizada
                clear dist elem2

                dist= pdist2(X_2,d);
                elem2 = a(1:M).*exp(-((dist.^2)/(2*c^2)))'; 
                S_2=a(M+1)+a(M+2)*X_2(:,1)+sum(elem2)';   %normalizada
                clear dist elem2

                S = [S_1; S_2];

               save(['DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE\' fold_name '\' VAR '\' file_name '.mat'],'S')

            else

                load(['DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE\' fold_name '\' VAR '\' file_name '.mat'])     

            end 
            

        elseif Forz_input.MA_DESPLAZ==1 && Forz_input.Q==0 %Caso 1 Opción 1: Tengo sólo MA_DESPLAZ
            f=F.MA_DESPLAZ.WL;

            %Creo una carpeta diferente para cada combinación de agentes en la que voy
            %a guardar los valores de f para no tener que cargarlos cada vez
            fold_name='';
            for j=1:1
               fold_name=[fold_name char(names(j)),'_']; 
            end

            %Creo la carpeta dentro de datos
            addpath('\DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE')
            mkdir(['DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE\' fold_name '\' VAR])
            addpath(['DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE\' fold_name '\' VAR])

            %Busco si existe un fichero con M puntos de la muestra o más
            file_name=[fold_name VAR '_' 'M=' num2str(M) '_PC_' num2str(PC(1)) '_' num2str(PC(2))];

            % Compruebo si hay archivos en la carpeta, si los hay los cargo para ver si
            % son mayores al número de valores de la muestra que deseo. Si no hay o el
            % número de valores es menor aplico el proceso de selección mediante MDA
            s = what(['DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE\' fold_name '\' VAR]);
            files=s(1,1).mat;

            if exist(['DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE\' fold_name '\' VAR '\' file_name '.mat'])==0 %Si no existe el archivo específico
                % En primer lugar calculo la primera parte de la matriz A (A_reducida)
                for i=1:M
                    for j=1:M
                        dist=sqrt((d(i,1)-d(j,1))^2);
                        A_red(i,j)=exp(-((dist^2)/(2*c^2))); % A_reducida
                    end    
                end

                % En segundo lugar calculo la segunda parte de la Matriz A, metiendo
                % los valores de la muestra
                for i=1:M
                    A_II(i,:)=[1 d(i,:)];
                end

                % En tercer lugar termino de calcular la matriz A introduciendo los 0
                s=size(A_II);
                Z=zeros(s(2),s(2));

                A_1=[A_red;A_II'];
                A_2=[A_II;Z];
                A=[A_1 A_2];

                % Calculo los coeficientes a
                a=inv(A)*[f zeros(1,length(d(1,:))+1)]';

                % Calculo la RBF en cada punto
                progressbar('Interpolación mediante RBF') % Init single bar
                for k=1:length(X(:,1))    
                    for j=1:M
                       dist=sqrt((X(k,1)-d(j,1))^2); 
                       elem(j)= a(j)*exp(-((dist^2)/(2*c^2))); 
                    end    

                    S(k)=a(M+1)+a(M+2)*X(k,1)+sum(elem);   %normalizada
                    progressbar(k/length(X(:,1))) % Update progress bar
                end


                save(['DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE\' fold_name '\' VAR '\' file_name '.mat'],'S')

            else

                load(['DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE\' fold_name '\' VAR '\' file_name '.mat'])     

            end 



    %         figure
    %         sub(1)=subplot(2,1,1);
    %         plot(Forzamiento.MA.ma,'k')
    %         grid on
    %         sub(2)=subplot(2,1,2);
    %         plot(S,'r')
    %         grid on
    %         linkaxes([sub],'x')

        elseif  Forz_input.MA==0 && Forz_input.Q==1 %Caso 1 Opción 2: Tengo sólo Q

            f=F.Q.WL;        
            %Creo una carpeta diferente para cada combinación de agentes en la que voy
            %a guardar los valores de f para no tener que cargarlos cada vez
            fold_name='';
            for j=1:l
               fold_name=[fold_name char(names(j)),'_']; 
            end

            %Creo la carpeta dentro de datos
            addpath('\DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE')
            mkdir(['DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE\' fold_name '\' VAR])
            addpath(['DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE\' fold_name '\' VAR])

            %Busco si existe un fichero con M puntos de la muestra o más
            file_name=[fold_name VAR '_' 'M=' num2str(M) '_PC_' num2str(PC(1)) '_' num2str(PC(2)) '_sim_' num2str(sim,'%04.f')];

            % Compruebo si hay archivos en la carpeta, si los hay los cargo para ver si
            % son mayores al número de valores de la muestra que deseo. Si no hay o el
            % número de valores es menor aplico el proceso de selección mediante MDA
            s = what(['DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE\' fold_name '\' VAR]);
            files=s(1,1).mat;

            if exist(['DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE\' fold_name '\' VAR '\' file_name '.mat'])==0 %Si no existe el archivo específico
                % En primer lugar calculo la primera parte de la matriz A (A_reducida)
                for i=1:M
                    for j=1:M
                        dist=sqrt((d(i,1)-d(j,1))^2);
                        A_red(i,j)=exp(-((dist^2)/(2*c^2))); % A_reducida
                    end    
                end

                % En segundo lugar calculo la segunda parte de la Matriz A, metiendo
                % los valores de la muestra
                for i=1:M
                    A_II(i,:)=[1 d(i,:)];
                end

                % En tercer lugar termino de calcular la matriz A introduciendo los 0
                s=size(A_II);
                Z=zeros(s(2),s(2));

                A_1=[A_red;A_II'];
                A_2=[A_II;Z];
                A=[A_1 A_2];

                % Calculo los coeficientes a
                a=inv(A)*[f zeros(1,length(d(1,:))+1)]';

                % Modo bucle anidado
                % Calculo la RBF en cada punto
    %             progressbar('Interpolación mediante RBF') % Init single bar
    %             for k=1:length(X(:,1))    
    %                 for j=1:M
    %                    dist=sqrt((X(k,1)-d(j,1))^2); 
    %                    elem(j)= a(j)*exp(-((dist^2)/(2*c^2))); 
    %                 end    
    % 
    %                 S(k)=a(M+1)+a(M+2)*X(k,1)+sum(elem);   %normalizada 
    %                 progressbar(k/length(X(:,1))) % Update progress bar
    %             end

                % Modo vectorial II
                % Calculo la RBF en cada punto
                X_1 = X(1:round(length(X)/2), :);
                X_2 = X(round(length(X)/2) + 1:end, :);

                dist= pdist2(X_1,d);
                elem2 = a(1:M).*exp(-((dist.^2)/(2*c^2)))'; 
                S_1=a(M+1)+a(M+2)*X_1(:,1)+sum(elem2)';   %normalizada
                clear dist elem2

                dist= pdist2(X_2,d);
                elem2 = a(1:M).*exp(-((dist.^2)/(2*c^2)))'; 
                S_2=a(M+1)+a(M+2)*X_2(:,1)+sum(elem2)';   %normalizada
                clear dist elem2

                S = [S_1; S_2];

                save(['DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE\' fold_name '\' VAR '\' file_name '.mat'],'S')

            else

                load(['DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE\' fold_name '\' VAR '\' file_name '.mat'])     

            end 

    %         figure
    %         sub(1)=subplot(2,1,1);
    %         plot(Forzamiento.Q.q,'k')
    %         grid on
    %         sub(2)=subplot(2,1,2);
    %         plot(S,'r')
    %         grid on
    %         linkaxes([sub],'x')
        end

    elseif  comp_oleaje==0 && comp_m_meteo==1 && comp_oleaje_desembocadura==0 && comp_oleaje_desembocadura_sin_viento==0 % Caso 2 Sólo tengo m.meteo

            f=F.MM.WL;        
            %Creo una carpeta diferente para cada combinación de agentes en la que voy
            %a guardar los valores de f para no tener que cargarlos cada vez
            fold_name='';
            for j=1:l
               fold_name=[fold_name char(names(j)),'_']; 
            end

            %Creo la carpeta dentro de datos
            addpath('\DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE')
            mkdir(['DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE\' fold_name '\' VAR])
            addpath(['DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE\' fold_name '\' VAR])

            %Busco si existe un fichero con M puntos de la muestra o más
            file_name=[fold_name VAR '_' 'M=' num2str(M) '_PC_' num2str(PC(1)) '_' num2str(PC(2))];

            % Compruebo si hay archivos en la carpeta, si los hay los cargo para ver si
            % son mayores al número de valores de la muestra que deseo. Si no hay o el
            % número de valores es menor aplico el proceso de selección mediante MDA
            s = what(['DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE\' fold_name '\' VAR]);
            files=s(1,1).mat;

            if exist(['DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE\' fold_name '\' VAR '\' file_name '.mat'])==0 %Si no existe el archivo específico
                % En primer lugar calculo la primera parte de la matriz A (A_reducida)
                for i=1:M
                    for j=1:M
                        minimo_teta_viento=min([abs(d(i,2)-d(j,2)) 2-abs(d(i,2)-d(j,2))]);

                        dist=sqrt((d(i,1)-d(j,1))^2+minimo_teta_viento^2+(d(i,3)-d(j,3))^2);
                        A_red(i,j)=exp(-((dist^2)/(2*c^2))); % A_reducida
                    end    
                end

                % En segundo lugar calculo la segunda parte de la Matriz A, metiendo
                % los valores de la muestra
                for i=1:M
                    A_II(i,:)=[1 d(i,:)];
                end

                % En tercer lugar termino de calcular la matriz A introduciendo los 0
                s=size(A_II);
                Z=zeros(s(2),s(2));

                A_1=[A_red;A_II'];
                A_2=[A_II;Z];
                A=[A_1 A_2];

                % Calculo los coeficientes a
                a=inv(A)*[f zeros(1,length(d(1,:))+1)]';

                % Calculo la RBF en cada punto
                progressbar('Interpolación mediante RBF') % Init single bar
                for k=1:length(X(:,1))    
                    for j=1:M
                       minimo_teta_viento=min([abs(X(k,2)-d(j,2)) 2-abs(X(k,2)-d(j,2))]);

                       dist=sqrt((X(k,1)-d(j,1))^2+minimo_teta_viento^2+(X(k,3)-d(j,3))^2); 
                       elem(j)= a(j)*exp(-((dist^2)/(2*c^2))); 
                    end    

                    S(k)=a(M+1)+a(M+2)*X(k,1)+a(M+3)*X(k,2)+a(M+4)*X(k,3)+sum(elem);   %normalizada
                    progressbar(k/length(X(:,1))) % Update progress bar
                end


                save(['DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE\' fold_name '\' VAR '\' file_name '.mat'],'S')

            else

                load(['DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE\' fold_name '\' VAR '\' file_name '.mat'])     

            end 

    %         figure
    %         sub(1)=subplot(3,1,1);
    %         plot(Forzamiento.MM.vv,'g')
    %         grid on
    %         sub(2)=subplot(3,1,2);
    %         plot(Forzamiento.MM.d_v,'k')
    %         grid on
    %         sub(3)=subplot(3,1,3);
    %         plot(S,'r')
    %         grid on
    %         linkaxes([sub],'x')


    elseif  comp_oleaje==0 && comp_m_meteo==0 && comp_oleaje_desembocadura==0 && comp_oleaje_desembocadura_sin_viento==1 % Caso 3 Sólo tengo oleaje en la desembocadura sin viento

            f=F.ODSV.WL;        
            %Creo una carpeta diferente para cada combinación de agentes en la que voy
            %a guardar los valores de f para no tener que cargarlos cada vez
            fold_name='';
            for j=1:l
               fold_name=[fold_name char(names(j)),'_']; 
            end

            %Creo la carpeta dentro de datos
            addpath('\DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE')
            mkdir(['DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE\' fold_name '\' VAR])
            addpath(['DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE\' fold_name '\' VAR])

            %Busco si existe un fichero con M puntos de la muestra o más
            file_name=[fold_name VAR '_' 'M=' num2str(M) '_PC_' num2str(PC(1)) '_' num2str(PC(2))];

            % Compruebo si hay archivos en la carpeta, si los hay los cargo para ver si
            % son mayores al número de valores de la muestra que deseo. Si no hay o el
            % número de valores es menor aplico el proceso de selección mediante MDA
            s = what(['DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE\' fold_name '\' VAR]);
            files=s(1,1).mat;

            if exist(['DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE\' fold_name '\' VAR '\' file_name '.mat'])==0 %Si no existe el archivo específico
                % En primer lugar calculo la primera parte de la matriz A (A_reducida)
                for i=1:M
                    for j=1:M
                        minimo_teta_oleaje=min([abs(d(i,3)-d(j,3)) 2-abs(d(i,3)-d(j,3))]);

                        dist=sqrt((d(i,1)-d(j,1))^2+(d(i,2)-d(j,2))^2+minimo_teta_oleaje^2);
                        A_red(i,j)=exp(-((dist^2)/(2*c^2))); % A_reducida
                    end    
                end

                % En segundo lugar calculo la segunda parte de la Matriz A, metiendo
                % los valores de la muestra
                for i=1:M
                    A_II(i,:)=[1 d(i,:)];
                end

                % En tercer lugar termino de calcular la matriz A introduciendo los 0
                s=size(A_II);
                Z=zeros(s(2),s(2));

                A_1=[A_red;A_II'];
                A_2=[A_II;Z];
                A=[A_1 A_2];

                % Calculo los coeficientes a
                a=inv(A)*[f zeros(1,length(d(1,:))+1)]';

                % Calculo la RBF en cada punto
                progressbar('Interpolación mediante RBF') % Init single bar
                for k=1:length(X(:,1))    
                    for j=1:M
                       minimo_teta_oleaje=min([abs(X(k,3)-d(j,3)) 2-abs(X(k,3)-d(j,3))]);

                       dist=sqrt((X(k,1)-d(j,1))^2+(X(k,2)-d(j,2))^2+minimo_teta_oleaje^2); 
                       elem(j)= a(j)*exp(-((dist^2)/(2*c^2))); 
                    end    

                    S(k)=a(M+1)+a(M+2)*X(k,1)+a(M+3)*X(k,2)+a(M+4)*X(k,3)+sum(elem);   %normalizada 
                    progressbar(k/length(X(:,1))) % Update progress bar
                end


                save(['DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE\' fold_name '\' VAR '\' file_name '.mat'],'S')

            else

                load(['DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE\' fold_name '\' VAR '\' file_name '.mat'])     

            end 

    %         figure
    %         sub(1)=subplot(3,1,1);
    %         plot(Forzamiento.ODSV.Hs,'g')
    %         grid on
    %         sub(2)=subplot(3,1,2);
    %         plot(Forzamiento.ODSV.Tp,'k')
    %         grid on
    %         sub(3)=subplot(3,1,3);
    %         plot(S,'r')
    %         grid on
    %         linkaxes([sub],'x')

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
            addpath('\DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE')
            mkdir(['DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE\' fold_name '\' VAR])
            addpath(['DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE\' fold_name '\' VAR])

            %Busco si existe un fichero con M puntos de la muestra o más
            file_name=[fold_name VAR '_' 'M=' num2str(M) '_PC_' num2str(PC(1)) '_' num2str(PC(2)) '_sim_' num2str(sim,'%04.f')];

            % Compruebo si hay archivos en la carpeta, si los hay los cargo para ver si
            % son mayores al número de valores de la muestra que deseo. Si no hay o el
            % número de valores es menor aplico el proceso de selección mediante MDA
            s = what(['DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE\' fold_name '\' VAR]);
            files=s(1,1).mat;

            if exist(['DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE\' fold_name '\' VAR '\' file_name '.mat'])==0 %Si no existe el archivo específico
                % En primer lugar calculo la primera parte de la matriz A (A_reducida)
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
                for i=1:M
                    A_II(i,:)=[1 d(i,:)];
                end

                % En tercer lugar termino de calcular la matriz A introduciendo los 0
                s=size(A_II);
                Z=zeros(s(2),s(2));

                A_1=[A_red;A_II'];
                A_2=[A_II;Z];
                A=[A_1 A_2];

                % Calculo los coeficientes a
                a=inv(A)*[f zeros(1,length(d(1,:))+1)]';

    %             % Calculo la RBF en cada punto
    %             progressbar('Interpolación mediante RBF') % Init single bar
    %             for k=1:length(X(:,1))    
    %                 for j=1:M
    %                    minimo_teta_oleaje=min([abs(X(k,3)-d(j,3)) 2-abs(X(k,3)-d(j,3))]);
    %                    minimo_teta_viento=min([abs(X(k,5)-d(j,5)) 2-abs(X(k,5)-d(j,5))]);
    %                
    %                    dist=sqrt((X(k,1)-d(j,1))^2+(X(k,2)-d(j,2))^2+minimo_teta_oleaje^2+(X(k,4)-d(j,4))^2+minimo_teta_viento^2+(X(k,6)-d(j,6))^2); 
    %                    elem(j)= a(j)*exp(-((dist^2)/(2*c^2))); 
    %                 end    
    % 
    %                 S(k)=a(M+1)+a(M+2)*X(k,1)+a(M+3)*X(k,2)+a(M+4)*X(k,3)+a(M+5)*X(k,4)+a(M+6)*X(k,5)+a(M+7)*X(k,6)+sum(elem);   %normalizada 
    %                 progressbar(k/length(X(:,1))) % Update progress bar
    %             end

                % Modo vectorial II
                % Division de X
                X_1 = X(1:round(length(X)/2), :);
                X_2 = X(round(length(X)/2) + 1:end, :);

                dist= pdist2(X_1,d);
                elem = a(1:M).*exp(-((dist.^2)/(2*c^2)))'; 
                S_1 = a(M+1)+a(M+2)*X_1(:,1)+a(M+3)*X_1(:,2)+a(M+4)*X_1(:,3)+a(M+5)*X_1(:,4)+a(M+6)*X_1(:,5)+a(M+7)*X_1(:,6)+sum(elem)'; %normalizada
                clear dist elem

                dist= pdist2(X_2,d);
                elem = a(1:M).*exp(-((dist.^2)/(2*c^2)))'; 
                S_2 = a(M+1)+a(M+2)*X_2(:,1)+a(M+3)*X_2(:,2)+a(M+4)*X_2(:,3)+a(M+5)*X_2(:,4)+a(M+6)*X_2(:,5)+a(M+7)*X_2(:,6)+sum(elem)'; %normalizada
                clear dist elem

                S = [S_1; S_2];

                save(['DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE\' fold_name '\' VAR '\' file_name '.mat'],'S')

            else

                load(['DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE\' fold_name '\' VAR '\' file_name '.mat'])     

            end 




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
            addpath('\DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE')
            mkdir(['DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE\' fold_name '\' VAR '\' SC '\' OF])
            addpath(['DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE\' fold_name '\' VAR '\' SC '\' OF])

            %Busco si existe un fichero con M puntos de la muestra o más
            file_name=[fold_name VAR '_' 'M=' num2str(M) '_PC_' num2str(PC(2,1)) '_' num2str(PC(2,2)) '_sim_' num2str(sim,'%04.f')];

            % Compruebo si hay archivos en la carpeta, si los hay los cargo para ver si
            % son mayores al número de valores de la muestra que deseo. Si no hay o el
            % número de valores es menor aplico el proceso de selección mediante MDA
            s = what(['DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE\' fold_name '\' VAR '\' SC '\' OF]);
            files=s(1,1).mat;

            if exist(['DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE\' fold_name '\' VAR '\' SC '\' OF '\' file_name '.mat'])==0 %Si no existe el archivo específico
                % En primer lugar calculo la primera parte de la matriz A (A_reducida)
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
                for i=1:M
                    A_II(i,:)=[1 d(i,:)];
                end

                % En tercer lugar termino de calcular la matriz A introduciendo los 0
                s=size(A_II);
                Z=zeros(s(2),s(2));

                A_1=[A_red;A_II'];
                A_2=[A_II;Z];
                A=[A_1 A_2];

                % Calculo los coeficientes a
                a=inv(A)*[f zeros(1,length(d(1,:))+1)]';

                % Calculo la RBF en cada punto
    %             progressbar('Interpolación mediante RBF') % Init single bar
    %             for k=1:length(X(:,1))    
    %                 for j=1:M
    %                    minimo_teta_oleaje=min([abs(X(k,5)-d(j,5)) 2-abs(X(k,5)-d(j,5))]);
    %                    minimo_teta_viento=min([abs(X(k,7)-d(j,7)) 2-abs(X(k,7)-d(j,7))]);
    %                
    %                    dist=sqrt((X(k,1)-d(j,1))^2+(X(k,2)-d(j,2))^2+(X(k,3)-d(j,3))^2+(X(k,4)-d(j,4))^2+minimo_teta_oleaje^2+(X(k,6)-d(j,6))^2+minimo_teta_viento^2+(X(k,8)-d(j,8))^2); 
    %                    elem(j)= a(j)*exp(-((dist^2)/(2*c^2))); 
    %                 end    
    % 
    %                 S(k)=a(M+1)+a(M+2)*X(k,1)+a(M+3)*X(k,2)+a(M+4)*X(k,3)+a(M+5)*X(k,4)+a(M+6)*X(k,5)+a(M+7)*X(k,6)+a(M+8)*X(k,7)+a(M+9)*X(k,8)+sum(elem);   %normalizada 
    %                 progressbar(k/length(X(:,1))) % Update progress bar
    %             end


                % Modo vectorial II
                % Division de X
                X_1 = X(1:round(length(X)/2), :);
                X_2 = X(round(length(X)/2) + 1:end, :);

                dist= pdist2(X_1,d);
                elem = a(1:M).*exp(-((dist.^2)/(2*c^2)))'; 
                S_1 = a(M+1)+a(M+2)*X_1(:,1)+a(M+3)*X_1(:,2)+a(M+4)*X_1(:,3)+a(M+5)*X_1(:,4)+a(M+6)*X_1(:,5)+a(M+7)*X_1(:,6)+a(M+8)*X_1(:,7)+a(M+9)*X_1(:,8)+sum(elem)'; %normalizada
                clear dist elem

                dist= pdist2(X_2,d);
                elem = a(1:M).*exp(-((dist.^2)/(2*c^2)))'; 
                S_2 = a(M+1)+a(M+2)*X_2(:,1)+a(M+3)*X_2(:,2)+a(M+4)*X_2(:,3)+a(M+5)*X_2(:,4)+a(M+6)*X_2(:,5)+a(M+7)*X_2(:,6)+a(M+8)*X_2(:,7)+a(M+9)*X_2(:,8)+sum(elem)'; %normalizada
                clear dist elem

                S = [S_1; S_2];

                save(['DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE\' fold_name '\' VAR '\' SC '\' OF '\' file_name '.mat'],'S')

            else

                load(['DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE\' fold_name '\' VAR '\' SC '\' OF '\' file_name '.mat'])  

            end 


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
            addpath('\DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE')
            mkdir(['DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE\' fold_name '\' VAR])
            addpath(['DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE\' fold_name '\' VAR])

            %Busco si existe un fichero con M puntos de la muestra o más
            file_name=[fold_name VAR '_' 'M=' num2str(M) '_PC_' num2str(PC(1)) '_' num2str(PC(2))];

            % Compruebo si hay archivos en la carpeta, si los hay los cargo para ver si
            % son mayores al número de valores de la muestra que deseo. Si no hay o el
            % número de valores es menor aplico el proceso de selección mediante MDA
            s = what(['DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE\' fold_name '\' VAR]);
            files=s(1,1).mat;

            if exist(['DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE\' fold_name '\' VAR '\' file_name '.mat'])==0 %Si no existe el archivo específico
                % En primer lugar calculo la primera parte de la matriz A (A_reducida)
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
                for i=1:M
                    A_II(i,:)=[1 d(i,:)];
                end

                % En tercer lugar termino de calcular la matriz A introduciendo los 0
                s=size(A_II);
                Z=zeros(s(2),s(2));

                A_1=[A_red;A_II'];
                A_2=[A_II;Z];
                A=[A_1 A_2];

                % Calculo los coeficientes a
                a=inv(A)*[f zeros(1,length(d(1,:))+1)]';

                % Calculo la RBF en cada punto
                progressbar('Interpolación mediante RBF') % Init single bar
                for k=1:length(X(:,1))    
                    for j=1:M
                       minimo_teta_oleaje=min([abs(X(k,4)-d(j,4)) 2-abs(X(k,4)-d(j,4))]);
                       minimo_teta_viento=min([abs(X(k,6)-d(j,6)) 2-abs(X(k,6)-d(j,6))]);

                       dist=sqrt((X(k,1)-d(j,1))^2+(X(k,2)-d(j,2))^2+(X(k,3)-d(j,3))^2+minimo_teta_oleaje^2+(X(k,5)-d(j,5))^2+minimo_teta_viento^2+(X(k,7)-d(j,7))^2); 
                       elem(j)= a(j)*exp(-((dist^2)/(2*c^2))); 
                    end    

                    S(k)=a(M+1)+a(M+2)*X(k,1)+a(M+3)*X(k,2)+a(M+4)*X(k,3)+a(M+5)*X(k,4)+a(M+6)*X(k,5)+a(M+7)*X(k,6)+a(M+8)*X(k,7)+sum(elem);   %normalizada 
                    progressbar(k/length(X(:,1))) % Update progress bar
                end

                save(['DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE\' fold_name '\' VAR '\' SC '\' OF '\' file_name '.mat'],'S')

            else

                load(['DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE\' fold_name '\' VAR '\' SC '\' OF '\' file_name '.mat'])     

            end 

    %         figure
    %         sub(1)=subplot(5,1,1);
    %         plot(Forzamiento.MA.ma,'k')
    %         grid on
    %         sub(2)=subplot(5,1,2);
    %         plot(Forzamiento.Q.q,'r')
    %         grid on
    %         sub(4)=subplot(5,1,3);
    %         plot(Forzamiento.OD.Hs,'b')
    %         grid on
    %         sub(5)=subplot(5,1,4);
    %         plot(Forzamiento.MM.vv,'g')
    %         grid on
    %         sub(6)=subplot(5,1,5);
    %         plot(S,'r')
    %         grid on
    %         linkaxes([sub],'x')



        %%%%%%%%%%%%

    elseif comp_oleaje==1 && comp_m_meteo==0 % Caso 1 Sólo tengo oleaje

        if VAR=='Hs'    
            f=F.Oleaje.Hs;
            c=c.c_Hs;
        elseif VAR=='Tp'
            f=F.Oleaje.Tp;
            c=c.c_Tp;
        elseif VAR=='Do'
            f=F.Oleaje.d_o;
            c=c.c_Dmd_o;
        end

        %Creo una carpeta diferente para cada combinación de agentes en la que voy
        %a guardar los valores de f para no tener que cargarlos cada vez
        fold_name='';
        for j=1:l
           fold_name=[fold_name char(names(j)),'_']; 
        end

        %Creo la carpeta dentro de datos
        addpath('\DATOS\RADIAL_BASIS_FUNCTION\PROPAGACION_REGIMEN_MEDIO')
        mkdir(['DATOS\RADIAL_BASIS_FUNCTION\PROPAGACION_REGIMEN_MEDIO\' fold_name '\' VAR])
        addpath(['DATOS\RADIAL_BASIS_FUNCTION\PROPAGACION_REGIMEN_MEDIO\' fold_name '\' VAR])

        %Busco si existe un fichero con M puntos de la muestra o más
        file_name=[fold_name VAR '_' 'M=' num2str(M) '_PC=' num2str(PC)];

        % Compruebo si hay archivos en la carpeta, si los hay los cargo para ver si
        % son mayores al número de valores de la muestra que deseo. Si no hay o el
        % número de valores es menor aplico el proceso de selección mediante MDA
        s = what(['DATOS\RADIAL_BASIS_FUNCTION\PROPAGACION_REGIMEN_MEDIO\' fold_name '\' VAR]);
        files=s(1,1).mat;

        if exist(['DATOS\RADIAL_BASIS_FUNCTION\PROPAGACION_REGIMEN_MEDIO\' fold_name '\' VAR '\' file_name '.mat'])==0 %Si no existe el archivo específico
            % En primer lugar calculo la primera parte de la matriz A (A_reducida)
            for i=1:M
                for j=1:M
                    minimo_teta_oleaje=min([abs(d(i,3)-d(j,3)) 2-abs(d(i,3)-d(j,3))]);

                    dist=sqrt((d(i,1)-d(j,1))^2+(d(i,2)-d(j,2))^2+minimo_teta_oleaje^2);
                    A_red(i,j)=exp(-((dist^2)/(2*c^2))); % A_reducida
                end    
            end

            % En segundo lugar calculo la segunda parte de la Matriz A, metiendo
            % los valores de la muestra
            for i=1:M
                A_II(i,:)=[1 d(i,:)];
            end

            % En tercer lugar termino de calcular la matriz A introduciendo los 0
            s=size(A_II);
            Z=zeros(s(2),s(2));

            A_1=[A_red;A_II'];
            A_2=[A_II;Z];
            A=[A_1 A_2];

            % Calculo los coeficientes a
            a=inv(A)*[f zeros(1,length(d(1,:))+1)]';

            % Calculo la RBF en cada punto
            progressbar('Interpolación mediante RBF') % Init single bar
            for k=1:length(X(:,1))    
                for j=1:M
                   minimo_teta_oleaje=min([abs(X(k,3)-d(j,3)) 2-abs(X(k,3)-d(j,3))]);

                   dist=sqrt((X(k,1)-d(j,1))^2+(X(k,2)-d(j,2))^2+minimo_teta_oleaje^2); 
                   elem(j)= a(j)*exp(-((dist^2)/(2*c^2))); 
                end    

                S(k)=a(M+1)+a(M+2)*X(k,1)+a(M+3)*X(k,2)+a(M+4)*X(k,3)+sum(elem);   %normalizada
                progressbar(k/length(X(:,1))) % Update progress bar
            end


            save(['DATOS\RADIAL_BASIS_FUNCTION\PROPAGACION_REGIMEN_MEDIO\' fold_name '\' VAR '\' file_name '.mat'],'S')

        else

            load(['DATOS\RADIAL_BASIS_FUNCTION\PROPAGACION_REGIMEN_MEDIO\' fold_name '\' VAR '\' file_name '.mat'])     

        end

    elseif comp_oleaje==1 && comp_m_meteo==1 % Caso 2 Tengo Oleaje y M. Meteo

        if VAR=='Hs'    
            f=F.Oleaje.Hs;
            c=c.c_Hs;
        elseif VAR=='Tp'
            f=F.Oleaje.Tp;
            c=c.c_Tp;
        elseif VAR=='Do'
            f=F.Oleaje.d_o;
            c=c.c_Dmd_o;
        end

        %Creo una carpeta diferente para cada combinación de agentes en la que voy
        %a guardar los valores de f para no tener que cargarlos cada vez
        fold_name='';
        for j=1:l
           fold_name=[fold_name char(names(j)),'_']; 
        end

        %Creo la carpeta dentro de datos
        addpath('\DATOS\RADIAL_BASIS_FUNCTION\PROPAGACION_REGIMEN_MEDIO')
        mkdir(['DATOS\RADIAL_BASIS_FUNCTION\PROPAGACION_REGIMEN_MEDIO\' fold_name '\' VAR])
        addpath(['DATOS\RADIAL_BASIS_FUNCTION\PROPAGACION_REGIMEN_MEDIO\' fold_name '\' VAR])

        %Busco si existe un fichero con M puntos de la muestra o más
        file_name=[fold_name VAR '_' 'M=' num2str(M) '_PC_' num2str(PC) '_sim_' num2str(sim,'%04.f')];

        % Compruebo si hay archivos en la carpeta, si los hay los cargo para ver si
        % son mayores al número de valores de la muestra que deseo. Si no hay o el
        % número de valores es menor aplico el proceso de selección mediante MDA
        s = what(['DATOS\RADIAL_BASIS_FUNCTION\PROPAGACION_REGIMEN_MEDIO\' fold_name '\' VAR]);
        files=s(1,1).mat;

        if exist(['DATOS\RADIAL_BASIS_FUNCTION\PROPAGACION_REGIMEN_MEDIO\' fold_name '\' VAR '\' file_name '.mat'])==0 %Si no existe el archivo específico
            % En primer lugar calculo la primera parte de la matriz A (A_reducida)
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
            for i=1:M
                A_II(i,:)=[1 d(i,:)];
            end

            % En tercer lugar termino de calcular la matriz A introduciendo los 0
            s=size(A_II);
            Z=zeros(s(2),s(2));

            A_1=[A_red;A_II'];
            A_2=[A_II;Z];
            A=[A_1 A_2];

            % Calculo los coeficientes a
            a=inv(A)*[f zeros(1,length(d(1,:))+1)]';

            % Calculo la RBF en cada punto
    %         progressbar('Interpolación mediante RBF') % Init single bar
    %         for k=1:length(X(:,1))    
    %             for j=1:M
    %                minimo_teta_oleaje=min([abs(X(k,3)-d(j,3)) 2-abs(X(k,3)-d(j,3))]);
    %                minimo_teta_viento=min([abs(X(k,5)-d(j,5)) 2-abs(X(k,5)-d(j,5))]);
    %                
    %                dist=sqrt((X(k,1)-d(j,1))^2+(X(k,2)-d(j,2))^2+minimo_teta_oleaje^2+(X(k,4)-d(j,4))^2+minimo_teta_viento^2); 
    %                elem(j)= a(j)*exp(-((dist^2)/(2*c^2))); 
    %             end    
    % 
    %             S(k)=a(M+1)+a(M+2)*X(k,1)+a(M+3)*X(k,2)+a(M+4)*X(k,3)+a(M+5)*X(k,4)+a(M+6)*X(k,5)+sum(elem);   %normalizada 
    %             progressbar(k/length(X(:,1))) % Update progress bar
    %         end

            % Modo vectorial II
            % Division de X
            X_1 = X(1:round(length(X)/2), :);
            X_2 = X(round(length(X)/2) + 1:end, :);

            dist= pdist2(X_1,d);
            elem = a(1:M).*exp(-((dist.^2)/(2*c^2)))'; 
            S_1 = a(M+1)+a(M+2)*X_1(:,1)+a(M+3)*X_1(:,2)+a(M+4)*X_1(:,3)+a(M+5)*X_1(:,4)+a(M+6)*X_1(:,5)+sum(elem)'; %normalizada
            clear dist elem

            dist= pdist2(X_2,d);
            elem = a(1:M).*exp(-((dist.^2)/(2*c^2)))'; 
            S_2 = a(M+1)+a(M+2)*X_2(:,1)+a(M+3)*X_2(:,2)+a(M+4)*X_2(:,3)+a(M+5)*X_2(:,4)+a(M+6)*X_2(:,5)+sum(elem)'; %normalizada
            clear dist elem

            S = [S_1; S_2];
            % Erase negative values
            S(S<0) = 0;

            save(['DATOS\RADIAL_BASIS_FUNCTION\PROPAGACION_REGIMEN_MEDIO\' fold_name '\' VAR '\' file_name '.mat'],'S')

        else

            load(['DATOS\RADIAL_BASIS_FUNCTION\PROPAGACION_REGIMEN_MEDIO\' fold_name '\' VAR '\' file_name '.mat'])     

        end

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
    addpath('\DATOS\RADIAL_BASIS_FUNCTION\CORRIENTE_X_GAUDALETE')
    mkdir(['DATOS\RADIAL_BASIS_FUNCTION\CORRIENTE_X_GAUDALETE\' fold_name '\' VAR '\' SC '\' OF])
    addpath(['DATOS\RADIAL_BASIS_FUNCTION\CORRIENTE_X_GAUDALETE\' fold_name '\' VAR '\' SC '\' OF])

    %Busco si existe un fichero con M puntos de la muestra o más
    file_name=[fold_name VAR '_' 'M=' num2str(M) '_PC_' num2str(PC(2,1)) '_' num2str(PC(2,2)) '_sim_' num2str(sim,'%04.f')];

    % Compruebo si hay archivos en la carpeta, si los hay los cargo para ver si
    % son mayores al número de valores de la muestra que deseo. Si no hay o el
    % número de valores es menor aplico el proceso de selección mediante MDA
    s = what(['DATOS\RADIAL_BASIS_FUNCTION\CORRIENTE_X_GAUDALETE\' fold_name '\' VAR '\' SC '\' OF]);
    files=s(1,1).mat;

    if exist(['DATOS\RADIAL_BASIS_FUNCTION\CORRIENTE_X_GAUDALETE\' fold_name '\' VAR '\' SC '\' OF '\' file_name '.mat'])==0 %Si no existe el archivo específico
        % En primer lugar calculo la primera parte de la matriz A (A_reducida)
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
        for i=1:M
            A_II(i,:)=[1 d(i,:)];
        end

        % En tercer lugar termino de calcular la matriz A introduciendo los 0
        s=size(A_II);
        Z=zeros(s(2),s(2));

        A_1=[A_red;A_II'];
        A_2=[A_II;Z];
        A=[A_1 A_2];

        % Calculo los coeficientes a
        a=inv(A)*[f zeros(1,length(d(1,:))+1)]';

        % Calculo la RBF en cada punto
    %             progressbar('Interpolación mediante RBF') % Init single bar
    %             for k=1:length(X(:,1))    
    %                 for j=1:M
    %                    minimo_teta_oleaje=min([abs(X(k,5)-d(j,5)) 2-abs(X(k,5)-d(j,5))]);
    %                    minimo_teta_viento=min([abs(X(k,7)-d(j,7)) 2-abs(X(k,7)-d(j,7))]);
    %                
    %                    dist=sqrt((X(k,1)-d(j,1))^2+(X(k,2)-d(j,2))^2+(X(k,3)-d(j,3))^2+(X(k,4)-d(j,4))^2+minimo_teta_oleaje^2+(X(k,6)-d(j,6))^2+minimo_teta_viento^2+(X(k,8)-d(j,8))^2); 
    %                    elem(j)= a(j)*exp(-((dist^2)/(2*c^2))); 
    %                 end    
    % 
    %                 S(k)=a(M+1)+a(M+2)*X(k,1)+a(M+3)*X(k,2)+a(M+4)*X(k,3)+a(M+5)*X(k,4)+a(M+6)*X(k,5)+a(M+7)*X(k,6)+a(M+8)*X(k,7)+a(M+9)*X(k,8)+sum(elem);   %normalizada 
    %                 progressbar(k/length(X(:,1))) % Update progress bar
    %             end


        % Modo vectorial II
        % Division de X
        X_1 = X(1:round(length(X)/2), :);
        X_2 = X(round(length(X)/2) + 1:end, :);

        dist= pdist2(X_1,d);
        elem = a(1:M).*exp(-((dist.^2)/(2*c^2)))'; 
        S_1 = a(M+1)+a(M+2)*X_1(:,1)+a(M+3)*X_1(:,2)+a(M+4)*X_1(:,3)+a(M+5)*X_1(:,4)+a(M+6)*X_1(:,5)+a(M+7)*X_1(:,6)+a(M+8)*X_1(:,7)+a(M+9)*X_1(:,8)+sum(elem)'; %normalizada
        clear dist elem

        dist= pdist2(X_2,d);
        elem = a(1:M).*exp(-((dist.^2)/(2*c^2)))'; 
        S_2 = a(M+1)+a(M+2)*X_2(:,1)+a(M+3)*X_2(:,2)+a(M+4)*X_2(:,3)+a(M+5)*X_2(:,4)+a(M+6)*X_2(:,5)+a(M+7)*X_2(:,6)+a(M+8)*X_2(:,7)+a(M+9)*X_2(:,8)+sum(elem)'; %normalizada
        clear dist elem

        S = [S_1; S_2];

        save(['DATOS\RADIAL_BASIS_FUNCTION\CORRIENTE_X_GAUDALETE\' fold_name '\' VAR '\' SC '\' OF '\' file_name '.mat'],'S')

    else

        load(['DATOS\RADIAL_BASIS_FUNCTION\CORRIENTE_X_GAUDALETE\' fold_name '\' VAR '\' SC '\' OF '\' file_name '.mat'])  

    end 
    
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
    addpath('\DATOS\RADIAL_BASIS_FUNCTION\CORRIENTE_Y_GAUDALETE')
    mkdir(['DATOS\RADIAL_BASIS_FUNCTION\CORRIENTE_Y_GAUDALETE\' fold_name '\' VAR '\' SC '\' OF])
    addpath(['DATOS\RADIAL_BASIS_FUNCTION\CORRIENTE_Y_GAUDALETE\' fold_name '\' VAR '\' SC '\' OF])

    %Busco si existe un fichero con M puntos de la muestra o más
    file_name=[fold_name VAR '_' 'M=' num2str(M) '_PC_' num2str(PC(2,1)) '_' num2str(PC(2,2)) '_sim_' num2str(sim,'%04.f')];

    % Compruebo si hay archivos en la carpeta, si los hay los cargo para ver si
    % son mayores al número de valores de la muestra que deseo. Si no hay o el
    % número de valores es menor aplico el proceso de selección mediante MDA
    s = what(['DATOS\RADIAL_BASIS_FUNCTION\CORRIENTE_Y_GAUDALETE\' fold_name '\' VAR '\' SC '\' OF]);
    files=s(1,1).mat;

    if exist(['DATOS\RADIAL_BASIS_FUNCTION\CORRIENTE_Y_GAUDALETE\' fold_name '\' VAR '\' SC '\' OF '\' file_name '.mat'])==0 %Si no existe el archivo específico
        % En primer lugar calculo la primera parte de la matriz A (A_reducida)
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
        for i=1:M
            A_II(i,:)=[1 d(i,:)];
        end

        % En tercer lugar termino de calcular la matriz A introduciendo los 0
        s=size(A_II);
        Z=zeros(s(2),s(2));

        A_1=[A_red;A_II'];
        A_2=[A_II;Z];
        A=[A_1 A_2];

        % Calculo los coeficientes a
        a=inv(A)*[f zeros(1,length(d(1,:))+1)]';

        % Calculo la RBF en cada punto
    %             progressbar('Interpolación mediante RBF') % Init single bar
    %             for k=1:length(X(:,1))    
    %                 for j=1:M
    %                    minimo_teta_oleaje=min([abs(X(k,5)-d(j,5)) 2-abs(X(k,5)-d(j,5))]);
    %                    minimo_teta_viento=min([abs(X(k,7)-d(j,7)) 2-abs(X(k,7)-d(j,7))]);
    %                
    %                    dist=sqrt((X(k,1)-d(j,1))^2+(X(k,2)-d(j,2))^2+(X(k,3)-d(j,3))^2+(X(k,4)-d(j,4))^2+minimo_teta_oleaje^2+(X(k,6)-d(j,6))^2+minimo_teta_viento^2+(X(k,8)-d(j,8))^2); 
    %                    elem(j)= a(j)*exp(-((dist^2)/(2*c^2))); 
    %                 end    
    % 
    %                 S(k)=a(M+1)+a(M+2)*X(k,1)+a(M+3)*X(k,2)+a(M+4)*X(k,3)+a(M+5)*X(k,4)+a(M+6)*X(k,5)+a(M+7)*X(k,6)+a(M+8)*X(k,7)+a(M+9)*X(k,8)+sum(elem);   %normalizada 
    %                 progressbar(k/length(X(:,1))) % Update progress bar
    %             end


        % Modo vectorial II
        % Division de X
        X_1 = X(1:round(length(X)/2), :);
        X_2 = X(round(length(X)/2) + 1:end, :);

        dist= pdist2(X_1,d);
        elem = a(1:M).*exp(-((dist.^2)/(2*c^2)))'; 
        S_1 = a(M+1)+a(M+2)*X_1(:,1)+a(M+3)*X_1(:,2)+a(M+4)*X_1(:,3)+a(M+5)*X_1(:,4)+a(M+6)*X_1(:,5)+a(M+7)*X_1(:,6)+a(M+8)*X_1(:,7)+a(M+9)*X_1(:,8)+sum(elem)'; %normalizada
        clear dist elem

        dist= pdist2(X_2,d);
        elem = a(1:M).*exp(-((dist.^2)/(2*c^2)))'; 
        S_2 = a(M+1)+a(M+2)*X_2(:,1)+a(M+3)*X_2(:,2)+a(M+4)*X_2(:,3)+a(M+5)*X_2(:,4)+a(M+6)*X_2(:,5)+a(M+7)*X_2(:,6)+a(M+8)*X_2(:,7)+a(M+9)*X_2(:,8)+sum(elem)'; %normalizada
        clear dist elem

        S = [S_1; S_2];

        save(['DATOS\RADIAL_BASIS_FUNCTION\CORRIENTE_Y_GAUDALETE\' fold_name '\' VAR '\' SC '\' OF '\' file_name '.mat'],'S')

    else

        load(['DATOS\RADIAL_BASIS_FUNCTION\CORRIENTE_Y_GAUDALETE\' fold_name '\' VAR '\' SC '\' OF '\' file_name '.mat'])  

    end
    
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
    addpath('\DATOS\RADIAL_BASIS_FUNCTION\HS')
    mkdir(['DATOS\RADIAL_BASIS_FUNCTION\HS\' fold_name '\' VAR '\' SC '\' OF])
    addpath(['DATOS\RADIAL_BASIS_FUNCTION\HS\' fold_name '\' VAR '\' SC '\' OF])

    %Busco si existe un fichero con M puntos de la muestra o más
    file_name=[fold_name VAR '_' 'M=' num2str(M) '_PC_' num2str(PC(2,1)) '_' num2str(PC(2,2)) '_sim_' num2str(sim,'%04.f')];

    % Compruebo si hay archivos en la carpeta, si los hay los cargo para ver si
    % son mayores al número de valores de la muestra que deseo. Si no hay o el
    % número de valores es menor aplico el proceso de selección mediante MDA
    s = what(['DATOS\RADIAL_BASIS_FUNCTION\HS\' fold_name '\' VAR '\' SC '\' OF]);
    files=s(1,1).mat;

    if exist(['DATOS\RADIAL_BASIS_FUNCTION\HS\' fold_name '\' VAR '\' SC '\' OF '\' file_name '.mat'])==0 %Si no existe el archivo específico
        % En primer lugar calculo la primera parte de la matriz A (A_reducida)
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
        for i=1:M
            A_II(i,:)=[1 d(i,:)];
        end

        % En tercer lugar termino de calcular la matriz A introduciendo los 0
        s=size(A_II);
        Z=zeros(s(2),s(2));

        A_1=[A_red;A_II'];
        A_2=[A_II;Z];
        A=[A_1 A_2];

        % Calculo los coeficientes a
        a=inv(A)*[f zeros(1,length(d(1,:))+1)]';

        % Calculo la RBF en cada punto
    %             progressbar('Interpolación mediante RBF') % Init single bar
    %             for k=1:length(X(:,1))    
    %                 for j=1:M
    %                    minimo_teta_oleaje=min([abs(X(k,5)-d(j,5)) 2-abs(X(k,5)-d(j,5))]);
    %                    minimo_teta_viento=min([abs(X(k,7)-d(j,7)) 2-abs(X(k,7)-d(j,7))]);
    %                
    %                    dist=sqrt((X(k,1)-d(j,1))^2+(X(k,2)-d(j,2))^2+(X(k,3)-d(j,3))^2+(X(k,4)-d(j,4))^2+minimo_teta_oleaje^2+(X(k,6)-d(j,6))^2+minimo_teta_viento^2+(X(k,8)-d(j,8))^2); 
    %                    elem(j)= a(j)*exp(-((dist^2)/(2*c^2))); 
    %                 end    
    % 
    %                 S(k)=a(M+1)+a(M+2)*X(k,1)+a(M+3)*X(k,2)+a(M+4)*X(k,3)+a(M+5)*X(k,4)+a(M+6)*X(k,5)+a(M+7)*X(k,6)+a(M+8)*X(k,7)+a(M+9)*X(k,8)+sum(elem);   %normalizada 
    %                 progressbar(k/length(X(:,1))) % Update progress bar
    %             end


        % Modo vectorial II
        % Division de X
        X_1 = X(1:round(length(X)/2), :);
        X_2 = X(round(length(X)/2) + 1:end, :);

        dist= pdist2(X_1,d);
        elem = a(1:M).*exp(-((dist.^2)/(2*c^2)))'; 
        S_1 = a(M+1)+a(M+2)*X_1(:,1)+a(M+3)*X_1(:,2)+a(M+4)*X_1(:,3)+a(M+5)*X_1(:,4)+a(M+6)*X_1(:,5)+a(M+7)*X_1(:,6)+a(M+8)*X_1(:,7)+a(M+9)*X_1(:,8)+sum(elem)'; %normalizada
        clear dist elem

        dist= pdist2(X_2,d);
        elem = a(1:M).*exp(-((dist.^2)/(2*c^2)))'; 
        S_2 = a(M+1)+a(M+2)*X_2(:,1)+a(M+3)*X_2(:,2)+a(M+4)*X_2(:,3)+a(M+5)*X_2(:,4)+a(M+6)*X_2(:,5)+a(M+7)*X_2(:,6)+a(M+8)*X_2(:,7)+a(M+9)*X_2(:,8)+sum(elem)'; %normalizada
        clear dist elem

        S = [S_1; S_2];

        save(['DATOS\RADIAL_BASIS_FUNCTION\HS\' fold_name '\' VAR '\' SC '\' OF '\' file_name '.mat'],'S')

    else

        load(['DATOS\RADIAL_BASIS_FUNCTION\HS\' fold_name '\' VAR '\' SC '\' OF '\' file_name '.mat'])  

    end
    
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
    addpath('\DATOS\RADIAL_BASIS_FUNCTION\TP')
    mkdir(['DATOS\RADIAL_BASIS_FUNCTION\TP\' fold_name '\' VAR '\' SC '\' OF])
    addpath(['DATOS\RADIAL_BASIS_FUNCTION\TP\' fold_name '\' VAR '\' SC '\' OF])

    %Busco si existe un fichero con M puntos de la muestra o más
    file_name=[fold_name VAR '_' 'M=' num2str(M) '_PC_' num2str(PC(2,1)) '_' num2str(PC(2,2)) '_sim_' num2str(sim,'%04.f')];

    % Compruebo si hay archivos en la carpeta, si los hay los cargo para ver si
    % son mayores al número de valores de la muestra que deseo. Si no hay o el
    % número de valores es menor aplico el proceso de selección mediante MDA
    s = what(['DATOS\RADIAL_BASIS_FUNCTION\TP\' fold_name '\' VAR '\' SC '\' OF]);
    files=s(1,1).mat;

    if exist(['DATOS\RADIAL_BASIS_FUNCTION\TP\' fold_name '\' VAR '\' SC '\' OF '\' file_name '.mat'])==0 %Si no existe el archivo específico
        % En primer lugar calculo la primera parte de la matriz A (A_reducida)
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
        for i=1:M
            A_II(i,:)=[1 d(i,:)];
        end

        % En tercer lugar termino de calcular la matriz A introduciendo los 0
        s=size(A_II);
        Z=zeros(s(2),s(2));

        A_1=[A_red;A_II'];
        A_2=[A_II;Z];
        A=[A_1 A_2];

        % Calculo los coeficientes a
        a=inv(A)*[f zeros(1,length(d(1,:))+1)]';

        % Calculo la RBF en cada punto
    %             progressbar('Interpolación mediante RBF') % Init single bar
    %             for k=1:length(X(:,1))    
    %                 for j=1:M
    %                    minimo_teta_oleaje=min([abs(X(k,5)-d(j,5)) 2-abs(X(k,5)-d(j,5))]);
    %                    minimo_teta_viento=min([abs(X(k,7)-d(j,7)) 2-abs(X(k,7)-d(j,7))]);
    %                
    %                    dist=sqrt((X(k,1)-d(j,1))^2+(X(k,2)-d(j,2))^2+(X(k,3)-d(j,3))^2+(X(k,4)-d(j,4))^2+minimo_teta_oleaje^2+(X(k,6)-d(j,6))^2+minimo_teta_viento^2+(X(k,8)-d(j,8))^2); 
    %                    elem(j)= a(j)*exp(-((dist^2)/(2*c^2))); 
    %                 end    
    % 
    %                 S(k)=a(M+1)+a(M+2)*X(k,1)+a(M+3)*X(k,2)+a(M+4)*X(k,3)+a(M+5)*X(k,4)+a(M+6)*X(k,5)+a(M+7)*X(k,6)+a(M+8)*X(k,7)+a(M+9)*X(k,8)+sum(elem);   %normalizada 
    %                 progressbar(k/length(X(:,1))) % Update progress bar
    %             end


        % Modo vectorial II
        % Division de X
        X_1 = X(1:round(length(X)/2), :);
        X_2 = X(round(length(X)/2) + 1:end, :);

        dist= pdist2(X_1,d);
        elem = a(1:M).*exp(-((dist.^2)/(2*c^2)))'; 
        S_1 = a(M+1)+a(M+2)*X_1(:,1)+a(M+3)*X_1(:,2)+a(M+4)*X_1(:,3)+a(M+5)*X_1(:,4)+a(M+6)*X_1(:,5)+a(M+7)*X_1(:,6)+a(M+8)*X_1(:,7)+a(M+9)*X_1(:,8)+sum(elem)'; %normalizada
        clear dist elem

        dist= pdist2(X_2,d);
        elem = a(1:M).*exp(-((dist.^2)/(2*c^2)))'; 
        S_2 = a(M+1)+a(M+2)*X_2(:,1)+a(M+3)*X_2(:,2)+a(M+4)*X_2(:,3)+a(M+5)*X_2(:,4)+a(M+6)*X_2(:,5)+a(M+7)*X_2(:,6)+a(M+8)*X_2(:,7)+a(M+9)*X_2(:,8)+sum(elem)'; %normalizada
        clear dist elem

        S = [S_1; S_2];

        save(['DATOS\RADIAL_BASIS_FUNCTION\TP\' fold_name '\' VAR '\' SC '\' OF '\' file_name '.mat'],'S')

    else

        load(['DATOS\RADIAL_BASIS_FUNCTION\TP\' fold_name '\' VAR '\' SC '\' OF '\' file_name '.mat'])  

    end
    
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
    addpath('\DATOS\RADIAL_BASIS_FUNCTION\DO')
    mkdir(['DATOS\RADIAL_BASIS_FUNCTION\DO\' fold_name '\' VAR '\' SC '\' OF])
    addpath(['DATOS\RADIAL_BASIS_FUNCTION\DO\' fold_name '\' VAR '\' SC '\' OF])

    %Busco si existe un fichero con M puntos de la muestra o más
    file_name=[fold_name VAR '_' 'M=' num2str(M) '_PC_' num2str(PC(2,1)) '_' num2str(PC(2,2)) '_sim_' num2str(sim,'%04.f')];

    % Compruebo si hay archivos en la carpeta, si los hay los cargo para ver si
    % son mayores al número de valores de la muestra que deseo. Si no hay o el
    % número de valores es menor aplico el proceso de selección mediante MDA
    s = what(['DATOS\RADIAL_BASIS_FUNCTION\DO\' fold_name '\' VAR '\' SC '\' OF]);
    files=s(1,1).mat;

    if exist(['DATOS\RADIAL_BASIS_FUNCTION\DO\' fold_name '\' VAR '\' SC '\' OF '\' file_name '.mat'])==0 %Si no existe el archivo específico
        % En primer lugar calculo la primera parte de la matriz A (A_reducida)
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
        for i=1:M
            A_II(i,:)=[1 d(i,:)];
        end

        % En tercer lugar termino de calcular la matriz A introduciendo los 0
        s=size(A_II);
        Z=zeros(s(2),s(2));

        A_1=[A_red;A_II'];
        A_2=[A_II;Z];
        A=[A_1 A_2];

        % Calculo los coeficientes a
        a=inv(A)*[f zeros(1,length(d(1,:))+1)]';

        % Calculo la RBF en cada punto
    %             progressbar('Interpolación mediante RBF') % Init single bar
    %             for k=1:length(X(:,1))    
    %                 for j=1:M
    %                    minimo_teta_oleaje=min([abs(X(k,5)-d(j,5)) 2-abs(X(k,5)-d(j,5))]);
    %                    minimo_teta_viento=min([abs(X(k,7)-d(j,7)) 2-abs(X(k,7)-d(j,7))]);
    %                
    %                    dist=sqrt((X(k,1)-d(j,1))^2+(X(k,2)-d(j,2))^2+(X(k,3)-d(j,3))^2+(X(k,4)-d(j,4))^2+minimo_teta_oleaje^2+(X(k,6)-d(j,6))^2+minimo_teta_viento^2+(X(k,8)-d(j,8))^2); 
    %                    elem(j)= a(j)*exp(-((dist^2)/(2*c^2))); 
    %                 end    
    % 
    %                 S(k)=a(M+1)+a(M+2)*X(k,1)+a(M+3)*X(k,2)+a(M+4)*X(k,3)+a(M+5)*X(k,4)+a(M+6)*X(k,5)+a(M+7)*X(k,6)+a(M+8)*X(k,7)+a(M+9)*X(k,8)+sum(elem);   %normalizada 
    %                 progressbar(k/length(X(:,1))) % Update progress bar
    %             end


        % Modo vectorial II
        % Division de X
        X_1 = X(1:round(length(X)/2), :);
        X_2 = X(round(length(X)/2) + 1:end, :);

        dist= pdist2(X_1,d);
        elem = a(1:M).*exp(-((dist.^2)/(2*c^2)))'; 
        S_1 = a(M+1)+a(M+2)*X_1(:,1)+a(M+3)*X_1(:,2)+a(M+4)*X_1(:,3)+a(M+5)*X_1(:,4)+a(M+6)*X_1(:,5)+a(M+7)*X_1(:,6)+a(M+8)*X_1(:,7)+a(M+9)*X_1(:,8)+sum(elem)'; %normalizada
        clear dist elem

        dist= pdist2(X_2,d);
        elem = a(1:M).*exp(-((dist.^2)/(2*c^2)))'; 
        S_2 = a(M+1)+a(M+2)*X_2(:,1)+a(M+3)*X_2(:,2)+a(M+4)*X_2(:,3)+a(M+5)*X_2(:,4)+a(M+6)*X_2(:,5)+a(M+7)*X_2(:,6)+a(M+8)*X_2(:,7)+a(M+9)*X_2(:,8)+sum(elem)'; %normalizada
        clear dist elem

        S = [S_1; S_2];

        save(['DATOS\RADIAL_BASIS_FUNCTION\DO\' fold_name '\' VAR '\' SC '\' OF '\' file_name '.mat'],'S')

    else

        load(['DATOS\RADIAL_BASIS_FUNCTION\DO\' fold_name '\' VAR '\' SC '\' OF '\' file_name '.mat'])  

    end
    
    
end

