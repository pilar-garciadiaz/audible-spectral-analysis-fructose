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

function [indiv]=mutacion_individuo_adyacentes(indiv)
% Mutacion añadiendo característica anterior y posterior de cada
% característica del mejor grupo
% NECESITA REPARACION Y EVALUACION

global ind_contenido;
global ind_long;
global ind_fobj_grupos;

global coord_indiv_asig;
global coord_indiv_grupos;

global num_charact;%la ultima columna NO SE CUENTA, es el campo a predecir

indiv=reparacion_individuo(indiv);        
indiv=evaluacion_individuo(indiv);

%Decodificacion
individuo1=indiv{:,ind_contenido};
long_individuo1=indiv{:,ind_long};

ptos_asig_indiv1=individuo1(1:long_individuo1(coord_indiv_asig));
ptos_grupos_indiv1=individuo1(long_individuo1(coord_indiv_asig)+1:end);

%Seleccionar el mejor grupo del individuo
fobj_grupos=indiv{:,ind_fobj_grupos};
grupo_interes_1=[];
if (long_individuo1(coord_indiv_grupos)>1)
     
    % minimizar
    
    % maximizar
    [valor,grupo_interes_1]=max(fobj_grupos);


m=find(ptos_asig_indiv1==grupo_interes_1);
%aleatorio
indices=randperm(length(m));
m=m(indices(1:uint8(length(indices)/5)));

new_m=[];
for ii=1:length(m)
    if m(ii)-1 > 0
        new_m=[new_m m(ii)-1];
    end
    if m(ii)+1 < long_individuo1(coord_indiv_asig)
        new_m=[new_m m(ii)+1];
    end
end
%actualizar m
m=find(ptos_asig_indiv1==grupo_interes_1);
new_m=[new_m m];
m = unique(new_m);

ptos_asig_indiv1(m)=grupo_interes_1;

end

%Codificacion del descendiente
descendiente=[ptos_asig_indiv1,ptos_grupos_indiv1];
indiv{:,ind_contenido}=descendiente;
%no importa el resto, se actualiza en evaluacion
