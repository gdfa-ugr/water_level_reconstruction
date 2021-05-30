function [F]=EXTRACCION_VALOR_DE_F_SLR(Forzamiento,Forzamiento_3h,PC,M,pos,ini,SC, OF, var)

%Calculo del desfase entre marea astronómica y elevaciones
%lagDiff=DESFASE_MAREA_ASTRONOMICA_ELEVACIONES(Forzamiento,PC);
%disp(['El desfase entre MA y ELEVACION ES ' num2str(lagDiff) ' minutos'])

% En primer lugar me creo las carpetas para la simulación
names = fieldnames(Forzamiento);
l=length(names);
fold_name='';
for j=1:l
   fold_name=[fold_name char(names(j)),'_']; 
end

if strcmp(var, 'eta')

    progressbar('Extracción valores de F') % Init single bar
    for j=ini:M  

         if ismember(j, [252, 253, 254])
    %     F.MA_Q_MM_OD.eta(j)=Forzamiento_3h.MA_95_85.ma(pos(j)); %Solo MA,Q,MM
    %     F.MA_Q_MM_OD.Hs(j)=0; %Solo oleaje
    %     F.MA_Q_MM_OD.WL(j)=Forzamiento_3h.MA_95_85.ma(pos(j))+Hs; %Total
    %     F.MA_Q_MM_OD.t_WL(j,:)=NaN;
         pause
         end

        %Extraigo los valores
        dir_sim=(['..\SIMULACIONES\RESULTADOS\RESULTADOS_MUESTRA\Sim_' fold_name '\' SC '\' OF '\Sim_' fold_name SC '_' OF '_sintetica_' sprintf('%04d',j)]);
        file_name=(['Sim_' fold_name SC '_' OF '_sintetica_' sprintf('%04d',j)]);
        [t_sintetica,WL_sintetica,coord]=EXTRACCION_DELFT_FGUAD(dir_sim,file_name,PC, var);

        % Lo paso a horario para suavizar la señal que tiene ruido 
        t_sintetica_hor = t_sintetica(1:60:end);
        WL_sintetica_hor = WL_sintetica(1:60:end);

        % Lo devuelvo a minutario
        WL_sintetica = interp1(t_sintetica_hor, WL_sintetica_hor, t_sintetica);

        %Saco el vector de t_sintetica
        t_sintetica_vect=datevec(t_sintetica);
        t_sintetica_vect(:,6)=0;
        t_sintetica = datenum(t_sintetica_vect);    

        %Busco el instante horario de t_ma en el que 
        %se toma el valor
        if strcmp(SC, 'SC_95_85')
            t_valor=datevec(Forzamiento.SLR_95_85.t_horario(pos(j)));
        elseif strcmp(SC, 'SC_05_45')
            t_valor=datevec(Forzamiento.SLR_05_45.t_horario(pos(j)));
        end
        pos_sintetica=find(t_sintetica_vect(:,1)==t_valor(1) & t_sintetica_vect(:,2)==t_valor(2) & t_sintetica_vect(:,3)==t_valor(3) & t_sintetica_vect(:,4)==t_valor(4) & t_sintetica_vect(:,5)==t_valor(5) & t_sintetica_vect(:,6)==0);

        figure
        s(1) = subplot(2, 1, 1);
        hold on
        %plot(Forzamiento_3h.MA_95_85.t_ma, Forzamiento_3h.MA_95_85.ma)
        if strcmp(SC, 'SC_95_85')
            plot(Forzamiento.SLR_95_85.t_horario, Forzamiento.SLR_95_85.slr, 'displayname', 'Forzamiento MA horario')
            plot(t_sintetica, WL_sintetica, 'displayname', 'WL Delft')
            plot(Forzamiento.SLR_95_85.t_horario(pos(j)), Forzamiento.SLR_95_85.slr(pos(j)), '.', 'markersize', 40, 'displayname', 'Pos MDA Forzamiento')
        elseif strcmp(SC, 'SC_05_45')
            plot(Forzamiento.SLR_05_45.t_horario, Forzamiento.SLR_05_45.slr, 'displayname', 'Forzamiento MA horario')
            plot(t_sintetica, WL_sintetica, 'displayname', 'WL Delft')
            plot(Forzamiento.SLR_05_45.t_horario(pos(j)), Forzamiento.SLR_05_45.slr(pos(j)), '.', 'markersize', 40, 'displayname', 'Pos MDA Forzamiento')
            
        end
        plot(t_sintetica(pos_sintetica), WL_sintetica(pos_sintetica), '.', 'markersize', 40, 'displayname', 'Pos F')
        grid on
        legend('Show')
        xlim([t_sintetica(1)-0.5 t_sintetica(end)+0.5])    

        s(2) = subplot(2, 1, 2);
        plot(t_sintetica, WL_sintetica)
        hold on
        plot(t_sintetica(pos_sintetica), WL_sintetica(pos_sintetica), '.', 'markersize', 40)
        grid on
        xlim([t_sintetica(1)-0.5 t_sintetica(end)+0.5])
        dateaxis('x', 10)
        linkaxes([s], 'x')
        %pause
        close all

        %Guardo el valor de F
        F.SLR.WL(j)=WL_sintetica(pos_sintetica); %Total
        F.SLR.t_WL(j,:)=t_sintetica_vect(pos_sintetica,:);
        
        progressbar(j/M)
    end
    
elseif strcmp(var, 'v_x')
        
    progressbar('Extracción valores de F') % Init single bar
    for j=ini:M 

        if j == ini
            % Calculo el desfase
            %Extraigo los valores
            dir_sim=(['..\SIMULACIONES\RESULTADOS\RESULTADOS_MUESTRA\Sim_' fold_name '\' SC '\' OF '\Sim_' fold_name SC '_' OF '_sintetica_' sprintf('%04d',j)]);
            file_name=(['Sim_' fold_name SC '_' OF '_sintetica_' sprintf('%04d',j)]);
            [t_sintetica,WL_sintetica,coord]=EXTRACCION_DELFT_FGUAD(dir_sim,file_name,PC, 'eta');

            % Lo paso a horario para suavizar la señal que tiene ruido 
            t_sintetica_hor = t_sintetica(1:60:end);
            WL_sintetica_hor = WL_sintetica(1:60:end);

            % Lo devuelvo a minutario
            WL_sintetica = interp1(t_sintetica_hor, WL_sintetica_hor, t_sintetica);

            %Saco el vector de t_sintetica
            t_sintetica_vect=datevec(t_sintetica);
            t_sintetica_vect(:,6)=0;
            t_sintetica = datenum(t_sintetica_vect);    

            % Desfase entre Forzamiento y Elevaciones
            pos_ini = find(Forzamiento.MA_95_85.t_ma==t_sintetica(1));
            pos_fin = find(Forzamiento.MA_95_85.t_ma==t_sintetica(end));
            t_ma = Forzamiento.MA_95_85.t_ma(pos_ini:pos_fin);
            ma = Forzamiento.MA_95_85.ma(pos_ini:pos_fin);

            % Convierto el forzamiento a minutario
            t_ma_min=[t_ma(1):1/(24*60):t_ma(end)];
            ma=interp1(t_ma,ma,t_ma_min);
            t_ma=t_ma_min;
            t_ma_vect=datevec(t_ma);
            clear t_ma_min

            % Calculo el desfase
            [c,lag] = xcorr(WL_sintetica,ma,'coeff');
            pos_lag=find(lag<0);
            c(pos_lag)=0;
            [c_pos,I] =  findpeaks(c);
            lag_pos = lag(I(1)); %minutos de desfase entre s1 y s2
            lagDiff=lag_pos;
            disp(['El desfase entre MA y ELEVACION ES ' num2str(lagDiff) ' minutos'])
        end

        %Extraigo los valores
        dir_sim=(['..\SIMULACIONES\RESULTADOS\RESULTADOS_MUESTRA\Sim_' fold_name '\' SC '\' OF '\Sim_' fold_name SC '_' OF '_sintetica_' sprintf('%04d',j)]);
        file_name=(['Sim_' fold_name SC '_' OF '_sintetica_' sprintf('%04d',j)]);
        [t_sintetica, v_x_sintetica,coord]=EXTRACCION_DELFT_FGUAD(dir_sim,file_name,PC, var);

        % Lo paso a horario para suavizar la señal que tiene ruido 
        t_sintetica_hor = t_sintetica(1:60:end);
        v_x_sintetica_hor = v_x_sintetica(1:60:end);

        % Lo devuelvo a minutario
        v_x_sintetica = interp1(t_sintetica_hor, v_x_sintetica_hor, t_sintetica);
        
        %Saco el vector de t_sintetica
        t_sintetica_vect=datevec(t_sintetica);
        t_sintetica_vect(:,6)=0;
        t_sintetica = datenum(t_sintetica_vect);  

        %Busco el instante horario de t_ma en el que 
        %se toma el valor
        if strcmp(SC, 'SC_95_85')
            t_valor=datevec(Forzamiento.MA_95_85.t_ma(pos(j)));
        elseif strcmp(SC, 'SC_05_45')
            t_valor=datevec(Forzamiento.MA_05_45.t_ma(pos(j)));
        end
        pos_sintetica=find(t_sintetica_vect(:,1)==t_valor(1) & t_sintetica_vect(:,2)==t_valor(2) & t_sintetica_vect(:,3)==t_valor(3) & t_sintetica_vect(:,4)==t_valor(4) & t_sintetica_vect(:,5)==t_valor(5) & t_sintetica_vect(:,6)==0);
        pos_sintetica=pos_sintetica+lagDiff;

        figure
        s(1) = subplot(3, 1, 1);
        hold on
        %plot(Forzamiento_3h.MA_95_85.t_ma, Forzamiento_3h.MA_95_85.ma)
        plot(Forzamiento.MA_95_85.t_ma, Forzamiento.MA_95_85.ma, 'displayname', 'Forzamiento MA horario')
        plot(t_sintetica, v_x_sintetica, 'displayname', 'WL Delft')
        plot(Forzamiento.MA_95_85.t_ma(pos(j)), Forzamiento.MA_95_85.ma(pos(j)), '.', 'markersize', 40, 'displayname', 'Pos MDA Forzamiento')
        plot(t_sintetica(pos_sintetica), v_x_sintetica(pos_sintetica), '.', 'markersize', 40, 'displayname', 'Pos F')
        grid on
        legend('Show')
        xlim([t_sintetica(1)-0.5 t_sintetica(end)+0.5])    

        s(2) = subplot(3, 1, 2);
        plot(Forzamiento.Q.t_q, Forzamiento.Q.q)
        hold on
        plot(Forzamiento.Q.t_q(pos(j)), Forzamiento.Q.q(pos(j)), '.', 'markersize', 40)
        grid on
        xlim([t_sintetica(1)-0.5 t_sintetica(end)+0.5])

        s(3) = subplot(3, 1, 3);
        plot(t_sintetica, v_x_sintetica)
        hold on
        plot(t_sintetica(pos_sintetica), v_x_sintetica(pos_sintetica), '.', 'markersize', 40)
        grid on
        xlim([t_sintetica(1)-0.5 t_sintetica(end)+0.5])
        dateaxis('x', 10)
        linkaxes([s], 'x')
        %pause
        close all

        %Guardo el valor de F
        F.MA_Q_MM_OD.v_x(j)=v_x_sintetica(pos_sintetica); %Solo MA,Q,MM
        progressbar(j/M)
    end
        
elseif strcmp(var, 'v_y')
    progressbar('Extracción valores de F') % Init single bar
    for j=ini:M 

        if j == ini
            % Calculo el desfase
            %Extraigo los valores
            dir_sim=(['..\SIMULACIONES\RESULTADOS\RESULTADOS_MUESTRA\Sim_' fold_name '\' SC '\' OF '\Sim_' fold_name SC '_' OF '_sintetica_' sprintf('%04d',j)]);
            file_name=(['Sim_' fold_name SC '_' OF '_sintetica_' sprintf('%04d',j)]);
            [t_sintetica,WL_sintetica,coord]=EXTRACCION_DELFT_FGUAD(dir_sim,file_name,PC, 'eta');

            % Lo paso a horario para suavizar la señal que tiene ruido 
            t_sintetica_hor = t_sintetica(1:60:end);
            WL_sintetica_hor = WL_sintetica(1:60:end);

            % Lo devuelvo a minutario
            WL_sintetica = interp1(t_sintetica_hor, WL_sintetica_hor, t_sintetica);

            %Saco el vector de t_sintetica
            t_sintetica_vect=datevec(t_sintetica);
            t_sintetica_vect(:,6)=0;
            t_sintetica = datenum(t_sintetica_vect);    

            % Desfase entre Forzamiento y Elevaciones
            pos_ini = find(Forzamiento.MA_95_85.t_ma==t_sintetica(1));
            pos_fin = find(Forzamiento.MA_95_85.t_ma==t_sintetica(end));
            t_ma = Forzamiento.MA_95_85.t_ma(pos_ini:pos_fin);
            ma = Forzamiento.MA_95_85.ma(pos_ini:pos_fin);

            % Convierto el forzamiento a minutario
            t_ma_min=[t_ma(1):1/(24*60):t_ma(end)];
            ma=interp1(t_ma,ma,t_ma_min);
            t_ma=t_ma_min;
            t_ma_vect=datevec(t_ma);
            clear t_ma_min

            % Calculo el desfase
            [c,lag] = xcorr(WL_sintetica,ma,'coeff');
            pos_lag=find(lag<0);
            c(pos_lag)=0;
            [c_pos,I] =  findpeaks(c);
            lag_pos = lag(I(1)); %minutos de desfase entre s1 y s2
            lagDiff=lag_pos;
            disp(['El desfase entre MA y ELEVACION ES ' num2str(lagDiff) ' minutos'])
        end

        %Extraigo los valores
        dir_sim=(['..\SIMULACIONES\RESULTADOS\RESULTADOS_MUESTRA\Sim_' fold_name '\' SC '\' OF '\Sim_' fold_name SC '_' OF '_sintetica_' sprintf('%04d',j)]);
        file_name=(['Sim_' fold_name SC '_' OF '_sintetica_' sprintf('%04d',j)]);
        [t_sintetica, v_y_sintetica,coord]=EXTRACCION_DELFT_FGUAD(dir_sim,file_name,PC, var);

        % Lo paso a horario para suavizar la señal que tiene ruido 
        t_sintetica_hor = t_sintetica(1:60:end);
        v_y_sintetica_hor = v_y_sintetica(1:60:end);

        % Lo devuelvo a minutario
        v_y_sintetica = interp1(t_sintetica_hor, v_y_sintetica_hor, t_sintetica);
        
        %Saco el vector de t_sintetica
        t_sintetica_vect=datevec(t_sintetica);
        t_sintetica_vect(:,6)=0;
        t_sintetica = datenum(t_sintetica_vect);

        %Busco el instante horario de t_ma en el que 
        %se toma el valor
        if strcmp(SC, 'SC_95_85')
            t_valor=datevec(Forzamiento.MA_95_85.t_ma(pos(j)));
        elseif strcmp(SC, 'SC_05_45')
            t_valor=datevec(Forzamiento.MA_05_45.t_ma(pos(j)));
        end
        pos_sintetica=find(t_sintetica_vect(:,1)==t_valor(1) & t_sintetica_vect(:,2)==t_valor(2) & t_sintetica_vect(:,3)==t_valor(3) & t_sintetica_vect(:,4)==t_valor(4) & t_sintetica_vect(:,5)==t_valor(5) & t_sintetica_vect(:,6)==0);
        pos_sintetica=pos_sintetica+lagDiff;

        figure
        s(1) = subplot(3, 1, 1);
        hold on
        %plot(Forzamiento_3h.MA_95_85.t_ma, Forzamiento_3h.MA_95_85.ma)
        plot(Forzamiento.MA_95_85.t_ma, Forzamiento.MA_95_85.ma, 'displayname', 'Forzamiento MA horario')
        plot(t_sintetica, v_y_sintetica, 'displayname', 'WL Delft')
        plot(Forzamiento.MA_95_85.t_ma(pos(j)), Forzamiento.MA_95_85.ma(pos(j)), '.', 'markersize', 40, 'displayname', 'Pos MDA Forzamiento')
        plot(t_sintetica(pos_sintetica), v_y_sintetica(pos_sintetica), '.', 'markersize', 40, 'displayname', 'Pos F')
        grid on
        legend('Show')
        xlim([t_sintetica(1)-0.5 t_sintetica(end)+0.5])    

        s(2) = subplot(3, 1, 2);
        plot(Forzamiento.Q.t_q, Forzamiento.Q.q)
        hold on
        plot(Forzamiento.Q.t_q(pos(j)), Forzamiento.Q.q(pos(j)), '.', 'markersize', 40)
        grid on
        xlim([t_sintetica(1)-0.5 t_sintetica(end)+0.5])

        s(3) = subplot(3, 1, 3);
        plot(t_sintetica, v_y_sintetica)
        hold on
        plot(t_sintetica(pos_sintetica), v_y_sintetica(pos_sintetica), '.', 'markersize', 40)
        grid on
        xlim([t_sintetica(1)-0.5 t_sintetica(end)+0.5])
        dateaxis('x', 10)
        linkaxes([s], 'x')
        %pause
        close all

        %Guardo el valor de F
        F.MA_Q_MM_OD.v_y(j)=v_y_sintetica(pos_sintetica); %Solo MA,Q,MM
        progressbar(j/M)
    end

elseif strcmp(var, 'hs')
    progressbar('Extracción valores de F') % Init single bar
    for j=ini:M 

%         if j == ini
%             % Calculo el desfase
%             %Extraigo los valores
%             dir_sim=(['..\SIMULACIONES\RESULTADOS\RESULTADOS_MUESTRA\Sim_' fold_name '\' SC '\' OF '\Sim_' fold_name SC '_' OF '_sintetica_' sprintf('%04d',j)]);
%             file_name=(['Sim_' fold_name SC '_' OF '_sintetica_' sprintf('%04d',j)]);
%             [t_sintetica,WL_sintetica,coord]=EXTRACCION_DELFT_FGUAD(dir_sim,file_name,PC, 'eta');
% 
%             % Lo paso a horario para suavizar la señal que tiene ruido 
%             t_sintetica_hor = t_sintetica(1:60:end);
%             WL_sintetica_hor = WL_sintetica(1:60:end);
% 
%             % Lo devuelvo a minutario
%             WL_sintetica = interp1(t_sintetica_hor, WL_sintetica_hor, t_sintetica);
% 
%             %Saco el vector de t_sintetica
%             t_sintetica_vect=datevec(t_sintetica);
%             t_sintetica_vect(:,6)=0;
%             t_sintetica = datenum(t_sintetica_vect);    
% 
%             % Desfase entre Forzamiento y Elevaciones
%             pos_ini = find(Forzamiento.MA_95_85.t_ma==t_sintetica(1));
%             pos_fin = find(Forzamiento.MA_95_85.t_ma==t_sintetica(end));
%             t_ma = Forzamiento.MA_95_85.t_ma(pos_ini:pos_fin);
%             ma = Forzamiento.MA_95_85.ma(pos_ini:pos_fin);
% 
%             % Convierto el forzamiento a minutario
%             t_ma_min=[t_ma(1):1/(24*60):t_ma(end)];
%             ma=interp1(t_ma,ma,t_ma_min);
%             t_ma=t_ma_min;
%             t_ma_vect=datevec(t_ma);
%             clear t_ma_min
% 
%             % Calculo el desfase
%             [c,lag] = xcorr(WL_sintetica,ma,'coeff');
%             pos_lag=find(lag<0);
%             c(pos_lag)=0;
%             [c_pos,I] =  findpeaks(c);
%             lag_pos = lag(I(1)); %minutos de desfase entre s1 y s2
%             lagDiff=lag_pos;
%             disp(['El desfase entre MA y ELEVACION ES ' num2str(lagDiff) ' minutos'])
%         end

        %Extraigo los valores
        dir_sim=(['..\SIMULACIONES\RESULTADOS\RESULTADOS_MUESTRA\Sim_' fold_name '\' SC '\' OF '\Sim_' fold_name SC '_' OF '_sintetica_' sprintf('%04d',j)]);
        file_name=(['Sim_' fold_name SC '_' OF '_sintetica_' sprintf('%04d',j)]);
        [t_sintetica, hs_sintetica,coord]=EXTRACCION_DELFT_FGUAD(dir_sim,file_name,PC, var);
        
        if iscell(hs_sintetica)
            hs_sintetica  = t_sintetica*0 + 0.25;
        end
        
        % Lo paso a horario para suavizar la señal que tiene ruido 
        t_sintetica_hor = t_sintetica(1:60:end);
        hs_sintetica_hor = hs_sintetica(1:60:end);

        % Lo devuelvo a minutario
        hs_sintetica = interp1(t_sintetica_hor, hs_sintetica_hor, t_sintetica);
        
        %Saco el vector de t_sintetica
        t_sintetica_vect=datevec(t_sintetica);
        t_sintetica_vect(:,6)=0;
        t_sintetica = datenum(t_sintetica_vect);

        %Busco el instante horario de t_ma en el que 
        %se toma el valor
        if strcmp(SC, 'SC_95_85')
            t_valor=datevec(Forzamiento.MA_95_85.t_ma(pos(j)));
        elseif strcmp(SC, 'SC_05_45')
            t_valor=datevec(Forzamiento.MA_05_45.t_ma(pos(j)));
        end
        pos_sintetica=find(t_sintetica_vect(:,1)==t_valor(1) & t_sintetica_vect(:,2)==t_valor(2) & t_sintetica_vect(:,3)==t_valor(3) & t_sintetica_vect(:,4)==t_valor(4) & t_sintetica_vect(:,5)==t_valor(5) & t_sintetica_vect(:,6)==0);
        pos_sintetica=pos_sintetica;
        
        if hs_sintetica(pos_sintetica) > Forzamiento.OD.Hs(pos(j))
            %Guardo el valor de F
            F.MA_Q_MM_OD.hs(j)=Forzamiento.OD.Hs(pos(j));
            
        else
            %Guardo el valor de F
            F.MA_Q_MM_OD.hs(j)=hs_sintetica(pos_sintetica); %Solo MA,Q,MM
        end

        figure
        s(1) = subplot(2, 1, 1);
        hold on
        %plot(Forzamiento_3h.MA_95_85.t_ma, Forzamiento_3h.MA_95_85.ma)
        plot(Forzamiento.OD.t_horario, Forzamiento.OD.Hs, 'displayname', 'Forzamiento Hs horario')
        plot(t_sintetica, hs_sintetica, 'displayname', 'WL Delft')
        plot(Forzamiento.OD.t_horario(pos(j)), Forzamiento.OD.Hs(pos(j)), '.', 'markersize', 40, 'displayname', 'Pos MDA Forzamiento')
        plot(t_sintetica(pos_sintetica), hs_sintetica(pos_sintetica), '.', 'markersize', 40, 'displayname', 'Pos F')
        grid on
        legend('Show')
        xlim([t_sintetica(1)-0.5 t_sintetica(end)+0.5])    

        s(2) = subplot(2, 1, 2);
        plot(t_sintetica, hs_sintetica)
        hold on
        plot(t_sintetica(pos_sintetica), hs_sintetica(pos_sintetica), '.', 'markersize', 40)
        grid on
        xlim([t_sintetica(1)-0.5 t_sintetica(end)+0.5])
        dateaxis('x', 10)
        linkaxes([s], 'x')
        %pause
        close all

        progressbar(j/M)
    end

elseif strcmp(var, 'tp')
    progressbar('Extracción valores de F') % Init single bar
    for j=ini:M 

        %Extraigo los valores
        dir_sim=(['..\SIMULACIONES\RESULTADOS\RESULTADOS_MUESTRA\Sim_' fold_name '\' SC '\' OF '\Sim_' fold_name SC '_' OF '_sintetica_' sprintf('%04d',j)]);
        file_name=(['Sim_' fold_name SC '_' OF '_sintetica_' sprintf('%04d',j)]);
        [t_sintetica, tp_sintetica,coord]=EXTRACCION_DELFT_FGUAD(dir_sim,file_name,PC, var);
        
        if iscell(tp_sintetica) || mode(tp_sintetica) == -999
            tp_sintetica  = t_sintetica*0 + Forzamiento.OD.Tp(pos(j));
        end

        % Lo paso a horario para suavizar la señal que tiene ruido 
        t_sintetica_hor = t_sintetica(1:60:end);
        tp_sintetica_hor = tp_sintetica(1:60:end);

        % Lo devuelvo a minutario
        tp_sintetica = interp1(t_sintetica_hor, tp_sintetica_hor, t_sintetica);
        
        %Saco el vector de t_sintetica
        t_sintetica_vect=datevec(t_sintetica);
        t_sintetica_vect(:,6)=0;
        t_sintetica = datenum(t_sintetica_vect);

        %Busco el instante horario de t_ma en el que 
        %se toma el valor
        if strcmp(SC, 'SC_95_85')
            t_valor=datevec(Forzamiento.MA_95_85.t_ma(pos(j)));
        elseif strcmp(SC, 'SC_05_45')
            t_valor=datevec(Forzamiento.MA_05_45.t_ma(pos(j)));
        end
        pos_sintetica=find(t_sintetica_vect(:,1)==t_valor(1) & t_sintetica_vect(:,2)==t_valor(2) & t_sintetica_vect(:,3)==t_valor(3) & t_sintetica_vect(:,4)==t_valor(4) & t_sintetica_vect(:,5)==t_valor(5) & t_sintetica_vect(:,6)==0);
        pos_sintetica=pos_sintetica;

        figure
        s(1) = subplot(2, 1, 1);
        hold on
        %plot(Forzamiento_3h.MA_95_85.t_ma, Forzamiento_3h.MA_95_85.ma)
        plot(Forzamiento.OD.t_horario, Forzamiento.OD.Tp, 'displayname', 'Forzamiento Tp horario')
        plot(t_sintetica, tp_sintetica, 'displayname', 'WL Delft')
        plot(Forzamiento.OD.t_horario(pos(j)), Forzamiento.OD.Tp(pos(j)), '.', 'markersize', 40, 'displayname', 'Pos MDA Forzamiento')
        plot(t_sintetica(pos_sintetica), tp_sintetica(pos_sintetica), '.', 'markersize', 40, 'displayname', 'Pos F')
        grid on
        legend('Show')
        xlim([t_sintetica(1)-0.5 t_sintetica(end)+0.5])    
        ylim([0 30])

        s(2) = subplot(2, 1, 2);
        plot(t_sintetica, tp_sintetica)
        hold on
        plot(t_sintetica(pos_sintetica), tp_sintetica(pos_sintetica), '.', 'markersize', 40)
        grid on
        xlim([t_sintetica(1)-0.5 t_sintetica(end)+0.5])
        dateaxis('x', 10)
        ylim([0 30])
        linkaxes([s], 'x')
        %pause
        close all

        %Guardo el valor de F
        F.MA_Q_MM_OD.tp(j)=tp_sintetica(pos_sintetica); %Solo MA,Q,MM
        progressbar(j/M)
    end

elseif strcmp(var, 'do')
    progressbar('Extracción valores de F') % Init single bar
    for j=ini:M 

        %Extraigo los valores
        dir_sim=(['..\SIMULACIONES\RESULTADOS\RESULTADOS_MUESTRA\Sim_' fold_name '\' SC '\' OF '\Sim_' fold_name SC '_' OF '_sintetica_' sprintf('%04d',j)]);
        file_name=(['Sim_' fold_name SC '_' OF '_sintetica_' sprintf('%04d',j)]);
        [t_sintetica, do_sintetica,coord]=EXTRACCION_DELFT_FGUAD(dir_sim,file_name,PC, var);
        
        if iscell(do_sintetica) || mode(do_sintetica) == -999
            do_sintetica  = t_sintetica*0 + mode(round(F.MA_Q_MM_OD.do));
            %do_sintetica  = t_sintetica*0 + mean(round(F.MA_Q_MM_OD.do));
        end

        % Lo paso a horario para suavizar la señal que tiene ruido 
        t_sintetica_hor = t_sintetica(1:60:end);
        do_sintetica_hor = do_sintetica(1:60:end);

        % Lo devuelvo a minutario
        do_sintetica = interp1(t_sintetica_hor, do_sintetica_hor, t_sintetica);
        
        %Saco el vector de t_sintetica
        t_sintetica_vect=datevec(t_sintetica);
        t_sintetica_vect(:,6)=0;
        t_sintetica = datenum(t_sintetica_vect);

        %Busco el instante horario de t_ma en el que 
        %se toma el valor
        if strcmp(SC, 'SC_95_85')
            t_valor=datevec(Forzamiento.MA_95_85.t_ma(pos(j)));
        elseif strcmp(SC, 'SC_05_45')
            t_valor=datevec(Forzamiento.MA_05_45.t_ma(pos(j)));
        end
        pos_sintetica=find(t_sintetica_vect(:,1)==t_valor(1) & t_sintetica_vect(:,2)==t_valor(2) & t_sintetica_vect(:,3)==t_valor(3) & t_sintetica_vect(:,4)==t_valor(4) & t_sintetica_vect(:,5)==t_valor(5) & t_sintetica_vect(:,6)==0);
        pos_sintetica=pos_sintetica;

        figure
        s(1) = subplot(2, 1, 1);
        hold on
        %plot(Forzamiento_3h.MA_95_85.t_ma, Forzamiento_3h.MA_95_85.ma)
        plot(Forzamiento.OD.t_horario, Forzamiento.OD.Do, 'displayname', 'Forzamiento Do horario')
        plot(t_sintetica, do_sintetica, 'displayname', 'WL Delft')
        plot(Forzamiento.OD.t_horario(pos(j)), Forzamiento.OD.Do(pos(j)), '.', 'markersize', 40, 'displayname', 'Pos MDA Forzamiento')
        plot(t_sintetica(pos_sintetica), do_sintetica(pos_sintetica), '.', 'markersize', 40, 'displayname', 'Pos F')
        grid on
        legend('Show')
        xlim([t_sintetica(1)-0.5 t_sintetica(end)+0.5])   
        ylim([0 360])

        s(2) = subplot(2, 1, 2);
        plot(t_sintetica, do_sintetica)
        hold on
        plot(t_sintetica(pos_sintetica), do_sintetica(pos_sintetica), '.', 'markersize', 40)
        grid on
        xlim([t_sintetica(1)-0.5 t_sintetica(end)+0.5])
        dateaxis('x', 10)
        ylim([0 360])
        linkaxes([s], 'x')
        %pause
        close all

        %Guardo el valor de F
        F.MA_Q_MM_OD.do(j)=do_sintetica(pos_sintetica); %Solo MA,Q,MM
        progressbar(j/M)
    end
        
end
     
end