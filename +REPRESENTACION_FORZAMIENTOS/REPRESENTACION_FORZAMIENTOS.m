function REPRESENTACION_FORZAMIENTOS(Forzamiento)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% REPRESENTACION_FORZAMIENTOS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%_________________________________________________________________________
% 
% Descripcion: Función que me pinta las series temporales de los 
%forzamientos.
%
% Datos de entrada:
% 1. Forzamiento: Estructura con las series temporales de los forzamientos 
% considerados
%
%
%
%                                              Granada, 15 de marzo de 2016
%                                                     Juan del Rosal Salido
%                                   Grupo de Dinámica de Flujos Ambientales 
%                                                    Universidad de Granada
%__________________________________________________________________________

figure1 = figure('PaperSize',[20.98 29.68],'Color',[1 1 1],'Position',[1,1,2000,1000],'Visible','on');

if isfield(Forzamiento,'MA')
    s(1)=subplot(4,2,1);
    plot(Forzamiento.MA.t_ma,Forzamiento.MA.ma,'k','Linewidth',2)
    grid on
    datetick('x',11)
    set(gca,'xticklabel',{[]}) 
    set(gca, 'fontsize' ,16)
    xlim([Forzamiento.MA.t_ma(1) Forzamiento.MA.t_ma(end)])
    ylim([min(Forzamiento.MA.ma) max(Forzamiento.MA.ma)])
    ylabel('MA (m)','Fontweight','bold','Fontsize',16)
end

if isfield(Forzamiento,'MA_95_85')
    s(1)=subplot(4,2,1);
    plot(Forzamiento.MA_95_85.t_ma,Forzamiento.MA_95_85.ma,'k','Linewidth',2)
    grid on
    datetick('x',11)
    set(gca,'xticklabel',{[]}) 
    set(gca, 'fontsize' ,16)
    xlim([Forzamiento.MA_95_85.t_ma(1) Forzamiento.MA_95_85.t_ma(end)])
    ylim([min(Forzamiento.MA_95_85.ma) max(Forzamiento.MA_95_85.ma)])
    ylabel('MA 95 8.5 (m)','Fontweight','bold','Fontsize',16)
end

if isfield(Forzamiento,'MA_05_45')
    s(1)=subplot(4,2,1);
    plot(Forzamiento.MA_05_45.t_ma,Forzamiento.MA_05_45.ma,'k','Linewidth',2)
    grid on
    datetick('x',11)
    set(gca,'xticklabel',{[]}) 
    set(gca, 'fontsize' ,16)
    xlim([Forzamiento.MA_05_45.t_ma(1) Forzamiento.MA_05_45.t_ma(end)])
    ylim([min(Forzamiento.MA_05_45.ma) max(Forzamiento.MA_05_45.ma)])
    ylabel('MA 05 4.5 (m)','Fontweight','bold','Fontsize',16)
end


if isfield(Forzamiento,'Q')
    s(2)=subplot(4,2,2);
    plot(Forzamiento.Q.t_q,Forzamiento.Q.q,'r','Linewidth',2)
    grid on
    datetick('x',11)
    set(gca,'xticklabel',{[]}) 
    set(gca, 'fontsize', 16)
    xlim([Forzamiento.Q.t_q(1) Forzamiento.Q.t_q(end)])
    ylim([min(Forzamiento.Q.q) max(Forzamiento.Q.q)])
    ylabel('Q (m3/s)','Fontweight','bold','Fontsize',16)
    %xlabel('t','Fontweight','bold','Fontsize',16)
end


if isfield(Forzamiento,'O')
    s(3)=subplot(4,2,3);
    plot(Forzamiento.O.t_horario,Forzamiento.O.h,'b','Linewidth',2)
    grid on
    datetick('x',11)
    set(gca,'xticklabel',{[]}) 
    set(gca, 'fontsize' ,16)
    xlim([Forzamiento.O.t_horario(1) Forzamiento.O.t_horario(end)])
    ylim([min(Forzamiento.O.h) max(Forzamiento.O.h)])
    ylabel('H','Fontweight','bold','Fontsize',16)
    
    s(4)=subplot(4,2,4);
    plot(Forzamiento.O.t_horario,Forzamiento.O.tp,'r','Linewidth',2)
    grid on
    datetick('x',11)
    set(gca,'xticklabel',{[]}) 
    set(gca, 'fontsize' ,16)
    xlim([Forzamiento.O.t_horario(1) Forzamiento.O.t_horario(end)])
    ylim([min(Forzamiento.O.tp) max(Forzamiento.O.tp)])
    ylabel('Tp','Fontweight','bold','Fontsize',16)
    
    s(5)=subplot(4,2,5);
    plot(Forzamiento.O.t_horario,Forzamiento.O.d_o,'k','Linewidth',2)
    grid on
    datetick('x',11)
    set(gca,'xticklabel',{[]}) 
    set(gca, 'fontsize' ,16)
    xlim([Forzamiento.O.t_horario(1) Forzamiento.O.t_horario(end)])
    ylim([min(Forzamiento.O.d_o) max(Forzamiento.O.d_o)])
    ylabel('Dmd','Fontweight','bold','Fontsize',16)
   
    
