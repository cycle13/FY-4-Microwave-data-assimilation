function [Long_observation,Lat_observation] = GOES_observation_coordinate_calc(angle_Long,angle_Lat,sample_width_Long,sample_width_Lat,Long_scene,Lat_scene)
%   �������ܣ�����۲�����㾭γ������**********************************
%             
%  �������:
%   angle_Lat       : ����γ�ȷ���Ƕȷ�Χ
%   angle_Long      ���������ȷ���Ƕȷ�Χ
% sample_width_Long : ���ȷ�������Ƕȼ��
% sample_width_Lat  : γ�ȷ�������Ƕȼ��
% Lat_scene         ������γ������
% Long_scene        : ������������
%  ���������
% Long_observation  : �۲�㾭������
% Lat_observation   ���۲��γ������ 
%   by �¿� 2016.12.22  ******************************************************  
[N_y,N_x] = size(Long_scene);
N_TA_Lat = round(angle_Lat/sample_width_Lat);                   %γ�ȷ�����������ɨ�����  
N_TA_Long = round(angle_Long/sample_width_Long);                %���ȷ�����������ɨ�����  
%��������ÿ��ɨ�貨��ָ��Ƕ�Ӧ������ͼ���С��б��
row_TA_Lat = zeros(1,N_TA_Lat);                                 %����ÿ��ɨ�貨��ָ��Ƕ�Ӧ������ͼ���б��
col_TA_Long = zeros(1,N_TA_Long);                               %����ÿ��ɨ�貨��ָ��Ƕ�Ӧ������ͼ���б��
for k = 1:N_TA_Lat  %�б��
    delta_angle=(k-1)*(sample_width_Lat);
    row_TA_Lat(k) = min(round(delta_angle/angle_Lat*N_y)+1,N_y);    
end
for k = 1:N_TA_Long  %�б��
    delta_angle=(k-1)*(sample_width_Long);
    col_TA_Long(k) = min(round(delta_angle/angle_Long*N_x)+1,N_x);    
end
Long_observation = zeros(N_TA_Lat,N_TA_Long);
Lat_observation = zeros(N_TA_Lat,N_TA_Long);
for m = 1:N_TA_Lat
    for n = 1:1:N_TA_Long
        Long_observation(m,n) = Long_scene(row_TA_Lat(m),col_TA_Long(n));
        Lat_observation(m,n)  = Lat_scene(row_TA_Lat(m),col_TA_Long(n));
    end
end

