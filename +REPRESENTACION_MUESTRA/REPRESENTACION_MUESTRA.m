function REPRESENTACION_MUESTRA(Forzamiento,Forzamiento_norm,pos,X,M)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% REPRESENTACION_MUESTRA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%_________________________________________________________________________
% 
% Descripcion: Función que me representa las series temporales de los
% forzamientos elegidos junto con los puntos de la muestra seleccionados
% mediante el MDA
%
% Datos de entrada:
% 1. Forzamiento: Estructura con las series temporales de los forzamientos 
% considerados
% 2. Forzamiento_norm: Estructura con las series temporales de los 
% forzamientos considerados normalizados
% 3. pos: Posiciones de cada uno de los puntos de la muestra en las series 
% temporales completas.
% 4. X: Almacena en cada columna la serie temporal completa de cada uno de
% los forzamientos considerados sin normalizar.
% 5. M: Número de puntos que se quiere que tenga la muestra
%
%
%
%
%                                              Granada, 15 de marzo de 2016
%                                                     Juan del Rosal Salido
%                                   Grupo de Dinámica de Flujos Ambientales 
%                                                    Universidad de Granada
%__________________________________________________________________________

if isfield(Forzamiento, 'MA_95_85') 
    Forzamiento.MA = Forzamiento.MA_95_85;
end

if isfield(Forzamiento, 'MA_05_45') 
    Forzamiento.MA = Forzamiento.MA_05_45;
end

figure1 = figure('PaperSize',[20.98 29.68],'Color',[1 1 1],'Position',[1,1,2000,1000],'Visible','on');
if isfield(Forzamiento,'MA')
    s(1)=subplot(4,2,1);
    plot(Forzamiento.MA.t_ma,Forzamiento.MA.ma,'color',[0.8 0.8 0.8],'Linewidth',1)
    hold on
    plot(Forzamiento.MA.t_ma(pos(1:25)),Forzamiento.MA.ma(pos(1:25)),'.k','Markersize',30)
    plot(Forzamiento.MA.t_ma(pos(26:50)),Forzamiento.MA.ma(pos(26:50)),'.r','Markersize',20)
    plot(Forzamiento.MA.t_ma(pos(51:100)),Forzamiento.MA.ma(pos(51:100)),'.y','Markersize',15)
    plot(Forzamiento.MA.t_ma(pos(101:end)),Forzamiento.MA.ma(pos(101:end)),'.g','Markersize',10)
    grid on
    datetick('x',11)
    set(gca, 'fontsize', 16)
    xlim([Forzamiento.MA.t_ma(1) Forzamiento.MA.t_ma(end)]) 
    ylim([min(Forzamiento.MA.ma(pos)) max(Forzamiento.MA.ma(pos))])
    ylabel('M.Astro (m)','Fontweight','bold','Fontsize',16)
    xlabel ('t','Fontweight','bold','Fontsize',16)
    
%     for j=1:length(pos)
%        text(Forzamiento.MA.t_ma(pos(j)),Forzamiento.MA.ma(pos(j)),num2str(j),'Color','blue')         
%     end
    
end

if isfield(Forzamiento,'MA_DESPLAZ')
    s(1)=subplot(4,1,1);
    plot(Forzamiento.MA_DESPLAZ.t_ma,Forzamiento.MA_DESPLAZ.ma,'k','Linewidth',1)
    hold on
    plot(Forzamiento.MA_DESPLAZ.t_ma(pos),Forzamiento.MA_DESPLAZ.ma(pos),'.y','Markersize',30)
    grid on
    datetick('x',12)
    xlim([Forzamiento.MA_DESPLAZ.t_ma(1) Forzamiento.MA_DESPLAZ.t_ma(end)])
    ylabel('M.Astro','Fontweight','bold','Fontsize',16)
    xlabel ('t','Fontweight','bold','Fontsize',16)
    
    for j=1:length(pos)
       text(Forzamiento.MA_DESPLAZ.t_ma(pos(j)),Forzamiento.MA_DESPLAZ.ma(pos(j)),num2str(j),'Color','blue')         
    end
    
end


if isfield(Forzamiento,'Q')
    s(2)=subplot(4,2,2);
    plot(Forzamiento.Q.t_q,Forzamiento.Q.q,'color',[0.8 0.8 0.8],'Linewidth',1)
    hold on
    plot(Forzamiento.Q.t_q(pos(1:25)),Forzamiento.Q.q(pos(1:25)),'.k','Markersize',30)
    plot(Forzamiento.Q.t_q(pos(26:50)),Forzamiento.Q.q(pos(26:50)),'.r','Markersize',20)
    plot(Forzamiento.Q.t_q(pos(51:100)),Forzamiento.Q.q(pos(51:100)),'.y','Markersize',15)
    plot(Forzamiento.Q.t_q(pos(101:end)),Forzamiento.Q.q(pos(101:end)),'.g','Markersize',10)
    grid on
    datetick('x',11)
    set(gca, 'fontsize', 16)
    xlim([Forzamiento.Q.t_q(1) Forzamiento.Q.t_q(end)])
    ylim([min(Forzamiento.Q.q(pos)) max(Forzamiento.Q.q(pos))])
    ylabel('Q (m3 \ s)','Fontweight','bold','Fontsize',16)
    xlabel ('t','Fontweight','bold','Fontsize',16)
%     
%     for j=1:length(pos)
%        text(Forzamiento.Q.t_q(pos(j)),Forzamiento.Q.q(pos(j)),num2str(j),'Color','blue')         
%     end
end


if isfield(Forzamiento,'O')
    s(3)=subplot(4,2,3);
    plot(Forzamiento.O.t_horario,Forzamiento.O.h,'color',[0.8 0.8 0.8],'Linewidth',1)
    hold on
    plot(Forzamiento.O.t_horario(pos(1:25)),Forzamiento.O.h(pos(1:25)),'.k','Markersize',30)
    plot(Forzamiento.O.t_horario(pos(26:50)),Forzamiento.O.h(pos(26:50)),'.r','Markersize',20)
    plot(Forzamiento.O.t_horario(pos(51:100)),Forzamiento.O.h(pos(51:100)),'.y','Markersize',15)
    plot(Forzamiento.O.t_horario(pos(101:end)),Forzamiento.O.h(pos(101:end)),'.g','Markersize',10)
    grid on
    datetick('x',11)
    set(gca, 'fontsize', 16)
    xlim([Forzamiento.O.t_horario(1) Forzamiento.O.t_horario(end)])
    ylabel('hs (m)','Fontweight','bold','Fontsize',16)
    xlabel ('t','Fontweight','bold','Fontsize',16)

    s(4)=subplot(4,2,4);
    plot(Forzamiento.O.t_horario,Forzamiento.O.tp,'color',[0.8 0.8 0.8],'Linewidth',1)
    hold on
    plot(Forzamiento.O.t_horario(pos(1:25)),Forzamiento.O.tp(pos(1:25)),'.k','Markersize',30)
    plot(Forzamiento.O.t_horario(pos(26:50)),Forzamiento.O.tp(pos(26:50)),'.r','Markersize',20)
    plot(Forzamiento.O.t_horario(pos(51:100)),Forzamiento.O.tp(pos(51:100)),'.y','Markersize',15)
    plot(Forzamiento.O.t_horario(pos(101:end)),Forzamiento.O.tp(pos(101:end)),'.g','Markersize',10)
    grid on
    datetick('x',11)
    set(gca, 'fontsize', 16)
    xlim([Forzamiento.O.t_horario(1) Forzamiento.O.t_horario(end)])
    ylabel('T (s)','Fontweight','bold','Fontsize',16)
    xlabel ('t','Fontweight','bold','Fontsize',16)
    
    s(5)=subplot(4,2,5);
    plot(Forzamiento.O.t_horario,Forzamiento.O.d_o,'color',[0.8 0.8 0.8],'Linewidth',1)
    hold on
    plot(Forzamiento.O.t_horario(pos(1:25)),Forzamiento.O.d_o(pos(1:25)),'.k','Markersize',30)
    plot(Forzamiento.O.t_horario(pos(26:50)),Forzamiento.O.d_o(pos(26:50)),'.r','Markersize',20)
    plot(Forzamiento.O.t_horario(pos(51:100)),Forzamiento.O.d_o(pos(51:100)),'.y','Markersize',15)
    plot(Forzamiento.O.t_horario(pos(101:end)),Forzamiento.O.d_o(pos(101:end)),'.g','Markersize',10)
    grid on
    datetick('x',11)
    set(gca, 'fontsize', 16)
    xlim([Forzamiento.O.t_horario(1) Forzamiento.O.t_horario(end)])
    ylabel('DMD (º)','Fontweight','bold','Fontsize',16)
    xlabel ('t','Fontweight','bold','Fontsize',16)


end

if isfield(Forzamiento,'OD')
    s(3)=subplot(4,2,3);
    plot(Forzamiento.OD.t_horario,Forzamiento.OD.Hs,'color',[0.8 0.8 0.8],'Linewidth',1)
    hold on
    plot(Forzamiento.OD.t_horario(pos(1:25)),Forzamiento.OD.Hs(pos(1:25)),'.k','Markersize',30)
    plot(Forzamiento.OD.t_horario(pos(26:50)),Forzamiento.OD.Hs(pos(26:50)),'.r','Markersize',20)
    plot(Forzamiento.OD.t_horario(pos(51:100)),Forzamiento.OD.Hs(pos(51:100)),'.y','Markersize',15)
    plot(Forzamiento.OD.t_horario(pos(101:end)),Forzamiento.OD.Hs(pos(101:end)),'.g','Markersize',10)
    grid on
    datetick('x',11)
    set(gca, 'fontsize', 16)
    xlim([Forzamiento.OD.t_horario(1) Forzamiento.OD.t_horario(end)])
    ylim([min(Forzamiento.OD.Hs(pos)) max(Forzamiento.OD.Hs(pos))])
    ylabel('H','Fontweight','bold','Fontsize',16)
    xlabel ('t','Fontweight','bold','Fontsize',16)
%     for j=1:length(pos)
%        text(Forzamiento.OD.t_horario(pos(j)),Forzamiento.OD.Hs(pos(j)),num2str(j),'Color','blue')         
%     end

    s(4)=subplot(4,2,4);
    plot(Forzamiento.OD.t_horario,Forzamiento.OD.Tp,'color',[0.8 0.8 0.8],'Linewidth',1)
    hold on
    plot(Forzamiento.OD.t_horario(pos(1:25)),Forzamiento.OD.Tp(pos(1:25)),'.k','Markersize',30)
    plot(Forzamiento.OD.t_horario(pos(26:50)),Forzamiento.OD.Tp(pos(26:50)),'.r','Markersize',20)
    plot(Forzamiento.OD.t_horario(pos(51:100)),Forzamiento.OD.Tp(pos(51:100)),'.y','Markersize',15)
    plot(Forzamiento.OD.t_horario(pos(101:end)),Forzamiento.OD.Tp(pos(101:end)),'.g','Markersize',10)
    grid on
    datetick('x',11)
    set(gca, 'fontsize', 16)
    xlim([Forzamiento.OD.t_horario(1) Forzamiento.OD.t_horario(end)])
    ylim([min(Forzamiento.OD.Tp(pos)) max(Forzamiento.OD.Tp(pos))])
    ylabel('Tp (s)','Fontweight','bold','Fontsize',16)
    xlabel ('t','Fontweight','bold','Fontsize',16)
%     for j=1:length(pos)
%        text(Forzamiento.OD.t_horario(pos(j)),Forzamiento.OD.Hs(pos(j)),num2str(j),'Color','blue')         
%     end

    s(5)=subplot(4,2,5);
    plot(Forzamiento.OD.t_horario,Forzamiento.OD.Do,'color',[0.8 0.8 0.8],'Linewidth',1)
    hold on
    plot(Forzamiento.OD.t_horario(pos(1:25)),Forzamiento.OD.Do(pos(1:25)),'.k','Markersize',30)
    plot(Forzamiento.OD.t_horario(pos(26:50)),Forzamiento.OD.Do(pos(26:50)),'.r','Markersize',20)
    plot(Forzamiento.OD.t_horario(pos(51:100)),Forzamiento.OD.Do(pos(51:100)),'.y','Markersize',15)
    plot(Forzamiento.OD.t_horario(pos(101:end)),Forzamiento.OD.Do(pos(101:end)),'.g','Markersize',10)
    grid on
    datetick('x',11)
    set(gca, 'fontsize', 16)
    xlim([Forzamiento.OD.t_horario(1) Forzamiento.OD.t_horario(end)])
    ylim([min(Forzamiento.OD.Do(pos)) max(Forzamiento.OD.Do(pos))])
    ylabel('DMD (º)','Fontweight','bold','Fontsize',16)
    xlabel ('t','Fontweight','bold','Fontsize',16)
%     for j=1:length(pos)
%        text(Forzamiento.OD.t_horario(pos(j)),Forzamiento.OD.Hs(pos(j)),num2str(j),'Color','blue')         
%     end

    
end


if isfield(Forzamiento,'ODSV')
      s(3)=subplot(4,2,3);
    plot(Forzamiento.ODSV.t_horario,Forzamiento.ODSV.Hs,'color',[0.8 0.8 0.8],'Linewidth',1)
    hold on
    plot(Forzamiento.ODSV.t_horario(pos(1:25)),Forzamiento.ODSV.Hs(pos(1:25)),'.k','Markersize',30)
    plot(Forzamiento.ODSV.t_horario(pos(26:50)),Forzamiento.ODSV.Hs(pos(26:50)),'.r','Markersize',20)
    plot(Forzamiento.ODSV.t_horario(pos(51:100)),Forzamiento.ODSV.Hs(pos(51:100)),'.y','Markersize',15)
    plot(Forzamiento.ODSV.t_horario(pos(101:end)),Forzamiento.ODSV.Hs(pos(101:end)),'.g','Markersize',10)
    grid on
    datetick('x',11)
    set(gca, 'fontsize', 16)
    xlim([Forzamiento.ODSV.t_horario(1) Forzamiento.ODSV.t_horario(end)])
    ylim([min(Forzamiento.ODSV.Hs(pos)) max(Forzamiento.ODSV.Hs(pos))])
    ylabel('H','Fontweight','bold','Fontsize',16)
    xlabel ('t','Fontweight','bold','Fontsize',16)
%     for j=1:length(pos)
%        text(Forzamiento.OD.t_horario(pos(j)),Forzamiento.OD.Hs(pos(j)),num2str(j),'Color','blue')         
%     end

    s(4)=subplot(4,2,4);
    plot(Forzamiento.ODSV.t_horario,Forzamiento.ODSV.Tp,'color',[0.8 0.8 0.8],'Linewidth',1)
    hold on
    plot(Forzamiento.ODSV.t_horario(pos(1:25)),Forzamiento.ODSV.Tp(pos(1:25)),'.k','Markersize',30)
    plot(Forzamiento.ODSV.t_horario(pos(26:50)),Forzamiento.ODSV.Tp(pos(26:50)),'.r','Markersize',20)
    plot(Forzamiento.ODSV.t_horario(pos(51:100)),Forzamiento.ODSV.Tp(pos(51:100)),'.y','Markersize',15)
    plot(Forzamiento.ODSV.t_horario(pos(101:end)),Forzamiento.ODSV.Tp(pos(101:end)),'.g','Markersize',10)
    grid on
    datetick('x',11)
    set(gca, 'fontsize', 16)
    xlim([Forzamiento.ODSV.t_horario(1) Forzamiento.ODSV.t_horario(end)])
    ylim([min(Forzamiento.ODSV.Tp(pos)) max(Forzamiento.ODSV.Tp(pos))])
    ylabel('Tp (s)','Fontweight','bold','Fontsize',16)
    xlabel ('t','Fontweight','bold','Fontsize',16)
%     for j=1:length(pos)
%        text(Forzamiento.OD.t_horario(pos(j)),Forzamiento.OD.Hs(pos(j)),num2str(j),'Color','blue')         
%     end

    s(5)=subplot(4,2,5);
    plot(Forzamiento.ODSV.t_horario,Forzamiento.ODSV.Do,'color',[0.8 0.8 0.8],'Linewidth',1)
    hold on
    plot(Forzamiento.ODSV.t_horario(pos(1:25)),Forzamiento.ODSV.Do(pos(1:25)),'.k','Markersize',30)
    plot(Forzamiento.ODSV.t_horario(pos(26:50)),Forzamiento.ODSV.Do(pos(26:50)),'.r','Markersize',20)
    plot(Forzamiento.ODSV.t_horario(pos(51:100)),Forzamiento.ODSV.Do(pos(51:100)),'.y','Markersize',15)
    plot(Forzamiento.ODSV.t_horario(pos(101:end)),Forzamiento.ODSV.Do(pos(101:end)),'.g','Markersize',10)
    grid on
    datetick('x',11)
    set(gca, 'fontsize', 16)
    xlim([Forzamiento.ODSV.t_horario(1) Forzamiento.ODSV.t_horario(end)])
    ylim([min(Forzamiento.ODSV.Do(pos)) max(Forzamiento.ODSV.Do(pos))])
    ylabel('DMD (º)','Fontweight','bold','Fontsize',16)
    xlabel ('t','Fontweight','bold','Fontsize',16)
%     for j=1:length(pos)
%        text(Forzamiento.OD.t_horario(pos(j)),Forzamiento.OD.Hs(pos(j)),num2str(j),'Color','blue')         
%     end

    
end


if isfield(Forzamiento,'MM')
    s(6)=subplot(4,2,6);
    plot(Forzamiento.MM.t_horario,Forzamiento.MM.vv,'color',[0.8 0.8 0.8],'Linewidth',1)
    hold on
    plot(Forzamiento.MM.t_horario(pos(1:25)),Forzamiento.MM.vv(pos(1:25)),'.k','Markersize',30)
    plot(Forzamiento.MM.t_horario(pos(26:50)),Forzamiento.MM.vv(pos(26:50)),'.r','Markersize',20)
    plot(Forzamiento.MM.t_horario(pos(51:100)),Forzamiento.MM.vv(pos(51:100)),'.y','Markersize',15)
    plot(Forzamiento.MM.t_horario(pos(101:end)),Forzamiento.MM.vv(pos(101:end)),'.g','Markersize',10)
    grid on
    datetick('x',11)
    set(gca, 'fontsize', 16)
    xlim([Forzamiento.MM.t_horario(1) Forzamiento.MM.t_horario(end)])    
    ylabel('Vv (m/s)','Fontweight','bold','Fontsize',16)
    xlabel ('t','Fontweight','bold','Fontsize',16) 
    ylim([min(Forzamiento.MM.vv(pos)) max(Forzamiento.MM.vv(pos))])
