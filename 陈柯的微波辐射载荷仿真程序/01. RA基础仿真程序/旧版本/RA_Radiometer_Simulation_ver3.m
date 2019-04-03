%������ģ��ʵ�׾�������غɹ۲�����
%by �¿� 2015.11.10 --updated 2016.10.19 

clear;
close all;
tic;
%%***************************���²��������ñ�־λ�͹������**********************************************************
flag_draw_TB = 1;                               %����ԭʼ����TB                     
flag_save = 1;                                  %���ݴ洢��־λ
flag_BG = 0;
RMSE_offset  = 20;                               %�۲�ͼ����ԭʼͼ��Ա�ʱͼ���Եȥ�����л�����
R = 6371;                                       %����뾶 unit:km
orbit_height = 35786;                           %����߶ȣ���ǰΪ����ֹ�����, unit:km
%*********************************************************************************************************

%% ********************************************************part1����������ͼ�񳡾��������ռ����������ֵ********************************************
%����ѡ��ģ�����³�����ȡ��ӦƵ�ε�ģ������ͼ��
file_path = 'D:\��ǰ�Ĺ���\2015.03.21 ��������ͬ����GEO�����о�\01. ������������\2016.10.09 쫷�sandy-NAM-20121029\����ͼ��';   %�ļ��洢Ŀ¼ 
TB_filename = 'HurricanSandy_29_00_C1_H';     %����ͼ���ļ������ó�����ΧΪ1500*1500����
TB_matfile = sprintf('%s\\%s.mat', file_path,TB_filename);
load(TB_matfile);
TB=(pic);
T_max=max(max(TB));
T_min=min(min(TB));
% T_min=220;
[N_Lat,N_Long] = size(TB);
%���㳡���ھ��Ⱥ�γ�ȷ���Ĺ۲�Ƿ�Χ
coordinate_filename = sprintf('%s\\coords.mat', file_path);
[angle_Long,angle_Lat] = Image_Long_Lat_calc(coordinate_filename,R,orbit_height);
%����ͼ��ռ�Ƕ��������*********************************************
%����ռ����С
d_Long = angle_Long/(N_Long);                  %����ͼ�񾭶ȷ�����С��࣬���Ƕȷֱ���  
d_Lat = angle_Lat/(N_Lat);                     %����ͼ��γ�ȷ�����С��࣬���Ƕȷֱ��� 
%����ͼ�����ʵ�ռ��ά�Ƕ�����ֵ
Coordinate_Long = linspace(-angle_Long/2,angle_Long/2-d_Long,N_Long);   %���ȽǶ���������
Coordinate_Lat = linspace(-angle_Lat/2,angle_Lat/2-d_Lat,N_Lat);        %γ�ȽǶ���������
[Fov_Long,Fov_Lat] = meshgrid(Coordinate_Long,Coordinate_Lat);          %����γ�ȷ����ά�������
AP_Coordinate_Long = linspace(-angle_Long,angle_Long-d_Long,2*N_Long);
AP_Coordinate_Lat = linspace(-angle_Lat,angle_Lat-d_Lat,2*N_Lat);
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
             case 29,freq= 380e9;    bandwith = 2*1000e6; noise_figure= 11; antenna_diameter = 2.4;
             case 30,freq= 428.763e9;bandwith = 2*1000e6; noise_figure= 11; antenna_diameter = 2.4;
             case 31,freq= 426.263e9;bandwith = 2*600e6;  noise_figure= 11; antenna_diameter = 2.4;
             case 32,freq= 425.763e9;bandwith = 2*400e6;  noise_figure= 11; antenna_diameter = 2.4;
             case 33,freq= 425.363e9;bandwith = 2*200e6;  noise_figure= 11; antenna_diameter = 2.4;
             case 34,freq= 425.063e9;bandwith = 2*100e6;  noise_figure= 11; antenna_diameter = 2.4;
             case 35,freq= 424.913e9;bandwith = 2*60e6;   noise_figure= 11; antenna_diameter = 2.4;
             case 36,freq= 424.833e9;bandwith = 2*20e6;   noise_figure= 11; antenna_diameter = 2.4;
             case 37,freq= 424.793e9;bandwith = 2*10e6;   noise_figure= 11; antenna_diameter = 2.4;
