clear; clc; close all;

%% parameters

% path dataset
pathdata = [pwd filesep 'example_dataset' filesep 'particle-identification-from-detector-responses' filesep 'pid-5M.csv'];

% variable to be predicted (target variable)
i = 1;

model_funct = @reg_lin_2k; % model function
str_hifi = struct_hifi;

%% change values of some parameters.

str_hifi.saveFig = false;
str_hifi.saveResults = false;

str_hifi.pathOut = [pwd filesep 'results_particle']; % path to save figures and/or final results

str_hifi.maximizedFig = false;
str_hifi.fontSizeFig = 10;

%% load data

data = readtable(pathdata);

% data
x = data.Variables;
x_names = data.Properties.VariableNames;

% select subset for binary class

idx1 = find(x(:,i) == 211);
idx2 = find(x(:,i) == 2212);

x = x([idx1;idx2],:);

idx1 = find(x(:,i) == 211);
idx2 = find(x(:,i) == 2212);
x(idx1,i) = 0; % binary class: 0,1
x(idx2,i) = 1;

%% preprocessing

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
for k = 1:p-1
    disp(['Variable ' num2str(k) ' of ' num2str(p-1)])
    [drivers_red{k}, drivers_syn{k}, mi_red{k}, mi_syn{k}] = hifi_syn_red(x, i, all_i(k), model_funct, str_hifi);
end

disp ('Running hifi permutations...');

mi_red_surr = cell(p-1,1);
mi_syn_surr = cell(p-1,1);
for k = 1:p-1
    disp(['Variable ' num2str(k) ' of ' num2str(p-1)])
    [mi_red_surr{k}, mi_syn_surr{k}] = hifi_surr(x, drivers_red{k}, drivers_syn{k}, str_hifi.nsurr, model_funct);
end

% thresholding drivers...
[r_n,s_n] = drivers_thresholded(p, str_hifi.alpha, str_hifi.nsurr, mi_red, mi_syn, mi_red_surr, mi_syn_surr);

% decomposition
[dU, dR, dS, dbiv] = hifi_decomposition(mi_red, mi_syn, r_n, s_n);

% standard loco 
dLOC = standard_LOCO(x(:,i), x(:,all_i), model_funct);

% R and S pathsù
Rm_path = hifi_path(mi_red, drivers_red, r_n);
Sm_path = hifi_path(mi_syn, drivers_syn, s_n);

Rm_path = abs(Rm_path); % make positive

%% plot results

% R and S surrogates
plot_surr(mi_red, mi_red_surr, r_n, x_names, 'Redundancy', str_hifi);
plot_surr(mi_syn, mi_syn_surr, s_n, x_names, 'Sinergy', str_hifi);

% decomposition
plot_decomposition(dU, dR, dS, dLOC, dbiv, x_names, str_hifi);

% R and S pathways
plot_path(Rm_path, Sm_path, x_names, str_hifi);

%% save results

if str_hifi.saveResults == true
    pathOut = str_hifi.pathOut;
    save([pathOut filesep 'hifi_Results.mat'], 'drivers_red', 'drivers_syn', 'mi_red', 'mi_syn', ... 
                          'mi_red_surr', 'mi_syn_surr', 'r_n', 's_n', 'Rm_path', 'Sm_path', ...
                          'dU', 'dR', 'dS', 'dbiv', 'dLOC', 'x_names', 'str_hifi');
end
