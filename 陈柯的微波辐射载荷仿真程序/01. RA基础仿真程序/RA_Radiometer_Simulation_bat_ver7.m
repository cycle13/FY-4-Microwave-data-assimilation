%������ģ��ʵ�׾�������غɹ۲�����
%by �¿� 2015.11.10 --updated 2016.10.19 

clear;
close all;
tic;
%%***************************���²��������ñ�־λ�͹������***************************************************************************************************
flag_draw_TB = 0;                               %������������TB 
flag_draw_TA = 0;                               %�����۲�����TA 
flag_draw_pattern = 0;                          %�����߷���ͼ��־λ
flag_save =    1;                               %���ݴ洢��־λ
flag_Resolution_Enhancement  = 0;               %ʹ�÷ֱ�����ǿ�����־λ
flag_RealAntenna = 0;
Resolution_Enhancement_name = 'BG';             %��ѡ�㷨��BG��WienerFilter��SIR��ODC
flag_PDF_calc = 0;
RMSE_offset  = 0;                              %�۲�ͼ����ԭʼͼ��Ա�ʱͼ���Եȥ�����л�����
R = 6371;                                       %����뾶 unit:km
orbit_height = 35786;                           %����߶ȣ���ǰΪ����ֹ�����, unit:km
Payload_name = 'GEM5';
%************************************************************************************************************************************************************

%% ********************************************************part1����������ͼ�񳡾��������ռ����������ֵ********************************************
%����ѡ��ģ�����³�����ȡ��ӦƵ�ε�ģ������ͼ��
file_path = 'F:\read_innnotb_out';   %�ļ��洢Ŀ¼
%���㳡���ھ��Ⱥ�γ�ȷ���Ĺ۲�Ƿ�Χ
coordinate_filename = sprintf('%s\\latlon\\coords.mat', file_path);
[angle_Long,angle_Lat] = Image_Long_Lat_calc(coordinate_filename,R,orbit_height);
scene_time='2018-03-07_00_00_00';
scene_name = 'TyphoonMaria_08_12';
channel_start_index = 1;
channel_end_index = 22;
channel_num = channel_end_index-channel_end_index+1;

%������������Ҫȫ����ʾ�ķ�����
   RMSE_list  = zeros(channel_num,1);  RMSE_antenna_list  = zeros(channel_num,1);RMSE_noise_list  = zeros(channel_num,1);
   Corr_coefficient_list =zeros(channel_num,1); ground_resolution_list = zeros(channel_num,1);
   NEDT_list  = zeros(channel_num,1);   HPBW_list = zeros(channel_num,1);   SLL_list = zeros(channel_num,1);  MBE_list =zeros(channel_num,1); 
   if  flag_Resolution_Enhancement == 1
      RMSE_RE_list = zeros(channel_num,1);   Corr_coefficient_RE_list = zeros(channel_num,1);   factor_opt_list = zeros(channel_num,1);
      if  flag_PDF_calc == 1
          HPBW_RE_list = zeros(channel_num,1);  ground_resolution_RE_list = zeros(channel_num,1); SLL_RE_list = zeros(channel_num,1);   MBE_RE_list = zeros(channel_num,1);
      end
   end
   

% ����Ҫ���������ͨ�����

