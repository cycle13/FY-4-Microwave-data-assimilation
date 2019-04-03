function  AP = Antenna_Pattern_angle_calc(angle,Ba,taper)
%   �������ܣ�����ָ���Ƕ�ֵ��Բ�ο�������ʵ�׾����߷���ͼ**********************************
%             ���ط���ͼȨֵ%  
%   �������:
%   angle        ������������ļн�
%   Ba           : ���ߵ糤�Ȳ���
%   taper        : �׾��նȣ�
%   ���������
%   AP           : ���߹�һ�����ʷ���ͼ                                       
%   by �¿� 2017.03.20  ******************************************************
[num_row,num_col] = size(angle);
AP = zeros(num_row,num_col);
for x = 1:num_col
    for y = 1: num_row
        if isnan(angle(y,x))  %�ж��Ƿ�Ƕ�ֵ�Ƿ�ΪNaN
           AP(y,x) = 0; 
        else
           theta = abs(angle(y,x));
        %����ָ���Ӧ��λ���ӳ���Χ�ڵķ�������߷���ͼ 
           if(sind(theta)<=1e-6)  %�����ĸΪ0ʱ����
              AP(y,x) = 1;
           else
              AP(y,x) = abs((2^(taper+1)* factorial(taper+1)*besselj(taper+1,(Ba*sind(abs(theta))))/((Ba*sind(abs(theta)))^(taper+1)))^2);
           end 
        end
     end
end
AP=AP/sum(sum(AP)); %���߷���ͼ��һ��