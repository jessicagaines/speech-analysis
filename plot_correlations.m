function [] = plot_correlations(adapt_values,pairs,subplots,type,labels,lim,savepath)
    fig = figure('Position',[200,50,300*subplots(2),300*subplots(1)]);
    tiledlayout(subplots(1),subplots(2));
    for i=1:size(pairs,1)
        ax = nexttile;
        pair = pairs(i,:);
        if ~isnan(pair(1))
            data1 = adapt_values(:,pair(1));
            data2 = adapt_values(:,pair(2));
            scatter(data1,data2,'filled')
            [rho,pval] = corr(adapt_values(:,pair),'type',type);
            rho = rho(1,2);
            pval = pval(1,2);
            annotate_pval(pval,rho,0.05,[lim(1)+10,lim(2)-10],type)
            %[r, LB, UB, F, df1, df2, p] = ICC(adapt_values(:,pair), 'A-1', 0.05, 0);
            %annotate_pval(p,r,0.05,[lim(2)-50,lim(2)-10],'ICC')
            xlim(lim)
            ylim(lim)
            xlabel(labels(pair(1)))
            ylabel(labels(pair(2)))
        else
            set(gca, 'visible', 'off');
        end
    end
    saveas(fig,savepath,'fig');
    saveas(fig,savepath,'epsc');
end
