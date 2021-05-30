function [t_anno_real,WL_anno_real]=EXTRACCION_ELEVACION_MA_Q_ANUAL(PC)
%Programa para extraer la serie anual de elevaciones MA+Q

dir='C:\Delft3D\w32\delft3d_matlab';
addpath(dir) %Añado el directorio con las funciones del Quickplot
dir_sim=['..\..\HINDCAST\SIMULACIONES\RESULTADOS\RESULTADOS_ANNO_COMPLETO\MA_Q_\Sim_1_1996_1997' '\trih-fguad.dat'];
M=num2str(PC(1,1));
N=num2str(PC(1,2));
file_name='Sim_Real_MA_Q_1996_1997';

%Abro el TRIM de la malla FGUAD 
d3d_qp('openfile',dir_sim) 
d3d_qp('selectfield','water level')
estation=strcat('(',M,',',N,')  ');
d3d_qp('station',estation)
d3d_qp('exporttype','mat file (v7)')
% EXPORTO A LA CARPETA DE RESULTADOS
currentFolder = pwd;
dir_res=strcat(currentFolder,'\RESULTADOS_SIMULACIONES\',file_name,'_',M,'_',N,'_WL.mat');

addpath('RESULTADOS_SIMULACIONES')
% No exportar el resultado si ya esta exportado, para ahorrar tiempo
if isequal(exist(dir_res,'file'),2) % 2 means it's a file. 

else 
d3d_qp('exportdata',dir_res)
end

% Cargo los datos sacados del Delft
data=load(dir_res);
t_anno_real=data.data.Time;
WL_anno_real=data.data.Val;

end