end     
% freq = 50.3e9;                                             %���������Ƶ�ʣ���λ:Hz
% bandwith = 180e6;                                          %����ƴ���, unit:Hz
% noise_figure= 5;                                           %���������ϵ��, unit:dB
% antenna_diameter = 5;                                      %��������߿ھ� ��λ����
illumination_taper = 0;                                    %the illumination taper //by thesis of G.M.Skofronick
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
sample_width = min(sample_width_Lat,sample_width_Long);
%���÷����������յ�ǰ����Ƶ�εĲ�����ȵ�ĳһ��������
% sample_factor = 0.5;                                       %����ϵ����Ϊ��������뵱ǰƵ�ʲ������֮��
% sample_width = sample_factor*beam_width;                   %�غ�����ɨ��������λ����
% sample_width_Lat = max(sample_width,d_Lat);                %��γ�ȷ������߲����ĸ��Ƕ�
% sample_width_Long = max(sample_width,d_Long);              %�ھ��ȷ������߲����ĸ��Ƕ�
%���÷����ģ�ֱ�Ӱ���ĳһ�Ƕ�ֵ����
% sample_width = 0.01;                                       %�غ�����ɨ��������λ����
% sample_width_Lat = max(sample_width,d_Lat);                %��γ�ȷ������߲����ĸ��Ƕ�
% sample_width_Long = max(sample_width,d_Long);              %�ھ��ȷ������߲����ĸ��Ƕ�
%part2��end**************************************************************************************************************************************************


%% ********************************************************part3��ģ����������ɨ��۲������̣�����۲����������ͼ��TA**************************************
%����ϵͳ���߷���ͼ����ָ�����
[Antenna_Pattern,HPBW,SLL,MBE] = RA_antenna_pattern_2D(Ba,Coordinate_Long,Coordinate_Lat,angle_Long,angle_Lat,illumination_taper,freq_index,flag_draw_pattern);

sample_density = HPBW/sample_width;                            %����������������ı�ֵ������ÿ��������Χ�ڵĲ�������
N_TA_Lat = round(angle_Lat/sample_width_Lat);                   %γ�ȷ�����������ɨ�����  
N_TA_Long = round(angle_Long/sample_width_Long);                %���ȷ�����������ɨ�����  
%��������ÿ��ɨ�貨��ָ��Ƕ�Ӧ������ͼ���С��б��
row_TA_Lat = zeros(1,N_TA_Lat);                                 %����ÿ��ɨ�貨��ָ��Ƕ�Ӧ������ͼ���б��
col_TA_Long = zeros(1,N_TA_Long);                               %����ÿ��ɨ�貨��ָ��Ƕ�Ӧ������ͼ���б��
for i = 1:N_TA_Lat  %�б��
    delta_angle=(i-1)*(sample_width_Lat);
    row_TA_Lat(i) = min(round(delta_angle/angle_Lat*N_Lat)+1,N_Lat);    
end
for i = 1:N_TA_Long  %�б��
    delta_angle=(i-1)*(sample_width_Long);
    col_TA_Long(i) = min(round(delta_angle/angle_Long*N_Long)+1,N_Long);    
end
%%%%%%%%%%%%%%%%����ģ��۲�����TA%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Antenna_Pattern_Full = Antenna_Pattern_calc(AP_Coordinate_Long,AP_Coordinate_Lat,Ba,illumination_taper);
%��ʼ���۲����������ͼ��TA
TA=zeros(N_TA_Lat,N_TA_Long);  
matlabpool open ;
parfor sample_num_Lat=1:N_TA_Lat
     for sample_num_Long=1:N_TA_Long
         %�������߷���ͼƽ�����������½��о��������ģ��ÿ�����صĹ۲�����TA  
         row_current=row_TA_Lat(sample_num_Lat);
         col_current=col_TA_Long(sample_num_Long);
         Antenna_Pattern_current = Antenna_Pattern_Full(N_Lat+1-row_current+1:2*N_Lat+1-row_current,N_Long+1-col_current+1:2*N_Long+1-col_current) 
         Antenna_Pattern_current = Antenna_Pattern_current/sum(sum(Antenna_Pattern_current));
         TA(sample_num_Lat,sample_num_Long)=sum(sum(TB.* Antenna_Pattern_current));        
    end
