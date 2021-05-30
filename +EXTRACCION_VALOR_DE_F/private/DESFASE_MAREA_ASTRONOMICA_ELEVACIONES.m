function lagDiff=DESFASE_MAREA_ASTRONOMICA_ELEVACIONES(Forzamiento,PC)

%Para calcular dicho desfase es más preciso utilizar la serie completa de 
%elevaciones en un año y comparar el desfase en dicho punto con la serie
%anual de marea astronómica. Este desfase no cambia aunque tenga MA+Q+MM+O
%puesto que MM y O cabalgan sobre el nivel medio de MA y Q. ESTA
%COMPROBADO y como no tengo la serie anual de MA+Q+MM+O aprovecho la de
%MA+Q.

[t_anno_real,WL_anno_real]=EXTRACCION_ELEVACION_MA_Q_ANUAL(PC);

%Valores de elevaciones MA+Q reales anuales frecuencia MINUTARIA
t_anno_real_vect=datevec(t_anno_real);
t_anno_real_vect(:,6)=0;
t_anno_real=datenum(t_anno_real_vect);

%Valores de marea astronómica FREQ HORARIA
% Cargo la serie de marea astronomica de hindcast
data = load(['..\..\HINDCAST\REC_ELEVACIONES\DATOS\MAREA_ASTRONOMICA\MA_SIMAR_1052046.mat']);

t_ma=data.t;
t_ma_vect=datevec(t_ma);
ma=data.WL;

%Lo convierto a FREQ MINUTARIA
t_ma_min=[t_ma(1):1/(24*60):t_ma(end)];
ma=interp1(t_ma,ma,t_ma_min);
t_ma=t_ma_min;
t_ma_vect=datevec(t_ma);
clear t_ma_min

%Recorto los valores de marea astronomica al periodo
%de tiempo de la simulacion anual y los convierto a FREQ MINUTARIA
pos_ini=find(t_ma==t_anno_real(1))
pos_fin=find(t_ma==t_anno_real(end))
t_ma=t_ma(pos_ini:pos_fin);
t_ma_vect=datevec(t_ma);
ma=ma(pos_ini:pos_fin);

% %Represento ambas series temporales para ver el desfase
% figure1 = figure('PaperSize',[20.98 29.68],'Color',[1 1 1],'Position',[1,1,2000,1000],'Visible','on');
% subplot(2,1,1)
% plot(t_anno_real,WL_anno_real,'r','DisplayName','Elevaciones Delft en punto de control')
% hold on
% p=plot(t_anno_real,WL_anno_real,'.r','MarkerSize',5);
% set(get(get(p, 'Annotation'), 'LegendInformation'),'IconDisplayStyle', 'off')
% hold on
% plot(t_ma,ma,'k','DisplayName','Marea astronómica en prof. indefinidas')
% p=plot(t_ma,ma,'ok','Markersize',5);
% set(get(get(p, 'Annotation'), 'LegendInformation'), ...
% 'IconDisplayStyle', 'off')
% datetick('x',6)
% grid on
% title('Series temporales desfasadas')
% legend('Show')

% Calculamos el desfase mediante el coeficiente de 
% correlacion cruzada
s1=ma;
t_s1=t_ma;
s2=WL_anno_real;
t_s2=t_anno_real;

[c,lag] = xcorr(s2,s1,'coeff');
pos=find(lag<0);
c(pos)=0;
[c_pos,I] =  findpeaks(c);
lag_pos = lag(I(1)); %minutos de desfase entre s1 y s2
lagDiff=lag_pos; 

%Esta representación nos da para cada valor de desfase en X la correlación.
%Es por ello que tenemos que buscar el valor e X (desfase) que tenga la
%máxima correlación. Ese valor es el que tengo que desplazar la serie

%c=1 significa que la correlacion es positiva si a sube b sube.
%c=-1 significa que la correlacion es inversa, si a sube b baja.

%  figure
%  plot(lag,c)

% Reconstruyo la serie
s2al = s2(lagDiff:end); %Retraso la serie de elevaciones lagDiff minutos para que esteen fase con la MA
t2al = t_s2(1:length(s2al));

s1al=s1(1:length(s2al));
t1al = t_s1(1:length(t2al));

[R,P]=corrcoef(s1al,s2al);

% % Representamos las dos series temporales reconstruidas
% figure1 = figure('PaperSize',[20.98 29.68],'Color',[1 1 1],'Position',[1,1,2000,1000],'Visible','on');
% subplot(2,1,1)
% plot(t1al,s1al','k','DisplayName','Marea astronómica en prof. indefinidas')
% hold on
% p=plot(t1al,s1al,'.k','MarkerSize',10);
% set(get(get(p, 'Annotation'), 'LegendInformation'),'IconDisplayStyle', 'off')
% hold on
% plot(t2al,s2al,'r','DisplayName','Elevaciones Delft en punto de control')
% hold on
% p=plot(t2al,s2al,'.r','MarkerSize',10);
% set(get(get(p, 'Annotation'), 'LegendInformation'),'IconDisplayStyle', 'off')
% hold on
% grid on
% datetick('x',6)
% title('Series temporales sin desfase')
% legend('Show')






end