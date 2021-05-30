function GENERACION_SIMULACIONES_CASO_1_OPC_2_Q_CALIBRACION(Forzamiento,t_ini_sim,t_fin_sim,NP)
t_ini_sim_vect=datevec(t_ini_sim);
t_fin_sim_vect=datevec(t_fin_sim);
    
% En primer lugar me creo las carpetas para la simulación
names = fieldnames(Forzamiento);
l=length(names);
fold_name='';
for j=1:l
   fold_name=[fold_name char(names(j)),'_']; 
end


    sim_calibracion=['Sim_' fold_name NP '_calibracion_' num2str(t_ini_sim_vect(1)) '_' num2str(t_ini_sim_vect(2)) '_' num2str(t_ini_sim_vect(3))];

    % Si ya existe el directorio no lo vuelvo a crear        
    if exist(['..\SIMULACIONES\DATOS\SIMULACIONES_CALIBRACION\Sim_' fold_name '\' NP '\' sim_calibracion],'dir')==7
        %break
    else
        %Creo el directorio
        mkdir(['..\SIMULACIONES\DATOS\SIMULACIONES_CALIBRACION\Sim_' fold_name '\' NP '\' sim_calibracion])


        % Copio la simulación base a los directorios
        source=['..\SIMULACIONES\DATOS\SIMULACIONES_BASE\Sim_' fold_name '\' NP];

        %Sim_sintetica
        destination_sintetica=['..\SIMULACIONES\DATOS\SIMULACIONES_CALIBRACION\Sim_' fold_name '\' NP '\' sim_calibracion];
        copyfile(source,destination_sintetica);



        file_fcad_sintetico=[destination_sintetica '\fcad.mdf'];
        file_fguad_sintetico=[destination_sintetica '\fguad.mdf'];
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
        q=Forzamiento.(names{1}).(var{1});
        pos_ini=find(t==t_ini_sim);       

        %Extarigo el instante de inicio y de final
        t_ini=t_ini_sim;
        t_ini_vec=datevec(t_ini);
        t_fin=t_fin_sim;
        t_fin_vector=datevec(t_fin);

        %Valor inicial de elevación
        eta0=0;

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

    end  

end
                
            
        
       
        





                

         