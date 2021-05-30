function [t_sintetica,WL_sintetica,coord]=EXTRACCION_DELFT_FGUAD(dir_sim,file_name,PC,var)

dir='C:\Delft3D\w32\delft3d_matlab';
addpath(dir) %Añado el directorio con las funciones del Quickplot
dir_simulacion=[dir_sim '\trih-fcad.dat']

%Elimino espacios en blanco
dir_simulacion(dir_simulacion==' ') = [];
file_name(file_name==' ') = [];



M=num2str(PC(2,1));
N=num2str(PC(2,2));

%Abro el TRIM de la malla FGUAD 
d3d_qp('openfile',dir_simulacion) 
if strcmp(var, 'eta')
    d3d_qp('selectfield','water level')
elseif strcmp(var, 'v_x')
    d3d_qp('selectfield','depth averaged velocity')
    d3d_qp('component','x component')
elseif strcmp(var, 'v_y')
    d3d_qp('selectfield','depth averaged velocity')
    d3d_qp('component','x component')
elseif strcmp(var, 'hs')
    d3d_qp('selectfield','significant wave height')
elseif strcmp(var, 'tp')
    d3d_qp('selectfield','peak wave period')
elseif strcmp(var, 'do')
    d3d_qp('selectfield','wave direction')
end
    
estation=strcat('(',M,',',N,')  ');
d3d_qp('station',estation)
d3d_qp('exporttype','mat file (v7)')
% EXPORTO A LA CARPETA DE RESULTADOS
currentFolder = pwd;

if strcmp(var, 'eta')
    dir_res=strcat(currentFolder,'\RESULTADOS_SIMULACIONES\',file_name,'_',M,'_',N,'_WL.mat');
    file_name=[file_name,'_',M,'_',N,'_WL.mat'];
elseif strcmp(var, 'v_x')
    dir_res=strcat(currentFolder,'\RESULTADOS_SIMULACIONES\',file_name,'_',M,'_',N,'_v_x.mat');
    file_name=[file_name,'_',M,'_',N,'_v_x.mat'];
elseif strcmp(var, 'v_y')
    dir_res=strcat(currentFolder,'\RESULTADOS_SIMULACIONES\',file_name,'_',M,'_',N,'_v_y.mat');
    file_name=[file_name,'_',M,'_',N,'_v_y.mat'];
elseif strcmp(var, 'hs')
    dir_res=strcat(currentFolder,'\RESULTADOS_SIMULACIONES\',file_name,'_',M,'_',N,'_hs.mat');
    file_name=[file_name,'_',M,'_',N,'_hs.mat'];
elseif strcmp(var, 'tp')
    dir_res=strcat(currentFolder,'\RESULTADOS_SIMULACIONES\',file_name,'_',M,'_',N,'_tp.mat');
    file_name=[file_name,'_',M,'_',N,'_tp.mat'];
elseif strcmp(var, 'do')
    dir_res=strcat(currentFolder,'\RESULTADOS_SIMULACIONES\',file_name,'_',M,'_',N,'_do.mat');
    file_name=[file_name,'_',M,'_',N,'_do.mat'];
end

addpath('RESULTADOS_SIMULACIONES')

% No exportar el resultado si ya esta exportado, para ahorrar tiempo
if isequal(exist(file_name,'file'),2) % 2 means it's a file. 

else 
d3d_qp('exportdata',dir_res)
end

%d3d_qp('exportdata',dir_res)

% Cargo los datos sacados del Delft
data=load(file_name);
t_sintetica=data.data.Time;
WL_sintetica=data.data.Val;
coord(1,1)=data.data.X(1);
coord(1,2)=data.data.Y(1);
end