%     for j=1:length(pos)
%        text(Forzamiento.MM.t_horario(pos(j)),Forzamiento.MM.vv(pos(j)),num2str(j),'Color','blue')         
%     end

    s(7)=subplot(4,2,7);
    plot(Forzamiento.MM.t_horario,Forzamiento.MM.d_v,'color',[0.8 0.8 0.8],'Linewidth',1)
    hold on
    plot(Forzamiento.MM.t_horario(pos(1:25)),Forzamiento.MM.d_v(pos(1:25)),'.k','Markersize',30)
    plot(Forzamiento.MM.t_horario(pos(26:50)),Forzamiento.MM.d_v(pos(26:50)),'.r','Markersize',20)
    plot(Forzamiento.MM.t_horario(pos(51:100)),Forzamiento.MM.d_v(pos(51:100)),'.y','Markersize',15)
    plot(Forzamiento.MM.t_horario(pos(101:end)),Forzamiento.MM.d_v(pos(101:end)),'.g','Markersize',10)
    grid on
    datetick('x',11)
    set(gca, 'fontsize', 16)
    xlim([Forzamiento.MM.t_horario(1) Forzamiento.MM.t_horario(end)])    
    ylabel('DMD (º)','Fontweight','bold','Fontsize',16)
    xlabel ('t','Fontweight','bold','Fontsize',16)  
    ylim([min(Forzamiento.MM.d_v(pos)) max(Forzamiento.MM.d_v(pos))])
    
    
    s(8)=subplot(4,2,8);
    plot(Forzamiento.MM.t_horario,Forzamiento.MM.pnm,'color',[0.8 0.8 0.8],'Linewidth',1)
    hold on
    plot(Forzamiento.MM.t_horario(pos(1:25)),Forzamiento.MM.pnm(pos(1:25)),'.k','Markersize',30)
    plot(Forzamiento.MM.t_horario(pos(26:50)),Forzamiento.MM.pnm(pos(26:50)),'.r','Markersize',20)
    plot(Forzamiento.MM.t_horario(pos(51:100)),Forzamiento.MM.pnm(pos(51:100)),'.y','Markersize',15)
    plot(Forzamiento.MM.t_horario(pos(101:end)),Forzamiento.MM.pnm(pos(101:end)),'.g','Markersize',10)
    grid on
    datetick('x',10)
    set(gca, 'fontsize', 16)
    xlim([Forzamiento.MM.t_horario(1) Forzamiento.MM.t_horario(end)])    
    ylabel('PNM (mbar)','Fontweight','bold','Fontsize',16)
    xlabel ('t','Fontweight','bold','Fontsize',16)  
    ylim([min(Forzamiento.MM.pnm(pos)) max(Forzamiento.MM.pnm(pos))])
    
%     for j=1:length(pos)
%        text(Forzamiento.MM.t_horario(pos(j)),Forzamiento.MM.vv(pos(j)),num2str(j),'Color','blue')         
%     end

end

linkaxes([s],'x')

%%%
%% Representacion en 2D ingles

x0=0;
y0=0;
width=550*1;
height=400*1;

figure1 = figure('PaperSize',[20.98 29.68],'Color',[1 1 1],'Position',[x0,y0,width,height],'Visible','on');

if isfield(Forzamiento,'MA') && isfield(Forzamiento,'Q')
    s(1) = subplot(7, 7 ,1);
    plot(Forzamiento.MA.ma,Forzamiento.Q.q,'.','color',[0.8 0.8 0.8],'markersize',2)
    hold on
    plot(Forzamiento.MA.ma(pos(101:end)),Forzamiento.Q.q(pos(101:end)),'.g','Markersize',10)
    plot(Forzamiento.MA.ma(pos(51:100)),Forzamiento.Q.q(pos(51:100)),'.y','Markersize',15)
    plot(Forzamiento.MA.ma(pos(26:50)),Forzamiento.Q.q(pos(26:50)),'.r','Markersize',20)
    plot(Forzamiento.MA.ma(pos(1:25)),Forzamiento.Q.q(pos(1:25)),'.k','Markersize',25)
    xlim([min(Forzamiento.MA.ma(pos)) max(Forzamiento.MA.ma(pos))])
    ylim([min(Forzamiento.Q.q(pos)) max(Forzamiento.Q.q(pos))])
    set(gca, 'fontsize', 16, 'YTick',[10 200 400])
    xlabel('AT (m)','Fontweight','bold','Fontsize',16)
    ylabel ('Q (m^3/s)','Fontweight','bold','Fontsize',16)     
    
end


if isfield(Forzamiento,'MA') && isfield(Forzamiento,'OD')
    s(2) = subplot(7, 7 ,2);
    plot(Forzamiento.MA.ma,Forzamiento.OD.Hs,'.','color',[0.8 0.8 0.8],'markersize',2)
    hold on
    plot(Forzamiento.MA.ma(pos(101:end)),Forzamiento.OD.Hs(pos(101:end)),'.g','Markersize',10)
    plot(Forzamiento.MA.ma(pos(51:100)),Forzamiento.OD.Hs(pos(51:100)),'.y','Markersize',15)
    plot(Forzamiento.MA.ma(pos(26:50)),Forzamiento.OD.Hs(pos(26:50)),'.r','Markersize',20)
    plot(Forzamiento.MA.ma(pos(1:25)),Forzamiento.OD.Hs(pos(1:25)),'.k','Markersize',25)
    xlim([min(Forzamiento.MA.ma(pos)) max(Forzamiento.MA.ma(pos))])
    ylim([min(Forzamiento.OD.Hs(pos)) 4])
    set(gca, 'fontsize', 16, 'YTick', [0, 2, 4])
    xlabel('AT (m)','Fontweight','bold','Fontsize',16)
    ylabel ('H_{m0} (m)','Fontweight','bold','Fontsize',16)     
    
end

if isfield(Forzamiento,'MA') && isfield(Forzamiento,'OD')
    s(3) = subplot(7, 7 ,3);
    plot(Forzamiento.MA.ma,Forzamiento.OD.Tp,'.','color',[0.8 0.8 0.8],'markersize',2)
    hold on
    plot(Forzamiento.MA.ma(pos(101:end)),Forzamiento.OD.Tp(pos(101:end)),'.g','Markersize',10)
    plot(Forzamiento.MA.ma(pos(51:100)),Forzamiento.OD.Tp(pos(51:100)),'.y','Markersize',15)
    plot(Forzamiento.MA.ma(pos(26:50)),Forzamiento.OD.Tp(pos(26:50)),'.r','Markersize',20)
    plot(Forzamiento.MA.ma(pos(1:25)),Forzamiento.OD.Tp(pos(1:25)),'.k','Markersize',25)
    xlim([min(Forzamiento.MA.ma(pos)) max(Forzamiento.MA.ma(pos))])
    ylim([0 max(Forzamiento.OD.Tp(pos))])
    set(gca, 'fontsize', 16, 'YTick', [0, 10, 20])
    xlabel('AT (m)','Fontweight','bold','Fontsize',16)
    ylabel ('Tp (s)','Fontweight','bold','Fontsize',16)     
    
end

if isfield(Forzamiento,'MA') && isfield(Forzamiento,'OD')
    s(4) = subplot(7, 7 ,4);
    plot(Forzamiento.MA.ma,Forzamiento.OD.Do,'.','color',[0.8 0.8 0.8],'markersize',2)
    hold on
    plot(Forzamiento.MA.ma(pos(101:end)),Forzamiento.OD.Do(pos(101:end)),'.g','Markersize',10)
    plot(Forzamiento.MA.ma(pos(51:100)),Forzamiento.OD.Do(pos(51:100)),'.y','Markersize',15)
    plot(Forzamiento.MA.ma(pos(26:50)),Forzamiento.OD.Do(pos(26:50)),'.r','Markersize',20)
    plot(Forzamiento.MA.ma(pos(1:25)),Forzamiento.OD.Do(pos(1:25)),'.k','Markersize',25)
    xlim([min(Forzamiento.MA.ma(pos)) max(Forzamiento.MA.ma(pos))])
    ylim([240 345])
    set(gca, 'fontsize', 16, 'YTick',[240, 290, 340])    
    xlabel('AT (m)','Fontweight','bold','Fontsize',16)
    ylabel ('w_{\theta} (º)','Fontweight','bold','Fontsize',16)  
end

if isfield(Forzamiento,'MA') && isfield(Forzamiento,'MM')
    s(5) = subplot(7, 7 ,5);
    plot(Forzamiento.MA.ma,Forzamiento.MM.vv,'.','color',[0.8 0.8 0.8],'markersize',2)
    hold on
    plot(Forzamiento.MA.ma(pos(101:end)),Forzamiento.MM.vv(pos(101:end)),'.g','Markersize',10)
    plot(Forzamiento.MA.ma(pos(51:100)),Forzamiento.MM.vv(pos(51:100)),'.y','Markersize',15)
    plot(Forzamiento.MA.ma(pos(26:50)),Forzamiento.MM.vv(pos(26:50)),'.r','Markersize',20)
    plot(Forzamiento.MA.ma(pos(1:25)),Forzamiento.MM.vv(pos(1:25)),'.k','Markersize',25)
    xlim([min(Forzamiento.MA.ma(pos)) max(Forzamiento.MA.ma(pos))])
    ylim([0 max(Forzamiento.MM.vv(pos))])
    set(gca, 'fontsize', 16, 'YTick', [0,10, 20])
    xlabel('AT (m)','Fontweight','bold','Fontsize',16)
    ylabel ('u_{10} (m/s)','Fontweight','bold','Fontsize',16)  
end

if isfield(Forzamiento,'MA') && isfield(Forzamiento,'MM')
    s(6) = subplot(7, 7 ,6);
    plot(Forzamiento.MA.ma,Forzamiento.MM.d_v,'.','color',[0.8 0.8 0.8],'markersize',2)
    hold on
    plot(Forzamiento.MA.ma(pos(101:end)),Forzamiento.MM.d_v(pos(101:end)),'.g','Markersize',10)
    plot(Forzamiento.MA.ma(pos(51:100)),Forzamiento.MM.d_v(pos(51:100)),'.y','Markersize',15)
    plot(Forzamiento.MA.ma(pos(26:50)),Forzamiento.MM.d_v(pos(26:50)),'.r','Markersize',20)
    plot(Forzamiento.MA.ma(pos(1:25)),Forzamiento.MM.d_v(pos(1:25)),'.k','Markersize',25)
    xlim([min(Forzamiento.MA.ma(pos)) max(Forzamiento.MA.ma(pos))])
    ylim([min(Forzamiento.MM.d_v(pos)) max(Forzamiento.MM.d_v(pos))])
    set(gca, 'fontsize', 16, 'YTick',[0 180 360])
    xlabel('AT (m)','Fontweight','bold','Fontsize',16)
    ylabel ('u_{\theta} (º)','Fontweight','bold','Fontsize',16)  
end

if isfield(Forzamiento,'MA') && isfield(Forzamiento,'MM')
    s(7) = subplot(7, 7 ,7);
    plot(Forzamiento.MA.ma,Forzamiento.MM.pnm,'.','color',[0.8 0.8 0.8],'markersize',2)
    hold on
    plot(Forzamiento.MA.ma(pos(101:end)),Forzamiento.MM.pnm(pos(101:end)),'.g','Markersize',10)
    plot(Forzamiento.MA.ma(pos(51:100)),Forzamiento.MM.pnm(pos(51:100)),'.y','Markersize',15)
    plot(Forzamiento.MA.ma(pos(26:50)),Forzamiento.MM.pnm(pos(26:50)),'.r','Markersize',20)
    plot(Forzamiento.MA.ma(pos(1:25)),Forzamiento.MM.pnm(pos(1:25)),'.k','Markersize',25)
    xlim([min(Forzamiento.MA.ma(pos)) max(Forzamiento.MA.ma(pos))])
    ylim([min(Forzamiento.MM.pnm(pos)) max(Forzamiento.MM.pnm(pos))])
    set(gca, 'fontsize', 16, 'YTick',[985 1010 1035])
    xlabel('AT (m)','Fontweight','bold','Fontsize',16)
    ylabel ('slp (mbar)','Fontweight','bold','Fontsize',16)  
end

%


if isfield(Forzamiento,'Q') && isfield(Forzamiento,'OD')
    s(9) = subplot(7, 7 ,9);
    plot(Forzamiento.Q.q,Forzamiento.OD.Hs,'.','color',[0.8 0.8 0.8],'markersize',2)
    hold on
    plot(Forzamiento.Q.q(pos(101:end)),Forzamiento.OD.Hs(pos(101:end)),'.g','Markersize',10)
    plot(Forzamiento.Q.q(pos(51:100)),Forzamiento.OD.Hs(pos(51:100)),'.y','Markersize',15)
    plot(Forzamiento.Q.q(pos(26:50)),Forzamiento.OD.Hs(pos(26:50)),'.r','Markersize',20)
    plot(Forzamiento.Q.q(pos(1:25)),Forzamiento.OD.Hs(pos(1:25)),'.k','Markersize',25)
    xlim([0 max(Forzamiento.Q.q(pos))])
    ylim([min(Forzamiento.OD.Hs(pos)) 4])
    set(gca, 'fontsize', 16, 'YTick', [0, 2, 4])
    xlabel('Q (m^3/s)','Fontweight','bold','Fontsize',16)
    ylabel ('H_{m0} (m)','Fontweight','bold','Fontsize',16)     
    
end

if isfield(Forzamiento,'Q') && isfield(Forzamiento,'OD')
    s(10) = subplot(7, 7 ,10);
    plot(Forzamiento.Q.q,Forzamiento.OD.Tp,'.','color',[0.8 0.8 0.8],'markersize',2)
    hold on
    plot(Forzamiento.Q.q(pos(101:end)),Forzamiento.OD.Tp(pos(101:end)),'.g','Markersize',10)
    plot(Forzamiento.Q.q(pos(51:100)),Forzamiento.OD.Tp(pos(51:100)),'.y','Markersize',15)
    plot(Forzamiento.Q.q(pos(26:50)),Forzamiento.OD.Tp(pos(26:50)),'.r','Markersize',20)
    plot(Forzamiento.Q.q(pos(1:25)),Forzamiento.OD.Tp(pos(1:25)),'.k','Markersize',25)
    xlim([0 max(Forzamiento.Q.q(pos))])
    ylim([0 max(Forzamiento.OD.Tp(pos))])
    set(gca, 'fontsize', 16, 'YTick', [0, 10, 20])
    xlabel('Q (m^3/s)','Fontweight','bold','Fontsize',16)
    ylabel ('Tp (s)','Fontweight','bold','Fontsize',16)     
    
end

if isfield(Forzamiento,'Q') && isfield(Forzamiento,'OD')
    s(11) = subplot(7, 7 ,11);
    plot(Forzamiento.Q.q,Forzamiento.OD.Do,'.','color',[0.8 0.8 0.8],'markersize',2)
    hold on
    plot(Forzamiento.Q.q(pos(101:end)),Forzamiento.OD.Do(pos(101:end)),'.g','Markersize',10)
    plot(Forzamiento.Q.q(pos(51:100)),Forzamiento.OD.Do(pos(51:100)),'.y','Markersize',15)
    plot(Forzamiento.Q.q(pos(26:50)),Forzamiento.OD.Do(pos(26:50)),'.r','Markersize',20)
    plot(Forzamiento.Q.q(pos(1:25)),Forzamiento.OD.Do(pos(1:25)),'.k','Markersize',25)
    xlim([0 max(Forzamiento.Q.q(pos))])
    ylim([240 345])
    set(gca, 'fontsize', 16, 'YTick',[240, 290, 340])    
    xlabel('Q (m^3/s)','Fontweight','bold','Fontsize',16)
    ylabel ('w_{\theta} (º)','Fontweight','bold','Fontsize',16)  
end

if isfield(Forzamiento,'Q') && isfield(Forzamiento,'MM')
    s(12) = subplot(7, 7 ,12);
    plot(Forzamiento.Q.q,Forzamiento.MM.vv,'.','color',[0.8 0.8 0.8],'markersize',2)
    hold on
    plot(Forzamiento.Q.q(pos(101:end)),Forzamiento.MM.vv(pos(101:end)),'.g','Markersize',10)
    plot(Forzamiento.Q.q(pos(51:100)),Forzamiento.MM.vv(pos(51:100)),'.y','Markersize',15)
    plot(Forzamiento.Q.q(pos(26:50)),Forzamiento.MM.vv(pos(26:50)),'.r','Markersize',20)
    plot(Forzamiento.Q.q(pos(1:25)),Forzamiento.MM.vv(pos(1:25)),'.k','Markersize',25)
    xlim([0 max(Forzamiento.Q.q(pos))])
    ylim([0 max(Forzamiento.MM.vv(pos))])
    set(gca, 'fontsize', 16, 'YTick', [0,10, 20])
    xlabel('Q (m^3/s)','Fontweight','bold','Fontsize',16)
    ylabel ('u_{10} (m/s)','Fontweight','bold','Fontsize',16)  
end

if isfield(Forzamiento,'Q') && isfield(Forzamiento,'MM')
    s(13) = subplot(7, 7 ,13);
    plot(Forzamiento.Q.q,Forzamiento.MM.d_v,'.','color',[0.8 0.8 0.8],'markersize',2)
    hold on
    plot(Forzamiento.Q.q(pos(101:end)),Forzamiento.MM.d_v(pos(101:end)),'.g','Markersize',10)
    plot(Forzamiento.Q.q(pos(51:100)),Forzamiento.MM.d_v(pos(51:100)),'.y','Markersize',15)
    plot(Forzamiento.Q.q(pos(26:50)),Forzamiento.MM.d_v(pos(26:50)),'.r','Markersize',20)
    plot(Forzamiento.Q.q(pos(1:25)),Forzamiento.MM.d_v(pos(1:25)),'.k','Markersize',25)
    xlim([0 max(Forzamiento.Q.q(pos))])
    ylim([min(Forzamiento.MM.d_v(pos)) max(Forzamiento.MM.d_v(pos))])
    set(gca, 'fontsize', 16, 'YTick',[0 180 360])
    xlabel('Q (m^3/s)','Fontweight','bold','Fontsize',16)
    ylabel ('u_{\theta} (º)','Fontweight','bold','Fontsize',16)  
end

if isfield(Forzamiento,'Q') && isfield(Forzamiento,'MM')
    s(14) = subplot(7, 7 ,14);
    plot(Forzamiento.Q.q,Forzamiento.MM.pnm,'.','color',[0.8 0.8 0.8],'markersize',2)
    hold on
    plot(Forzamiento.Q.q(pos(101:end)),Forzamiento.MM.pnm(pos(101:end)),'.g','Markersize',10)
    plot(Forzamiento.Q.q(pos(51:100)),Forzamiento.MM.pnm(pos(51:100)),'.y','Markersize',15)
    plot(Forzamiento.Q.q(pos(26:50)),Forzamiento.MM.pnm(pos(26:50)),'.r','Markersize',20)
    plot(Forzamiento.Q.q(pos(1:25)),Forzamiento.MM.pnm(pos(1:25)),'.k','Markersize',25)
    xlim([0 max(Forzamiento.Q.q(pos))])
    ylim([min(Forzamiento.MM.pnm(pos)) max(Forzamiento.MM.pnm(pos))])
    set(gca, 'fontsize', 16, 'YTick',[985 1010 1035])
    xlabel('Q (m^3/s)','Fontweight','bold','Fontsize',16)
    ylabel ('slp (mbar)','Fontweight','bold','Fontsize',16)  
end

%

if isfield(Forzamiento,'OD') && isfield(Forzamiento,'OD')
    s(17) = subplot(7, 7 ,17);
    plot(Forzamiento.OD.Hs,Forzamiento.OD.Tp,'.','color',[0.8 0.8 0.8],'markersize',2)
    hold on
    plot(Forzamiento.OD.Hs(pos(101:end)),Forzamiento.OD.Tp(pos(101:end)),'.g','Markersize',10)
    plot(Forzamiento.OD.Hs(pos(51:100)),Forzamiento.OD.Tp(pos(51:100)),'.y','Markersize',15)
    plot(Forzamiento.OD.Hs(pos(26:50)),Forzamiento.OD.Tp(pos(26:50)),'.r','Markersize',20)
    plot(Forzamiento.OD.Hs(pos(1:25)),Forzamiento.OD.Tp(pos(1:25)),'.k','Markersize',25)
    xlim([min(Forzamiento.OD.Hs(pos)) 4])
    ylim([0 max(Forzamiento.OD.Tp(pos))])
    set(gca, 'fontsize', 16, 'YTick', [0, 10, 20])
    xlabel('H_{m0} (m)','Fontweight','bold','Fontsize',16)
    ylabel ('Tp (s)','Fontweight','bold','Fontsize',16)     
    
