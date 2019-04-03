function [angle_Longitude,angle_Latitude] = Image_Long_Lat_calc_cycle(LAT,LON,R,orbit_height)
%��������Wrfout����ļ��ж�ȡ�����泡���ľ�γ�ȷ�Χ��Ȼ������غɹ���߶ȼ��㳡������ά�ϵ��춥�Ƿ�Χ�������غ�����λ�ڳ���������
%%import coordinate information of scene%%%%%%%%%%%%%%%%%%%%                
                    % read latitude coordinate of scene
Longitude =LAT.';
Latitude = LON.';

num_Longitude = size(Longitude,2);
num_Latitude = size(Latitude,1);

Longitude_start = Longitude(1,1);
Longitude_end = Longitude(1,num_Longitude);
Latitude_start = Latitude(1,1);
Latitude_end = Latitude(num_Latitude,1);

Length_Longitude = R*acos(sind(Latitude_start)*sind(Latitude_start) + cosd(Latitude_start)*cosd(Latitude_start)*cosd(Longitude_start-Longitude_end));  %  ground  longitude size of scene, unit:km
Length_Latitude = R*acos(sind(Latitude_start)*sind(Latitude_end) + cosd(Latitude_start)*cosd(Latitude_end)*cosd(Longitude_start-Longitude_start));     %  ground  latitude size of scene, unit:km
angle_Longitude = Length_Longitude/orbit_height*180/pi;   %   longitude angle scope of scene from orbit heigth, unit:degree
angle_Latitude = Length_Latitude/orbit_height*180/pi;    %   latitude angle scope of scene from orbit heigth, unit:degree


