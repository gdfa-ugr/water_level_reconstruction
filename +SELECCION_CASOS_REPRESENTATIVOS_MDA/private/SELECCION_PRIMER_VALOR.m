function   [x,d]=SELECCION_PRIMER_VALOR(x,Forzamiento_norm)

%Primera comprobación ¿Existe oleaje como forzamiento?
comp_oleaje=isfield(Forzamiento_norm,'O');
comp_oleaje_desembocadura=isfield(Forzamiento_norm,'OD');
comp_oleaje_desembocadura_sin_viento=isfield(Forzamiento_norm,'ODSV');
comp_m_meteo=isfield(Forzamiento_norm,'MM');
comp_descarga=isfield(Forzamiento_norm,'Q');

if comp_oleaje==0 && comp_m_meteo==0 && comp_oleaje_desembocadura==0 && comp_oleaje_desembocadura_sin_viento==0 % Caso 1 no hay ni olejae ni m.meteo
    
    % Caso 1, opción 1: Sólo tengo un forzamiento (O MA o Q)
    if length(x(1,:))==1
        
    tam=size(x);
    tam=tam(1); % Número de datos en la muestra

    % Me calculo la distancia de cada punto con los demás
    progressbar('Primer valor') % Init single bar
    for j=1:tam
        for k=1:tam      
          dist(k)=sqrt((x(j,1)-x(k,1))^2);   
        end
        %Cada posición es la Suma de distancias del elemento j al resto de elementos
        distancia(1,j)=sum(dist);
        progressbar(j/tam) % Update progress bar  
    end 

    %Cojo el que tiene la máxima distancia
    [~,pos]=max(distancia);
    %Lo almaceno en d
    d=x(pos,:);
    %Lo elimino de la matriz x
    [~,indx]=ismember(d,x,'rows');
    x(indx,:)=[]; 
    end
    
    % Caso 1, opción 2: Tengo dos forzamiento
    if length(x(1,:))==2
        
    tam=size(x);
    tam=tam(1); % Número de datos en la muestra
    
    % Me calculo la distancia de cada punto con los demás    
    progressbar('Primer valor') % Init single bar
    for j=1:tam
        for k=1:tam      
          dist(k)=sqrt((x(j,1)-x(k,1))^2+(x(j,2)-x(k,2))^2);   
        end
        %Cada posición es la Suma de distancias del elemento j al resto de elementos
        distancia(1,j)=sum(dist);
        progressbar(j/tam) % Update progress bar  
    end 
    
    %Cojo el que tiene la máxima distancia
    [~,pos]=max(distancia);
    %Lo almaceno en d
    d=x(pos,:);
    %Lo elimino de la matriz x
    [~,indx]=ismember(d,x,'rows');
    x(indx,:)=[]; 
    end
    
    
elseif comp_oleaje==1 && comp_m_meteo==0 && comp_oleaje_desembocadura==0 && comp_oleaje_desembocadura_sin_viento==0 % Caso 2 hay oleaje 
    
    % Caso 2, opción 1: Sólo tengo tres forzamientos H, T y Teta: Oleaje en
    % el contorno
    if length(x(1,:))==3
        
    tam=size(x);
    tam=tam(1); % Número de datos en la muestra

    % Me calculo la distancia de cada punto con los demás
    progressbar('Primer valor') % Init single bar
    for j=1:tam
        for k=1:tam
            minimo=min([abs(x(j,3)-x(k,3)) 2-abs(x(j,3)-x(k,3))]);
            dist(k)=sqrt((x(j,1)-x(k,1))^2+(x(j,2)-x(k,2))^2+(minimo)^2);   
            %dist(k,j)=sqrt((x(j,1)-x(k,1))^2+(x(j,2)-x(k,2))^2);   
        end
        %Cada posición es la Suma de distancias del elemento j al resto de elementos
        distancia(1,j)=sum(dist);
        progressbar(j/tam) % Update progress bar  
    end 

    %Cojo el que tiene la máxima distancia
    [~,pos]=max(distancia);
    %Lo almaceno en d
    d=x(pos,:);
    %Lo elimino de la matriz x
    [~,indx]=ismember(d,x,'rows');
    x(indx,:)=[]; 
    end
    
