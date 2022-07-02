function long_rodent = tbx_cfg_longitudinal_RLT
% Configuration file for longitudinal data
%
% Christian Gaser
% $Id: tbx_cfg_longitudinal_RLT.m 1339 2018-07-25 13:35:02Z gaser $

addpath(fileparts(which(mfilename)));

% try to estimate number of processor cores
try
  numcores = feature('numcores');
  % because of poor memory management use only half of the cores for windows
  if ispc
    numcores = round(numcores/2);
  end
  numcores = max(numcores,1);
catch
  numcores = 0;
end

% force running in the foreground if only one processor was found or for compiled version
if numcores == 1 || isdeployed, numcores = 0; end

%------------------------------------------------------------------------
nproc         = cfg_entry;
nproc.tag     = 'nproc';
nproc.name    = 'Split job into separate processes';
nproc.strtype = 'w';
nproc.val     = {numcores};
nproc.num     = [1 1];
nproc.help    = {
    'In order to use multi-threading the job with multiple subjects can be split into separate processes that run in the background. You can even close Matlab, which will not affect the processes that will run in the background without GUI. If you do not want to run processes in the background then set this value to 0.'
    ''
    'Keep in mind that each process needs about 1.5..2GB of RAM, which should be considered to choose the appropriate  number of processes.'
    ''
    'Please further note that no additional modules in the batch can be run except CAT12 segmentation. Any dependencies will be broken for subsequent modules.'
  };

%------------------------------------------------------------------------
matrate         = cfg_entry;
matrate.tag     = 'matrate';
matrate.name    = 'Maturational rate compared to humans';
matrate.help    = {'In order to use the longitudinal tool you have to define the times for each scan. Because the registration method is adapted to human changes defined as years it is necessary to corrected the resp. times for mice. See https://www.jax.org/news-and-insights/jax-blog/2017/november/when-are-mice-considered-old for more information about the recommended maturational rates. The default value of 45 works fine for 1-6 months old mice, while a value of 150 is recommended for younger and 25 for older mice. However, you should just use one shared value for your whole sample.'};
matrate.strtype = 'r';
matrate.val     = {45};
matrate.num     = [1 1];

%------------------------------------------------------------------------
tim         = cfg_entry;
tim.tag     = 'times';
tim.name    = 'Times';
tim.help    = {'Specify the times of the scans in days. Please note that for the SPM12 longitudinal toolbox the times in mouse/rat days are transformed to human years by using the maturational rate divided by 365 (days per year).'};
tim.strtype = 'e';
tim.num     = [1 Inf];

%------------------------------------------------------------------------
mov = cfg_files;
mov.name = 'Longitudinal data for this subject';
mov.tag  = 'mov';
mov.filter = 'image';
mov.num  = [1 Inf];
mov.help   = {...
'These are the data of the same subject.'};

%------------------------------------------------------------------------
subj = cfg_branch;
subj.name = 'Subject';
subj.tag = 'subj';
subj.val = {mov tim};
subj.help = {...
'Images of the same subject.'};

%------------------------------------------------------------------------
esubjs         = cfg_repeat;
esubjs.tag     = 'esubjs';
esubjs.name    = 'Data';
esubjs.values  = {subj};
esubjs.num     = [1 Inf];
esubjs.help = {...
'Specify data for each subject.'};

%------------------------------------------------------------------------
tpm = cfg_files;
tpm.name    = 'Tissue Probabilty Map';
tpm.tag     = 'tpm';
tpm.filter  = 'image';
tpm.ufilter = 'TPM';
tpm.dir     = fullfile(spm('dir'),'toolbox','RLT');
tpm.val     = {{fullfile(spm('dir'),'toolbox','RLT','TPM_C57Bl6_n30.nii')}};
tpm.num     = [1 1];
tpm.help    = {...
'Select tissue probability map (TPM) for spatial registration. For mouse data select the TPM_C57Bl6_n30.nii template and for rat data the TPM_Rat.nii.'};

%------------------------------------------------------------------------
cfg = tbx_cfg_longitudinal;
cfg.values{2}.vout = @vout_series_align;
%------------------------------------------------------------------------

long_rodent = cfg_exbranch;
long_rodent.name = 'Preprocess longitudinal rodent data';
long_rodent.tag  = 'long_rodent';
long_rodent.val  = {tpm,matrate,nproc,esubjs};
long_rodent.prog = @rlt_long_multi_run;
long_rodent.vout = @vout_long;
long_rodent.help = {
'This option provides customized processing of longitudinal data. Please note that this processing pipeline was optimized for processing and detecting changes over time in rodent data.'
''
};

%------------------------------------------------------------------------


return;
%------------------------------------------------------------------------
 
%------------------------------------------------------------------------
function dep = vout_long(job)
for k=1:numel(job.subj)
    cdep(k)            = cfg_dep;
    cdep(k).sname      = sprintf('Segmented longitudinal data (Subj %d)',k);
    cdep(k).src_output = substruct('.','sess','()',{k},'.','files');
    cdep(k).tgt_spec   = cfg_findspec({{'filter','image','strtype','e'}});
    if k == 1
        dep = cdep;
    else
        dep = [dep cdep];
    end
end;
%------------------------------------------------------------------------

%======================================================================
function cdep = vout_series_align(job)
% This depends on job contents, which may not be present when virtual
% outputs are calculated.

ind  = 1;
if job.write_avg,
    cdep(ind)          = cfg_dep;
    cdep(ind).sname      = 'Midpoint Average';
    cdep(ind).src_output = substruct('.','avg','()',{':'});
    cdep(ind).tgt_spec   = cfg_findspec({{'filter','image','strtype','e'}});
    ind = ind + 1;
end
if job.write_jac,
    cdep(ind)          = cfg_dep;
    cdep(ind).sname      = 'Jacobian';
    cdep(ind).src_output = substruct('.','jac','()',{':'});
    cdep(ind).tgt_spec   = cfg_findspec({{'filter','image','strtype','e'}});
    ind = ind + 1;
end
if job.write_div,
    cdep(ind)          = cfg_dep;
    cdep(ind).sname      = 'Divergence';
    cdep(ind).src_output = substruct('.','div','()',{':'});
    cdep(ind).tgt_spec   = cfg_findspec({{'filter','image','strtype','e'}});
    ind = ind + 1;
end
if job.write_def,
    cdep(ind)            = cfg_dep;
    cdep(ind).sname      = 'Deformation';
    cdep(ind).src_output = substruct('.','def','()',{':'});
    cdep(ind).tgt_spec   = cfg_findspec({{'filter','image','strtype','e'}});
end
