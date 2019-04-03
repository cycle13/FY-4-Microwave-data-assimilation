function TB = BG_deconv_real(TA,pattern,NEDT,R)
%   �������ܣ� �Դ��й۲�����������ͼ��TA����BG������������ͼ��ֱ��ʺ;���****************
%              ����BG���ؽ��������ͼ��
%  
%   �������:
%    TA           �����ؽ�����������ͼ��TA
%    pattern      �����߷���ͼ����
%    T_rec        : ����ƽ��ջ��¶�
%    bandwith     : ����ƴ���
%    integral_time: ����ƻ���ʱ��
%    R            : BG����
%   ���������
%    TB           : BG�ؽ��������ͼ��                                       
%   by ������ 2016.10.19  ******************************************************

[row,col]=size(TA);
TB = zeros(row,col);                                                                                        %��ʼ��BG�ؽ�������¾���
n = 1;                                                                                                      %BG�ؽ����������ظ���
m = (2*n+1)^2;                                                                                              %BG�ؽ��õ����������ظ���
r = pi/2*R;                                                                                                 %RȡֵΪ0-1
w = 0.001; 
Var_noise =NEDT^2 *4;                                                   %ͼ�������
T_var = eye(m)*Var_noise;

% matlabpool open 
parfor row_number = 1+n:row-n
    for col_number = 1+n:col-n        
        u = zeros(m,1);                                                                                     %��ʼ��uʸ��
        v = zeros(m,1);                                                                                     %��ʼ��vʸ��
        G = zeros(m,m);                                                                                     %��ʼ��G����
        pattern_zeros = zeros(row,col);                     
        Antenna_pattern = zeros(row,col,m);                                                                 %��ʼ��һ����ά������m������ͼ
        Ta = zeros(1,m);                                                                                    %��ʼ��Ta���������ڴ����Χm��TA��ֵ
        %��ָ��λ�����ɾ���pattern_zeros
        for range_row = -n:n
            for range_col = -n:n
                pattern_zeros(row_number+range_row,col_number+range_col) = 1/m;
            end
        end
        for range_row = -n:n
            for range_col = -n:n
                Col_number = col_number+range_col;                                                          %��ǰλ�õ�������
                Row_number = row_number+range_row;                                                          %��ǰλ�õ�������
                col_start = col+1-Col_number+1;                                                             %��ȡ����ͼ������ʼֵ
                col_end = 2*col+1-Col_number;                                                               %��ȡ����ͼ������ֵֹ
                row_start = row+1-Row_number+1;                                                             %��ȡ����ͼ������ʼֵ
                row_end = 2*row+1-Row_number;                                                               %��ȡ����ͼ������ֵֹ
                Antenna_pattern_t = pattern(row_start:row_end,col_start:col_end);                           %��ȡ����ͼ
                Antenna_pattern_t = Antenna_pattern_t/sum(sum(Antenna_pattern_t));                          %����ͼ��һ��
                Antenna_pattern(:,:,(range_row+n)*(2*n+1)+range_col+n+1) = Antenna_pattern_t;               %����ȡ�ķ���ͼ������ά�����С����ڼ���G����
                u((range_row+n)*(2*n+1)+range_col+n+1) = sum(sum(Antenna_pattern_t));                       %����uʸ��
                v((range_row+n)*(2*n+1)+range_col+n+1) = sum(sum(Antenna_pattern_t.*pattern_zeros));        %����vʸ��
                Ta(1,(range_row+n)*(2*n+1)+range_col+n+1) = TA(row_number+range_row,col_number+range_col);  %����Χ���������δ���Ta��          
            end
        end
        for i = 1:m
            for j = 1:m
                G(i,j) = sum(sum(Antenna_pattern(:,:,i).*Antenna_pattern(:,:,j)));                          %����G����       
            end 
        end
        R = G*cos(r)+(T_var)*w*sin(r);                                                      
        q = pinv(R)*(v*cos(r)+(1-u'*pinv(R)*v*cos(r))/(u'*pinv(R)*u)*u);                                    %����Ȩֵ����q
        TB(row_number,col_number) = Ta*q;                                                                   %��Ȩֵq����Χ���µõ������������TB 
    end
end
% matlabpool close
%BG�ؽ����ܴ����Ե���е����أ���ԭͼ��ֵ����
TB(1:n,:) = TA(1:n,:);
TB(row-n+1:row,:) = TA(row-n+1:row,:);
TB(:,1:n) = TA(:,1:n);
TB(:,col-n+1:col) = TA(:,col-n+1:col);