end
matlabpool close ;

TA_conv = conv2(TB,Antenna_Pattern,'same');
figure;
h =subplot(1,2,1); imagesc(Coordinate_Long,Coordinate_Lat,TA,[T_min T_max]);axis equal;xlim([-angle_Long/2,angle_Long/2]);ylim([-angle_Lat/2,angle_Lat/2]);
h =subplot(1,2,2); set(gca, 'Units', 'normalized', 'Position', [0.505 0.505 0.495 0.495]);
imagesc(Coordinate_Long,Coordinate_Lat,TA_conv,[T_min T_max]);axis equal;xlim([-angle_Long/2,angle_Long/2]);ylim([-angle_Lat/2,angle_Lat/2]);colorbar;


RMSE_conv = Root_Mean_Square_Error(TB,TA_conv,RMSE_offset,0);
Corr_coefficient_conv = TB_correlation_coefficient(TB,TA_conv,RMSE_offset);
RMSE = Root_Mean_Square_Error(TB,TA,RMSE_offset,0);
Corr_coefficient = TB_correlation_coefficient(TB,TA,RMSE_offset);
disp(RMSE_conv); disp(Corr_coefficient_conv);
disp(RMSE); disp(Corr_coefficient);

%%%%��ģ��۲�����TA����ϵͳ����
TA_real = add_image_noise(TA,bandwith,integral_time,noise_figure);
figure;imagesc(Coordinate_Long,Coordinate_Lat,TA_real,[T_min T_max]);axis equal;xlim([-angle_Long/2,angle_Long/2]);ylim([-angle_Lat/2,angle_Lat/2]);
xlabel('���ȷ���'); ylabel('γ�ȷ���');title('�۲�����ͼ��TA');colorbar;
%part3��end**************************************************************************************************************************************************

%% ********************************************************part4��BG��������*********************************************************************
if  flag_BG == 1;
num_r = 10;                                         %rֵ��̽����
d_Long_TA = angle_Long/(N_TA_Long);
d_Lat_TA = angle_Lat/(N_TA_Lat);
BG_Coordinate_Long = linspace(-angle_Long,angle_Long-d_Long_TA,2*N_TA_Long);
BG_Coordinate_Lat = linspace(-angle_Lat,angle_Lat-d_Lat_TA,2*N_TA_Lat);
Antenna_Pattern_BG = Antenna_Pattern_calc(BG_Coordinate_Long,BG_Coordinate_Lat,Ba,illumination_taper);
TA_BG = BG_deconv(TA,Antenna_Pattern_BG);
% TA_real_BG = BG_deconv_real(TA_real,Antenna_Pattern_BG,T_rec,bandwith,integral_time,0.3);
% ����ʱ����BG����
MSE_array = zeros(num_r,1);                                           
TA_real_BG_array = zeros(N_TA_Lat,N_TA_Long,num_r);
R = linspace(0.1,1,num_r);
for i = 1:num_r                                                     %��N_r��rֵ������̽
    TA_real_BG = BG_deconv_real(TA_real,Antenna_Pattern_BG,T_rec,bandwith,integral_time,R(i));
    [MSE_array(i),~] = Mean_Square_Error(TB,TA_real_BG,RMSE_offset,0);
    TA_real_BG_array(:,:,i) = TA_real_BG;                                %��ÿһ��rֵ��ͼ�񴢴�
end
index_min = find(MSE_array == min(MSE_array));                  %�ҳ�MSE����Сֵ����Ϊ���Ż���R����
TA_real_BG = TA_real_BG_array(:,:,index_min);                        %ȡ��MSE��С��ͼ��
% 
figure;stem(R,MSE_array,'fill','r-.');xlabel('R'); ylabel('MSE');title('��ͬRֵ�µ�BG�����ͼ���MSE'); 
figure;imagesc(Coordinate_Long,Coordinate_Lat,TA_BG,[T_min T_max]);axis equal;xlim([-angle_Long/2,angle_Long/2]);ylim([-angle_Lat/2,angle_Lat/2]);
xlabel('���ȷ���'); ylabel('γ�ȷ���');title('����BG�����������ͼ��');colorbar;
figure;imagesc(Coordinate_Long,Coordinate_Lat,TA_real_BG,[T_min T_max]);axis equal;xlim([-angle_Long/2,angle_Long/2]);ylim([-angle_Lat/2,angle_Lat/2]);
xlabel('���ȷ���'); ylabel('γ�ȷ���');title('����BG�����������ͼ��');colorbar;

