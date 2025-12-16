function[] = plot_fatigue(all_amp,all_f0,shifts,pool_n,cond_values)
    slopes = NaN(size(all_amp,1),1);
    for i = 1:size(all_amp,1)
        x = find(not(isnan(all_amp(i,:))));
        y = all_amp(i,x);
        mdl = fitlm(x,y);
        intercept = mdl.Coefficients.Estimate(1);
        slope = mdl.Coefficients.Estimate(2);
        slopes(i) = slope;
    end

    fig = figure('Position',[200,50,700,500]);
    tiledlayout(2,1);
    nexttile;
    hold on;
    shade_hold_phase(cond_values,-48,98)
    plot_amplitude(all_amp,shifts,pool_n,"Voice Amplitude")
    nexttile;
    hold on;
    shade_hold_phase(cond_values,12,88)
    plot_variability(all_f0, pool_n,shifts)
    saveas(fig,"multiple_pitch_adapt_figures/fatigue",'fig')
    saveas(fig,"multiple_pitch_adapt_figures/fatigue",'epsc')
end

function [] = plot_amplitude(amplitude,shifts,pool_n,title_str,cond_values)
    upshift = amplitude(shifts>0,:);
    [pooled, sterr, confidence_int] = pool(upshift,pool_n,"mean","all");
    %errorbar(1:pool_n:size(amplitude,2),pooled,-(confidence_int(1,:)-pooled),confidence_int(2,:)-pooled,'r',LineWidth=1)
    plot(1:pool_n:size(amplitude,2),pooled,'r',LineWidth=1)
    downshift = amplitude(shifts<0,:);
    [pooled, sterr, confidence_int] = pool(downshift,pool_n,"mean","all");
    %errorbar(1:pool_n:size(amplitude,2),pooled,-(confidence_int(1,:)-pooled),confidence_int(2,:)-pooled,'b',LineWidth=1)
    plot(1:pool_n:size(amplitude,2),pooled,'b',LineWidth=1)
    [pooled, sterr, confidence_int] = pool(amplitude,pool_n,"mean","all");
    errorbar(1:pool_n:size(amplitude,2),pooled,-(confidence_int(1,:)-pooled),confidence_int(2,:)-pooled,'k',LineWidth=2)
    title(title_str)
    legend(["","","","","","","Upshift","Downshift","All"],Location="northwest")
    xlim([0,size(amplitude,2)+1])
    ylabel("Amplitude (%)",fontsize=12)
end

function [] = plot_variability(all_f0, pool_n,shifts)
    %stdevs = NaN(size(all_f0,1),size(all_f0,2)-pool_n);
    stdevs = NaN(size(all_f0,1),size(all_f0,2)/pool_n);
    for i = 1:size(stdevs,2)
        %stdevs(:,i) = std(all_f0(:,i:i+pool_n),0,2,"omitmissing");
        stdevs(:,i) = std(all_f0(:,(i-1)*pool_n+1:i*pool_n),0,2,"omitmissing");
    end
    plot(1:pool_n:size(all_f0,2),mean(stdevs(shifts<0,:),1,"omitmissing"),'b',LineWidth=1)
    plot(1:pool_n:size(all_f0,2),mean(stdevs(shifts>0,:),1,"omitmissing"),'r',LineWidth=1)
    
    [pooled, sterr, confidence_int] = pool(stdevs,1,"mean","all");
    errorbar(1:pool_n:size(all_f0,2),pooled,-(confidence_int(1,:)-pooled),confidence_int(2,:)-pooled,'k',LineWidth=2)
    xlim([0,size(all_f0,2)+1])
    ylim([10,90])
    title("Mean Participant F0 Variability")
    xlabel("Trial")
    ylabel("Standard Deviation (cents)",fontsize=12)
end
