% struct with default values of the parameters 
function str_hifi = struct_hifi
    
    str_hifi.maxNdrivers = Inf; 
    str_hifi.runPerms = false;

    str_hifi.nsurr = 1000; %
    str_hifi.alpha = 0.05; %

    str_hifi.saveResults = false;
    str_hifi.saveFig = false;

    str_hifi.pathOut = pwd; % 
    
    str_hifi.fontSizeFig = 10;
    str_hifi.maximizedFig = false;
end