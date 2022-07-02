function rlt_set_com_and_scale_rat(vargin)
% 1. Use center-of-mass (COM) to roughly correct for differences in the
% position between image and template
% 2. Correct voxelsize if necessary


if nargin == 1
	P = char(vargin.data);
else
  P = spm_select(Inf,'image','Select images to filter');
end
V = spm_vol(P);
n = size(P,1);

% pre-estimated COM of rat template
com_reference = [0 -11 -37];

for i=1:n
  fprintf('Correct center-of-mass for %s\n',V(i).fname);
  Affine = eye(4);
  vol = spm_read_vols(V(i));
  avg = mean(vol(:));
  avg = mean(vol(vol>avg));
  
  iM = spm_imatrix(V(i).mat);
  vx_vol  = sqrt(sum(V(i).mat(1:3,1:3).^2));
  if any(vx_vol<0.5)
    fprintf('Correct voxel size by factor 6.\n');
    iM([1:3 7:9]) = 6*iM([1:3 7:9]);
    V(i).mat = spm_matrix(iM);
  end
  
  % don't use background values
  [x,y,z] = ind2sub(size(vol),find(vol>avg));
  com = V(i).mat(1:3,:)*[mean(x) mean(y) mean(z) 1]';
  com = com';

  Affine(1:3,4) = (com - com_reference)';
  spm_get_space(V(i).fname,Affine\V(i).mat);
end
