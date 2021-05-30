function [F]=EXTRACCION_VALOR_DE_F_MA(Forzamiento,PC,M,pos,ini)

%Calculo del desfase entre marea astronómica y elevaciones
lagDiff=DESFASE_MAREA_ASTRONOMICA_ELEVACIONES(Forzamiento,PC);
disp(['El desfase entre MA y ELEVACION ES ' num2str(lagDiff) ' minutos'])

progressbar('Extracción valores de F') % Init single bar
for j=ini:M        
    %Extraigo los valores
    dir_sim=(['..\SIMULACIONES\RESULTADOS\RESULTADOS_MUESTRA\MA\Sim_MA_SP_sintetica_' num2str(j)]);
    file_name=(['Sim_MA_SP_sintetica_' num2str(j)]);
    [t_sintetica,WL_sintetica]=EXTRACCION_DELFT_FGUAD(dir_sim,file_name,PC);

    %Extraccion del valor de F

    %Saco el vector de t_sintetica
    t_sintetica_vect=datevec(t_sintetica);
    t_sintetica_vect(:,6)=0;

    %Busco el instante horario de t_ma en el que 
    %se toma el valor
    t_valor=datevec(Forzamiento.MA.t_ma(pos(j)));

    %Busco la posición en t_sintetica_vect en la que
    %se encuentra el valor CONSIDERANDO YA LOS MINUTOS LAGDIFF
    pos_sintetica=find(t_sintetica_vect(:,1)==t_valor(1) & t_sintetica_vect(:,2)==t_valor(2) & t_sintetica_vect(:,3)==t_valor(3) & t_sintetica_vect(:,4)==t_valor(4) & t_sintetica_vect(:,5)==t_valor(5) & t_sintetica_vect(:,6)==0);
    pos_sintetica=pos_sintetica+lagDiff;
    
    if isnan(WL_sintetica(pos_sintetica))
        disp(['NaN value error in sim ', num2str(j)])
        break
    end
        
        

    %Guardo el valor de F
    F.MA.WL(j)=WL_sintetica(pos_sintetica);
    F.MA.t_WL(j,:)=t_sintetica_vect(pos_sintetica,:); 
    progressbar(j/M) % Update progress bar
end