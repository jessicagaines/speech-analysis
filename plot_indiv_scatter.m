function[] = plot_indiv_scatter(stacked_f0,cond_values,adapt_size,tick_labels,connecting_lines,y_label,savepath)
    adapt_trials = stacked_f0(:,cond_values(3)-adapt_size+1:cond_values(3),:);
    n_adapt = length(tick_labels);
    cmap = colormap(winter(size(stacked_f0,1)));

    fig = figure;
    hold on;
    adapt_values = squeeze(mean(adapt_trials,2,"omitmissing"));
    [h,p,stats] = run_fisher_pair(adapt_values(:,1:2));
    [h,p,stats] = run_fisher_pair(adapt_values(:,2:3));
    diff_values = [adapt_values(:,2)-adapt_values(:,1) adapt_values(:,3)-adapt_values(:,2)];
    [h,p,stats] = run_fisher_pair(diff_values);
    adapt_values = sortrows(adapt_values);
    for i = 1:1:size(adapt_values,1)
        color = cmap(i,:);
        scatter(1:n_adapt,adapt_values(i,:),30,'o','filled',MarkerFaceColor=color)
        if connecting_lines
            plot(1:n_adapt,adapt_values(i,:),color=color)
        end
    end
    v = violinplot(1:size(stacked_f0,3),adapt_values);
    for i = 1:size(v,2)
        v(i).FaceColor = [0.5 0.5 0.5];
    end
    ylim([-125,125]);
    plot_extras(n_adapt,tick_labels)
    ylabel(y_label)
    saveas(fig,savepath,'fig');
    saveas(fig,savepath,'epsc');
end

function[h, p, stats] = run_fisher_pair(adapt_values)
    pos1_idx = find(adapt_values(:,1) >= 0);
    neg1_idx = find(adapt_values(:,1) < 0);
    pos1 = [sum(adapt_values(pos1_idx,2) >= 0); sum(adapt_values(pos1_idx,2) < 0)];
    neg1 = [sum(adapt_values(neg1_idx,2) >= 0); sum(adapt_values(neg1_idx,2) < 0)];
    tbl = [array2table(pos1) array2table(neg1)]
    [h,p,stats] = fishertest(tbl)
end

function[] = plot_extras(n_adapt,tick_labels)
    xticks(1:n_adapt)
    xticklabels(tick_labels)
    xlabel('Trials')
    xlim([0.5,n_adapt+0.5])
end

function[] = add_sig_marker(group1,group2)
    height = 130;
    plot([group1,group2],[height,height],'k|-')
    text((group1+group2)/2,height+5,'*','FontSize',20)
end