for freq_index = [[1:22]]
 % for freq_index = channel_start_index:channel_end_index    
    TB_filename = sprintf('C%s_%s.mat', num2str(freq_index),scene_time); %����ͼ���ļ���
    TB_matfile = sprintf('%s\\%s', file_path,TB_filename);
    load(TB_matfile);   TB=(TbMap);
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
              case 1, freq= 50.3e9;   bandwith = 180e6;    noise_figure= 5;  antenna_diameter = 5;                      
             case 2, freq= 51.76e9;  bandwith = 400e6;    noise_figure= 5;  antenna_diameter = 5;                     
             case 3, freq= 52.8e9;   bandwith = 400e6;    noise_figure= 5;  antenna_diameter = 5;                     
             case 4, freq= 53.596e9; bandwith = 400e6;    noise_figure= 5;  antenna_diameter = 5;                     
             case 5, freq= 54.4e9;   bandwith = 400e6;    noise_figure= 5;  antenna_diameter = 5;                     
             case 6, freq= 54.94e9;  bandwith = 400e6;    noise_figure= 5;  antenna_diameter = 5;                      
             case 7, freq= 55.5e9;   bandwith = 330e6;    noise_figure= 5;  antenna_diameter = 5;                     
             case 8, freq= 57.29e9;  bandwith = 330e6;    noise_figure= 5;  antenna_diameter = 5; 
             case 9, freq= 57.507e9; bandwith = 2*78e6;   noise_figure= 5;  antenna_diameter = 5; 
             case 10,freq= 57.66e9;  bandwith = 4*36e6;   noise_figure= 5;  antenna_diameter = 5; 
             case 11,freq= 57.63e9;  bandwith = 4*16e6;   noise_figure= 5;  antenna_diameter = 5; 
             case 12,freq= 57.62e9;  bandwith = 4*8e6;    noise_figure= 5;  antenna_diameter = 5; 
             case 13,freq= 57.617e9; bandwith = 4*3e6;    noise_figure= 5;  antenna_diameter = 5; 
             case 14,freq= 88.2e9;   bandwith = 2000e6;   noise_figure= 7;  antenna_diameter = 2.4;                      
             case 15,freq= 118.83e9; bandwith = 2*20e6;   noise_figure= 8;  antenna_diameter = 2.4;
             case 16,freq= 118.95e9; bandwith = 2*100e6;  noise_figure= 8;  antenna_diameter = 2.4;
             case 17,freq= 119.05e9; bandwith = 2*165e6;  noise_figure= 8;  antenna_diameter = 2.4;
             case 18,freq= 119.55e9; bandwith = 2*200e6;  noise_figure= 8;  antenna_diameter = 2.4;                     
             case 19,freq= 119.85e9; bandwith = 2*200e6;  noise_figure= 8;  antenna_diameter = 2.4;                     
             case 20,freq= 121.25e9; bandwith = 2*200e6;  noise_figure= 8;  antenna_diameter = 2.4;                     
             case 21,freq= 121.75e9; bandwith = 2*1000e6; noise_figure= 8;  antenna_diameter = 2.4;                     
             case 22,freq= 123.75e9; bandwith = 2*2000e6; noise_figure= 8;  antenna_diameter = 2.4;                     
             case 23,freq= 165.5e9;  bandwith = 3000e6;   noise_figure= 9;  antenna_diameter = 2.4;                    
             case 24,freq= 190.31e9; bandwith = 2*2000e6; noise_figure= 9;  antenna_diameter = 2.4;                    
             case 25,freq= 187.81e9; bandwith = 2*2000e6; noise_figure= 9;  antenna_diameter = 2.4;                    
             case 26,freq= 186.31e9; bandwith = 2*1000e6; noise_figure= 9;  antenna_diameter = 2.4;                    
             case 27,freq= 185.11e9; bandwith = 2*1000e6; noise_figure= 9;  antenna_diameter = 2.4;                     
             case 28,freq= 184.31e9; bandwith = 2*500e6;  noise_figure= 9;  antenna_diameter = 2.4;                     
             case 29,freq= 398.197e9;bandwith = 2*2000e6; noise_figure= 11; antenna_diameter = 2.4;
             case 30,freq= 389.197e9;bandwith = 2*2000e6; noise_figure= 11; antenna_diameter = 2.4;
             case 31,freq= 384.197e9;bandwith = 2*900e6;  noise_figure= 11; antenna_diameter = 2.4;
             case 32,freq= 381.697e9;bandwith = 2*500e6;  noise_figure= 11; antenna_diameter = 2.4;
             case 33,freq= 380.597e9;bandwith = 2*200e6;  noise_figure= 11; antenna_diameter = 2.4;
             case 34,freq= 380.242e9;bandwith = 2*30e6;   noise_figure= 11; antenna_diameter = 2.4;   
             case 35,freq= 428.763e9;bandwith = 2*1000e6; noise_figure= 11; antenna_diameter = 2.4;                     
             case 36,freq= 426.263e9;bandwith = 2*600e6;  noise_figure= 11; antenna_diameter = 2.4;                     
             case 37,freq= 425.763e9;bandwith = 2*400e6;  noise_figure= 11; antenna_diameter = 2.4;                   
             case 38,freq= 425.363e9;bandwith = 2*200e6;  noise_figure= 11; antenna_diameter = 2.4;                     
             case 39,freq= 425.063e9;bandwith = 2*100e6;  noise_figure= 11; antenna_diameter = 2.4;
             case 40,freq= 424.913e9;bandwith = 2*60e6;   noise_figure= 11; antenna_diameter = 2.4;
             case 41,freq= 424.833e9;bandwith = 2*20e6;   noise_figure= 11; antenna_diameter = 2.4;
             case 42,freq= 424.793e9;bandwith = 2*10e6;   noise_figure= 11; antenna_diameter = 2.4; 
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
%part2��end**************************************************************************************************************************************************


