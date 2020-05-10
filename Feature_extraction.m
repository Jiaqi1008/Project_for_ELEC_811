function f=FE(L,label)

%% remove DC
L=L-cat(2,mean(L(:,1:6)),zeros(1,8));
%% segment
if (abs(L(150,8)-L(1480,8))>0.1)
    L1=EMGFilter(differential(L));
    index3=find(L1(:,8)>0.1);
    index3=max(index3);
    index1=find(L1(:,8)<0.1);
    for i=1:length(index1)
        if index1(i)>index3
            index1(i)=0;
        end
    end  
    index1(index1==0)=[];
else
    index1=find(L(:,8)<=0.9*min(L(150,8),L(1480,8))|L(:,8)>=1.1*min(L(150,8),L(1480,8)));
end

c1 = 1;
arrset = cell(0,0);
while(c1<numel(index1))
    c2 = 0;
    while (c1+c2+1<=numel(index1)&&index1(c1)+c2+1==index1(c1+c2+1))
        c2 = c2+1;
    end
    if(c2>=1)
        arrset= [arrset;(index1(c1:1:c1+c2))];
    end
    c1 = c1 + c2 +1;
end
a=[];b_up=[];b_back=[];b_down=[];c=[];
for i=1:length(arrset)
    a=[a;length(arrset{i,1})];
end
[AS pos]=sort(a,'descend');

if length(pos)<3
    clear vars a
    index2=find(L(index1,8)<=2.2&L(index1,8)>=1.8);
    index=index1(index2);
    c1 = 1;
    arrset = cell(0,0);
    while(c1<numel(index))
        c2 = 0;
        while (c1+c2+1<=numel(index)&&index(c1)+c2+1==index(c1+c2+1))
            c2 = c2+1;
        end
        if(c2>=1)
            arrset= [arrset;(index(c1:1:c1+c2))];
        end
        c1 = c1 + c2 +1;
    end
    a=[];b_up=[];b_back=[];b_down=[];c=[];
    for i=1:length(arrset)
        a=[a;length(arrset{i,1})];
    end
    [AS pos]=sort(a,'descend');
end
c=sort(pos(1:3));
for i=1:c(2)-1
    b_up=[b_up;arrset{i,1}];
end
for i=c(2):c(3)-1
    b_back=[b_back;arrset{i,1}];
end
for i=c(3):length(a)
    b_down=[b_down;arrset{i,1}];
end
%%
L1=EMGsmooth(EMGFilter(L));
m1=mean(L1(:,1:6));
L_up=L(b_up,1:6);L_up1=L1(b_up,1:6);
L_back=L(b_back,1:6);L_back1=L1(b_back,1:6);
L_down=L(b_down,1:6);L_down1=L1(b_down,1:6);
%% get feature
f=[];f_up=[];f_back=[];f_down=[];
f_up=EMGfeature(L_up,L_up1,m1);
f_back=EMGfeature(L_back,L_back1,m1);
f_down=EMGfeature(L_down,L_down1,m1);
f=[label;f_up;f_back;f_down];

