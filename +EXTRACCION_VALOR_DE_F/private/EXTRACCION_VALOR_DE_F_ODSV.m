function [F]=EXTRACCION_VALOR_DE_F_ODSV(Forzamiento,PC,M,pos,ini)

progressbar('Extracción valores de F') % Init single bar
for j=ini:M        
    %Extraigo los valores
    dir_sim=(['..\SIMULACIONES\RESULTADOS\RESULTADOS_MUESTRA\ODSV\Sim_ODSV_SP_sintetica_' num2str(j)]);
    file_name=(['Sim_ODSV_sintetica_' num2str(j)]);
    [t_sintetica,WL_sintetica,coord]=EXTRACCION_DELFT_FGUAD(dir_sim,file_name,PC);

    %Calculo del desfase entre marea astronómica y elevaciones
    lagDiff=0
    disp(['El desfase entre MA y ELEVACION ES ' num2str(lagDiff) ' minutos porque el oleaje es estacionario'])


    %Extraccion del valor de F

    %Saco el vector de t_sintetica
    t_sintetica_vect=datevec(t_sintetica);
    t_sintetica_vect(:,6)=0;

    %Busco el instante horario de t_ma en el que 
    %se toma el valor
    t_valor=datevec(Forzamiento.ODSV.t_horario(pos(j)));

    %Busco la posición en t_sintetica_vect en la que
    %se encuentra el valor CONSIDERANDO YA LOS MINUTOS LAGDIFF
    pos_sintetica=find(t_sintetica_vect(:,1)==t_valor(1) & t_sintetica_vect(:,2)==t_valor(2) & t_sintetica_vect(:,3)==t_valor(3) & t_sintetica_vect(:,4)==t_valor(4) & t_sintetica_vect(:,5)==lagDiff & t_sintetica_vect(:,6)==0);

    %Ahora tenemos que sacar el valor de la altura de ola en dicho
    %punto
    Hs=EXTRACCION_HS_DELFT_WGUAD_SOLO_OLEAJE(coord,j);

    %Guardo el valor de F
    F.ODSV.eta(j)=WL_sintetica(pos_sintetica); %Solo MA,Q,MM
    F.ODSV.Hs(j)=Hs; %Solo oleaje
    F.ODSV.WL(j)=WL_sintetica(pos_sintetica)+Hs; %Total
    F.ODSV.t_WL(j,:)=t_sintetica_vect(pos_sintetica,:);  
    
    progressbar(j/M)
end