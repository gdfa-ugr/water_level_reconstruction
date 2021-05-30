function [Forzamiento_3h] = REDUCCION_VOLUMEN(Forz_input, Forzamiento, slr_sc)

%% Genero serie de SLR
if Forz_input.SLR == 1 && Forz_input.MA==0 && Forz_input.Q==0 && Forz_input.MM==0 && Forz_input.OD==0

    if strcmp(slr_sc, '95_85')
        Forzamiento_3h.SLR_95_85.slr=Forzamiento.SLR_95_85.slr(1:3:end);
        Forzamiento_3h.SLR_95_85.t_horario=Forzamiento.SLR_95_85.t_horario(1:3:end);           
    elseif strcmp(slr_sc, '05_45')
        Forzamiento_3h.SLR_05_45.slr=Forzamiento.SLR_05_45.slr(1:3:end);
        Forzamiento_3h.SLR_05_45.t_horario=Forzamiento.SLR_05_45.t_horario(1:3:end);
    end

end


%% Genero serie de marea
if Forz_input.MA==0
else   
    if Forz_input.SLR == 0    
        Forzamiento_3h.MA.ma=Forzamiento.MA.ma(1:3:end);
        Forzamiento_3h.MA.t_ma=Forzamiento.MA.t_ma(1:3:end);
    else
        if strcmp(slr_sc, '95_85')
            Forzamiento_3h.MA_95_85.ma=Forzamiento.MA_95_85.ma(1:3:end);
            Forzamiento_3h.MA_95_85.t_ma=Forzamiento.MA_95_85.t_ma(1:3:end);           
        elseif strcmp(slr_sc, '05_45')
            Forzamiento_3h.MA_05_45.ma=Forzamiento.MA_05_45.ma(1:3:end);
            Forzamiento_3h.MA_05_45.t_ma=Forzamiento.MA_05_45.t_ma(1:3:end);
        end
        
    end

end

%% Cargo la serie de caudales
if Forz_input.Q==0
else   
    
    Forzamiento_3h.Q.q=Forzamiento.Q.q(1:3:end);
    Forzamiento_3h.Q.t_q=Forzamiento.Q.t_q(1:3:end);

end
%% Cargo los datos de Oleaje
if Forz_input.O==0
else 
    
    Forzamiento_3h.O.h=Forzamiento.O.h(1:3:end);
    Forzamiento_3h.O.tp=Forzamiento.O.tp(1:3:end);
    Forzamiento_3h.O.d_o=Forzamiento.O.d_o(1:3:end);
    Forzamiento_3h.O.t_horario=Forzamiento.O.t_horario(1:3:end);

end

%% Cargo los datos de oleaje ya propagado a la desembocadura
if Forz_input.OD==0
else 

    Forzamiento_3h.OD.Hs=Forzamiento.OD.Hs(1:3:end);
    Forzamiento_3h.OD.Tp=Forzamiento.OD.Tp(1:3:end);
    Forzamiento_3h.OD.Do=Forzamiento.OD.Do(1:3:end);
    Forzamiento_3h.OD.t_horario=Forzamiento.OD.t_horario(1:3:end);

end

%% Cargo los datos de oleaje ya propagado a la desembocadura sin viento
if Forz_input.ODSV==0
else 

    Forzamiento_3h.ODSV.Hs=Forzamiento.ODSV.Hs(1:3:end);
    Forzamiento_3h.ODSV.Tp=Forzamiento.ODSV.Tp(1:3:end);
    Forzamiento_3h.ODSV.Do=Forzamiento.ODSV.Do(1:3:end);
    Forzamiento_3h.ODSV.t_horario=Forzamiento.ODSV.t_horario(1:3:end);

end

%% Cargo los datos de viento
if Forz_input.MM==0
else
    
    Forzamiento_3h.MM.vv=Forzamiento.MM.vv(1:3:end);
    Forzamiento_3h.MM.d_v=Forzamiento.MM.d_v(1:3:end);
    Forzamiento_3h.MM.t_horario=Forzamiento.MM.t_horario(1:3:end);
    Forzamiento_3h.MM.pnm=Forzamiento.MM.pnm(1:3:end);

end



end
