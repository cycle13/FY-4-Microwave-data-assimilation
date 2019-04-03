function  MBE = AP_Main_Beam_efficiency_Gail(Ba,Null_theta,taper)
%   �������ܣ������ۺϿ׾����з���ͼ������Ч��**********************************
%            ���շ��ز���Ч��
%  
%   �������:
%    Ba           :���ߵ糤�Ȳ���
%    taper        :�׾��նȣ�
%    Null_BW      :��㲨�����
%   ���������
%    MBE          :������Ч��                                      
%   by �¿� 2016.06.24  ******************************************************

num_Full = 18000;
d_angle=180/num_Full;                %unit degree
theta_all=d_angle:d_angle:90-d_angle;%��ĸ�Ƕȷ�Χ
theta_max = asind(10/Ba); 
theta=d_angle:d_angle:theta_max;     %���ӽǶȷ�Χ

num_theta = length(theta_all);
num_beam_efficiency = length(theta);
beam_efficiency=zeros(1,num_beam_efficiency);
denominator = 0;
numerator = 0;

%�����ĸ  
for n=1:num_theta
    u=Ba*sind(theta_all(n));
    du=Ba*cosd(theta_all(n))*d_angle*pi/180;
    denominator=denominator+(besselj(taper+1,u))^2/u^(2*taper+1)/sqrt(1-(sind(theta_all(n)))^2)*du;
end
%�������
for m=1:num_beam_efficiency
    for n=1:m
        u=Ba*sind(theta(n));
        du=Ba*cosd(theta(n))*d_angle*pi/180;
        numerator=numerator+(besselj(taper+1,u))^2/u^(2*taper+1)/sqrt(1-(sind(theta(n)))^2)*du;
    end
    beam_efficiency(m)=numerator/denominator;
    numerator=0;        
end      
mark_Null =( abs(theta-Null_theta)==min(abs(theta-Null_theta)));
MBE = beam_efficiency(mark_Null)*100;


