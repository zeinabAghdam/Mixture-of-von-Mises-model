% Plot the estimated vonMises along with Histogram for different times over
% different subjects.


subjects = 5;
dataTime = 50;
for timeInd = 1:11
 
   load(strcat('D:\HTW\phase_data\DataNumbered\', num2str(subjects),'.mat'));
   Xrad = ipsi1_phase(:,dataTime);
   subplot(2,5,timeInd),
   plot(linspace(-pi,pi,100), mJointDist{subjects,timeInd},'r','LineWidth',3),
   hold on , 
   histnorm(Xrad,32);
   dataTime = dataTime +5;

end
