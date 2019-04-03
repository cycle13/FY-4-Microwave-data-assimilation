function TA = Satellite_POES_conv(TB,Long_scene,Lat_scene,Long_observation,Lat_observation,Long_Subsatellite,Lat_Subsatellite,R,orbit_height,Antenna_Patter,angle)
%   �������ܣ�ʵ�ּ��������غ����߷���ͼ�����۲����**********************************
%  
%   �������:
%   TB              : �����߷ֱ�������ͼ��
%   Long_scene      : ������������
%   Lat_scene       ������γ������
%   Long_observation�����ǹ۲�㾭������
%   Lat_observation �����ǹ۲��γ������
%   Long_Subsatellite:�������µ㾭������
%   Lat_Subsatellite:�������µ�γ������
% % R               : ����뾶
%   orbit_height    �����ǹ���߶�
%   Ba              �����߷���ͼ����糤��
% illumination_taper: ���߷���ͼ����׶��
%   ���������
%   TA      : ����ɨ������Ĺ۲����� 
%   by �¿� 2016.12.22  ******************************************************  

%%%%%%%%%%%%%%%%����ģ��۲�����TA%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%��ʼ���۲����������ͼ��TA
[num_Long,num_Lat] = size(Lat_observation);
TA=zeros(num_Long,num_Lat);   %��ʼ���۲�����
TB_nan = TB;                  %
TB(isnan(TB)) = 0;            %��TB��NaNֵ��Ϊ��
%ģ�������غ�����ɨ����̣�����TA
% matlabpool open ;
parfor k =1:num_Lat  %����ÿһ�еĹ۲�����
     tic;
    current_Subsatellite_Long = Long_Subsatellite(k);   %��ǰ�����µ㾭������
    current_Subsatellite_Lat  = Lat_Subsatellite(k);    %��ǰ�����µ�γ������
    current_observation_Long  = Long_observation(:,k);  %���ǲ����㾭������
    current_observation_Lat   = Lat_observation(:,k);   %���ǲ�����γ������ 
%   �������ǹ��ת��Ϊ������ǵĽǶ�����
    [theta_scene,phi_scene] = Satellite_Sphere_Coordinate_Calc(Long_scene,Lat_scene,current_Subsatellite_Long,current_Subsatellite_Lat,R,orbit_height);
    theta_scene(isnan(TB_nan)) = NaN;phi_scene(isnan(TB_nan)) = NaN;
    [theta_observation,phi_observation] = Satellite_Sphere_Coordinate_Calc(current_observation_Long,current_observation_Lat,current_Subsatellite_Long,current_Subsatellite_Lat,R,orbit_height);
%   ����ÿ�еĲ�������������Ӧָ������߷���ͼ���꣬Ȼ����ֵõ����¡�    
    for m =1:num_Long     
        antenna_pattern_angle = vector_angle_calc(theta_observation(m),phi_observation(m),theta_scene,phi_scene);
%         Antenna_Pattern_current = Antenna_Pattern_angle_calc(antenna_pattern_angle,Ba,illumination_taper)  ;  
        Antenna_Pattern_current = Antenna_Pattern_interp(antenna_pattern_angle,Antenna_Patter,angle); 
        TA(m,k)=sum(sum(TB.* Antenna_Pattern_current));       
    end
     toc;
end
% matlabpool close ;