end

if isfield(Forzamiento,'OD') && isfield(Forzamiento,'OD')
    s(18) = subplot(7, 7 ,18);
    plot(Forzamiento.OD.Hs,Forzamiento.OD.Do,'.','color',[0.8 0.8 0.8],'markersize',2)
    hold on
    plot(Forzamiento.OD.Hs(pos(101:end)),Forzamiento.OD.Do(pos(101:end)),'.g','Markersize',10)
    plot(Forzamiento.OD.Hs(pos(51:100)),Forzamiento.OD.Do(pos(51:100)),'.y','Markersize',15)
    plot(Forzamiento.OD.Hs(pos(26:50)),Forzamiento.OD.Do(pos(26:50)),'.r','Markersize',20)
    plot(Forzamiento.OD.Hs(pos(1:25)),Forzamiento.OD.Do(pos(1:25)),'.k','Markersize',25)
    xlim([min(Forzamiento.OD.Hs(pos)) 4])
    ylim([240 345])
    set(gca, 'fontsize', 16, 'YTick',[240, 290, 340])      
    xlabel('H_{m0} (m)','Fontweight','bold','Fontsize',16)
    ylabel ('w_{\theta} (º)','Fontweight','bold','Fontsize',16)  
end

if isfield(Forzamiento,'OD') && isfield(Forzamiento,'MM')
    s(19) = subplot(7, 7 ,19);
    plot(Forzamiento.OD.Hs,Forzamiento.MM.vv,'.','color',[0.8 0.8 0.8],'markersize',2)
    hold on
    plot(Forzamiento.OD.Hs(pos(101:end)),Forzamiento.MM.vv(pos(101:end)),'.g','Markersize',10)
    plot(Forzamiento.OD.Hs(pos(51:100)),Forzamiento.MM.vv(pos(51:100)),'.y','Markersize',15)
    plot(Forzamiento.OD.Hs(pos(26:50)),Forzamiento.MM.vv(pos(26:50)),'.r','Markersize',20)
    plot(Forzamiento.OD.Hs(pos(1:25)),Forzamiento.MM.vv(pos(1:25)),'.k','Markersize',25)
    xlim([min(Forzamiento.OD.Hs(pos)) 4])
    ylim([0 max(Forzamiento.MM.vv(pos))])
    set(gca, 'fontsize', 16, 'YTick', [0,10, 20])
    xlabel('H_{m0} (m)','Fontweight','bold','Fontsize',16)
    ylabel ('u_{10} (m/s)','Fontweight','bold','Fontsize',16)  
end

if isfield(Forzamiento,'OD') && isfield(Forzamiento,'MM')
    s(20) = subplot(7, 7 ,20);
    plot(Forzamiento.OD.Hs,Forzamiento.MM.d_v,'.','color',[0.8 0.8 0.8],'markersize',2)
    hold on
    plot(Forzamiento.OD.Hs(pos(101:end)),Forzamiento.MM.d_v(pos(101:end)),'.g','Markersize',10)
    plot(Forzamiento.OD.Hs(pos(51:100)),Forzamiento.MM.d_v(pos(51:100)),'.y','Markersize',15)
    plot(Forzamiento.OD.Hs(pos(26:50)),Forzamiento.MM.d_v(pos(26:50)),'.r','Markersize',20)
    plot(Forzamiento.OD.Hs(pos(1:25)),Forzamiento.MM.d_v(pos(1:25)),'.k','Markersize',25)
    xlim([min(Forzamiento.OD.Hs(pos)) 4])
    ylim([min(Forzamiento.MM.d_v(pos)) max(Forzamiento.MM.d_v(pos))])
    set(gca, 'fontsize', 16, 'YTick',[0 180 360])
    xlabel('H_{m0} (m)','Fontweight','bold','Fontsize',16)
    ylabel ('u_{\theta} (º)','Fontweight','bold','Fontsize',16)  
end

if isfield(Forzamiento,'OD') && isfield(Forzamiento,'MM')
    s(21) = subplot(7, 7 ,21);
    plot(Forzamiento.OD.Hs,Forzamiento.MM.pnm,'.','color',[0.8 0.8 0.8],'markersize',2)
    hold on
    plot(Forzamiento.OD.Hs(pos(101:end)),Forzamiento.MM.pnm(pos(101:end)),'.g','Markersize',10)
    plot(Forzamiento.OD.Hs(pos(51:100)),Forzamiento.MM.pnm(pos(51:100)),'.y','Markersize',15)
    plot(Forzamiento.OD.Hs(pos(26:50)),Forzamiento.MM.pnm(pos(26:50)),'.r','Markersize',20)
    plot(Forzamiento.OD.Hs(pos(1:25)),Forzamiento.MM.pnm(pos(1:25)),'.k','Markersize',25)
    xlim([min(Forzamiento.OD.Hs(pos)) 4])
    ylim([min(Forzamiento.MM.pnm(pos)) max(Forzamiento.MM.pnm(pos))])
    set(gca, 'fontsize', 16, 'YTick',[985 1010 1035])
    xlabel('H_{m0} (m)','Fontweight','bold','Fontsize',16)
    ylabel ('slp (mbar)','Fontweight','bold','Fontsize',16)  
end

%

if isfield(Forzamiento,'OD') && isfield(Forzamiento,'OD')
    s(25) = subplot(7, 7 ,25);
    plot(Forzamiento.OD.Tp,Forzamiento.OD.Do,'.','color',[0.8 0.8 0.8],'markersize',2)
    hold on
    plot(Forzamiento.OD.Tp(pos(101:end)),Forzamiento.OD.Do(pos(101:end)),'.g','Markersize',10)
    plot(Forzamiento.OD.Tp(pos(51:100)),Forzamiento.OD.Do(pos(51:100)),'.y','Markersize',15)
    plot(Forzamiento.OD.Tp(pos(26:50)),Forzamiento.OD.Do(pos(26:50)),'.r','Markersize',20)
    plot(Forzamiento.OD.Tp(pos(1:25)),Forzamiento.OD.Do(pos(1:25)),'.k','Markersize',25)
    xlim([0 max(Forzamiento.OD.Tp(pos))])
    ylim([240 345])
    set(gca, 'fontsize', 16, 'YTick',[240, 290, 340])      
    xlabel('Tp (s)','Fontweight','bold','Fontsize',16)
    ylabel ('w_{\theta} (º)','Fontweight','bold','Fontsize',16)  
end

if isfield(Forzamiento,'OD') && isfield(Forzamiento,'MM')
    s(26) = subplot(7, 7 ,26);
    plot(Forzamiento.OD.Tp,Forzamiento.MM.vv,'.','color',[0.8 0.8 0.8],'markersize',2)
    hold on
    plot(Forzamiento.OD.Tp(pos(101:end)),Forzamiento.MM.vv(pos(101:end)),'.g','Markersize',10)
    plot(Forzamiento.OD.Tp(pos(51:100)),Forzamiento.MM.vv(pos(51:100)),'.y','Markersize',15)
    plot(Forzamiento.OD.Tp(pos(26:50)),Forzamiento.MM.vv(pos(26:50)),'.r','Markersize',20)
    plot(Forzamiento.OD.Tp(pos(1:25)),Forzamiento.MM.vv(pos(1:25)),'.k','Markersize',25)
    xlim([0 max(Forzamiento.OD.Tp(pos))])
    ylim([0 max(Forzamiento.MM.vv(pos))])
    set(gca, 'fontsize', 16, 'YTick', [0,10, 20])
    xlabel('Tp (s)','Fontweight','bold','Fontsize',16)
    ylabel ('u_{10} (m/s)','Fontweight','bold','Fontsize',16)  
end

if isfield(Forzamiento,'OD') && isfield(Forzamiento,'MM')
    s(27) = subplot(7, 7 ,27);
    plot(Forzamiento.OD.Tp,Forzamiento.MM.d_v,'.','color',[0.8 0.8 0.8],'markersize',2)
    hold on
    plot(Forzamiento.OD.Tp(pos(101:end)),Forzamiento.MM.d_v(pos(101:end)),'.g','Markersize',10)
    plot(Forzamiento.OD.Tp(pos(51:100)),Forzamiento.MM.d_v(pos(51:100)),'.y','Markersize',15)
    plot(Forzamiento.OD.Tp(pos(26:50)),Forzamiento.MM.d_v(pos(26:50)),'.r','Markersize',20)
    plot(Forzamiento.OD.Tp(pos(1:25)),Forzamiento.MM.d_v(pos(1:25)),'.k','Markersize',25)
    xlim([0 max(Forzamiento.OD.Tp(pos))])
    ylim([min(Forzamiento.MM.d_v(pos)) max(Forzamiento.MM.d_v(pos))])
    set(gca, 'fontsize', 16, 'YTick',[0 180 360])
    xlabel('Tp (s)','Fontweight','bold','Fontsize',16)
    ylabel ('u_{\theta} (º)','Fontweight','bold','Fontsize',16)  
end

if isfield(Forzamiento,'OD') && isfield(Forzamiento,'MM')
    s(28) = subplot(7, 7 ,28);
    plot(Forzamiento.OD.Tp,Forzamiento.MM.pnm,'.','color',[0.8 0.8 0.8],'markersize',2)
    hold on
    plot(Forzamiento.OD.Tp(pos(101:end)),Forzamiento.MM.pnm(pos(101:end)),'.g','Markersize',10)
    plot(Forzamiento.OD.Tp(pos(51:100)),Forzamiento.MM.pnm(pos(51:100)),'.y','Markersize',15)
    plot(Forzamiento.OD.Tp(pos(26:50)),Forzamiento.MM.pnm(pos(26:50)),'.r','Markersize',20)
    plot(Forzamiento.OD.Tp(pos(1:25)),Forzamiento.MM.pnm(pos(1:25)),'.k','Markersize',25)
    xlim([0 max(Forzamiento.OD.Tp(pos))])
    ylim([min(Forzamiento.MM.pnm(pos)) max(Forzamiento.MM.pnm(pos))])
    set(gca, 'fontsize', 16, 'YTick',[985 1010 1035])
    xlabel('Tp (s)','Fontweight','bold','Fontsize',16)
    ylabel ('slp (mbar)','Fontweight','bold','Fontsize',16)  
end

%

if isfield(Forzamiento,'OD') && isfield(Forzamiento,'MM')
    s(33) = subplot(7, 7 ,33);
    plot(Forzamiento.OD.Do,Forzamiento.MM.vv,'.','color',[0.8 0.8 0.8],'markersize',2)
    hold on
    plot(Forzamiento.OD.Do(pos(101:end)),Forzamiento.MM.vv(pos(101:end)),'.g','Markersize',10)
    plot(Forzamiento.OD.Do(pos(51:100)),Forzamiento.MM.vv(pos(51:100)),'.y','Markersize',15)
    plot(Forzamiento.OD.Do(pos(26:50)),Forzamiento.MM.vv(pos(26:50)),'.r','Markersize',20)
    plot(Forzamiento.OD.Do(pos(1:25)),Forzamiento.MM.vv(pos(1:25)),'.k','Markersize',25)
    xlim([240 345])
    ylim([0 max(Forzamiento.MM.vv(pos))])
    set(gca, 'fontsize', 16, 'YTick', [0,10, 20])
    xlabel('w_{\theta} (º)','Fontweight','bold','Fontsize',16)
    ylabel ('u_{10} (m/s)','Fontweight','bold','Fontsize',16)  
end

if isfield(Forzamiento,'OD') && isfield(Forzamiento,'MM')
    s(34) = subplot(7, 7 ,34);
    plot(Forzamiento.OD.Do,Forzamiento.MM.d_v,'.','color',[0.8 0.8 0.8],'markersize',2)
    hold on
    plot(Forzamiento.OD.Do(pos(101:end)),Forzamiento.MM.d_v(pos(101:end)),'.g','Markersize',10)
    plot(Forzamiento.OD.Do(pos(51:100)),Forzamiento.MM.d_v(pos(51:100)),'.y','Markersize',15)
    plot(Forzamiento.OD.Do(pos(26:50)),Forzamiento.MM.d_v(pos(26:50)),'.r','Markersize',20)
    plot(Forzamiento.OD.Do(pos(1:25)),Forzamiento.MM.d_v(pos(1:25)),'.k','Markersize',25)
    xlim([240 345])
    ylim([min(Forzamiento.MM.d_v(pos)) max(Forzamiento.MM.d_v(pos))])
    set(gca, 'fontsize', 16, 'YTick',[0 180 360])
    xlabel('w_{\theta} (º)','Fontweight','bold','Fontsize',16)
    ylabel ('u_{\theta} (º)','Fontweight','bold','Fontsize',16)  
end

if isfield(Forzamiento,'OD') && isfield(Forzamiento,'MM')
    s(35) = subplot(7, 7 ,35);
    plot(Forzamiento.OD.Do,Forzamiento.MM.pnm,'.','color',[0.8 0.8 0.8],'markersize',2)
    hold on
    plot(Forzamiento.OD.Do(pos(101:end)),Forzamiento.MM.pnm(pos(101:end)),'.g','Markersize',10)
    plot(Forzamiento.OD.Do(pos(51:100)),Forzamiento.MM.pnm(pos(51:100)),'.y','Markersize',15)
    plot(Forzamiento.OD.Do(pos(26:50)),Forzamiento.MM.pnm(pos(26:50)),'.r','Markersize',20)
    plot(Forzamiento.OD.Do(pos(1:25)),Forzamiento.MM.pnm(pos(1:25)),'.k','Markersize',25)
    xlim([240 345])
    ylim([min(Forzamiento.MM.pnm(pos)) max(Forzamiento.MM.pnm(pos))])
    set(gca, 'fontsize', 16, 'YTick',[985 1010 1035])
    xlabel('w_{\theta} (º)','Fontweight','bold','Fontsize',16)
    ylabel ('slp (mbar)','Fontweight','bold','Fontsize',16)  
end

%

if isfield(Forzamiento,'MM') && isfield(Forzamiento,'MM')
    s(41) = subplot(7, 7 ,41);
    plot(Forzamiento.MM.vv,Forzamiento.MM.d_v,'.','color',[0.8 0.8 0.8],'markersize',2)
    hold on
    plot(Forzamiento.MM.vv(pos(101:end)),Forzamiento.MM.d_v(pos(101:end)),'.g','Markersize',10)
    plot(Forzamiento.MM.vv(pos(51:100)),Forzamiento.MM.d_v(pos(51:100)),'.y','Markersize',15)
    plot(Forzamiento.MM.vv(pos(26:50)),Forzamiento.MM.d_v(pos(26:50)),'.r','Markersize',20)
    plot(Forzamiento.MM.vv(pos(1:25)),Forzamiento.MM.d_v(pos(1:25)),'.k','Markersize',25)
    xlim([0 max(Forzamiento.MM.vv(pos))])
    ylim([min(Forzamiento.MM.d_v(pos)) max(Forzamiento.MM.d_v(pos))])
    set(gca, 'fontsize', 16, 'YTick',[0 180 360])
    xlabel('u_{10} (m/s)','Fontweight','bold','Fontsize',16)
    ylabel ('u_{\theta} (º)','Fontweight','bold','Fontsize',16)  
end

if isfield(Forzamiento,'MM') && isfield(Forzamiento,'MM')
    s(42) = subplot(7, 7 ,42);
    plot(Forzamiento.MM.vv,Forzamiento.MM.pnm,'.','color',[0.8 0.8 0.8],'markersize',2)
    hold on
    plot(Forzamiento.MM.vv(pos(101:end)),Forzamiento.MM.pnm(pos(101:end)),'.g','Markersize',10)
    plot(Forzamiento.MM.vv(pos(51:100)),Forzamiento.MM.pnm(pos(51:100)),'.y','Markersize',15)
    plot(Forzamiento.MM.vv(pos(26:50)),Forzamiento.MM.pnm(pos(26:50)),'.r','Markersize',20)
    plot(Forzamiento.MM.vv(pos(1:25)),Forzamiento.MM.pnm(pos(1:25)),'.k','Markersize',25)
    xlim([0 max(Forzamiento.MM.vv(pos))])
    ylim([min(Forzamiento.MM.pnm(pos)) max(Forzamiento.MM.pnm(pos))])
    set(gca, 'fontsize', 16, 'YTick',[985 1010 1035])
    xlabel('u_{10} (m/s)','Fontweight','bold','Fontsize',16)
    ylabel ('slp (mbar)','Fontweight','bold','Fontsize',16)  
end

%

if isfield(Forzamiento,'MM') && isfield(Forzamiento,'MM')
    s(49) = subplot(7, 7 ,49);
    plot(Forzamiento.MM.d_v,Forzamiento.MM.pnm,'.','color',[0.8 0.8 0.8],'markersize',2)
    hold on
    plot(Forzamiento.MM.d_v(pos(101:end)),Forzamiento.MM.pnm(pos(101:end)),'.g','Markersize',10)
    plot(Forzamiento.MM.d_v(pos(51:100)),Forzamiento.MM.pnm(pos(51:100)),'.y','Markersize',15)
    plot(Forzamiento.MM.d_v(pos(26:50)),Forzamiento.MM.pnm(pos(26:50)),'.r','Markersize',20)
    plot(Forzamiento.MM.d_v(pos(1:25)),Forzamiento.MM.pnm(pos(1:25)),'.k','Markersize',25)
    xlim([min(Forzamiento.MM.d_v(pos))-1 max(Forzamiento.MM.d_v(pos))+1])
    ylim([min(Forzamiento.MM.pnm(pos)) max(Forzamiento.MM.pnm(pos))])
    set(gca, 'fontsize', 16, 'YTick',[985 1010 1035])
    set(gca, 'fontsize', 16, 'XTick',[0 180 360])
    xlabel('u_{\theta} (º)','Fontweight','bold','Fontsize',16) 
    ylabel ('slp (mbar)','Fontweight','bold','Fontsize',16)  
end


% addpath('export_fig_2016')
% directorio_salida = ['MDA_v3.png'];
% export_fig(figure1, directorio_salida, '-png', '-q101'); % Salvar en pdf

%%%

%% Representacion en 2D ingles
% if isfield(Forzamiento,'OD')
% if isfield(Forzamiento,'MM')
% if isfield(Forzamiento,'MA')
% if isfield(Forzamiento,'Q')