end

if isfield(Forzamiento,'OD')
    s(3)=subplot(4,2,3);
    plot(Forzamiento.OD.t_horario,Forzamiento.OD.Hs,'color',[0.8 0.8 0.8],'Linewidth',2)
    grid on
    datetick('x',11)
    set(gca,'xticklabel',{[]}) 
    set(gca, 'fontsize' ,16)
    xlim([Forzamiento.OD.t_horario(1) Forzamiento.OD.t_horario(end)])
    ylim([min(Forzamiento.OD.Hs) max(Forzamiento.OD.Hs)])
    ylabel('Hs (m)','Fontweight','bold','Fontsize',16)
    
    s(4)=subplot(4,2,4);
    plot(Forzamiento.OD.t_horario,Forzamiento.OD.Tp,'color',[0.8 0.8 0.8],'Linewidth',2)
    grid on
    datetick('x',11)
    set(gca,'xticklabel',{[]}) 
    set(gca, 'fontsize' ,16)
    xlim([Forzamiento.OD.t_horario(1) Forzamiento.OD.t_horario(end)])
    ylim([min(Forzamiento.OD.Tp) max(Forzamiento.OD.Tp)])
    ylabel('Tp (s)','Fontweight','bold','Fontsize',16)
    
    s(5)=subplot(4,2,5);
    plot(Forzamiento.OD.t_horario,Forzamiento.OD.Do,'color',[0.8 0.8 0.8],'Linewidth',2)
    grid on
    datetick('x',11)
    set(gca,'xticklabel',{[]}) 
    set(gca, 'fontsize' ,16)
    xlim([Forzamiento.OD.t_horario(1) Forzamiento.OD.t_horario(end)])
    ylim([min(Forzamiento.OD.Do) max(Forzamiento.OD.Do)])
    ylabel('Dmd (º)','Fontweight','bold','Fontsize',16)
    
    
end


if isfield(Forzamiento,'ODSV')
    s(3)=subplot(4,1,3);
    plot(Forzamiento.ODSV.t_horario,Forzamiento.ODSV.Hs,'b','Linewidth',2)
    grid on
    datetick('x',12)
    xlim([Forzamiento.ODSV.t_horario(1) Forzamiento.ODSV.t_horario(end)])    
    ylabel('Hs','Fontweight','bold','Fontsize',16)
    xlabel ('t','Fontweight','bold','Fontsize',16)    
end

if isfield(Forzamiento,'MM')
    s(6)=subplot(4,2,6);
    plot(Forzamiento.MM.t_horario,Forzamiento.MM.vv,'color',[0.3 0.3 0.3],'Linewidth',2)
    grid on
    datetick('x',11)
    %set(gca,'xticklabel',{[]}) 
    set(gca, 'fontsize' ,16)
    xlim([Forzamiento.OD.t_horario(1) Forzamiento.OD.t_horario(end)])
    ylim([min(Forzamiento.MM.vv) max(Forzamiento.MM.vv)])
    ylabel('Vv (m/s)','Fontweight','bold','Fontsize',16)
    xlabel ('t','Fontweight','bold','Fontsize',16)
    
    s(7)=subplot(4,2,7);
    plot(Forzamiento.MM.t_horario,Forzamiento.MM.d_v,'color',[0.3 0.3 0.3],'Linewidth',1)
    grid on
    datetick('x',11)
    set(gca, 'fontsize' ,16)
    xlim([Forzamiento.OD.t_horario(1) Forzamiento.OD.t_horario(end)])
    ylim([min(Forzamiento.MM.d_v) max(Forzamiento.MM.d_v)])
    ylabel('Dmd (º)','Fontweight','bold','Fontsize',16)
    xlabel ('t','Fontweight','bold','Fontsize',16)
    
end

linkaxes([s],'x')

