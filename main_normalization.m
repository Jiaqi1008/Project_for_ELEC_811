clear all
set(0,'defaultfigurecolor','w')
rng(0);i_01=round(rand()*4)+1;rng(1);j_01_L=round(rand()*4)+1;rng(2);j_01_M=round(rand()*4)+1;rng(3);j_01_H=round(rand()*4)+1
rng(4);i_02=round(rand()*4)+1;rng(5);j_02_L=round(rand()*4)+1;rng(6);j_02_M=round(rand()*4)+1;rng(7);j_02_H=round(rand()*4)+1
filename_L_01=['S0',num2str(i_01),' Raw Data 30 Files\LiftCycle_2pt5kg',num2str(j_01_L),'.txt']
filename_M_01=['S0',num2str(i_01),' Raw Data 30 Files\LiftCycle_10kg',num2str(j_01_M),'.txt']
filename_H_01=['S0',num2str(i_01),' Raw Data 30 Files\LiftCycle_20kg',num2str(j_01_H),'.txt']
filename_L_02=['S0',num2str(i_02),' Raw Data 30 Files\LiftCycle_2pt5kg',num2str(j_02_L),'.txt']
filename_M_02=['S0',num2str(i_02),' Raw Data 30 Files\LiftCycle_10kg',num2str(j_02_M),'.txt']
filename_H_02=['S0',num2str(i_02),' Raw Data 30 Files\LiftCycle_20kg',num2str(j_02_H),'.txt']
L_01=importdata(filename_L_01);L_01=L_01-cat(2,mean(L_01(:,1:6)),zeros(1,8));
L_02=importdata(filename_L_02);L_02=L_02-cat(2,mean(L_02(:,1:6)),zeros(1,8));
M_01=importdata(filename_M_01);M_01=M_01-cat(2,mean(M_01(:,1:6)),zeros(1,8));
M_02=importdata(filename_M_02);M_02=M_02-cat(2,mean(M_02(:,1:6)),zeros(1,8));
H_01=importdata(filename_H_01);H_01=H_01-cat(2,mean(H_01(:,1:6)),zeros(1,8));
H_02=importdata(filename_H_02);H_02=H_02-cat(2,mean(H_02(:,1:6)),zeros(1,8));
%%
L_01_output=EMGFilter(L_01(:,1:8));M_01_output=EMGFilter(M_01(:,1:8));H_01_output=EMGFilter(H_01(:,1:8));
L_02_output=EMGFilter(L_02(:,1:8));M_02_output=EMGFilter(M_02(:,1:8));H_02_output=EMGFilter(H_02(:,1:8));
%%
C=['L' 'M' 'H' 'L' 'M' 'H']
N=[1 1 1 2 2 2]
S=['BB' 'TB' 'BR' 'AD' 'LES' 'TES']
for j=1:6
    figure(j)
    for i=1:7
        if i~=7
            subplot(7,3,3*i-2)
            plot(eval([C(j),'_0',num2str(N(j)),'(:,i)']))
            if i<5
                title(['Raw ',S(2*i-1),S(2*i),'-EMG ',C(j),num2str(N(j))])
            else
                title(['Raw ',S(3*i-6),S(3*i-5),S(3*i-4),'-EMG ',C(j),num2str(N(j))])
            end
            subplot(7,3,3*i-1)
            plot(eval([C(j),'_0',num2str(N(j)),'_output(:,i)']))
            hold on
            plot(EMGsmooth(eval([C(j),'_0',num2str(N(j)),'_output(:,i)'])))
            if i<5
                title(['Filtered and Smoothed ',S(2*i-1),S(2*i),'-EMG ',C(j),num2str(N(j))])
            else
                title(['Filtered and Smoothed ',S(3*i-6),S(3*i-5),S(3*i-4),'-EMG ',C(j),num2str(N(j))])
            end
            subplot(7,3,3*i)
            plot((eval([C(j),'_0',num2str(N(j)),'_output(:,i)'])/mean(eval([C(j),'_0',num2str(N(j)),'_output(:,i)']))))
            hold on
            plot(EMGsmooth((eval([C(j),'_0',num2str(N(j)),'_output(:,i)'])/mean(eval([C(j),'_0',num2str(N(j)),'_output(:,i)'])))))
            if i<5
                title(['Normalized ',S(2*i-1),S(2*i),'-EMG ',C(j),num2str(N(j))])
            else
                title(['Normalized ',S(3*i-6),S(3*i-5),S(3*i-4),'-EMG ',C(j),num2str(N(j))])
            end
        else
            subplot(7,3,3*i-2)
            plot(eval([C(j),'_0',num2str(N(j)),'(:,8)']))           
            title(['Raw Box switch signal ',C(j),num2str(N(j))])
            axis([-inf inf 0 1.2*max(eval([C(j),'_0',num2str(N(j)),'(:,8)']))])
            subplot(7,3,3*i-1)
            plot(eval([C(j),'_0',num2str(N(j)),'_output(:,8)']))
            hold on
            title(['Filtered and Smoothed Box switch signal ',C(j),num2str(N(j))])   
            axis([-inf inf 0 1.2*max(EMGsmooth(eval([C(j),'_0',num2str(N(j)),'_output(:,8)'])))])
            subplot(7,3,3*i)
            plot((eval([C(j),'_0',num2str(N(j)),'_output(:,8)'])/mean(eval([C(j),'_0',num2str(N(j)),'_output(:,i)']))))
            hold on
            title(['Normalized Box switch signal ',C(j),num2str(N(j))])  
            axis([-inf inf 0 1.2*max(EMGsmooth((eval([C(j),'_0',num2str(N(j)),'_output(:,8)'])/mean(eval([C(j),'_0',num2str(N(j)),'_output(:,i)'])))))])
        end
    end
end