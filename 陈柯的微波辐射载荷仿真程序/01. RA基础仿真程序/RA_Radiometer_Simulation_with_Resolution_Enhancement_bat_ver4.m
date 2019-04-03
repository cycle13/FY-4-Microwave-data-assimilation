%������ģ��ʵ�׾�������غɹ۲�����
%by �¿� 2015.11.10 --updated 2016.10.19 

clear;
close all;
tic;
%%***************************���²��������ñ�־λ�͹������**********************************************************
flag_draw_TB = 1;                               %����ԭʼ����TB 
flag_draw_TA = 1; 
flag_draw_pattern = 0;                          %�����߷���ͼ��־λ
flag_save = 1;                                  %���ݴ洢��־λ
flag_Resolution_Enhancement  = 1;               %ʹ�÷ֱ�����ǿ�����־λ
Resolution_Enhancement_name = 'SIR';             %��ѡ�㷨��BG��WienerFilter��SIR��ODC
RMSE_offset  = 20;                              %�۲�ͼ����ԭʼͼ��Ա�ʱͼ���Եȥ�����л�����
R = 6371;                                       %����뾶 unit:km
orbit_height = 35786;                           %����߶ȣ���ǰΪ����ֹ�����, unit:km
%*********************************************************************************************************

%% ********************************************************part1����������ͼ�񳡾��������ռ����������ֵ********************************************
%����ѡ��ģ�����³�����ȡ��ӦƵ�ε�ģ������ͼ��
file_path = 'D:\��ǰ�Ĺ���\2015.03.21 ��������ͬ����GEO�����о�\01. ������������\2016.10.09 쫷�sandy-NAM-20121029\����ͼ��';   %�ļ��洢Ŀ¼
%���㳡���ھ��Ⱥ�γ�ȷ���Ĺ۲�Ƿ�Χ
coordinate_filename = sprintf('%s\\coords.mat', file_path);
[angle_Long,angle_Lat] = Image_Long_Lat_calc(coordinate_filename,R,orbit_height);
scene_name = 'HurricanSandy_29_00';
channel_start_index = 1;
channel_end_index = 37;
%������������Ҫȫ����ʾ�ķ�����
   RMSE_list = [];
   Corr_coefficient_list =[];
   NEDT_list = [];  
   HPBW_list = [];
   ground_resolution_list = [];
   SLL_list = [];
   MBE_list =[]; 
   if  flag_Resolution_Enhancement == 1
   RMSE_RE_list = [];
   Corr_coefficient_RE_list =[];
   factor_opt_list = [];
   end

