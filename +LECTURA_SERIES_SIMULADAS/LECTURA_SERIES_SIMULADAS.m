function [Forzamiento]=LECTURA_SERIES_SIMULADAS(Forz_input,t_ini,t_fin, file, slr_sc, dir_sim, sim, Forzamiento_HC, PC)

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
    
    
    
    if strcmp(slr_sc, '95_85')
        data = load(['DATOS\SUBIDA_NIVEL_DEL_MAR\slr_' slr_sc '_tratado.txt']);
        t_horario = t_ma;
        t_anual = datenum(data(:, 1), data(:, 1)*0+1, data(:, 1)*0+1, data(:, 1)*0+1, data(:, 1)*0, data(:, 1)*0);

        data_horario = interp1(t_anual, data(:, 2), t_horario);

%         figure
%         s(1) = subplot(3,1,1)
%         plot(t_horario, data_horario)
%         grid on
%         dateaxis('x', 10)
%         linkaxes([s], 'x')
        
        Forzamiento.SLR_95_85.slr = data_horario;
        Forzamiento.SLR_95_85.t_horario = t_ma;

    elseif strcmp(slr_sc, '05_45')
        data = load(['DATOS\SUBIDA_NIVEL_DEL_MAR\slr_' slr_sc '_tratado.txt']);
        t_horario = t_ma;
        t_anual = datenum(data(:, 1), data(:, 1)*0+1, data(:, 1)*0+1, data(:, 1)*0+1, data(:, 1)*0, data(:, 1)*0);

        data_horario = interp1(t_anual, data(:, 2), t_horario);

%         figure
%         s(1) = subplot(3,1,1)
%         plot(t_horario, data_horario)
%         grid on
%         dateaxis('x', 10)
%         linkaxes([s], 'x')

        Forzamiento.SLR_05_45.slr = data_horario;
        Forzamiento.SLR_05_45.t_horario=t_ma;

    end

end



%% Genero serie de marea
if Forz_input.MA==0
else   
    
    load(['DATOS\MAREA_ASTRONOMICA\data.mat']);

    
    % Busco los datos en el espacio temporal elegido para marea
    t = SerialDay;
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
    
%     figure
%     plot(t_ma, ma)
%     dateaxis('x', 10)
%     grid on

    if Forz_input.SLR == 1
        if strcmp(slr_sc, '95_85')
            data = load(['DATOS\SUBIDA_NIVEL_DEL_MAR\slr_' slr_sc '_tratado.txt']);
            t_horario = t_ma;
            t_anual = datenum(data(:, 1), data(:, 1)*0+1, data(:, 1)*0+1, data(:, 1)*0+1, data(:, 1)*0, data(:, 1)*0);

            data_horario = interp1(t_anual, data(:, 2), t_horario);

%             figure
%             s(1) = subplot(3,1,1)
%             plot(t_horario, data_horario)
%             grid on
%             s(2) = subplot(3,1,2)
%             plot(t_horario, data_horario)
%             grid on
%             s(3) = subplot(3, 1, 3)
%             plot(t_ma, ma+data_horario)
%             hold on
%             plot(t_ma, ma)
%             plot(t_horario, data_horario)
%             grid on
%             dateaxis('x', 10)
%             linkaxes([s], 'x')

            Forzamiento.MA_95_85.ma = ma + data_horario;
            Forzamiento.MA_95_85.t_ma=t_ma;
            
        elseif strcmp(slr_sc, '05_45')
            data = load(['DATOS\SUBIDA_NIVEL_DEL_MAR\slr_' slr_sc '_tratado.txt']);
            t_horario = t_ma;
            t_anual = datenum(data(:, 1), data(:, 1)*0+1, data(:, 1)*0+1, data(:, 1)*0+1, data(:, 1)*0, data(:, 1)*0);

            data_horario = interp1(t_anual, data(:, 2), t_horario);

