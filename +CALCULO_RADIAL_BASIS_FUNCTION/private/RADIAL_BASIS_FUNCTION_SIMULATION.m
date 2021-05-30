function S=RADIAL_BASIS_FUNCTION_SIMULATION(Forzamiento,c,F,M,PC,VAR,d,X,Forz_input)

warning('')

%Primera comprobaci�n �Existe oleaje como forzamiento?
comp_oleaje=isfield(Forzamiento,'O');
comp_oleaje_desembocadura=isfield(Forzamiento,'OD');
comp_oleaje_desembocadura_sin_viento=isfield(Forzamiento,'ODSV');
comp_m_meteo=isfield(Forzamiento,'MM');

%Obtengo los forzamientos que se han elegido
names = fieldnames(Forzamiento);
l=length(names);

if  comp_oleaje==0 && comp_m_meteo==0 && comp_oleaje_desembocadura==0 && comp_oleaje_desembocadura_sin_viento==0 % Caso 1 no hay ni olejae ni m.meteo
    % En el caso 1, s�lo puedo tener MA o Q o ambos
    if Forz_input.MA==1 && Forz_input.Q==0 %Caso 1 Opci�n 1: Tengo s�lo MA
        f=F.MA.WL;
        
        %Creo una carpeta diferente para cada combinaci�n de agentes en la que voy
        %a guardar los valores de f para no tener que cargarlos cada vez
        fold_name='';
        for j=1:l
           fold_name=[fold_name char(names(j)),'_']; 
        end

        %Creo la carpeta dentro de datos
        addpath('\DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE')
        mkdir(['DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE\' fold_name '\' VAR])
        addpath(['DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE\' fold_name '\' VAR])

        %Busco si existe un fichero con M puntos de la muestra o m�s
        file_name=[fold_name VAR '_' 'M=' num2str(M) '_PC_' num2str(PC(1)) '_' num2str(PC(2))];

        % Compruebo si hay archivos en la carpeta, si los hay los cargo para ver si
        % son mayores al n�mero de valores de la muestra que deseo. Si no hay o el
        % n�mero de valores es menor aplico el proceso de selecci�n mediante MDA
        s = what(['DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE\' fold_name '\' VAR]);
        files=s(1,1).mat;

        if exist(['DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE\' fold_name '\' VAR '\' file_name '.mat'])==0 %Si no existe el archivo espec�fico
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
            progressbar('Interpolaci�n mediante RBF') % Init single bar
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
        
    elseif Forz_input.MA_DESPLAZ==1 && Forz_input.Q==0 %Caso 1 Opci�n 1: Tengo s�lo MA_DESPLAZ
        f=F.MA_DESPLAZ.WL;
        
        %Creo una carpeta diferente para cada combinaci�n de agentes en la que voy
        %a guardar los valores de f para no tener que cargarlos cada vez
        fold_name='';
        for j=1:1
           fold_name=[fold_name char(names(j)),'_']; 
        end

        %Creo la carpeta dentro de datos
        addpath('\DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE')
        mkdir(['DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE\' fold_name '\' VAR])
        addpath(['DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE\' fold_name '\' VAR])

        %Busco si existe un fichero con M puntos de la muestra o m�s
        file_name=[fold_name VAR '_' 'M=' num2str(M) '_PC_' num2str(PC(1)) '_' num2str(PC(2))];

        % Compruebo si hay archivos en la carpeta, si los hay los cargo para ver si
        % son mayores al n�mero de valores de la muestra que deseo. Si no hay o el
        % n�mero de valores es menor aplico el proceso de selecci�n mediante MDA
        s = what(['DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE\' fold_name '\' VAR]);
        files=s(1,1).mat;

        if exist(['DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE\' fold_name '\' VAR '\' file_name '.mat'])==0 %Si no existe el archivo espec�fico
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
            progressbar('Interpolaci�n mediante RBF') % Init single bar
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
        
    elseif  Forz_input.MA==0 && Forz_input.Q==1 %Caso 1 Opci�n 2: Tengo s�lo Q
       
        f=F.Q.WL;        
        %Creo una carpeta diferente para cada combinaci�n de agentes en la que voy
        %a guardar los valores de f para no tener que cargarlos cada vez
        fold_name='';
        for j=1:l
           fold_name=[fold_name char(names(j)),'_']; 
        end

        %Creo la carpeta dentro de datos
        addpath('\DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE')
        mkdir(['DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE\' fold_name '\' VAR])
        addpath(['DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE\' fold_name '\' VAR])

        %Busco si existe un fichero con M puntos de la muestra o m�s
        file_name=[fold_name VAR '_' 'M=' num2str(M) '_PC_' num2str(PC(1)) '_' num2str(PC(2))];

        % Compruebo si hay archivos en la carpeta, si los hay los cargo para ver si
        % son mayores al n�mero de valores de la muestra que deseo. Si no hay o el
        % n�mero de valores es menor aplico el proceso de selecci�n mediante MDA
        s = what(['DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE\' fold_name '\' VAR]);
        files=s(1,1).mat;

        if exist(['DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE\' fold_name '\' VAR '\' file_name '.mat'])==0 %Si no existe el archivo espec�fico
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
            progressbar('Interpolaci�n mediante RBF') % Init single bar
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
%         plot(Forzamiento.Q.q,'k')
%         grid on
%         sub(2)=subplot(2,1,2);
%         plot(S,'r')
%         grid on
%         linkaxes([sub],'x')
    end

elseif  comp_oleaje==0 && comp_m_meteo==1 && comp_oleaje_desembocadura==0 && comp_oleaje_desembocadura_sin_viento==0 % Caso 2 S�lo tengo m.meteo

        f=F.MM.WL;        
        %Creo una carpeta diferente para cada combinaci�n de agentes en la que voy
        %a guardar los valores de f para no tener que cargarlos cada vez
        fold_name='';
        for j=1:l
           fold_name=[fold_name char(names(j)),'_']; 
        end

        %Creo la carpeta dentro de datos
        addpath('\DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE')
        mkdir(['DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE\' fold_name '\' VAR])
        addpath(['DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE\' fold_name '\' VAR])

        %Busco si existe un fichero con M puntos de la muestra o m�s
        file_name=[fold_name VAR '_' 'M=' num2str(M) '_PC_' num2str(PC(1)) '_' num2str(PC(2))];

        % Compruebo si hay archivos en la carpeta, si los hay los cargo para ver si
        % son mayores al n�mero de valores de la muestra que deseo. Si no hay o el
        % n�mero de valores es menor aplico el proceso de selecci�n mediante MDA
        s = what(['DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE\' fold_name '\' VAR]);
        files=s(1,1).mat;

        if exist(['DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE\' fold_name '\' VAR '\' file_name '.mat'])==0 %Si no existe el archivo espec�fico
            % En primer lugar calculo la primera parte de la matriz A (A_reducida)
            for i=1:M
                for j=1:M
                    minimo_teta_viento=min([abs(d(i,2)-d(j,2)) 2-abs(d(i,2)-d(j,2))]);

                    dist=sqrt((d(i,1)-d(j,1))^2+minimo_teta_viento^2);
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
            progressbar('Interpolaci�n mediante RBF') % Init single bar
            for k=1:length(X(:,1))    
                for j=1:M
                   minimo_teta_viento=min([abs(X(k,2)-d(j,2)) 2-abs(X(k,2)-d(j,2))]);
               
                   dist=sqrt((X(k,1)-d(j,1))^2+minimo_teta_viento^2); 
                   elem(j)= a(j)*exp(-((dist^2)/(2*c^2))); 
                end    

                S(k)=a(M+1)+a(M+2)*X(k,1)+a(M+3)*X(k,2)+sum(elem);   %normalizada
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
    
    
elseif  comp_oleaje==0 && comp_m_meteo==0 && comp_oleaje_desembocadura==0 && comp_oleaje_desembocadura_sin_viento==1 % Caso 3 S�lo tengo oleaje en la desembocadura sin viento

        f=F.ODSV.WL;        
        %Creo una carpeta diferente para cada combinaci�n de agentes en la que voy
        %a guardar los valores de f para no tener que cargarlos cada vez
        fold_name='';
        for j=1:l
           fold_name=[fold_name char(names(j)),'_']; 
        end

        %Creo la carpeta dentro de datos
        addpath('\DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE')
        mkdir(['DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE\' fold_name '\' VAR])
        addpath(['DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE\' fold_name '\' VAR])

        %Busco si existe un fichero con M puntos de la muestra o m�s
        file_name=[fold_name VAR '_' 'M=' num2str(M) '_PC_' num2str(PC(1)) '_' num2str(PC(2))];

        % Compruebo si hay archivos en la carpeta, si los hay los cargo para ver si
        % son mayores al n�mero de valores de la muestra que deseo. Si no hay o el
        % n�mero de valores es menor aplico el proceso de selecci�n mediante MDA
        s = what(['DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE\' fold_name '\' VAR]);
        files=s(1,1).mat;

        if exist(['DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE\' fold_name '\' VAR '\' file_name '.mat'])==0 %Si no existe el archivo espec�fico
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
            progressbar('Interpolaci�n mediante RBF') % Init single bar
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
    
    
elseif  comp_oleaje==0 && comp_m_meteo==1 && comp_oleaje_desembocadura==1 && comp_oleaje_desembocadura_sin_viento==0 % Caso 4 Tengo Oleaje en la desembocadura con viento m�s marea meteorol�gica    

        % En el caso 4, lo tengo todo
        f=F.MA_Q_MM_OD.WL;       
        
        %Creo una carpeta diferente para cada combinaci�n de agentes en la que voy
        %a guardar los valores de f para no tener que cargarlos cada vez
        fold_name='';
        for j=1:l
           fold_name=[fold_name char(names(j)),'_']; 
        end

        %Creo la carpeta dentro de datos
        addpath('\DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE')
        mkdir(['DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE\' fold_name '\' VAR])
        addpath(['DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE\' fold_name '\' VAR])

        %Busco si existe un fichero con M puntos de la muestra o m�s
        file_name=[fold_name VAR '_' 'M=' num2str(M) '_PC_' num2str(PC(1)) '_' num2str(PC(2))];

        % Compruebo si hay archivos en la carpeta, si los hay los cargo para ver si
        % son mayores al n�mero de valores de la muestra que deseo. Si no hay o el
        % n�mero de valores es menor aplico el proceso de selecci�n mediante MDA
        s = what(['DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE\' fold_name '\' VAR]);
        files=s(1,1).mat;

        if exist(['DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE\' fold_name '\' VAR '\' file_name '.mat'])==0 %Si no existe el archivo espec�fico
            % En primer lugar calculo la primera parte de la matriz A (A_reducida)
            for i=1:M
                for j=1:M
                    minimo_teta_oleaje=min([abs(d(i,7)-d(j,7)) 2-abs(d(i,7)-d(j,7))]);
                    minimo_teta_viento=min([abs(d(i,4)-d(j,4)) 2-abs(d(i,4)-d(j,4))]);

                    dist=sqrt((d(i,1)-d(j,1))^2+(d(i,2)-d(j,2))^2+(d(i,3)-d(j,3))^2+minimo_teta_viento^2+(d(i,5)-d(j,5))^2+(d(i,6)-d(j,6))^2+minimo_teta_oleaje^2);
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
            progressbar('Interpolaci�n mediante RBF') % Init single bar
            for k=1:length(X(:,1))    
                for j=1:M
                   minimo_teta_oleaje=min([abs(X(k,7)-d(j,7)) 2-abs(X(k,7)-d(j,7))]);
                   minimo_teta_viento=min([abs(X(k,4)-d(j,4)) 2-abs(X(k,4)-d(j,4))]);
               
                   dist=sqrt((X(k,1)-d(j,1))^2+(X(k,2)-d(j,2))^2+(X(k,3)-d(j,3))^2+minimo_teta_viento^2+(X(k,5)-d(j,5))^2+(X(k,6)-d(j,6))^2+minimo_teta_oleaje^2); 
                   elem(j)= a(j)*exp(-((dist^2)/(2*c^2))); 
                end    

                S(k)=a(M+1)+a(M+2)*X(k,1)+a(M+3)*X(k,2)+a(M+4)*X(k,3)+a(M+5)*X(k,4)+a(M+6)*X(k,5)+a(M+7)*X(k,6)+a(M+8)*X(k,7)+sum(elem);   %normalizada 
                progressbar(k/length(X(:,1))) % Update progress bar
            end
            
            save(['DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE\' fold_name '\' VAR '\' file_name '.mat'],'S')

        else

            load(['DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE\' fold_name '\' VAR '\' file_name '.mat'])     

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

elseif comp_oleaje==1 && comp_m_meteo==0 % Caso 1 S�lo tengo oleaje
    
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
        
    %Creo una carpeta diferente para cada combinaci�n de agentes en la que voy
    %a guardar los valores de f para no tener que cargarlos cada vez
    fold_name='';
    for j=1:l
       fold_name=[fold_name char(names(j)),'_']; 
    end

    %Creo la carpeta dentro de datos
    addpath('\DATOS\RADIAL_BASIS_FUNCTION\PROPAGACION_REGIMEN_MEDIO')
    mkdir(['DATOS\RADIAL_BASIS_FUNCTION\PROPAGACION_REGIMEN_MEDIO\' fold_name '\' VAR])
    addpath(['DATOS\RADIAL_BASIS_FUNCTION\PROPAGACION_REGIMEN_MEDIO\' fold_name '\' VAR])

    %Busco si existe un fichero con M puntos de la muestra o m�s
    file_name=[fold_name VAR '_' 'M=' num2str(M) '_PC=' num2str(PC)];

    % Compruebo si hay archivos en la carpeta, si los hay los cargo para ver si
    % son mayores al n�mero de valores de la muestra que deseo. Si no hay o el
    % n�mero de valores es menor aplico el proceso de selecci�n mediante MDA
    s = what(['DATOS\RADIAL_BASIS_FUNCTION\PROPAGACION_REGIMEN_MEDIO\' fold_name '\' VAR]);
    files=s(1,1).mat;
    
    if exist(['DATOS\RADIAL_BASIS_FUNCTION\PROPAGACION_REGIMEN_MEDIO\' fold_name '\' VAR '\' file_name '.mat'])==0 %Si no existe el archivo espec�fico
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
        progressbar('Interpolaci�n mediante RBF') % Init single bar
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
        
    %Creo una carpeta diferente para cada combinaci�n de agentes en la que voy
    %a guardar los valores de f para no tener que cargarlos cada vez
    fold_name='';
    for j=1:l
       fold_name=[fold_name char(names(j)),'_']; 
    end

    %Creo la carpeta dentro de datos
    addpath('\DATOS\RADIAL_BASIS_FUNCTION\PROPAGACION_REGIMEN_MEDIO')
    mkdir(['DATOS\RADIAL_BASIS_FUNCTION\PROPAGACION_REGIMEN_MEDIO\' fold_name '\' VAR])
    addpath(['DATOS\RADIAL_BASIS_FUNCTION\PROPAGACION_REGIMEN_MEDIO\' fold_name '\' VAR])

    %Busco si existe un fichero con M puntos de la muestra o m�s
    file_name=[fold_name VAR '_' 'M=' num2str(M) '_PC=' num2str(PC)];

    % Compruebo si hay archivos en la carpeta, si los hay los cargo para ver si
    % son mayores al n�mero de valores de la muestra que deseo. Si no hay o el
    % n�mero de valores es menor aplico el proceso de selecci�n mediante MDA
    s = what(['DATOS\RADIAL_BASIS_FUNCTION\PROPAGACION_REGIMEN_MEDIO\' fold_name '\' VAR]);
    files=s(1,1).mat;
    
    if exist(['DATOS\RADIAL_BASIS_FUNCTION\PROPAGACION_REGIMEN_MEDIO\' fold_name '\' VAR '\' file_name '.mat'])==0 %Si no existe el archivo espec�fico
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
        progressbar('Interpolaci�n mediante RBF') % Init single bar
        for k=1:length(X(:,1))    
            for j=1:M
               minimo_teta_oleaje=min([abs(X(k,3)-d(j,3)) 2-abs(X(k,3)-d(j,3))]);
               minimo_teta_viento=min([abs(X(k,5)-d(j,5)) 2-abs(X(k,5)-d(j,5))]);
               
               dist=sqrt((X(k,1)-d(j,1))^2+(X(k,2)-d(j,2))^2+minimo_teta_oleaje^2+(X(k,4)-d(j,4))^2+minimo_teta_viento^2); 
               elem(j)= a(j)*exp(-((dist^2)/(2*c^2))); 
            end    

            S(k)=a(M+1)+a(M+2)*X(k,1)+a(M+3)*X(k,2)+a(M+4)*X(k,3)+a(M+5)*X(k,4)+a(M+6)*X(k,5)+sum(elem);   %normalizada 
            progressbar(k/length(X(:,1))) % Update progress bar
        end
       
        
        save(['DATOS\RADIAL_BASIS_FUNCTION\PROPAGACION_REGIMEN_MEDIO\' fold_name '\' VAR '\' file_name '.mat'],'S')
        
    else
    
        load(['DATOS\RADIAL_BASIS_FUNCTION\PROPAGACION_REGIMEN_MEDIO\' fold_name '\' VAR '\' file_name '.mat'])     
    
    end

end