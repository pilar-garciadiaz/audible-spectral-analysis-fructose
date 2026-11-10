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

function [indiv]=evaluacion_individuo(indiv)

global data_train;
global data_test;

global neuron_number;

global ind_contenido;
global ind_long;
global ind_fobj_grupos;
global ind_fobj_indiv;
global ind_fobj_media;
global ind_fobj_min;
global ind_fobj_descarte;
global ind_grupo_descarte;

global num_charact;%la ultima columna NO SE CUENTA, es el campo a predecir

global coord_indiv_asig;
global coord_indiv_grupos;

global num_mean_ELM;

if isempty(indiv)
    disp('ERROR en evaluacion_individuo.m con INDIVIDUO NULO');
    return;
end

% Decodificacion
individuo=indiv{:,ind_contenido};
long_individuo=indiv{:,ind_long};

ptos_asig=individuo(1:long_individuo(coord_indiv_asig));
ptos_grupos=individuo(long_individuo(coord_indiv_asig)+1:end);

if length(ptos_grupos) ~= long_individuo(coord_indiv_grupos)
    disp('ERROR en evaluacion_individuo.m con INDIVIDUO incoherente');
    return;
end

fobj_grupos=zeros(1,length(ptos_grupos));
for ii=1:long_individuo(coord_indiv_grupos)
        
    %ELM 
    m=find(ptos_asig==ptos_grupos(ii));
    m=[(num_charact+1) m];%columna 1=resultados
    
    accu=[];
    for kk=1:num_mean_ELM
        [TY_label,TestingAccuracy]=ELM(data_train(:,m), data_test(:,m),1, neuron_number, 'sig');
        accu(kk)=TestingAccuracy;
    end

    fobj_grupos(ii)=mean(accu);
    
end

% Codificacion
indiv{:,ind_fobj_grupos}=fobj_grupos;
indiv{:,ind_fobj_min}=min(fobj_grupos);

grupo_descarte=[];
if (long_individuo(coord_indiv_grupos)>1)
    [valor,grupo_descarte]=max(fobj_grupos);
    indiv{:,ind_grupo_descarte}=grupo_descarte(1);%indice del array
    indiv{:,ind_fobj_descarte}=valor;
end


valor=fobj_grupos;
if (~isempty(grupo_descarte))
    valor(grupo_descarte(1))=[];
end
indiv{:,ind_fobj_media}=mean(valor);



% minimizar
%indiv{:,ind_fobj_indiv}=min(fobj_grupos);

% maximizar
indiv{:,ind_fobj_indiv}=max(fobj_grupos);
 

