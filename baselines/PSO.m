
function Best_Cost = PSO()
fitness = @objfun;
NP = 60;
c1 = 2;  c2 = 2;% c1,c2��ѧϰ����
wmax = 0.8; % wmax������Ȩ�����ֵ
wmin = 0.6; % wmin������Ȩ����Сֵ
MAX_ITER = 100; % M������������
D = 10; % D�������ռ�ά��
% N����ʼ��Ⱥ�������Ŀ
MinX=[100,50,200,90,190,85,200,99,130,200];
MaxX=[250,230,500,265,490,265,500,265,440,490];
% MinX=[100,200,90,190,85,200,99,130,200];
% MaxX=[250,500,265,490,265,500,265,440,490];
Pd=2700;

% ��ʼ����Ⱥ�ĸ��壨�����������޶�λ�ú��ٶȵķ�Χ��
for i=1:1:D
x(:,i)=MinX(i)+(MaxX(i)-MinX(i))*rand(NP,1);    
end

for i = 1:NP
    for j=1:D
        v(i,j) = randn; % �漴��ʼ���ٶ�
    end
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

%�ȼ���������ӵ���Ӧ�ȣ�����ʼ���������Ž�pi���������Ž�pg %
%��ʼ��pi %
for i = 1:NP
    p(i) = fitness(x(i,:)) ;
    y(i,:) = x(i,:) ;
end
%��ʼ��pg %
pg = x(NP,:) ;
%�õ���ʼ��ȫ������pg %
for i = 1:(NP-1)
    if fitness(x(i,:)) < fitness(pg)
        pg = x(i,:) ;
    end
end
 
%��ѭ�����������е�����ֱ���ﵽ���ȵ�Ҫ�� %
for k = 1:MAX_ITER
    for j = 1:NP
        fv(j) = fitness(x(j,:)) ;
    end
    fvag = sum(fv)/NP ;
    fmin = min(fv);
    for i = 1:NP    %���º���,����v���ٶ�������xΪλ��,iΪ��������
        if fv(i) <= fvag
            w = wmin+(fv(i)-fmin)*(wmax-wmin)/(fvag-fmin) ;   %�������������̶Ⱥ���Ӧ��ֵ���е���
        else
            w = wmax ;
        end
        v(i,:) = w*v(i,:)+c1*rand*(y(i,:)-x(i,:))+c2*rand*(pg-x(i,:)) ;
        x(i,:) = x(i,:)+v(i,:) ;
        
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
           
        if fitness(x(i,:)) < p(i)
            p(i) = fitness(x(i,:)) ;
            y(i,:) = x(i,:) ;
        end
        if p(i) < fitness(pg)
            pg = y(i,:) ;
        end
    end
    
     Cost_curve(k) = fitness(pg) ;
end
 
%�������ļ����� %
% xm = pg' ;
% fv = fitness(pg) ;
Best_Cost = min(Cost_curve);
end
