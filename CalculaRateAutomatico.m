close all;
close all hidden;
close all force;
clear all;
clc;

dir_relatorio = 'C:\Users\andre\Google Drive\ArtigosParaPublicar\EDT\Latex\Relatorios\';
dir_relatorio(dir_relatorio == '\') = '/';

%% Definicoes iniciais

dir_atual = pwd;
dir_arquivos = [dir_atual, '\Arquivos'];
load([dir_arquivos, '\', 'Configuracoes.mat']);
load('C:\Users\andre\Google Drive\ArtigosParaPublicar\EDT\ConfiguracoesGerais\Configuracoes.mat');

%% Se precisar analisar forcadamente

% Bases_analisadas = 4%[3, 4, 5, 7];%1 : 5; % 1 : length(bases)

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
    
    Y = k';
       
    [n_inst, n_atrib] = size(X);
    Rates = ValidacaoCruzada(X, Y, kfold);
    Rate = mean(Rates);
    Desvio = std(Rates);
    
    fprintf('MAX -> %s -> [%.2g %c %.2g] (%g)\n', bases(base).nome, Rate, char(177), Desvio, n_atrib);
        
    res(n_res).res.RateMax = Rate;
    res(n_res).res.Desvio = Desvio;
    res(n_res).res.n_atrib_RateMax = n_atrib;
    res(n_res).res.Rates = Rates;

    n_res = n_res + 1;
end

save([dir_arquivos, sprintf('%s.mat', nome_metodo)], 'res', 'kfold', 'nome_metodo');