function [] = methods_figure(cond_array,baseline_size,adapt_size,washout_size,n_cycles)
    close all;
    cond_values = get_cond_change_values(cond_array);
    baseline_start = cond_values(2)-baseline_size+1;
    baseline_end = cond_values(2);
    hold_start = cond_values(3) - adapt_size + 1;
    hold_end = cond_values(3);
    early_washout_start = cond_values(3)+1;
    early_washout_end = cond_values(3) + washout_size;
    late_washout_start = cond_values(4)-washout_size + 1;
    late_washout_end = cond_values(4);


    fig = figure('Position',[200,100,1000,500]);
    hold on;
    trials = 1:length(cond_array);
    
    shade_hold_phase(cond_values,-298,298)
    plot(trials,-cond_array,':k',LineWidth=2)
    plot(trials,cond_array,'-k',LineWidth=2)
    xlim([0,cond_values(end)+20])
    ylim([-300,300])
    xlabel("Trial")
    ylabel("f0 shift (cents)")
    xticks(0:baseline_size:cond_values(end))
    yticks([-max(abs(cond_array)),0,max(abs(cond_array))])
    for i = 0:n_cycles-1
        cycle_offset = late_washout_end - baseline_end;
        cycle_start = baseline_start+cycle_offset*i;
        cycle_end = late_washout_end+cycle_offset*i;
        plot([cycle_start,cycle_end],[250-50*i,250-50*i],Marker='.',MarkerSize=20,LineWidth=2,Color='k')
        text((cycle_end-cycle_start)/2+cycle_start,270-50*i,strcat("Cycle ",num2str(i+1)),HorizontalAlignment="center")
        plot([baseline_start+cycle_offset*i,baseline_end+cycle_offset*i],[-140,-140],Marker='.',MarkerSize=20,LineWidth=2,Color='k')
        text((baseline_end-baseline_start)/2+baseline_start+cycle_offset*i,-120,"Baseline",HorizontalAlignment="center")
        plot([hold_start+cycle_offset*i,hold_end+cycle_offset*i],[-180,-180],Marker='.',MarkerSize=20,LineWidth=2,Color='k')
        text((hold_end-hold_start)/2+hold_start+cycle_offset*i,-160,"Hold",HorizontalAlignment="center")
        plot([early_washout_start+cycle_offset*i,early_washout_end+cycle_offset*i],[-220,-220],Marker='.',MarkerSize=20,LineWidth=2,Color='k')
        text((early_washout_end-early_washout_start)/2+early_washout_start+cycle_offset*i,-200,"Early Washout",HorizontalAlignment="center")
        plot([late_washout_start+cycle_offset*i,late_washout_end+cycle_offset*i],[-260,-260],Marker='.',MarkerSize=20,LineWidth=2,Color='k')
        text((late_washout_end-late_washout_start)/2+late_washout_start+cycle_offset*i,-240,"Late Washout",HorizontalAlignment="center")
    end
    
    saveas(fig,"multiple_pitch_adapt_figures/methods",'fig')
    saveas(fig,"methods","epsc")
end