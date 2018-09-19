function [] = initialize()  
global Xrad
global time
global segments_size
global segments_offset
global start_segment
global end_segment
global M
global k
global continuousUniformEntropy


%time = 55;
% number of von mises models
k = 2;
segments_size = 100;
segments_offset = 100;
start_segment = 1;
end_segment = segments_size;
M = floor((900 - segments_size) / segments_offset);
continuousUniformEntropy = -log2(1/(2*pi));


