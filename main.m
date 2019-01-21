close all;
close all hidden;
close all force;
clear all;
clc;

% N = 4;
% myCluster=parcluster('local'); 
% myCluster.NumWorkers=N; 
% parpool(myCluster,N)

%% Configurar Bases de Textura

dir_bases = 'C:\FDMIG\Bases';

bases(1).nome = 'Outex';
bases(2).nome = 'Usptex';
bases(3).nome = 'Madeiras';
bases(4).nome = 'Vistex';
bases(5).nome = 'ESPECTROGRAMA';

Bases_analisadas = 5%1 : 4;

kfold = 10;

%% Configurar Parametros do FDMIG

nome_metodo = 'FDMIG';
Rmax = 4;
N_Camadas = 96;


%% Salvar configuracoes

dir_atual = pwd;
dir_arquivos = [dir_atual, '\Arquivos'];
if exist(dir_arquivos) % Deletar Pasta, se ela existir
    rmdir(dir_arquivos, 's');
end
mkdir(dir_arquivos);

save([dir_arquivos, '\', 'Configuracoes.mat'], 'Bases_analisadas', 'bases', 'dir_bases', 'nome_metodo', 'kfold');

%% Tipos possiveis de imagens

ti(1).nome = '.png';
ti(2).nome = '.bmp';
ti(3).nome = '.jpg';

%% Análise de textura

for base = Bases_analisadas
    fprintf('Base: %s\n', bases(base).nome);
    dir_base_atual = [dir_bases, '\', bases(base).nome, '\Base\'];
    % Obter lista de imagens dos tipos armazenados em 'ti'
    files = [];
    for iti = 1 : length(ti)
        files_ti = dir([dir_base_atual, '*', ti(iti).nome]);
        files = [files; files_ti];
    end
    % Criar uma pasta para o DataSet gerado pela base atual
    dir_DataSets_dessa_Base = [dir_atual, '\DataSets\', bases(base).nome];
    if exist(dir_DataSets_dessa_Base) % Deletar Pasta, se ela existir
        rmdir(dir_DataSets_dessa_Base, 's');
    end
    mkdir(dir_DataSets_dessa_Base);
    % Processar imagem por imagem gerando o dataset
    clearvars X;
    for x = 1 : length(files)
        I = imread([dir_base_atual files(x).name]);
        if length(size(I)) >= 3
            I = rgb2gray(I);       
        end
        X(x, :) = FDMIG_GRAY(double(I), N_Camadas, Rmax);
    end
    % salvar DataSet dentro de sua devida pasta
    nome_Dataset = sprintf('DATASET.mat');
    save([dir_DataSets_dessa_Base, '\', nome_Dataset], 'X');
end