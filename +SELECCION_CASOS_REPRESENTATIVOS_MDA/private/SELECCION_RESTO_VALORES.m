function [x,d]=SELECCION_RESTO_VALORES(x,d,m,Forzamiento_norm)   

%Primera comprobación ¿Existe oleaje como forzamiento?
comp_oleaje=isfield(Forzamiento_norm,'O');
comp_oleaje_desembocadura=isfield(Forzamiento_norm,'OD');
comp_oleaje_desembocadura_sin_viento=isfield(Forzamiento_norm,'ODSV');
comp_m_meteo=isfield(Forzamiento_norm,'MM');
comp_descarga=isfield(Forzamiento_norm,'Q');

if comp_oleaje==0 && comp_m_meteo==0 && comp_oleaje_desembocadura==0 && comp_oleaje_desembocadura_sin_viento==0 % Caso 1 no hay ni olejae ni m.meteo
    
    % Caso 1, opción 1: Sólo tengo un forzamiento: MA o Q
    if length(x(1,:))==1

    % Calculo el tamaño de los vectores d y x
    l=size(d);
    l=l(1);
    tam=size(x);
    tam=tam(1);

    % Calculo la distancia de cada elemento a los elementos de d
    for j=1:tam   
        for k=1:l       
            dist(k)=sqrt((x(j,1)-d(k,1))^2);        
        end
        %Para cada elemento (fila) calculo el minimo de la distancia a cada valor
        %de la muestra (columna)
        min_dist(j,1)=min(dist);
        progressbar([],j/tam) % Update progress bar 
    end

    %De todos ellos cojo el máximo. Método min-max
    [~,pos]=max(min_dist);
    d(m,:)=x(pos,:);
    l=size(d);
    l=l(1);

    %Elimino el valor de la muestra
    [~,indx]=ismember(d(l,:),x,'rows');
    x(indx,:)=[];

    end
    
% Caso 1, opción 2: Sólo tengo un forzamiento
    if length(x(1,:))==2

    % Calculo el tamaño de los vectores d y x
    l=size(d);
    l=l(1);
    tam=size(x);
    tam=tam(1);

    %Inicializo la variable para darle un tamaño inicial (Rapidez cálculo)
    dist=zeros(tam,l);

    % Calculo la distancia de cada elemento a los elementos de d
    for j=1:tam   
        for k=1:l       
            dist(k)=sqrt((x(j,1)-d(k,1))^2+(x(j,2)-d(k,2))^2);           
        end 
        %Para cada elemento (fila) calculo el minimo de la distancia a cada valor
        %de la muestra (columna)
        min_dist(j,1)=min(dist);
        progressbar([],j/tam) % Update 2nd bar
    end

    %De todos ellos cojo el máximo. Método min-max
    [~,pos]=max(min_dist);
    d(m,:)=x(pos,:);
    l=size(d);
    l=l(1);

    %Elimino el valor de la muestra
    [~,indx]=ismember(d(l,:),x,'rows');
    x(indx,:)=[];

    end
    
elseif comp_oleaje==1 && comp_m_meteo==0 && comp_oleaje_desembocadura==0 && comp_oleaje_desembocadura_sin_viento==0 % Caso 2 hay oleaje 
    
    % Caso 2, opción 1: Sólo tengo tres forzamientos H, T y Teta: Oleaje en
    % el contorno
    if length(x(1,:))==3
        
    % Calculo el tamaño de los vectores d y x
    l=size(d);
    l=l(1);
    tam=size(x);
    tam=tam(1);


    % Calculo la distancia de cada elemento a los elementos de d
    for j=1:tam   
        for k=1:l
            minimo=min([abs(x(j,3)-d(k,3)) 2-abs(x(j,3)-d(k,3))]);
            dist(k)=sqrt((x(j,1)-d(k,1))^2+(x(j,2)-d(k,2))^2+(minimo)^2);           
            %dist(j,k)=sqrt((x(j,1)-d(k,1))^2+(x(j,2)-d(k,2))^2);           
        end 
        %Para cada elemento (fila) calculo el minimo de la distancia a cada valor
        %de la muestra (columna)
        min_dist(j,1)=min(dist);
        progressbar([],j/tam) % Update progress bar 
    end


    %De todos ellos cojo el máximo. Método min-max
    [~,pos]=max(min_dist);
    d(m,:)=x(pos,:);
    l=size(d);
    l=l(1);

    %Elimino el valor de la muestra
    [~,indx]=ismember(d(l,:),x,'rows');
    x(indx,:)=[];
    
    end
    
    
