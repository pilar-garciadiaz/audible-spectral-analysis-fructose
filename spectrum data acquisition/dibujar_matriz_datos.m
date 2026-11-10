% Copyright 2026 Pilar Garcia Diaz
%
% Licensed under the Apache License, Version 2.0 (the "License");
% you may not use this file except in compliance with the License.
% You may obtain a copy of the License at:
%
%     https://www.apache.org/licenses/LICENSE-2.0
%
% Unless required by applicable law or agreed to in writing, software
% distributed under the License is distributed on an "AS IS" BASIS,
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
% See the License for the specific language governing permissions and
% limitations under the License.
%
% SPDX-License-Identifier: Apache-2.0
%
% This file is part of:
% Audible Spectral Analysis of Aqueous Fructose Solutions
%
% Associated publication:
% Garcia Diaz, P., Utrilla Manso, M., Alpuente Hermosilla, J., and
% Martinez Rojas, J. A. (2021). Study of the Optimal Waveforms for
% Non-Destructive Spectral Analysis of Aqueous Solutions by Means of
% Audible Sound and Optimization Algorithms. Applied Sciences, 11(16),
% 7301. https://doi.org/10.3390/app11167301
%
% Software repository:
% https://github.com/pilar-garciadiaz]/audible-spectral-analysis-fructose
%
% Software DOI:
% https://doi.org/10.5281/zenodo.24119982
%
% Author:
% Pilar Garcia Diaz, Universidad de Alcala
% ORCID: https://orcid.org/0000-0002-5361-6947

clear all;
close all;

global datos;
global num_tramos;
global num_medidas;
global average_points_num;


path_datos='/Datos/';
path_resultados='/Resultados/';

datos=[];
average_points_num=100;


num_tramos=4

num_tramos=1


%Para unidades
num_medidas=10
%Para decimas y centesimas
num_medidas=11




%Leer datos


% nombre='mls_datos_matriz1.txt';
% nombre='mls_datos_matriz2.txt';
% nombre='mls_datos_matriz3.txt';
% nombre='mls_datos_matriz4.txt';

% nombre='mls_decimas_datos_matriz1.txt'
% nombre='mls_decimas_datos_matriz2.txt'
% nombre='mls_decimas_datos_matriz3.txt'
% nombre='mls_decimas_datos_matriz4.txt'

nombre='mls_centesimas_datos_matriz1.txt'
nombre='mls_centesimas_datos_matriz2.txt'
nombre='mls_centesimas_datos_matriz3.txt'
nombre='mls_centesimas_datos_matriz4.txt'


myfile=cat(2,path_datos,nombre);
fid = fopen(myfile, 'r');
valor=[myfile];
if fid < 3 
    display('Error al abrir archivo datos_matriz.txt');
else
    
    datos_matriz = load(valor,'-ascii');
    datos=num2cell(datos_matriz);
    
    fclose(fid)
end

promedio_datos();

% Grabar datos promediados

% nombre='mls_datos_promedio_matriz1.txt';
% nombre='mls_datos_promedio_matriz2.txt';
% nombre='mls_datos_promedio_matriz3.txt';
% nombre='mls_datos_promedio_matriz4.txt';

% nombre='mls_decimas_datos_promedio_matriz1.txt';
% nombre='mls_decimas_datos_promedio_matriz2.txt';
% nombre='mls_decimas_datos_promedio_matriz3.txt';
% nombre='mls_decimas_datos_promedio_matriz4.txt';

nombre='mls_centesimas_datos_promedio_matriz1.txt';
nombre='mls_centesimas_datos_promedio_matriz2.txt';
nombre='mls_centesimas_datos_promedio_matriz3.txt';
nombre='mls_centesimas_datos_promedio_matriz4.txt';



myfile=cat(2,path_resultados,nombre);

fid = fopen(myfile, 'w+');
if fid < 3
    display('Error al abrir archivo datos_matriz.txt');
    return
end

datos_matriz=cell2mat(datos);    
dlmwrite(myfile,datos_matriz,'delimiter','\t','precision',18);
fclose(fid)



[fil,col]=size(datos);
df=1:(length(datos)-1);

%offset_tramo=num_sufijo-1;

for offset_tramo=0:((fil/num_medidas)-1)
    
    %FIGURA CON TODAS LAS MEDIDAS DE UN TRAMO
    h=figure(1);
    set(h,'Name','Resultado_todos')
    
    set(h,'OuterPosition',[0 0 1900 1050]);%sobremesa
    
    %Para unidades
    m=5
    %Para decimas y centesimas
    m=6
    
    k=ceil(num_medidas/m);
    for ii=1:num_medidas
        y=cell2mat(datos(( ii+(offset_tramo*num_medidas) ),2:end));

        subplot(k,m,ii);
        plot(df(1:length(df)),y(1:length(y)));%,'b','linewidth',2);
        axis([df(1) df(end) min(y) max(y)]);
        %legend('1',num2str(vector(ii)));
        grid      
        title(cat(2,'Measure ',num2str(ii)))
    end

    nombre='_0_9gr_promedio.jpg';
    nombre='_2_3gr_promedio_decimas.jpg';
    nombre='_2_2_1gr_promedio_centesimas.jpg';
    


    myfile=cat(2,path_resultados,'mls_Tramo_',num2str(offset_tramo+1),nombre);%OJO hasta offset_tramo=99 
    myfile=cat(2,path_resultados,'mls_Tramo_',num2str(offset_tramo+1+4),nombre);%OJO hasta offset_tramo=99 
    myfile=cat(2,path_resultados,'mls_Tramo_',num2str(offset_tramo+1+8),nombre);%OJO hasta offset_tramo=99 
    myfile=cat(2,path_resultados,'mls_Tramo_',num2str(offset_tramo+1+12),nombre);%OJO hasta offset_tramo=99 

    saveas(gcf,myfile);

close all;
end


%FIGURA TODOS LOS TRAMOS para cada medida

nombre='mls_Tramos_1_4_medida_';
nombre='mls_Tramos_5_8_medida_';
nombre='mls_Tramos_9_12_medida_';
nombre='mls_Tramos_13_medida_';
    

k=num_tramos;
m=1;
for jj=1:num_medidas
    h=figure();
    
    set(h,'OuterPosition',[0 0 1900 1050]);%sobremesa
    for ii=1:k

        valor = [jj:num_medidas:num_medidas*num_tramos];
        y=cell2mat(datos(valor(ii),2:end));

        subplot(k,m,ii);
        plot(df(1:length(df)),y(1:length(y)));%,'b','linewidth',2);
        axis([df(1) df(end) min(y) max(y)]);
        grid      
        title(num2str(valor(ii)))
    end
    
    myfile=cat(2,path_resultados,nombre,num2str(jj),'_promedio.jpg');%OJO hasta jj=99  
    saveas(gcf,myfile);

    
end

close all;
    
    




