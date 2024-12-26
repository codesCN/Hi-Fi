% plot redundancy/synergy path for each variable 
function plot_surr(mi, mi_surr, mi_n, x_names, measure_name, str_hifi)

    fs = str_hifi.fontSizeFig;

    h = figure;
    set(h,'paperpositionmode','auto');

    if str_hifi.maximizedFig==true
        h.WindowState = 'maximized';
    end

    tl = tiledlayout('flow', 'Padding', 'compact', 'TileSpacing', 'compact'); 
    title(tl, measure_name, FontSize=18, FontWeight='bold');       
    
    p = length(x_names); % number of variables minus ones
    for k = 1:p    
        nexttile; 
        mii = mi{k};
        mii_surr = mi_surr{k};
        plot(mii,'-*k', LineWidth=2); hold on;
        errorbar(2:p, mean(mii_surr), var(mii_surr), '-ob', LineWidth=2);
        xline(mi_n(k), '--r', LineWidth=2);
        axis square
       
        ax = gca(h);
        ax.FontSize = fs;  

        title(x_names{k}, FontSize=fs);
    end
    ylabel(tl, 'Values', FontSize=fs);
    xlabel(tl, 'Number of variables', FontSize=fs);

    if str_hifi.saveFig == true
        pathOut = str_hifi.pathOut;
        exportgraphics(tl,[pathOut filesep measure_name '.tiff'],'Resolution',300);
        exportgraphics(tl,[pathOut filesep measure_name '.pdf'],'Resolution',300);
        savefig([pathOut filesep measure_name]);
    end
end
