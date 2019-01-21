function Atributos = FDMIG_GRAY(I, N_Camadas, Rmax)

[M, N] = size(I);

LBP_CODIGOS = uint32(LBPRIU2_GRAY(I));

N_labels = 10;

X = zeros(M * N, 1);
Y = zeros(M * N, 1);
Z = zeros(M * N, 1);
Lab = zeros(M * N, 1);

u = 1;
for i = 1 : M
    for j = 1 : N
        X(u, 1) = i - 1;
        Y(u, 1) = j - 1;
        Z(u, 1) = I(i, j) / 255.0;
        Lab(u, 1) = bitshift(1, LBP_CODIGOS(i, j)); % 10 bits
        u = u + 1;
    end
end

Camadas = N_Camadas;
Z = Z * (Camadas - 1);
Z = Z - min(Z(:));
Camadas = max(Z(:)) + 1;

Atributos = EDT_FRACTAL(double(X), double(Y), double(Z), double(Lab), [M, N, Camadas], Rmax, N_labels);

end
