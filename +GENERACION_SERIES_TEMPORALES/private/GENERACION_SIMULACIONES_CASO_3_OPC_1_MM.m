function GENERACION_SIMULACIONES_CASO_3_OPC_1_MM(Forzamiento,pos,NP,M)

for k=1:M
    for s=1:2
        
        clear var value tstop tstart t_valor_vector t_valor t_sim_vec t_ini_vec t_ini t_fin_vector t_fin t_delft t sim_sintetica
        clear sim_real referenceTime records pos_valor pos_ini pos_fin nSections nRecords long l key t_delft
        clear itdate hora_ini eta0 Q_Delft Flpp Flmap Flhis
        
        % En primer lugar me creo las carpetas para la simulación
        names = fieldnames(Forzamiento);
        l=length(names);
        fold_name='';
        for j=1:l
           fold_name=[fold_name char(names(j)),'_']; 
        end
        
        % SIMULACION SINTETICA        
        if s==1 
            
            sim_sintetica=['Sim_' fold_name NP '_sintetica_' num2str(k)];
                    
            % Si ya existe el directorio no lo vuelvo a crear        
            if exist(['..\SIMULACIONES\DATOS\SIMULACIONES_MUESTRA\Sim_' fold_name '\' NP '\' sim_sintetica],'dir')==7
                %break
            else
                %Creo el directorio
                mkdir(['..\SIMULACIONES\DATOS\SIMULACIONES_MUESTRA\Sim_' fold_name '\' NP '\' sim_sintetica])
                
                if k==1 %Solo lo copio una vez
                % Copio la carpeta de DATOS COMUNES
                source=['..\SIMULACIONES\DATOS\SIMULACIONES_BASE\Sim_' fold_name '\' 'DATOS_COMUNES'];
                destination_sintetica=['..\SIMULACIONES\DATOS\SIMULACIONES_MUESTRA\Sim_' fold_name '\' NP '\' 'DATOS_COMUNES'];
                copyfile(source,destination_sintetica);                
                end 
                
                
                % Copio la simulación base a los directorios
                source=['..\SIMULACIONES\DATOS\SIMULACIONES_BASE\Sim_' fold_name '\' NP];
                
                %Sim_sintetica
                destination_sintetica=['..\SIMULACIONES\DATOS\SIMULACIONES_MUESTRA\Sim_' fold_name '\' NP '\' sim_sintetica];
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
                vv=Forzamiento.(names{1}).(var{1});
                d_v=Forzamiento.(names{1}).(var{2});
                %eta=Forzamiento.(names{1}).(var{1});
                %Extaigo el instante el que se produce el forzamiento
                t_valor=t(pos(k));
                t_valor_vector=datevec(t_valor);        

                %Extarigo el instante de inicio y de final
                t_ini=t(pos(k)-23);
                t_ini_vec=datevec(t_ini);
                t_fin=t_valor+0.5;
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
                Flhis=strcat(tstart ,{' '},'1',{'  '},tstop);
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
                Flhis=strcat(tstart ,{' '},'1',{'  '},tstop);
                Flpp=strcat(tstart ,{' '},'60',{'  '},tstop);

                value={Flmap,Flhis,Flpp};
                bak='1';
                del='1';
                PROG_2_DELFT_PARSER_CASO_1_OPC_1(file, key, value, bak, del);    
                
                % MODIFICO LOS ARCHIVOS WIND SINTETICOS
                nRecords=length(t_delft);
                % Generación  de la matriz con la descarga
                pos_ini=find(t==t_ini);
                pos_fin=find(t==t_fin);
                pos_valor=find(t==t_valor);
                VV_Delft=zeros(nRecords,1);
                DV_Delft=zeros(nRecords,1);
                VV_Delft=VV_Delft+vv(pos_valor);
                DV_Delft=DV_Delft+d_v(pos_valor);

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

            end
        end
        
        % SIMULACION REAL        
        if s==2
            if k<=20 %Solo me genero simulación real para los 10 primeros valores
                                   
                sim_real=['Sim_' fold_name NP '_real_' num2str(k)]; 
                % Si ya existe el directorio no lo vuelvo a crear        
                if exist(['..\SIMULACIONES\DATOS\SIMULACIONES_MUESTRA\Sim_' fold_name '\' NP '\' sim_real],'dir')==7
                    %break
                else
                    mkdir(['..\SIMULACIONES\DATOS\SIMULACIONES_MUESTRA\Sim_' fold_name '\' NP '\' sim_real])
                    
                    % Copio la simulación base a los directorios
                    source=['..\SIMULACIONES\DATOS\SIMULACIONES_BASE\Sim_' fold_name '\' NP];

                    %Sim_real
                    destination_real=['..\SIMULACIONES\DATOS\SIMULACIONES_MUESTRA\Sim_' fold_name '\' NP '\' sim_real];
                    copyfile(source,destination_real);
                    file_fcad_real=[destination_real '\fcad.mdf'];
                    file_fguad_real=[destination_real '\fguad.mdf'];
                    
                    %La simulación real la inicio 47 h antes de que se produzca el
                    %valor del forzamiento +/- 8 h para emepezar en eta igual a 0
                    %puesto que la marea pasa por 0 cada 6h. Finalizo 1 días despues de
                    %que se produzca el valor del forzamiento.

                    %Extaigo el vector de tiempo y elevación
                    names = fieldnames(Forzamiento);
                    var=fieldnames(Forzamiento.(names{1}));
                    t=Forzamiento.(names{1}).(var{end});
                    %eta=Forzamiento.(names{1}).(var{1});
                    %Extaigo el instante el que se produce el forzamiento
                    t_valor=t(pos(k));
                    t_valor_vector=datevec(t_valor);        

                    %Extarigo el instante de inicio y de final
                    if (pos(k)-47)<0
                        t_ini=t(1);
                    else
                        t_ini=t(pos(k)-47);
                    end                    
                    t_ini_vec=datevec(t_ini);
                    t_fin=t_valor+0.5;
                    t_fin_vector=datevec(t_fin);

                    %Valor inicial de elevación
                    eta0=0;

                    %Tiempo de simulación
                    t_sim_vec=datevec(t_ini:1/24:t_fin);

                    %% MODIFICO EL ARCHIVO FCAD REAL
                    file=file_fcad_real;
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

                    %% MODIFICO EL ARCHIVO FGUAD REAL
                    file=file_fguad_real;
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
                    
                    %% MODIFICO LOS ARCHIVOS WIND REALES
                    nRecords=length(t_delft);
                    % Generación  de la matriz con la descarga
                    pos_ini=find(t==t_ini);
                    pos_fin=find(t==t_fin);
                    VV_Delft=vv(pos_ini:pos_fin);
                    DV_Delft=d_v(pos_ini:pos_fin);

                    records(:,1)=t_delft;
                    records(:,2)=VV_Delft;
                    records(:,3)=DV_Delft;

                    save 'viento_fcad.wnd' records -ASCII
                    save 'viento_fguad.wnd' records -ASCII               

                    source='viento_fcad.wnd';
                    pause(1)
                    copyfile(source,destination_real)
                    delete('viento_fcad.wnd')

                    source='viento_fguad.wnd';
                    pause(1)
                    copyfile(source,destination_real)
                    delete('viento_fguad.wnd')
                end
            end
        end
    end
end
end

