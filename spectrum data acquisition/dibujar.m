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
path_resultados='.\Resultados\';


datos=[];
average_points_num=100;


num_tramos=4
num_tramos=1%para la medida 13



% num_medidas=10 % Para unidades
num_medidas=11   % Para decimas y centesimas



%df=1:(length(datos)-1);

for num_sufijo=1:num_tramos
    
    close all;
    
    switch num_sufijo
        case 1
            
%             sufijo='mls_0_9gr_part_2_4s_smooth.txt'
%             sufijo='mls_0_9gr_part_10_12s_smooth.txt'
%             sufijo='mls_0_9gr_part_18_20s_smooth.txt'
%             sufijo='mls_0_9gr_part_26_28s_smooth.txt'

%             sufijo='mls_2_3gr_decimas_part_2_4s_smooth.txt'
%             sufijo='mls_2_3gr_decimas_part_10_12s_smooth.txt'
%             sufijo='mls_2_3gr_decimas_part_18_20s_smooth.txt'
%             sufijo='mls_2_3gr_decimas_part_26_28s_smooth.txt'
            
            sufijo='mls_2_2_1gr_centesimas_part_2_4s_smooth.txt'
            sufijo='mls_2_2_1gr_centesimas_part_10_12s_smooth.txt'
            sufijo='mls_2_2_1gr_centesimas_part_18_20s_smooth.txt'
            sufijo='mls_2_2_1gr_centesimas_part_26_28s_smooth.txt'            
            
        case 2
           
%             sufijo='mls_0_9gr_part_4_6s_smooth.txt'
%             sufijo='mls_0_9gr_part_12_14s_smooth.txt'
%             sufijo='mls_0_9gr_part_20_22s_smooth.txt'

%             sufijo='mls_2_3gr_decimas_part_4_6s_smooth.txt'
%             sufijo='mls_2_3gr_decimas_part_12_14s_smooth.txt'
%             sufijo='mls_2_3gr_decimas_part_20_22s_smooth.txt'

            sufijo='mls_2_2_1gr_centesimas_part_4_6s_smooth.txt'
            sufijo='mls_2_2_1gr_centesimas_part_12_14s_smooth.txt'
            sufijo='mls_2_2_1gr_centesimas_part_20_22s_smooth.txt'


        case 3
            
%             sufijo='mls_0_9gr_part_6_8s_smooth.txt'
%             sufijo='mls_0_9gr_part_14_16s_smooth.txt'
%             sufijo='mls_0_9gr_part_22_24s_smooth.txt'

%             sufijo='mls_2_3gr_decimas_part_6_8s_smooth.txt'
%             sufijo='mls_2_3gr_decimas_part_14_16s_smooth.txt'
%             sufijo='mls_2_3gr_decimas_part_22_24s_smooth.txt'

            sufijo='mls_2_2_1gr_centesimas_part_6_8s_smooth.txt'
            sufijo='mls_2_2_1gr_centesimas_part_14_16s_smooth.txt'
            sufijo='mls_2_2_1gr_centesimas_part_22_24s_smooth.txt'

            
        case 4
            
%             sufijo='mls_0_9gr_part_8_10s_smooth.txt'
%             sufijo='mls_0_9gr_part_16_18s_smooth.txt'
%             sufijo='mls_0_9gr_part_24_26s_smooth.txt'

%             sufijo='mls_2_3gr_decimas_part_8_10s_smooth.txt'
%             sufijo='mls_2_3gr_decimas_part_16_18s_smooth.txt'
%             sufijo='mls_2_3gr_decimas_part_24_26s_smooth.txt'

            sufijo='mls_2_2_1gr_centesimas_part_8_10s_smooth.txt'
            sufijo='mls_2_2_1gr_centesimas_part_16_18s_smooth.txt'
            sufijo='mls_2_2_1gr_centesimas_part_24_26s_smooth.txt'


    end
    
    nombre_datos=cat(2,path_datos,sufijo);
    
    
    
    %Para unidades
