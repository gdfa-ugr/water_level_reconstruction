function GENERACION_SIMULACIONES_CASO_2_OPC_1_ODSV(Forzamiento,pos,NP,M,D)
    
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
                break
            else
                mkdir(['..\SIMULACIONES\DATOS\SIMULACIONES_MUESTRA\Sim_' fold_name '\' NP '\' sim_sintetica])
                
            
                % Copio la simulación base a los directorios
                source=['..\SIMULACIONES\DATOS\SIMULACIONES_BASE\Sim_' fold_name '\' NP];                
                
                %Sim_sintetica
                destination_sintetica=['..\SIMULACIONES\DATOS\SIMULACIONES_MUESTRA\Sim_' fold_name '\' NP '\' sim_sintetica];
                copyfile(source,destination_sintetica);               


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
                                
                %Extaigo el instante el que se produce el forzamiento
                t_valor=t(pos(k));
                t_valor_vector=datevec(t_valor);        

                %Extarigo el instante de inicio y de final
                t_ini=t(pos(k))-0.5;
                t_ini_vec=datevec(t_ini);
                t_fin=t_valor+0.1;
                t_fin_vector=datevec(t_fin);

                %Valor inicial de elevación
                eta0=0;

                %Tiempo de simulación
                t_sim_vec=datevec(t_ini:1/24:t_fin);

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
                Flhis=strcat(tstart ,{' '},'1',{'  '},tstop);
                Flpp=strcat(tstart ,{' '},'60',{'  '},tstop);

                value={Flmap,Flhis,Flpp};
                bak='1';
                del='1';
                PROG_2_DELFT_PARSER_CASO_1_OPC_1(file, key, value, bak, del);
                              
                
                % MODIFICO EL ARCHIVO WGUAD SINTETICO
                file=file_wguad_sintetico;
                ReferenceDate=strcat(num2str(t_ini_vec(1,1),'%02i'),'-',num2str(t_ini_vec(1,2),'%02i'),'-',num2str(t_ini_vec(1,3),'%02i'));
                key={'ReferenceDate','WaveHeight','Period','Direction'};
                WaveHeight=num2str(D(k,1));
                Period=num2str(D(k,2));
                Direction=num2str(D(k,3));

                value={ReferenceDate,WaveHeight,Period,Direction};
                bak='1';
                del='1';        
                PROG_1_DELFT_PARSER_CASO_1_OPC_1(file, key, value, bak, del); 

            end
        end
        
%         %SIMULACION REAL
%         if s==2
%             if k<=10 %Solo me genero simulación real para los 10 primeros valores
%                 sim_real=['Sim_' fold_name NP '_real_' num2str(k)];
%                 % Si ya existe el directorio no lo vuelvo a crear        
%                 if exist(['..\SIMULACIONES\DATOS\SIMULACIONES_MUESTRA\Sim_' fold_name '\' NP '\' sim_real],'dir')==7
%                     break
%                 else
%                     mkdir(['..\SIMULACIONES\DATOS\SIMULACIONES_MUESTRA\Sim_' fold_name '\' NP '\' sim_real])
%                     
%                     % Copio la simulación base a los directorios
%                     source=['..\SIMULACIONES\DATOS\SIMULACIONES_BASE\Sim_' fold_name '\' NP];
%                     
%                     %Sim_real
%                     destination_real=['..\SIMULACIONES\DATOS\SIMULACIONES_MUESTRA\Sim_' fold_name '\' NP '\' sim_real];
%                     copyfile(source,destination_real);
%                     file_fcad_real=[destination_real '\fcad.mdf'];
%                     file_fguad_real=[destination_real '\fguad.mdf'];
%                     file_wguad_real=[destination_sintetica '\wguad.mdw'];
%                     
%                     %La simulación real la inicio 47 h antes de que se produzca el
%                     %valor del forzamiento +/- 8 h para emepezar en eta igual a 0
%                     %puesto que la marea pasa por 0 cada 6h. Finalizo 1 días despues de
%                     %que se produzca el valor del forzamiento.
% 
%                     %Extaigo el vector de tiempo y elevación
%                     names = fieldnames(Forzamiento);
%                     var=fieldnames(Forzamiento.(names{1}));
%                     t=Forzamiento.(names{1}).(var{end});
%                     eta=Forzamiento.(names{1}).(var{1});
% 
%                     names = fieldnames(Forzamiento);
%                     var=fieldnames(Forzamiento.(names{2}));
%                     q=Forzamiento.(names{2}).(var{1});
%                     
%                     %Extaigo el instante el que se produce el forzamiento
%                     t_valor=t(pos(k));
%                     t_valor_vector=datevec(t_valor);        
% 
%                     %Extaigo el rango de etas +/- 8 h antes y después de 47 h de inicio
%                     eta_ini=eta(pos(k)-47-8:pos(k)-47+8);
% 
%                     %Busco el mínimo para ver el instante en el que empiezo
%                     [~,val]=min(abs(eta_ini)); 
% 
%                     %Extarigo el instante de inicio y de final
%                     t_ini=t(pos(k)-47-8+val-1);
%                     t_ini_vec=datevec(t_ini);
%                     t_fin=t_valor+1;
%                     t_fin_vector=datevec(t_fin);
% 
%                     %Valor inicial de elevación
%                     eta0=eta(pos(k)-47-8+val-1);
% 
%                     %Tiempo de simulación
%                     t_sim_vec=datevec(t_ini:1/24:t_fin);
% 
%                     % MODIFICO EL ARCHIVO FCAD REAL
%                     file=file_fcad_real;
%                     key={'Itdate','Tstart','Tstop','Zeta0'};
%                     %Dato itdate
%                     itdate=strcat('#',num2str(t_ini_vec(1,1),'%02i'),'-',num2str(t_ini_vec(1,2),'%02i'),'-',num2str(t_ini_vec(1,3),'%02i'),'#');
%                     %dato tstart and tstop
%                     hora_ini=t_sim_vec(1,4)*60;
%                     long=length(t_sim_vec(:,1));
%                     t_delft=hora_ini:60:hora_ini+(long-1)*60;
%                     tstart=num2str(t_delft(1));
%                     tstop=num2str(t_delft(end));
%                     eta0=num2str(eta0);
% 
%                     value={itdate,tstart,tstop,eta0};
%                     bak='1';
%                     del='1';        
%                     PROG_1_DELFT_PARSER_CASO_1_OPC_1(file, key, value, bak, del);
% 
%                     clear key value
%                     key={'Flmap','Flhis','Flpp'};
%                     Flmap=strcat(tstart ,{' '},'1440',{'  '},tstop);
%                     Flhis=strcat(tstart ,{' '},'1',{'  '},tstop);
%                     Flpp=strcat(tstart ,{' '},'60',{'  '},tstop);
% 
%                     value={Flmap,Flhis,Flpp};
%                     bak='1';
%                     del='1';
%                     PROG_2_DELFT_PARSER_CASO_1_OPC_1(file, key, value, bak, del);
% 
%                     % MODIFICO EL ARCHIVO FGUAD REAL
%                     file=file_fguad_real;
%                     key={'Itdate','Tstart','Tstop','Zeta0'};
% 
%                     value={itdate,tstart,tstop,eta0};
%                     bak='1';
%                     del='1';
%                     PROG_1_DELFT_PARSER_CASO_1_OPC_1(file, key, value, bak, del);
% 
%                     clear key value
%                     key={'Flmap','Flhis','Flpp'};
%                     Flmap=strcat(tstart ,{' '},'1440',{'  '},tstop);
%                     Flhis=strcat(tstart ,{' '},'1',{'  '},tstop);
%                     Flpp=strcat(tstart ,{' '},'60',{'  '},tstop);
% 
%                     value={Flmap,Flhis,Flpp};
%                     bak='1';
%                     del='1';
%                     PROG_2_DELFT_PARSER_CASO_1_OPC_1(file, key, value, bak, del); 
%                     
%                     % MODIFICO EL ARCHIVO DISCHARGE REAL
%                     file='descarga1.dis';
%                     nSections=4; % Número de puntos de descarga
%                     referenceTime=[num2str(t_ini_vec(1,1),'%02i') num2str(t_ini_vec(1,2),'%02i') num2str(t_ini_vec(1,3),'%02i')]; %Fecha de referencia
%                     nRecords=length(t_delft);
%                     % Generación  de la matriz con la descarga
%                     pos_ini=find(t==t_ini);
%                     pos_fin=find(t==t_fin);
%                     Q_Delft=q(pos_ini:pos_fin);
% 
%                     records(:,1)=t_delft;
%                     records(:,2)=Q_Delft/nSections; % El caudal que se vierte en cada punto lo divido entre el número de puntos   
% 
% 
%                     DELFT_DISCHARGE_FILE(file, nSections, referenceTime, nRecords, records);
% 
%                     source='descarga1.dis';
%                     pause(1)
%                     copyfile(source,destination_real)
%                     delete('descarga1.dis')
%                     
%                 end
%             end
%         end
    end
end


end