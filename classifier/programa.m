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

%Programa (GGA aplicado a clasificación)

clear all;
close all;

global path_datos;
global path_resultados;

global data;
global data_train;
global data_test;
global data_validate;
global data_train_final;

global neuron_number;

global num_max_gen;
global num_individuos;

global num_campos_poblacion;
global ind_contenido;
global ind_long;
global ind_fobj_grupos;
global ind_fobj_indiv;
global ind_fobj_media;
global ind_fobj_min;
global ind_fobj_descarte;
global ind_grupo_descarte;

global coord_indiv_asig;
global coord_indiv_grupos;

global fobj_mejor;
global fobj_media;

global num_charact;%la ultima columna NO SE CUENTA, es el campo a predecir

global num_min_grupos;
global num_max_grupos;

global probMutacion;
global num_mean_ELM;
global alpha;

global salto_frec;

% salto_frec=0.1682281494140625*100;
salto_frec=2*0.1682281494140625*100;

num_campos_poblacion=8;
ind_contenido=1;
ind_long=2;
ind_fobj_grupos=3;
ind_fobj_indiv=4;
ind_fobj_media=5;
ind_fobj_min=6;
ind_fobj_descarte=7;
ind_grupo_descarte=8;

coord_indiv_asig=1;
coord_indiv_grupos=2;
num_mean_ELM=10;

path_datos='.\Datos\';
path_resultados='.\Resultados\';


nombre='mls_datos_promedio_matriz1.txt';
%nombre='mls_decimas_datos_promedio_matriz1.txt';
% nombre='mls_centesimas_datos_promedio_matriz1.txt';

data_file=cat(2,path_datos,nombre);
fileID = fopen(data_file);
if fileID >= 3
    fclose(fileID);
    data = load(data_file,'-ascii');%puntos=xlsread('Ficheros_entrada','Puntos');
end


nombre='mls_datos_promedio_matriz2.txt';
%nombre='mls_decimas_datos_promedio_matriz2.txt';
% nombre='mls_centesimas_datos_promedio_matriz2.txt';

data_file=cat(2,path_datos,nombre);
fileID = fopen(data_file);
if fileID >= 3
    fclose(fileID);
    data2 = load(data_file,'-ascii');%puntos=xlsread('Ficheros_entrada','Puntos');
end
data=[data;data2];


nombre='mls_datos_promedio_matriz3.txt';
%nombre='mls_decimas_datos_promedio_matriz3.txt';
% nombre='mls_centesimas_datos_promedio_matriz3.txt';

data_file=cat(2,path_datos,nombre);
fileID = fopen(data_file);
if fileID >= 3
    fclose(fileID);
    data2 = load(data_file,'-ascii');%puntos=xlsread('Ficheros_entrada','Puntos');
end
data=[data;data2];


nombre='mls_datos_promedio_matriz4.txt';
%nombre='mls_decimas_datos_promedio_matriz4.txt';
% nombre='mls_centesimas_datos_promedio_matriz4.txt';

data_file=cat(2,path_datos,nombre);
fileID = fopen(data_file);
if fileID >= 3
    fclose(fileID);
    data2 = load(data_file,'-ascii');%puntos=xlsread('Ficheros_entrada','Puntos');
end
data=[data;data2];



% normalizar NO LA PRIMERA COLUMNA
for(ii=2:(size(data,2)))
   Mx(ii)=max(abs(data(:,ii)));
end
for(ii=2:(size(data,2)))
    if Mx(ii)>1
        data(:,ii)= data(:,ii)/Mx(ii);
%     else
%         display(num2str(ii,2));
    end
end

%Eliminar desde la columna 500
data(:,502:end)=[];

[num_data,num_charact]=size(data);

%Primera columna (tipo) pasa a ser la ultima
tipo=data(:,1);
data(:,1)=[];
data(:,num_charact)=tipo;


num_charact=num_charact-1;%la ultima columna NO SE CUENTA, es el campo a predecir