% ����Ҫ���������ͨ�����
for freq_index = channel_start_index:channel_end_index    
TB_filename = sprintf('%s_C%s_H.mat', scene_name,num2str(freq_index));
TB_matfile = sprintf('%s\\%s', file_path,TB_filename);
load(TB_matfile);
TB=(pic);
T_max=max(max(TB));
T_min=min(min(TB));
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
                     T_min = 220;
             case 2, freq= 51.76e9;  bandwith = 400e6;    noise_figure= 5;  antenna_diameter = 5; 
                     T_min = 235;
             case 3, freq= 52.8e9;   bandwith = 400e6;    noise_figure= 5;  antenna_diameter = 5; 
                     T_min = 235;
             case 4, freq= 53.596e9; bandwith = 400e6;    noise_figure= 5;  antenna_diameter = 5;
                     T_min = 240;
             case 5, freq= 54.4e9;   bandwith = 400e6;    noise_figure= 5;  antenna_diameter = 5;
                     T_min = 239;
             case 6, freq= 54.94e9;  bandwith = 400e6;    noise_figure= 5;  antenna_diameter = 5; 
                     T_min = 231;
             case 7, freq= 55.5e9;   bandwith = 330e6;    noise_figure= 5;  antenna_diameter = 5;
                     T_min = 220;
             case 8, freq= 57.29e9;  bandwith = 330e6;    noise_figure= 5;  antenna_diameter = 5; 
             case 9, freq= 57.507e9; bandwith = 2*78e6;   noise_figure= 5;  antenna_diameter = 5; 
             case 10,freq= 57.66e9;  bandwith = 4*36e6;   noise_figure= 5;  antenna_diameter = 5; 
             case 11,freq= 57.63e9;  bandwith = 4*16e6;   noise_figure= 5;  antenna_diameter = 5; 
             case 12,freq= 57.62e9;  bandwith = 4*8e6;    noise_figure= 5;  antenna_diameter = 5; 
             case 13,freq= 57.617e9; bandwith = 4*3e6;    noise_figure= 5;  antenna_diameter = 5; 
             case 14,freq= 88.2e9;   bandwith = 2000e6;   noise_figure= 7;  antenna_diameter = 5; 
                     T_min = 210;
             case 15,freq= 118.83e9; bandwith = 2*20e6;   noise_figure= 8;  antenna_diameter = 2.4;
             case 16,freq= 118.95e9; bandwith = 2*100e6;  noise_figure= 8;  antenna_diameter = 2.4;
             case 17,freq= 119.05e9; bandwith = 2*165e6;  noise_figure= 8;  antenna_diameter = 2.4;
             case 18,freq= 119.55e9; bandwith = 2*200e6;  noise_figure= 8;  antenna_diameter = 2.4;
                     T_min = 230;
             case 19,freq= 119.85e9; bandwith = 2*200e6;  noise_figure= 8;  antenna_diameter = 2.4;
                     T_min = 240;
             case 20,freq= 121.25e9; bandwith = 2*200e6;  noise_figure= 8;  antenna_diameter = 2.4;
                     T_min = 225;
             case 21,freq= 121.75e9; bandwith = 2*1000e6; noise_figure= 8;  antenna_diameter = 2.4;
                     T_min = 225;
             case 22,freq= 123.75e9; bandwith = 2*2000e6; noise_figure= 8;  antenna_diameter = 2.4;
                     T_min = 225;
             case 23,freq= 165.5e9;  bandwith = 3000e6;   noise_figure= 9;  antenna_diameter = 2.4;
                     T_min = 200;
             case 24,freq= 190.31e9; bandwith = 2*2000e6; noise_figure= 9;  antenna_diameter = 2.4;
                     T_min = 215;
             case 25,freq= 187.81e9; bandwith = 2*2000e6; noise_figure= 9;  antenna_diameter = 2.4;
                     T_min = 225;
             case 26,freq= 186.31e9; bandwith = 2*1000e6; noise_figure= 9;  antenna_diameter = 2.4;
                     T_min = 235;
             case 27,freq= 185.11e9; bandwith = 2*1000e6; noise_figure= 9;  antenna_diameter = 2.4;
                     T_min = 240;
             case 28,freq= 184.31e9; bandwith = 2*500e6;  noise_figure= 9;  antenna_diameter = 2.4;
                     T_min = 237;
             case 29,freq= 380e9;    bandwith = 2*1000e6; noise_figure= 11; antenna_diameter = 2.4;
                     T_min = 212;
             case 30,freq= 428.763e9;bandwith = 2*1000e6; noise_figure= 11; antenna_diameter = 2.4;
                     T_min = 227;
             case 31,freq= 426.263e9;bandwith = 2*600e6;  noise_figure= 11; antenna_diameter = 2.4;
                     T_min = 230;
             case 32,freq= 425.763e9;bandwith = 2*400e6;  noise_figure= 11; antenna_diameter = 2.4;
                     T_min = 220;
             case 33,freq= 425.363e9;bandwith = 2*200e6;  noise_figure= 11; antenna_diameter = 2.4;
                     T_min = 205;
             case 34,freq= 425.063e9;bandwith = 2*100e6;  noise_figure= 11; antenna_diameter = 2.4;
             case 35,freq= 424.913e9;bandwith = 2*60e6;   noise_figure= 11; antenna_diameter = 2.4;
             case 36,freq= 424.833e9;bandwith = 2*20e6;   noise_figure= 11; antenna_diameter = 2.4;
             case 37,freq= 424.793e9;bandwith = 2*10e6;   noise_figure= 11; antenna_diameter = 2.4;