elseif comp_oleaje==0 && comp_m_meteo==0 && comp_oleaje_desembocadura==1 && comp_oleaje_desembocadura_sin_viento==0 % Caso 2' hay oleaje en la desembocadura
    
    % Caso 2, opción 1: Sólo tengo tres forzamientos H, T y Teta: Oleaje en
    % la desembocadura
    if length(x(1,:))==3
        
    % Calculo el tamaño de los vectores d y x
    l=size(d);
    l=l(1);
    tam=size(x);
    tam=tam(1);

    % Calculo la distancia de cada elemento a los elementos de d
    for j=1:tam   
        for k=1:l
            minimo=min([abs(x(j,3)-d(k,3)) 2-abs(x(j,3)-d(k,3))]);
            dist(k)=sqrt((x(j,1)-d(k,1))^2+(x(j,2)-d(k,2))^2+(minimo)^2);           
            %dist(j,k)=sqrt((x(j,1)-d(k,1))^2+(x(j,2)-d(k,2))^2);           
        end 
        %Para cada elemento (fila) calculo el minimo de la distancia a cada valor
        %de la muestra (columna)
        min_dist(j,1)=min(dist);
        progressbar([],j/tam) % Update progress bar 
    end

    %De todos ellos cojo el máximo. Método min-max
    [~,pos]=max(min_dist);
    d(m,:)=x(pos,:);
    l=size(d);
    l=l(1);

    %Elimino el valor de la muestra
    [~,indx]=ismember(d(l,:),x,'rows');
    x(indx,:)=[];
    
    end
    
elseif comp_oleaje==0 && comp_m_meteo==0 && comp_oleaje_desembocadura==0 && comp_oleaje_desembocadura_sin_viento==1 % Caso 2'' hay oleaje en la desembocadura sin viento
    
    % Caso 2, opción 1: Sólo tengo tres forzamientos H, T y Teta: Oleaje en
    % la desembocadura sin viento
    if length(x(1,:))==3
        
    % Calculo el tamaño de los vectores d y x
    l=size(d);
    l=l(1);
    tam=size(x);
    tam=tam(1);

    % Calculo la distancia de cada elemento a los elementos de d
    for j=1:tam   
        for k=1:l
            minimo=min([abs(x(j,3)-d(k,3)) 2-abs(x(j,3)-d(k,3))]);
            dist(k)=sqrt((x(j,1)-d(k,1))^2+(x(j,2)-d(k,2))^2+(minimo)^2);           
            %dist(j,k)=sqrt((x(j,1)-d(k,1))^2+(x(j,2)-d(k,2))^2);           
        end 
        %Para cada elemento (fila) calculo el minimo de la distancia a cada valor
        %de la muestra (columna)
        min_dist(j,1)=min(dist);
        progressbar([],j/tam) % Update progress bar 
    end

    %De todos ellos cojo el máximo. Método min-max
    [~,pos]=max(min_dist);
    d(m,:)=x(pos,:);
    l=size(d);
    l=l(1);

    %Elimino el valor de la muestra
    [~,indx]=ismember(d(l,:),x,'rows');
    x(indx,:)=[];
    
    end
        
