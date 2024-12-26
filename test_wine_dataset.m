clear; clc; close all;

%% parameters

% path dataset
pathdata = [pwd filesep 'example_dataset' filesep 'wine+quality' filesep];

% variable to be predicted (target variable)
i = 12; 

model_funct = @reg_lin; % model function
str_hifi = struct_hifi;

%% change values of some parameters.

str_hifi.runPerms = true;

str_hifi.saveFig = false;
str_hifi.saveResults = false;

str_hifi.pathOut = [pwd filesep 'results_wine']; % path to save figures and/or final results

str_hifi.maximizedFig = false;
str_hifi.fontSizeFig = 10;

%% load data

data_red = readtable([pathdata 'winequality-red.csv']);
data_white = readtable([pathdata 'winequality-white.csv']);
data = [data_red; data_white];

idx_rem = 11; % remove this variable
data(:,idx_rem) = [];
i = i-1;

% data
x = data.Variables;
x_names = data.Properties.VariableNames;

%% preprocessing data

[x, x_names, i, i_name, str_hifi] = preprocessing_data(x, x_names, i, str_hifi);

%% run HIFI

disp ('Running hifi...');

p = size(x,2);
all_i = setdiff(1:p,i);

% i, for all j (target and all drivers)
drivers_red = cell(p-1,1);
drivers_syn = cell(p-1,1);
mi_red = cell(p-1,1);
mi_syn = cell(p-1,1);
r_n = zeros(p-1,1);
s_n = zeros(p-1,1);
for k = 1:p-1
    disp(['Variable ' num2str(k) ' of ' num2str(p-1)])
    [drivers_red{k}, drivers_syn{k}, mi_red{k}, mi_syn{k}, r_n(k), s_n(k)] = hifi_syn_red(x, i, all_i(k), model_funct, str_hifi);
end

% decomposition
[dU, dR, dS, dbiv] = hifi_decomposition(mi_red, mi_syn, r_n, s_n);

% standard loco 
dLOC = standard_LOCO(x(:,i), x(:,all_i), model_funct);

% R and S paths
Rm_path = hifi_path(mi_red, drivers_red, r_n);
Sm_path = hifi_path(mi_syn, drivers_syn, s_n);

Rm_path = abs(Rm_path); % make positive

%% plot results

% decomposition
plot_decomposition(dU, dR, dS, dLOC, dbiv, x_names, str_hifi);

% R and S pathways
plot_path(Rm_path, Sm_path, x_names, str_hifi);

%% save results

if str_hifi.saveResults == true
    pathOut = str_hifi.pathOut;
    save([pathOut filesep 'hifi_Results.mat'], 'drivers_red', 'drivers_syn', 'mi_red', 'mi_syn', ... 
                          'r_n', 's_n', 'Rm_path', 'Sm_path', ...
                          'dU', 'dR', 'dS', 'dbiv', 'dLOC', 'x_names', 'str_hifi');
end
