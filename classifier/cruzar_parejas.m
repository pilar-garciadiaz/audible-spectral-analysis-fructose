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

function descendencia=cruzar_parejas(parejas,poblacion,num_generaciones)
% Se genera un solo individuo por cada pareja cruzada: INCLUYE MUTACIÓN Y REPARACIÓN

global num_max_gen;

global num_campos_poblacion;

global probMutacion;


n_indiv=size(poblacion);
n_indiv=n_indiv(1);
if ~isempty(find(parejas>n_indiv,1))
    disp('ERROR en cruzar_parejas.m padre no encontrado en la población de núm. de individuos: ');n_indiv %#ok<NOPRT>
end

num_parejas=length(parejas(:,1));
descendencia=cell(num_parejas,num_campos_poblacion);

prob_mutar=rand(num_parejas,1);

for n=1:num_parejas
    
    indiv1=poblacion(parejas(n,1),:);
    indiv2=poblacion(parejas(n,2),:);
   
    if num_generaciones<(num_max_gen*0.6)
        descen=cruce_individuos(indiv1,indiv2);
    else
        if rand()<0.5
            descen=cruce_individuos(indiv1,indiv2);
        else
            descen=cruce_individuos_suma(indiv1,indiv2);
        end
    end
        
    
    if (prob_mutar(n)<=probMutacion)
        descen=reparacion_individuo(descen);%lo hace en mutaciones      
        descen=evaluacion_individuo(descen);%lo hace en mutaciones
            
        valor=rand();
        if valor<0.1
            descen=mutacion_individuo(descen);
        elseif valor<0.4
            descen=mutacion_individuo_adyacentes(descen);
        elseif valor<0.9
            descen=mutacion_individuo_banda_elim(descen);
        else                
            descen=mutacion_individuo_grupo_menos(descen);
        end
        
    end

    descen=reparacion_individuo(descen);        
    descen=evaluacion_individuo(descen);
    
    descendencia(n,:)=descen;
end
