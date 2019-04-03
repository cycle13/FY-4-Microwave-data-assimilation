function  AP = Antenna_Pattern_calc(TB,AP_Coordinate_Long,AP_Coordinate_Lat,N_x,N_y,Ba,taper)
%   �������ܣ����ݶ�ά���껭��Բ�ο�������ʵ�׾����߷���ͼ**********************************
%            ����3dB������ȡ���㲨����ȡ�����Ч�ʡ���һ�԰��ƽ������ͼ����
%  
%   �������:
%    Coordinate_x ��x�᷽�����꣬��λ���Ƕ�
%    Coordinate_y ��y�᷽�����꣬��λ���Ƕ�
%    Ba           :���ߵ糤�Ȳ���
%    taper        :�׾��նȣ�
%   ���������
%    AP           : ���߹�һ�����ʷ���ͼ                                       
%   by �¿� 2016.09.24  ******************************************************

TB(isnan(TB)) = 0;
num_row = length(N_x);
num_col = length(N_y);
AP = zeros(num_row,num_col);
for x = 1:num_col
    for y = 1: num_row
            %���λ��
            if(TB(x,y)~=0)
                pix_point = AP_Coordinate_Long(x,y)+1i*AP_Coordinate_Lat(x,y);
                if (abs(pix_point/90)<=1)
                    theta = abs(pix_point);
                    %����ָ���Ӧ��λ���ӳ���Χ�ڵķ�������߷���ͼ 
                   if(sind(theta)<=1e-6)  %�����ĸΪ0ʱ����
                       AP(y,x) = 1;
                   else
                       AP(y,x) = abs((2^(taper+1)* factorial(taper+1)*besselj(taper+1,(Ba*sind(abs(theta))))/((Ba*sind(abs(theta)))^(taper+1)))^2);
                   end
                end
            end
     end
end
AP=AP/sum(sum(AP));      %���߷���ͼ��һ��