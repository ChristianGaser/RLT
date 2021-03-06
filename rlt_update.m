function rlt_update(update)
% check for new updates
%
% FORMAT rlt_update(update)
% update - allow installation of update
% 
% This function will connect itself to the SBM server, compare the
% version number of the updates with the one of the VBM8 installation 
% currently in the MATLAB path and will display the outcome.
%_______________________________________________________________________
% Christian Gaser
% $Id: rlt_update.m 130 2017-09-07 07:47:37Z gaser $

rev = '$Rev: 130 $';

if nargin == 0
  update = 0;
end

r = 0;

% get current release number
A = ver;
for i=1:length(A)
  if strcmp(A(i).Name,'Rodent Longitudinal Toolbox')
    r = str2double(A(i).Version);
  end
end

url = 'http://dbm.neuro.uni-jena.de/rlt/';

% get new release numbers
[s,sts] = urlread(url);
if ~sts
  sts = NaN;
  msg = sprintf('Cannot access %s. Please check your proxy and/or firewall to allow access.\nYou can download your update at %s\n',url,url); 
  if ~nargout, error(msg); else varargout = {sts, msg}; end
  return
end

n = regexp(s,'tfce_r(\d.*?)\.zip','tokens');
if isempty(n)
  fprintf('There are no new releases available yet.\n');
  return;
else
  % get largest release number
  rnew = [];
  for i=1:length(n)
    rnew = [rnew str2double(n{i})];
  end
  rnew = max(rnew);
end

if rnew > r
  sts = n;
  msg = sprintf('         A new version of LRT is available on:\n');
  msg = [msg sprintf('   %s\n',url)];
  msg = [msg sprintf('        (Your version: %d - New version: %d)\n',r,rnew)];
  if ~nargout, fprintf(msg); else varargout = {sts, msg}; end
else
    sts = 0;
    msg = sprintf('Your version of RLT is up to date.');
    if ~nargout, fprintf([blanks(9) msg '\n']);
    else varargout = {sts, msg}; end
    return
end

if update
  d = fullfile(spm('Dir'),'toolbox'); 
  overwrite = spm_input('Update',1,'m','Do not update|Download zip-file only|Overwrite old RLT installation',[-1 0 1],3);
  switch overwrite
  case 1
    try
      fprintf('Download RLT\n');
      s = unzip([url sprintf('rlt_r%d.zip',rnew)], d);
      fprintf('%d files have been updated.\nSPM will be restarted.\n',numel(s));
      rehash
      rehash toolboxcache;
      toolbox_path_cache
      eval(['spm fmri; spm_RLT']);
    catch
      fprintf('Update failed: check file permissions. Download zip-file only.\n');
      web([url sprintf('rlt_r%d.zip',rnew)],'-browser');
      fprintf('Unzip file to %s\n',d);
    end
  case 0
    web([url sprintf('rlt_r%d.zip',rnew)],'-browser');
    fprintf('Unzip file to %s\n',d);
  end
end