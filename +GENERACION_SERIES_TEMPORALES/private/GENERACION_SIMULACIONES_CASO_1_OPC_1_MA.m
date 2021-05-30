function GENERACION_SIMULACIONES_CASO_1_OPC_1_MA(Forzamiento,pos,NP,M)

for k=1:M

        %% En primer lugar me creo las carpetas para la simulación
        names = fieldnames(Forzamiento);
        l=length(names);
        fold_name='';
        for j=1:l
           fold_name=[fold_name char(names(j)),'_']; 
        end
        
        sim_sintetica=['Sim_' fold_name NP '_sintetica_' num2str(k)];

        % Si ya existe el directorio no lo vuelvo a crear        
        if exist(['..\SIMULACIONES\DATOS\SIMULACIONES_MUESTRA\Sim_' fold_name '\' NP '\' sim_sintetica],'dir')==7
        else
            mkdir(['..\SIMULACIONES\DATOS\SIMULACIONES_MUESTRA\Sim_' fold_name '\' NP '\' sim_sintetica])

            if k==1 %Solo lo copio una vez
            % Copio la carpeta de DATOS COMUNES
            source=['..\SIMULACIONES\DATOS\SIMULACIONES_BASE\Sim_' fold_name '\' 'DATOS_COMUNES'];
            destination_sintetica=['..\SIMULACIONES\DATOS\SIMULACIONES_MUESTRA\Sim_' fold_name '\' NP '\' 'DATOS_COMUNES'];
            copyfile(source,destination_sintetica);                
            end  
            
            
            %% Copio la simulación base a los directorios
            source=['..\SIMULACIONES\DATOS\SIMULACIONES_BASE\Sim_' fold_name '\' NP];

            %Sim_sintetica
            destination=['..\SIMULACIONES\DATOS\SIMULACIONES_MUESTRA\Sim_' fold_name '\' NP '\' sim_sintetica];
            copyfile(source,destination);
            
          

            file_fcad_sintetico=[destination '\fcad.mdf'];
            file_fguad_sintetico=[destination '\fguad.mdf'];
            clear destination l names source

            %% BUSCO INICIO Y FINAL DE LA SIMULACIONES

            %La simulación SINTETICA la inicio 23 h antes de que se produzca el
            %valor del forzamiento +/- 8 h para emepezar en eta igual a 0
            %puesto que la marea pasa por 0 cada 6h. Finalizo 1 días despues de
            %que se produzca el valor del forzamiento.

            %Extaigo el vector de tiempo y elevación
            names = fieldnames(Forzamiento);
            var=fieldnames(Forzamiento.(names{1}));
            t=Forzamiento.(names{1}).(var{end});
            eta=Forzamiento.(names{1}).(var{1});
            %Extaigo el instante el que se produce el forzamiento
            t_valor=t(pos(k));
            t_valor_vector=datevec(t_valor);        

            %Extaigo el rango de etas +/- 8 h antes y después de 23 h de inicio
            eta_ini=eta(pos(k)-23-8:pos(k)-23+8);

            %Busco el mínimo para ver el instante en el que empiezo
            [~,val]=min(abs(eta_ini)); 

            %Extarigo el instante de inicio y de final
            t_ini=t(pos(k)-23-8+val-1);
            t_ini_vec=datevec(t_ini);
            t_fin=t_valor+0.5;
            t_fin_vector=datevec(t_fin);

            %Valor inicial de elevación
            eta0=eta(pos(k)-23-8+val-1);

            %Tiempo de simulación
            t_sim_vec=datevec(t_ini:1/24:t_fin);

            %% MODIFICO EL ARCHIVO FCAD SINTETICO
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
            Flhis=strcat(tstart ,{' '},'1',{'  '},tstop);
            Flpp=strcat(tstart ,{' '},'60',{'  '},tstop);

            value={Flmap,Flhis,Flpp};
            bak='1';
            del='1';
            PROG_2_DELFT_PARSER_CASO_1_OPC_1(file, key, value, bak, del);

            %% MODIFICO EL ARCHIVO FGUAD SINTETICO
            file=file_fguad_sintetico;
            key={'Itdate','Tstart','Tstop','Zeta0'};

            value={itdate,tstart,tstop,eta0};
            bak='1';
            del='1';
            PROG_1_DELFT_PARSER_CASO_1_OPC_1(file, key, value, bak, del);

            clear key value
            key={'Flmap','Flhis','Flpp'};
            Flmap=strcat(tstart ,{' '},'1440',{'  '},tstop);
            Flhis=strcat(tstart ,{' '},'1',{'  '},tstop);
            Flpp=strcat(tstart ,{' '},'60',{'  '},tstop);

            value={Flmap,Flhis,Flpp};
            bak='1';
            del='1';
            PROG_2_DELFT_PARSER_CASO_1_OPC_1(file, key, value, bak, del);            

        end
   
end

end