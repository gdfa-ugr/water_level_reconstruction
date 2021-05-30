function Hs=EXTRACCION_HS_DELFT_WGUAD(coord,j)

%En primer lugar comparo las coordenadas del punto de control de fguad con 
% los limites de la malla de wguad. Si el punto de control esta fuera de
% wguad, el valor de salida Hs es 0.

xlim=751497;
ylim=4054652;

if coord(1,1)>xlim || coord(1,2)>ylim
    Hs=0;
else
    Hs=0;
    
%     %Cargo los archivos .tab que haya y en ellos busco la fila que más se
%     %aproxime a mi punto de control
%     files=ls(['..\SIMULACIONES\RESULTADOS\RESULTADOS_MUESTRA\MA_Q_MM_OD\Sim_MA_Q_MM_OD_SP_sintetica_' num2str(j) '\*.tab']); 
%     data=load(['..\SIMULACIONES\RESULTADOS\RESULTADOS_MUESTRA\MA_Q_MM_OD\Sim_MA_Q_MM_OD_SP_sintetica_' num2str(j) '\' files(1,:)]);
%     
%     for k=1:length(data(:,1))
%         dist(k)=sqrt((coord(1,1)-data(k,1))^2+((coord(1,2)-data(k,2))^2));
%     end
%     
%     figure
%     plot(dist)
%     
%     [min_dist pos]=min(dist);    
%     
%     %Ahora saco la Hs de todos los ficheros en dicha posicion
%     for k=1:length(files)
%         data=load(['..\SIMULACIONES\RESULTADOS\RESULTADOS_MUESTRA\MA_Q_MM_OD\Sim_MA_Q_MM_OD_SP_sintetica_' num2str(j) '\' files(k,:)]);
%         Hs(k)=data(pos,4);
%     end
%     
%     figure
%     plot(Hs)
%     
%     Hs=max(Hs)
    
end


end