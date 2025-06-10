function[pooled, sterr, confidence_int] = pool(vector,pool_n,method,option)
    if ~exist('option','var')
        option = "";
    end
    if size(vector,2) > 1
        if strcmp(option,"all")
            [pooled, sterr, confidence_int] = pool2d_all(vector,pool_n,method);
        else
            [pooled, sterr, confidence_int] = pool2d(vector,pool_n,method);
        end
    else
        [pooled, sterr, confidence_int] = pool1d(vector,pool_n,method);
    end
end

function[pooled, sterr, confidence_int] = pool1d(vector,pool_n,method)
    pooled = zeros(1,length(vector)/pool_n);
    sterr = zeros(1,length(vector)/pool_n);
    confidence_int = zeros(2,length(vector)/pool_n);
    for i = 1:length(pooled)
        if strcmp(method, "mean")
            pooled(i) = mean(vector(((i-1)*pool_n+1):(i*pool_n)),"omitmissing");
        elseif strcmp(method, "median")
            pooled(i) = median(vector(((i-1)*pool_n+1):(i*pool_n)),"omitmissing");
        end
    end
end

function[pooled, sterr, confidence_int] = pool2d(vector,pool_n,method)
    pooled = zeros(size(vector,1),length(vector)/pool_n);
    sterr = zeros(size(vector,1),length(vector)/pool_n);
    confidence_int = zeros(size(vector,1),length(vector)/pool_n);
    for i = 1:size(pooled,2)
        if strcmp(method, "mean")
            pooled(:,i) = mean(vector(:,((i-1)*pool_n+1):(i*pool_n)),2,"omitmissing");
        elseif strcmp(method, "median")
            pooled(:,i) = median(vector(:,((i-1)*pool_n+1):(i*pool_n)),2,"omitmissing");
        end
    end
end

function[pooled, sterr, confidence_int] = pool2d_all(vector,pool_n,method)
    pooled = zeros(1,length(vector)/pool_n);
    sterr = zeros(1,length(vector)/pool_n);
    confidence_int = zeros(2,length(vector)/pool_n);
    for i = 1:size(pooled,2)
        data_pool = vector(:,((i-1)*pool_n+1):(i*pool_n));
        if strcmp(method, "mean")
            pooled(i) = mean(data_pool(:),"omitmissing");
            sterr(i) = std(data_pool(:),"omitmissing")/sqrt(size(data_pool(:),1)-sum(isnan(data_pool(:))));
            tscore = tinv([0.025,0.975],size(data_pool(:),1)-1);
            confidence_int(:,i) = pooled(i) + tscore*sterr(i);
        elseif strcmp(method, "median")
            pooled(:,i) = median(data_pool,"all","omitmissing");
        end
    end
end