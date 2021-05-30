function [Forzamiento]=GENERACION_SERIES_TEMPORALES(Forz_input,t_ini,t_fin, file, slr_sc)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% GENERACION_SERIES_TEMPORALES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%_________________________________________________________________________
% 
% Descripcion: Funcion que me extrae de los datos del Wana y caudal medido
% las series temporales de los forzamientos.
%
% Datos de entrada:
% 1. Forz_input: Estructura que indica con 1 los forzamientos a considerar
% y con 0 el resto
% 2. t_ini: Tiempo inicial de la serie temporal de 20 años
% 3. t_fin: Tiempo final de la serie temporal de 20 años.
%
% Datos de salida:
% 1. Forzamiento: Estructura con las series temporales de los forzamientos 
% considerados
%
%                                          Granada, 14 de marzo de 2016
%                                                     Juan del Rosal Salido
%                                   Grupo de Dinámica de Flujos Ambientales 
%                                                    Universidad de Granada
%__________________________________________________________________________



% Leo los directorios
addpath('DATOS')

%% Genero serie de SLR
if Forz_input.SLR == 1 && Forz_input.MA==0 && Forz_input.Q==0 && Forz_input.MM==0 && Forz_input.OD==0
    load(['DATOS\MAREA_ASTRONOMICA\data.mat']);

    
    % Busco los datos en el espacio temporal elegido para marea
    t = SerialDay;
    t_vec = datevec(t);
    t = datenum(t_vec(:, 1), t_vec(:, 2), t_vec(:, 3), t_vec(:, 4), t_vec(:, 4)*0, t_vec(:, 4)*0);
    pos_ini=find(t==t_ini);
    pos_fin=find(t==t_fin);

    t_ma=t(pos_ini:pos_fin);
    
    % Filas repetidas
    [~, ind] = unique(t_ma, 'rows');
    t_ma = t_ma(ind);
    
    if strcmp(slr_sc, '95_85')
        data = load(['DATOS\SUBIDA_NIVEL_DEL_MAR\slr_' slr_sc '_tratado.txt']);
        t_horario = t_ma;
        t_anual = datenum(data(:, 1), data(:, 1)*0+1, data(:, 1)*0+1, data(:, 1)*0+1, data(:, 1)*0, data(:, 1)*0);

        data_horario = interp1(t_anual, data(:, 2), t_horario);

        figure
        s(1) = subplot(3,1,1)
        plot(t_horario, data_horario)
        grid on
        dateaxis('x', 10)
        linkaxes([s], 'x')
        
        Forzamiento.SLR_95_85.slr = data_horario;
        Forzamiento.SLR_95_85.t_horario = t_ma;

    elseif strcmp(slr_sc, '05_45')
        data = load(['DATOS\SUBIDA_NIVEL_DEL_MAR\slr_' slr_sc '_tratado.txt']);
        t_horario = t_ma;
        t_anual = datenum(data(:, 1), data(:, 1)*0+1, data(:, 1)*0+1, data(:, 1)*0+1, data(:, 1)*0, data(:, 1)*0);

        data_horario = interp1(t_anual, data(:, 2), t_horario);

        figure
        s(1) = subplot(3,1,1)
        plot(t_horario, data_horario)
        grid on
        dateaxis('x', 10)
        linkaxes([s], 'x')

        Forzamiento.SLR_05_45.slr = data_horario;
        Forzamiento.SLR_05_45.t_horario=t_ma;

    end

end