end     
illumination_taper_num = 1;                                    %the illumination taper //by thesis of G.M.Skofronick
%% �����ǲ���ÿ��Ƶ���޸ĵķ���Ʋ���
c=3e8;                                                      %���� unit m/s
wavelength = c/freq;                                        %���� unit:m
integral_time = 40*10^(-3);                                 %����ʱ��, unit:S                                           
T_rec=290*(10^(noise_figure/10)-1);                         %����Ƶ�Ч�����¶�, unit:K
T_A = 250;                                                  %����ƽ��������������TA����λ��K
NEDT = (T_rec+T_A)/sqrt(bandwith*integral_time);            %����������ȣ���λ��K
Ba = pi*antenna_diameter/wavelength;                        %���ߵ糤�Ȳ���
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
   RMSE_taper =zeros(1,illumination_taper_num) ;
   Corr_coefficient_taper=zeros(1,illumination_taper_num) ;
   NEDT_taper=zeros(1,illumination_taper_num) ;
   HPBW_taper=zeros(1,illumination_taper_num) ;
   ground_resolution_taper=zeros(1,illumination_taper_num) ;
   SLL_taper=zeros(1,illumination_taper_num) ;
   MBE_taper=zeros(1,illumination_taper_num) ;
   if  flag_Resolution_Enhancement == 1
   RMSE_RE_taper=zeros(1,illumination_taper_num) ;
   Corr_coefficient_RE_taper=zeros(1,illumination_taper_num) ;
   factor_opt_taper=zeros(1,illumination_taper_num) ;
   end
%����ϵͳ���߷���ͼ����ָ�����
for illumination_taper = 0:illumination_taper_num-1
[Antenna_Pattern,HPBW,SLL,MBE] = RA_antenna_pattern_2D(Ba,Coordinate_Long,Coordinate_Lat,angle_Long,angle_Lat,illumination_taper,freq_index,flag_draw_pattern);
ground_resolution = HPBW/180*pi*orbit_height;
sample_density = HPBW/sample_width;                            %����������������ı�ֵ������ÿ��������Χ�ڵĲ�������

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
         Block_num = 5;                                                                                            %���ݷֿ����� 
         [TA_RE,factor_opt] = split_deconv_SIR(TA,TB,angle_Long,angle_Lat,Ba,illumination_taper,Block_num,sample_factor);
