function [] = visualize_variability(stacked_f0,cond_values,baseline_size,adapt_size)
    baseline = stacked_f0(:,cond_values(2)-baseline_size+1:cond_values(2),1);
    holds = stacked_f0(:,cond_values(3)-adapt_size+1:cond_values(3),1);
    fig = figure('Position',[200,50,700,700]);
    tiledlayout(4,1)

    nexttile;
    hold on;
    title("Baseline")
    violinplot(transpose(baseline));
    plot_extras()
    
    nexttile;
    hold on;
    title("Hold Phase 1")
    violinplot(transpose(holds));
    plot_extras()

    nexttile;
    hold on;
    holds = stacked_f0(:,cond_values(2)+1:cond_values(3),2);
    title("Hold Phase 2")
    violinplot(transpose(holds));
    plot_extras()

    nexttile;
    hold on;
    holds = stacked_f0(:,cond_values(2)+1:cond_values(3),3);
    title("Hold Phase 3")
    violinplot(transpose(holds));
    plot_extras()

    saveas(fig,'multiple_pitch_adapt_figures/ppt_variance','fig');
    saveas(fig,'multiple_pitch_adapt_figures/ppt_variance','epsc');
end

function[] = plot_extras()
    ylim([-500,500])
    xlabel("Participant")
    ylabel("Pitch (cents)")
end