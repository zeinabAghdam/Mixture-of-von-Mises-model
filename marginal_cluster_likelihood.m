function marginalLK = marginal_cluster_likelihood(h,cluster_likelihood)
global X

    marginalLK = sum(X .* cluster_likelihood(:,h))

end
