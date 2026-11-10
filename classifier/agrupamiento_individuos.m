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
% [ZENODO VERSION DOI TO BE ADDED]
%
% Author:
% Pilar Garcia Diaz, Universidad de Alcala
% ORCID: https://orcid.org/0000-0002-5361-6947

function grupos=agrupamiento_individuos(num_total,num_grupos, num_ind_grupo,repetir_ind)
% Formar grupos de individuos
% grupos es una matriz nxm siendo 
%                   n el num_grupos (núm. de grupos)
%                   m el num_ind_grupo (núm. indiv en cada grupo)
% repetir_ind = 1 CON REPETICIONES ENTRE GRUPOS Y DENTRO DE LOS GRUPOS,
%                 un individuo puede partircipar en varios grupos y 
%                 puede haber dobles en un mismo grupo
% repetir_ind = 2 REPETICIONES ENTRE GRUPOS,
%                 un individuo puede partircipar en varios grupos pero
%                 NO puede haber dobles en un mismo grupo
% repetir_ind = 3 SIN REPETICIONES, 
%                 un individuo participa UNA sola vez entre todos los grupos
%                 y sin dobles


if num_ind_grupo>num_total 
    num_ind_grupo=num_total;
end

n=num_grupos;

switch repetir_ind
case 1
    grupos=floor(rand(n,num_ind_grupo)*num_total+1);
case 2% En un grupo NO puede haber individuos repetidos
    grupos=floor(rand(n,num_ind_grupo)*num_total+1);
    for g=1:n
        while (length(unique(grupos(g,:))) < num_ind_grupo)
            for i=1:num_ind_grupo
                test=find(grupos(g,:)==grupos(g,i));
                valor=length(test);
                if valor>1
                    grupos(g,test(2:valor))=floor(rand(1,valor-1)*num_total+1);
                end
                if (length(unique(grupos(g,:))) >= num_ind_grupo)
                    break;%for
                end
            end 
        end
    end       
case 3
    if num_grupos*num_ind_grupo > num_total
        n=floor(num_total/num_ind_grupo);
    else
        n=num_grupos;
    end
    grupos=zeros(n,num_ind_grupo);
    participantes=1:num_total;
    for i=1:n
        for j=1:num_ind_grupo
            indice=floor(rand*length(participantes)+1);
            grupos(i,j)=participantes(indice);
            participantes(indice)=[];
        end
    end
end