figure1 = figure('PaperSize',[20.98 29.68],'Color',[1 1 1],'Position',[1,1,2000,1000],'Visible','on');
if isfield(Forzamiento,'OD')
    s(1) = subplot(4, 6 ,1);
    plot(Forzamiento.OD.Hs,Forzamiento.OD.Tp,'.','color',[0.8 0.8 0.8],'markersize',2)
    hold on
    plot(Forzamiento.OD.Hs(pos(101:end)),Forzamiento.OD.Tp(pos(101:end)),'.g','Markersize',10)
    plot(Forzamiento.OD.Hs(pos(51:100)),Forzamiento.OD.Tp(pos(51:100)),'.y','Markersize',15)
    plot(Forzamiento.OD.Hs(pos(26:50)),Forzamiento.OD.Tp(pos(26:50)),'.r','Markersize',20)
    plot(Forzamiento.OD.Hs(pos(1:25)),Forzamiento.OD.Tp(pos(1:25)),'.k','Markersize',25)
    xlim([min(Forzamiento.OD.Hs(pos)) max(Forzamiento.OD.Hs(pos))])
    ylim([min(Forzamiento.OD.Tp(pos)) max(Forzamiento.OD.Tp(pos))])
    set(gca, 'fontsize', 16)
    ylabel('Tp (s)','Fontweight','bold','Fontsize',16)
    xlabel ('Hs (m)','Fontweight','bold','Fontsize',16)  
end

if isfield(Forzamiento,'OD')
    s(2) = subplot(4, 6 ,2);
    plot(Forzamiento.OD.Hs,Forzamiento.OD.Do,'.','color',[0.8 0.8 0.8],'markersize',2)
    hold on
    plot(Forzamiento.OD.Hs(pos(101:end)),Forzamiento.OD.Do(pos(101:end)),'.g','Markersize',10)
    plot(Forzamiento.OD.Hs(pos(51:100)),Forzamiento.OD.Do(pos(51:100)),'.y','Markersize',15)
    plot(Forzamiento.OD.Hs(pos(26:50)),Forzamiento.OD.Do(pos(26:50)),'.r','Markersize',20)
    plot(Forzamiento.OD.Hs(pos(1:25)),Forzamiento.OD.Do(pos(1:25)),'.k','Markersize',25)
    xlim([min(Forzamiento.OD.Hs(pos)) max(Forzamiento.OD.Hs(pos))])
    ylim([min(Forzamiento.OD.Do(pos)) max(Forzamiento.OD.Do(pos))])
    set(gca, 'fontsize', 16)
    ylabel('\theta (º)','Fontweight','bold','Fontsize',16)
    xlabel ('Hs (m)','Fontweight','bold','Fontsize',16)  
end

if (isfield(Forzamiento,'OD') && isfield(Forzamiento,'MM'))
    s(3) = subplot(4, 6 ,3);
    plot(Forzamiento.OD.Hs,Forzamiento.MM.vv,'.','color',[0.8 0.8 0.8],'markersize',2)
    hold on
    plot(Forzamiento.OD.Hs(pos(101:end)),Forzamiento.MM.vv(pos(101:end)),'.g','Markersize',10)
    plot(Forzamiento.OD.Hs(pos(51:100)),Forzamiento.MM.vv(pos(51:100)),'.y','Markersize',15)
    plot(Forzamiento.OD.Hs(pos(26:50)),Forzamiento.MM.vv(pos(26:50)),'.r','Markersize',20)
    plot(Forzamiento.OD.Hs(pos(1:25)),Forzamiento.MM.vv(pos(1:25)),'.k','Markersize',25)
    xlim([min(Forzamiento.OD.Hs(pos)) max(Forzamiento.OD.Hs(pos))])
    ylim([min(Forzamiento.MM.vv(pos)) max(Forzamiento.MM.vv(pos))])
    set(gca, 'fontsize', 16)
    %ylabel('W_{u10} (m/s)','Fontweight','bold','Fontsize',16)
    xlabel ('Hs (m)','Fontweight','bold','Fontsize',16)  
end

if (isfield(Forzamiento,'OD') && isfield(Forzamiento,'MM'))
    s(4) = subplot(4, 6 ,4);
    plot(Forzamiento.OD.Hs,Forzamiento.MM.d_v,'.','color',[0.8 0.8 0.8],'markersize',2)
    hold on
    plot(Forzamiento.OD.Hs(pos(101:end)),Forzamiento.MM.d_v(pos(101:end)),'.g','Markersize',10)
    plot(Forzamiento.OD.Hs(pos(51:100)),Forzamiento.MM.d_v(pos(51:100)),'.y','Markersize',15)
    plot(Forzamiento.OD.Hs(pos(26:50)),Forzamiento.MM.d_v(pos(26:50)),'.r','Markersize',20)
    plot(Forzamiento.OD.Hs(pos(1:25)),Forzamiento.MM.d_v(pos(1:25)),'.k','Markersize',25)
    xlim([min(Forzamiento.OD.Hs(pos)) max(Forzamiento.OD.Hs(pos))])
    ylim([min(Forzamiento.MM.d_v(pos)) max(Forzamiento.MM.d_v(pos))])
    set(gca, 'fontsize', 16)
    ylabel('W_{\theta} (º)','Fontweight','bold','Fontsize',16)
    xlabel ('Hs (m)','Fontweight','bold','Fontsize',16)  
end

if (isfield(Forzamiento,'OD') && isfield(Forzamiento,'MA'))
    s(5) = subplot(4, 6 ,5);
    plot(Forzamiento.OD.Hs,Forzamiento.MA.ma,'.','color',[0.8 0.8 0.8],'markersize',2)
    hold on
    plot(Forzamiento.OD.Hs(pos(101:end)),Forzamiento.MA.ma(pos(101:end)),'.g','Markersize',10)
    plot(Forzamiento.OD.Hs(pos(51:100)),Forzamiento.MA.ma(pos(51:100)),'.y','Markersize',15)
    plot(Forzamiento.OD.Hs(pos(26:50)),Forzamiento.MA.ma(pos(26:50)),'.r','Markersize',20)
    plot(Forzamiento.OD.Hs(pos(1:25)),Forzamiento.MA.ma(pos(1:25)),'.k','Markersize',25)
    xlim([min(Forzamiento.OD.Hs(pos)) max(Forzamiento.OD.Hs(pos))])
    ylim([min(Forzamiento.MA.ma(pos)) max(Forzamiento.MA.ma(pos))])
    set(gca, 'fontsize', 16)
    ylabel('\eta_{AT} (m)','Fontweight','bold','Fontsize',16)
    xlabel ('Hs (m)','Fontweight','bold','Fontsize',16)  
end

if (isfield(Forzamiento,'OD') && isfield(Forzamiento,'Q'))
    s(6) = subplot(4, 6 ,6);
    plot(Forzamiento.OD.Hs,Forzamiento.Q.q,'.','color',[0.8 0.8 0.8],'markersize',2)
    hold on
    plot(Forzamiento.OD.Hs(pos(101:end)),Forzamiento.Q.q(pos(101:end)),'.g','Markersize',10)
    plot(Forzamiento.OD.Hs(pos(51:100)),Forzamiento.Q.q(pos(51:100)),'.y','Markersize',15)
    plot(Forzamiento.OD.Hs(pos(26:50)),Forzamiento.Q.q(pos(26:50)),'.r','Markersize',20)
    plot(Forzamiento.OD.Hs(pos(1:25)),Forzamiento.Q.q(pos(1:25)),'.k','Markersize',25)
    xlim([min(Forzamiento.OD.Hs(pos)) max(Forzamiento.OD.Hs(pos))])
    ylim([min(Forzamiento.Q.q(pos)) max(Forzamiento.Q.q(pos))])
    set(gca, 'fontsize', 16)
    ylabel('Q (m3/s)','Fontweight','bold','Fontsize',16)
    xlabel ('Hs (m)','Fontweight','bold','Fontsize',16)  
end
%%%%
if isfield(Forzamiento,'OD')
    s(7) = subplot(4, 6 ,7);
    plot(Forzamiento.OD.Tp,Forzamiento.OD.Do,'.','color',[0.8 0.8 0.8],'markersize',2)
    hold on
    plot(Forzamiento.OD.Tp(pos(101:end)),Forzamiento.OD.Do(pos(101:end)),'.g','Markersize',10)
    plot(Forzamiento.OD.Tp(pos(51:100)),Forzamiento.OD.Do(pos(51:100)),'.y','Markersize',15)
    plot(Forzamiento.OD.Tp(pos(26:50)),Forzamiento.OD.Do(pos(26:50)),'.r','Markersize',20)
    plot(Forzamiento.OD.Tp(pos(1:25)),Forzamiento.OD.Do(pos(1:25)),'.k','Markersize',25)
    xlim([min(Forzamiento.OD.Tp(pos)) max(Forzamiento.OD.Tp(pos))])
    ylim([min(Forzamiento.OD.Do(pos)) max(Forzamiento.OD.Do(pos))])
    set(gca, 'fontsize', 16)
    ylabel('\theta (º)','Fontweight','bold','Fontsize',16)
    xlabel ('Tp (s)','Fontweight','bold','Fontsize',16)  
end

if (isfield(Forzamiento,'OD') && isfield(Forzamiento,'MM'))
    s(8) = subplot(4, 6 ,8);
    plot(Forzamiento.OD.Tp,Forzamiento.MM.vv,'.','color',[0.8 0.8 0.8],'markersize',2)
    hold on
    plot(Forzamiento.OD.Tp(pos(101:end)),Forzamiento.MM.vv(pos(101:end)),'.g','Markersize',10)
    plot(Forzamiento.OD.Tp(pos(51:100)),Forzamiento.MM.vv(pos(51:100)),'.y','Markersize',15)
    plot(Forzamiento.OD.Tp(pos(26:50)),Forzamiento.MM.vv(pos(26:50)),'.r','Markersize',20)
    plot(Forzamiento.OD.Tp(pos(1:25)),Forzamiento.MM.vv(pos(1:25)),'.k','Markersize',25)
    xlim([min(Forzamiento.OD.Tp(pos)) max(Forzamiento.OD.Tp(pos))])
    ylim([min(Forzamiento.MM.vv(pos)) max(Forzamiento.MM.vv(pos))])
    set(gca, 'fontsize', 16)
    ylabel('W_{u10} (m/s)','Fontweight','bold','Fontsize',16)
    xlabel ('Tp (s)','Fontweight','bold','Fontsize',16)  
end

if (isfield(Forzamiento,'OD') && isfield(Forzamiento,'MM'))
    s(9) = subplot(4, 6 ,9);
    plot(Forzamiento.OD.Tp,Forzamiento.MM.d_v,'.','color',[0.8 0.8 0.8],'markersize',2)
    hold on
    plot(Forzamiento.OD.Tp(pos(101:end)),Forzamiento.MM.d_v(pos(101:end)),'.g','Markersize',10)
    plot(Forzamiento.OD.Tp(pos(51:100)),Forzamiento.MM.d_v(pos(51:100)),'.y','Markersize',15)
    plot(Forzamiento.OD.Tp(pos(26:50)),Forzamiento.MM.d_v(pos(26:50)),'.r','Markersize',20)
    plot(Forzamiento.OD.Tp(pos(1:25)),Forzamiento.MM.d_v(pos(1:25)),'.k','Markersize',25)
    xlim([min(Forzamiento.OD.Tp(pos)) max(Forzamiento.OD.Tp(pos))])
    ylim([min(Forzamiento.MM.d_v(pos)) max(Forzamiento.MM.d_v(pos))])
    set(gca, 'fontsize', 16)
    ylabel('W_{\theta} (º)','Fontweight','bold','Fontsize',16)
    xlabel ('Tp (s)','Fontweight','bold','Fontsize',16)  
end

if (isfield(Forzamiento,'OD') && isfield(Forzamiento,'MA'))
    s(10) = subplot(4, 6 ,10);
    plot(Forzamiento.OD.Tp,Forzamiento.MA.ma,'.','color',[0.8 0.8 0.8],'markersize',2)
    hold on
    plot(Forzamiento.OD.Tp(pos(101:end)),Forzamiento.MA.ma(pos(101:end)),'.g','Markersize',10)
    plot(Forzamiento.OD.Tp(pos(51:100)),Forzamiento.MA.ma(pos(51:100)),'.y','Markersize',15)
    plot(Forzamiento.OD.Tp(pos(26:50)),Forzamiento.MA.ma(pos(26:50)),'.r','Markersize',20)
    plot(Forzamiento.OD.Tp(pos(1:25)),Forzamiento.MA.ma(pos(1:25)),'.k','Markersize',25)
    xlim([min(Forzamiento.OD.Tp(pos)) max(Forzamiento.OD.Tp(pos))])
    ylim([min(Forzamiento.MA.ma(pos)) max(Forzamiento.MA.ma(pos))])
    set(gca, 'fontsize', 16)
    ylabel('\eta_{AT} (m)','Fontweight','bold','Fontsize',16)
    xlabel ('Tp (s)','Fontweight','bold','Fontsize',16)  
end

if (isfield(Forzamiento,'OD') && isfield(Forzamiento,'Q'))
    s(11) = subplot(4, 6 ,11);
    plot(Forzamiento.OD.Tp,Forzamiento.Q.q,'.','color',[0.8 0.8 0.8],'markersize',2)
    hold on
    plot(Forzamiento.OD.Tp(pos(101:end)),Forzamiento.Q.q(pos(101:end)),'.g','Markersize',10)
    plot(Forzamiento.OD.Tp(pos(51:100)),Forzamiento.Q.q(pos(51:100)),'.y','Markersize',15)
    plot(Forzamiento.OD.Tp(pos(26:50)),Forzamiento.Q.q(pos(26:50)),'.r','Markersize',20)
    plot(Forzamiento.OD.Tp(pos(1:25)),Forzamiento.Q.q(pos(1:25)),'.k','Markersize',25)
    xlim([min(Forzamiento.OD.Tp(pos)) max(Forzamiento.OD.Tp(pos))])
    ylim([min(Forzamiento.Q.q(pos)) max(Forzamiento.Q.q(pos))])
    set(gca, 'fontsize', 16)
    ylabel('Q (m3/s)','Fontweight','bold','Fontsize',16)
    xlabel ('Tp (s)','Fontweight','bold','Fontsize',16)  
end
%%%%%
if (isfield(Forzamiento,'OD') && isfield(Forzamiento,'MM'))
    s(12) = subplot(4, 6 ,12);
    plot(Forzamiento.OD.Do, Forzamiento.MM.vv,'.','color',[0.8 0.8 0.8],'markersize',2)
    hold on
    plot(Forzamiento.OD.Do(pos(101:end)), Forzamiento.MM.vv(pos(101:end)),'.g','Markersize',10)
    plot(Forzamiento.OD.Do(pos(51:100)), Forzamiento.MM.vv(pos(51:100)),'.y','Markersize',15)
    plot(Forzamiento.OD.Do(pos(26:50)), Forzamiento.MM.vv(pos(26:50)),'.r','Markersize',20)
    plot(Forzamiento.OD.Do(pos(1:25)), Forzamiento.MM.vv(pos(1:25)),'.k','Markersize',25)
    ylim([min(Forzamiento.MM.vv(pos)) max(Forzamiento.MM.vv(pos))])
    xlim([min(Forzamiento.OD.Do(pos)) max(Forzamiento.OD.Do(pos))])
    set(gca, 'fontsize', 16)
    ylabel('W_{u10} (m/s)','Fontweight','bold','Fontsize',16)
    xlabel ('\theta (º)','Fontweight','bold','Fontsize',16)  
end

if (isfield(Forzamiento,'OD') && isfield(Forzamiento,'MM'))
    s(13) = subplot(4, 6 ,13);
    plot(Forzamiento.OD.Do,Forzamiento.MM.d_v,'.','color',[0.8 0.8 0.8],'markersize',2)
    hold on
    plot(Forzamiento.OD.Do(pos(101:end)),Forzamiento.MM.d_v(pos(101:end)),'.g','Markersize',10)
    plot(Forzamiento.OD.Do(pos(51:100)),Forzamiento.MM.d_v(pos(51:100)),'.y','Markersize',15)
    plot(Forzamiento.OD.Do(pos(26:50)),Forzamiento.MM.d_v(pos(26:50)),'.r','Markersize',20)
    plot(Forzamiento.OD.Do(pos(1:25)),Forzamiento.MM.d_v(pos(1:25)),'.k','Markersize',25)
    xlim([min(Forzamiento.OD.Do(pos)) max(Forzamiento.OD.Do(pos))])
    ylim([min(Forzamiento.MM.d_v(pos)) max(Forzamiento.MM.d_v(pos))])
    set(gca, 'fontsize', 16)
    ylabel('W_{\theta} (º)','Fontweight','bold','Fontsize',16)
    xlabel ('\theta (º)','Fontweight','bold','Fontsize',16)  
end

if (isfield(Forzamiento,'OD') && isfield(Forzamiento,'MA'))
    s(14) = subplot(4, 6 ,14);
    plot(Forzamiento.OD.Do, Forzamiento.MA.ma,'.','color',[0.8 0.8 0.8],'markersize',2)
    hold on
    plot(Forzamiento.OD.Do(pos(101:end)), Forzamiento.MA.ma(pos(101:end)),'.g','Markersize',10)
    plot(Forzamiento.OD.Do(pos(51:100)), Forzamiento.MA.ma(pos(51:100)),'.y','Markersize',15)
    plot(Forzamiento.OD.Do(pos(26:50)), Forzamiento.MA.ma(pos(26:50)),'.r','Markersize',20)
    plot(Forzamiento.OD.Do(pos(1:25)), Forzamiento.MA.ma(pos(1:25)),'.k','Markersize',25)
    ylim([min(Forzamiento.MA.ma(pos)) max(Forzamiento.MA.ma(pos))])
    xlim([min(Forzamiento.OD.Do(pos)) max(Forzamiento.OD.Do(pos))])
    set(gca, 'fontsize', 16)
    ylabel('\eta_{AT} (m)','Fontweight','bold','Fontsize',16)
    xlabel ('\theta (º)','Fontweight','bold','Fontsize',16)  
end

if (isfield(Forzamiento,'OD') && isfield(Forzamiento,'Q'))
    s(15) = subplot(4, 6 ,15);
    plot(Forzamiento.OD.Do,Forzamiento.Q.q,'.','color',[0.8 0.8 0.8],'markersize',2)
    hold on
    plot(Forzamiento.OD.Do(pos(101:end)), Forzamiento.Q.q(pos(101:end)),'.g','Markersize',10)
    plot(Forzamiento.OD.Do(pos(51:100)), Forzamiento.Q.q(pos(51:100)),'.y','Markersize',15)
    plot(Forzamiento.OD.Do(pos(26:50)), Forzamiento.Q.q(pos(26:50)),'.r','Markersize',20)
    plot(Forzamiento.OD.Do(pos(1:25)), Forzamiento.Q.q(pos(1:25)),'.k','Markersize',25)
    ylim([min(Forzamiento.Q.q(pos)) max(Forzamiento.Q.q(pos))])
    xlim([min(Forzamiento.OD.Do(pos)) max(Forzamiento.OD.Do(pos))])
    set(gca, 'fontsize', 16)
    ylabel('Q (m3/s)','Fontweight','bold','Fontsize',16)
    xlabel ('\theta (º)','Fontweight','bold','Fontsize',16)  
end

%%%%% %%%%
if (isfield(Forzamiento,'MM'))
    s(16) = subplot(4, 6 ,16);
    plot(Forzamiento.MM.vv,Forzamiento.MM.d_v,'.','color',[0.8 0.8 0.8],'markersize',2)
    hold on
    plot(Forzamiento.MM.vv(pos(101:end)),Forzamiento.MM.d_v(pos(101:end)),'.g','Markersize',10)
    plot(Forzamiento.MM.vv(pos(51:100)),Forzamiento.MM.d_v(pos(51:100)),'.y','Markersize',15)
    plot(Forzamiento.MM.vv(pos(26:50)),Forzamiento.MM.d_v(pos(26:50)),'.r','Markersize',20)
    plot(Forzamiento.MM.vv(pos(1:25)),Forzamiento.MM.d_v(pos(1:25)),'.k','Markersize',25)
    xlim([min(Forzamiento.MM.vv(pos)) max(Forzamiento.MM.vv(pos))])
    ylim([min(Forzamiento.MM.d_v(pos)) max(Forzamiento.MM.d_v(pos))])
    set(gca, 'fontsize', 16)
    xlabel('W_{u10} (m/s)','Fontweight','bold','Fontsize',16)
    ylabel ('W_{\theta} (º)','Fontweight','bold','Fontsize',16)  
