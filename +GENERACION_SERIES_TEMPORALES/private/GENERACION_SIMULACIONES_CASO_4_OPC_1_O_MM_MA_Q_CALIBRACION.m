function GENERACION_SIMULACIONES_CASO_4_OPC_1_O_MM_MA_Q_CALIBRACION(Forzamiento,t_ini_sim,t_fin_sim,NP)
t_ini_sim_vect=datevec(t_ini_sim);
t_fin_sim_vect=datevec(t_fin_sim);

% En primer lugar me creo las carpetas para la simulación
names = fieldnames(Forzamiento);
l=length(names);
fold_name='';
for j=1:l
   fold_name=[fold_name char(names(j)),'_']; 
end

% SIMULACION SINTETICA
    sim_calibracion=['Sim_' fold_name NP '_calibracion_' num2str(t_ini_sim_vect(1)) '_' num2str(t_ini_sim_vect(2)) '_' num2str(t_ini_sim_vect(3))];

    % Si ya existe el directorio no lo vuelvo a crear        
    if exist(['..\SIMULACIONES\DATOS\SIMULACIONES_CALIBRACION\Sim_' fold_name '\' NP '\' sim_calibracion],'dir')==7
        
    else
        mkdir(['..\SIMULACIONES\DATOS\SIMULACIONES_CALIBRACION\Sim_' fold_name '\' NP '\' sim_calibracion])

        % Copio la simulación base a los directorios
        source=['..\SIMULACIONES\DATOS\SIMULACIONES_BASE\Sim_' fold_name '\' NP];                

        %Sim_sintetica
        destination_sintetica=['..\SIMULACIONES\DATOS\SIMULACIONES_CALIBRACION\Sim_' fold_name '\' NP '\' sim_calibracion];
        copyfile(source,destination_sintetica);               


        file_fcad_sintetico=[destination_sintetica '\fcad.mdf'];
        file_fguad_sintetico=[destination_sintetica '\fguad.mdf'];
        file_wguad_sintetico=[destination_sintetica '\wguad.mdw'];
        clear l names source

        % Busco los inicios y finales de periodo para la simulacion

        %La simulación real la inicio 23 h antes de que se produzca el
        %valor del forzamiento +/- 8 h para emepezar en eta igual a 0
        %puesto que la marea pasa por 0 cada 6h. Finalizo 1 días despues de
        %que se produzca el valor del forzamiento.

        %Extaigo el vector de tiempo y elevación
        names = fieldnames(Forzamiento);
        var=fieldnames(Forzamiento.(names{1}));
        t=Forzamiento.(names{1}).(var{end});
        eta=Forzamiento.(names{1}).(var{1});
        pos_ini=find(t==t_ini_sim)
        pos_fin=find(t==t_fin_sim)
        
        names = fieldnames(Forzamiento);
        var=fieldnames(Forzamiento.(names{2}));
        q=Forzamiento.(names{2}).(var{1});                

        %Extarigo el instante de inicio y de final
        t_ini=t_ini_sim;
        t_ini_vec=datevec(t_ini);
        t_fin=t_fin_sim;
        t_fin_vector=datevec(t_fin);

        %Valor inicial de elevación
        eta0=eta(pos_ini);

        %Tiempo de simulación
        t_sim_vec=datevec(t_ini:1/24:t_fin);

        % MODIFICO EL ARCHIVO FCAD SINTETICO
        file=file_fcad_sintetico;
        key={'Itdate','Tstart','Tstop','Zeta0'};
        %Dato itdate
        itdate=strcat('#',num2str(t_ini_vec(1,1),'%02i'),'-',num2str(t_ini_vec(1,2),'%02i'),'-',num2str(t_ini_vec(1,3),'%02i'),'#');
        %dato tstart and tstop
        hora_ini=t_sim_vec(1,4)*60;
        long=length(t_sim_vec(:,1));
        t_delft=hora_ini:60:hora_ini+(long-1)*60;
        tstart=num2str(t_delft(1));
        tstop=num2str(t_delft(end));
        eta0=num2str(eta0);

        value={itdate,tstart,tstop,eta0};
        bak='1';
        del='1';        
        PROG_1_DELFT_PARSER_CASO_1_OPC_1(file, key, value, bak, del);

        clear key value
        key={'Flmap','Flhis','Flpp'};
        Flmap=strcat(tstart ,{' '},'1440',{'  '},tstop);
        Flhis=strcat(tstart ,{' '},'60',{'  '},tstop);
        Flpp=strcat(tstart ,{' '},'60',{'  '},tstop);

        value={Flmap,Flhis,Flpp};
        bak='1';
        del='1';
        PROG_2_DELFT_PARSER_CASO_1_OPC_1(file, key, value, bak, del);

        % MODIFICO EL ARCHIVO FGUAD SINTETICO
        file=file_fguad_sintetico;
        key={'Itdate','Tstart','Tstop','Zeta0'};

        value={itdate,tstart,tstop,eta0};
        bak='1';
        del='1';
        PROG_1_DELFT_PARSER_CASO_1_OPC_1(file, key, value, bak, del);

        clear key value
        key={'Flmap','Flhis','Flpp'};
        Flmap=strcat(tstart ,{' '},'1440',{'  '},tstop);
        Flhis=strcat(tstart ,{' '},'60',{'  '},tstop);
        Flpp=strcat(tstart ,{' '},'60',{'  '},tstop);

        value={Flmap,Flhis,Flpp};
        bak='1';
        del='1';
        PROG_2_DELFT_PARSER_CASO_1_OPC_1(file, key, value, bak, del);    

        % MODIFICO EL ARCHIVO DISCHARGE SINTETICO
        file='descarga1.dis';
        nSections=4; % Número de puntos de descarga
        referenceTime=[num2str(t_ini_vec(1,1),'%02i') num2str(t_ini_vec(1,2),'%02i') num2str(t_ini_vec(1,3),'%02i')]; %Fecha de referencia
        nRecords=length(t_delft);
        % Generación  de la matriz con la descarga
        pos_ini=find(t==t_ini);
        pos_fin=find(t==t_fin);
        Q_Delft=zeros(nRecords,1);
        Q_Delft=Forzamiento.Q.q(pos_ini:pos_fin)

        records(:,1)=t_delft;
        records(:,2)=Q_Delft/nSections; % El caudal que se vierte en cada punto lo divido entre el número de puntos   


        DELFT_DISCHARGE_FILE(file, nSections, referenceTime, nRecords, records)

        source='descarga1.dis';
        pause(1)
        copyfile(source,destination_sintetica)
        delete('descarga1.dis')

        % MODIFICO LOS ARCHIVOS WIND SINTETICOS
        %Extaigo el vector de velocidad y dirección de viento
        names = fieldnames(Forzamiento);
        var=fieldnames(Forzamiento.(names{3}));
        t=Forzamiento.(names{3}).(var{end});
        vv=Forzamiento.(names{3}).(var{1});
        d_v=Forzamiento.(names{3}).(var{2});                

        nRecords=length(t_delft);

        VV_Delft=vv(pos_ini:pos_fin);
        DV_Delft=d_v(pos_ini:pos_fin);

        records(:,1)=t_delft;
        records(:,2)=VV_Delft;
        records(:,3)=DV_Delft;

        save 'viento_fcad.wnd' records -ASCII
        save 'viento_fguad.wnd' records -ASCII               

        source='viento_fcad.wnd';
        pause(1)
        copyfile(source,destination_sintetica)
        delete('viento_fcad.wnd')

        source='viento_fguad.wnd';
        pause(1)
        copyfile(source,destination_sintetica)
        delete('viento_fguad.wnd')


        % MODIFICO EL ARCHIVO WGUAD SINTETICO
        file=file_wguad_sintetico;
        ReferenceDate=strcat(num2str(t_ini_vec(1,1),'%02i'),'-',num2str(t_ini_vec(1,2),'%02i'),'-',num2str(t_ini_vec(1,3),'%02i'));
        key={'ReferenceDate'};

        value={ReferenceDate};
        bak='1';
        del='1';        
        PROG_1_DELFT_PARSER_CASO_1_OPC_1(file, key, value, bak, del); 
        
        % ME GENERO EL ARCHIVO WAVECON
        names = fieldnames(Forzamiento);
        var=fieldnames(Forzamiento.(names{4}));
        t=Forzamiento.(names{4}).(var{end});
        Hs=Forzamiento.(names{4}).(var{1});
        Tp=Forzamiento.(names{4}).(var{2});                
        d_o=Forzamiento.(names{4}).(var{3});

        records(:,1)=t_delft;
        records(:,2)=Hs(pos_ini:pos_fin);
        records(:,3)=Tp(pos_ini:pos_fin);
        records(:,4)=d_o(pos_ini:pos_fin);
        records(:,5)=Hs(pos_ini:pos_fin)*0+1;
        records(:,6)=eta(pos_ini:pos_fin);
        records(:,7)=VV_Delft;
        records(:,8)=DV_Delft;

        save 'wavecon.wguad' records -ASCII
        
        source='wavecon.wguad';
        pause(1)
        copyfile(source,destination_sintetica)
        delete('wavecon.wguad')
        
    
    end
    
        
        


end