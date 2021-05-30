 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Interpolacion_regimen_medio_RBF
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%_________________________________________________________________________
% 
% Programa principal que a partir de las series temporales de
% los forzamientos elegidos selecciona una muestra representativa de M
% puntos mediante el método de MDA, obtiene los valores de elevación en los
% puntos de control indicados para cada valor de los forzamientos contenido
% en la muestra y finalmente me interpola la serie completa de oleaje,
% periodo y dirección a partir de los valores simulados en Delft3D para cada
% combinación de forzamientos contenidos en la muestra obtenida mediante el
% MDA
%
% Consta de varias funciones:
% 1. GENERACION DE SERIES TEMPORALES
% 2. NORMALIZACION
% 3. SELECCION DE CASOS REPRESENTATIVOS MDA
% 4. BUSQUEDA DE POSICIONES
% 5. DESNORMALIZACION
% 6. REPRESENTACION_MUESTRA
% 7. CALCULO_PARAMETROS_FORMA_RIPPA_99
% 8. CALCULO_RADIAL_BASIS_FUNCTION
%
%                                              Granada, 14 de marzo de 2016
%                                                     Juan del Rosal Salido
%                                   Grupo de Dinámica de Flujos Ambientales 
%                                                    Universidad de Granada
%__________________________________________________________________________

clear all
close all
clc

%% Datos de entrada
slr_sc = '95_85';
SC='SC_95_85';

n_sim = 3;

Forz_input=struct('MA_DESPLAZ',0,'MA',1,'Q',1,'O',0,'OD',1,'ODSV',0,'MM',1,'SLR',1); 

t_ini=datenum(2018,01,01,00,00,00);
t_fin=datenum(2100,01,01,00,00,00);

puntos_control = [133, 39; 680, 372; 133, 108; 725, 411; 131, 205; 774, 468; 260, 196; 858, 377; 332, 239; 932, 346; 422, 274; 1015, 286; 483, 297; 1069, 249; 439, 382; 1100, 347];


M=300;

OF = 'OF_REAL';
%OF = 'OF_NO';

c_ini=0.001; %0.01
c_paso=0.001; %0.001
c_fin=1;
c_vect=[c_ini:c_paso:c_fin];

var = 'eta';

%% Importacion de modulos
import LECTURA_SERIES_SIMULADAS.*
import GENERACION_SERIES_TEMPORALES.*
import REPRESENTACION_FORZAMIENTOS.*
import NORMALIZACION.*
import SELECCION_CASOS_REPRESENTATIVOS_MDA.*
import AGRUPACION_AGENTES_NORMALIZADOS_HORARIOS.*
import BUSQUEDA_POSICIONES.*
import DESNORMALIZACION.*
import REPRESENTACION_MUESTRA.*
import EXTRACCION_VALOR_DE_F.*
import CALCULO_PARAMETROS_FORMA_RIPPA_99.*
import CALCULO_RADIAL_BASIS_FUNCTION.*
import AGRUPACION_AGENTES_NORMALIZADOS_HORARIOS.*
import REDUCCION_VOLUMEN.*