end

if (isfield(Forzamiento,'MM') && isfield(Forzamiento,'MA'))
    s(17) = subplot(4, 6 ,17);
    plot(Forzamiento.MM.vv,Forzamiento.MA.ma,'.','color',[0.8 0.8 0.8],'markersize',2)
    hold on
    plot(Forzamiento.MM.vv(pos(101:end)),Forzamiento.MA.ma(pos(101:end)),'.g','Markersize',10)
    plot(Forzamiento.MM.vv(pos(51:100)),Forzamiento.MA.ma(pos(51:100)),'.y','Markersize',15)
    plot(Forzamiento.MM.vv(pos(26:50)),Forzamiento.MA.ma(pos(26:50)),'.r','Markersize',20)
    plot(Forzamiento.MM.vv(pos(1:25)),Forzamiento.MA.ma(pos(1:25)),'.k','Markersize',25)
    xlim([min(Forzamiento.MM.vv(pos)) max(Forzamiento.MM.vv(pos))])
    ylim([min(Forzamiento.MA.ma(pos)) max(Forzamiento.MA.ma(pos))])
    set(gca, 'fontsize', 16)
    ylabel('\eta_{AT} (m)','Fontweight','bold','Fontsize',16)
    xlabel ('W_{u10} (m/s)','Fontweight','bold','Fontsize',16)  
end

if (isfield(Forzamiento,'MM') && isfield(Forzamiento,'Q'))
    s(18) = subplot(4, 6 ,18);
    plot(Forzamiento.MM.vv,Forzamiento.Q.q,'.','color',[0.8 0.8 0.8],'markersize',2)
    hold on
    plot(Forzamiento.MM.vv(pos(101:end)),Forzamiento.Q.q(pos(101:end)),'.g','Markersize',10)
    plot(Forzamiento.MM.vv(pos(51:100)),Forzamiento.Q.q(pos(51:100)),'.y','Markersize',15)
    plot(Forzamiento.MM.vv(pos(26:50)),Forzamiento.Q.q(pos(26:50)),'.r','Markersize',20)
    plot(Forzamiento.MM.vv(pos(1:25)),Forzamiento.Q.q(pos(1:25)),'.k','Markersize',25)
    xlim([min(Forzamiento.MM.vv(pos)) max(Forzamiento.MM.vv(pos))])
    ylim([min(Forzamiento.Q.q(pos)) max(Forzamiento.Q.q(pos))])
    set(gca, 'fontsize', 16)
    ylabel('Q (m3/s)','Fontweight','bold','Fontsize',16)
    xlabel ('W_{u10} (m/s)','Fontweight','bold','Fontsize',16)  
end

if (isfield(Forzamiento,'MM') && isfield(Forzamiento,'MA'))
    s(19) = subplot(4, 6 ,19);
    plot(Forzamiento.MM.d_v, Forzamiento.MA.ma,'.','color',[0.8 0.8 0.8],'markersize',2)
    hold on
    plot(Forzamiento.MM.d_v(pos(101:end)), Forzamiento.MA.ma(pos(101:end)),'.g','Markersize',10)
    plot(Forzamiento.MM.d_v(pos(51:100)), Forzamiento.MA.ma(pos(51:100)),'.y','Markersize',15)
    plot(Forzamiento.MM.d_v(pos(26:50)), Forzamiento.MA.ma(pos(26:50)),'.r','Markersize',20)
    plot(Forzamiento.MM.d_v(pos(1:25)), Forzamiento.MA.ma(pos(1:25)),'.k','Markersize',25)
    ylim([min(Forzamiento.MA.ma(pos)) max(Forzamiento.MA.ma(pos))])
    xlim([min(Forzamiento.MM.d_v(pos)) max(Forzamiento.MM.d_v(pos))])
    set(gca, 'fontsize', 16)
    ylabel('\eta_{AT} (m)','Fontweight','bold','Fontsize',16)
    xlabel ('W_{\theta} (º)','Fontweight','bold','Fontsize',16)  
end

if (isfield(Forzamiento,'MM') && isfield(Forzamiento,'Q'))
    s(20) = subplot(4, 6 ,20);
    plot(Forzamiento.MM.d_v, Forzamiento.Q.q,'.','color',[0.8 0.8 0.8],'markersize',2)
    hold on
    plot(Forzamiento.MM.d_v(pos(101:end)), Forzamiento.Q.q(pos(101:end)),'.g','Markersize',10)
    plot(Forzamiento.MM.d_v(pos(51:100)), Forzamiento.Q.q(pos(51:100)),'.y','Markersize',15)
    plot(Forzamiento.MM.d_v(pos(26:50)), Forzamiento.Q.q(pos(26:50)),'.r','Markersize',20)
    plot(Forzamiento.MM.d_v(pos(1:25)), Forzamiento.Q.q(pos(1:25)),'.k','Markersize',25)
    ylim([min(Forzamiento.Q.q(pos)) max(Forzamiento.Q.q(pos))])
    xlim([min(Forzamiento.MM.d_v(pos)) max(Forzamiento.MM.d_v(pos))])
    set(gca, 'fontsize', 16)
    ylabel('Q (m3/s)','Fontweight','bold','Fontsize',16)
    xlabel ('W_{\theta} (º)','Fontweight','bold','Fontsize',16)  
end

if (isfield(Forzamiento,'MM') && isfield(Forzamiento,'Q'))
    s(21) = subplot(4, 6 ,21);
    plot(Forzamiento.MA.ma,Forzamiento.Q.q,'.','color',[0.8 0.8 0.8],'markersize',10)
    hold on
    plot(Forzamiento.MA.ma(pos(101:end)),Forzamiento.Q.q(pos(101:end)),'.g','Markersize',10)
    plot(Forzamiento.MA.ma(pos(51:100)),Forzamiento.Q.q(pos(51:100)),'.y','Markersize',15)
    plot(Forzamiento.MA.ma(pos(26:50)),Forzamiento.Q.q(pos(26:50)),'.r','Markersize',20)
    plot(Forzamiento.MA.ma(pos(1:25)),Forzamiento.Q.q(pos(1:25)),'.k','Markersize',25)
    xlim([min(Forzamiento.MA.ma(pos)) max(Forzamiento.MA.ma(pos))])
    ylim([min(Forzamiento.Q.q(pos)) max(Forzamiento.Q.q(pos))])
    set(gca, 'fontsize', 16)
    ylabel('Q (m3/s)','Fontweight','bold','Fontsize',16)
    xlabel ('\eta_{AT} (m)','Fontweight','bold','Fontsize',16)  
end


%%%%% %%%%


if isfield(Forzamiento,'OD')
    s(3) = subplot(4, 6 ,3);
    plot(Forzamiento.OD.Tp,Forzamiento.OD.Do,'.','color',[0.8 0.8 0.8],'markersize',2)
    hold on
    plot(Forzamiento.OD.Tp(pos(101:end)),Forzamiento.OD.Do(pos(101:end)),'.g','Markersize',10)
    plot(Forzamiento.OD.Tp(pos(51:100)),Forzamiento.OD.Do(pos(51:100)),'.y','Markersize',15)
    plot(Forzamiento.OD.Tp(pos(26:50)),Forzamiento.OD.Do(pos(26:50)),'.r','Markersize',20)
    plot(Forzamiento.OD.Tp(pos(1:25)),Forzamiento.OD.Do(pos(1:25)),'.k','Markersize',25)
    xlim([min(Forzamiento.OD.Tp(pos)) max(Forzamiento.OD.Tp(pos))])
    ylim([min(Forzamiento.OD.Do(pos)) max(Forzamiento.OD.Do(pos))])
    set(gca, 'fontsize', 16)
    ylabel('\theta (º)','Fontweight','bold','Fontsize',16)
    xlabel ('Tp (s)','Fontweight','bold','Fontsize',16)  
end

% addpath('Rutinas_export_fig')
% directorio_salida = ['MDA.png'];
% export_fig(figure1, directorio_salida, '-png', '-q101'); % Salvar en pdf

%% Español
figure1 = figure('PaperSize',[20.98 29.68],'Color',[1 1 1],'Position',[1,1,2000,1000],'Visible','on');
if isfield(Forzamiento,'OD')
    s(1) = subplot(4, 6 ,1);
    plot(Forzamiento.OD.Hs,Forzamiento.OD.Tp,'.','color',[0.8 0.8 0.8],'markersize',2)
    hold on
    plot(Forzamiento.OD.Hs(pos(101:end)),Forzamiento.OD.Tp(pos(101:end)),'.g','Markersize',10)
    plot(Forzamiento.OD.Hs(pos(51:100)),Forzamiento.OD.Tp(pos(51:100)),'.y','Markersize',15)
    plot(Forzamiento.OD.Hs(pos(26:50)),Forzamiento.OD.Tp(pos(26:50)),'.r','Markersize',20)
    plot(Forzamiento.OD.Hs(pos(1:25)),Forzamiento.OD.Tp(pos(1:25)),'.k','Markersize',25)
    xlim([min(Forzamiento.OD.Hs(pos)) max(Forzamiento.OD.Hs(pos))])
    ylim([min(Forzamiento.OD.Tp(pos)) max(Forzamiento.OD.Tp(pos))])
    set(gca, 'fontsize', 16)
    ylabel('Tp (s)','Fontweight','bold','Fontsize',16)
    xlabel ('Hs (m)','Fontweight','bold','Fontsize',16)  
end

if isfield(Forzamiento,'OD')
    s(2) = subplot(4, 6 ,2);
    plot(Forzamiento.OD.Hs,Forzamiento.OD.Do,'.','color',[0.8 0.8 0.8],'markersize',2)
    hold on
    plot(Forzamiento.OD.Hs(pos(101:end)),Forzamiento.OD.Do(pos(101:end)),'.g','Markersize',10)
    plot(Forzamiento.OD.Hs(pos(51:100)),Forzamiento.OD.Do(pos(51:100)),'.y','Markersize',15)
    plot(Forzamiento.OD.Hs(pos(26:50)),Forzamiento.OD.Do(pos(26:50)),'.r','Markersize',20)
    plot(Forzamiento.OD.Hs(pos(1:25)),Forzamiento.OD.Do(pos(1:25)),'.k','Markersize',25)
    xlim([min(Forzamiento.OD.Hs(pos)) max(Forzamiento.OD.Hs(pos))])
    ylim([min(Forzamiento.OD.Do(pos)) max(Forzamiento.OD.Do(pos))])
    set(gca, 'fontsize', 16)
    ylabel('Dmd (º)','Fontweight','bold','Fontsize',16)
    xlabel ('Hs (m)','Fontweight','bold','Fontsize',16)  
end

if (isfield(Forzamiento,'OD') && isfield(Forzamiento,'MM'))
    s(3) = subplot(4, 6 ,3);
    plot(Forzamiento.OD.Hs,Forzamiento.MM.vv,'.','color',[0.8 0.8 0.8],'markersize',2)
    hold on
    plot(Forzamiento.OD.Hs(pos(101:end)),Forzamiento.MM.vv(pos(101:end)),'.g','Markersize',10)
    plot(Forzamiento.OD.Hs(pos(51:100)),Forzamiento.MM.vv(pos(51:100)),'.y','Markersize',15)
    plot(Forzamiento.OD.Hs(pos(26:50)),Forzamiento.MM.vv(pos(26:50)),'.r','Markersize',20)
    plot(Forzamiento.OD.Hs(pos(1:25)),Forzamiento.MM.vv(pos(1:25)),'.k','Markersize',25)
    xlim([min(Forzamiento.OD.Hs(pos)) max(Forzamiento.OD.Hs(pos))])
    ylim([min(Forzamiento.MM.vv(pos)) max(Forzamiento.MM.vv(pos))])
    set(gca, 'fontsize', 16)
    ylabel('Vv (m/s)','Fontweight','bold','Fontsize',16)
    xlabel ('Hs (m)','Fontweight','bold','Fontsize',16)  
end

if (isfield(Forzamiento,'OD') && isfield(Forzamiento,'MM'))
    s(4) = subplot(4, 6 ,4);
    plot(Forzamiento.OD.Hs,Forzamiento.MM.vv,'.','color',[0.8 0.8 0.8],'markersize',2)
    hold on
    plot(Forzamiento.OD.Hs(pos(101:end)),Forzamiento.MM.d_v(pos(101:end)),'.g','Markersize',10)
    plot(Forzamiento.OD.Hs(pos(51:100)),Forzamiento.MM.d_v(pos(51:100)),'.y','Markersize',15)
    plot(Forzamiento.OD.Hs(pos(26:50)),Forzamiento.MM.d_v(pos(26:50)),'.r','Markersize',20)
    plot(Forzamiento.OD.Hs(pos(1:25)),Forzamiento.MM.d_v(pos(1:25)),'.k','Markersize',25)
    xlim([min(Forzamiento.OD.Hs(pos)) max(Forzamiento.OD.Hs(pos))])
    ylim([min(Forzamiento.MM.d_v(pos)) max(Forzamiento.MM.d_v(pos))])
    set(gca, 'fontsize', 16)
    ylabel('Dmd (º)','Fontweight','bold','Fontsize',16)
    xlabel ('Hs (m)','Fontweight','bold','Fontsize',16)  
end

if (isfield(Forzamiento,'OD') && isfield(Forzamiento,'MA'))
    s(5) = subplot(4, 6 ,5);
    plot(Forzamiento.OD.Hs,Forzamiento.MA.ma,'.','color',[0.8 0.8 0.8],'markersize',2)
    hold on
    plot(Forzamiento.OD.Hs(pos(101:end)),Forzamiento.MA.ma(pos(101:end)),'.g','Markersize',10)
    plot(Forzamiento.OD.Hs(pos(51:100)),Forzamiento.MA.ma(pos(51:100)),'.y','Markersize',15)
    plot(Forzamiento.OD.Hs(pos(26:50)),Forzamiento.MA.ma(pos(26:50)),'.r','Markersize',20)
    plot(Forzamiento.OD.Hs(pos(1:25)),Forzamiento.MA.ma(pos(1:25)),'.k','Markersize',25)
    xlim([min(Forzamiento.OD.Hs(pos)) max(Forzamiento.OD.Hs(pos))])
    ylim([min(Forzamiento.MA.ma(pos)) max(Forzamiento.MA.ma(pos))])
    set(gca, 'fontsize', 16)
    ylabel('M. Astro (m)','Fontweight','bold','Fontsize',16)
    xlabel ('Hs (m)','Fontweight','bold','Fontsize',16)  
end

if (isfield(Forzamiento,'OD') && isfield(Forzamiento,'Q'))
    s(6) = subplot(4, 6 ,6);
    plot(Forzamiento.OD.Hs,Forzamiento.Q.q,'.','color',[0.8 0.8 0.8],'markersize',2)
    hold on
    plot(Forzamiento.OD.Hs(pos(101:end)),Forzamiento.Q.q(pos(101:end)),'.g','Markersize',10)
    plot(Forzamiento.OD.Hs(pos(51:100)),Forzamiento.Q.q(pos(51:100)),'.y','Markersize',15)
    plot(Forzamiento.OD.Hs(pos(26:50)),Forzamiento.Q.q(pos(26:50)),'.r','Markersize',20)
    plot(Forzamiento.OD.Hs(pos(1:25)),Forzamiento.Q.q(pos(1:25)),'.k','Markersize',25)
    xlim([min(Forzamiento.OD.Hs(pos)) max(Forzamiento.OD.Hs(pos))])
    ylim([min(Forzamiento.Q.q(pos)) max(Forzamiento.Q.q(pos))])
    set(gca, 'fontsize', 16)
    ylabel('Q (m3/s)','Fontweight','bold','Fontsize',16)
    xlabel ('Hs (m)','Fontweight','bold','Fontsize',16)  
end
%%%%
if isfield(Forzamiento,'OD')
    s(7) = subplot(4, 6 ,7);
    plot(Forzamiento.OD.Tp,Forzamiento.OD.Do,'.','color',[0.8 0.8 0.8],'markersize',2)
    hold on
    plot(Forzamiento.OD.Tp(pos(101:end)),Forzamiento.OD.Do(pos(101:end)),'.g','Markersize',10)
    plot(Forzamiento.OD.Tp(pos(51:100)),Forzamiento.OD.Do(pos(51:100)),'.y','Markersize',15)
    plot(Forzamiento.OD.Tp(pos(26:50)),Forzamiento.OD.Do(pos(26:50)),'.r','Markersize',20)
    plot(Forzamiento.OD.Tp(pos(1:25)),Forzamiento.OD.Do(pos(1:25)),'.k','Markersize',25)
    xlim([min(Forzamiento.OD.Tp(pos)) max(Forzamiento.OD.Tp(pos))])
    ylim([min(Forzamiento.OD.Do(pos)) max(Forzamiento.OD.Do(pos))])
    set(gca, 'fontsize', 16)
    ylabel('Dmd (º)','Fontweight','bold','Fontsize',16)
    xlabel ('Tp (s)','Fontweight','bold','Fontsize',16)  
end

if (isfield(Forzamiento,'OD') && isfield(Forzamiento,'MM'))
    s(8) = subplot(4, 6 ,8);
    plot(Forzamiento.OD.Tp,Forzamiento.MM.vv,'.','color',[0.8 0.8 0.8],'markersize',2)
    hold on
    plot(Forzamiento.OD.Tp(pos(101:end)),Forzamiento.MM.vv(pos(101:end)),'.g','Markersize',10)
    plot(Forzamiento.OD.Tp(pos(51:100)),Forzamiento.MM.vv(pos(51:100)),'.y','Markersize',15)
    plot(Forzamiento.OD.Tp(pos(26:50)),Forzamiento.MM.vv(pos(26:50)),'.r','Markersize',20)
    plot(Forzamiento.OD.Tp(pos(1:25)),Forzamiento.MM.vv(pos(1:25)),'.k','Markersize',25)
    xlim([min(Forzamiento.OD.Tp(pos)) max(Forzamiento.OD.Tp(pos))])
    ylim([min(Forzamiento.MM.vv(pos)) max(Forzamiento.MM.vv(pos))])
    set(gca, 'fontsize', 16)
    ylabel('Vv (m/s)','Fontweight','bold','Fontsize',16)
    xlabel ('Tp (s)','Fontweight','bold','Fontsize',16)  
end

if (isfield(Forzamiento,'OD') && isfield(Forzamiento,'MM'))
    s(9) = subplot(4, 6 ,9);
    plot(Forzamiento.OD.Tp,Forzamiento.MM.vv,'.','color',[0.8 0.8 0.8],'markersize',2)
    hold on
    plot(Forzamiento.OD.Tp(pos(101:end)),Forzamiento.MM.d_v(pos(101:end)),'.g','Markersize',10)
    plot(Forzamiento.OD.Tp(pos(51:100)),Forzamiento.MM.d_v(pos(51:100)),'.y','Markersize',15)
    plot(Forzamiento.OD.Tp(pos(26:50)),Forzamiento.MM.d_v(pos(26:50)),'.r','Markersize',20)
    plot(Forzamiento.OD.Tp(pos(1:25)),Forzamiento.MM.d_v(pos(1:25)),'.k','Markersize',25)
    xlim([min(Forzamiento.OD.Tp(pos)) max(Forzamiento.OD.Tp(pos))])
    ylim([min(Forzamiento.MM.d_v(pos)) max(Forzamiento.MM.d_v(pos))])
    set(gca, 'fontsize', 16)
    ylabel('Dmd (º)','Fontweight','bold','Fontsize',16)
    xlabel ('Tp (s)','Fontweight','bold','Fontsize',16)  
