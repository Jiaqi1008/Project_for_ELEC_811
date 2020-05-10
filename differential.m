function L1=differential(L)

L1=L;
L2=L;
L2(length(L2(:,1)),:)=[];

L2=[zeros(1,length(L2(1,:)));L2];
L1=L1-L2;
