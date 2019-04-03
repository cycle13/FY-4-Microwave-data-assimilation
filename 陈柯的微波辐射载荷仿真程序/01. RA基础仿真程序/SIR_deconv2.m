function [TB_SIR,optimal_iteration] = SIR_deconv2(TA,TB,pattern,row_TA_Lat,col_TA_Long,Num_iteration,sample_factor,flag_draw_iteration)
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
row_RE = sample_factor*row; col_RE = sample_factor*col;
num_TA = row*col; num_RE = row_RE*col_RE;
TA_1D = reshape(TA,num_TA,1);
gk = zeros(num_RE,1);
% h1 = zeros(num_RE,1);							 %��i����������������溯���ľ���
h2 = zeros(num_TA,1);                            %ÿ�����صĹ���ÿ����������������溯���ľ���
qk = zeros(num_TA,1);
fk = zeros(num_TA,1);
dk = zeros(num_TA,1);
uk = zeros(num_TA,1);
pk = sum(TA_1D)/(num_TA)*ones(num_RE,1);              %��TA��ƽ��ֵ��Ϊ��ʼ����ֵ
RMSE_array = zeros(Num_iteration,1);
for k =1:Num_iteration    
    for j = 1:num_RE
        for i = 1:num_TA 
            if mod(i,row) == 0
               m = row; n = i/row;
            else
               m = mod(i,row);  n = floor(i/row)+1;
            end 
            row_current=row_TA_Lat(m);     col_current=col_TA_Long(n);
            %���ÿ����������������溯������
            h1 = shape(pattern(row_RE+1-row_current+1:2*row_RE+1-row_current,col_RE+1-col_current+1:2*col_RE+1-col_current),num_RE,1);
            qk(i) = sum(h1);
            fk(i) = sum(pk.* h1)/qk(i); 
            dk(i) = sqrt(TA_1D(i)/fk(i));
%           j_current = (x-1)*row_RE+y;                     
            if dk(i)<1
               uk(i) = 0.5*fk(i)*(1-dk(i))+pk(j)*dk(i);
            else 
               uk(i) = 1/(0.5/fk(i)*(1-1/dk(i))+1/(pk(j)*dk(i)));            
            end
            h2(i) = h1(j);                
         end
         gk(j) = sum(h2);	%h2(:,(n-1)*0.5*row+m)Ϊ��j�����ص���������溯�����󣬸þ����Ԫ�ذ����ӵ�һ�������㵽���һ����������������溯��
         pk(j) = sum(uk.* h2)/gk(j);       
    end
    TA_RE = reshape(pk,row_RE,col_RE);
    RMSE_array(k) = Root_Mean_Square_Error(TA_RE,TB,0,0);   
end
%�������ŵ�������
optimal_iteration = find(RMSE_array == min(RMSE_array));                %�ҳ�MSE����Сֵ����Ϊ���Ż���R����
if flag_draw_iteration ==1
      figure;bar(RMSE_array)
end
TB_SIR = TA_RE;