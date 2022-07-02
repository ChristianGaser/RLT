function out = rlt_long_multi_run(job)
% Call rlt_long_main for multiple subjects
%
% Christian Gaser
% $Id: rlt_long_multi_run.m 1339 2018-07-25 13:35:02Z gaser $

global tpm
warning off;

maturation_rate = job.matrate;
tpm = job.tpm{:};
tpm  = strrep(tpm,'nii,1','nii');

jobs = repmat({'rlt_long_main.m'}, 1, numel(job.subj));
inputs = cell(2,numel(job.subj),1);

for i=1:numel(job.subj),
    out.sess(i).files = cell(numel(job.subj(i).mov),1);
    m = numel(job.subj(i).mov);
    data = cell(m,1);
    for j=1:m
      [pth,nam,ext,num] = spm_fileparts(job.subj(i).mov{j});
      out.sess(i).files{j} = fullfile(pth,['wj_', nam, ext, num]);
      data{j} = job.subj(i).mov{j};
    end
    inputs{1,i} = data;
    if isfinite(job.subj(i).times)
      % transform time from mouse days to human years by a factor of maturation_rate/365
      inputs{2,i} = job.subj(i).times*maturation_rate/365;
    else
      inputs{2,i} = NaN;
    end
end;

% split job and data into separate processes to save computation time
if isfield(job,'nproc') && job.nproc>0 && numel(job.subj)>1 && (~isfield(job,'process_index'))
  if nargout==1
    varargout{1} = cat_parallelize(job,mfilename,'subj');
  else
    cat_parallelize(job,mfilename,'subj');
  end
  return
else
  spm_jobman('run',jobs,inputs{:});
end

warning on;
