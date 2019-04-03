%������ģ��ʵ�׾�������غɹ۲�����
%by �¿� 2015.11.10 --updated 2016.10.19 

clear;
close all;
tic;
%%***************************���²��������ñ�־λ�͹������**********************************************************
flag_draw_TB = 1;                               %��ԭʼ����TB��־λ  
flag_draw_pattern = 0;                          %�����߷���ͼ��־λ
flag_save = 0;                                  %���ݴ洢��־λ
flag_Resolution_Enhancement  = 0;               %ʹ�÷ֱ�����ǿ�����־λ
Resolution_Enhancement_name = 'SIR';             %��ѡ�㷨��BG��WienerFilter��SIR��ODC
RMSE_offset  = 0;                              %�۲�ͼ����ԭʼͼ��Ա�ʱͼ���Եȥ�����л�����
R = 6371;                                       %����뾶 unit:km
orbit_height = 35786;                           %����߶ȣ���ǰΪ����ֹ�����, unit:km
Long_Subsatellite = -99.5;                      %��ֹ���������������
Lat_Subsatellite = 0;                           %��ֹ�����������γ��
%*********************************************************************************************************

%% ********************************************************part1����������ͼ�񳡾��������ռ����������ֵ********************************************
%����ѡ��ģ�����³�����ȡ��ӦƵ�ε�ģ������ͼ��
file_path = 'D:\��ǰ�Ĺ���\2015.03.21 ��������ͬ����GEO�����о�\01. ������������\2016.10.09 쫷�sandy-NAM-20121029\����ͼ��';   %�ļ��洢Ŀ¼ 
TB_filename = 'HurricanSandy_29_00_C5_H';     %����ͼ���ļ������ó�����ΧΪ1500*1500����
TB_matfile = sprintf('%s\\%s.mat', file_path,TB_filename);
load(TB_matfile);
TB=(pic); [N_Lat,N_Long] = size(TB); 
T_max=max(max(TB)); T_min=min(min(TB));% T_min=220;
%��ȡ�����ľ��Ⱥ�γ������,Ȼ��������ǹ��ת��Ϊ������ǵĽǶ�����
coordinate_filename = sprintf('%s\\coords.mat', file_path);
load(coordinate_filename);
Long_scene =XLO.';  Lat_scene = XLA.';  %���㳡����㾭γ������
%�������ǹ�����㳡������������������ϵ�µĽǶ�����
[theta_scene,phi_scene] = Satellite_Sphere_Coordinate_Calc(Long_scene,Lat_scene,Long_Subsatellite,Lat_Subsatellite,R,orbit_height);
%���㳡��������ǵĽǶȷ�Χ
angle_Long = vector_angle_calc(theta_scene(1,1),phi_scene(1,1),theta_scene(1,N_Long),phi_scene(1,N_Long));
angle_Lat = vector_angle_calc(theta_scene(1,1),phi_scene(1,1),theta_scene(N_Lat,1),phi_scene(N_Lat,1));
%����ռ���Ƕ�ֵ
d_Long = angle_Long/(N_Long);                  %����ͼ�񾭶ȷ�����С��࣬���Ƕȷֱ���  
d_Lat = angle_Lat/(N_Lat);                     %����ͼ��γ�ȷ�����С��࣬���Ƕȷֱ��� 
%����ͼ�����ʵ�ռ��ά�Ƕ�����ֵ
Coordinate_Long = linspace(-angle_Long/2,angle_Long/2-d_Long,N_Long);   %���ȽǶ���������
Coordinate_Lat = linspace(-angle_Lat/2,angle_Lat/2-d_Lat,N_Lat);        %γ�ȽǶ���������
%������������ͼ��
if  flag_draw_TB == 1;
    figure;imagesc(Coordinate_Long,Coordinate_Lat,TB,[T_min T_max]);axis equal;xlim([-angle_Long/2,angle_Long/2]);ylim([-angle_Lat/2,angle_Lat/2]);
    xlabel('���ȷ���'); ylabel('γ�ȷ���');title('ԭʼ����ͼ��TB');colorbar;
end
%�������������ļ���ȡ�ļ��е�Ƶ����
length_filename = length(TB_filename);
if strcmpi('C',TB_filename(length_filename-3))
     freq_index = str2double(TB_filename(length_filename-2));     