elseif comp_oleaje==0 && comp_m_meteo==0 && comp_oleaje_desembocadura==1 && comp_oleaje_desembocadura_sin_viento==0 % Caso 2' hay oleaje en la desembocadura
    
    % Caso 2', opción 1: Sólo tengo tres forzamientos H, T y Teta: Oleaje
    % en la desembocadura
    if length(x(1,:))==3
        
    tam=size(x);
    tam=tam(1); % Número de datos en la muestra
    
    progressbar('Primer valor') % Init single bar
    % Me calculo la distancia de cada punto con los demás
    for j=1:tam
        for k=1:tam
            minimo=min([abs(x(j,3)-x(k,3)) 2-abs(x(j,3)-x(k,3))]);
            dist(k)=sqrt((x(j,1)-x(k,1))^2+(x(j,2)-x(k,2))^2+(minimo)^2);   
            %dist(k,j)=sqrt((x(j,1)-x(k,1))^2+(x(j,2)-x(k,2))^2);   
        end
        %Cada posición es la Suma de distancias del elemento j al resto de elementos
        distancia(1,j)=sum(dist);
        progressbar(j/tam) % Update progress bar  
    end 

    %Cojo el que tiene la máxima distancia
    [~,pos]=max(distancia);
    %Lo almaceno en d
    d=x(pos,:);
    %Lo elimino de la matriz x
    [~,indx]=ismember(d,x,'rows');
    x(indx,:)=[]; 
    end
    
elseif comp_oleaje==0 && comp_m_meteo==0 && comp_oleaje_desembocadura==0 && comp_oleaje_desembocadura_sin_viento==1 % Caso 2'' hay oleaje en la desembocadura sin viento
    
    % Caso 2', opción 1: Sólo tengo tres forzamientos H, T y Teta: Oleaje
    % en la desembocadura sin viento
    if length(x(1,:))==3
        
    tam=size(x);
    tam=tam(1); % Número de datos en la muestra
    
    progressbar('Primer valor') % Init single bar
    % Me calculo la distancia de cada punto con los demás
    for j=1:tam
        for k=1:tam
            minimo=min([abs(x(j,3)-x(k,3)) 2-abs(x(j,3)-x(k,3))]);
            dist(k)=sqrt((x(j,1)-x(k,1))^2+(x(j,2)-x(k,2))^2+(minimo)^2);   
            %dist(k,j)=sqrt((x(j,1)-x(k,1))^2+(x(j,2)-x(k,2))^2);   
        end
        %Cada posición es la Suma de distancias del elemento j al resto de elementos
        distancia(1,j)=sum(dist);
        progressbar(j/tam) % Update progress bar  
    end 

    %Cojo el que tiene la máxima distancia
    [~,pos]=max(distancia);
    %Lo almaceno en d
    d=x(pos,:);
    %Lo elimino de la matriz x
    [~,indx]=ismember(d,x,'rows');
    x(indx,:)=[]; 
    end
    

elseif comp_oleaje==0 && comp_oleaje_desembocadura==0 && comp_m_meteo==1 && comp_oleaje_desembocadura_sin_viento==0 % Caso 3 hay m.meteo
    
    % Caso 3, opción 1: Sólo tengo tres forzamientos Vv y Teta y Pnm: Marea
    % meteorologica
    if length(x(1,:))==2
        
    tam=size(x);
    tam=tam(1); % Número de datos en la muestra
    
    progressbar('Primer valor') % Init single bar
    % Me calculo la distancia de cada punto con los demás
    for j=1:tam
        for k=1:tam
            minimo=min([abs(x(j,2)-x(k,2)) 2-abs(x(j,2)-x(k,2))]);
            dist(k)=sqrt((x(j,1)-x(k,1))^2+(minimo)^2+(x(j,3)-x(k,3))^2);   
            %dist(k,j)=sqrt((x(j,1)-x(k,1))^2+(x(j,2)-x(k,2))^2);   
        end
        %Cada posición es la Suma de distancias del elemento j al resto de elementos
        distancia(1,j)=sum(dist);
        progressbar(j/tam) % Update progress bar  
    end 

    %Cojo el que tiene la máxima distancia
    [~,pos]=max(distancia);
    %Lo almaceno en d
    d=x(pos,:);
    %Lo elimino de la matriz x
    [~,indx]=ismember(d,x,'rows');
    x(indx,:)=[]; 
    end
    
    

