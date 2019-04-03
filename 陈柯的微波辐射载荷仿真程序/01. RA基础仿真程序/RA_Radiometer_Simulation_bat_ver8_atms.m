%������ģ��ʵ�׾�������غɹ۲�����
%by �¿� 2015.11.10 --updated 2016.10.19 

% clear;
close all;
tic
%%***************************���²��������ñ�־λ�͹������***************************************************************************************************
flag_draw_TB = 0;                               %������������TB 
flag_draw_TA = 0;                               %�����۲�����TA 
flag_draw_pattern = 0;                          %�����߷���ͼ��־λ
flag_save =   1;                               %���ݴ洢��־λ
flag_Resolution_Enhancement  = 0;               %ʹ�÷ֱ�����ǿ�����־λ
Resolution_Enhancement_name = 'BG';             %��ѡ�㷨��BG��WienerFilter��SIR��ODC
RMSE_offset  =0;                                %�۲�ͼ����ԭʼͼ��Ա�ʱͼ���Եȥ�����л�����
R = 6371;                                       %����뾶 unit:km
orbit_height = 35786;                           %����߶ȣ���ǰΪ����ֹ�����, unit:km
%************************************************************************************************************************************************************

%% ********************************************************part1����������ͼ�񳡾��������ռ����������ֵ********************************************
%����ѡ��ģ�����³�����ȡ��ӦƵ�ε�ģ������ͼ��
% file_path = 'F:\myfile\WeChat Files\hpf950409\Files';   %�ļ��洢¼
% file_path1='F:\myfile\WeChat Files\hpf950409\Files';
%���㳡���ھ��Ⱥ�γ�ȷ���Ĺ۲�Ƿ�Χ
% scene_time='2018-03-07_00_00_00';
scene_time=sprintf('%s-%s-%s_%s_%s_00',time(1:4),time(5:6),time(7:8),time(9:10),time(11:12));
% scene_name = 'TyphoonMaria_08_12';
scene_name=sprintf('Typhoon%s_%s_%s_%s',typhoon_name,time(7:8),time(9:10),time(11:12));
Payload_name = 'ATMS';
channel_start_index = 1;
channel_end_index = 22;
channel_num = channel_end_index-channel_end_index+1;
coordinate_filename = sprintf('%s/coords.mat', file_path1);
[angle_Long,angle_Lat] = Image_Long_Lat_calc(coordinate_filename,R,orbit_height);


%������������Ҫȫ����ʾ�ķ�����
   RMSE_list  = zeros(channel_num,1);   Corr_coefficient_list =zeros(channel_num,1); ground_resolution_list = zeros(channel_num,1);
   NEDT_list  = zeros(channel_num,1);   HPBW_list = zeros(channel_num,1);   SLL_list = zeros(channel_num,1);  MBE_list =zeros(channel_num,1); 
   if  flag_Resolution_Enhancement == 1
       RMSE_RE_list = zeros(channel_num,1);   Corr_coefficient_RE_list = zeros(channel_num,1);   factor_opt_list = zeros(channel_num,1);
   end

% �����ļ�����
% file_path = 'D:\���ڴ���ĳ���\2012.10.29 Hurricansandy1500-NAMʱ������';