end

if (isfield(Forzamiento,'OD') && isfield(Forzamiento,'MA'))
    s(10) = subplot(4, 6 ,10);
    plot(Forzamiento.OD.Tp,Forzamiento.MA.ma,'.','color',[0.8 0.8 0.8],'markersize',2)
    hold on
    plot(Forzamiento.OD.Tp(pos(101:end)),Forzamiento.MA.ma(pos(101:end)),'.g','Markersize',10)
    plot(Forzamiento.OD.Tp(pos(51:100)),Forzamiento.MA.ma(pos(51:100)),'.y','Markersize',15)
    plot(Forzamiento.OD.Tp(pos(26:50)),Forzamiento.MA.ma(pos(26:50)),'.r','Markersize',20)
    plot(Forzamiento.OD.Tp(pos(1:25)),Forzamiento.MA.ma(pos(1:25)),'.k','Markersize',25)
    xlim([min(Forzamiento.OD.Tp(pos)) max(Forzamiento.OD.Tp(pos))])
    ylim([min(Forzamiento.MA.ma(pos)) max(Forzamiento.MA.ma(pos))])
    set(gca, 'fontsize', 16)
    ylabel('M. Astro (m)','Fontweight','bold','Fontsize',16)
    xlabel ('Tp (s)','Fontweight','bold','Fontsize',16)  
end

if (isfield(Forzamiento,'OD') && isfield(Forzamiento,'Q'))
    s(11) = subplot(4, 6 ,11);
    plot(Forzamiento.OD.Tp,Forzamiento.Q.q,'.','color',[0.8 0.8 0.8],'markersize',2)
    hold on
    plot(Forzamiento.OD.Tp(pos(101:end)),Forzamiento.Q.q(pos(101:end)),'.g','Markersize',10)
    plot(Forzamiento.OD.Tp(pos(51:100)),Forzamiento.Q.q(pos(51:100)),'.y','Markersize',15)
    plot(Forzamiento.OD.Tp(pos(26:50)),Forzamiento.Q.q(pos(26:50)),'.r','Markersize',20)
    plot(Forzamiento.OD.Tp(pos(1:25)),Forzamiento.Q.q(pos(1:25)),'.k','Markersize',25)
    xlim([min(Forzamiento.OD.Tp(pos)) max(Forzamiento.OD.Tp(pos))])
    ylim([min(Forzamiento.Q.q(pos)) max(Forzamiento.Q.q(pos))])
    set(gca, 'fontsize', 16)
    ylabel('Q (m3/s)','Fontweight','bold','Fontsize',16)
    xlabel ('Tp (s)','Fontweight','bold','Fontsize',16)  
end
%%%%%
if (isfield(Forzamiento,'OD') && isfield(Forzamiento,'MM'))
    s(12) = subplot(4, 6 ,12);
    plot(Forzamiento.OD.Do,Forzamiento.MM.vv,'.','color',[0.8 0.8 0.8],'markersize',2)
    hold on
    plot(Forzamiento.OD.Do(pos(101:end)),Forzamiento.MM.vv(pos(101:end)),'.g','Markersize',10)
    plot(Forzamiento.OD.Do(pos(51:100)),Forzamiento.MM.vv(pos(51:100)),'.y','Markersize',15)
    plot(Forzamiento.OD.Do(pos(26:50)),Forzamiento.MM.vv(pos(26:50)),'.r','Markersize',20)
    plot(Forzamiento.OD.Do(pos(1:25)),Forzamiento.MM.vv(pos(1:25)),'.k','Markersize',25)
    xlim([min(Forzamiento.OD.Do(pos)) max(Forzamiento.OD.Do(pos))])
    ylim([min(Forzamiento.MM.vv(pos)) max(Forzamiento.MM.vv(pos))])
    set(gca, 'fontsize', 16)
    ylabel('Vv (m/s)','Fontweight','bold','Fontsize',16)
    xlabel ('Dmd (º)','Fontweight','bold','Fontsize',16)  
end

if (isfield(Forzamiento,'OD') && isfield(Forzamiento,'MM'))
    s(13) = subplot(4, 6 ,13);
    plot(Forzamiento.OD.Do,Forzamiento.MM.vv,'.','color',[0.8 0.8 0.8],'markersize',2)
    hold on
    plot(Forzamiento.OD.Do(pos(101:end)),Forzamiento.MM.d_v(pos(101:end)),'.g','Markersize',10)
    plot(Forzamiento.OD.Do(pos(51:100)),Forzamiento.MM.d_v(pos(51:100)),'.y','Markersize',15)
    plot(Forzamiento.OD.Do(pos(26:50)),Forzamiento.MM.d_v(pos(26:50)),'.r','Markersize',20)
    plot(Forzamiento.OD.Do(pos(1:25)),Forzamiento.MM.d_v(pos(1:25)),'.k','Markersize',25)
    xlim([min(Forzamiento.OD.Do(pos)) max(Forzamiento.OD.Do(pos))])
    ylim([min(Forzamiento.MM.d_v(pos)) max(Forzamiento.MM.d_v(pos))])
    set(gca, 'fontsize', 16)
    ylabel('Dmd (º)','Fontweight','bold','Fontsize',16)
    xlabel ('Dmd (º)','Fontweight','bold','Fontsize',16)  
end

if (isfield(Forzamiento,'OD') && isfield(Forzamiento,'MA'))
    s(14) = subplot(4, 6 ,14);
    plot(Forzamiento.OD.Do,Forzamiento.MA.ma,'.','color',[0.8 0.8 0.8],'markersize',2)
    hold on
    plot(Forzamiento.OD.Do(pos(101:end)),Forzamiento.MA.ma(pos(101:end)),'.g','Markersize',10)
    plot(Forzamiento.OD.Do(pos(51:100)),Forzamiento.MA.ma(pos(51:100)),'.y','Markersize',15)
    plot(Forzamiento.OD.Do(pos(26:50)),Forzamiento.MA.ma(pos(26:50)),'.r','Markersize',20)
    plot(Forzamiento.OD.Do(pos(1:25)),Forzamiento.MA.ma(pos(1:25)),'.k','Markersize',25)
    xlim([min(Forzamiento.OD.Do(pos)) max(Forzamiento.OD.Do(pos))])
    ylim([min(Forzamiento.MA.ma(pos)) max(Forzamiento.MA.ma(pos))])
    set(gca, 'fontsize', 16)
    ylabel('M. Astro (m)','Fontweight','bold','Fontsize',16)
    xlabel ('Dmd (º)','Fontweight','bold','Fontsize',16)  
end

if (isfield(Forzamiento,'OD') && isfield(Forzamiento,'Q'))
    s(15) = subplot(4, 6 ,15);
    plot(Forzamiento.OD.Do,Forzamiento.Q.q,'.','color',[0.8 0.8 0.8],'markersize',2)
    hold on
    plot(Forzamiento.OD.Do(pos(101:end)),Forzamiento.Q.q(pos(101:end)),'.g','Markersize',10)
    plot(Forzamiento.OD.Do(pos(51:100)),Forzamiento.Q.q(pos(51:100)),'.y','Markersize',15)
    plot(Forzamiento.OD.Do(pos(26:50)),Forzamiento.Q.q(pos(26:50)),'.r','Markersize',20)
    plot(Forzamiento.OD.Do(pos(1:25)),Forzamiento.Q.q(pos(1:25)),'.k','Markersize',25)
    xlim([min(Forzamiento.OD.Do(pos)) max(Forzamiento.OD.Do(pos))])
    ylim([min(Forzamiento.Q.q(pos)) max(Forzamiento.Q.q(pos))])
    set(gca, 'fontsize', 16)
    ylabel('Q (m3/s)','Fontweight','bold','Fontsize',16)
    xlabel ('Dmd (º)','Fontweight','bold','Fontsize',16)  
end

%%%%% %%%%
if (isfield(Forzamiento,'MM'))
    s(16) = subplot(4, 6 ,16);
    plot(Forzamiento.MM.vv,Forzamiento.MM.d_v,'.','color',[0.8 0.8 0.8],'markersize',2)
    hold on
    plot(Forzamiento.MM.vv(pos(101:end)),Forzamiento.MM.d_v(pos(101:end)),'.g','Markersize',10)
    plot(Forzamiento.MM.vv(pos(51:100)),Forzamiento.MM.d_v(pos(51:100)),'.y','Markersize',15)
    plot(Forzamiento.MM.vv(pos(26:50)),Forzamiento.MM.d_v(pos(26:50)),'.r','Markersize',20)
    plot(Forzamiento.MM.vv(pos(1:25)),Forzamiento.MM.d_v(pos(1:25)),'.k','Markersize',25)
    xlim([min(Forzamiento.MM.vv(pos)) max(Forzamiento.MM.vv(pos))])
    ylim([min(Forzamiento.MM.d_v(pos)) max(Forzamiento.MM.d_v(pos))])
    set(gca, 'fontsize', 16)
    xlabel('Vv (m/s)','Fontweight','bold','Fontsize',16)
    ylabel ('Dmd (º)','Fontweight','bold','Fontsize',16)  
end

if (isfield(Forzamiento,'MM') && isfield(Forzamiento,'MA'))
    s(17) = subplot(4, 6 ,17);
    plot(Forzamiento.MM.vv,Forzamiento.MA.ma,'.','color',[0.8 0.8 0.8],'markersize',2)
    hold on
    plot(Forzamiento.MM.vv(pos(101:end)),Forzamiento.MA.ma(pos(101:end)),'.g','Markersize',10)
    plot(Forzamiento.MM.vv(pos(51:100)),Forzamiento.MA.ma(pos(51:100)),'.y','Markersize',15)
    plot(Forzamiento.MM.vv(pos(26:50)),Forzamiento.MA.ma(pos(26:50)),'.r','Markersize',20)
    plot(Forzamiento.MM.vv(pos(1:25)),Forzamiento.MA.ma(pos(1:25)),'.k','Markersize',25)
    xlim([min(Forzamiento.MM.vv(pos)) max(Forzamiento.MM.vv(pos))])
    ylim([min(Forzamiento.MA.ma(pos)) max(Forzamiento.MA.ma(pos))])
    set(gca, 'fontsize', 16)
    ylabel('M. Astro (m)','Fontweight','bold','Fontsize',16)
    xlabel ('Vv (m/s)','Fontweight','bold','Fontsize',16)  
end

if (isfield(Forzamiento,'MM') && isfield(Forzamiento,'Q'))
    s(18) = subplot(4, 6 ,18);
    plot(Forzamiento.MM.vv,Forzamiento.Q.q,'.','color',[0.8 0.8 0.8],'markersize',2)
    hold on
    plot(Forzamiento.MM.vv(pos(101:end)),Forzamiento.Q.q(pos(101:end)),'.g','Markersize',10)
    plot(Forzamiento.MM.vv(pos(51:100)),Forzamiento.Q.q(pos(51:100)),'.y','Markersize',15)
    plot(Forzamiento.MM.vv(pos(26:50)),Forzamiento.Q.q(pos(26:50)),'.r','Markersize',20)
    plot(Forzamiento.MM.vv(pos(1:25)),Forzamiento.Q.q(pos(1:25)),'.k','Markersize',25)
    xlim([min(Forzamiento.MM.vv(pos)) max(Forzamiento.MM.vv(pos))])
    ylim([min(Forzamiento.Q.q(pos)) max(Forzamiento.Q.q(pos))])
    set(gca, 'fontsize', 16)
    ylabel('Q (m3/s)','Fontweight','bold','Fontsize',16)
    xlabel ('Vv (m/s)','Fontweight','bold','Fontsize',16)  
end

if (isfield(Forzamiento,'MM') && isfield(Forzamiento,'MA'))
    s(19) = subplot(4, 6 ,19);
    plot(Forzamiento.MM.d_v,Forzamiento.MA.ma,'.','color',[0.8 0.8 0.8],'markersize',2)
    hold on
    plot(Forzamiento.MM.d_v(pos(101:end)),Forzamiento.MA.ma(pos(101:end)),'.g','Markersize',10)
    plot(Forzamiento.MM.d_v(pos(51:100)),Forzamiento.MA.ma(pos(51:100)),'.y','Markersize',15)
    plot(Forzamiento.MM.d_v(pos(26:50)),Forzamiento.MA.ma(pos(26:50)),'.r','Markersize',20)
    plot(Forzamiento.MM.d_v(pos(1:25)),Forzamiento.MA.ma(pos(1:25)),'.k','Markersize',25)
    xlim([min(Forzamiento.MM.d_v(pos)) max(Forzamiento.MM.d_v(pos))])
    ylim([min(Forzamiento.MA.ma(pos)) max(Forzamiento.MA.ma(pos))])
    set(gca, 'fontsize', 16)
    ylabel('M. Astro (m)','Fontweight','bold','Fontsize',16)
    xlabel ('Dmd (º)','Fontweight','bold','Fontsize',16)  
end

if (isfield(Forzamiento,'MM') && isfield(Forzamiento,'Q'))
    s(20) = subplot(4, 6 ,20);
    plot(Forzamiento.MM.d_v,Forzamiento.Q.q,'.','color',[0.8 0.8 0.8],'markersize',2)
    hold on
    plot(Forzamiento.MM.d_v(pos(101:end)),Forzamiento.Q.q(pos(101:end)),'.g','Markersize',10)
    plot(Forzamiento.MM.d_v(pos(51:100)),Forzamiento.Q.q(pos(51:100)),'.y','Markersize',15)
    plot(Forzamiento.MM.d_v(pos(26:50)),Forzamiento.Q.q(pos(26:50)),'.r','Markersize',20)
    plot(Forzamiento.MM.d_v(pos(1:25)),Forzamiento.Q.q(pos(1:25)),'.k','Markersize',25)
    xlim([min(Forzamiento.MM.d_v(pos)) max(Forzamiento.MM.d_v(pos))])
    ylim([min(Forzamiento.Q.q(pos)) max(Forzamiento.Q.q(pos))])
    set(gca, 'fontsize', 16)
    ylabel('Q (m3/s)','Fontweight','bold','Fontsize',16)
    xlabel ('Dmd (º)','Fontweight','bold','Fontsize',16)  
end

if (isfield(Forzamiento,'MM') && isfield(Forzamiento,'Q'))
    s(21) = subplot(4, 6 ,21);
    plot(Forzamiento.MA.ma,Forzamiento.Q.q,'.','color',[0.8 0.8 0.8],'markersize',2)
    hold on
    plot(Forzamiento.MA.ma(pos(101:end)),Forzamiento.Q.q(pos(101:end)),'.g','Markersize',10)
    plot(Forzamiento.MA.ma(pos(51:100)),Forzamiento.Q.q(pos(51:100)),'.y','Markersize',15)
    plot(Forzamiento.MA.ma(pos(26:50)),Forzamiento.Q.q(pos(26:50)),'.r','Markersize',20)
    plot(Forzamiento.MA.ma(pos(1:25)),Forzamiento.Q.q(pos(1:25)),'.k','Markersize',25)
    xlim([min(Forzamiento.MA.ma(pos)) max(Forzamiento.MA.ma(pos))])
    ylim([min(Forzamiento.Q.q(pos)) max(Forzamiento.Q.q(pos))])
    set(gca, 'fontsize', 16)
    ylabel('Q (m3/s)','Fontweight','bold','Fontsize',16)
    xlabel ('M. Astro (m)','Fontweight','bold','Fontsize',16)  
end


%%%%% %%%%


if isfield(Forzamiento,'OD')
    s(3) = subplot(4, 6 ,3);
    plot(Forzamiento.OD.Tp,Forzamiento.OD.Do,'.','color',[0.8 0.8 0.8],'markersize',2)
    hold on
    plot(Forzamiento.OD.Tp(pos(101:end)),Forzamiento.OD.Do(pos(101:end)),'.g','Markersize',10)
    plot(Forzamiento.OD.Tp(pos(51:100)),Forzamiento.OD.Do(pos(51:100)),'.y','Markersize',15)
    plot(Forzamiento.OD.Tp(pos(26:50)),Forzamiento.OD.Do(pos(26:50)),'.r','Markersize',20)
    plot(Forzamiento.OD.Tp(pos(1:25)),Forzamiento.OD.Do(pos(1:25)),'.k','Markersize',25)
    xlim([min(Forzamiento.OD.Tp(pos)) max(Forzamiento.OD.Tp(pos))])
    ylim([min(Forzamiento.OD.Do(pos)) max(Forzamiento.OD.Do(pos))])
    set(gca, 'fontsize', 16)
    ylabel('Dmd (º)','Fontweight','bold','Fontsize',16)
    xlabel ('Tp (s)','Fontweight','bold','Fontsize',16)  
end



%%
%Primera comprobación ¿Existe O como forzamiento?
comp_O=isfield(Forzamiento,'O');
comp_OD=isfield(Forzamiento,'OD');
comp_ODSV=isfield(Forzamiento,'ODSV');
comp_MM=isfield(Forzamiento,'MM');

if comp_O==0 && comp_MM==0 && comp_OD==0 && comp_ODSV==0  % Caso 1 no hay ni olejae ni m.meteo
    
%Obtengo los forzamientos que se han elegido
l=length(X);
    
    % Caso 1, opción 1: Sólo tengo un forzamiento
    if length(X(1,:))==1
        % Extraigo el valor del forzamiento
%         forz=Forzamiento.(names{1});
%         var=fieldnames(Forzamiento.(names{1}));
%         forz=Forzamiento.(names{1}).(var{1})
        
        figure1 = figure('PaperSize',[20.98 29.68],'Color',[1 1 1],'Position',[1,1,1000,1000],'Visible','on');
        plot(X,X,'.k','Markersize',15)
        hold on
        for j=1:length(pos)
            plot(X(pos(j)),X(pos(j)),'.m','Markersize',30)
            text(X(pos(j)),X(pos(j)),num2str(j),'FontSize',14,'Color','black')
        end
        names=fieldnames(Forzamiento);
        xlabel(names(1),'Fontweight','bold','Fontsize',16)
        ylabel(names(1),'Fontweight','bold','Fontsize',16)
        grid on
        
    else
        
        figure1 = figure('PaperSize',[20.98 29.68],'Color',[1 1 1],'Position',[1,1,1000,1000],'Visible','on');
        plot(X(:,2),X(:,1),'.k','Markersize',15)
        hold on
        for j=1:length(pos)
            plot(X(pos(j),2),X(pos(j),1),'.m','Markersize',30)
            text(X(pos(j),2),X(pos(j),1),num2str(j),'FontSize',14,'Color','black')
        end
        names=fieldnames(Forzamiento);
        xlabel(names(2),'Fontweight','bold','Fontsize',16)
        ylabel(names(1),'Fontweight','bold','Fontsize',16)
        grid on
        
    end
end

