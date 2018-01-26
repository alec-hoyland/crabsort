%                 _                    _   
%   ___ _ __ __ _| |__  ___  ___  _ __| |_ 
%  / __| '__/ _` | '_ \/ __|/ _ \| '__| __|
% | (__| | | (_| | |_) \__ \ (_) | |  | |_ 
%  \___|_|  \__,_|_.__/|___/\___/|_|   \__|
%
% attempts to go through all files and run through
% the process that was done earlier manually 

function automate(self,~,~)

% get a list of all files 
% figure out what file types we can work with
allowed_file_extensions = setdiff(unique({self.installed_plugins.data_extension}),'n/a');
allowed_file_extensions = cellfun(@(x) ['*.' x], allowed_file_extensions,'UniformOutput',false);
allowed_file_extensions = allowed_file_extensions(:);


% get the list of files
[~,~,ext] = fileparts(self.file_name);
allfiles = dir([self.path_name '*' ext]);
% remove hidden files that begin with a ".
allfiles(cellfun(@(x) strcmp(x(1),'.'),{allfiles.name})) = [];
% permute the list so that the current file is last
allfiles = circshift({allfiles.name},[0,length(allfiles)-find(strcmp(self.file_name,{allfiles.name}))])';
% pick the first one 

% figure out what the filter_index is
filter_index = find(strcmp(['*' ext],allowed_file_extensions));


self.automatic = true;

for i = 1:length(allfiles)-1
	self.reset(false);

	self.file_name = allfiles{i};
	self.loadFile;

	self.handles.popup.Visible = 'off';
	drawnow

	for j = 1:length(self.automate_info)
		if isempty(self.automate_info(j).operation)
			continue
		end

		% switch to the correct channel
		self.channel_to_work_with = j;

		% go through all the steps in the operation 
		for k = 1:length(self.automate_info(j).operation)
			operation = self.automate_info(j).operation(k);

			% assign all properties
			for l = 1:length(operation.property)
				p = operation.property{l};
				setfield(self,p{:},operation.value{l});
			end

			% execute the method
			operation.method(self);

		end



	end

	self.saveData;

	pause(1)

end

 
self.automatic = false;


% go over all files