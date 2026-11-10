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

function [poblacion,individuo0,num_generaciones]=genetico_winners(poblacion)

global num_individuos;

global ind_contenido;
global ind_long;
global ind_fobj_grupos;
global ind_fobj_indiv;
global ind_fobj_media;
global ind_fobj_min;
global ind_fobj_descarte;
global ind_grupo_descarte;

global coord_indiv_asig;


global num_max_gen;

global path_resultados;

global alpha;

global fobj_mejor;
global fobj_media;


num_generaciones=0;
pobla_caract_g=cell(0,3);% registro de las mejores soluciones

tiempo=clock;

fobj=cell2mat(poblacion(:,ind_fobj_indiv));

fobj_mejor=min(fobj);
fobj_media=mean(fobj);

if (isempty(poblacion))
    disp('ERROR en genetico_winners.m Poblacion inicial nula.');
    return; 
end


% individuo0= Mejor individuo población inicial
%ordenar población de mejor a peor
fobj=cell2mat(poblacion(:,ind_fobj_indiv));

% minimizar
%[Ri,ni]=sort(fobj);%orden ascendente por defecto

% maximizar
[Ri,ni]=sort(fobj,'descend');

individuo0{1,ind_contenido}=poblacion{ni(1),ind_contenido};
individuo0{1,ind_long}=poblacion{ni(1),ind_long};
individuo0{1,ind_fobj_grupos}=poblacion{ni(1),ind_fobj_grupos};
individuo0{1,ind_fobj_indiv}=Ri(1);
individuo0{1,ind_fobj_media}=poblacion{ni(1),ind_fobj_media};
individuo0{1,ind_fobj_min}=poblacion{ni(1),ind_fobj_min};
individuo0{1,ind_fobj_descarte}=poblacion{ni(1),ind_fobj_descarte};
individuo0{1,ind_grupo_descarte}=poblacion{ni(1),ind_grupo_descarte};


