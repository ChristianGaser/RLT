%-----------------------------------------------------------------------
% Job saved on 22-Jan-2019 16:38:36 by cfg_util (rev $Rev: 7345 $)
% spm SPM - SPM12 (7487)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------
global tpm

matlabbatch{1}.spm.tools.cat.tools.series.data = '<UNDEFINED>';
matlabbatch{1}.spm.tools.cat.tools.series.bparam = 1000000;
matlabbatch{1}.spm.tools.cat.tools.series.use_brainmask = 0;
matlabbatch{1}.spm.tools.cat.tools.series.reg.nonlin.times = '<UNDEFINED>';
matlabbatch{1}.spm.tools.cat.tools.series.reg.nonlin.wparam = [0 0 100 25 100];
matlabbatch{1}.spm.tools.cat.tools.series.reg.nonlin.write_jac = 1;
matlabbatch{1}.spm.tools.cat.tools.series.write_rimg = 0;
matlabbatch{1}.spm.tools.cat.tools.series.reduce = 0;
matlabbatch{1}.spm.tools.cat.tools.series.write_avg = 1;
matlabbatch{2}.spm.spatial.normalise.estwrite.subj.vol(1) = cfg_dep('Longitudinal Registration: Midpoint Average', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','avg', '()',{':'}));
matlabbatch{2}.spm.spatial.normalise.estwrite.subj.resample(1) = cfg_dep('Longitudinal Registration: Midpoint Average', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','avg', '()',{':'}));
matlabbatch{2}.spm.spatial.normalise.estwrite.subj.resample(2) = cfg_dep('Longitudinal Registration: Jacobian Diff', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','jac', '()',{':'}));
matlabbatch{2}.spm.spatial.normalise.estwrite.eoptions.biasreg = 0.0001;
matlabbatch{2}.spm.spatial.normalise.estwrite.eoptions.biasfwhm = 60;
matlabbatch{2}.spm.spatial.normalise.estwrite.eoptions.tpm = {tpm};
matlabbatch{2}.spm.spatial.normalise.estwrite.eoptions.affreg = 'subj';
matlabbatch{2}.spm.spatial.normalise.estwrite.eoptions.reg = [0 0.001 0.5 0.05 0.2];
matlabbatch{2}.spm.spatial.normalise.estwrite.eoptions.fwhm = 0;
matlabbatch{2}.spm.spatial.normalise.estwrite.eoptions.samp = 3;
matlabbatch{2}.spm.spatial.normalise.estwrite.woptions.bb = [NaN NaN NaN
                                                             NaN NaN NaN];
matlabbatch{2}.spm.spatial.normalise.estwrite.woptions.vox = [1 1 1];
matlabbatch{2}.spm.spatial.normalise.estwrite.woptions.interp = 4;
matlabbatch{2}.spm.spatial.normalise.estwrite.woptions.prefix = 'w';
