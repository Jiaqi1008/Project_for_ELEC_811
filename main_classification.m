clear all
set(0,'defaultfigurecolor','w')
%% Feature Extraction
acc1=[];acc2=[];acc3=[];acc4=[];acc5=[];acc6=[];acc=[];

i=[1 2 3 4 5];label=[0 1 2 3 4 5];j=[1 2 3 4 5];w=['0' '2pt5' '5' '10' '15' '20'];
rng(7);i_01=round(rand()*4)+1;
i(i_01)=[];i_02=i;
train=[];test=[];
for i=1:length(i_02)
    for k=1:6
        for j=1:5
            if k==1
                filename=['S0',num2str(i_02(i)),' Raw Data 30 Files\LiftCycle_',w(k),'kg',num2str(j),'.txt']
            elseif k==2
                filename=['S0',num2str(i_02(i)),' Raw Data 30 Files\LiftCycle_',w(k:k+3),'kg',num2str(j),'.txt']
            elseif k==3
                filename=['S0',num2str(i_02(i)),' Raw Data 30 Files\LiftCycle_',w(k+3),'kg',num2str(j),'.txt']
            else
                filename=['S0',num2str(i_02(i)),' Raw Data 30 Files\LiftCycle_',w(2*k-1:2*k),'kg',num2str(j),'.txt']
            end
            L=importdata(filename);
            f=FE(L,label(k));
            train=[train f];
        end
    end
end
for k=1:6
    for j=1:5
        if k==1
            filename=['S0',num2str(i_01),' Raw Data 30 Files\LiftCycle_',w(k),'kg',num2str(j),'.txt']
        elseif k==2
            filename=['S0',num2str(i_01),' Raw Data 30 Files\LiftCycle_',w(k:k+3),'kg',num2str(j),'.txt']
        elseif k==3
            filename=['S0',num2str(i_01),' Raw Data 30 Files\LiftCycle_',w(k+3),'kg',num2str(j),'.txt']
        else
            filename=['S0',num2str(i_01),' Raw Data 30 Files\LiftCycle_',w(2*k-1:2*k),'kg',num2str(j),'.txt']
        end
        L=importdata(filename);
        f=FE(L,label(k));
        test=[test f];
    end
end
%%
score1=0;score2=0;score3=0;score4=0;score5=0;score6=0;score=0;ii=0;jj=0;
for i=10:10:500
    for j=1:1:15
        Md_rf = TreeBagger(i,train(2:length(train(:,1)),:)',train(1,:)','OOBPrediction','on','MinLeafSize',j);
        a1=predict(Md_rf,test(2:length(train(:,1)),:)');
        a1=cell2mat(a1);a1=str2num(a1);
        for k=1:length(a1)
            if a1(k)==test(1,k)
                score1=score1+1;
            end
        end
        if score1>score
            score=score1;
            ii=i;
            jj=j;
        end
        score1=0;
    end
end

Md_rf = TreeBagger(ii,train(2:length(train(:,1)),:)',train(1,:)','OOBPrediction','on','MinLeafSize',jj);
a1=predict(Md_rf,test(2:length(train(:,1)),:)');
a1=cell2mat(a1);a1=str2num(a1);
Md_svm=fitcecoc(train(2:length(train(:,1)),:)',train(1,:)','OptimizeHyperparameters','all');
a2=predict(Md_svm,test(2:length(train(:,1)),:)');
Md_dis=fitcdiscr(train(2:length(train(:,1)),:)',train(1,:)','OptimizeHyperparameters','all');
a3=predict(Md_dis,test(2:length(train(:,1)),:)');
Md_nb=fitcnb(train(2:length(train(:,1)),:)',train(1,:)','OptimizeHyperparameters','all');
a4=predict(Md_nb,test(2:length(train(:,1)),:)');
Md_knn=fitcknn(train(2:length(train(:,1)),:)',train(1,:)', 'OptimizeHyperparameters','all');
a5=predict(Md_knn,test(2:length(train(:,1)),:)');
Md_ens=fitcensemble(train(2:length(train(:,1)),:)',train(1,:)', 'OptimizeHyperparameters','all');
a6=predict(Md_ens,test(2:length(train(:,1)),:)');

for i=1:length(a1)
    if a1(i)==test(1,i)
        score1=score1+1;
    end
end
acc1=[acc1 score1/length(a1)]
for i=1:length(a2)
    if a2(i)==test(1,i)
        score2=score2+1;
    end
end
acc2=[acc2 score2/length(a1)]
for i=1:length(a3)
    if a3(i)==test(1,i)
        score3=score3+1;
    end
end
acc3=[acc3 score3/length(a1)]
for i=1:length(a4)
    if a4(i)==test(1,i)
        score4=score4+1;
    end
end
acc4=[acc4 score4/length(a1)]
for i=1:length(a5)
    if a5(i)==test(1,i)
        score5=score5+1;
    end
end
acc5=[acc5 score5/length(a5)]
for i=1:length(a6)
    if a6(i)==test(1,i)
        score6=score6+1;
    end
end
acc6=[acc6 score6/length(a6)]

%%
acc=[acc1;acc2;acc3;acc4;acc5;acc6]


