function [F]=EXTRACCION_VALOR_DE_F_MM(Forzamiento,PC,M,pos,ini)

progressbar('Extracción valores de F') % Init single bar
for j=ini:M        
    %Extraigo los valores
    dir_sim=(['..\SIMULACIONES\RESULTADOS\RESULTADOS_MUESTRA\MM\Sim_MM_SP_sintetica_' num2str(j)]);
    file_name=(['Sim_MM_SP_sintetica_' num2str(j)]);
    [t_sintetica,WL_sintetica]=EXTRACCION_DELFT_FGUAD(dir_sim,file_name,PC);

    %Calculo del desfase entre marea astronómica y elevaciones
    lagDiff=0;
    disp(['El desfase entre MM y ELEVACION ES ' num2str(0) ' minutos PORQUE ES ESTACIONARIA'])

    %Extraccion del valor de F

    %Sao el vector de t_sintetica
    t_sintetica_vect=datevec(t_sintetica);
    t_sintetica_vect(:,6)=0;

    %Busco el instante horario de t_ma en el que 
    %se toma el valor
    t_valor=datevec(Forzamiento.MM.t_horario(pos(j)))

    %El valor de F para la marea meteorológica lo tomo al final de
    %la simulación sintetica para garantizar la estacionariedad. No
    %lo hago así con la descarga porque una descarga muy prolongada
    %puede dar lugar a valores de elevación por encima del real.
    %Pero con el oleaje y marea meteo no ocurre así.
    pos_sintetica=find(t_sintetica_vect(:,1)==t_valor(1) & t_sintetica_vect(:,2)==t_valor(2) & t_sintetica_vect(:,3)==t_valor(3) & t_sintetica_vect(:,4)==t_valor(4) & t_sintetica_vect(:,5)==lagDiff & t_sintetica_vect(:,6)==0)

    %Guardo el valor de F
    F.MM.WL(j)=WL_sintetica(pos_sintetica);
    F.MM.t_WL(j,:)=t_sintetica_vect(pos_sintetica,:); 
    
    progressbar(j/M) % Update progress bar
end
