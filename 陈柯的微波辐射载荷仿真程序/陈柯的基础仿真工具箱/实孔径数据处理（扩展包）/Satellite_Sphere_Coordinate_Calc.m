function [theta,phi ] =Satellite_Sphere_Coordinate_Calc(Longitude_scene,Latitude_scene,Longtitude_satellite,Latititude_satellite,R,orbit_height )
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
% by �¿� 2017.03.15  ****************************************************** 
theta_E = 90-(Latitude_scene-Latititude_satellite);
phi_E = Longitude_scene-Longtitude_satellite;
AB = R*cosd(theta_E);
BC = R*sind(theta_E).*sind(phi_E);
SC = R+orbit_height-R*sind(theta_E).*cosd(phi_E);
SB = sqrt(BC.^2+SC.^2);
phi = atand(BC./SC);
theta = atand(SB./AB);
theta(theta<0) = 180+theta(theta<0);
end

