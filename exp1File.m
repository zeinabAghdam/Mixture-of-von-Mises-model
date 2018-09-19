function str = exp1File( number , dataList )
%exp1File Match a given number to its patient, i.e. file name
%   INPUT:
%       number: Number of the patient or zero
%
%   OUTPUT:
%       str: the corresponging string to access the files of patient number
%           returns -1 if no such patient number exists (greater than
%           length or negative
%           returns the array of all patients if the number is zero
%---
% R. Bergmann - 2013-10-21

% Hard coded included from the readme.
if dataList ==1 
 patients = {'AR02','CT10','FC04','IZ05','KW01','LH09','MB05',...
     'MM03','MS07','WD08','YL06'};
else
    patients = {'KN31' ,'LY16','ME09','MI27','MM10','NJ18','NJ20','NS01',...
     'WT09', 'WM07', 'TI26', 'TC21', 'RA18', 'PN21'};
end

if (number>length(patients))||(number<0)
   str = '';
elseif (number==0)
    str = patients;
else
    str = patients(number);
end
end