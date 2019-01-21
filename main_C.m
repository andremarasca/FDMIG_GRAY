close all;
close all hidden;
close all force;
clear all;
clc;

% N = 4;
% myCluster=parcluster('local'); 
% myCluster.NumWorkers=N; 
% parpool(myCluster,N)

%% Configurar Constantes

nome_metodo = 'AFDMIGLBPPURO';

load('C:\Users\andre\Google Drive\ArtigosParaPublicar\EDT\ConfiguracoesGerais\Configuracoes.mat');
dir_atual = pwd;

Rmax = 4;
N_Camadas = 96;

% Salvar configuracoes

dir_arquivos = [dir_atual, '\Arquivos'];
if exist(dir_arquivos) % Deletar Pasta, se ela existir
    rmdir(dir_arquivos, 's');
end
mkdir(dir_arquivos);

save([dir_arquivos, '\', 'Configuracoes.mat'], 'Bases_analisadas', 'bases', 'dir_bases', 'nome_metodo');

%% Tipos possiveis de imagens

ti(1).nome = '.png';
ti(2).nome = '.bmp';
ti(3).nome = '.jpg';

%% Análise de textura

for base = Bases_analisadas
    fprintf('Base: %s\n', bases(base).nome);
    dir_base_atual = [dir_bases, '\', bases(base).nome, '\Base\'];
    % Obter imagens de todos os tipos
    files = [];
    for iti = 1 : length(ti)
        files_ti = dir([dir_base_atual, '*', ti(iti).nome]);
        files = [files; files_ti];
    end
    % Criar uma pasta para o DataSet atual
    dir_DataSets_dessa_Base = [dir_atual, '\DataSets\', bases(base).nome];
    if exist(dir_DataSets_dessa_Base) % Deletar Pasta, se ela existir
        rmdir(dir_DataSets_dessa_Base, 's');
    end
    mkdir(dir_DataSets_dessa_Base);
    
    clearvars X;
    parfor x = 1 : length(files)
        I = imread([dir_base_atual files(x).name]);
%         I = rgb2gray(I);        
        X(x, :) = FDMIG_CINZA(double(I), N_Camadas, Rmax);
    end
    % salvar DataSet dentro de sua devida pasta
    nome_Dataset = sprintf('DATASET.mat');
    save([dir_DataSets_dessa_Base, '\', nome_Dataset], 'X');
end