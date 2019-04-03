function TA = Satellite_GOES_conv(TB,theta_scene,phi_scene,theta_observation,phi_observation,Ba,illumination_taper)
%   �������ܣ�ʵ�־�ֹ��������غ����߷���ͼ�����۲����**********************************
%             
%  �������:
%    TB             : �����߷ֱ�������ͼ��
%   theta_scene     : �������������������ϵ���춥������
%   angle_y         ���������������������ϵ�·�λ������ 
%theta_observation  ���۲������������������ϵ���춥������
%phi_observation    ���۲������������������ϵ�·�λ������
% Ba                �����߷���ͼ���㺯��
% illumination_taper: ���߷���ͼ����׶��
%  ���������
% TA                : ����ɨ������Ĺ۲����� 
%   by �¿� 2017.03.22  ******************************************************  
%%%%%%%%%%%%%%%%����ģ��۲�����TA%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%��ʼ���۲����������ͼ��TA
[N_TA_Lat,N_TA_Long] = size(theta_observation);
TA=zeros(N_TA_Lat,N_TA_Long); 
%����һ���Ƕ��ܼ����غ����߷���ͼ
angle = linspace(0,180,180000);
Antenna_Patter = Antenna_Pattern_angle_calc(angle,Ba,illumination_taper);
% matlabpool open ;
parfor m=1:N_TA_Lat
    tic;
     for n=1:N_TA_Long
         %���ղ�������������Ӧָ������߷���ͼ���꣬Ȼ����ֵõ�����TA           
         antenna_pattern_angle = vector_angle_calc(theta_observation(m,n),phi_observation(m,n),theta_scene,phi_scene);
         Antenna_Pattern_current = Antenna_Pattern_interp(antenna_pattern_angle,Antenna_Patter,angle); 
%          Antenna_Pattern_current = Antenna_Pattern_angle_calc(antenna_pattern_angle,Ba,illumination_taper);          
         TA(m,n)=sum(sum(TB.* Antenna_Pattern_current));        
     end
    toc;
end
% matlabpool close ;