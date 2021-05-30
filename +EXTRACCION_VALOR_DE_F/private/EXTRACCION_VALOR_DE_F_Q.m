function [F]=EXTRACCION_VALOR_DE_F_Q(Forzamiento,PC,M,pos,ini)

progressbar('Extracción valores de F') % Init single bar
for j=ini:M        
    %Extraigo los valores
    dir_sim=(['..\SIMULACIONES\RESULTADOS\RESULTADOS_MUESTRA\Q\Sim_Q_SP_sintetica_' num2str(j)]);
    file_name=(['Sim_Q_SP_sintetica_' num2str(j)]);
    [t_sintetica,WL_sintetica]=EXTRACCION_DELFT_FGUAD(dir_sim,file_name,PC);

    %Calculo del desfase entre DESCARGA EN EL PORTAL Y EN MI PUNTO
    %DE CONTROL: Como no hay marea, la descarga fluvial es
    %estacionaria y por tanto no hay desfase.
    lagDiff=0
    disp(['El desfase entre Q y ELEVACION ES ' num2str(lagDiff) ' minutos PORQUE ES ESTACIONARIA'])


    %Extraccion del valor de F

    %Saco el vector de t_sintetica
    t_sintetica_vect=datevec(t_sintetica);
    t_sintetica_vect(:,6)=0;

    %Busco el instante horario de t_ma en el que 
    %se toma el valor
    t_valor=datevec(Forzamiento.Q.t_q(pos(j)))

    %Busco la posición en t_sintetica_vect en la que
    %se encuentra el valor CONSIDERANDO YA LOS MINUTOS LAGDIFF
    pos_sintetica=find(t_sintetica_vect(:,1)==t_valor(1) & t_sintetica_vect(:,2)==t_valor(2) & t_sintetica_vect(:,3)==t_valor(3) & t_sintetica_vect(:,4)==t_valor(4) & t_sintetica_vect(:,5)==lagDiff & t_sintetica_vect(:,6)==0)

    if isempty(pos_sintetica)
        pos_sintetica = length(t_sintetica);        
        disp('Posicion no encontrada, comprobar que esta hipotesis es correcta')
        %pause
    end
    
    %Guardo el valor de F
    F.Q.WL(j)=WL_sintetica(pos_sintetica);
    F.Q.t_WL(j,:)=t_sintetica_vect(pos_sintetica,:); 
    progressbar(j/M) % Update progress bar
end