% Find the maximum of clusters and plot over different Segments 
% Segments are defined as N number of sweeps. 


function [skewness]= plotClusteredFig(cluster_likelihood, Xrad)   

    numClusters = size(cluster_likelihood,2);

    for ix = 1:size(cluster_likelihood,1)
        % Max likelihood cluster selection:
        %[likelihoodDensity(ix), clusterLabel(ix)] = max(cluster_likelihood(ix,:));
        
        % Stochastic cluster selection:
        clusterLabel(ix) = drawCluster(cluster_likelihood(ix,:));
        
        dataRadLabels(ix,:) = [Xrad(ix) clusterLabel(ix)];
        %dataCarLabels(ix,:) = [X(ix,1) X(ix,2) clusterLabel(ix)];
    end
 
    clusters_ind = cell(numClusters);
    clusters = cell(numClusters);
    
    for i = 1:numClusters
        clusters_ind{i}  = find(dataRadLabels(:,2) == i);
        if (~isempty(clusters_ind{i}))
            for id = 1:size(clusters_ind{i},1)
                clusters{i}(id) = dataRadLabels(clusters_ind{i}(id),1);
            end
        else
            clusters{i} = [];
        end
    end
    
    % Plot the clustered data
    figure(101),
    hold on,
    
    plotStyles = ['ro'; 'go'; 'yo'; 'mo'; 'co'; 'bo'; 'ko'];
    
    for i = 1:numClusters
        if (~isempty(clusters_ind{i}))
            circ_plot(clusters{i},'color',plotStyles(i,:)),
            hold on,
        end
    end
    
    % compute the skewness rate (propotion of clusters).   
    if (numClusters > 2)
        skewness = min(min(clusters{:})) / max(max(clusters{:}));
    else
        skewness = size(clusters{1}) / size(clusters{2});
    end
       
    hold off
 
end
