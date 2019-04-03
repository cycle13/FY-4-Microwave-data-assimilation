function [WRF_angles] =Satellite_Sphere_Coordinate_dotrt_wrfangles(Longitude_scene,Latitude_scene,Longtitude_satellite,Latititude_satellite,R,orbit_height)
% ����������۲�λ�õĵ�����Ϣ���������Ƕ�Ӧ�Ĺ۲�Ƕ�
%   �������:
%   Longitude_scene             : ������㾭���������
%   Latitude_scene              : �������γ���������
%   Longtitude_satellite        ���������µ㾭������
%   Latititude_satellite        ���������µ�γ������
%   R                           ������뾶
%   orbit_height                �����ǹ���߶�
%   ���������
%   theta                       : �������������������ϵ���춥������
%   phi                         : �������������������ϵ�·�λ������
%   WRF_angle                   : DOTRTģ���춥�ǽǶ���Ϣ
% by ������ 2018.09.17  ****************************************************** 
theta_E = 90-(Latitude_scene-Latititude_satellite);
phi_E = Longitude_scene-Longtitude_satellite;
AB = R*cosd(theta_E);
BC = R*sind(theta_E).*sind(phi_E);
SC = R+orbit_height-R*sind(theta_E).*cosd(phi_E);
SB = sqrt(BC.^2+SC.^2);
phi = atand(BC./SC);
theta = atand(AB./SB);
theta(theta<0) = 180+theta(theta<0);
for m=1:251
    for n=1:251
        WRF_angles(m,n)=asind(((R+orbit_height)/R)*sind(theta(m,n)));
    end
end
end