while (fobj_media(num_generaciones+1) > fobj_mejor(num_generaciones+1)*(1+alpha))||(num_generaciones<num_max_gen)
    
    tiempo_gen=clock;
    
	% Formación de parejas
	n_indiv_ini=size(poblacion);
    n_indiv_ini=n_indiv_ini(1);
    parejas=agrupamiento_individuos(n_indiv_ini,floor(n_indiv_ini/2),2,3);%sin repeticiones
	
	

	% Cruzar parejas
	descendencia=cruzar_parejas(parejas,poblacion,num_generaciones);

        
	% Generación de la poblacion temporal
    if isempty(descendencia)
        poblacion_temporal=poblacion;	    
    else
        poblacion_temporal=[poblacion; descendencia];
    end
    tam_poblacion_temporal=size(poblacion_temporal);
    tam_poblacion_temporal=tam_poblacion_temporal(1);

    
    fobj=cell2mat(poblacion_temporal(:,ind_fobj_indiv));
    
    % minimizar
    %[Ri,ni]=sort(fobj);%orden ascendente por defecto

    % maximizar
    [Ri,ni]=sort(fobj,'descend');
    
    %Selección por torneo
    grupos=agrupamiento_individuos(tam_poblacion_temporal,num_individuos,2,2);%con repeticiones entre grupos
   
    num_grupos=length(grupos(:,1));

    if num_individuos>tam_poblacion_temporal
        seleccion=1:tam_poblacion_temporal;
        indice_elitista=tam_poblacion_temporal+1;
    else
        seleccion=zeros(num_individuos,1);
        for n=1:num_grupos%num_individuos
            if fobj(grupos(n,1))<=fobj(grupos(n,2))
                seleccion(n)=grupos(n,1);
            else
                seleccion(n)=grupos(n,2);
            end
        end
        
    
        %Completar (agrupamiento sin repeticiones)
        diferencia=num_individuos-num_grupos;
        if diferencia>0
            intervalo1=(num_grupos+1):num_individuos;
            intervalo2=1:diferencia;
            seleccion(intervalo1)=ni(intervalo2);%ni=(poblacion+descendencia)
        else
            diferencia=0;
        end

        %Cambiar individuos repetidos    
        indice_elitista=diferencia+1;

        while (length(unique(seleccion))<num_individuos)
            for i=1:num_individuos
                test=find(seleccion==seleccion(i));
                valor=length(test);
                if valor>1%cambiar individuos repetidos
                    intervalo=indice_elitista:(indice_elitista+valor-2);
                    seleccion(test(2:valor))=ni(intervalo);
                    indice_elitista=indice_elitista+valor-1;
                end
                if (length(unique(seleccion)) >= num_individuos)
                    break;%for
                end
            end 
        end
    end
    
    
    for n=1:min(num_individuos,tam_poblacion_temporal)
        poblacion{n,ind_contenido}=poblacion_temporal{seleccion(n),ind_contenido};
        poblacion{n,ind_long}=poblacion_temporal{seleccion(n),ind_long};
        poblacion{n,ind_fobj_grupos}=poblacion_temporal{seleccion(n),ind_fobj_grupos};
        poblacion{n,ind_fobj_indiv}=fobj(seleccion(n));
        poblacion{n,ind_fobj_media}=poblacion_temporal{seleccion(n),ind_fobj_media};
        poblacion{n,ind_fobj_min}=poblacion_temporal{seleccion(n),ind_fobj_min};
        poblacion{n,ind_fobj_descarte}=poblacion_temporal{seleccion(n),ind_fobj_descarte};
        poblacion{n,ind_grupo_descarte}=poblacion_temporal{seleccion(n),ind_grupo_descarte};
    end
    


    fobj=cell2mat(poblacion(:,ind_fobj_indiv));
    
    % minimizar
    %[Ri_poblacion,ni_poblacion]=sort(fobj);%orden ascendente por defecto

    % maximizar
    [Ri_poblacion,ni_poblacion]=sort(fobj,'descend');
    
    fobj_mejor=[fobj_mejor Ri_poblacion(1)];
    fobj_media=[fobj_media mean(Ri_poblacion)];

    tiempo_gen=etime(clock,tiempo_gen);     
    if tiempo/60 > 1   
       disp('Tiempo total de generacion (minutos)');tiempo_gen/60 %#ok<NOPRT>
    end

  
        Ri_poblacion(1)
       
    
        %Decodificación
        indivF=poblacion{ni_poblacion(1),ind_contenido};
        long_indivF=poblacion{ni_poblacion(1),ind_long};

        ptos_asig=indivF(1:long_indivF(coord_indiv_asig));
        ptos_grupos=indivF(long_indivF(coord_indiv_asig)+1:end);

        fobj_grupos=poblacion{ni_poblacion(1),ind_fobj_grupos};

        % minimizar
        %[grupo,val]=min(fobj_grupos);

        % maximizar
        [grupo,val]=max(fobj_grupos);
        
        
        m=find(ptos_asig==ptos_grupos(val))

        
        
  %Registro de las mejores soluciones de cada generacion
        if isempty(pobla_caract_g) %Incluir solucion nueva
            pobla_caract_g{1,1}=Ri_poblacion(1);
            pobla_caract_g{1,2}=length(m);
            pobla_caract_g{1,3}=m;
        else
            longitudes=cell2mat(pobla_caract_g(:,2));
            temporal=find(longitudes==length(m));
            if isempty(temporal) %Incluir solucion nueva
                [a,b]=size(pobla_caract_g);
                pobla_caract_g{a+1,1}=Ri_poblacion(1);
                pobla_caract_g{a+1,2}=length(m);
                pobla_caract_g{a+1,3}=m;
            else  %comparar
                b_found=0;
                for ii=1:length(temporal)
                    m_done=pobla_caract_g{temporal(ii),3};
                    conj=ismember(m,m_done);
                    if (sum(conj)==length(m))
                        b_found=1;
                        break;
                    end
                end
                if b_found<1
                    [a,b]=size(pobla_caract_g);
                    pobla_caract_g{a+1,1}=Ri_poblacion(1);
                    pobla_caract_g{a+1,2}=length(m);
                    pobla_caract_g{a+1,3}=m;
                end
            end
        end        
    %end
    
    num_generaciones=num_generaciones+1; %#ok<NOPRT>
    if num_generaciones==num_max_gen
        break;
    end
end

nombre='Resul_inter_componentes.txt';
myfile=cat(2,path_resultados,nombre);
fid = fopen(myfile, 'a');%Open or create new file for writing. Append data to the end of the file.
if fid < 3
    disp('ERROR al abrir Resul_inter_componentes.txt');
end

t = datetime('now');
DateString = datestr(t);
fprintf(fid, '\n\n\n\n%s\tsimulacion WINNERS \n%s\n', DateString);

[a,b]=size(pobla_caract_g);
for ii=1:a
    fprintf(fid, '\n%1.4f\t%3d\n',pobla_caract_g{ii,1},pobla_caract_g{ii,2});
    m=pobla_caract_g{ii,3};
    fprintf(fid, '%3d\t',m);
    fprintf(fid,'\n');
end

fclose(fid)