else
     freq_index = str2double([TB_filename(length_filename-3),TB_filename(length_filename-2)]);     
end
%part1��end**************************************************************************************************************************************************

%% ********************************************************part2��������غɲ�����ɨ�������������**************************************************************
%%***************************���÷���Ʋ���******************************
%% ������ÿ��Ƶ�㶼��һ���ķ�����غɲ���
switch freq_index   %����Ƶ��,��λ:Hz  %����, ��λ:Hz     %����ϵ��,��λ:dB   %���߿ھ�����λ����
             case 1, freq= 50.3e9;   bandwith = 180e6;    noise_figure= 6;  antenna_diameter = 5; 
             case 2, freq= 51.76e9;  bandwith = 400e6;    noise_figure= 6;  antenna_diameter = 5; 
             case 3, freq= 52.8e9;   bandwith = 400e6;    noise_figure= 6;  antenna_diameter = 5; 
             case 4, freq= 53.596e9; bandwith = 2*170e6;  noise_figure= 6;  antenna_diameter = 5; 
             case 5, freq= 54.4e9;   bandwith = 400e6;    noise_figure= 6;  antenna_diameter = 5; 
             case 6, freq= 54.94e9;  bandwith = 400e6;    noise_figure= 6;  antenna_diameter = 5; 
             case 7, freq= 55.5e9;   bandwith = 330e6;    noise_figure= 6;  antenna_diameter = 5; 
             case 8, freq= 57.29e9;  bandwith = 2*155e6;    noise_figure= 6;  antenna_diameter = 5; 
             case 9, freq= 57.507e9; bandwith = 2*78e6;   noise_figure= 6;  antenna_diameter = 5; 
             case 10,freq= 57.66e9;  bandwith = 2*36e6;   noise_figure= 6;  antenna_diameter = 5; 
             case 11,freq= 57.63e9;  bandwith = 2*16e6;   noise_figure= 6;  antenna_diameter = 5; 
             case 12,freq= 57.62e9;  bandwith = 2*8e6;    noise_figure= 6;  antenna_diameter = 5; 
             case 13,freq= 57.617e9; bandwith = 2*3e6;    noise_figure= 6;  antenna_diameter = 5; 
             case 14,freq= 88.2e9;   bandwith = 2000e6;   noise_figure= 9;  antenna_diameter = 5; 
             case 15,freq= 118.83e9; bandwith = 2*20e6;   noise_figure= 10;  antenna_diameter = 2.4;
             case 16,freq= 118.95e9; bandwith = 2*100e6;  noise_figure= 10;  antenna_diameter = 2.4;
             case 17,freq= 119.05e9; bandwith = 2*165e6;  noise_figure= 10;  antenna_diameter = 2.4;
             case 18,freq= 119.55e9; bandwith = 2*200e6;  noise_figure= 10;  antenna_diameter = 2.4;
             case 19,freq= 119.85e9; bandwith = 2*200e6;  noise_figure= 10;  antenna_diameter = 2.4;
             case 20,freq= 121.25e9; bandwith = 2*200e6;  noise_figure= 10;  antenna_diameter = 2.4;
             case 21,freq= 121.75e9; bandwith = 2*1000e6; noise_figure= 10;  antenna_diameter = 2.4;
             case 22,freq= 123.75e9; bandwith = 2*2000e6; noise_figure= 10;  antenna_diameter = 2.4;
             case 23,freq= 165.5e9;  bandwith = 2*1150e6;   noise_figure= 12;  antenna_diameter = 2.4;
             case 24,freq= 190.31e9; bandwith = 2*2000e6; noise_figure= 12;  antenna_diameter = 2.4;
             case 25,freq= 187.81e9; bandwith = 2*2000e6; noise_figure= 12;  antenna_diameter = 2.4;
             case 26,freq= 186.31e9; bandwith = 2*1000e6; noise_figure= 12;  antenna_diameter = 2.4;
             case 27,freq= 185.11e9; bandwith = 2*1000e6; noise_figure= 12;  antenna_diameter = 2.4;
             case 28,freq= 184.31e9; bandwith = 2*500e6;  noise_figure= 12;  antenna_diameter = 2.4;
             case 29,freq= 380e9;    bandwith = 2*1000e6; noise_figure= 13; antenna_diameter = 2.4;
             case 30,freq= 428.763e9;bandwith = 2*1000e6; noise_figure= 13; antenna_diameter = 2.4;
             case 31,freq= 426.263e9;bandwith = 2*600e6;  noise_figure= 13; antenna_diameter = 2.4;
             case 32,freq= 425.763e9;bandwith = 2*400e6;  noise_figure= 13; antenna_diameter = 2.4;
             case 33,freq= 425.363e9;bandwith = 2*200e6;  noise_figure= 13; antenna_diameter = 2.4;
             case 34,freq= 425.063e9;bandwith = 2*100e6;  noise_figure= 13; antenna_diameter = 2.4;
             case 35,freq= 424.913e9;bandwith = 2*60e6;   noise_figure= 13; antenna_diameter = 2.4;
             case 36,freq= 424.833e9;bandwith = 2*20e6;   noise_figure= 13; antenna_diameter = 2.4;
             case 37,freq= 424.793e9;bandwith = 2*10e6;   noise_figure= 13; antenna_diameter = 2.4;
