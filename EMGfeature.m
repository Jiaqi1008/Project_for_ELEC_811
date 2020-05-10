function f=EMGfeature(L_up1,L_up,m1)

m=mean(L_up./m1);
maxi=max(L_up./m1);
R=sqrt(mean(L_up.^2));
v=std(L_up./m1).^2;

[pxx,w] = periodogram(L_up);

tp=sum(pxx);
mf=sum(pxx.*w)./sum(pxx)*1000;

d=[m;maxi;R;v;tp;mf]
f=[]

for i=1:6
    zc=0;
    for j=1:length(L_up1(:,i))-2
        if length(find(L_up1(j,i)*L_up1(j+1,i)<0|(L_up1(j,i)*L_up1(j+1,i)==0&L_up1(j,i)*L_up1(j+2,i)<0)))
            zc=zc+1;
        end
    end
        f=[f;d(:,1);zc]
    end
