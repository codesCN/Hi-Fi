function [x, x_names, i, i_name, str_hifi] = preprocessing_data(x, x_names, i, str_hifi)
    
    % set target variable in column 1
    i_name = x_names(i); 
    x_names(i) = [];
    
    y = x(:,i);
    x(:,i) = [];
    [x_names, idx] = sort(x_names); % sorted data by variable names
    x = x(:,idx); clear idx
    
    x = [y x]; clear y
    i = 1;
    
    % removing rows with missing values
    [r,~] = find(isnan(x));
    r = unique(r);
    x(r,:) = []; clear r
    
    % bonferroni correction (multiple comparisons)
    str_hifi.alpha = str_hifi.alpha/length(x_names);

    % normalizing data
    x = zscore(x);
    
    if (str_hifi.saveFig==true || str_hifi.saveResults==true) && ~isfolder(str_hifi.pathOut)
        mkdir(str_hifi.pathOut);
    end
end