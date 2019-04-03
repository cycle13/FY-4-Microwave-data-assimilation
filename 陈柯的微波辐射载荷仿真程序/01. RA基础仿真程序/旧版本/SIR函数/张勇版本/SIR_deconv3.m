function TB = SIR_deconv3(sample_factor,N,TA,pattern,row_TA_Lat,col_TA_Long,TA_real_SIR1)
%   �������ܣ� ��û�й۲�����������ͼ��TA����SIR������������ͼ��ֱ��ʺ;���****************
%              ����SIR���ؽ��������ͼ��
%  
%   �������:
%    TA           �����ؽ�����������ͼ��TA
%    pattern      �����߷���ͼ����
%   ���������
%    TB           : SIR�ؽ��������ͼ����������TAͼ���СΪN*N�����ؽ�ͼ��Ĵ�СΪsample_factorN*sample_factorN��                                     
%   by ���� 2017.3.31  ******************************************************
    [row,col]=size(TA);
    TB = zeros(sample_factor*row,sample_factor*col);                                    %��ʼ��SIR�ؽ�������¾���
	pk = zeros(sample_factor*row,sample_factor*col);
	gk = zeros(sample_factor*row,sample_factor*col);
	h1 = zeros(sample_factor*row,sample_factor*col);									%��i����������������溯���ľ���
	h2 = zeros(row*col,sample_factor*sample_factor*col*row);                               %ÿ�����صĹ���ÿ����������������溯���ľ���
	qk = zeros(row,col);
	fk = zeros(row,col);
	dk = zeros(row,col);
	uk = zeros(row*col,sample_factor*sample_factor*col*row);  
    if N<2
        pk = sum(sum(TA))/(row*col)*ones(sample_factor*row,sample_factor*col);              %��TA��ƽ��ֵ��Ϊ��ʼ����ֵ
    else
        pk=TA_real_SIR1;
    end
   
for i=1:row
	for j=1:col
        row_current=row_TA_Lat(i);
		col_current=col_TA_Long(j);
		h1 = pattern(sample_factor*row+1-row_current+1:2*sample_factor*row+1-row_current,sample_factor*col+1-col_current+1:2*sample_factor*col+1-col_current);  %���ÿ����������������溯������
		qk(i,j) = sum(sum(h1));
		fk(i,j) = sum(sum(pk.* h1))/qk(i,j); 
		dk(i,j) = sqrt(TA(i,j)/fk(i,j));
        for TB_num=1:sample_factor*sample_factor*col*row    
            if dk(i,j)<1
                uk((j-1)*row+i,TB_num) = 0.5*fk(i,j)*(1-dk(i,j))+pk(TB_num)*dk(i,j);
             else 
                uk((j-1)*row+i,TB_num) = 1/(0.5/fk(i,j)*(1-1/dk(i,j))+1/(pk(TB_num)*dk(i,j)));           
            end
            h2((j-1)*row+i,TB_num) = h1(TB_num);
        end
	end
end
for m=1:sample_factor*row
	for n=1:sample_factor*col      
		gk(m,n) = sum(h2(:,(n-1)*sample_factor*row+m));		%h2(:,(n-1)*sample_factor*row+m)Ϊ��j�����ص���������溯�����󣬸þ����Ԫ�ذ����ӵ�һ�������㵽���һ����������������溯��
		pk(m,n) = sum(h2(:,(n-1)*sample_factor*row+m).*uk(:,(n-1)*sample_factor*row+m))/gk(m,n);
	end
end
TB = pk;