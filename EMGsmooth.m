function EMG_RMS_output=EMGsmooth(EMG_raw)
%%
%% smoothing
% LPF 
[b,a] = butter(2,2.7/1000)

EMG_RMS_output=filter(b,a,EMG_raw);