%% Grafico específico O
if isfield(Forzamiento,'O')
    figure1 = figure('PaperSize',[20.98 29.68],'Color',[1 1 1],'Position',[1,1,2000,1000],'Visible','on');
    s(1)=subplot(3,1,1);
    plot(Forzamiento.O.t_horario,Forzamiento.O.h,'b','Linewidth',2)
    grid on
    datetick('x',12)
    xlim([Forzamiento.O.t_horario(1) Forzamiento.O.t_horario(end)])
    ylabel('H (m)','Fontweight','bold','Fontsize',16)
    
    s(2)=subplot(3,1,2);
    plot(Forzamiento.O.t_horario,Forzamiento.O.tp,'r','Linewidth',2)
    grid on
    datetick('x',12)
    xlim([Forzamiento.O.t_horario(1) Forzamiento.O.t_horario(end)])
    ylabel('Tp (s)','Fontweight','bold','Fontsize',16)
    
    
    s(3)=subplot(3,1,3);
    plot(Forzamiento.O.t_horario,Forzamiento.O.d_o,'.k','Linewidth',2)
    grid on
    datetick('x',12)
    xlim([Forzamiento.O.t_horario(1) Forzamiento.O.t_horario(end)])
    ylabel('Dmd (º)','Fontweight','bold','Fontsize',16)
    xlabel ('t','Fontweight','bold','Fontsize',16)
end



%% Grafico específico OD
if isfield(Forzamiento,'OD')
    figure1 = figure('PaperSize',[20.98 29.68],'Color',[1 1 1],'Position',[1,1,2000,1000],'Visible','on');
    s(1)=subplot(3,1,1);
    plot(Forzamiento.OD.t_horario,Forzamiento.OD.Hs,'b','Linewidth',2)
    grid on
    datetick('x',12)
    xlim([Forzamiento.OD.t_horario(1) Forzamiento.OD.t_horario(end)])
    ylabel('H (m)','Fontweight','bold','Fontsize',16)
    
    s(2)=subplot(3,1,2);
    plot(Forzamiento.OD.t_horario,Forzamiento.OD.Tp,'r','Linewidth',2)
    grid on
    datetick('x',12)
    xlim([Forzamiento.OD.t_horario(1) Forzamiento.OD.t_horario(end)])
    ylabel('Tp (s)','Fontweight','bold','Fontsize',16)
    
    
    s(3)=subplot(3,1,3);
    plot(Forzamiento.OD.t_horario,Forzamiento.OD.Do,'.k','Linewidth',2)
    grid on
    datetick('x',12)
    xlim([Forzamiento.OD.t_horario(1) Forzamiento.OD.t_horario(end)])
    ylabel('Dmd (º)','Fontweight','bold','Fontsize',16)
    xlabel ('t','Fontweight','bold','Fontsize',16)
end

%% Grafico específico ODSV
if isfield(Forzamiento,'ODSV')
    figure1 = figure('PaperSize',[20.98 29.68],'Color',[1 1 1],'Position',[1,1,2000,1000],'Visible','on');
    s(1)=subplot(3,1,1);
    plot(Forzamiento.ODSV.t_horario,Forzamiento.ODSV.Hs,'b','Linewidth',2)
    grid on
    datetick('x',12)
    xlim([Forzamiento.ODSV.t_horario(1) Forzamiento.ODSV.t_horario(end)])
    ylabel('H (m)','Fontweight','bold','Fontsize',16)
    
    s(2)=subplot(3,1,2);
    plot(Forzamiento.ODSV.t_horario,Forzamiento.ODSV.Tp,'r','Linewidth',2)
    grid on
    datetick('x',12)
    xlim([Forzamiento.ODSV.t_horario(1) Forzamiento.ODSV.t_horario(end)])
    ylabel('Tp (s)','Fontweight','bold','Fontsize',16)
    
    
    s(3)=subplot(3,1,3);
    plot(Forzamiento.ODSV.t_horario,Forzamiento.ODSV.Do,'.k','Linewidth',2)
    grid on
    datetick('x',12)
    xlim([Forzamiento.ODSV.t_horario(1) Forzamiento.ODSV.t_horario(end)])
    ylabel('Dmd (º)','Fontweight','bold','Fontsize',16)
    xlabel ('t','Fontweight','bold','Fontsize',16)
end

%% Grafico específico Marea_meteo
if isfield(Forzamiento,'MM')
    figure1 = figure('PaperSize',[20.98 29.68],'Color',[1 1 1],'Position',[1,1,2000,1000],'Visible','on');
    s(1)=subplot(3,1,1);
    plot(Forzamiento.MM.t_horario,Forzamiento.MM.vv,'g','Linewidth',2)
    grid on
    datetick('x',12)
    xlim([Forzamiento.MM.t_horario(1) Forzamiento.MM.t_horario(end)])
    ylabel('Vv (m)','Fontweight','bold','Fontsize',16)
    
    s(2)=subplot(3,1,2);
    plot(Forzamiento.MM.t_horario,Forzamiento.MM.d_v,'k','Linewidth',2)
    grid on
    datetick('x',12)
    xlim([Forzamiento.MM.t_horario(1) Forzamiento.MM.t_horario(end)])
    ylabel('Dmd (º)','Fontweight','bold','Fontsize',16)
    xlabel ('t','Fontweight','bold','Fontsize',16)
end



end