%% Genero serie de marea
if Forz_input.MA==0
else   
    
    load(['DATOS\MAREA_ASTRONOMICA\data.mat']);

    
    % Busco los datos en el espacio temporal elegido para marea
    t = SerialDay';
    t_vec = datevec(t);
    t = datenum(t_vec(:, 1), t_vec(:, 2), t_vec(:, 3), t_vec(:, 4), t_vec(:, 4)*0, t_vec(:, 4)*0);
    pos_ini=find(t==t_ini);
    pos_fin=find(t==t_fin);

    t_ma=t(pos_ini:pos_fin);
    ma=TimeSeries(pos_ini:pos_fin)';
    
    % Filas repetidas
    [~, ind] = unique(t_ma, 'rows');
    t_ma = t_ma(ind);
    ma = ma(ind);
    
    figure
    plot(t_ma, ma)
    dateaxis('x', 10)
    grid on

    if Forz_input.SLR == 1
        if strcmp(slr_sc, '95_85')
            data = load(['DATOS\SUBIDA_NIVEL_DEL_MAR\slr_' slr_sc '_tratado.txt']);
            t_horario = t_ma;
            t_anual = datenum(data(:, 1), data(:, 1)*0+1, data(:, 1)*0+1, data(:, 1)*0+1, data(:, 1)*0, data(:, 1)*0);

            data_horario = interp1(t_anual, data(:, 2), t_horario);

            figure
            s(1) = subplot(3,1,1)
            plot(t_horario, data_horario)
            grid on
            s(2) = subplot(3,1,2)
            plot(t_horario, data_horario)
            grid on
            s(3) = subplot(3, 1, 3)
            plot(t_ma, ma+data_horario)
            hold on
            plot(t_ma, ma)
            plot(t_horario, data_horario)
            grid on
            dateaxis('x', 10)
            linkaxes([s], 'x')

            Forzamiento.MA_95_85.ma = ma + data_horario;
            Forzamiento.MA_95_85.t_ma=t_ma;
            
        elseif strcmp(slr_sc, '05_45')
            data = load(['DATOS\SUBIDA_NIVEL_DEL_MAR\slr_' slr_sc '_tratado.txt']);
            t_horario = t_ma;
            t_anual = datenum(data(:, 1), data(:, 1)*0+1, data(:, 1)*0+1, data(:, 1)*0+1, data(:, 1)*0, data(:, 1)*0);

            data_horario = interp1(t_anual, data(:, 2), t_horario);

            figure
            s(1) = subplot(3,1,1)
            plot(t_horario, data_horario)
            grid on
            s(2) = subplot(3,1,2)
            plot(t_horario, data_horario)
            grid on
            s(3) = subplot(3, 1, 3)
            plot(t_ma, ma+data_horario)
            hold on
            plot(t_ma, ma)
            plot(t_horario, data_horario)
            grid on
            dateaxis('x', 10)
            linkaxes([s], 'x')

            Forzamiento.MA_05_45.ma = ma + data_horario;
            Forzamiento.MA_05_45.t_ma=t_ma;
            
        end
    else
        Forzamiento.MA.ma=ma;
        Forzamiento.MA.t_ma=t_ma;

    end


end

%% Cargo la serie de caudales
if Forz_input.Q==0
else   
    
    data = load('DATOS\DESCARGA_FLUVIAL\descarga_fluvial_tratado.txt'); 
    tiempo_horario_interpolado = datenum(data(:, 1), data(:, 2), data(:, 3), data(:, 4), data(:, 4)*0, data(:, 4)*0);
    val1=find(tiempo_horario_interpolado==t_ini);
    val2=find(tiempo_horario_interpolado==t_fin);
    t_q=tiempo_horario_interpolado(val1:val2);
    q=data(val1:val2, 5);
    
% Comparo cada valor del forzamiento con el resto para ver si hay
% repeticiones que puedan dar error a la hora de elegir la muestra
%     tam=length(q);
%   
%     for k=1:tam
%         val=find(q(k+1:end)==q(k));
%         if isempty(val)
%         else
%         q(k)=q(k)+rand/10000000;
%         end
%         disp(k)
%     end
    
    Forzamiento.Q.q=q;
    Forzamiento.Q.t_q=t_q;

