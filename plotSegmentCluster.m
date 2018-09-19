%    Find the maximum of clusters and plot. Segments are defined as the
%    number of trials (sweeps) in one block of data.

function [clusters, skewness]= plotSegmentCluster(cluster_likelihood,Xrad,st_ind,en_ind,PlotInd)

    numClusters = size(cluster_likelihood, 2);
    

    for ix = 1:size(cluster_likelihood,1)
        % Max likelihood cluster selection:
        %[likelihoodDensity(ix), clusterLabel(ix)] = max(cluster_likelihood(ix,:));
        
        % Stochastic cluster selection:
        clusterLabel(ix) = drawCluster(cluster_likelihood(ix,:));
        
        dataRadLabels(ix,:) = [Xrad(st_ind) clusterLabel(ix)];
        st_ind = st_ind + 1;
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
 
    subplot(2,4,PlotInd), 
    hold on,
    
    plotStyles = ['ro'; 'ko'; 'yo'; 'mo'; 'co'; 'bo'; 'ko'];
    
    for i = 1:numClusters
        if (~isempty(clusters_ind{i}))
            circ_plot(clusters{i},'color',plotStyles(i,:)),
            title(['Segment ',num2str(PlotInd)]);
            hold on,
        end
    end
    hold off
 
    
     if (numClusters > 2)
        skewness = min(min(clusters{:})) / max(max(clusters{:}));
    else
        skewness = size(clusters{1}) / size(clusters{2});
     end
    
end

