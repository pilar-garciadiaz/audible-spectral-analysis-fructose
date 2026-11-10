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

function promedio_datos()

global datos;
global average_points_num;

[fil,col]=size(datos);

new_points=floor((col-1)/average_points_num);

resto=col-1-(new_points*average_points_num);
if resto>1
    disp(resto)
end

new_datos=cell(fil,new_points+1);

for ii=1:fil
    
    new_datos{ii,1}=datos{ii,1};
    valores_curva=cell2mat(datos(ii,2:col));
    
    salto=average_points_num;
    for jj=1:new_points-resto
        %((jj-1)*salto)+1
        %valores_curva( ((jj-1)*salto)+1:jj*salto  )
        
        valor=mean( valores_curva( ((jj-1)*salto)+1:jj*salto  ) );
        %valor=median( valores_curva( ((jj-1)*salto)+1:jj*salto  ) );
        %valor=mode( valores_curva( ((jj-1)*salto)+1:jj*salto  ) );
        new_datos{ii,jj+1}=valor;
    end
    
    valor_inicio=average_points_num*(new_points-resto)+1;
    salto=average_points_num;
    for jj=(new_points-resto+1):new_points
        %valor_inicio
        %valores_curva(valor_inicio:valor_inicio+salto)
        
        valor=mean(valores_curva(valor_inicio:valor_inicio+salto));
        %valor=median(valores_curva(valor_inicio:valor_inicio+salto));
        %valor=mode(valores_curva(valor_inicio:valor_inicio+salto));
        
        
        valor_inicio=valor_inicio+salto+1;
        
        new_datos{ii,jj+1}=valor;
    end
end

datos=[];
datos=new_datos;