%         [TA_RE,factor_opt] = Scatterometer_Image_Restruction(TA,TB,angle_Long,angle_Lat,Ba,illumination_taper,Num_iteration);
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
   FileName = sprintf('RA_%s_C%d_H_D%s_q%d_��%s_sample%s',scene_name,freq_index,num2str(round(antenna_diameter*1000)),illumination_taper,num2str(integral_time),num2str(round(sample_width/180*pi*orbit_height)));
   if flag_Resolution_Enhancement == 1;
   FileName = sprintf('%s_%s', FileName,Resolution_Enhancement_name);
   end
   MatFileName = sprintf('%s.mat', FileName);
   save(['..\RA������\' MatFileName],'TA_noiseless','TA','Antenna_Pattern','NEDT','HPBW','SLL','MBE','RMSE','Corr_coefficient','ground_resolution'); 
   if  flag_Resolution_Enhancement == 1;
   save(['..\RA������\' MatFileName],'TA_RE','RMSE_RE','Corr_coefficient_RE','factor_opt','-append'); 
   end
end

   %��ÿ��channel����taperֵ�������б�ֵ
   RMSE_taper(illumination_taper+1) = RMSE;
   RMSE_RE_taper(illumination_taper+1) = RMSE_RE;
   Corr_coefficient_taper(illumination_taper+1) =Corr_coefficient;
   Corr_coefficient_RE_taper(illumination_taper+1) =Corr_coefficient_RE;
   factor_opt_taper(illumination_taper+1)=factor_opt;
   NEDT_taper(illumination_taper+1) = NEDT;  
   HPBW_taper(illumination_taper+1) = HPBW;
   ground_resolution_taper(illumination_taper+1) = ground_resolution;
   SLL_taper(illumination_taper+1) = SLL;
   MBE_taper(illumination_taper+1) = MBE;
end
   %������channel�������б�ֵ
   RMSE_list = [RMSE_list;RMSE_taper];
   RMSE_RE_list = [RMSE_RE_list;RMSE_RE_taper];
   Corr_coefficient_list =[Corr_coefficient_list;Corr_coefficient_taper];
   Corr_coefficient_RE_list =[Corr_coefficient_RE_list;Corr_coefficient_RE_taper];
   factor_opt_list=[factor_opt_list;factor_opt_taper];
   NEDT_list = [NEDT_list;NEDT_taper];  
   HPBW_list = [HPBW_list;HPBW_taper];
   ground_resolution_list = [ground_resolution_list;ground_resolution_taper];
   SLL_list = [SLL_list;SLL_taper];
   MBE_list =[MBE_list;MBE_taper];
%part5��end**************************************************************************************************************************************************
end

disp([num2str(antenna_diameter),'�׿ھ���ʵ�׾�������غɶ�����������',scene_name,'@',Resolution_Enhancement_name,'�ֱ�����ǿ�㷨�����','������']);
disp('taper=0, taper=1')
disp('----------------------------------------------')
disp('�۲�RMSE');
disp(roundn(RMSE_list,-2));
disp('----------------------------------------------')
disp('�ֱ�����ǿ������RMSE');
disp(roundn(RMSE_RE_list,-2));
disp('----------------------------------------------')
disp(['�۲����ϵ��']);
disp(roundn(Corr_coefficient_list,-3));
disp('----------------------------------------------')
disp(['�ֱ�����ǿ���������ϵ��']);
disp(roundn(Corr_coefficient_RE_list,-3));
disp('----------------------------------------------')
disp(['�ֱ�����ǿ���Ų���ֵfactor']);
disp(factor_opt_list);
disp('----------------------------------------------')
disp(['������']);
disp(roundn(NEDT_list,-2));
disp('----------------------------------------------')
disp(['3dB�������']);
disp(roundn(HPBW_list,-3));
disp('----------------------------------------------')
disp(['����ֱ���']); 
disp(roundn(ground_resolution_list,0));
disp('----------------------------------------------')
disp(['�����ƽ']);
disp(roundn(SLL_list,-1));
disp('----------------------------------------------')
disp(['������Ч��']);
disp(roundn(MBE_list,-1));

if flag_save == 1;
   SaveFileName = sprintf('RA_%s_D%s_��%s_sample%s',scene_name,num2str(round(antenna_diameter*1000)),num2str(integral_time),num2str(round(sample_width/180*pi*orbit_height)));
   if flag_Resolution_Enhancement == 1;
   SaveFileName = sprintf('%s_%s', SaveFileName,Resolution_Enhancement_name);
   end
   SaveMatFileName = sprintf('%s_result_list.mat', SaveFileName);
   save(['..\RA������\' SaveMatFileName],'RMSE_list','Corr_coefficient_list','NEDT_list','HPBW_list','ground_resolution_list','SLL_list','MBE_list');
   if  flag_Resolution_Enhancement == 1;
   save(['..\RA������\' SaveMatFileName],'RMSE_RE_list','Corr_coefficient_RE_list','factor_opt_list','-append'); 
   end    
end
toc;