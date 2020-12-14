%% Script que importa los datos procesados por el filtro implementado en la 
% FPGA y los compara con los filtrados idealmente

% Importar ficheros .dat

data_out_FPGA_HP = load('../../output_data/sample_out_haha_HP.dat')./127;
data_out_FPGA_LP = load('../../output_data/sample_out_haha_LP.dat')./127;

% Tratar datos originales

[data,fs] = audioread('../data/haha.wav');

data_out_test_HP = filter([-0.0078 -0.2031 0.6015 -0.2031 -0.0078], [1 0 0 0 0], data);
data_out_test_LP = filter([0.039 0.2422 0.4453 0.2422 0.039], [1 0 0 0 0], data);

% Plotear gráficos de error

error_LP = abs(filterLP(2:end)-new_data_LP);
error_HP = abs(filterHP(2:end)-new_data_HP);

figure (1)
plot(error_LP)
title("error LP")

figure (2)
plot(error_HP)
title("error HP")

% Some data

avg_error_LP = sum(error_LP)/length(error_LP)
avg_error_HP = sum(error_HP)/length(error_HP)
avg_error_LP_2 = sum(error_LP.^2)/length(error_LP)
avg_error_HP_2 = sum(error_HP.^2)/length(error_HP)
