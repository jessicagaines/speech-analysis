function[] = plot_correlations(stacked_f0,cond_values,adapt_size,washout_size,tick_labels)
    early_baseline_values = squeeze(mean(stacked_f0(:,1:20,:),2,"omitmissing"));
    baseline_values = squeeze(mean(stacked_f0(:,cond_values(2)-20+1:cond_values(2),:),2,"omitmissing"));
    adapt_values = squeeze(mean(stacked_f0(:,cond_values(3)-adapt_size+1:cond_values(3),:),2,"omitmissing"));
    early_washout_values = squeeze(mean(stacked_f0(:,cond_values(3)+1:cond_values(3)+washout_size,:),2,"omitmissing"));
    late_washout_values = squeeze(mean(stacked_f0(:,cond_values(4)-washout_size+1:cond_values(4),:),2,"omitmissing"));
    n_adapt = length(tick_labels);
    fig = figure;
    tiledlayout(n_adapt-1,n_adapt-1);
    [rho,pval] = corr(adapt_values,'type','Pearson');
    for i = 1:n_adapt
        for j = i+1:n_adapt
            nexttile(2*(i-1)+(j-1))
            scatter(adapt_values(:,j),adapt_values(:,i),10,'o','filled')
            annotate_pval(pval(i,j),rho(i,j),0.05,[-180,120])
            if j == i+1
                ylabel(strcat('Hold ',num2str(i)))
            end
            if i == j-1
                xlabel(strcat('Hold ',num2str(j)))
            end
            xlim([-200,150])
            ylim([-200,150])
        end
    end
    saveas(fig,'multiple_pitch_adapt_figures/correlations','fig');
    saveas(fig,'multiple_pitch_adapt_figures/correlations','epsc');

end

function annotate_pval(pval,rho,siglevel,loc)
    if pval < siglevel
        text(loc(1),loc(2),strcat("r^{2} = ", num2str(round(rho^2,2))))
        text(loc(1)-10,loc(2),'*')
    else
        text(loc(1),loc(2),strcat("r^{2} = ", num2str(round(rho^2,2))," (n.s.)"))
    end
end