elseif comp_oleaje==1 && comp_m_meteo==1 && comp_oleaje_desembocadura==0 && comp_oleaje_desembocadura_sin_viento==0 % Caso 4 hay oleaje y m.meteo
    
    % Caso 4, opción 1: Sólo tengo cinco forzamientos H, T, Teta,Vv y Teta:
    % Oleaje y viento para propagar el oleaje con viento
    if length(x(1,:))==5
        
    tam=size(x);
    tam=tam(1); % Número de datos en la muestra
    
    progressbar('Primer valor') % Init single bar
    % Me calculo la distancia de cada punto con los demás
    for j=1:tam
        for k=1:tam
            minimo_teta_oleaje=min([abs(x(j,3)-x(k,3)) 2-abs(x(j,3)-x(k,3))]);
            minimo_teta_viento=min([abs(x(j,5)-x(k,5)) 2-abs(x(j,5)-x(k,5))]);
            
            dist(k)=sqrt((x(j,1)-x(k,1))^2+(x(j,2)-x(k,2))^2+(minimo_teta_oleaje)^2+(x(j,4)-x(k,4))^2+(minimo_teta_viento)^2);   
            %dist(k,j)=sqrt((x(j,1)-x(k,1))^2+(x(j,2)-x(k,2))^2);   
        end
        %Cada posición es la Suma de distancias del elemento j al resto de elementos
        distancia(1,j)=sum(dist);
        progressbar(j/tam) % Update progress bar  
    end 

    %Cojo el que tiene la máxima distancia
    [~,pos]=max(distancia);
    %Lo almaceno en d
    d=x(pos,:);
    %Lo elimino de la matriz x
    [~,indx]=ismember(d,x,'rows');
    x(indx,:)=[]; 
    end
    
elseif comp_descarga == 0 && comp_oleaje==0 && comp_m_meteo==1 && comp_oleaje_desembocadura==1 && comp_oleaje_desembocadura_sin_viento==0 % Caso 4 hay oleaje y m.meteo
    
    % Caso 4, opción 1: Sólo tengo cinco forzamientos H, T, Teta,Vv y Teta:
    % Oleaje y viento para propagar el oleaje con viento
    if length(x(1,:))==6
        
    tam=size(x);
    tam=tam(1); % Número de datos en la muestra
    
    progressbar('Primer valor') % Init single bar
    % Me calculo la distancia de cada punto con los demás
    for j=1:tam
        for k=1:tam
            minimo_teta_oleaje=min([abs(x(j,3)-x(k,3)) 2-abs(x(j,3)-x(k,3))]);
            minimo_teta_viento=min([abs(x(j,5)-x(k,5)) 2-abs(x(j,5)-x(k,5))]);
            
            dist(k)=sqrt((x(j,1)-x(k,1))^2+(x(j,2)-x(k,2))^2+(minimo_teta_oleaje)^2+(x(j,4)-x(k,4))^2+(minimo_teta_viento)^2+(x(j,6)-x(k,6))^2);   
            %dist(k,j)=sqrt((x(j,1)-x(k,1))^2+(x(j,2)-x(k,2))^2);   
        end
        %Cada posición es la Suma de distancias del elemento j al resto de elementos
        distancia(1,j)=sum(dist);
        progressbar(j/tam) % Update progress bar  
    end 

    %Cojo el que tiene la máxima distancia
    [~,pos]=max(distancia);
    %Lo almaceno en d
    d=x(pos,:);
    %Lo elimino de la matriz x
    [~,indx]=ismember(d,x,'rows');
    x(indx,:)=[]; 
    end
    
