function [F]=EXTRACCION_VALOR_DE_F_MM_OD(Forzamiento,PC,M,pos,ini)

progressbar('Extracción valores de F') % Init single bar
for j=ini:M  
  
    %Extraigo los valores
    dir_sim=(['..\SIMULACIONES\RESULTADOS\RESULTADOS_MUESTRA\MM_OD\Sim_OD_MM_SP_sintetica_' num2str(j)]);
    file_name=(['Sim_OD_MM_SP_sintetica_' num2str(j)]);
    [t_sintetica,WL_sintetica,coord]=EXTRACCION_DELFT_FGUAD(dir_sim,file_name,PC);
    
    %Calculo del desfase entre marea astronómica y elevaciones
    lagDiff=0;
    disp(['El desfase entre MM y ELEVACION ES ' num2str(0) ' minutos PORQUE ES ESTACIONARIA'])

    %Extraccion del valor de F

    %Saco el vector de t_sintetica
    t_sintetica_vect=datevec(t_sintetica);
    t_sintetica_vect(:,6)=0;

    %Busco el instante horario de t_ma en el que 
    %se toma el valor
    t_valor=datevec(Forzamiento.MM.t_horario(pos(j)));

    %Busco la posición en t_sintetica_vect en la que
    %se encuentra el valor CONSIDERANDO YA LOS MINUTOS LAGDIFF
    pos_sintetica=find(t_sintetica_vect(:,1)==t_valor(1) & t_sintetica_vect(:,2)==t_valor(2) & t_sintetica_vect(:,3)==t_valor(3) & t_sintetica_vect(:,4)==t_valor(4) & t_sintetica_vect(:,5)==t_valor(5) & t_sintetica_vect(:,6)==0);
    pos_sintetica=pos_sintetica+lagDiff;
    %Ahora tenemos que sacar el valor de la altura de ola en dicho
    %punto
    Hs=EXTRACCION_HS_DELFT_WGUAD(coord,j);

    %Guardo el valor de F
    F.MM_OD.eta(j)=WL_sintetica(pos_sintetica); %Solo MA,Q,MM
    F.MM_OD.Hs(j)=Hs; %Solo oleaje
    F.MM_OD.WL(j)=WL_sintetica(pos_sintetica)+Hs; %Total
    F.MM_OD.t_WL(j,:)=t_sintetica_vect(pos_sintetica,:); 
    
    progressbar(j/M)
end