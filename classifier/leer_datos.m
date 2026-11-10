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

function leer_datos()

global path_datos;
global data;


%Lectura de datos, conjuntos training, test, validation
nombre='praat.txt';


data_file=cat(2,path_datos,nombre);
fileID = fopen(data_file,'rt');
if fileID >= 3
    %primeras 3 lineas sin contenido: File type = "ooTextFile"; Objectclass = "Collection"; ;
    for contador=1:3    
        tline=fgetl(fileID);      
        if ~ischar(tline), break, end
    end
    
    tline=fgetl(fileID);
    num_medidas=str2double(tline);
    
    %Bloque1 = 1 linea + Identificador + 2 lineas + num. valores + salto frec + 6 lineas + datos
    fila =1;
    tline=fgetl(fileID);% "Ltas 2"
    tline=fgetl(fileID);
    id_medida=tline(2:end-1)
    tline=fgetl(fileID);% linea "0"
    tline=fgetl(fileID);% linea "48000"
    tline=fgetl(fileID);% 1 linea
    num_bandas=str2double(tline);
    
   
    
    datos=cell(num_medidas,num_bandas+2);%2=id_medida, id_muestra
    
    datos{fila,1}=id_medida;
    

    
    tline=fgetl(fileID);% 1 linea
    salto_frec=str2double(tline);
    %siguientes 6 lineas sin contendo: 50;1;1;1;1;1
    for contador=1:6  
        tline=fgetl(fileID);       
        if ~ischar(tline), break, end
    end
    
    for contador=1:num_bandas
         tline=fgetl(fileID);
         datos{fila,contador+1}=str2double(tline);
    end
    
    %Cepstral smoothing añade el doble de valores (nulos)
    for contador=1:num_bandas
         tline=fgetl(fileID);
    end
    
    k = strfind(id_medida,'_');
    if isempty(k)
        disp('error leer_datos');
        fclose(fileID);
        return;
    end        
    datos{fila,num_bandas+2}=str2double(id_medida(1:k(1)-1));%id_medida(k(1)+1:end)
    
    
    %Segundo bloque y siguientes
    for fila=2:num_medidas
        tline=fgetl(fileID);% "Ltas 2"
        tline=fgetl(fileID);
        id_medida=tline(2:end-1)
        %siguientes 10 lineas sin contendo: 0;480000;480;100;50;1;1;1;1;1
        for contador=1:10  
            tline=fgetl(fileID);       
            if ~ischar(tline), break, end
        end
        datos{fila,1}=id_medida;


        for contador=1:num_bandas
         tline=fgetl(fileID);
         datos{fila,contador+1}=str2double(tline);
        end
        
        %Cepstral smoothing añade el doble de valores (nulos)
        for contador=1:num_bandas
             tline=fgetl(fileID);
        end        
        
        k = strfind(id_medida,'_'); 
        if isempty(k)
            disp('error leer_datos');
            fclose(fileID);
            break;
        end    
        datos{fila,num_bandas+2}=str2double(id_medida(1:k(1)-1));
        
    end
    
    fclose(fileID);
    
    data=cell2mat(datos(:,2:end));
       
    
end

datos=[];

