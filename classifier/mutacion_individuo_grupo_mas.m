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

function [indiv]=mutacion_individuo_grupo_mas(indiv)
%necesita reparacion+evaluacion posterior

global ind_contenido;
global ind_long;

global coord_indiv_asig;
global coord_indiv_grupos;

global num_max_grupos;
global num_charact;%la ultima columna NO SE CUENTA, es el campo a predecir


indiv=reparacion_individuo(indiv);        


%Decodificacion
individuo=indiv{:,ind_contenido};
long_individuo=indiv{:,ind_long};

ptos_asig=individuo(1:long_individuo(coord_indiv_asig));
ptos_grupos=individuo(long_individuo(coord_indiv_asig)+1:end);

long_individuo(coord_indiv_grupos)=long_individuo(coord_indiv_grupos)+1;
ptos_grupos_new=1:long_individuo(coord_indiv_grupos);%nuevos identificadores de grupos en orden creciente
ptos_asig_new=ptos_asig;
for ii=1:(long_individuo(coord_indiv_grupos)-1)
    m=find(ptos_asig==ptos_grupos(ii));
    ptos_asig_new(m)=ptos_grupos_new(ii);
end

num=ceil(rand()*((num_charact/num_max_grupos)+1));
m=ceil(rand(1,num)*long_individuo(coord_indiv_asig));
ptos_asig_new(m)=ptos_grupos_new(end);


%Codificacion
individuo=[ptos_asig_new,ptos_grupos_new];
indiv{:,ind_contenido}=individuo;
indiv{:,ind_long}=long_individuo;

%necesita reparacion+evaluacion posterior
