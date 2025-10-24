function [] = plot_rebaseline_timecourse(stacked_data,pool_n,cond_values,subplots,y_label,y_lim,titles,savepath)
    n_holds = size(stacked_data,3);
    x_pooled = 0.5+(pool_n/2):pool_n:size(stacked_data,2)+(pool_n/2);
    fig = figure('Position',[200,50,700,700]);
    
    tiledlayout(subplots(1),subplots(2));
    for i = 0:n_holds-1
        if length(cond_values) > 4
            offset = cond_values(2*(i+1)-1);
        else
            offset = 0;
        end
        nexttile
        hold on
        plot_extras(cond_values,size(stacked_data,2),offset)
        [f0_pooled, sterr, confidence_int] = pool(stacked_data(:,:,i+1),pool_n,"mean","all");
        errorbar(x_pooled+offset,f0_pooled,sterr,'k')
        plot(x_pooled+offset,f0_pooled,'k',marker='.',MarkerSize=20,LineWidth=1.5)
        title(titles(i+1))
        ylabel(y_label);
        ylim(y_lim)
        [clusters, p_values, t_sums, permutation_distribution ] = permutest((stacked_data(:,:,i+1))',zeros((size((stacked_data(:,:,i+1))'))),true,0.05,10^5,true);
        clusters
        p_values
        %add green color for significant clusters
        for j = 1:size(p_values,2)
           if p_values(j) < 0.05
               sig_trials = cell2mat(clusters(j));
               plot(sig_trials + offset,zeros(size(sig_trials)),'g',LineWidth=5)
           end
        end
    end
    saveas(fig,savepath,'fig');
    saveas(fig,savepath,'epsc');
end
    

function[] = plot_extras(cond_values,total_trials,x_offset)
    ymin = -60;
    ymax = 40;
    shade_hold_phase(cond_values,ymin+1.5,ymax-1.5)
    yline(0,'k');
    xlabel('Trial');
    xlim([x_offset,total_trials+x_offset])
    yticks([ymin+10:20:ymax])
end