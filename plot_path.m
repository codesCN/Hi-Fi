function plot_path(Rm_path, Sm_path, x_names, str_hifi)

    p = length(x_names);
    maxH = max([Rm_path(:);Sm_path(:)]);

    fs = str_hifi.fontSizeFig;

    h = figure;
    set(h,'paperpositionmode','auto')

    if str_hifi.maximizedFig==true
        h.WindowState = 'maximized';
    end

    tl = tiledlayout(1, 2, 'Padding', 'compact', 'TileSpacing', 'compact'); 

    % red pathway
    nexttile
    imagesc(Rm_path); colormap(flipud(hot)) 
    colorbar;
    clim([0 maxH]);
    axis square;
    clear xticklabels yticklabels
    xticks(1:p);
    yticks(1:p);
    xticklabels(x_names);
    yticklabels(x_names);
    xtickangle(45)
    ytickangle(45)
    a = gca;
    a.FontSize = fs+5;
    title('Redundancy');

    % syn pathway
    nexttile
    imagesc(Sm_path); colormap(flipud(hot)) 
    colorbar;
    clim([0 maxH]); 
    axis square
    clear xticklabels yticklabels
    xticks(1:p);
    yticks(1:p);
    xticklabels(x_names);
    yticklabels(x_names);
    xtickangle(45)
    ytickangle(45)
    a = gca;
    a.FontSize = fs+5;
    title('Synergy');

    if str_hifi.saveFig == true
        pathOut = str_hifi.pathOut;
        exportgraphics(tl,[pathOut filesep 'rs_paths.tiff'],'Resolution',300);
        exportgraphics(tl,[pathOut filesep 'rs_paths.pdf'],'Resolution',300);
        savefig([pathOut filesep 'rs_paths']);
    end
end
