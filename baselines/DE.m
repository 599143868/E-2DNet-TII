function Best_Cost = DE()
% dbstop if error
% close all;
% clear ;
% clc;
NP=60;       % ��Ⱥ��ģ
D=10;        % Ⱦɫ�峤��
MAX_ITER=200;
F0=0.1;
CR=0.2;

MinX=[100,50,200,90,190,85,200,99,130,200];
MaxX=[250,230,500,265,490,265,500,265,440,490];
% MinX=[100,200,90,190,85,200,99,130,200];
% MaxX=[250,500,265,490,265,500,265,440,490];
Pd=2700;
% yz=10^-6;
 
x=zeros(NP,D);    % ��ʼ��Ⱥ
v=zeros(NP,D);    % ������Ⱥ
u=zeros(NP,D);    % ѡ����Ⱥ
%-----------------------��Ⱥ��ʼ��--------------------------
for i=1:1:D
x(:,i)=MinX(i)+(MaxX(i)-MinX(i))*rand(NP,1);    
end

x = Projection(x,MinX,MaxX,Pd); 
 
for i=1:NP
Best(i,:)=x(i,:);% ÿ��λ�����Ÿ��� ֮�󲻶ϸ���
ob(i)=objfun(Best(i,:));
end

%          ��ֽ���ѭ��
for k=1:MAX_ITER
%----------------------����-------------------------- 
    for m=1:NP
        r1=randi([1,NP],1,1);
        while(r1==m)
            r1=randi([1,NP],1,1);
        end
        
        r2=randi([1,NP],1,1);
        while(r2==r1)||(r2==m)
            r2=randi([1,NP],1,1);
        end
        
        r3=randi([1,NP],1,1);
        while(r3==m)||(r3==r2)||(r3==r1)
            r3=randi([1,NP],1,1);
        end
        %  ������ͬ��r1,r2,r3
        
        v(m,:)=x(r1,:)+F0*(x(r2,:)-x(r3,:));
 
    end   
 %----------------------����-------------------------- 
    r=randi([1,D],1,1);   % ����������������Ⱥ
    for n=1:D
        cr=rand;
        if (cr<=CR)||(n==r)  %����һ����������Ŵ��Ա�����
            u(:,n)=v(:,n);
        else
            u(:,n)=x(:,n);
        end
    end    
%----------------------����ʹ������Լ������-------------------------- 
    u = Projection(u,MinX,MaxX,Pd);

    % �����µ���Ӧ��
    for m=1:NP
        ob_1(m)=objfun(u(m,:));
    end
%---------------------- ѡ��--------------------------    
    for m=1:NP
        if ob_1(m)<ob(m)
            x(m,:)=u(m,:);
        else
            x(m,:)=x(m,:);
        end       
    end
    % ����xΪ����ѡ������Ⱥ
    for m=1:NP
        ob(m)=objfun(x(m,:));        
    end
    Cost_curve(k) = min(ob);
end
Best_Cost = min(Cost_curve);
end

function x = Projection(x,MinX,MaxX,Pd)
[NP,D] = size(x);
for i=1:NP
    while(1)
        S=sum(x(i,:));
        delta=Pd-S;
        x(i,:)=x(i,:)+delta/D;
        for j=1:D %����Ƿ�Խ��
            if(x(i,j)<MinX(j))
                x(i,j)=MinX(j);
            elseif(x(i,j)>MaxX(j)) 
                x(i,j)=MaxX(j);
            end
        end
        S=sum(x(i,:));
        delta=Pd-S;
        if abs(delta)<1e-3
            break;          
        end
     end
end
end
