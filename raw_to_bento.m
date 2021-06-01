function data = raw_to_bento(file_dir, file_name, map_dir, map_name, params)
% raw_to_xds(file_dir, file_name, map_dir, map_name, params)
%
% takes in raw .nev and associated files, and spits out a Bento compatible 
% structure.
% This structure will be built according to the information given by the
% params structure that's input.
%
% Despite the name, this goes through the CDS structure as an intermediary.
% Take that into account - any issues in that codebase will be propagated
% through to this output.
%
% -- Inpusts --
% file_dir              Where the file is stored
% file_name             file name to be converted
% map_dir               directory where the array map is stored
% map_name              name of the map file
% params:        
%   monkey_name         monkey's name 
%   array_name          nickname for the array (ie M1). use the name from
%                           the implant database
%   task_name           valid task code according to the CDS code
%   ran_by              identification of who collected the data
%   lab                 lab #
%   bin_width           width to bin the spiking and EMG
%   sorted              Is the file sorted? (0/1 or true/false)
%   requires_raw_emg    True for all EMG recordings
%
%
% -- Outputs --
% bento                   The Bento compatible file structure
%
xds = raw_to_xds(file_dir, file_name, map_dir, map_name, params);
if xds.has_EMG
    data.raw_EMGs = transpose(xds.raw_EMG);
    data.raw_EMG_timestamps = transpose(xds.raw_EMG_time_frame);
    
    names = transpose(xds.EMG_names);
    names = char(names);
    data.EMG_names = names(:,5:end);
    
    data.EMGFr = 1/mode(diff(xds.raw_EMG_time_frame));
    data.EMG_filtered = transpose(xds.EMG);
end
sampling_frequency = 30000;

data.spike_times = xds.spikes;
for k=1:numel(data.spike_times)
    data.spike_times{k} = cast(transpose(data.spike_times{k}) * sampling_frequency, 'uint32');
end
data.binnedFr = transpose(xds.time_frame);
data.spikes_binned = cast(transpose(xds.spike_counts), 'double');
save('test.mat','data')
% bento.xds = xds; %temporary for viewing






