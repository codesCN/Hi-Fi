% test on simulated data
close all; clear; clc;

%% simulation

N = 80000;

mu = [0 0 0]; Sigma = [1 .5 .3;.5 1 -0.5;.3 -0.5 1];
x = mvnrnd(mu,Sigma,N);
xsyn = x;
mu = [0 0 0]; Sigma = [1 .5 .3;.5 1 0.5;.3 0.5 1];
x = mvnrnd(mu,Sigma,N);
xred = x;
xunique = randn(N,1);
xint = randn(N,2);

% let's build data
X(1:N,1) = xsyn(:,1)+xred(:,1)+xunique+xint(:,1).*xint(:,2)+0.05*randn(N,1);
X(:,2:3) = xsyn(:,2:3);
X(:,4:5) = xred(:,2:3);
X(:,6) = xunique;
X(:,7:8) = xint;

% variable to be predicted (target variable)
i = 1;

% 'syn1', 'syn2', 'red1', 'red2', 'unique', 'int1', 'int2'};
x_names = {'1', '2', '3', '4', '5', '6', '7'};

%% parameters

model_funct = @reg_lin_2k; % model function
str_hifi = struct_hifi;

%% change values of some parameters.

str_hifi.saveFig = false;
str_hifi.saveResults = false;

str_hifi.pathOut = [pwd filesep 'results_toy'];
if (str_hifi.saveFig==true || str_hifi.saveResults==true) && ~isfolder(str_hifi.pathOut)
    mkdir(str_hifi.pathOut);
end

str_hifi.maximizedFig = false;
str_hifi.fontSizeFig = 10;

%% run HIFI

disp ('Running hifi...');

p = size(X,2);
all_i = setdiff(1:p,i);

% i, for all j (target and all drivers)
drivers_red = cell(p-1,1);
drivers_syn = cell(p-1,1);
mi_red = cell(p-1,1);
mi_syn = cell(p-1,1);
for k = 1:p-1
    disp(['Variable ' num2str(k) ' of ' num2str(p-1)])
    [drivers_red{k}, drivers_syn{k}, mi_red{k}, mi_syn{k}] = hifi_syn_red(X, i, all_i(k), model_funct, str_hifi);
end
 
r_n = [1 1 2 2 1 1 1];
s_n = [2 2 1 1 1 2 2]; 

% decomposition
[dU, dR, dS, dbiv] = hifi_decomposition(mi_red, mi_syn, r_n, s_n);

% standard loco 
dLOC = standard_LOCO(X(:,i), X(:,all_i), model_funct);

%% plot results

plot_decomposition(dU, dR, dS, dLOC, dbiv, x_names, str_hifi)

%% save results

if str_hifi.saveResults == true
    pathOut = str_hifi.pathOut;
    save([pathOut filesep 'hifi_Results.mat'], 'drivers_red', 'drivers_syn', 'mi_red', 'mi_syn', ... 
                                              'r_n', 's_n', 'dU', 'dR', 'dS', 'dbiv', 'dLOC', 'x_names', ...
                                              'str_hifi');
end