%% ********************************************************part3��ģ����������ɨ��۲������̣�����۲����������ͼ��TA**************************************   
%����ϵͳ���߷���ͼ����ָ�����
if flag_RealAntenna == 1
%    fov_804_antenna = 0.0036; %for 425
%      fov_804_antenna = 0.004; %for 183
     fov_804_antenna = 0.006; %for 54
   [Antenna_Pattern,HPBW,SLL,MBE] = RA_antenna_pattern_2D_RealAntenna(Ba,Coordinate_Long,Coordinate_Lat,angle_Long,angle_Lat,illumination_taper,freq_index,flag_draw_pattern,fov_804_antenna);
   TA_noiseless = Real_Antenna_conv(TB,angle_Lat,angle_Long,sample_width_Long,sample_width_Lat,N_Long,N_Lat,Antenna_Pattern,Coordinate_Long,Coordinate_Lat);
else
   [Antenna_Pattern,HPBW,SLL,MBE] = RA_antenna_pattern_2D(Ba,Coordinate_Long,Coordinate_Lat,angle_Long,angle_Lat,illumination_taper,freq_index,flag_draw_pattern);
   %ģ������ɨ�跽ʽ��ù۲�����TA
   TA_noiseless = Antenna_conv(TB,angle_Lat,angle_Long,sample_width_Long,sample_width_Lat,N_Long,N_Lat,Ba,illumination_taper);
end
    
    ground_resolution = HPBW/180*pi*orbit_height;
    sample_density = HPBW/sample_width;                           %����������������ı�ֵ������ÿ��������Χ�ڵĲ�������


% %ֱ��ʹ�þ����������۲�����
    % TA_noiseless = conv2(TB,Antenna_Pattern,'same');
% ϵͳ����Ӧͼ��ģ�����
if flag_PDF_calc == 1;
   TB_Point = zeros(N_Lat,N_Long);
   TB_Point(N_Lat/2,N_Long/2) = 1000; 
   TA_PDF =  Antenna_conv(TB_Point,angle_Lat,angle_Long,sample_width_Long,sample_width_Lat,N_Long,N_Lat,Ba,illumination_taper);
end

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
            if flag_PDF_calc == 1 
               [TA_RE,factor_opt,TA_PDF_RE] = Backus_Gilbert_deconv(TA_noiseless,TB,angle_Long,angle_Lat,Ba,illumination_taper,NEDT,num_R,max_R,RMSE_offset,flag_PDF_calc,TA_PDF);
            else
               [TA_RE,factor_opt] = Backus_Gilbert_deconv(TA_noiseless,TB,angle_Long,angle_Lat,Ba,illumination_taper,NEDT,num_R,max_R,RMSE_offset);
            end
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
        if flag_PDF_calc == 1
           [HPBW_RE,SLL_RE,MBE_RE] = Antenna_Pattern_2D_parameter_calc(TA_PDF_RE,Coordinate_Long,Coordinate_Lat,angle_Long,angle_Lat,freq_index,flag_draw_pattern,Ba,illumination_taper);
           ground_resolution_RE = HPBW_RE/180*pi*orbit_height;
        end
    end
%part4��end*****************************************************************************************************************************************


