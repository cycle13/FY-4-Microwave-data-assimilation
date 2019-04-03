function  MBE = AP_Main_Beam_efficiency(Ba,Null_BW,taper)
%   �������ܣ������ۺϿ׾����з���ͼ������Ч��**********************************
%            ���ز���Ч��
%  
%   �������:
%    Ba           :���ߵ糤�Ȳ���
%    taper        :�׾��նȣ�
%    Null_BW      :��㲨�����
%   ���������
%    MBE          :������Ч��                                      
%   by �¿� 2016.06.24  ******************************************************

Main_lobe = 0;
Full_lobe = 0;
num_Full = 10000;
theta_x = linspace(-90,90,num_Full);        %x��������
theta_y = linspace(-90,90,num_Full);        %y��������
AP_MBE = zeros(num_Full,num_Full);
matlabpool open;
parfor x = 1:num_Full
    for y = 1:num_Full 
    %���λ��
    pix_point = theta_x(x)+1i*theta_y(y);
    if (abs(pix_point/90)<=1)
        theta = abs(pix_point);
    %����ָ���Ӧ��λ���ӳ���Χ�ڵķ�������߷���ͼ 
        if(sind(theta)<=1e-6)  %�����ĸΪ0ʱ����
           AP_MBE(y,x) = 1;
        else
           AP_MBE(y,x) = abs((2^(taper+1)* factorial(taper+1)*besselj(taper+1,(Ba*sind(abs(theta))))/((Ba*sind(abs(theta)))^(taper+1)))^2);
        end
        if theta <= Null_BW
            Main_lobe = Main_lobe+AP_MBE(y,x);             
        end
        Full_lobe = Full_lobe+AP_MBE(y,x) ;
     end      
    end
 end
matlabpool close;
MBE = Main_lobe/Full_lobe*100;