elseif comp_oleaje==0 && comp_m_meteo==1 && comp_oleaje_desembocadura==0 && comp_oleaje_desembocadura_sin_viento==0 % Caso 3 Marea Meteorologica  
    
    % Caso 3, opción 1: Sólo tengo tres forzamientos Vv y Teta y Pnm
    if length(x(1,:))==2
        
    % Calculo el tamaño de los vectores d y x
    l=size(d);
    l=l(1);
    tam=size(x);
    tam=tam(1);

    % Calculo la distancia de cada elemento a los elementos de d
    for j=1:tam   
        for k=1:l
            minimo=min([abs(x(j,2)-d(k,2)) 2-abs(x(j,2)-d(k,2))]);
            dist(k)=sqrt((x(j,1)-d(k,1))^2+(minimo)^2+(x(j,3)-d(k,3))^2);           
            %dist(j,k)=sqrt((x(j,1)-d(k,1))^2+(x(j,2)-d(k,2))^2);           
        end 
        %Para cada elemento (fila) calculo el minimo de la distancia a cada valor
        %de la muestra (columna)
        min_dist(j,1)=min(dist);
        progressbar([],j/tam) % Update progress bar 
    end

    %De todos ellos cojo el máximo. Método min-max
    [~,pos]=max(min_dist);
    d(m,:)=x(pos,:);
    l=size(d);
    l=l(1);

    %Elimino el valor de la muestra
    [~,indx]=ismember(d(l,:),x,'rows');
    x(indx,:)=[];
    
    end
elseif comp_oleaje==1 && comp_m_meteo==1 && comp_oleaje_desembocadura==0 && comp_oleaje_desembocadura_sin_viento==0 % Caso 4 hay oleaje y Marea Meteorológica
    
    % Caso 4, opción 1: Sólo tengo cinco forzamientos H, T, Teta, Vv y
    % Teta: Oleaje y viento en el contorno
    if length(x(1,:))==5
        
    % Calculo el tamaño de los vectores d y x
    l=size(d);
    l=l(1);
    tam=size(x);
    tam=tam(1);

    % Calculo la distancia de cada elemento a los elementos de d
    for j=1:tam   
        for k=1:l
            minimo_teta_oleaje=min([abs(x(j,3)-d(k,3)) 2-abs(x(j,3)-d(k,3))]);
            minimo_teta_viento=min([abs(x(j,5)-d(k,5)) 2-abs(x(j,5)-d(k,5))]);
                
            dist(k)=sqrt((x(j,1)-d(k,1))^2+(x(j,2)-d(k,2))^2+(minimo_teta_oleaje)^2+(x(j,4)-d(k,4))^2+(minimo_teta_viento)^2);   
            %dist(j,k)=sqrt((x(j,1)-d(k,1))^2+(x(j,2)-d(k,2))^2);           
        end 
        %Para cada elemento (fila) calculo el minimo de la distancia a cada valor
        %de la muestra (columna)
        min_dist(j,1)=min(dist);
        progressbar([],j/tam) % Update progress bar 
    end

    %De todos ellos cojo el máximo. Método min-max
    [~,pos]=max(min_dist);
    d(m,:)=x(pos,:);
    l=size(d);
    l=l(1);

    %Elimino el valor de la muestra
    [~,indx]=ismember(d(l,:),x,'rows');
    x(indx,:)=[];
    
    end 
    
elseif comp_descarga == 0 && comp_oleaje==0 && comp_m_meteo==1 && comp_oleaje_desembocadura==1 && comp_oleaje_desembocadura_sin_viento==0 % Caso 4 hay oleaje y Marea Meteorológica
    
    % Caso 4, opción 1: Sólo tengo cinco forzamientos H, T, Teta, Vv y
    % Teta: Oleaje y viento en el contorno
    if length(x(1,:))==6
        
    % Calculo el tamaño de los vectores d y x
    l=size(d);
    l=l(1);
    tam=size(x);
    tam=tam(1);

    % Calculo la distancia de cada elemento a los elementos de d
    for j=1:tam   
        for k=1:l
            minimo_teta_oleaje=min([abs(x(j,3)-d(k,3)) 2-abs(x(j,3)-d(k,3))]);
            minimo_teta_viento=min([abs(x(j,5)-d(k,5)) 2-abs(x(j,5)-d(k,5))]);
                
            dist(k)=sqrt((x(j,1)-d(k,1))^2+(x(j,2)-d(k,2))^2+(minimo_teta_oleaje)^2+(x(j,4)-d(k,4))^2+(minimo_teta_viento)^2+(x(j,6)-d(k,6))^2);   
            %dist(j,k)=sqrt((x(j,1)-d(k,1))^2+(x(j,2)-d(k,2))^2);           
        end 
        %Para cada elemento (fila) calculo el minimo de la distancia a cada valor
        %de la muestra (columna)
        min_dist(j,1)=min(dist);
        progressbar([],j/tam) % Update progress bar 
    end

    %De todos ellos cojo el máximo. Método min-max
    [~,pos]=max(min_dist);
    d(m,:)=x(pos,:);
    l=size(d);
    l=l(1);

    %Elimino el valor de la muestra
    [~,indx]=ismember(d(l,:),x,'rows');
    x(indx,:)=[];
    
    end 
    