%% ********************************************************part5����ʾ����ָ�겢�洢��������************************************************
%������򾫶ȣ��ù۲�����TA������Tb��RMSE������
    [RMSE] = Root_Mean_Square_Error(TB,TA,RMSE_offset,0);
    Corr_coefficient = TB_correlation_coefficient(TB,TA,RMSE_offset);
    [RMSE_antenna] = Root_Mean_Square_Error(TB,TA_noiseless,RMSE_offset,0);
    RMSE_noise = sqrt(RMSE^2-RMSE_antenna^2);
    
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
       FileName = sprintf('GOES_%s_C%d_%s',Payload_name,freq_index,scene_name);
       if flag_Resolution_Enhancement == 1;
          FileName = sprintf('%s_%s', FileName,Resolution_Enhancement_name);
       end
       MatFileName = sprintf('%s.mat', FileName);
       save(['F:\����\���\��ֹ���\sandy\sandy�۲�����\' MatFileName],'TA_noiseless','TA','Antenna_Pattern','NEDT','HPBW','SLL','MBE','RMSE','RMSE_antenna','RMSE_noise','Corr_coefficient','ground_resolution'); 
       if  flag_Resolution_Enhancement == 1;
           save(['F:\����\���\��ֹ���\sandy\sandy�۲�����\' MatFileName],'TA_RE','RMSE_RE','Corr_coefficient_RE','factor_opt','-append');
           if  flag_PDF_calc == 1;
               save(['F:\����\���\��ֹ���\sandy\sandy�۲�����\' MatFileName],'TA_PDF_RE','HPBW_RE','ground_resolution_RE','SLL_RE','MBE_RE','-append'); 
           end
       end
       
    end   
   %������channel�������б�ֵ
   RMSE_list(freq_index) = RMSE;   RMSE_antenna_list(freq_index) = RMSE_antenna;  RMSE_noise_list(freq_index) = RMSE_noise;  
   Corr_coefficient_list(freq_index) = Corr_coefficient; 
   NEDT_list(freq_index) = NEDT;  HPBW_list(freq_index) = HPBW;  SLL_list(freq_index) = SLL;MBE_list(freq_index) =MBE;
   ground_resolution_list(freq_index) = ground_resolution;  
   if  flag_Resolution_Enhancement == 1;
       RMSE_RE_list(freq_index) = RMSE_RE; factor_opt_list (freq_index) =factor_opt;Corr_coefficient_RE_list(freq_index) = Corr_coefficient_RE;
       if  flag_PDF_calc == 1;
           HPBW_RE_list(freq_index) = HPBW_RE; ground_resolution_RE_list(freq_index) = ground_resolution_RE; SLL_RE_list (freq_index) =SLL_RE;MBE_RE_list(freq_index) = MBE_RE;
       end
   end
   
%part5��end**************************************************************************************************************************************************
end

disp([Payload_name,'�غɶ�',scene_name,'�ķ�����']);
disp('�۲�RMSE   �ֱ���RMSE   ����RMSE  �۲����ϵ��');
disp([roundn(RMSE_list,-2);roundn(RMSE_antenna_list,-2);roundn(RMSE_noise_list,-2);roundn(Corr_coefficient_list,-3)].');
disp('------------------------------------------------------------------------------')
disp(['������  3dB�������  ����ֱ���  �����ƽ ������Ч��']);
disp([roundn(NEDT_list,-2);roundn(HPBW_list,-3);roundn(ground_resolution_list,0);roundn(SLL_list,-1);roundn(MBE_list,-1)].');
disp('------------------------------------------------------------------------------')
if  flag_Resolution_Enhancement == 1;
    disp('ԭʼRMSE �ֱ�����ǿ������RMSE  ԭʼ���ϵ�� �ֱ�����ǿ���������ϵ��  ���Ų���ֵfactor ');
    disp([roundn(RMSE_list,-2);roundn(RMSE_RE_list,-2);roundn(Corr_coefficient_list,-3);roundn(Corr_coefficient_RE_list,-3);factor_opt_list].');
    disp('--------------------------------------------------------------------------')
    if  flag_PDF_calc == 1;
        disp('�ֱ�����ǿ������3dB�������  ����ֱ���  �����ƽ ������Ч�� ');
        disp([roundn(HPBW_RE_list,-3);roundn(ground_resolution_RE_list,0);roundn(SLL_RE_list,-1);roundn(MBE_RE_list,-1)].');
        disp('--------------------------------------------------------------------------')           
    end
end

if flag_save == 1;
   SaveFileName = sprintf('GOES_%s_C%d_%s',Payload_name,freq_index,scene_name);
   if flag_Resolution_Enhancement == 1;
   SaveFileName = sprintf('%s_%s', SaveFileName,Resolution_Enhancement_name);
   end
   SaveMatFileName = sprintf('%s_result_list.mat', SaveFileName);
   save(['F:\����\���\��ֹ���\sandy\sandy�۲�����\' SaveMatFileName],'RMSE_list','RMSE_antenna_list','RMSE_noise_list','Corr_coefficient_list','NEDT_list','HPBW_list','ground_resolution_list','SLL_list','MBE_list');
   if  flag_Resolution_Enhancement == 1;
   save(['F:\����\���\��ֹ���\sandy\sandy�۲�����\' SaveMatFileName],'RMSE_RE_list','Corr_coefficient_RE_list','factor_opt_list','-append'); 
       if  flag_PDF_calc == 1;
            save(['F:\����\���\��ֹ���\sandy\sandy�۲�����\' SaveMatFileName],'HPBW_RE_list','ground_resolution_RE_list','SLL_RE_list','MBE_RE_list','-append'); 
       end
   end    
end
toc;