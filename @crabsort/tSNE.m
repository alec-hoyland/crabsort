% crabsort plugin
% plugin_type = 'dim-red';
% plugin_dimension = 2; 
% 
%                 _                    _   
%   ___ _ __ __ _| |__  ___  ___  _ __| |_ 
%  / __| '__/ _` | '_ \/ __|/ _ \| '__| __|
% | (__| | | (_| | |_) \__ \ (_) | |  | |_ 
%  \___|_|  \__,_|_.__/|___/\___/|_|   \__|
%
% created by Srinivas Gorur-Shandilya at 2:04 , 02 September 2015. Contact me at http://srinivas.gs/contact/
% 
%
% this plugin implements a single channel t-SNE of the spikes
% using just the spike shape 
% 
function tSNE(self)

d = dbstack;
if self.verbosity > 3
	disp(['[' mfilename '] called by ' d(2).name])
end


% interactively t-sne the data 
if self.pref.use_matlab_tsne
	R = tsne(self.data_to_reduce');
	self.R{self.channel_to_work_with} = R';
else
	self.R{self.channel_to_work_with} = mctsne(self.data_to_reduce);
end