%     leer_datos(nombre_datos); 
    %Para decimas y centesimas
    leer_datos_unsorted_measures(nombre_datos); 
    
    
    
    
    df=1:(length(datos)-1);
    offset_tramo=num_sufijo-1;

    %FIGURA CON TODAS LAS MEDIDAS DE UN TRAMO
    h=figure(1);
    set(h,'Name','Resultado_todos')
    set(h,'OuterPosition',[0 0 1650 1000]);%portatil
    %set(h,'OuterPosition',[0 0 1900 1050]);%sobremesa
    
    
    
    m=5%para 10 medidas (unidades)
    m=6%para 11 medidas (decimas y centesimas)
    
    
    
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

%     nombre='_0_9gr.jpg';
%     nombre='_2_3gr_decimas.jpg';
    nombre='_2_2_1gr_centesimas.jpg';
    

      
    myfile=cat(2,path_resultados,'mls_Tramo_',num2str(num_sufijo),nombre);%OJO hasta num_sufijo=99
    myfile=cat(2,path_resultados,'mls_Tramo_',num2str(num_sufijo+4),nombre);%OJO hasta num_sufijo=99
    myfile=cat(2,path_resultados,'mls_Tramo_',num2str(num_sufijo+8),nombre);%OJO hasta num_sufijo=99
    myfile=cat(2,path_resultados,'mls_Tramo_',num2str(num_sufijo+12),nombre);%OJO hasta num_sufijo=99

    
    
    saveas(gcf,myfile);

end

%FIGURA VARIOS TRAMOS para cada medida

%     nombre='Chirp_Tramos_1_4_medida_';
%     nombre='Chirp_Tramos_5_8_medida_';
%     nombre='Chirp_Tramos_9_12_medida_';
    
    nombre='mls_Tramos_1_4_medida_';
    nombre='mls_Tramos_5_8_medida_';
    nombre='mls_Tramos_9_12_medida_';
    nombre='mls_Tramos_13_medida_';
    
    k=num_tramos;
    m=1;
    for jj=1:num_medidas
        h=figure();
        set(h,'OuterPosition',[0 0 1650 1000]);%;portatil
        %set(h,'OuterPosition',[0 0 1900 1050]);%sobremesa
        for ii=1:k

            valor = [jj:num_medidas:num_medidas*num_tramos];
            y=cell2mat(datos(valor(ii),2:end));

            subplot(k,m,ii);
            plot(df(1:length(df)),y(1:length(y)));%,'b','linewidth',2);
            axis([df(1) df(end) min(y) max(y)]);
            %legend('1',num2str(vector(ii)));
            grid      
            title(num2str(valor(ii)))
        end
        
        myfile=cat(2,path_resultados,nombre,num2str(jj),'.jpg');%OJO hasta simul=99   
        saveas(gcf,myfile);
 
    end
    
    close all;



% Grabar datos

% nombre='mls_datos_matriz1.txt';
% nombre='mls_datos_matriz2.txt';
% nombre='mls_datos_matriz3.txt';
% nombre='mls_datos_matriz4.txt';

% nombre='mls_decimas_datos_matriz1.txt';
% nombre='mls_decimas_datos_matriz2.txt';
% nombre='mls_decimas_datos_matriz3.txt';
% nombre='mls_decimas_datos_matriz4.txt';

nombre='mls_centesimas_datos_matriz1.txt';
nombre='mls_centesimas_datos_matriz2.txt';
nombre='mls_centesimas_datos_matriz3.txt';
nombre='mls_centesimas_datos_matriz4.txt';


myfile=cat(2,path_resultados,nombre);

fid = fopen(myfile, 'w+');
if fid < 3
    disp('Error al abrir archivo datos_matriz.txt');
    return
end

datos_matriz=cell2mat(datos);    
dlmwrite(myfile,datos_matriz,'delimiter','\t','precision',18);
fclose(fid);


