function EMG_RMS_output=EMGFilter(EMG_raw)
%% smoothing
% Non-linear(RMS)
EMG_RMS=EMG_raw.*EMG_raw;
% LPF 
Wp = 30/1000; Ws = 400/1000;
Rp = 2;Rs = 40;
[n,Wn] = buttord(Wp,Ws,Rp,Rs);
[b,a] = butter(n,Wn);

EMG_RMS_output=filter(b,a,EMG_RMS);
% Re-linear
EMG_RMS_output=sqrt(abs(EMG_RMS_output));