%____________________________________
%COMIENZO DE VALORES PARAMETRIZABLES parte 2 de 2:

training_percent=80;%80;
test_percent=15;
validation_percent=5;

% neuron_number=42;%clasificacion, numero de clases

num_max_gen=50;%100;
num_individuos=50;

num_min_grupos=30;
num_max_grupos=100;%floor(num_charact/10);

probMutacion=0.1;

alpha=0.001;%0.01; %Rango de convergencia

%_______________________________
%FIN DE VALORES PARAMETRIZABLES parte 2 de 2:


if (training_percent + test_percent + validation_percent) > 100
    display('Porcentajes de entrenamiento,prueba y validacion erroneos. Valores por defecto 60,20,20');
    training_percent=80;
    test_percent=10;
    validation_percent=10;
end


max_index_data=zeros(1,3);
max_index_data(1)=floor(num_data*training_percent/100);
max_index_data(2)=max_index_data(1)+floor(num_data*test_percent/100);
max_index_data(3)=max_index_data(2)+floor(num_data*validation_percent/100);
valor=num_data - max_index_data(3);
if (valor~=0)
    max_index_data=max_index_data+valor;
end


%Seleccion ALEATORIA de datos al crear conj de train, test y validation
indices=randperm(num_data);
data_train=data(indices(1:max_index_data(1)),:);
data_test=data(indices((max_index_data(1)+1):max_index_data(2)),:);
data_validate=data(indices((max_index_data(2)+1):end),:);



% sumar test y validation data sets
data_test=[data_test;data_validate];
data_validate=data_test;
data_train_final=data_train;


neuron_number=10%clasificación en 10 tipos



nombre='comparacion.txt';
myfile=cat(2,path_resultados,nombre);
fid = fopen(myfile, 'w+');
fprintf(fid, 'Simul \t NumGen\t T(min) \t Ind0Fit \t Ind0NGrup Fitness\t NGrupos \t RHO^2  \t Convg  \n \n');


pobla_caract=cell(0,2);

for simul=1:10
    disp('Simulation ----------------------------------------------'); 
    simul %#ok<NOPTS>

close all;


start_time=cputime;

% %Seleccion ORDENADA de datos al crear conj de train, test y validation
% data_train=data(1:max_index_data(1),:);
% data_test=data((max_index_data(1)+1):max_index_data(2),:);
% data_validate=data((max_index_data(2)+1):end,:);

%Seleccion ALEATORIA de datos al crear conj de train, test y validation
indices=randperm(num_data);
data_train=data(indices(1:max_index_data(1)),:);
data_test=data(indices((max_index_data(1)+1):max_index_data(2)),:);
data_validate=data(indices((max_index_data(2)+1):end),:);

% sumar test y validation data sets
data_test=[data_test;data_validate];
data_validate=data_test;
data_train_final=data_train;



%Grouping-ELM
[poblacion,individuo0,num_generaciones]=genetico(simul);


%tiempo=etime(clock,tiempo);
end_time=cputime;
tiempo=end_time-start_time;%Calculate CPU time (seconds) spent by ELM predicting the whole testing data

% Comprobar respuesta No vacia
if isempty(poblacion)
    disp('programa.m No se ha ejecutado el algoritmo genetico. Respuesta nula');
    fclose(fid)
    return;
end


%Resultados de la simulación


%Resultados del individuo0
indiv0=individuo0{1,ind_contenido};
long_indiv0=individuo0{1,ind_long};

% Resultados del individuo final
%ordenar poblacion de mejor a peor
fobj=cell2mat(poblacion(:,ind_fobj_indiv));

% minimizar
%[Ri,ni]=sort(fobj);%orden ascendente por defecto

% maximizar
[Ri,ni]=sort(fobj,'descend');

%Decodificación
indivF=poblacion{ni(1),ind_contenido};
long_indivF=poblacion{ni(1),ind_long};

ptos_asig=indivF(1:long_indivF(coord_indiv_asig));
ptos_grupos=indivF(long_indivF(coord_indiv_asig)+1:end);