end
%% Cargo los datos de Oleaje
if Forz_input.OD==0
else 
    
    data = load(['DATOS\SIMAR\' file '.txt']);
    t_hor = datenum(data(:, 1), data(:, 2), data(:, 3), data(:, 4), data(:, 4)*0, data(:, 4)*0);
    h_hor = data(:, 5);
    tp_hor = data(:, 6);
    d_o_hor=data(:, 7);
    
    %Busco las posiciones iniciales y finales
    val1=find(t_hor==t_ini);
    val2=find(t_hor==t_fin);
    
    t_hor=t_hor(val1:val2);
    h_hor=h_hor(val1:val2);
    tp_hor=tp_hor(val1:val2);
    d_o_hor=d_o_hor(val1:val2);
    
    figure
    s(1) = subplot(3, 1, 1);
    plot(t_hor, h_hor)
    dateaxis('x', 10)
    grid on
    s(2) = subplot(3, 1, 2);
    plot(t_hor, tp_hor)
    dateaxis('x', 10)
    grid on
    s(3) = subplot(3, 1, 3);
    plot(t_hor, d_o_hor)
    dateaxis('x', 10)
    grid on
    linkaxes([s], 'x')
    
    % Comparo cada valor del forzamiento con el resto para ver si hay
    % repeticiones que puedan dar error a la hora de elegir la muestra
%     tam=length(h_hor);
%   
%     for k=1:tam
%         val=find(h_hor(k+1:end)==h_hor(k));
%         if isempty(val)
%         else
%         h_hor(k)=h_hor(k)+rand/10000000;
%         end
%         disp(k)
%     end    

    Forzamiento.OD.Hs=h_hor';
    Forzamiento.OD.Tp=tp_hor';
    Forzamiento.OD.Do=d_o_hor';
    Forzamiento.OD.t_horario=t_hor';

end

%% Cargo los datos de oleaje ya propagado a la desembocadura
% if Forz_input.OD==0
% else 
% addpath('DATOS')
% load('DATOS\OLEAJE_PROPAGAD_DESEMBOCADURA\Oleaje_propagado_desembocadura_con_viento.mat')
% t_hor=t_ini:1/24:t_fin;
% 
% %Busco las posiciones iniciales y finales
% val1=find(t_hor==t_ini);
% val2=find(t_hor==t_fin);
% 
% t_hor=t_hor(val1:val2);
% S.S_Hs=S.S_Hs(val1:val2);
% S.S_Tp=S.S_Tp(val1:val2);
% S.S_Do=S.S_Do(val1:val2);
% 
% Forzamiento.OD.Hs=S.S_Hs';
% Forzamiento.OD.Tp=S.S_Tp';
% Forzamiento.OD.Do=S.S_Do';
% Forzamiento.OD.t_horario=t_hor';
% 
% end

%% Cargo los datos de oleaje ya propagado a la desembocadura sin viento
if Forz_input.ODSV==0
else 
addpath('DATOS')
load('Oleaje_propagado_sin_viento.mat')
t_hor=t_ini:1/24:t_fin;

%Se corrigen los valores extraños de dirección
dir_media=mean(S.S_Do);
val=find(S.S_Do<200);
S.S_Do(val)=dir_media;  

Forzamiento.ODSV.Hs=S.S_Hs';
Forzamiento.ODSV.Tp=S.S_Tp';
Forzamiento.ODSV.Do=S.S_Do';
Forzamiento.ODSV.t_horario=t_hor;

end

%% Cargo los datos de viento y presion a nivel del mar
if Forz_input.MM==0
else
    
    % Velocidad de viento
    
    data = load(['DATOS\SIMAR\' file '.txt']);
    t_hor = datenum(data(:, 1), data(:, 2), data(:, 3), data(:, 4), data(:, 4)*0, data(:, 4)*0);
    vv_hor = data(:, 8);
    d_v_hor = data(:, 9);
    pnm_hor = data(:, 10);
    
    %Busco las posiciones iniciales y finales
    val1=find(t_hor==t_ini);
    val2=find(t_hor==t_fin);
    
    t_hor = t_hor(val1:val2);
    vv_hor = vv_hor(val1:val2);
    d_v_hor = d_v_hor(val1:val2);
    pnm_hor = pnm_hor(val1:val2);
        
    % Comparo cada valor del forzamiento con el resto para ver si hay
    % repeticiones que puedan dar error a la hora de elegir la muestra
%     tam=length(vv_hor);
%   
%     for k=1:tam
%         val=find(vv_hor(k+1:end)==vv_hor(k));
%         if isempty(val)
%         else
%         vv_hor(k)=vv_hor(k)+rand/10000000;
%         end
%     end

    Forzamiento.MM.vv=vv_hor';
    Forzamiento.MM.d_v=d_v_hor';
    Forzamiento.MM.pnm=pnm_hor;
    Forzamiento.MM.t_horario=t_hor';
    
  
end


        
% %% Cargo los datos de presion a nivel del mar
% if Forz_input.PNM==0
% else
%     datos = load('DATOS\PRESION\presion_nivel_mar.csv');
% 
%     % Vector teorico de tiempos horario
%     t_ini_presion = datenum(1957,09,01,00,00,00);
%     t_fin_presion = datenum(2017, 06, 30, 18, 00, 00);
%     t_total = [t_ini_presion: 1/24: t_fin_presion];
% 
%     % Datos de presion a nivel del mar
%     pnm = datos(:, 3);
%     
%     %Busco las posiciones iniciales y finales
%     val1=find(t_total==t_ini);
%     val2=find(t_total==t_fin);
%     
%     t_hor=t_total(val1:val2);
%     pnm_hor=pnm(val1:val2);
%     
%     Forzamiento.PNM.pnm=pnm_hor;
%     Forzamiento.PNM.t_horario=t_hor;
% 
% end


end

