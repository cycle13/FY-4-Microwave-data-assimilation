function [TB_SIR,optimal_iteration] = SIR_deconv(TA,TB,pattern,row_TA_Lat,col_TA_Long,Num_iteration,sample_factor,flag_draw_iteration)
%   �������ܣ� ��û�й۲�����������ͼ��TA����SIR������������ͼ��ֱ��ʺ;���****************
%              ����SIR���ؽ��������ͼ��
%  
%   �������:
%    TA           �����ؽ�����������ͼ��TA
%    pattern      �����߷���ͼ����
%   ���������
%    TB           : SIR�ؽ��������ͼ����������TAͼ���СΪN*N�����ؽ�ͼ��Ĵ�СΪ0.5N*0.5N��  
%   N:��������
%   by �¿� 2017.3.31  ******************************************************
[row,col]=size(TA);
row_RE = sample_factor*row; 
col_RE = sample_factor*col;
num_RE = row_RE*col_RE;
pk = zeros(row_RE,col_RE);
gk = zeros(row_RE,col_RE);
h1 = zeros(row_RE,col_RE);							 %��i����������������溯���ľ���
h2 = zeros(row,col);                         %ÿ�����صĹ���ÿ����������������溯���ľ���
qk = zeros(row,col);
fk = zeros(row,col);
dk = zeros(row,col);
uk = zeros(row,col);
pk = sum(sum(TA))/(row*col)*ones(sample_factor*row,sample_factor*col);              %��TA��ƽ��ֵ��Ϊ��ʼ����ֵ
RMSE_array = zeros(Num_iteration,1);
for k =1:Num_iteration
    tic;
    for y = 1:row_RE
        for x = 1:col_RE            
            for m = 1:row
                for n = 1:col
                    row_current=row_TA_Lat(m);     col_current=col_TA_Long(n);
                    %���ÿ����������������溯������
                    h1 = pattern(row_RE+1-row_current+1:2*row_RE+1-row_current,col_RE+1-col_current+1:2*col_RE+1-col_current);  
                    qk(m,n) = sum(sum(h1));
                    fk(m,n) = sum(sum(pk.* h1))/qk(m,n); 
                    dk(m,n) = sqrt(TA(m,n)/fk(m,n));
%                     j_current = (x-1)*row_RE+y;                     
                    if dk(m,n)<1
                        uk(m,n) = 0.5*fk(m,n)*(1-dk(m,n))+pk(y,x)*dk(m,n);
                    else 
                        uk(m,n) = 1/(0.5/fk(m,n)*(1-1/dk(m,n))+1/(pk(y,x)*dk(m,n)));            
                    end
                    h2(m,n) = h1(y,x);                    
                end
            end            
            gk(y,x) = sum(sum(h2));	%h2(:,(n-1)*0.5*row+m)Ϊ��j�����ص���������溯�����󣬸þ����Ԫ�ذ����ӵ�һ�������㵽���һ����������������溯��
            pk(y,x) = sum(sum(uk.* h2))/gk(y,x);
        end
    end 
    toc;
    RMSE_array(k) = Root_Mean_Square_Error(pk,TB,0,0);   
end
%�������ŵ�������
optimal_iteration = find(RMSE_array == min(RMSE_array));                %�ҳ�MSE����Сֵ����Ϊ���Ż���R����
if flag_draw_iteration ==1
      figure;bar(RMSE_array)
end
TB_SIR = pk;