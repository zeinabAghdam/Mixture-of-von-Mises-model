% Input : Set Xrad of data points
% Output A soft clustering of X over a mixture of 2-vMF distributions.
% Input data points are interpreted as radients
% The case that k=2 is a special case of a von Mises distribution.
% 
% mu, conc, alpha are vectors of mu = [mu1, mu2]; conc=[conc1, conc2];
% alpha = [alpha1, alpha2];

clear all 
close all
clc
global Xrad
global time
global segments_offset
global start_segment
global end_segment
global M
global k
global continuousUniformEntropy


iteration_size = 500;
concSubjects= cell(10,length(50:5:100));
muRad = cell(10,length(50:5:100));
muSubjects = cell(10,1);
mJointDist = cell(10,length(50:5:100));
alphaSubjects = cell(10,length(50:5:100));
time_index = 1;

for subj = 1:1
    
    time_index = 1;
    clear cluster_likelihood
    clear likelihood_data
    
    for time = 55:5:55
        initialize();
        clear cluster_likelihood
        clear likelihood_data
        clear jointDist
        clear mu
        clear murad
        clear kappa
        clear X
        
        str = exp1File( subj , 1 );
        load(strcat('C:\Users\sahar\CloudStation\project_1\fittingVonMisesModel_entropy\Codes\Data\', str{1}));

        
        %load(strcat('D:\HTW\phase_data\DataNumbered\', num2str(subj),'.mat'));
        Xrad = ipsi2_phase(:,time); 
        % Xrad = ipsi2_phase(:,time); 

        % Convert radients into vectors on the two-dimensional unit sphere
        X(:,1) = cos(Xrad);
        X(:,2) = sin(Xrad);
        
        [mu,kappa,alpha] = InitializeParameters(k,Xrad);
        [m,n]= size(X); % Data to be in column-wise manner.

        epsilon = 0.001;
        diff = 1;
       
        for iteration = 1:iteration_size
            for i =1:m
                for h=1:k
                    likelihood_data(i,h)= getpdf_VMf(mu(h,:)', kappa(h), X(i,:)');
                end

                for h=1:k
                  % cluster_likelihood(i,h) = log(alpha(h)) + likelihood_data(i,h) - log(sum(likelihood_data(i,:)));
                   cluster_likelihood(i,h) = alpha(h)* likelihood_data(i,h)/sum(alpha .* likelihood_data(i,:));
                end  
            end
            
            % The M (Maximization Step) of EM
            for h=1:k
                alpha(1,h) =  (1/m) * sum(cluster_likelihood(:,h));
                mu(h,:) = mean_likelihood_estimation(h,cluster_likelihood,X);
                rbar = norm(mu(h,:)) / (alpha(1,h)*m);
                mu(h,:) = mu(h,:) ./ norm(mu(h,:));
                kappa(1,h) = (rbar*2 - rbar^3)/(1-rbar^2);
                %kappa(1,h) = 2*rbar*(1+ (0.5* rbar^2) +  (0.4167* rbar^4));
            end
        end
        
        % Reconstruct the mean and kappa (- Added shift)
        murad = atan2(mu(:,2), mu(:,1))';
        murad = pi + murad;
        
        muSubjects{subj} = mu;
        concSubjects{subj,time_index} = kappa;
        muRad{subj,time_index} = murad;
        alphaSubjects{subj,time_index}= alpha;
             
        % Reconstruct the joint Distribution:: 
        % (alpha_1 * vM_pdf_1 + alpha_2 * vM_pdf_2 + ... [Depending on the
        % number of clusters.]  
        jointDist = zeros(100, 1);
        for h=1:k
            jointDist = jointDist + alpha(1,h)*circ_vmpdf([],murad(1,h),kappa(1,h));
        end
        
        % Compute the entropy of data
        distEntrop(subj,time_index) = entrop(normalise(jointDist)) * continuousUniformEntropy;
        mJointDist{subj,time_index} = jointDist; 
        %plot1- plot the histogram of data with the approximated distribution. 
        %subplot(2,5,subj),
        %plotHistFig(jointDist,Xrad);
        
%             
%         % plot clustered data - Different clusters
         % figure, [cluster_ratio] = plotClusteredFig(cluster_likelihood,Xrad);
%        
        
        % plot clustered data over different segments
         figure,
         for ix=1:M
             [clusters, cluster_ratio(ix)] = plotSegmentCluster(cluster_likelihood(start_segment:end_segment,:),Xrad,start_segment,end_segment,ix);
             start_segment = end_segment +1;
             end_segment = end_segment + segments_offset;   
         end
%         figure, plot(cluster_ratio)
%         
         time_index  = time_index + 1;
        
    end 
end
%%
close all
figure(2),
for subj = 1:10
    subplot(2,5,subj),
    plot(distEntrop(subj, :),'LineWidth',2);
    xLim([1 26]);
end

%%
subj = 5;
for i=1:11

    subplot(2,5,i),
    plot(mJointDist{subj,i});

end




