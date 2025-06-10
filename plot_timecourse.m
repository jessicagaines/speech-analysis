function[] = plot_timecourse(all_f0,upshift_f0,downshift_f0,pool_n,cond_values)
    total_trials = cond_values(end);
    x_pooled = 1+(pool_n/2):pool_n:total_trials+(pool_n/2);
    
    set(gca,'fontsize', 14);
    fig = figure('Position',[200,50,700,700]);
    tiledlayout(3,1);
    % Upshift
    [pooled_upshift,sterr, conf_int] = pool(upshift_f0,pool_n,"mean","all");
    nexttile
    hold on
    title('Upshift','FontSize',11,'FontWeight','normal')
    plot_extras(cond_values,total_trials)
    %scatter(x_pooled,pooled_upshift,'ko');
    plot(x_pooled,pooled_upshift,'r')
    plot(x_pooled,conf_int,'k')
    hold off
    % Downshift
    [pooled_downshift,sterr, conf_int] = pool(downshift_f0,pool_n,"mean","all");
    nexttile
    hold on
    title('Downshift','FontSize',11,'FontWeight','normal')
    plot_extras(cond_values,total_trials)
    %scatter(x_pooled,pooled_downshift,'ko');
    plot(x_pooled,pooled_downshift,'r')
    plot(x_pooled,conf_int,'k')
    hold off
    % Upshift and Downshift
    [pooled_means,sterr, conf_int] = pool(all_f0,pool_n,"mean","all");
    nexttile
    hold on
    title('Upshift and Downshift','FontSize',11,'FontWeight','normal')
    plot_extras(cond_values,total_trials)
    %scatter(x_pooled,pooled_means,'ko');
    plot(x_pooled,pooled_means,'r')
    plot(x_pooled,conf_int,'k')
    %plot(x_pooled,pooled_means+pooled_sterr,'k')
    %plot(x_pooled,pooled_means-pooled_sterr,'k')
    hold off

    % Save figure
    saveas(fig,'multiple_pitch_adapt_figures/upshift_downshift_timecourse','fig');
    saveas(fig,'multiple_pitch_adapt_figures/upshift_downshift_timecourse','epsc');
end

function[] = plot_extras(cond_values,total_trials)
    shade_hold_phase(cond_values,-100,100)
    yline(0,'k');
    xlabel('Trial','FontSize',10);
    ylabel('Pitch (cents)','FontSize',10);
    xlim([0,total_trials])
    ylim([-102,102])
end