function  angle = antenna_theta_calc(theta_axis,phi_axis,theta,phi)
%   �������ܣ�����������ϵ��һ���ο�������һ����������֮��ļн�**********************************
%            ���ؼнǾ���
%  
%   �������:
%    theta_axis ���ο��������춥��
%    phi_axis   ���ο������ķ�λ��
%    theta      : ����������춥��
%    phi        : ��������ķ�λ��
%   ���������
%    angle      : �нǾ���                                       
%   by �¿� 2016.09.24  ******************************************************
theta1 = phi_axis ;
phi1 =90-theta_axis;
theta2 = phi;
phi2 = 90-theta; 

a = cosd(theta1);
b = cosd(theta2);
c = tand(phi1);
d = tand(phi2);
e = tand(theta1);
f = tand(theta2);
angle = acosd((1/a^2+1./b.^2+c^2+d.^2-(e-f).^2-(c-d).^2)./(2*sqrt((1/a^2+c^2)*(1./b.^2+d.^2))));



