function [F]=EXTRACCION_VALOR_F_PROPAGACION_OLEAJE_CON_VIENTO(PC,M,ini,Forzamiento,pos)

addpath(['..\SIMULACIONES\RESULTADOS\RESULTADOS_MUESTRA\Sim_Propagacion_oleaje_con_m_meteo_'])

progressbar('Extracción valores de F') % Init single bar
for j=ini:M
    datos=load(['..\SIMULACIONES\RESULTADOS\RESULTADOS_MUESTRA\Sim_Propagacion_oleaje_con_m_meteo_\Sim_Propagacion_oleaje_con_m_meteo_',num2str(j),'\pcw.loct100002.tab']);
    
    %Comprobación por si el valor de altura de ola del forzamiento es 0. En
    %ese caso el Delft dará un valor de Hs propagada igual a -999
    
    F.Oleaje.Hs(j)=datos(PC,4);
    F.Oleaje.Tp(j)=datos(PC,6);
    F.Oleaje.d_o(j)=datos(PC,5);
    
    if F.Oleaje.Hs(j)<=0
        F.Oleaje.Hs(j)=0.05; %No lo hago nulo para que luego al calcular eta debida a oleaje no vuelva a salir -999
    end
    
    if F.Oleaje.Tp(j)<=0
        F.Oleaje.Tp(j)=Forzamiento.O.tp(pos(j));
    end
    
    if F.Oleaje.d_o(j)<=0
        F.Oleaje.d_o(j)=Forzamiento.O.d_o(pos(j));
    end
    
    progressbar(j/M)
end