elseif comp_descarga == 1 && comp_oleaje_desembocadura==1 && comp_m_meteo==1 && comp_oleaje==0 && comp_oleaje_desembocadura_sin_viento==0 % Caso 5 Oleaje en la desembocadura y m.meteo 

    % Caso 5, opción 1: Lo tengo todo: Oleaje en la desembocadura, marea
    % meteo, descarga y marea astronómica
        
    tam=size(x);
    tam=tam(1); % Número de datos en la muestra
    
    progressbar('Primer valor') % Init single bar    
    % Me calculo la distancia de cada punto con los demás
    for j=1:tam
        for k=1:tam
            minimo_teta_oleaje=min([abs(x(j,5)-x(k,5)) 2-abs(x(j,5)-x(k,5))]);
            minimo_teta_viento=min([abs(x(j,7)-x(k,7)) 2-abs(x(j,7)-x(k,7))]);
            
            dist(k)=sqrt((x(j,1)-x(k,1))^2+(x(j,2)-x(k,2))^2+(x(j,3)-x(k,3))^2+(x(j,4)-x(k,4))^2+(minimo_teta_oleaje)^2+(x(j,6)-x(k,6))^2+(minimo_teta_viento)^2+(x(j,8)-x(k,8))^2);   
            %dist(k,j)=sqrt((x(j,1)-x(k,1))^2+(x(j,2)-x(k,2))^2);   
        end
        %Cada posición es la Suma de distancias del elemento j al resto de elementos
        distancia(1,j)=sum(dist);
        progressbar(j/tam) % Update progress bar  
    end 

    %Cojo el que tiene la máxima distancia
    [~,pos]=max(distancia);
    %Lo almaceno en d
    d=x(pos,:);
    %Lo elimino de la matriz x
    [~,indx]=ismember(d,x,'rows');
    x(indx,:)=[]; 
    
    
elseif comp_descarga == 0 && comp_oleaje_desembocadura==1 && comp_m_meteo==1 && comp_oleaje==0 && comp_oleaje_desembocadura_sin_viento==0 % Caso 5 Oleaje en la desembocadura y m.meteo 

    % Caso 5, opción 2: Lo tengo todo sin caudal: Oleaje en la desembocadura, marea
    % meteo y marea astronómica
        
    tam=size(x);
    tam=tam(1); % Número de datos en la muestra
    
    progressbar('Primer valor') % Init single bar    
    % Me calculo la distancia de cada punto con los demás
    for j=1:tam
        for k=1:tam
            minimo_teta_oleaje=min([abs(x(j,4)-x(k,4)) 2-abs(x(j,4)-x(k,4))]);
            minimo_teta_viento=min([abs(x(j,6)-x(k,6)) 2-abs(x(j,6)-x(k,6))]);
            
            dist(k)=sqrt((x(j,1)-x(k,1))^2+(x(j,2)-x(k,2))^2+(x(j,3)-x(k,3))^2+(minimo_teta_oleaje)^2+(x(j,5)-x(k,5))^2+(minimo_teta_viento)^2+(x(j,7)-x(k,7))^2);   
            %dist(k,j)=sqrt((x(j,1)-x(k,1))^2+(x(j,2)-x(k,2))^2);   
        end
        %Cada posición es la Suma de distancias del elemento j al resto de elementos
        distancia(1,j)=sum(dist);
        progressbar(j/tam) % Update progress bar  
    end 

    %Cojo el que tiene la máxima distancia
    [~,pos]=max(distancia);
    %Lo almaceno en d
    d=x(pos,:);
    %Lo elimino de la matriz x
    [~,indx]=ismember(d,x,'rows');
    x(indx,:)=[]; 

    
    
end





end