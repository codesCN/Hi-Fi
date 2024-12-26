function plot_decomposition(dU, dR, dS, dLOC, dbiv, x_names, str_hifi)

    % U:b, R:r, S:g, LOCO:y, biv:b1
    cols = [0 0.4470 0.7410; ... 
            0.6350 0.0780 0.1840; ... 
            0.4660 0.6740 0.1880; ...
            0.9290 0.6940 0.1250; ...
            0.3010 0.7450 0.9330]; 

    fs = str_hifi.fontSizeFig;

    h = figure;
    set(h,'paperpositionmode','auto');
    
    if str_hifi.maximizedFig==true
        h.WindowState = 'maximized';
    end
    
    tl = tiledlayout(1, 2, 'Padding', 'compact', 'TileSpacing', 'compact'); 

    % decomposition
    nexttile
    b = bar(x_names, [dU dR dS],'stacked', 'FaceColor','flat'); legend('unique','redundancy','synergy');
    b(1).CData = cols(1,:); %b
    b(2).CData = cols(2,:); %r
    b(3).CData = cols(3,:); % gr
    a = gca;
    a.FontSize = fs;
    
    % unique
    nexttile; 
    b = bar(x_names,[dLOC dbiv], 'FaceColor','flat'); legend('LOCO','pairwise');
    b(1).CData = cols(4,:); %y
    b(2).CData = cols(5,:); %b1
    a = gca;
    a.FontSize = fs;

    if str_hifi.saveFig == true
        pathOut = str_hifi.pathOut;
        exportgraphics(tl,[pathOut filesep 'decomposition.tiff'],'Resolution',300);
        exportgraphics(tl,[pathOut filesep 'decomposition.pdf'],'Resolution',300);
        savefig([pathOut filesep 'decomposition']);
    end
end