end     
%% �����ǲ���ÿ��Ƶ���޸ĵķ���Ʋ���
c=3e8;                                                      %���� unit m/s
wavelength = c/freq;                                        %���� unit:m
integral_time = 40*10^(-3);                                 %����ʱ��, unit:S                                           
T_rec=290*(10^(noise_figure/10)-1);                         %����Ƶ�Ч�����¶�, unit:K
NEDT = (T_rec+250)/sqrt(bandwith*integral_time);            %����������ȣ���λ��K
Ba = pi*antenna_diameter/wavelength;                        %���ߵ糤�Ȳ���
illumination_taper = 1;                                    %the illumination taper //by thesis of G.M.Skofronick
%%***************************����ɨ������Ƕȼ������*******************
%���÷���һ�����շ������߹���Ƶ�εĲ�����ȵ�ĳһ��������
% sample_freq = 424.763e9;                                   %�������߹���Ƶ��
% sample_factor = 1;                                         %����ϵ����Ϊ������������Ƶ�β������֮��
% sample_wavelength = c/sample_freq;                         %�������߹���Ƶ�εĲ���
% sample_antenna_diameter = 2.4;
% sample_beam=sample_wavelength/sample_antenna_diameter*180/pi;%�������߹���Ƶ�ζ�Ӧ�������
% sample_width = sample_factor*sample_beam;                  %�غ�����ɨ��������λ����
% sample_width_Lat = max(sample_width,d_Lat);                %��γ�ȷ������߲����ĸ��Ƕ�
% sample_width_Long = max(sample_width,d_Long);              %�ھ��ȷ������߲����ĸ��Ƕ�
%���÷����������յ�ǰ����ͼ�����С����ı������ò������
sample_factor = 2;
sample_width_Lat = sample_factor*d_Lat;                      %��γ�ȷ������߲����ĸ��Ƕ�
sample_width_Long = sample_factor*d_Long;                    %�ھ��ȷ������߲����ĸ��Ƕ�
sample_width = sample_width_Long;
%���÷����������յ�ǰ����Ƶ�εĲ�����ȵ�ĳһ��������
% sample_factor = 0.5;                                       %����ϵ����Ϊ��������뵱ǰƵ�ʲ������֮��
% sample_width = sample_factor*beam_width;                   %�غ�����ɨ��������λ����
% sample_width_Lat = max(sample_width,d_Lat);                %��γ�ȷ������߲����ĸ��Ƕ�
% sample_width_Long = max(sample_width,d_Long);              %�ھ��ȷ������߲����ĸ��Ƕ�
%���÷����ģ�ֱ�Ӱ���ĳһ����ɨ��������
% sample_width = 0.01;                                       %�غ�����ɨ��������λ����
% sample_width_Lat = max(sample_width,d_Lat);                %��γ�ȷ������߲����ĸ��Ƕ�
% sample_width_Long = max(sample_width,d_Long);              %�ھ��ȷ������߲����ĸ��Ƕ�
%%%%%%%����۲�����㾭γ�����������������ϵ�µĽǶ�����
[Long_observation,Lat_observation] = GOES_observation_coordinate_calc(angle_Long,angle_Lat,sample_width_Long,sample_width_Lat,Long_scene,Lat_scene);
[theta_observation,phi_observation] = Satellite_Sphere_Coordinate_Calc(Long_observation,Lat_observation,Long_Subsatellite,Lat_Subsatellite,R,orbit_height);
%part2��end**************************************************************************************************************************************************

