function [TB_SIR,optimal_iteration] = SIR(TA,TB,pattern,row_TA_Lat,col_TA_Long,Num_iteration,sample_factor,flag_draw_iteration)
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
pk = zeros(sample_factor*row,sample_factor*col);
gk = zeros(sample_factor*row,sample_factor*col);
h1 = zeros(sample_factor*row,sample_factor*col);							 %��i����������������溯���ľ���
h2 = zeros(row*col,(sample_factor^2)*col*row);                               %ÿ�����صĹ���ÿ����������������溯���ľ���
qk = zeros(row,col);
fk = zeros(row,col);
dk = zeros(row,col);
uk = zeros(row*col,(sample_factor^2)*col*row);
pk = sum(sum(TA))/(row*col)*ones(sample_factor*row,sample_factor*col);              %��TA��ƽ��ֵ��Ϊ��ʼ����ֵ
RMSE_array = zeros(Num_iteration,1);
for k =1:Num_iteration
    for m=1:row
        for n=1:col
            row_current=row_TA_Lat(m);     col_current=col_TA_Long(n);
            %���ÿ����������������溯������
            h1 = pattern(sample_factor*row+1-row_current+1:2*sample_factor*row+1-row_current,sample_factor*col+1-col_current+1:2*sample_factor*col+1-col_current);  
            qk(m,n) = sum(sum(h1));
            fk(m,n) = sum(sum(pk.* h1))/qk(m,n); 
            dk(m,n) = sqrt(TA(m,n)/fk(m,n));
            for TB_num=1:(sample_factor^2)*col*row    
                if dk(m,n)<1
                   uk((n-1)*row+m,TB_num) = 0.5*fk(m,n)*(1-dk(m,n))+pk(TB_num)*dk(m,n);
                else 
                   uk((n-1)*row+m,TB_num) = 1/(0.5/fk(m,n)*(1-1/dk(m,n))+1/(pk(TB_num)*dk(m,n)));            
                end
                h2((n-1)*row+m,TB_num) = h1(TB_num);
            end
        end
    end

    for m=1:sample_factor*row
        for n=1:sample_factor*col      
            gk(m,n) = sum(h2(:,(n-1)*sample_factor*row+m));	%h2(:,(n-1)*0.5*row+m)Ϊ��j�����ص���������溯�����󣬸þ����Ԫ�ذ����ӵ�һ�������㵽���һ����������������溯��
            pk(m,n) = sum(h2(:,(n-1)*sample_factor*row+m).*uk(:,(n-1)*sample_factor*row+m))/gk(m,n);
        end
     end
        
   RMSE_array(k) = Root_Mean_Square_Error(pk,TB,0,0);   
end
%�������ŵ�������
optimal_iteration = find(RMSE_array == min(RMSE_array));                %�ҳ�MSE����Сֵ����Ϊ���Ż���R����
if flag_draw_iteration ==1
      figure;bar(RMSE_array)
end
TB_SIR = pk;