function [f0,amp] = get_f0(dataVals,timeframe)
    f0 = zeros(1,length(dataVals));
    amp = zeros(1,length(dataVals));
    for i = 1:length(f0)
        taxis = dataVals(i).pitch_taxis;
        t0 = taxis(1);
        taxis = taxis - t0;
        pitch = median(dataVals(i).f0(find(taxis>=timeframe(1) & taxis<=timeframe(2))),"omitmissing"); %#ok<FNDSB>
        intensity = median(dataVals(i).int(find(taxis>=timeframe(1) & taxis<=timeframe(2))),"omitmissing");
        f0(1,i) = pitch;
        amp(1,i) = intensity;
    end
end