%% ********************************************************part3��ģ����������ɨ��۲������̣�����۲����������ͼ��TA**************************************
[Antenna_Pattern,HPBW,SLL,MBE] = RA_antenna_pattern_2D(Ba,Coordinate_Long,Coordinate_Lat,angle_Long,angle_Lat,illumination_taper,freq_index,flag_draw_pattern);
ground_resolution = HPBW/180*pi*orbit_height;                  %�������ֱ���
sample_density = HPBW/sample_width;                            %����������������ı�ֵ������ÿ��������Χ�ڵĲ�������
%ģ������ɨ�跽ʽ��ù۲�����TA
TA_noiseless = Satellite_GOES_conv(TB,theta_scene,phi_scene,theta_observation,phi_observation,Ba,illumination_taper);
%%%%��ģ��۲�����TA����ϵͳ����
[TA] = add_image_noise(TA_noiseless,bandwith,integral_time,noise_figure);
%������񾫶ȣ��ù۲�����TA������Tb��RMSE�����ϵ��������
[RMSE] = Root_Mean_Square_Error(TB,TA,RMSE_offset,0);
Corr_coefficient = TB_correlation_coefficient(TB,TA,RMSE_offset);
TA_observation = interpolation(TA,N_Lat,N_Long);
delta_T = reshape(TA_observation-TB,N_Lat*N_Long,1);
ObsErr_mean = mean(delta_T);  ObsErr_std = std(delta_T);
%�����۲�����ͼ��
figure;imagesc(Coordinate_Long,Coordinate_Lat,TA,[T_min T_max]);axis equal;xlim([-angle_Long/2,angle_Long/2]);ylim([-angle_Lat/2,angle_Lat/2]);
xlabel('���ȷ���'); ylabel('γ�ȷ���');title('�۲�����ͼ��TA');colorbar;
%part3��end**************************************************************************************************************************************************

%% ********************************************************part4�������ֱ�����ǿ����*********************************************************************
if  flag_Resolution_Enhancement == 1;
    switch Resolution_Enhancement_name 
    % %��ѡ�㷨��BG��Wiener Filter��SIR��ODC
    case 'BG'
        max_R = 0.02; 
        num_R = 4;
        [TA_RE,factor_opt] = Backus_Gilbert_deconv(TA,TB,angle_Long,angle_Lat,Ba,illumination_taper,NEDT,num_R,max_R,RMSE_offset);
    case 'WienerFilter' 
        SNR_num = 100;
        [TA_RE,factor_opt] = Wiener_Filter_deconv(TA,TB,Antenna_Pattern,NEDT,SNR_num,RMSE_offset);
    case 'SIR'
        Block_num = 6;                                                                                              %���ݷֿ�����
        
        
        
        [TA_RE,factor_opt] = Scatterometer_Image_Restruction(TA,TB,angle_Long,angle_Lat,Ba,illumination_taper,row_TA_Lat,col_TA_Long,Block_num);
            
    case 'ODC'        
    end    
    %�����ֱ�����ǿ����������ͼ��
    figure;imagesc(Coordinate_Long,Coordinate_Lat,TA_RE,[T_min T_max]);axis equal;xlim([-angle_Long/2,angle_Long/2]);ylim([-angle_Lat/2,angle_Lat/2]);
    xlabel('���ȷ���'); ylabel('γ�ȷ���');title([Resolution_Enhancement_name,'�ֱ�����ǿ����������ͼ��TA_RE']);colorbar;
    %����ֱ�����ǿ��Ĺ۲⾫�ȣ����ؽ�����TA_RE������TB��RMSE�����ϵ��������
    [RMSE_RE] = Root_Mean_Square_Error(TB,TA_RE,RMSE_offset,0);
     Corr_coefficient_RE = TB_correlation_coefficient(TB,TA_RE,RMSE_offset);
     TA_observation_RE = interpolation(TA_RE,N_Lat,N_Long);
     delta_T = reshape(TA_observation_RE-TB,N_Lat*N_Long,1);
     ObsErr_RE_mean = mean(delta_T);  ObsErr_RE_std = std(delta_T);     