% Recorrido por los puntos de control
for j = 1: 2:length(puntos_control(:, 1))
    PC = [puntos_control(j, :); puntos_control(j+1, :)];
    for sim = 1: n_sim
         close all 
         disp(['Se inicia la RBF en el PC ', num2str(PC(2,1)), '_', num2str(PC(2,2)) ' simulacion ' num2str(sim)])
        if sim == 1
            file = 'simar_simulado_tratrado';
            [Forzamiento]=GENERACION_SERIES_TEMPORALES(Forz_input,t_ini,t_fin, file, slr_sc);
            [Forzamiento_3h] = REDUCCION_VOLUMEN(Forz_input, Forzamiento, slr_sc);
            [Forzamiento_norm_3h]=NORMALIZACION(Forzamiento_3h, Forzamiento_3h, Forz_input, slr_sc);
            [Forzamiento_norm]=NORMALIZACION(Forzamiento, Forzamiento, Forz_input, slr_sc);
            [d_3h,X_3h]=SELECCION_CASOS_REPRESENTATIVOS_MDA(Forzamiento_norm_3h,M);
            pos=BUSQUEDA_POSICIONES(d_3h,X_3h);
            D_3h=DESNORMALIZACION(Forzamiento_3h,pos);
            %REPRESENTACION_MUESTRA(Forzamiento_3h, Forzamiento_norm_3h, pos,X_3h, M);

            % Transformo las posiciones a los Forzamientos horarios
            if strcmp(SC, 'SC_95_85')
                for p = 1:M
                    pos_hor(p) = find(Forzamiento.MA_95_85.t_ma == Forzamiento_3h.MA_95_85.t_ma(pos(p)));
                end

                X = AGRUPACION_AGENTES_NORMALIZADOS_HORARIOS(Forzamiento_norm);
                d(:, 1) = Forzamiento_norm.MA_95_85.ma_norm(pos_hor);
                d(:, 2) = Forzamiento_norm.Q.q_norm(pos_hor);
                d(:, 3) = Forzamiento_norm.OD.Hs_norm(pos_hor);
                d(:, 4) = Forzamiento_norm.OD.Tp_norm(pos_hor);
                d(:, 5) = Forzamiento_norm.OD.Do_rad_norm(pos_hor);
                d(:, 6) = Forzamiento_norm.MM.vv_norm(pos_hor);
                d(:, 7) = Forzamiento_norm.MM.d_v_rad_norm(pos_hor);
                d(:, 8) = Forzamiento_norm.MM.pnm_norm(pos_hor);
            elseif strcmp(SC, 'SC_05_45')
                for p = 1:M
                    pos_hor(p) = find(Forzamiento.MA_05_45.t_ma == Forzamiento_3h.MA_05_45.t_ma(pos(p)));
                end
                X = AGRUPACION_AGENTES_NORMALIZADOS_HORARIOS(Forzamiento_norm);
                d(:, 1) = Forzamiento_norm.MA_05_45.ma_norm(pos_hor);
                d(:, 2) = Forzamiento_norm.Q.q_norm(pos_hor);
                d(:, 3) = Forzamiento_norm.OD.Hs_norm(pos_hor);
                d(:, 4) = Forzamiento_norm.OD.Tp_norm(pos_hor);
                d(:, 5) = Forzamiento_norm.OD.Do_rad_norm(pos_hor);
                d(:, 6) = Forzamiento_norm.MM.vv_norm(pos_hor);
                d(:, 7) = Forzamiento_norm.MM.d_v_rad_norm(pos_hor);
                d(:, 8) = Forzamiento_norm.MM.pnm_norm(pos_hor);
            end
            
            F=EXTRACCION_VALOR_DE_F(PC,M,Forzamiento,Forzamiento_3h,pos_hor,Forz_input, SC, OF, var);
            % Calculo del parametro de Forma (Rippa 1991)
            [c,E]=CALCULO_PARAMETROS_FORMA_RIPPA_99(c_ini,c_paso,c_fin,c_vect,F,d,Forzamiento,M,PC,Forz_input,SC, OF, var);
            % Reconstruction of the elevation through the Radial Basis Functions
            S_real=CALCULO_RADIAL_BASIS_FUNCTION(Forzamiento,c,F,M,PC,d,X,Forz_input, sim, SC, OF, var); 
            S_completo{sim} = S_real;
            
            figure
            s(1) = subplot(3,1,1)
            plot(datetime(Forzamiento.MA_95_85.t_ma,'ConvertFrom','datenum'), S_completo{sim})
            grid on
            s(2) = subplot(3,1,2)
            grid on
            plot(datetime(Forzamiento.MA_95_85.t_ma,'ConvertFrom','datenum'), Forzamiento.MA_95_85.ma)
            s(3) = subplot(3,1,3)
            grid on
            plot(datetime(Forzamiento.Q.t_q,'ConvertFrom','datenum'), Forzamiento.Q.q)
            linkaxes([s], 'x')
            
        else
            % Compruebo si existe fichero (para no volver a calcularlo)
            names = fieldnames(Forzamiento);
            l=length(names);
            fold_name='';
            for j=1:l
               fold_name=[fold_name char(names(j)),'_']; 
            end
            file_name=[fold_name 'eta_' 'M=' num2str(M) '_PC_' num2str(PC(2, 1)) '_' num2str(PC(2, 2)) '_sim_' num2str(sim,'%04.f')];

            if exist(['DATOS\RADIAL_BASIS_FUNCTION\ELEVACIONES_GAUDALETE\' fold_name '\eta\' SC '\' OF '\' file_name '.mat'], 'file') == 2
            else
                dir_sim = 'D:\REPOSITORIO GIT\protocol_project\protocol\protocol\climate\tests\stats\forecasting\output\simulacion\series_temporales';
                [Forzamiento_sim] = LECTURA_SERIES_SIMULADAS(Forz_input,t_ini,t_fin, file, slr_sc, dir_sim, sim, ...
                                                         Forzamiento);
                [Forzamiento_sim_norm]=NORMALIZACION(Forzamiento_sim, Forzamiento, Forz_input, slr_sc);
                X = AGRUPACION_AGENTES_NORMALIZADOS_HORARIOS(Forzamiento_sim_norm);
                S_real_sim=CALCULO_RADIAL_BASIS_FUNCTION(Forzamiento,c,F,M,PC,d,X,Forz_input, sim, SC, OF, var);
                S_completo{sim} = S_real;
            end

        end
    end
    
end
            
            
        