%% Si hay oleje representamos las tres variables del O 
if isfield(Forzamiento,'O') 
    
    figure1 = figure('PaperSize',[20.98 29.68],'Color',[1 1 1],'Position',[1,1,2000,1000],'Visible','on');
    s3(1)=subplot(3,1,1);
    plot(Forzamiento_norm.O.t_horario,Forzamiento_norm.O.h_norm,'b','Linewidth',1)
    hold on
    plot(Forzamiento_norm.O.t_horario(pos),Forzamiento_norm.O.h_norm(pos),'.y','Markersize',30)
    ylabel('Hs_norm','Fontweight','bold','Fontsize',16)
    grid on
    datetick('x',12)
    
    s3(2)=subplot(3,1,2);
    plot(Forzamiento_norm.O.t_horario,Forzamiento_norm.O.tp_norm,'r','Linewidth',1)
    hold on
    plot(Forzamiento_norm.O.t_horario(pos),Forzamiento_norm.O.tp_norm(pos),'.y','Markersize',30)
    ylabel('Tp_norm','Fontweight','bold','Fontsize',16)
    grid on
    datetick('x',12)
    
    s3(3)=subplot(3,1,3);
    plot(Forzamiento_norm.O.t_horario,Forzamiento_norm.O.d_o_rad_norm,'.k','Linewidth',1)
    hold on
    plot(Forzamiento_norm.O.t_horario(pos),Forzamiento_norm.O.d_o_rad_norm(pos),'.y','Markersize',30)
    ylabel('Dmd_norm','Fontweight','bold','Fontsize',16)
    grid on
    datetick('x',12)
    
    linkaxes([s3],'x')



    figure1 = figure('PaperSize',[20.98 29.68],'Color',[1 1 1],'Position',[1,1,2000,1000],'Visible','on');
    s4(1)=subplot(3,1,1);
    plot(Forzamiento.O.t_horario,Forzamiento.O.h,'b','Linewidth',2)
    hold on
    plot(Forzamiento.O.t_horario(pos),Forzamiento.O.h(pos),'.y','Markersize',30)
    ylabel('Hs norm','Fontweight','bold','Fontsize',16)
    grid on
    datetick('x',12)
    
    s4(2)=subplot(3,1,2);
    plot(Forzamiento.O.t_horario,Forzamiento.O.tp,'r','Linewidth',2)
    hold on
    plot(Forzamiento.O.t_horario(pos),Forzamiento.O.tp(pos),'.y','Markersize',30)
    ylabel('Tp norm','Fontweight','bold','Fontsize',16)
    grid on
    datetick('x',12)
    
    s4(3)=subplot(3,1,3);
    plot(Forzamiento.O.t_horario,Forzamiento.O.d_o,'.k','Linewidth',2)
    hold on
    plot(Forzamiento.O.t_horario(pos),Forzamiento.O.d_o(pos),'.y','Markersize',30)
    ylabel('Dmd norm','Fontweight','bold','Fontsize',16)
    grid on
    datetick('x',12)
    linkaxes([s4],'x')




    figure1 = figure('PaperSize',[20.98 29.68],'Color',[1 1 1],'Position',[1,1,2000,1000],'Visible','on');
    plot3(Forzamiento_norm.O.h_norm,Forzamiento_norm.O.tp_norm,Forzamiento_norm.O.d_o_rad_norm,'k.')
    hold on

    grid on

    for j=1:M
        plot3(Forzamiento_norm.O.h_norm(pos(j)),Forzamiento_norm.O.tp_norm(pos(j)),Forzamiento_norm.O.d_o_rad_norm(pos(j)),'y.','Markersize',30)        
        text(Forzamiento_norm.O.h_norm(pos(j)),Forzamiento_norm.O.tp_norm(pos(j)),Forzamiento_norm.O.d_o_rad_norm(pos(j)),num2str(j),'Color','magenta','Fontweight','bold','Fontsize',12)            
        xlabel('Hs norm','Fontweight','bold','Fontsize',16)
        ylabel('Tp norm','Fontweight','bold','Fontsize',16)
        zlabel('Dmd norm','Fontweight','bold','Fontsize',16)

        %pause
    end

    figure1 = figure('PaperSize',[20.98 29.68],'Color',[1 1 1],'Position',[1,1,2000,1000],'Visible','on');
    s5(1)=subplot(3,3,1);
    plot(Forzamiento.O.h,Forzamiento.O.tp,'.k')
    hold on
    plot(Forzamiento.O.h(pos),Forzamiento.O.tp(pos),'.y','Markersize',30)
    for j=1:M
       text(Forzamiento.O.h(pos(j)),Forzamiento.O.tp(pos(j)),num2str(j),'Color','magenta','Fontweight','bold','Fontsize',12) 
    end
    xlabel('Hs','Fontweight','bold','Fontsize',16)
    ylabel('Tp','Fontweight','bold','Fontsize',16)
    grid on

    s5(2)=subplot(3,3,2);
    plot(Forzamiento.O.h,Forzamiento.O.d_o,'.k')
    hold on
    plot(Forzamiento.O.h(pos),Forzamiento.O.d_o(pos),'.y','Markersize',30)
    for j=1:M
       text(Forzamiento.O.h(pos(j)),Forzamiento.O.d_o(pos(j)),num2str(j),'Color','magenta','Fontweight','bold','Fontsize',12) 
    end
    xlabel('Hs','Fontweight','bold','Fontsize',16)
    ylabel('Dmd','Fontweight','bold','Fontsize',16)
    grid on

    s5(3)=subplot(3,3,3);
    plot(Forzamiento.O.tp,Forzamiento.O.d_o,'.k')
    hold on
    plot(Forzamiento.O.tp(pos),Forzamiento.O.d_o(pos),'.y','Markersize',30)
    for j=1:M
       text(Forzamiento.O.tp(pos(j)),Forzamiento.O.d_o(pos(j)),num2str(j),'Color','magenta','Fontweight','bold','Fontsize',12) 
    end
    xlabel('Tp','Fontweight','bold','Fontsize',16)
    ylabel('Dmd','Fontweight','bold','Fontsize',16)
    grid on

end



%% Si hay oleje en la desembocadura representamos las tres variables del OD 
if isfield(Forzamiento,'OD')
    
    figure1 = figure('PaperSize',[20.98 29.68],'Color',[1 1 1],'Position',[1,1,2000,1000],'Visible','on');
    s(1)=subplot(3,1,1);
    plot(Forzamiento_norm.OD.t_horario,Forzamiento_norm.OD.Hs_norm,'b','Linewidth',2)
    hold on
    plot(Forzamiento_norm.OD.t_horario(pos),Forzamiento_norm.OD.Hs_norm(pos),'.y','Markersize',30)
    ylabel('Hs_norm','Fontweight','bold','Fontsize',16)
    grid on
    datetick('x',12)
    
    s(2)=subplot(3,1,2);
    plot(Forzamiento_norm.OD.t_horario,Forzamiento_norm.OD.Tp_norm,'r','Linewidth',2)
    hold on
    plot(Forzamiento_norm.OD.t_horario(pos),Forzamiento_norm.OD.Tp_norm(pos),'.y','Markersize',30)
    ylabel('Tp_norm','Fontweight','bold','Fontsize',16)
    grid on
    datetick('x',12)
    
    s(3)=subplot(3,1,3);
    plot(Forzamiento_norm.OD.t_horario,Forzamiento_norm.OD.Do_rad_norm,'.k','Linewidth',2)
    hold on
    plot(Forzamiento_norm.OD.t_horario(pos),Forzamiento_norm.OD.Do_rad_norm(pos),'.y','Markersize',30)
    ylabel('Dmd_norm','Fontweight','bold','Fontsize',16)
    grid on
    datetick('x',12)
    
    linkaxes([s],'x')



    figure1 = figure('PaperSize',[20.98 29.68],'Color',[1 1 1],'Position',[1,1,2000,1000],'Visible','on');
    s(1)=subplot(3,1,1);
    plot(Forzamiento.OD.t_horario,Forzamiento.OD.Hs,'b','Linewidth',2)
    hold on
    plot(Forzamiento.OD.t_horario(pos),Forzamiento.OD.Hs(pos),'.y','Markersize',30)
    ylabel('Hs norm','Fontweight','bold','Fontsize',16)
    grid on
    datetick('x',12)
    
    s(2)=subplot(3,1,2);
    plot(Forzamiento.OD.t_horario,Forzamiento.OD.Tp,'r','Linewidth',2)
    hold on
    plot(Forzamiento.OD.t_horario(pos),Forzamiento.OD.Tp(pos),'.y','Markersize',30)
    ylabel('Tp norm','Fontweight','bold','Fontsize',16)
    grid on
    datetick('x',12)
    
    s(3)=subplot(3,1,3);
    plot(Forzamiento.OD.t_horario,Forzamiento.OD.Do,'.k','Linewidth',2)
    hold on
    plot(Forzamiento.OD.t_horario(pos),Forzamiento.OD.Do(pos),'.y','Markersize',30)
    ylabel('Dmd norm','Fontweight','bold','Fontsize',16)
    grid on
    datetick('x',12)
    linkaxes([s],'x')




    figure1 = figure('PaperSize',[20.98 29.68],'Color',[1 1 1],'Position',[1,1,2000,1000],'Visible','on');
    plot3(Forzamiento_norm.OD.Hs_norm,Forzamiento_norm.OD.Tp_norm,Forzamiento_norm.OD.Do_rad_norm,'k.')
    hold on

    grid on

    for j=1:M
        plot3(Forzamiento_norm.OD.Hs_norm(pos(j)),Forzamiento_norm.OD.Tp_norm(pos(j)),Forzamiento_norm.OD.Do_rad_norm(pos(j)),'y.','Markersize',30)
        text(Forzamiento_norm.OD.Hs_norm(pos(j)),Forzamiento_norm.OD.Tp_norm(pos(j)),Forzamiento_norm.OD.Do_rad_norm(pos(j)),num2str(j),'Color','magenta','Fontweight','bold','Fontsize',12)    
        xlabel('Hs norm','Fontweight','bold','Fontsize',16)
        ylabel('Tp norm','Fontweight','bold','Fontsize',16)
        zlabel('Dmd norm','Fontweight','bold','Fontsize',16)

        %pause
    end

    figure1 = figure('PaperSize',[20.98 29.68],'Color',[1 1 1],'Position',[1,1,2000,1000],'Visible','on');
    s2(1)=subplot(3,3,1);
    plot(Forzamiento.OD.Hs,Forzamiento.OD.Tp,'.k')
    hold on
    plot(Forzamiento.OD.Hs(pos),Forzamiento.OD.Tp(pos),'.y','Markersize',30)
    for j=1:M
       text(Forzamiento.OD.Hs(pos(j)),Forzamiento.OD.Tp(pos(j)),num2str(j),'Color','magenta','Fontweight','bold','Fontsize',12) 
    end
    xlabel('Hs','Fontweight','bold','Fontsize',16)
    ylabel('Tp','Fontweight','bold','Fontsize',16)
    grid on

    s2(2)=subplot(3,3,2);
    plot(Forzamiento.OD.Hs,Forzamiento.OD.Do,'.k')
    hold on
    plot(Forzamiento.OD.Hs(pos),Forzamiento.OD.Do(pos),'.y','Markersize',30)
    for j=1:M
       text(Forzamiento.OD.Hs(pos(j)),Forzamiento.OD.Do(pos(j)),num2str(j),'Color','magenta','Fontweight','bold','Fontsize',12) 
    end
    xlabel('Hs','Fontweight','bold','Fontsize',16)
    ylabel('Dmd','Fontweight','bold','Fontsize',16)
    grid on

    s2(3)=subplot(3,3,3);
    plot(Forzamiento.OD.Tp,Forzamiento.OD.Do,'.k')
    hold on
    plot(Forzamiento.OD.Tp(pos),Forzamiento.OD.Do(pos),'.y','Markersize',30)
    for j=1:M
       text(Forzamiento.OD.Tp(pos(j)),Forzamiento.OD.Do(pos(j)),num2str(j),'Color','magenta','Fontweight','bold','Fontsize',12) 
    end
    xlabel('Tp','Fontweight','bold','Fontsize',16)
    ylabel('Dmd','Fontweight','bold','Fontsize',16)
    grid on

end

%% Si hay oleje en la desembocadura sin viento representamos las tres variables del ODSV 
if isfield(Forzamiento,'ODSV')
    
    figure1 = figure('PaperSize',[20.98 29.68],'Color',[1 1 1],'Position',[1,1,2000,1000],'Visible','on');
    s(1)=subplot(3,1,1);
    plot(Forzamiento_norm.ODSV.t_horario,Forzamiento_norm.ODSV.Hs_norm,'b','Linewidth',2)
    hold on
    plot(Forzamiento_norm.ODSV.t_horario(pos),Forzamiento_norm.ODSV.Hs_norm(pos),'.y','Markersize',30)
    ylabel('Hs_norm','Fontweight','bold','Fontsize',16)
    grid on
    datetick('x',12)
    
    s(2)=subplot(3,1,2);
    plot(Forzamiento_norm.ODSV.t_horario,Forzamiento_norm.ODSV.Tp_norm,'r','Linewidth',2)
    hold on
    plot(Forzamiento_norm.ODSV.t_horario(pos),Forzamiento_norm.ODSV.Tp_norm(pos),'.y','Markersize',30)
    ylabel('Tp_norm','Fontweight','bold','Fontsize',16)
    grid on
    datetick('x',12)
    
    s(3)=subplot(3,1,3);
    plot(Forzamiento_norm.ODSV.t_horario,Forzamiento_norm.ODSV.Do_rad_norm,'.k','Linewidth',2)
    hold on
    plot(Forzamiento_norm.ODSV.t_horario(pos),Forzamiento_norm.ODSV.Do_rad_norm(pos),'.y','Markersize',30)
    ylabel('Dmd_norm','Fontweight','bold','Fontsize',16)
    grid on
    datetick('x',12)
    
    linkaxes([s],'x')



    figure1 = figure('PaperSize',[20.98 29.68],'Color',[1 1 1],'Position',[1,1,2000,1000],'Visible','on');
    s(1)=subplot(3,1,1);
    plot(Forzamiento.ODSV.t_horario,Forzamiento.ODSV.Hs,'b','Linewidth',2)
    hold on
    plot(Forzamiento.ODSV.t_horario(pos),Forzamiento.ODSV.Hs(pos),'.y','Markersize',30)
    ylabel('Hs norm','Fontweight','bold','Fontsize',16)
    grid on
    datetick('x',12)
    
    s(2)=subplot(3,1,2);
    plot(Forzamiento.ODSV.t_horario,Forzamiento.ODSV.Tp,'r','Linewidth',2)
    hold on
    plot(Forzamiento.ODSV.t_horario(pos),Forzamiento.ODSV.Tp(pos),'.y','Markersize',30)
    ylabel('Tp norm','Fontweight','bold','Fontsize',16)
    grid on
    datetick('x',12)
    
    s(3)=subplot(3,1,3);
    plot(Forzamiento.ODSV.t_horario,Forzamiento.ODSV.Do,'.k','Linewidth',2)
    hold on
    plot(Forzamiento.ODSV.t_horario(pos),Forzamiento.ODSV.Do(pos),'.y','Markersize',30)
    ylabel('Dmd norm','Fontweight','bold','Fontsize',16)
    grid on
    datetick('x',12)
    linkaxes([s],'x')




    figure1 = figure('PaperSize',[20.98 29.68],'Color',[1 1 1],'Position',[1,1,2000,1000],'Visible','on');
    plot3(Forzamiento_norm.ODSV.Hs_norm,Forzamiento_norm.ODSV.Tp_norm,Forzamiento_norm.ODSV.Do_rad_norm,'k.')
    hold on

    grid on

    for j=1:M
        plot3(Forzamiento_norm.ODSV.Hs_norm(pos(j)),Forzamiento_norm.ODSV.Tp_norm(pos(j)),Forzamiento_norm.ODSV.Do_rad_norm(pos(j)),'y.','Markersize',30)
        text(Forzamiento_norm.ODSV.Hs_norm(pos(j)),Forzamiento_norm.ODSV.Tp_norm(pos(j)),Forzamiento_norm.ODSV.Do_rad_norm(pos(j)),num2str(j),'Color','magenta','Fontweight','bold','Fontsize',12)    
        xlabel('Hs norm','Fontweight','bold','Fontsize',16)
        ylabel('Tp norm','Fontweight','bold','Fontsize',16)
        zlabel('Dmd norm','Fontweight','bold','Fontsize',16)

        %pause
    end

    figure1 = figure('PaperSize',[20.98 29.68],'Color',[1 1 1],'Position',[1,1,2000,1000],'Visible','on');
    s(1)=subplot(3,3,1);
    plot(Forzamiento.ODSV.Hs,Forzamiento.ODSV.Tp,'.k')
    hold on
    plot(Forzamiento.ODSV.Hs(pos),Forzamiento.ODSV.Tp(pos),'.y','Markersize',30)
    for j=1:M
       text(Forzamiento.ODSV.Hs(pos(j)),Forzamiento.ODSV.Tp(pos(j)),num2str(j),'Color','magenta','Fontweight','bold','Fontsize',12) 
    end
    xlabel('Hs','Fontweight','bold','Fontsize',16)
    ylabel('Tp','Fontweight','bold','Fontsize',16)
    grid on

    s(2)=subplot(3,3,2);
    plot(Forzamiento.ODSV.Hs,Forzamiento.ODSV.Do,'.k')
    hold on
    plot(Forzamiento.ODSV.Hs(pos),Forzamiento.ODSV.Do(pos),'.y','Markersize',30)
    for j=1:M
       text(Forzamiento.ODSV.Hs(pos(j)),Forzamiento.ODSV.Do(pos(j)),num2str(j),'Color','magenta','Fontweight','bold','Fontsize',12) 
    end
    xlabel('Hs','Fontweight','bold','Fontsize',16)
    ylabel('Dmd','Fontweight','bold','Fontsize',16)
    grid on

    s(3)=subplot(3,3,3);
    plot(Forzamiento.ODSV.Tp,Forzamiento.ODSV.Do,'.k')
    hold on
    plot(Forzamiento.ODSV.Tp(pos),Forzamiento.ODSV.Do(pos),'.y','Markersize',30)
    for j=1:M
       text(Forzamiento.ODSV.Tp(pos(j)),Forzamiento.ODSV.Do(pos(j)),num2str(j),'Color','magenta','Fontweight','bold','Fontsize',12) 
    end
    xlabel('Tp','Fontweight','bold','Fontsize',16)
    ylabel('Dmd','Fontweight','bold','Fontsize',16)
    grid on

end

