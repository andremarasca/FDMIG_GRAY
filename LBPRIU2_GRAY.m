function Saida = LBPRIU2_GRAY(I)

load('LBPRIU2TABLE.mat');

[M, N] = size(I);

% Viz = [-1 -1; -1 0; -1 1; 0 -1; 0 1; 1 -1; 1 0; 1 1];
Viz = [-1 -1; -1 0; -1 1; 0 1; 1 1; 1 0; 1 -1; 0 -1];

Saida = zeros(M, N);

% mapa_andre = [0 0 0 1 1 1 2 2 2 3];


for i = 1 : M
    for j = 1 : N
        for u = 1 : 8
            if 1 <= (i + Viz(u, 1)) && (i + Viz(u, 1)) <= M
                if 1 <= (j + Viz(u, 2)) && (j + Viz(u, 2)) <= N
                    if I(i, j) <= I(i + Viz(u, 1), j + Viz(u, 2))
                        Saida(i, j) = Saida(i, j) + 2^(u - 1);
                    end
                else
                    if I(i, j) <= I(i + Viz(u, 1), j)
                        Saida(i, j) = Saida(i, j) + 2^(u - 1);
                    end
                end
            else
                if 1 <= (j + Viz(u, 2)) && (j + Viz(u, 2)) <= N
                    if I(i, j) <= I(i, j + Viz(u, 2))
                        Saida(i, j) = Saida(i, j) + 2^(u - 1);
                    end
                else
                    Saida(i, j) = Saida(i, j) + 2^(u - 1);
                end
            end
        end
        idx = uint32(Saida(i, j) + 1);
        Saida(i, j) = LBPRIU2(idx);
%             Saida(i, j) = mapa_andre(Saida(i, j) + 1);
    end
end

end