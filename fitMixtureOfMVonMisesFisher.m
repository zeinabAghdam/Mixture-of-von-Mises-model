function [vMu,vKappa,vAlpha, assignments] = fitMixtureOfMVonMisesFisher(M, X, vMu, vKappa, vAlpha)
    global delta
    global maxIterations
    
    alpha_diff = 2 * delta;
    mu_diff = 0;
    kappa_diff = 0;
    
    % Data to be in column-wise order.
    [numDataPoints, dataDim] = size(X);
    % assignments(i) contains the model index that data point X(i, :) was
    % assigned to
    assignments = [];

    currentIteration = 1;
    while ((alpha_diff > delta || mu_diff > delta || kappa_diff > delta) && ~(currentIteration > maxIterations))
        % Compute model likelihoods for all data points
        cluster_likelihoods = [];
        for h=1:M
            cluster_likelihoods(h, :) = getpdf_VMf(vMu(h, :)', vKappa(h), X');
        end
        for i=1:numDataPoints
            normalizationFactor = 1/sum(cluster_likelihoods(:, i)');
            for h=1:M
                cluster_likelihoods(h, i) = normalizationFactor * cluster_likelihoods(h, i);
            end
        end

        % Save the old parameters. 
        vAlpha_old = vAlpha;
        vKappa_old = vKappa;
        vMu_old = vMu;

        % The M (Maximization Step) of EM
        % Update parameters of models based on the data points belonging
        % to that model specifically. 
        for h=1:M
            %indexes = find(assignments==h);
            %if ~isempty(indexes)
            %    dataPointsOfThisModel = X(indexes, :);
                [newAlpha, newMu, newKappa] = maximizeModel(vMu(h, :), vKappa(h), cluster_likelihoods, X, numDataPoints, h);
                vAlpha(h) = newAlpha;
                vMu(h, :) = newMu;
                vKappa(h) = newKappa;
            %end
        end

        % Prev Parameters diff:
        alpha_diff = max(abs(vAlpha - vAlpha_old));
        mu_diff    = max(norm(vMu    - vMu_old));
        kappa_diff = max(abs(vKappa - vKappa_old));

        currentIteration = currentIteration + 1;
    end 
    
    
   % [likelihoodWithoutOutlier,DataWithoutOutlier]= removeOutliersWithLowLikelihood(M,vMu, vKappa, X,vAlpha);

    % Compute the current assignment of data to the models.   
    for i=1:numDataPoints
        dataPoint = X(i,:);
        assignments(i) = assignDataToModel_specifiedConfig(vAlpha, vMu, vKappa, dataPoint,M);
    end
end