%             figure
%             s(1) = subplot(3,1,1)
%             plot(t_horario, data_horario)
%             grid on
%             s(2) = subplot(3,1,2)
%             plot(t_horario, data_horario)
%             grid on
%             s(3) = subplot(3, 1, 3)
%             plot(t_ma, ma+data_horario)
%             hold on
%             plot(t_ma, ma)
%             plot(t_horario, data_horario)
%             grid on
%             dateaxis('x', 10)
%             linkaxes([s], 'x')

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
    
    % Read this file to extract time
    data = load('DATOS\DESCARGA_FLUVIAL\descarga_fluvial_tratado.txt'); 
    tiempo_horario_interpolado = datenum(data(:, 1), data(:, 2), data(:, 3), data(:, 4), data(:, 4)*0, data(:, 4)*0);
    val1=find(tiempo_horario_interpolado==t_ini);
    val2=find(tiempo_horario_interpolado==t_fin);
    t_q=tiempo_horario_interpolado(val1:val2);
    
    if sim == 1
        data=data(val1:val2, 5);
    elseif sim ~= 1
        % Read simulation file
        directory = [dir_sim, '\descarga_fluvial_500', '\descarga_fluvial_guadalete_sim_', num2str(sim,'%04.f'), '.txt'];
        data = readtable(directory, 'HeaderLines', 1);
        data = table2array(data(:, 2));
        data = data(val1:val2);
    end
    
    % Limit maximum values to the maximum of the hindcasting to avoid
    % distorsion in the RBF reconstruction
    %data(data > max(Forzamiento_HC.Q.q)) = max(Forzamiento_HC.Q.q);

    
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
    
    Forzamiento.Q.q=data;
    Forzamiento.Q.t_q=t_q;

end

%% Cargo la serie de oleaje
if Forz_input.OD==0
else   
    
    % Read this file to extract time
    data = load('DATOS\SIMAR\simar_simulado_tratrado.txt'); 
    tiempo_horario_interpolado = datenum(data(:, 1), data(:, 2), data(:, 3), data(:, 4), data(:, 4)*0, data(:, 4)*0);
    val1=find(tiempo_horario_interpolado==t_ini);
    val2=find(tiempo_horario_interpolado==t_fin);
    t_=tiempo_horario_interpolado(val1:val2);
    
    if sim == 1
        data_aux = data(val1:val2, 5:7);
        data = data_aux;
    elseif sim ~= 1
        % Read simulation file
        directory = [dir_sim, '\wave_wind_slp_offshore_500', '\wave_wind_slp_guadalete_offshore_sim_', num2str(sim,'%04.f'), '.txt'];
        data = readtable(directory, 'HeaderLines', 1);
        data = table2array(data(:, 2:7));
        data = data(val1:val2, :);
    end
    
%     % Limit maximum values to the maximum of the hindcasting to avoid
%     % distorsion in the RBF reconstruction
%     data(data(:, 1) > max(Forzamiento_HC.O.h), 1) = max(Forzamiento_HC.O.h);
%     data(data(:, 2) > max(Forzamiento_HC.O.tp), 2) = max(Forzamiento_HC.O.tp);
%     data(data(:, 3) > max(Forzamiento_HC.O.d_o), 3) = max(Forzamiento_HC.O.d_o);
%     data(data(:, 4) > max(Forzamiento_HC.MM.vv), 4) = max(Forzamiento_HC.MM.vv);
%     data(data(:, 5) > max(Forzamiento_HC.MM.d_v), 5) = max(Forzamiento_HC.MM.d_v);
%     %data(data(:, 6) > max(Forzamiento_HC.MM.pnm), 6) = max(Forzamiento_HC.MM.pnm);

    
    Forzamiento.OD.t_horario = t_';
    Forzamiento.OD.Hs = data(:, 1)';
    Forzamiento.OD.Tp = data(:, 2)';
    Forzamiento.OD.Do = data(:, 3)';