end
%part4��end*****************************************************************************************************************************************

%% ********************************************************part5����ʾ����ָ�겢�洢��������************************************************
%%%%%%%%%%��ʾ����õ�ϵͳָ��ͳ��񾫶�%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp(['Ch.',num2str(freq_index),'--',num2str(freq/1e9),'GHzƵ�Σ�',num2str(antenna_diameter),'�׿ھ���ʵ�׾�������غɣ�@taper=',num2str(illumination_taper),')']);
disp(['3dB�������=',num2str(roundn(HPBW,-3)),'�b','������ֱ���=',num2str(roundn(ground_resolution,-1)),'����']);
disp(['����ɨ�������=',num2str(roundn(sample_width/180*pi*orbit_height,-1)),'����,�����ܶ�=',num2str(roundn(sample_density,-1))]);
disp(['��һ�����ƽ=',num2str(roundn(SLL,-1)),'dB']);
disp(['������Ч��MBE=',num2str(roundn(MBE,-1)),'%']);
disp(['ʵ�׾����������������=',num2str(roundn(NEDT,-2)),'K']);  
disp([num2str(antenna_diameter),'�׿ھ���ʵ�׾�������غɹ۲�����TA��RMSE=',num2str(roundn(RMSE,-2)),'K']);
disp([num2str(antenna_diameter),'�׿ھ���ʵ�׾�������غɹ۲�ͼ��TA�볡������TB�����ϵ��=',num2str(roundn(Corr_coefficient,-3))]);
disp([num2str(antenna_diameter),'�׿ھ���ʵ�׾�������غɹ۲�����TA������ֵ=',num2str(roundn(ObsErr_mean,-2)),'K']);
disp([num2str(antenna_diameter),'�׿ھ���ʵ�׾�������غɹ۲�ͼ��TA������׼��=',num2str(roundn(ObsErr_std,-2)),'K']);
if  flag_Resolution_Enhancement == 1;
disp([num2str(antenna_diameter),'�׿ھ���ʵ�׾�������غɷֱ�����ǿ����TA_RE��RMSE=',num2str(roundn(RMSE_RE,-2)),'K@',num2str(factor_opt)]);
disp([num2str(antenna_diameter),'�׿ھ���ʵ�׾�������غɷֱ�����ǿ����TA_RE�볡������TB�����ϵ��=',num2str(roundn(Corr_coefficient_RE,-3)),'@',num2str(factor_opt)]);
disp([num2str(antenna_diameter),'�׿ھ���ʵ�׾�������غɷֱ�����ǿ����TA������ֵ=',num2str(roundn(ObsErr_RE_mean,-2)),'K']);
disp([num2str(antenna_diameter),'�׿ھ���ʵ�׾�������غɷֱ�����ǿͼ��TA������׼��=',num2str(roundn(ObsErr_RE_std,-2)),'K']);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if flag_save == 1
   FileName = sprintf('GOES_RA_%s_D%s_q%d_��%s', TB_filename,num2str(round(antenna_diameter*1000)),illumination_taper,num2str(integral_time));
   if flag_Resolution_Enhancement == 1;
   FileName = sprintf('%s_%s', FileName,Resolution_Enhancement_name);
   end
   MatFileName = sprintf('%s.mat', FileName);
   save(['..\RA������\' MatFileName],'TA_noiseless','TA','Antenna_Pattern','HPBW','SLL','MBE','RMSE','Corr_coefficient','ground_resolution','ObsErr_mean','ObsErr_std'); 
   if  flag_Resolution_Enhancement == 1;
   save(['..\RA������\' MatFileName],'TA_RE','RMSE_RE','Corr_coefficient_RE','ObsErr_RE_mean','ObsErr_RE_std','factor_opt','-append'); 
   end
end
%part5��end**************************************************************************************************************************************************

toc;