end
%part3��end*****************************************************************************************************************************************


%% ********************************************************part5����ʾ����ָ�겢�洢��������************************************************
%������򾫶ȣ��ù۲�����TA������Tb��RMSE������
[RMSE_real,norm_RMSE_real] = Root_Mean_Square_Error(TB,TA_real,RMSE_offset,0);
[RMSE,norm_RMSE] = Root_Mean_Square_Error(TB,TA,RMSE_offset,0);
[RMSE_BG,norm_RMSE_BG] = Root_Mean_Square_Error(TB,TA_BG,RMSE_offset,0);
[RMSE_real_BG,norm_RMSE_real_BG] = Root_Mean_Square_Error(TB,TA_real_BG,RMSE_offset,0);

%%%%%%%%%%��ʾ����õ�ϵͳָ��ͳ��񾫶�%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp([num2str(freq/1e9),'GHzƵ�Σ�',num2str(antenna_diameter),'�׿ھ���ʵ�׾�������غɣ�@taper=',num2str(illumination_taper),')']);
disp(['3dB�������=',num2str(roundn(HPBW,-3)),'�b','������ֱ���=',num2str(roundn(HPBW/180*pi*orbit_height,-1)),'����']);
disp(['����ɨ�������=',num2str(roundn(sample_width/180*pi*orbit_height,-1)),'����,�����ܶ�=',num2str(roundn(sample_density,-1))]);
disp(['��һ�����ƽ=',num2str(roundn(SLL,-1)),'dB']);
disp(['������Ч��MBE=',num2str(roundn(MBE,-1)),'%']);
disp(['ʵ�׾����������������=',num2str(roundn(NEDT,-2)),'K']);  
disp([num2str(antenna_diameter),'�׿ھ���ʵ�׾�������غ��������RMSE=',num2str(roundn(RMSE,-2)),'K��,��һ��RMSE=',num2str(roundn(norm_RMSE,-3))]);
disp([num2str(antenna_diameter),'�׿ھ���ʵ�׾�������غ�����BG�ؽ�RMSE=',num2str(roundn(RMSE_BG,-2)),'K��,��һ��RMSE=',num2str(roundn(norm_RMSE_BG,-3))]);
disp([num2str(antenna_diameter),'�׿ھ���ʵ�׾�������غ��������RMSE=',num2str(roundn(RMSE_real,-2)),'K��,��һ��RMSE=',num2str(roundn(norm_RMSE_real,-3))]);
disp([num2str(antenna_diameter),'�׿ھ���ʵ�׾�������غ�����BG�ؽ�RMSE=',num2str(roundn(RMSE_real_BG,-2)),'K@R=',num2str(roundn(R(index_min),-1)),',��һ��RMSE=',num2str(roundn(norm_RMSE_real_BG,-3))]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if flag_save == 1
   tempstr=textscan(TB_filename,'%s', 'delimiter', '.');
   tempstr=tempstr{1,1};
   Scene = tempstr{size(tempstr,1)-1,1};
   FileName = sprintf('RA_%s_D%s_q%d_��%s_sample%s', Scene,num2str(round(antenna_diameter*1000)),illumination_taper,num2str(integral_time),num2str(roundn(sample_density,-1)));
   MatFileName = sprintf('%s.mat', FileName);
   save(['..\RA������\' MatFileName],'TA','TA_real','TA_BG','TA_real_BG','Antenna_Pattern','HPBW','SLL','MBE','RMSE','RMSE_BG','RMSE_real','RMSE_real_BG','index_min'); 
   save(['..\RA������\' MatFileName],'norm_RMSE','norm_RMSE_BG','norm_RMSE_real','norm_RMSE_real_BG','-append'); 
end
%part5��end**************************************************************************************************************************************************

toc;