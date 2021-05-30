function [Forzamiento_norm]=NORMALIZACION(Forzamiento, Forzamiento_HC, Forz_input, slr_sc)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% NORMALIZACION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%_________________________________________________________________________
% 
% Descripcion: Funcion que me normaliza entre 0 y 1 las series temporales
% de los forzamientos .
%
% Datos de entrada:
% 1. Forzamiento: Estructura con las series temporales de los forzamientos 
% considerados
% 2. Forz_input: Estructura que indica con 1 los forzamientos a considerar
% y con 0 el resto
%
% Datos de salida:
% 1. Forzamiento_norm: Estructura con las series temporales de los 
% forzamientos considerados normalizados
%
%                                              Granada, 15 de marzo de 2016
%                                                     Juan del Rosal Salido
%                                   Grupo de Dinámica de Flujos Ambientales 
%                                                    Universidad de Granada
%__________________________________________________________________________

%% SLR 
if Forz_input.SLR==1 && Forz_input.MA==0 && Forz_input.Q==0 && Forz_input.MM==0 && Forz_input.OD==0
 
    if Forz_input.SLR == 1 && strcmp(slr_sc, '95_85')
        ma_min=min(Forzamiento_HC.SLR_95_85.slr);
        ma_max=max(Forzamiento_HC.SLR_95_85.slr);
        slr_norm=(Forzamiento.SLR_95_85.slr-ma_min)./(ma_max-ma_min);
        Forzamiento_norm.SLR_95_85.slr_norm=slr_norm;
        Forzamiento_norm.SLR_95_85.t_horario=Forzamiento.SLR_95_85.t_horario;
        Forzamiento_norm.SLR_95_85.ma_min=ma_min;
        Forzamiento_norm.SLR_95_85.ma_max=ma_max;

        
    elseif Forz_input.SLR == 1 && strcmp(slr_sc, '05_45')
        ma_min=min(Forzamiento_HC.SLR_05_45.slr);
        ma_max=max(Forzamiento_HC.SLR_05_45.slr);
        slr_norm=(Forzamiento.SLR_05_45.slr-ma_min)./(ma_max-ma_min);
        Forzamiento_norm.SLR_05_45.slr_norm=slr_norm;
        Forzamiento_norm.SLR_05_45.t_horario=Forzamiento.SLR_05_45.t_horario;
        Forzamiento_norm.SLR_05_45.ma_min=ma_min;
        Forzamiento_norm.SLR_05_45.ma_max=ma_max;

    end
    
end


%% M. Astro
if Forz_input.MA==0
else 
    if Forz_input.SLR == 0
        ma_min=min(Forzamiento_HC.MA.ma);
        ma_max=max(Forzamiento_HC.MA.ma);
        ma_norm=(Forzamiento.MA.ma-ma_min)./(ma_max-ma_min);
        Forzamiento_norm.MA.ma_norm=ma_norm;
        Forzamiento_norm.MA.t_ma=Forzamiento.MA.t_ma;
        Forzamiento_norm.MA.ma_min=ma_min;
        Forzamiento_norm.MA.ma_max=ma_max;
    
    elseif Forz_input.SLR == 1 && strcmp(slr_sc, '95_85')
        ma_min=min(Forzamiento.MA_95_85.ma);
        ma_max=max(Forzamiento.MA_95_85.ma);
        ma_norm=(Forzamiento.MA_95_85.ma-ma_min)./(ma_max-ma_min);
        Forzamiento_norm.MA_95_85.ma_norm=ma_norm;
        Forzamiento_norm.MA_95_85.t_ma=Forzamiento.MA_95_85.t_ma;
        Forzamiento_norm.MA_95_85.ma_min=ma_min;
        Forzamiento_norm.MA_95_85.ma_max=ma_max;

        
    elseif Forz_input.SLR == 1 && strcmp(slr_sc, '05_45')
        ma_min=min(Forzamiento.MA_05_45.ma);
        ma_max=max(Forzamiento.MA_05_45.ma);
        ma_norm=(Forzamiento.MA_05_45.ma-ma_min)./(ma_max-ma_min);
        Forzamiento_norm.MA_05_45.ma_norm=ma_norm;
        Forzamiento_norm.MA_05_45.t_ma=Forzamiento.MA_05_45.t_ma;
        Forzamiento_norm.MA_05_45.ma_min=ma_min;
        Forzamiento_norm.MA_05_45.ma_max=ma_max;

    end
    
end

%% M. Astro desplaz
if Forz_input.MA_DESPLAZ==0
else 
    ma_min=min(Forzamiento.MA_DESPLAZ.ma);
    ma_max=max(Forzamiento.MA_DESPLAZ.ma);
    ma_norm=(Forzamiento.MA_DESPLAZ.ma-ma_min)./(ma_max-ma_min);
    Forzamiento_norm.MA_DESPLAZ.ma_norm=ma_norm;
    Forzamiento_norm.MA_DESPLAZ.t_ma=Forzamiento.MA_DESPLAZ.t_ma;
    Forzamiento_norm.MA_DESPLAZ.ma_min=ma_min;
    Forzamiento_norm.MA_DESPLAZ.ma_max=ma_max;
end

%% Descarga % !! IMPORTANTE !! Normalizar con los forzamientos HC
if Forz_input.Q==0
else
    q_min=min(Forzamiento_HC.Q.q);
    q_max=max(Forzamiento_HC.Q.q);
    q_norm=(Forzamiento.Q.q-q_min)./(q_max-q_min);
    Forzamiento_norm.Q.q_norm=q_norm;
    Forzamiento_norm.Q.t_q=Forzamiento.Q.t_q;
    Forzamiento_norm.Q.q_min=q_min;
    Forzamiento_norm.Q.q_max=q_max;