%% Si hay Marea_meteo representamos las dos variables del viento 
if isfield(Forzamiento,'MM')
    
    figure1 = figure('PaperSize',[20.98 29.68],'Color',[1 1 1],'Position',[1,1,2000,1000],'Visible','on');
    s(1)=subplot(3,1,1);
    plot(Forzamiento_norm.MM.t_horario,Forzamiento_norm.MM.vv_norm,'g','Linewidth',2)
    hold on
    plot(Forzamiento_norm.MM.t_horario(pos),Forzamiento_norm.MM.vv_norm(pos),'.y','Markersize',30)
    ylabel('Vv norm','Fontweight','bold','Fontsize',16)
    grid on
    datetick('x',12)
    
    s(2)=subplot(3,1,2);
    plot(Forzamiento_norm.MM.t_horario,Forzamiento_norm.MM.d_v_rad_norm,'k','Linewidth',2)
    hold on
    plot(Forzamiento_norm.MM.t_horario(pos),Forzamiento_norm.MM.d_v_rad_norm(pos),'.y','Markersize',30)
    ylabel('Dv norm','Fontweight','bold','Fontsize',16)
    grid on
    datetick('x',12)
    xlabel('t','Fontweight','bold','Fontsize',16)
   
    linkaxes([s],'x')



    figure1 = figure('PaperSize',[20.98 29.68],'Color',[1 1 1],'Position',[1,1,2000,1000],'Visible','on');
    s(1)=subplot(3,1,1);
    plot(Forzamiento.MM.t_horario,Forzamiento.MM.vv,'g','Linewidth',2)
    hold on
    plot(Forzamiento.MM.t_horario(pos),Forzamiento.MM.vv(pos),'.y','Markersize',30)
    ylabel('Vv','Fontweight','bold','Fontsize',16)
    grid on
    datetick('x',12)
    
    s(2)=subplot(3,1,2);
    plot(Forzamiento.MM.t_horario,Forzamiento.MM.d_v,'k','Linewidth',2)
    hold on
    plot(Forzamiento.MM.t_horario(pos),Forzamiento.MM.d_v(pos),'.y','Markersize',30)
    ylabel('Dmd','Fontweight','bold','Fontsize',16)
    grid on
    datetick('x',12)
    xlabel('t','Fontweight','bold','Fontsize',16)


    figure1 = figure('PaperSize',[20.98 29.68],'Color',[1 1 1],'Position',[1,1,1000,1000],'Visible','on');
    plot(Forzamiento.MM.vv,Forzamiento.MM.d_v,'.k')
    hold on
    plot(Forzamiento.MM.vv(pos),Forzamiento.MM.d_v(pos),'.y','Markersize',30)
    for j=1:M
       text(Forzamiento.MM.vv(pos(j)),Forzamiento.MM.d_v(pos(j)),num2str(j),'Color','magenta','Fontweight','bold','Fontsize',12) 
    end
    xlabel('Vv','Fontweight','bold','Fontsize',16)
    ylabel('Dmd','Fontweight','bold','Fontsize',16)
    grid on
    
    figure1 = figure('PaperSize',[20.98 29.68],'Color',[1 1 1],'Position',[1,1,1000,1000],'Visible','on');
    plot(Forzamiento_norm.MM.vv_norm,Forzamiento_norm.MM.d_v_rad_norm,'.k')
    hold on
    plot(Forzamiento_norm.MM.vv_norm(pos),Forzamiento_norm.MM.d_v_rad_norm(pos),'.y','Markersize',30)
    for j=1:M
       text(Forzamiento_norm.MM.vv_norm(pos(j)),Forzamiento_norm.MM.d_v_rad_norm(pos(j)),num2str(j),'Color','magenta','Fontweight','bold','Fontsize',12) 
    end
    xlabel('Vv','Fontweight','bold','Fontsize',16)
    ylabel('Dmd','Fontweight','bold','Fontsize',16)
    grid on
    
end

%% Si hay O y Marea Meteo represento las cinco variables (VALIDO PARA PROGACION DEL REGIMEN MEDIO)
if comp_O==1 && comp_MM==1 % Caso 1 no hay ni olejae ni m.meteo
    
    figure1 = figure('PaperSize',[20.98 29.68],'Color',[1 1 1],'Position',[1,1,2000,1000],'Visible','on');
    ss1(1)=subplot(5,1,1);
    plot(Forzamiento.O.t_horario,Forzamiento.O.h,'b','Linewidth',2)
    hold on
    plot(Forzamiento.O.t_horario(pos),Forzamiento.O.h(pos),'.y','Markersize',30)
    ylabel('Hs norm','Fontweight','bold','Fontsize',16)
    grid on
    datetick('x',12)
    
    ss1(2)=subplot(5,1,2);
    plot(Forzamiento.O.t_horario,Forzamiento.O.tp,'r','Linewidth',2)
    hold on
    plot(Forzamiento.O.t_horario(pos),Forzamiento.O.tp(pos),'.y','Markersize',30)
    ylabel('Tp norm','Fontweight','bold','Fontsize',16)
    grid on
    datetick('x',12)
    
    ss1(3)=subplot(5,1,3);
    plot(Forzamiento.O.t_horario,Forzamiento.O.d_o,'.k','Linewidth',2)
    hold on
    plot(Forzamiento.O.t_horario(pos),Forzamiento.O.d_o(pos),'.y','Markersize',30)
    ylabel('Dmd norm','Fontweight','bold','Fontsize',16)
    grid on
    datetick('x',12)
    
    ss1(2)=subplot(5,1,4);
    plot(Forzamiento.MM.t_horario,Forzamiento.MM.vv,'g','Linewidth',2)
    hold on
    plot(Forzamiento.MM.t_horario(pos),Forzamiento.MM.vv(pos),'.y','Markersize',30)
    ylabel('Tp norm','Fontweight','bold','Fontsize',16)
    grid on
    datetick('x',12)
    
    ss1(3)=subplot(5,1,5);
    plot(Forzamiento.MM.t_horario,Forzamiento.MM.d_v,'.k','Linewidth',2)
    hold on
    plot(Forzamiento.MM.t_horario(pos),Forzamiento.MM.d_v(pos),'.y','Markersize',30)
    ylabel('Dmd norm','Fontweight','bold','Fontsize',16)
    grid on
    datetick('x',12)
    
    
    linkaxes([ss1],'x')
    
    
    figure1 = figure('PaperSize',[20.98 29.68],'Color',[1 1 1],'Position',[1,1,2000,1000],'Visible','on');
    ss2(1)=subplot(3,3,1);
    plot(Forzamiento.O.h,Forzamiento.O.tp,'.k')
    hold on
    plot(Forzamiento.O.h(pos),Forzamiento.O.tp(pos),'.y','Markersize',30)
    for j=1:M
       text(Forzamiento.O.h(pos(j)),Forzamiento.O.tp(pos(j)),num2str(j),'Color','magenta','Fontweight','bold','Fontsize',12) 
    end
    xlabel('Hs','Fontweight','bold','Fontsize',16)
    ylabel('Tp','Fontweight','bold','Fontsize',16)
    grid on

    ss2(2)=subplot(3,3,2);
    plot(Forzamiento.O.h,Forzamiento.O.d_o,'.k')
    hold on
    plot(Forzamiento.O.h(pos),Forzamiento.O.d_o(pos),'.y','Markersize',30)
    for j=1:M
       text(Forzamiento.O.h(pos(j)),Forzamiento.O.d_o(pos(j)),num2str(j),'Color','magenta','Fontweight','bold','Fontsize',12) 
    end
    xlabel('Hs','Fontweight','bold','Fontsize',16)
    ylabel('Dmd O','Fontweight','bold','Fontsize',16)
    grid on

    ss2(3)=subplot(3,3,3);
    plot(Forzamiento.O.h,Forzamiento.MM.vv,'.k')
    hold on
    plot(Forzamiento.O.h(pos),Forzamiento.MM.vv(pos),'.y','Markersize',30)
    for j=1:M
       text(Forzamiento.O.h(pos(j)),Forzamiento.MM.vv(pos(j)),num2str(j),'Color','magenta','Fontweight','bold','Fontsize',12) 
    end
    xlabel('Hs','Fontweight','bold','Fontsize',16)
    ylabel('Vv','Fontweight','bold','Fontsize',16)
    grid on

    ss2(4)=subplot(3,3,4);
    plot(Forzamiento.O.h,Forzamiento.MM.d_v,'.k')
    hold on
    plot(Forzamiento.O.h(pos),Forzamiento.MM.d_v(pos),'.y','Markersize',30)
    for j=1:M
       text(Forzamiento.O.h(pos(j)),Forzamiento.MM.d_v(pos(j)),num2str(j),'Color','magenta','Fontweight','bold','Fontsize',12) 
    end
    xlabel('Hs','Fontweight','bold','Fontsize',16)
    ylabel('Dmd V','Fontweight','bold','Fontsize',16)
    grid on

    ss2(5)=subplot(3,3,5);
    plot(Forzamiento.O.tp,Forzamiento.O.d_o,'.k')
    hold on
    plot(Forzamiento.O.tp(pos),Forzamiento.O.d_o(pos),'.y','Markersize',30)
    for j=1:M
       text(Forzamiento.O.tp(pos(j)),Forzamiento.O.d_o(pos(j)),num2str(j),'Color','magenta','Fontweight','bold','Fontsize',12) 
    end
    xlabel('Tp','Fontweight','bold','Fontsize',16)
    ylabel('Dmd','Fontweight','bold','Fontsize',16)
    grid on

    ss2(6)=subplot(3,3,6);
    plot(Forzamiento.O.tp,Forzamiento.MM.vv,'.k')
    hold on
    plot(Forzamiento.O.tp(pos),Forzamiento.MM.vv(pos),'.y','Markersize',30)
    for j=1:M
       text(Forzamiento.O.tp(pos(j)),Forzamiento.MM.vv(pos(j)),num2str(j),'Color','magenta','Fontweight','bold','Fontsize',12) 
    end
    xlabel('Tp','Fontweight','bold','Fontsize',16)
    ylabel('Vv','Fontweight','bold','Fontsize',16)
    grid on
    
    ss2(7)=subplot(3,3,7);
    plot(Forzamiento.O.d_o,Forzamiento.MM.vv,'.k')
    hold on
    plot(Forzamiento.O.d_o(pos),Forzamiento.MM.vv(pos),'.y','Markersize',30)
    for j=1:M
       text(Forzamiento.O.d_o(pos(j)),Forzamiento.MM.vv(pos(j)),num2str(j),'Color','magenta','Fontweight','bold','Fontsize',12) 
    end
    xlabel('Dmd_O','Fontweight','bold','Fontsize',16)
    ylabel('Vv','Fontweight','bold','Fontsize',16)
    grid on

    ss2(8)=subplot(3,3,8);
    plot(Forzamiento.O.d_o,Forzamiento.MM.d_v,'.k')
    hold on
    plot(Forzamiento.O.d_o(pos),Forzamiento.MM.d_v(pos),'.y','Markersize',30)
    for j=1:M
       text(Forzamiento.O.d_o(pos(j)),Forzamiento.MM.d_v(pos(j)),num2str(j),'Color','magenta','Fontweight','bold','Fontsize',12) 
    end
    xlabel('Dmd O','Fontweight','bold','Fontsize',16)
    ylabel('Dmd V','Fontweight','bold','Fontsize',16)
    grid on

    ss2(9)=subplot(3,3,9);
    plot(Forzamiento.MM.vv,Forzamiento.MM.d_v,'.k')
    hold on
    plot(Forzamiento.MM.vv(pos),Forzamiento.MM.d_v(pos),'.y','Markersize',30)
    for j=1:M
       text(Forzamiento.MM.vv(pos(j)),Forzamiento.MM.d_v(pos(j)),num2str(j),'Color','magenta','Fontweight','bold','Fontsize',12) 
    end
    xlabel('Vv','Fontweight','bold','Fontsize',16)
    ylabel('Dmd V','Fontweight','bold','Fontsize',16)
    grid on

    
end

% 
% %% Si hay O en desembocadura más Marea Meteo más Marea astro más descarga represento las 7 variables 
% if comp_O==1 && comp_MM==1 % Caso 1 no hay ni olejae ni m.meteo
%     
%     figure1 = figure('PaperSize',[20.98 29.68],'Color',[1 1 1],'Position',[1,1,2000,1000],'Visible','on');
%     s(1)=subplot(5,1,1);
%     plot(Forzamiento.O.t_horario,Forzamiento.O.h,'b','Linewidth',2)
%     hold on
%     plot(Forzamiento.O.t_horario(pos),Forzamiento.O.h(pos),'.y','Markersize',30)
%     ylabel('Hs norm','Fontweight','bold','Fontsize',16)
%     grid on
%     datetick('x',12)
%     
%     s(2)=subplot(5,1,2);
%     plot(Forzamiento.O.t_horario,Forzamiento.O.tp,'r','Linewidth',2)
%     hold on
%     plot(Forzamiento.O.t_horario(pos),Forzamiento.O.tp(pos),'.y','Markersize',30)
%     ylabel('Tp norm','Fontweight','bold','Fontsize',16)
%     grid on
%     datetick('x',12)
%     
%     s(3)=subplot(5,1,3);
%     plot(Forzamiento.O.t_horario,Forzamiento.O.d_o,'.k','Linewidth',2)
%     hold on
%     plot(Forzamiento.O.t_horario(pos),Forzamiento.O.d_o(pos),'.y','Markersize',30)
%     ylabel('Dmd norm','Fontweight','bold','Fontsize',16)
%     grid on
%     datetick('x',12)
%     
%     s(2)=subplot(5,1,4);
%     plot(Forzamiento.MM.t_horario,Forzamiento.MM.vv,'g','Linewidth',2)
%     hold on
%     plot(Forzamiento.MM.t_horario(pos),Forzamiento.MM.vv(pos),'.y','Markersize',30)
%     ylabel('Tp norm','Fontweight','bold','Fontsize',16)
%     grid on
%     datetick('x',12)
%     
%     s(3)=subplot(5,1,5);
%     plot(Forzamiento.MM.t_horario,Forzamiento.MM.d_v,'.k','Linewidth',2)
%     hold on
%     plot(Forzamiento.MM.t_horario(pos),Forzamiento.MM.d_v(pos),'.y','Markersize',30)
%     ylabel('Dmd norm','Fontweight','bold','Fontsize',16)
%     grid on
%     datetick('x',12)
%     
%     
%     linkaxes([s],'x')
%     
%     
%     figure1 = figure('PaperSize',[20.98 29.68],'Color',[1 1 1],'Position',[1,1,2000,1000],'Visible','on');
%     s(1)=subplot(3,3,1);
%     plot(Forzamiento.O.h,Forzamiento.O.tp,'.k')
%     hold on
%     plot(Forzamiento.O.h(pos),Forzamiento.O.tp(pos),'.y','Markersize',30)
%     for j=1:M
%        text(Forzamiento.O.h(pos(j)),Forzamiento.O.tp(pos(j)),num2str(j),'Color','magenta','Fontweight','bold','Fontsize',12) 
%     end
%     xlabel('Hs','Fontweight','bold','Fontsize',16)
%     ylabel('Tp','Fontweight','bold','Fontsize',16)
%     grid on
% 
%     s(2)=subplot(3,3,2);
%     plot(Forzamiento.O.h,Forzamiento.O.d_o,'.k')
%     hold on
%     plot(Forzamiento.O.h(pos),Forzamiento.O.d_o(pos),'.y','Markersize',30)
%     for j=1:M
%        text(Forzamiento.O.h(pos(j)),Forzamiento.O.d_o(pos(j)),num2str(j),'Color','magenta','Fontweight','bold','Fontsize',12) 
%     end
%     xlabel('Hs','Fontweight','bold','Fontsize',16)
%     ylabel('Dmd O','Fontweight','bold','Fontsize',16)
%     grid on
% 
%     s(3)=subplot(3,3,3);
%     plot(Forzamiento.O.h,Forzamiento.MM.vv,'.k')
%     hold on
%     plot(Forzamiento.O.h(pos),Forzamiento.MM.vv(pos),'.y','Markersize',30)
%     for j=1:M
%        text(Forzamiento.O.h(pos(j)),Forzamiento.MM.vv(pos(j)),num2str(j),'Color','magenta','Fontweight','bold','Fontsize',12) 
%     end
%     xlabel('Hs','Fontweight','bold','Fontsize',16)
%     ylabel('Vv','Fontweight','bold','Fontsize',16)
%     grid on
% 
%     s(4)=subplot(3,3,4);
%     plot(Forzamiento.O.h,Forzamiento.MM.d_v,'.k')
%     hold on
%     plot(Forzamiento.O.h(pos),Forzamiento.MM.d_v(pos),'.y','Markersize',30)
%     for j=1:M
%        text(Forzamiento.O.h(pos(j)),Forzamiento.MM.d_v(pos(j)),num2str(j),'Color','magenta','Fontweight','bold','Fontsize',12) 
%     end
%     xlabel('Hs','Fontweight','bold','Fontsize',16)
%     ylabel('Dmd V','Fontweight','bold','Fontsize',16)
%     grid on
% 
%     s(5)=subplot(3,3,5);
%     plot(Forzamiento.O.tp,Forzamiento.O.d_o,'.k')
%     hold on
%     plot(Forzamiento.O.tp(pos),Forzamiento.O.d_o(pos),'.y','Markersize',30)
%     for j=1:M
%        text(Forzamiento.O.tp(pos(j)),Forzamiento.O.d_o(pos(j)),num2str(j),'Color','magenta','Fontweight','bold','Fontsize',12) 
%     end
%     xlabel('Tp','Fontweight','bold','Fontsize',16)
%     ylabel('Dmd','Fontweight','bold','Fontsize',16)
%     grid on
% 
%     s(6)=subplot(3,3,6);
%     plot(Forzamiento.O.tp,Forzamiento.MM.vv,'.k')
%     hold on
%     plot(Forzamiento.O.tp(pos),Forzamiento.MM.vv(pos),'.y','Markersize',30)
%     for j=1:M
%        text(Forzamiento.O.tp(pos(j)),Forzamiento.MM.vv(pos(j)),num2str(j),'Color','magenta','Fontweight','bold','Fontsize',12) 
%     end
%     xlabel('Tp','Fontweight','bold','Fontsize',16)
%     ylabel('Vv','Fontweight','bold','Fontsize',16)
%     grid on
%     
%     s(7)=subplot(3,3,7);
%     plot(Forzamiento.O.d_o,Forzamiento.MM.vv,'.k')
%     hold on
%     plot(Forzamiento.O.d_o(pos),Forzamiento.MM.vv(pos),'.y','Markersize',30)
%     for j=1:M
%        text(Forzamiento.O.d_o(pos(j)),Forzamiento.MM.vv(pos(j)),num2str(j),'Color','magenta','Fontweight','bold','Fontsize',12) 
%     end
%     xlabel('Dmd_O','Fontweight','bold','Fontsize',16)
%     ylabel('Vv','Fontweight','bold','Fontsize',16)
%     grid on
% 
%     s(8)=subplot(3,3,8);
%     plot(Forzamiento.O.d_o,Forzamiento.MM.d_v,'.k')
%     hold on
%     plot(Forzamiento.O.d_o(pos),Forzamiento.MM.d_v(pos),'.y','Markersize',30)
%     for j=1:M
%        text(Forzamiento.O.d_o(pos(j)),Forzamiento.MM.d_v(pos(j)),num2str(j),'Color','magenta','Fontweight','bold','Fontsize',12) 
%     end
%     xlabel('Dmd O','Fontweight','bold','Fontsize',16)
%     ylabel('Dmd V','Fontweight','bold','Fontsize',16)
%     grid on
% 
%     s(9)=subplot(3,3,9);
%     plot(Forzamiento.MM.vv,Forzamiento.MM.d_v,'.k')
%     hold on
%     plot(Forzamiento.MM.vv(pos),Forzamiento.MM.d_v(pos),'.y','Markersize',30)
%     for j=1:M
%        text(Forzamiento.MM.vv(pos(j)),Forzamiento.MM.d_v(pos(j)),num2str(j),'Color','magenta','Fontweight','bold','Fontsize',12) 
%     end
%     xlabel('Vv','Fontweight','bold','Fontsize',16)
%     ylabel('Dmd V','Fontweight','bold','Fontsize',16)
%     grid on
% 
%     
% end
%         
    end

