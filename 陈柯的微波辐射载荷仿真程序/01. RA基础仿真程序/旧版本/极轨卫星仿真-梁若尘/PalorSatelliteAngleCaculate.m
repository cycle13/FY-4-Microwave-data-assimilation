function [ theta,phi ] = PalorSatelliteAngleCaculate( Coordinate_Long,Coordinate_Lat,satellite_longtitude,satellite_latititude,R,orbit_height )
% ���뼫��������۲�λ�õĵ�����Ϣ���������Ƕ�Ӧ�Ĺ۲�Ƕ�
% Coordinate_Long����Ҫ����ĵ��澭������
% Coordinate_Lat����Ҫ����ĵ���γ������
% satellite_longtitude���������µ�ľ��ȡ�
% satellite_latititude���������µ��γ�ȡ�
% R������뾶��
% orbit_height������߶ȡ�

[a,b] = size(Coordinate_Lat);                                       %��ȡ���������ά��
theta = zeros(a,b);                                                 %��ʼ����λ��
phi = zeros(a,b);                                                   %��ʼ��������

for lat_num = 1:a
    for lon_num =1:b

        Longitude_start = satellite_longtitude;         
        Longitude_end = Coordinate_Long(lat_num,lon_num);
        Latitude_start = satellite_latititude;
        Latitude_end = Coordinate_Lat(lat_num,lon_num);
        if Longitude_start>Longitude_end
        sign_Lo = 1;
        else
        sign_Lo = -1;
        end
        if Latitude_start>Latitude_end
        sign_La = 1;
        else
        sign_La = -1;
        end
        Length_Longitude = R*acos(sind(Latitude_start)*sind(Latitude_start) + cosd(Latitude_start)*cosd(Latitude_start)*cosd(Longitude_start-Longitude_end));  %  ground  longitude size of scene, unit:km
        Length_Latitude = R*acos(sind(Latitude_start)*sind(Latitude_end) + cosd(Latitude_start)*cosd(Latitude_end)*cosd(Longitude_start-Longitude_start));     %  ground  latitude size of scene, unit:km
        theta(lat_num,lon_num) = sign_Lo*atan(Length_Longitude/orbit_height)*180/pi;   
        phi(lat_num,lon_num) = sign_La*atan(Length_Latitude/orbit_height)*180/pi;    

    end
end

end

