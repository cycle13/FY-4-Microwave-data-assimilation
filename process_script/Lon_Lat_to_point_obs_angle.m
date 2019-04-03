function point_obs_angle=Lon_Lat_to_point_obs_angle(Longitude_scene,Latitude_scene,Longtitude_satellite,Latititude_satellite,R,orbit_height )
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
%   point_obs_angle                    : ���۲��
% by ������ 2018.10.12  ****************************************************** 
theta_E = 90-(Latitude_scene-Latititude_satellite);
phi_E = Longitude_scene-Longtitude_satellite;
AB = R*cosd(theta_E);
BC = R*sind(theta_E).*sind(phi_E);
SC = R+orbit_height-R*sind(theta_E).*cosd(phi_E);
SB = sqrt(BC.^2+SC.^2);
phi = atand(BC./SC);
theta = atand(SB./AB);
theta(theta<0) = 180+theta(theta<0);
[row,col]=size(theta);
point_obs_angle=zeros(row,col);
theta_scan=90-theta;
for m=1:row
    for n=1:col
        point_obs_angle(m,n)=asind(((R+orbit_height)/R)*sind(theta_scan(m,n)));
    end
end