fobj_grupos=poblacion{ni(1),ind_fobj_grupos};

% minimizar
%[grupo,val]=min(fobj_grupos);

% maximizar
[grupo,val]=max(fobj_grupos);

m=find(ptos_asig==ptos_grupos(val));

if isempty(pobla_caract) %Incluir solucion nueva
    pobla_caract{1,1}=length(m);
    pobla_caract{1,2}=m;
else
    longitudes=cell2mat(pobla_caract(:,1));
    temporal=find(longitudes==length(m));
    if isempty(temporal) %Incluir solucion nueva
        [a,b]=size(pobla_caract);
        pobla_caract{a+1,1}=length(m);
        pobla_caract{a+1,2}=m;
    else  %comparar
        b_found=0;
        for ii=1:length(temporal)
            m_done=pobla_caract{temporal(ii),2};
            conj=ismember(m,m_done);
            if (sum(conj)==length(m))
                b_found=1;
                break;
            end
        end
        if b_found<1
            [a,b]=size(pobla_caract);
            pobla_caract{a+1,1}=length(m);
            pobla_caract{a+1,2}=m;
        end
    end
end

fobj_grupos=poblacion{ni(1),ind_fobj_grupos};

% minimizar
%[grupo,val]=min(fobj_grupos);

% maximizar
[grupo,val]=max(fobj_grupos);

m=find(ptos_asig==ptos_grupos(val));

