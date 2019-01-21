function rates = ValidacaoCruzada(X, k, k_folds)

%% Criação dos folds

[k, I] = sort(k,'descend'); % ordenar instancias pela classe
X = X(I, :); % ordenar instancias pela classe

[n_inst, ~] = size(X); % pega o numero de instancias

if k_folds == 0
    k_folds = n_inst;
end

v = zeros(n_inst, 1); % cria um vetor com as folds

% divisão dos folds
for i = 1 : k_folds
    for j = i : k_folds : n_inst
        v(j) = i; % 1 2 3 1 2 3 1 2 3 <-- exemplo k_folds = 3
    end
end

%% Validação Cruzada

rates = zeros(1, k_folds);

for i = 1 : k_folds
    %% Normalização z-score
    X2 = X - repmat(mean(X(v ~= i, :)), n_inst, 1);
    X2 = X2 ./ repmat(std(X2(v ~= i, :)), n_inst, 1);
        
    %% Separação Instancias
    
    Xtreino = X2(v ~= i, :);
    Ytreino = k(v ~= i);
    Xteste = X2(v == i, :);
    
    %% LDA
    
    Yteste = classify(Xteste, Xtreino, Ytreino);
    rates(i) = 100 * sum(Yteste == k(v==i)) / length(Yteste);
    
end

end