end


%% O
if Forz_input.O==0
else    
    h_max=max(Forzamiento_HC.O.h);
    h_min=min(Forzamiento_HC.O.h);
    h_norm=(Forzamiento.O.h-h_min)./(h_max-h_min);

    %Periodo
    tp_max=max(Forzamiento_HC.O.tp);
    tp_min=min(Forzamiento_HC.O.tp);
    tp_norm=(Forzamiento.O.tp-tp_min)./(tp_max-tp_min);

    %Dirección de procedencia de O
    d_o_rad=Forzamiento.O.d_o.*(pi/180);
    d_o_rad_norm=d_o_rad./(2*pi);
    
    Forzamiento_norm.O.h_norm=h_norm;
    Forzamiento_norm.O.tp_norm=tp_norm;
    Forzamiento_norm.O.d_o_rad_norm=d_o_rad_norm;
    Forzamiento_norm.O.t_horario=Forzamiento.O.t_horario;
    Forzamiento_norm.O.h_max=h_max;
    Forzamiento_norm.O.h_min=h_min;
    Forzamiento_norm.O.tp_max=tp_max;
    Forzamiento_norm.O.tp_min=tp_min;
end

%% OD
if Forz_input.OD==0
else    
    Hs_max=max(Forzamiento_HC.OD.Hs);
    Hs_min=min(Forzamiento_HC.OD.Hs);
    Hs_norm=(Forzamiento.OD.Hs-Hs_min)./(Hs_max-Hs_min);

    %Periodo
    Tp_max=max(Forzamiento_HC.OD.Tp);
    Tp_min=min(Forzamiento_HC.OD.Tp);
    Tp_norm=(Forzamiento.OD.Tp-Tp_min)./(Tp_max-Tp_min);

    %Dirección de procedencia de OD
    Do_rad=Forzamiento.OD.Do.*(pi/180);
    Do_rad_norm=Do_rad./(2*pi);
    
    Forzamiento_norm.OD.Hs_norm=Hs_norm';
    Forzamiento_norm.OD.Tp_norm=Tp_norm';
    Forzamiento_norm.OD.Do_rad_norm=Do_rad_norm';
    Forzamiento_norm.OD.t_horario=Forzamiento.OD.t_horario';
    Forzamiento_norm.OD.Hs_max=Hs_max;
    Forzamiento_norm.OD.Hs_min=Hs_min;
    Forzamiento_norm.OD.Tp_max=Tp_max;
    Forzamiento_norm.OD.Tp_min=Tp_min;
end

%% ODSV
if Forz_input.ODSV==0
else    
    Hs_max=max(Forzamiento_HC.ODSV.Hs);
    Hs_min=min(Forzamiento_HC.ODSV.Hs);
    Hs_norm=(Forzamiento.ODSV.Hs-Hs_min)./(Hs_max-Hs_min);

    %Periodo
    Tp_max=max(Forzamiento_HC.ODSV.Tp);
    Tp_min=min(Forzamiento_HC.ODSV.Tp);
    Tp_norm=(Forzamiento.ODSV.Tp-Tp_min)./(Tp_max-Tp_min);

    %Dirección de procedencia de ODSV
    Do_rad=Forzamiento.ODSV.Do.*(pi/180);
    Do_rad_norm=Do_rad./(2*pi);
    
    Forzamiento_norm.ODSV.Hs_norm=Hs_norm;
    Forzamiento_norm.ODSV.Tp_norm=Tp_norm;
    Forzamiento_norm.ODSV.Do_rad_norm=Do_rad_norm;
    Forzamiento_norm.ODSV.t_horario=Forzamiento.ODSV.t_horario;
    Forzamiento_norm.ODSV.Hs_max=Hs_max;
    Forzamiento_norm.ODSV.Hs_min=Hs_min;
    Forzamiento_norm.ODSV.Tp_max=Tp_max;
    Forzamiento_norm.ODSV.Tp_min=Tp_min;
end

%% Velocidad de viento y presion a nivel del mar
if Forz_input.MM==0
else  
    
    % Velocidad de viento
    vv_max=max(Forzamiento_HC.MM.vv);
    vv_min=min(Forzamiento_HC.MM.vv);
    vv_norm=(Forzamiento.MM.vv-vv_min)./(vv_max-vv_min);

    %Dirección de procedencia de viento
    d_v_rad=Forzamiento.MM.d_v.*(pi/180);
    d_v_rad_norm=d_v_rad./(2*pi);
    
    if Forz_input.O==0    
        % Presion a nivel del mar
        pnm_max=max(Forzamiento_HC.MM.pnm);
        pnm_min=min(Forzamiento_HC.MM.pnm);
        pnm_norm=(Forzamiento.MM.pnm-pnm_min)./(pnm_max-pnm_min);
    end

    Forzamiento_norm.MM.vv_norm=vv_norm';
    Forzamiento_norm.MM.d_v_rad_norm=d_v_rad_norm';
    Forzamiento_norm.MM.t_horario=Forzamiento.MM.t_horario';
    Forzamiento_norm.MM.vv_max=vv_max;
    Forzamiento_norm.MM.vv_min=vv_min;
    
    if Forz_input.O==0
        Forzamiento_norm.MM.pnm_norm=pnm_norm;
        Forzamiento_norm.MM.pnm_max=pnm_max;
        Forzamiento_norm.MM.pnm_min=pnm_min;
    end
    
end

end