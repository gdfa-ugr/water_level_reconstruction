function X = AGRUPACION_AGENTES_NORMALIZADOS_HORARIOS(Forzamiento_norm)

    %Obtengo los forzamientos que se han elegido
    names = fieldnames(Forzamiento_norm);
    l=length(names);
    
    fold_name='';
    for j=1:l
       fold_name=[fold_name char(names(j)),'_']; 
    end

    %Generación del vector x en función de los forzamientos elegidos
    x=[];
    for j=1:l

       forz=Forzamiento_norm.(names{j});
       var=fieldnames(Forzamiento_norm.(names{j}));

       comp_oleaje=strcmp(names{j},'O');
       comp_Oleaje_desembocadura=strcmp(names{j},'OD');   
       comp_Oleaje_desembocadura_sin_viento=strcmp(names{j},'ODSV'); 
       comp_m_meteo=strcmp(names{j},'MM');
       if comp_oleaje
          h_norm=Forzamiento_norm.(names{j}).(var{1}); 
          tp_norm=Forzamiento_norm.(names{j}).(var{2});
          d_o_norm=Forzamiento_norm.(names{j}).(var{3});
          x=[x  h_norm  tp_norm  d_o_norm];

       elseif comp_Oleaje_desembocadura
          Hs_norm=Forzamiento_norm.(names{j}).(var{1}); 
          Tp_norm=Forzamiento_norm.(names{j}).(var{2});
          Do_norm=Forzamiento_norm.(names{j}).(var{3});
          x=[x  Hs_norm  Tp_norm  Do_norm];

       elseif comp_Oleaje_desembocadura_sin_viento
          Hs_norm=Forzamiento_norm.(names{j}).(var{1}); 
          Tp_norm=Forzamiento_norm.(names{j}).(var{2});
          Do_norm=Forzamiento_norm.(names{j}).(var{3});
          x=[x  Hs_norm  Tp_norm  Do_norm];

       elseif comp_m_meteo
           if strcmp(fold_name,'O_MM_')
            vv_norm=Forzamiento_norm.(names{j}).(var{1}); 
            d_v_norm=Forzamiento_norm.(names{j}).(var{2});
            x=[x  vv_norm  d_v_norm];
           else
            vv_norm=Forzamiento_norm.(names{j}).(var{1}); 
            d_v_norm=Forzamiento_norm.(names{j}).(var{2});
            pnm_norm=Forzamiento_norm.(names{j}).(var{6}); 
            x=[x  vv_norm  d_v_norm  pnm_norm];               
           end

       else
          var=Forzamiento_norm.(names{j}).(var{1});
          x=[x  var];
       end

    end

    X=x; %Guardo mis forzamientos normalizados en una variable X porque a x le
    % voy a ir quitando elementos.

end


