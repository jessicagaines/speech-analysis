function [] = plot_rebaseline_timecourse(stacked_f0,pool_n,cond_values)
    n_holds = length(cond_values)/2-1;
    x_pooled = 0.5+(pool_n/2):pool_n:size(stacked_f0,2)+(pool_n/2);
    fig = figure('Position',[200,50,700,700]);
    
    tiledlayout(n_holds,1);
    for i = 0:n_holds-1
        offset = cond_values(2*(i+1)-1);
        nexttile
        hold on
        plot_extras(cond_values,100,offset)
        [f0_pooled, sterr, confidence_int] = pool(stacked_f0(:,:,i+1),pool_n,"mean","all");
        errorbar(x_pooled+offset,f0_pooled,sterr,'k')
        plot(x_pooled+offset,f0_pooled,'k',marker='.',MarkerSize=20,LineWidth=1.5)
        [clusters, p_values, t_sums, permutation_distribution ] = permutest((stacked_f0(:,:,i+1))',zeros((size((stacked_f0(:,:,i+1))'))),true,0.05,10^5,true);
        title(strcat('Cycle ',num2str(i+1)))
        clusters
        p_values
        % add green color for significant clusters
        %for j = 1:size(p_values,2)
        %    if p_values(j) < 0.05
        %        sig_trials = cell2mat(clusters(j));
        %        plot(sig_trials + 60*i,zeros(size(sig_trials)),'g',LineWidth=5)
        %    end
        %end
    end
    saveas(fig,'multiple_pitch_adapt_figures/rebaseline_timecourse','fig');
    saveas(fig,'multiple_pitch_adapt_figures/rebaseline_timecourse','epsc');
end
    

function[] = plot_extras(cond_values,total_trials,x_offset)
    ymin = -60;
    ymax = 40;
    shade_hold_phase(cond_values,ymin+1.5,ymax-1.5)
    yline(0,'k');
    xlabel('Trial');
    ylabel('Pitch (cents)');
    xlim([x_offset,total_trials+x_offset])
    ylim([ymin,ymax])
    yticks([ymin+10:20:ymax])
end