m=[(num_charact+1) m];%columna 1=resultados
[TY,TestingAccuracy]=ELM(data_train_final(:,m), data_validate(:,m),1, neuron_number, 'sig');
RHO = corr(data_validate(:,end),TY');
R2=RHO^2;

poblacion_winners(simul,:)=poblacion(ni(1),:);



% nombre='result_pv8_b.mat';
nombre='result_pv8_b_';
nombre2=strcat(nombre,num2str(simul,2),'.mat');%OJO hasta simul=99; admite espacios
myfile=cat(2,path_resultados,nombre2);
save(myfile);


%Representacion grafica resumen
x=[1:length(data_validate(:,end))];
figure;
num_graficas=4;
k=floor(sqrt(num_graficas));
m=ceil(num_graficas/k);
for n=1:num_graficas
    subplot(k,m,n);
    if n==1 
        z1=plot([0:num_generaciones],fobj_mejor,'b');
        title('Min. fitness evol.');
        title(cat(2,'Min. fitness evol.; f=',num2str(fobj_mejor(end))));
        xlabel('Generations');
        grid;
    elseif n==2
        z2=plot([0:num_generaciones],fobj_media,'r');
        title('Average fitness evol.');
        title(cat(2,'Average fitness evol.; f=',num2str(fobj_media(end))));
        xlabel('Generations');
        grid;
    elseif n==3
        plot(x',data_validate(:,end),'*r');
        hold on;
        plot(x',TY','+b');%plot(x',TY');
        hold off
        title(cat(2,'RMSE= ',num2str(TestingAccuracy)));
    elseif n==4
        plot(linspace(min([data_validate(:,end);TY']),max([data_validate(:,end);TY']),100),linspace(min([data_validate(:,end);TY']),max([data_validate(:,end);TY']),100),'r','linewidth',2);
        hold on;
        plot(data_validate(:,end),TY','.','MarkerSize',15);
        title(cat(2,'R2= ',num2str(R2)));
        hold off
    end
end
nombre='Resultado_';
myfile=cat(2,path_resultados,nombre);
Name5=strcat(myfile,num2str(simul,2),'.jpg');%OJO hasta simul=99   
saveas(gcf,Name5);



fprintf(fid, '%5.0f\t%5.0f\t%8.6f\t%3.4f\t%3.0f\t%3.4f\t%3.0f\t%2.7f\t%3.8f\n', simul,...
    num_generaciones, tiempo/60, fobj_mejor(1), ...
    long_indiv0(coord_indiv_grupos), fobj_mejor(length(fobj_mejor)), ...
    long_indivF(coord_indiv_grupos),R2, fobj_mejor(end)/fobj_media(end));


end



% Ronda de ganadores
disp('Ronda ganadores ----------------------------------------------'); 

probMutacion=0.2;

%tiempo=clock;
start_time=cputime;


% % %Seleccion ORDENADA de datos al crear conj de train, test y validation
% % data_train=data(1:max_index_data(1),:);
% % data_test=data((max_index_data(1)+1):max_index_data(2),:);
% % data_validate=data((max_index_data(2)+1):end,:);

%Seleccion ALEATORIA de datos al crear conj de train, test y validation
indices=randperm(num_data);
data_train=data(indices(1:max_index_data(1)),:);
data_test=data(indices((max_index_data(1)+1):max_index_data(2)),:);
data_validate=data(indices((max_index_data(2)+1):end),:);

% sumar test y validation data sets
data_test=[data_test;data_validate];
data_validate=data_test;
data_train_final=data_train;

% data_train_final=[data_train; data_test];


% FALTA COMPROBAR
disp('Impone un individo suma de los mejores diferentes: seleccion elitista para CLASIFICACION');
nuevos_ptos_grupos=[1 2];
nuevos_ptos_asig=ones(1,num_charact);

nuevos_m=[];
[a,b]=size(pobla_caract);
for ii=1:a
   m_done=cell2mat(pobla_caract(ii,2));   
   nuevos_m=[nuevos_m m_done];%columna 1=resultados
end
m=unique(nuevos_m);

nuevos_ptos_asig(m)=2;

%Codificacion del individuo (cromosoma)
individuo=[nuevos_ptos_asig,nuevos_ptos_grupos];
long_individuo=[length(nuevos_ptos_asig),length(nuevos_ptos_grupos)];
poblacion_winners{simul+1,ind_contenido}=individuo;
poblacion_winners{simul+1,ind_long}=long_individuo;

poblacion_winners(simul+1,:)=reparacion_individuo(poblacion_winners(simul+1,:));    
poblacion_winners(simul+1,:)=evaluacion_individuo(poblacion_winners(simul+1,:));



[poblacion,individuo0,num_generaciones]=genetico_winners(poblacion_winners);

%tiempo=etime(clock,tiempo);
end_time=cputime;
tiempo=end_time-start_time;  % Calculate CPU time (seconds) spent by ELM predicting the whole testing data

% Comprobar respuesta No vacia
if isempty(poblacion)
    disp('programa.m No se ha ejecutado el algoritmo genetico. Respuesta nula');
    fclose(fid)
    return;
end

%Resultados del individuo0
indiv0=individuo0{1,ind_contenido};
long_indiv0=individuo0{1,ind_long};

% Resultados del individuo final
%ordenar población de mejor a peor
fobj=cell2mat(poblacion(:,ind_fobj_indiv));

% minimizar
%[Ri,ni]=sort(fobj);%orden ascendente por defecto

% maximizar
[Ri,ni]=sort(fobj,'descend');

indivF=poblacion{ni(1),ind_contenido};
long_indivF=poblacion{ni(1),ind_long};

ptos_asig=indivF(1:long_indivF(coord_indiv_asig));
ptos_grupos=indivF(long_indivF(coord_indiv_asig)+1:end);

fobj_grupos=poblacion{ni(1),ind_fobj_grupos};

% minimizar
%[grupo,val]=min(fobj_grupos);

% maximizar
[grupo,val]=max(fobj_grupos);

m=find(ptos_asig==ptos_grupos(val))

%Registrar mejor solucion
if isempty(pobla_caract) %Incluir solucion nueva
    pobla_caract{1,1}=length(m);
    pobla_caract{1,2}=m;
else
    longitudes=cell2mat(pobla_caract(:,1));
    temporal=find(longitudes==length(m));
    if isempty(temporal) %Incluir solucion nueva
        [a,b]=size(pobla_caract);
        pobla_caract{a+1,1}=length(m);
        pobla_caract{a+1,2}=m;
    else  %comparar
        b_found=0;
        for ii=1:length(temporal)
            m_done=pobla_caract{temporal(ii),2};
            conj=ismember(m,m_done);
            if (sum(conj)==length(m))
                b_found=1;
                break;
            end
        end
        if b_found<1
            [a,b]=size(pobla_caract);
            pobla_caract{a+1,1}=length(m);
            pobla_caract{a+1,2}=m;
        end
    end
end

fobj_grupos=poblacion{ni(1),ind_fobj_grupos};

% minimizar
%[grupo,val]=min(fobj_grupos);

% maximizar
[grupo,val]=max(fobj_grupos);

m=[];
m=find(ptos_asig==ptos_grupos(val));

m=[(num_charact+1) m];%columna 1=resultados
[TY,TestingAccuracy]=ELM(data_train_final(:,m), data_validate(:,m),1, neuron_number, 'sig');
RHO = corr(data_validate(:,end),TY');
R2=RHO^2;


nombre='result_win.mat';
myfile=cat(2,path_resultados,nombre);
save(myfile);



%Representacion grafica resumen
x=[1:length(data_validate(:,end))];
figure;
num_graficas=4;
k=floor(sqrt(num_graficas));
mm=ceil(num_graficas/k);
for n=1:num_graficas
    subplot(k,mm,n);
    if n==1 
        z1=plot([0:num_generaciones],fobj_mejor,'b');
        %title('Min. fitness evol.');
        title(cat(2,'Min. fitness evol.; f=',num2str(fobj_mejor(end))));
        xlabel('Generations');
        grid;
    elseif n==2
        z2=plot([0:num_generaciones],fobj_media,'r');
        %title('Average fitness evol.');
        title(cat(2,'Average fitness evol.; f=',num2str(fobj_media(end))));
        xlabel('Generations');
        grid;
    elseif n==3
        plot(x',data_validate(:,end),'*r');%plot(x',final_data_validate(:,end),'*r');
        hold on;
        plot(x',TY','+b');
        hold off
        title(cat(2,'RMSE= ',num2str(TestingAccuracy)));
    elseif n==4
        plot(linspace(min([data_validate(:,end);TY']),max([data_validate(:,end);TY']),100),linspace(min([data_validate(:,end);TY']),max([data_validate(:,end);TY']),100),'r','linewidth',2);
        hold on;        
        plot(data_validate(:,end),TY','.','MarkerSize',15);
        title(cat(2,'R2= ',num2str(R2)));
        hold off
    end
end
nombre='Resultado_winners';
myfile=cat(2,path_resultados,nombre);
%saveas(gcf,myfile);
Name5=strcat(myfile,'.jpg');
saveas(gcf,Name5);

fprintf(fid, '\n\t NumGen\t T(min)\t Ind0Fit\t Ind0NGrup Fitness NGrupos\t RHO^2 \t Convg \t IdGrup \n \n');

% minimizar
%fprintf(fid, 'winner\t%5.0f\t%8.6f\t%3.4f\t%3.0f\t%3.4f\t%3.0f\t%2.7f\t%3.8f\t%4.0f\n\n Asign. Campos \n%4.0f\t%4.0f\t%4.0f\t%4.0f\t%4.0f\t%4.0f\t%4.0f\t%4.0f\t%4.0f\t%4.0f\t%4.0f\t%4.0f\t%4.0f\t%4.0f\t%4.0f\t%4.0f\t%4.0f\t%4.0f\t%4.0f\t%4.0f\t%4.0f\t%4.0f\t%4.0f\t%4.0f\t%4.0f\t%4.0f\t%4.0f\t%4.0f\t%4.0f\t%4.0f\t%4.0f\t%4.0f\t%4.0f\t%4.0f\t%4.0f\t%4.0f\t%4.0f\t%4.0f\t%4.0f\t%4.0f\t%4.0f\t%4.0f\t%4.0f\t%4.0f\t%4.0f\t%4.0f\t%4.0f\t%4.0f\t%4.0f\t%4.0f\t%4.0f\t%4.0f\t%4.0f\t%4.0f\n',...
%     num_generaciones, tiempo/60, fobj_mejor(1), long_indiv0(coord_indiv_grupos), ...
%     min(fobj_grupos), long_indivF(coord_indiv_grupos),R2, ...
%     fobj_mejor(end)/fobj_media(end),ptos_grupos(val),ptos_asig);

% maximizar
fprintf(fid, 'winner\t%5.0f\t%8.6f\t%3.4f\t%3.4f\t%3.4f\t%3.4f\n\n Caracteristicas: \n',...
    num_generaciones, tiempo/60, fobj_mejor(1), fobj_mejor(end),R2, fobj_mejor(end)/fobj_media(end));


%validation

indiv{1,ind_contenido}=poblacion{ni(1),ind_contenido};
indiv{1,ind_long}=poblacion{ni(1),ind_long};

fobj_grupos=poblacion{ni(1),ind_fobj_grupos};

% minimizar
%[grupo,val]=min(fobj_grupos);

% maximizar
[grupo,val]=max(fobj_grupos);


m=find(ptos_asig==ptos_grupos(val));
m=[(num_charact+1) m];%columna 1=resultados


accu=[];
for kk=1:num_mean_ELM
    [TY,TestingAccuracy]=ELM(data_train_final(:,m), data_validate(:,m),1, neuron_number, 'sig');
    accu(kk)=TestingAccuracy;
end
indiv{1,ind_fobj_indiv}=mean(accu);

RHO = corr(data_validate(:,end),TY');
R2=RHO^2;


indiv


nombre='result_validate.mat';
myfile=cat(2,path_resultados,nombre);
save(myfile);

fprintf(fid, '\n Validat \t Fitness \t NGrupos \t RHO^2 \t IdGrup \n \n');

% minimizar
% fprintf(fid, ' --- \t %2.4f\t%4.0f\t%2.5f\t%4.0f\n\n Campos preferentes:\n',...
%     min(fobj_grupos), length(fobj_grupos),R2, ptos_grupos(val));

% maximizar
fprintf(fid, ' --- \t %2.4f\t%4.0f\t%2.5f\t%4.0f\n\n Campos preferentes:\n',...
    max(fobj_grupos), length(fobj_grupos),R2, ptos_grupos(val));



figure;
x=[1:length(data_validate(:,end))];
subplot(1,2,1);
plot(x',data_validate(:,end),'*r');
hold on;
plot(x',TY','+b');
hold off
title(cat(2,'RMSE= ',num2str(TestingAccuracy)));
subplot(1,2,2);
plot(data_validate(:,end),TY','.','MarkerSize',15);
hold on;
plot(linspace(min([data_validate(:,end);TY']),max([data_validate(:,end);TY']),100),linspace(min([data_validate(:,end);TY']),max([data_validate(:,end);TY']),100),'r','linewidth',2);

title(cat(2,'R2= ',num2str(R2)));
hold off

nombre='Resultado_validate';
myfile=cat(2,path_resultados,nombre);

Name5=strcat(myfile,'.jpg');
saveas(gcf,Name5);



[a,b]=size(pobla_caract);
for ii=1:a
   fprintf(fid, '\r\n');
   m_done=cell2mat(pobla_caract(ii,2));
   
   m=[(num_charact+1) m_done];%columna 1=resultados
   [TY,TestingAccuracy]=ELM(data_train_final(:,m), data_validate(:,m),1, neuron_number, 'sig');
    
   RHO = corr(data_validate(:,end),TY');
   R2=RHO^2;
   
   fprintf(fid, '%2.5f\t',R2);
   fprintf(fid, '%6d\t',m_done);
end

for ii=1:a
   fprintf(fid, '\n\n');
   m_done=cell2mat(pobla_caract(ii,2));
   
   m_done=m_done*salto_frec;
   
   fprintf(fid, '%3d\t',m_done);
end

fclose('all');
m_done