elseif comp_descarga == 1 && comp_oleaje_desembocadura==1 && comp_m_meteo==1 && comp_oleaje==0 && comp_oleaje_desembocadura_sin_viento==0 % Caso 5 hay Oleaje en la desembocadura y Marea meteorológica
    
    % Caso 5, opción 1: Lo tengo todo: Oleaje en la desembocadura, marea
    % meteo, descarga y marea astronómica

        
    % Calculo el tamaño de los vectores d y x
    l=size(d);
    l=l(1);
    tam=size(x);
    tam=tam(1);


    % Calculo la distancia de cada elemento a los elementos de d
    for j=1:tam   
        for k=1:l
            minimo_teta_oleaje=min([abs(x(j,5)-d(k,5)) 2-abs(x(j,5)-d(k,5))]);
            minimo_teta_viento=min([abs(x(j,7)-d(k,7)) 2-abs(x(j,7)-d(k,7))]);
            
            dist(k)=sqrt((x(j,1)-d(k,1))^2+(x(j,2)-d(k,2))^2+(x(j,3)-d(k,3))^2+(x(j,4)-d(k,4))^2+(minimo_teta_oleaje)^2+(x(j,6)-d(k,6))^2+(minimo_teta_viento)^2+(x(j,8)-d(k,8))^2);   
            %dist(j,k)=sqrt((x(j,1)-d(k,1))^2+(x(j,2)-d(k,2))^2);           
        end 
        %Para cada elemento (fila) calculo el minimo de la distancia a cada valor
        %de la muestra (columna)
        min_dist(j,1)=min(dist);
        progressbar([],j/tam) % Update progress bar 
    end

    %De todos ellos cojo el máximo. Método min-max
    [~,pos]=max(min_dist);
    d(m,:)=x(pos,:);
    l=size(d);
    l=l(1);

    %Elimino el valor de la muestra
    [~,indx]=ismember(d(l,:),x,'rows');
    x(indx,:)=[];
    
    
elseif comp_descarga == 0 && comp_oleaje_desembocadura==1 && comp_m_meteo==1 && comp_oleaje==0 && comp_oleaje_desembocadura_sin_viento==0 % Caso 5 hay Oleaje en la desembocadura y Marea meteorológica
    
    % Caso 5, opción 2: Lo tengo todo menos descarga: Oleaje en la desembocadura, marea
    % meteo y marea astronómica

        
    % Calculo el tamaño de los vectores d y x
    l=size(d);
    l=l(1);
    tam=size(x);
    tam=tam(1);


    % Calculo la distancia de cada elemento a los elementos de d
    for j=1:tam   
        for k=1:l
            minimo_teta_oleaje=min([abs(x(j,4)-d(k,4)) 2-abs(x(j,4)-d(k,4))]);
            minimo_teta_viento=min([abs(x(j,6)-d(k,6)) 2-abs(x(j,6)-d(k,6))]);
            
            dist(k)=sqrt((x(j,1)-d(k,1))^2+(x(j,2)-d(k,2))^2+(x(j,3)-d(k,3))^2+(minimo_teta_oleaje)^2+(x(j,5)-d(k,5))^2+(minimo_teta_viento)^2+(x(j,7)-d(k,7))^2);   
            %dist(j,k)=sqrt((x(j,1)-d(k,1))^2+(x(j,2)-d(k,2))^2);           
        end 
        %Para cada elemento (fila) calculo el minimo de la distancia a cada valor
        %de la muestra (columna)
        min_dist(j,1)=min(dist);
        progressbar([],j/tam) % Update progress bar 
    end

    %De todos ellos cojo el máximo. Método min-max
    [~,pos]=max(min_dist);
    d(m,:)=x(pos,:);
    l=size(d);
    l=l(1);

    %Elimino el valor de la muestra
    [~,indx]=ismember(d(l,:),x,'rows');
    x(indx,:)=[];
    
        
end

end