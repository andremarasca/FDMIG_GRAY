close all;
close all hidden;
close all force;
clear all;
clc;
%% Definicoes iniciais

dir_atual = pwd;
dir_arquivos = [dir_atual, '\Arquivos'];
load([dir_arquivos, '\', 'Configuracoes.mat']);

%%

n_res = 1;
for base = Bases_analisadas
    fprintf('Base: %s\n', bases(base).nome);
    dir_principal_base_atual = [dir_bases, '\', bases(base).nome];
    % Criar uma pasta para o DataSet atual
    dir_DataSets_dessa_Base = [dir_atual, '\DataSets\', bases(base).nome];
    % Para cada numero de camadas
    
    res(n_res).nome_base = bases(base).nome;
    
    
    disp(dir_DataSets_dessa_Base);
    nome_Dataset = sprintf('DATASET.mat');
    load([dir_DataSets_dessa_Base, '\', nome_Dataset]);
    load([dir_principal_base_atual, '\class', bases(base).nome, '.mat']);
    
    Y = k;
       
    [n_inst, n_atrib] = size(X);
    Rates = ValidacaoCruzada(X, Y, kfold);
    Rate = mean(Rates);
    Desvio = std(Rates);
    
    fprintf('%s -> [%.2f %c %.2f] (%d)\n', bases(base).nome, Rate, char(177), Desvio, n_atrib);
        
    res(n_res).res.RateMax = Rate;
    res(n_res).res.Desvio = Desvio;
    res(n_res).res.n_atrib_RateMax = n_atrib;
    res(n_res).res.Rates = Rates;

    n_res = n_res + 1;
end

save([dir_arquivos, sprintf('/%s_RelatorioAcuracia.mat', nome_metodo)], 'res', 'kfold', 'nome_metodo');