function cluster = drawCluster(cluster_likelihood)
    n = size(cluster_likelihood, 2);
    
    cumprob=[0 cumsum(cluster_likelihood)];

    uni=rand(1,1);
    
    for j=1:n
      if (uni>cumprob(j)) && (uni<=cumprob(j+1))
          cluster = j;
      end
    end
end