end

%% Cargo la serie de oleaje
if Forz_input.O==0
else  
    
    % Read this file to extract time
    data = load('DATOS\SIMAR\simar_simulado_tratrado.txt'); 
    tiempo_horario_interpolado = datenum(data(:, 1), data(:, 2), data(:, 3), data(:, 4), data(:, 4)*0, data(:, 4)*0);
    val1=find(tiempo_horario_interpolado==t_ini);
    val2=find(tiempo_horario_interpolado==t_fin);
    t_=tiempo_horario_interpolado(val1:val2);
    
    % Hs
    M = 600;
    PC = 268;
    VAR = 'Hs';    
    file_name=['O_MM_' VAR '_' 'M=' num2str(M) '_PC_' num2str(PC) '_sim_' num2str(sim,'%04.f')];
    Hs = load(['DATOS\RADIAL_BASIS_FUNCTION\PROPAGACION_REGIMEN_MEDIO\O_MM_\' VAR '\' file_name '.mat']);
    
    % Tp
    M = 600;
    PC = 268;
    VAR = 'Tp';    
    file_name=['O_MM_' VAR '_' 'M=' num2str(M) '_PC_' num2str(PC) '_sim_' num2str(sim,'%04.f')];
    Tp = load(['DATOS\RADIAL_BASIS_FUNCTION\PROPAGACION_REGIMEN_MEDIO\O_MM_\' VAR '\' file_name '.mat']);
    
    % Do
    M = 600;
    PC = 268;
    VAR = 'Do';    
    file_name=['O_MM_' VAR '_' 'M=' num2str(M) '_PC_' num2str(PC) '_sim_' num2str(sim,'%04.f')];
    Do = load(['DATOS\RADIAL_BASIS_FUNCTION\PROPAGACION_REGIMEN_MEDIO\O_MM_\' VAR '\' file_name '.mat']);
   
    Forzamiento.OD.t_horario = t_';
    Forzamiento.OD.Hs = Hs.S';
    Forzamiento.OD.Tp = Tp.S';
    Forzamiento.OD.Do = Do.S';
end

if Forz_input.MM == 0
else
    % Read this file to extract time
    data = load('DATOS\SIMAR\simar_simulado_tratrado.txt'); 
    tiempo_horario_interpolado = datenum(data(:, 1), data(:, 2), data(:, 3), data(:, 4), data(:, 4)*0, data(:, 4)*0);
    val1=find(tiempo_horario_interpolado==t_ini);
    val2=find(tiempo_horario_interpolado==t_fin);
    t_=tiempo_horario_interpolado(val1:val2);
    
    if sim == 1
        data_aux = data(val1:val2, 5:10);
        data = data_aux;
    elseif sim ~= 1
        % Read simulation file
        directory = [dir_sim, '\wave_wind_slp_offshore_500', '\wave_wind_slp_guadalete_offshore_sim_', num2str(sim,'%04.f'), '.txt'];

        data = readtable(directory, 'HeaderLines', 1);
        data = table2array(data(:, 2:7));
        data = data(val1:val2, :);
    end    

    
%     % Limit maximum values to the maximum of the hindcasting to avoid
%     % distorsion in the RBF reconstruction
%     data(data(:, 4) > max(Forzamiento_HC.MM.vv), 4) = max(Forzamiento_HC.MM.vv);
%     data(data(:, 5) > max(Forzamiento_HC.MM.d_v), 5) = max(Forzamiento_HC.MM.d_v);
%     data(data(:, 6) > max(Forzamiento_HC.MM.pnm), 6) = max(Forzamiento_HC.MM.pnm);

    Forzamiento.MM.t_horario = t_';
    Forzamiento.MM.vv = data(:, 4)';
    Forzamiento.MM.d_v = data(:, 5)';
    Forzamiento.MM.pnm = data(:, 6);
    
    
end