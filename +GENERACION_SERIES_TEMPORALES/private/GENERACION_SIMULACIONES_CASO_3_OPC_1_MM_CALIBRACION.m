function GENERACION_SIMULACIONES_CASO_3_OPC_1_MM_CALIBRACION(Forzamiento,t_ini_sim,t_fin_sim,NP)
t_ini_sim_vect=datevec(t_ini_sim);
t_fin_sim_vect=datevec(t_fin_sim);

        
        % En primer lugar me creo las carpetas para la simulaci?n
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
                
               
                % Copio la simulaci?n base a los directorios
                source=['..\SIMULACIONES\DATOS\SIMULACIONES_BASE\Sim_' fold_name '\' NP];
                
                %Sim_calibracion
                destination_sintetica=['..\SIMULACIONES\DATOS\SIMULACIONES_CALIBRACION\Sim_' fold_name '\' NP '\' sim_calibracion];
                copyfile(source,destination_sintetica);
                
 
                
                file_fcad_sintetico=[destination_sintetica '\fcad.mdf'];
                file_fguad_sintetico=[destination_sintetica '\fguad.mdf'];
                clear l names source
                
                % Busco los inicios y finales de periodo para la simulacion   
                %La simulaci?n real la inicio 23 h antes de que se produzca el
                %valor del forzamiento +/- 8 h para emepezar en eta igual a 0
                %puesto que la marea pasa por 0 cada 6h. Finalizo 1 d?as despues de
                %que se produzca el valor del forzamiento.

                %Extaigo el vector de tiempo y elevaci?n
                names = fieldnames(Forzamiento);
                var=fieldnames(Forzamiento.(names{1}));
                t=Forzamiento.(names{1}).(var{end});
                vv=Forzamiento.(names{1}).(var{1});
                d_v=Forzamiento.(names{1}).(var{2});
                pos_ini=find(t==t_ini_sim);       

                %Extarigo el instante de inicio y de final
                t_ini=t_ini_sim;
                t_ini_vec=datevec(t_ini);
                t_fin=t_fin_sim;
                t_fin_vector=datevec(t_fin);

                %Valor inicial de elevaci?n
                eta0=0;

                %Tiempo de simulaci?n
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
                % Generaci?n  de la matriz con la descarga
                pos_ini=find(t==t_ini);
                pos_fin=find(t==t_fin);
                VV_Delft=vv(pos_ini:pos_fin);
                DV_Delft=d_v(pos_ini:pos_fin)

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