% for freq_index = channel_start_index:channel_end_index    
for freq_index = [[1:22]],
     %TB_filename = sprintf('C%s_%s.mat', num2str(freq_index),scene_time); %����ͼ���ļ���
     TB_filename = sprintf('%s_C%s_H.mat',scene_name,num2str(freq_index));
     TB_matfile = sprintf('%s/%s', file_path,TB_filename);
     if(exist(TB_matfile,'file')~=2)
        continue;
     end
     load(TB_matfile); TB=(TbMap(:,:)'); 
%      [N_Lat1,N_Long1] = size(TB); 
     T_max=max(max(TB)); T_min=min(min(TB));
       
    [N_Lat,N_Long] = size(TB);
    %����ͼ��ռ�Ƕ��������*********************************************
    %����ռ����С
    d_Long = angle_Long/(N_Long);                  %����ͼ�񾭶ȷ�����С��࣬���Ƕȷֱ���  
    d_Lat = angle_Lat/(N_Lat);                     %����ͼ��γ�ȷ�����С��࣬���Ƕȷֱ��� 
    %����ͼ�����ʵ�ռ��ά�Ƕ�����ֵ
    Coordinate_Long = linspace(-angle_Long/2,angle_Long/2-d_Long,N_Long);   %���ȽǶ���������
    Coordinate_Lat = linspace(-angle_Lat/2,angle_Lat/2-d_Lat,N_Lat);        %γ�ȽǶ���������
    [Fov_Long,Fov_Lat] = meshgrid(Coordinate_Long,Coordinate_Lat);          %����γ�ȷ����ά�������
    %������������ͼ��
    
    if  flag_draw_TB == 1;
        figure;imagesc(Coordinate_Long,Coordinate_Lat,TB,[T_min T_max]);axis equal;xlim([-angle_Long/2,angle_Long/2]);ylim([-angle_Lat/2,angle_Lat/2]);
        xlabel('���ȷ���'); ylabel('γ�ȷ���');title(['ԭʼ����ͼ��TB@Ch.',num2str(freq_index)]);colorbar;
    end
%part1��end**************************************************************************************************************************************************


%% ********************************************************part2��������غɲ�����ɨ�������������**************************************************************
%%***************************���÷���Ʋ���******************************
%% ������ÿ��Ƶ����Ҫ�޸ĵķ���Ʋ���
    switch freq_index   %����Ƶ��,��λ:Hz  %����, ��λ:Hz     %����ϵ��,��λ:dB   %���߿ھ�����λ����
             case 1, freq= 23.8e9;   bandwith = 270e6;    noise_figure= 4.5;antenna_diameter = 0.175; integral_time = 18*10^(-3);  
             case 2, freq= 31.4e9;   bandwith = 180e6;    noise_figure= 5;  antenna_diameter = 0.135; integral_time = 18*10^(-3);  
             case 3, freq= 50.3e9;   bandwith = 180e6;    noise_figure= 6;  antenna_diameter = 0.185; integral_time = 18*10^(-3);  
             case 4, freq= 51.76e9;  bandwith = 400e6;    noise_figure= 6;  antenna_diameter = 0.185; integral_time = 18*10^(-3);  
             case 5, freq= 52.8e9;   bandwith = 400e6;    noise_figure= 6;  antenna_diameter = 0.185; integral_time = 18*10^(-3);  
             case 6, freq= 53.596e9; bandwith = 2*170e6;  noise_figure= 6;  antenna_diameter = 0.185; integral_time = 18*10^(-3);  
             case 7, freq= 54.4e9;   bandwith = 400e6;    noise_figure= 6;  antenna_diameter = 0.185; integral_time = 18*10^(-3);  
             case 8, freq= 54.94e9;  bandwith = 400e6;    noise_figure= 6;  antenna_diameter = 0.185; integral_time = 18*10^(-3);  
             case 9, freq= 55.5e9;   bandwith = 330e6;    noise_figure= 6;  antenna_diameter = 0.185; integral_time = 18*10^(-3);  
             case 10,freq= 57.29e9;  bandwith = 2*155e6;  noise_figure= 6;  antenna_diameter = 0.185; integral_time = 18*10^(-3);  
             case 11,freq= 57.507e9; bandwith = 2*78e6;   noise_figure= 6;  antenna_diameter = 0.185; integral_time = 18*10^(-3);  
             case 12,freq= 57.66e9;  bandwith = 2*36e6;   noise_figure= 6;  antenna_diameter = 0.185; integral_time = 18*10^(-3);  
             case 13,freq= 57.63e9;  bandwith = 2*16e6;   noise_figure= 6;  antenna_diameter = 0.185; integral_time = 18*10^(-3);  
             case 14,freq= 57.62e9;  bandwith = 2*8e6;    noise_figure= 6;  antenna_diameter = 0.185; integral_time = 18*10^(-3);  
             case 15,freq= 57.617e9; bandwith = 2*3e6;    noise_figure= 6;  antenna_diameter = 0.185; integral_time = 18*10^(-3);  
             case 16,freq= 88.2e9;   bandwith = 2000e6;   noise_figure= 9;  antenna_diameter = 0.11;  integral_time = 18*10^(-3);  
             case 17,freq= 165.5e9;  bandwith = 2*1150e6; noise_figure= 12; antenna_diameter = 0.11;  integral_time = 18*10^(-3);  
             case 18,freq= 190.31e9; bandwith = 2*2000e6; noise_figure= 12; antenna_diameter = 0.11;  integral_time = 18*10^(-3);  
             case 19,freq= 187.81e9; bandwith = 2*2000e6; noise_figure= 12; antenna_diameter = 0.11;  integral_time = 18*10^(-3);  
             case 20,freq= 186.31e9; bandwith = 2*1000e6; noise_figure= 12; antenna_diameter = 0.11;  integral_time = 18*10^(-3);  
             case 21,freq= 185.11e9; bandwith = 2*1000e6; noise_figure= 12; antenna_diameter = 0.11;  integral_time = 18*10^(-3);  
             case 22,freq= 184.31e9; bandwith = 2*500e6;  noise_figure= 12; antenna_diameter = 0.11;  integral_time = 18*10^(-3);
        
%              case 1, freq= 50.3e9;   bandwith = 180e6;    noise_figure= 5;  antenna_diameter = 5;                      
%              case 2, freq= 51.76e9;  bandwith = 400e6;    noise_figure= 5;  antenna_diameter = 5;                     
%              case 3, freq= 52.8e9;   bandwith = 400e6;    noise_figure= 5;  antenna_diameter = 5;                     
%              case 4, freq= 53.596e9; bandwith = 400e6;    noise_figure= 5;  antenna_diameter = 5;                     
%              case 5, freq= 54.4e9;   bandwith = 400e6;    noise_figure= 5;  antenna_diameter = 5;                     
%              case 6, freq= 54.94e9;  bandwith = 400e6;    noise_figure= 5;  antenna_diameter = 5;                      
%              case 7, freq= 55.5e9;   bandwith = 330e6;    noise_figure= 5;  antenna_diameter = 5;                     
%              case 8, freq= 57.29e9;  bandwith = 330e6;    noise_figure= 5;  antenna_diameter = 5; 
%              case 9, freq= 57.507e9; bandwith = 2*78e6;   noise_figure= 5;  antenna_diameter = 5; 
%              case 10,freq= 57.66e9;  bandwith = 4*36e6;   noise_figure= 5;  antenna_diameter = 5; 
%              case 11,freq= 57.63e9;  bandwith = 4*16e6;   noise_figure= 5;  antenna_diameter = 5; 
%              case 12,freq= 57.62e9;  bandwith = 4*8e6;    noise_figure= 5;  antenna_diameter = 5; 
%              case 13,freq= 57.617e9; bandwith = 4*3e6;    noise_figure= 5;  antenna_diameter = 5; 
%              case 14,freq= 88.2e9;   bandwith = 2000e6;   noise_figure= 7;  antenna_diameter = 5;                      
%              case 15,freq= 118.83e9; bandwith = 2*20e6;   noise_figure= 8;  antenna_diameter = 2.4;
%              case 16,freq= 118.95e9; bandwith = 2*100e6;  noise_figure= 8;  antenna_diameter = 2.4;
%              case 17,freq= 119.05e9; bandwith = 2*165e6;  noise_figure= 8;  antenna_diameter = 2.4;
%              case 18,freq= 119.55e9; bandwith = 2*200e6;  noise_figure= 8;  antenna_diameter = 2.4;                     
%              case 19,freq= 119.85e9; bandwith = 2*200e6;  noise_figure= 8;  antenna_diameter = 2.4;                     
%              case 20,freq= 121.25e9; bandwith = 2*200e6;  noise_figure= 8;  antenna_diameter = 2.4;                     
%              case 21,freq= 121.75e9; bandwith = 2*1000e6; noise_figure= 8;  antenna_diameter = 2.4;                     
%              case 22,freq= 123.75e9; bandwith = 2*2000e6; noise_figure= 8;  antenna_diameter = 2.4;                     
%              case 23,freq= 165.5e9;  bandwith = 3000e6;   noise_figure= 9;  antenna_diameter = 2.4;                    
%              case 24,freq= 190.31e9; bandwith = 2*2000e6; noise_figure= 9;  antenna_diameter = 2.4;                    
%              case 25,freq= 187.81e9; bandwith = 2*2000e6; noise_figure= 9;  antenna_diameter = 2.4;                    
%              case 26,freq= 186.31e9; bandwith = 2*1000e6; noise_figure= 9;  antenna_diameter = 2.4;                    
%              case 27,freq= 185.11e9; bandwith = 2*1000e6; noise_figure= 9;  antenna_diameter = 2.4;                     
%              case 28,freq= 184.31e9; bandwith = 2*500e6;  noise_figure= 9;  antenna_diameter = 2.4;                      
%              case 35,freq= 428.763e9;bandwith = 2*1000e6; noise_figure= 11; antenna_diameter = 2.4;                     
%              case 36,freq= 426.263e9;bandwith = 2*600e6;  noise_figure= 11; antenna_diameter = 2.4;                     
%              case 37,freq= 425.763e9;bandwith = 2*400e6;  noise_figure= 11; antenna_diameter = 2.4;                   
%              case 38,freq= 425.363e9;bandwith = 2*200e6;  noise_figure= 11; antenna_diameter = 2.4;                     
%              case 39,freq= 425.063e9;bandwith = 2*100e6;  noise_figure= 11; antenna_diameter = 2.4;
%              case 40,freq= 424.913e9;bandwith = 2*60e6;   noise_figure= 11; antenna_diameter = 2.4;
%              case 41,freq= 424.833e9;bandwith = 2*20e6;   noise_figure= 11; antenna_diameter = 2.4;
%              case 42,freq= 424.793e9;bandwith = 2*10e6;   noise_figure= 11; antenna_diameter = 2.4;
%              case 29,freq= 398.197e9;bandwith = 2*2000e6; noise_figure= 11; antenna_diameter = 2.4;
%              case 30,freq= 389.197e9;bandwith = 2*2000e6; noise_figure= 11; antenna_diameter = 2.4;
%              case 31,freq= 384.197e9;bandwith = 2*900e6;  noise_figure= 11; antenna_diameter = 2.4;
%              case 32,freq= 381.697e9;bandwith = 2*500e6;  noise_figure= 11; antenna_diameter = 2.4;
%              case 33,freq= 380.597e9;bandwith = 2*200e6;  noise_figure= 11; antenna_diameter = 2.4;
%              case 34,freq= 380.242e9;bandwith = 2*1000e6; noise_figure=11 ; antenna_diameter = 2.4;                
     end
    
%% �����ǲ���ÿ��Ƶ���޸ĵķ���Ʋ���
    c=3e8;                                                      %���� unit m/s
    wavelength = c/freq;                                        %���� unit:m
    integral_time = 40*10^(-3);                                 %����ʱ��, unit:S                                           
    T_rec = 290*(10^(noise_figure/10)-1);                         %����Ƶ�Ч�����¶�, unit:K
    T_A = 250;                                                  %����ƽ��������������TA����λ��K
    NEDT = (T_rec+T_A)/sqrt(bandwith*integral_time);            %����������ȣ���λ��K
    Ba = pi*antenna_diameter/wavelength;                        %���ߵ糤�Ȳ���
    illumination_taper = 1;                                 %the illumination taper //by thesis of G.M.Skofronick
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
    sample_factor = 1;
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
%part2��end**************************************************************************************************************************************************


%% ********************************************************part3��ģ����������ɨ��۲������̣�����۲����������ͼ��TA**************************************   
%����ϵͳ���߷���ͼ����ָ�����
    [Antenna_Pattern,HPBW,SLL,MBE] = RA_antenna_pattern_2D(Ba,Coordinate_Long,Coordinate_Lat,angle_Long,angle_Lat,illumination_taper,freq_index,flag_draw_pattern);
    ground_resolution = HPBW/180*pi*orbit_height;
    sample_density = HPBW/sample_width;                           %����������������ı�ֵ������ÿ��������Χ�ڵĲ�������

%ģ������ɨ�跽ʽ��ù۲�����TA
    TA_noiseless = Antenna_conv(TB,angle_Lat,angle_Long,sample_width_Long,sample_width_Lat,N_Long,N_Lat,Ba,illumination_taper);
% %ֱ��ʹ�þ����������۲�����
    % TA_noiseless = conv2(TB,Antenna_Pattern,'same');

%%%%��ģ��۲�����TA����ϵͳ����
    TA = add_image_noise(TA_noiseless,bandwith,integral_time,noise_figure);
    if  flag_draw_TA == 1
        figure;imagesc(Coordinate_Long,Coordinate_Lat,TA,[T_min T_max]);axis equal;xlim([-angle_Long/2,angle_Long/2]);ylim([-angle_Lat/2,angle_Lat/2]);
        xlabel('���ȷ���'); ylabel('γ�ȷ���');title(['�۲�����ͼ��TA@Ch.',num2str(freq_index),'@taper=',num2str(illumination_taper)]);colorbar;
    end
%part3��end**************************************************************************************************************************************************

%% ********************************************************part4�������ֱ�����ǿ����*********************************************************************
    if  flag_Resolution_Enhancement == 1;
        switch Resolution_Enhancement_name 
        % %��ѡ�㷨��BG��Wiener Filter��SIR��ODC
          case 'BG'
            max_R = 0.1; 
            num_R = 5;
            [TA_RE,factor_opt] = Backus_Gilbert_deconv(TA_noiseless,TB,angle_Long,angle_Lat,Ba,illumination_taper,NEDT,num_R,max_R,RMSE_offset);
          case 'WienerFilter' 
            SNR_num = 100;
            [TA_RE,factor_opt] = Wiener_Filter_deconv(TA,TB,Antenna_Pattern,NEDT,SNR_num,RMSE_offset);
          case 'SIR'
            Block_num = 1;       %���ݷֿ�����
            [TA_RE,factor_opt] = Scatterometer_Image_Restruction(TA,TB,Block_num,sample_width_Lat,sample_width_Long,sample_factor,Ba,illumination_taper,angle_Long,angle_Lat,d_Long,d_Lat);
          case 'ODC'       
        end
    %�����ֱ�����ǿ����������ͼ��
        figure;imagesc(Coordinate_Long,Coordinate_Lat,TA_RE,[T_min T_max]);axis equal;xlim([-angle_Long/2,angle_Long/2]);ylim([-angle_Lat/2,angle_Lat/2]);
        xlabel('���ȷ���'); ylabel('γ�ȷ���');title([Resolution_Enhancement_name,'��ǿ����ͼ��TA@Ch.',num2str(freq_index),'@taper=',num2str(illumination_taper)]);colorbar;
    %����ֱ�����ǿ��Ĺ۲⾫�ȣ����ؽ�����TA_RE������TB��RMSE�����ϵ��������
        [RMSE_RE] = Root_Mean_Square_Error(TB,TA_RE,RMSE_offset,0);
        Corr_coefficient_RE = TB_correlation_coefficient(TB,TA_RE,RMSE_offset);
    end
%part4��end*****************************************************************************************************************************************


%% ********************************************************part5����ʾ����ָ�겢�洢��������************************************************
%������򾫶ȣ��ù۲�����TA������Tb��RMSE������
    [RMSE] = Root_Mean_Square_Error(TB,TA,RMSE_offset,0);
    Corr_coefficient = TB_correlation_coefficient(TB,TA,RMSE_offset);
%%%%%%%%%%��ʾ����õ�ϵͳָ��ͳ��񾫶�%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% disp(['Ch.',num2str(freq_index),'--',num2str(freq/1e9),'GHzƵ�Σ�',num2str(antenna_diameter),'�׿ھ���ʵ�׾�������غɣ�@taper=',num2str(illumination_taper),')']);
% disp(['3dB�������=',num2str(roundn(HPBW,-3)),'�b','������ֱ���=',num2str(roundn(ground_resolution,-1)),'����']);
% disp(['����ɨ�������=',num2str(roundn(sample_width/180*pi*orbit_height,-1)),'����,�����ܶ�=',num2str(roundn(sample_density,-1))]);
% disp(['��һ�����ƽ=',num2str(roundn(SLL,-1)),'dB']);
% disp(['������Ч��MBE=',num2str(roundn(MBE,-1)),'%']);
% disp(['ʵ�׾����������������=',num2str(roundn(NEDT,-2)),'K']);  
% disp([num2str(antenna_diameter),'�׿ھ���ʵ�׾�������غɹ۲�����TA��RMSE=',num2str(roundn(RMSE,-2)),'K']);
% disp([num2str(antenna_diameter),'�׿ھ���ʵ�׾�������غɹ۲�ͼ��TA�볡������TB�����ϵ��=',num2str(roundn(Corr_coefficient,-3))]);
% if  flag_Resolution_Enhancement == 1;
% disp([num2str(antenna_diameter),'�׿ھ���ʵ�׾�������غɷֱ�����ǿ����TA_RE��RMSE=',num2str(roundn(RMSE_RE,-2)),'K@',num2str(factor_opt)]);
% disp([num2str(antenna_diameter),'�׿ھ���ʵ�׾�������غɷֱ�����ǿ����TA_RE�볡������TB�����ϵ��=',num2str(roundn(Corr_coefficient_RE,-3)),'@',num2str(factor_opt)]);
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if flag_save == 1
%        FileName = sprintf('GOES_%s_C%d_%s',Payload_name,freq_index,scene_name);
       FileName=sprintf('%s_C%s_H',scene_name,num2str(freq_index));
       if flag_Resolution_Enhancement == 1;
          FileName = sprintf('%s_%s', FileName,Resolution_Enhancement_name);
       end
       
%        save(['..\05. RA������\' MatFileName],'TA_noiseless','TA','Antenna_Pattern','NEDT','HPBW','SLL','MBE','RMSE','Corr_coefficient','ground_resolution');
       save([output_dir '//' FileName],'TA');
       if  flag_Resolution_Enhancement == 1;
%            save(['..\05. RA������\' MatFileName],'TA_RE','RMSE_RE','Corr_coefficient_RE','factor_opt','-append'); 
           save(['C:\Users\ai\Desktop\send_beijing\TB_WRF\output_noangle\' FileName],'TA_RE','RMSE_RE','Corr_coefficient_RE','factor_opt','-append');
       end
    end   
   %������channel�������б�ֵ
   RMSE_list(freq_index) = RMSE;   
   Corr_coefficient_list(freq_index) = Corr_coefficient; 
   NEDT_list(freq_index) = NEDT;  HPBW_list(freq_index) = HPBW;  SLL_list(freq_index) = SLL;MBE_list(freq_index) =MBE;
   ground_resolution_list(freq_index) = ground_resolution;  
   if  flag_Resolution_Enhancement == 1;
       RMSE_RE_list(freq_index) = RMSE_RE; factor_opt_list (freq_index) =factor_opt;Corr_coefficient_RE_list(freq_index) = Corr_coefficient_RE;
   end
%part5��end**************************************************************************************************************************************************
end

% disp([Payload_name,'�غɶ�',scene_name,'@',Resolution_Enhancement_name,'�ֱ�����ǿ�㷨�����','������']);
% disp('�۲�RMSE');
% disp(roundn(RMSE_list,-2));
% disp('----------------------------------------------')
% disp(['�۲����ϵ��']);
% disp(roundn(Corr_coefficient_list,-3));
% disp('----------------------------------------------')
% disp(['������']);
% disp(roundn(NEDT_list,-2));
% disp('----------------------------------------------')
% disp(['3dB�������']);
% disp(roundn(HPBW_list,-3));
% disp('----------------------------------------------')
% disp(['����ֱ���']); 
% disp(roundn(ground_resolution_list,0));
% disp('----------------------------------------------')
% disp(['�����ƽ']);
% disp(roundn(SLL_list,-1));
% disp('----------------------------------------------')
% disp(['������Ч��']);
% disp(roundn(MBE_list,-1));
% if  flag_Resolution_Enhancement == 1;
%     disp('----------------------------------------------')
%     disp('�ֱ�����ǿ������RMSE');
%     disp(roundn(RMSE_RE_list,-2));
%     disp('----------------------------------------------')
%     disp(['�ֱ�����ǿ���������ϵ��']);
%     disp(roundn(Corr_coefficient_RE_list,-3));
%     disp('----------------------------------------------')
%     disp(['�ֱ�����ǿ���Ų���ֵfactor']);
%     disp(factor_opt_list);
% end
% 
% if flag_save == 1;
%    SaveFileName = sprintf('GOES-MW%s_C%d_%s',Payload_name,freq_index,scene_name);
%    if flag_Resolution_Enhancement == 1;
%       SaveFileName = sprintf('%s_%s', SaveFileName,Resolution_Enhancement_name);
%    end
%    SaveMatFileName = sprintf('%s_result_list.mat', SaveFileName);
%    %save(['C:\Users\ai\Desktop\send_beijing\TB_WRf\output_noangle\' SaveMatFileName],'RMSE_list','Corr_coefficient_list','NEDT_list','HPBW_list','ground_resolution_list','SLL_list','MBE_list');
%    if  flag_Resolution_Enhancement == 1;
%     save(['C:\Users\ai\Desktop\send_beijing\TB_WRF\output_noangle\' SaveMatFileName],'RMSE_RE_list','Corr_coefficient_RE_list','factor_opt_list','-append'); 
%    end    
% end
toc;
