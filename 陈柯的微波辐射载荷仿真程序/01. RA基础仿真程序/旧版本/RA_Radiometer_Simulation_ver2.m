%������ģ��ʵ�׾�������غɹ۲�����
%by �¿� 2015.11.10

clear;
close all;
tic;
%%***************************���²��������ñ�־λ**********************************************************
flag_draw_TB = 1;                                           %����ԭʼ����TB                     
flag_save = 0;                                              %���ݴ洢��־λ
%*********************************************************************************************************



%%********************************************************part1��������غɲ�����ɨ�������������**************************************************************
%%***************************���÷���Ʋ���******************************
freq = 50.3e9;                                               %���������Ƶ�ʣ���λ:Hz
c=3e8;                                                      %���� unit m/s
wavelength = c/freq;                                          %���� unit:m
R = 6371;                                                   %����뾶 unit:km
orbit_height = 35786;                                       %����߶ȣ���ǰΪ����ֹ�����, unit:km
antenna_diameter = 3.7;                                       %���߿ھ� ��λ����
illumination_taper = 0;                                     %the illumination taper //by thesis of G.M.Skofronick
bandwith = 180*10^6;                                        %����ƴ���, unit:Hz
integral_time = 20*10^(-3);                                 %����ʱ��, unit:S
noise_figure= 5;                                            %���������ϵ��, unit:dB
T_rec=290*(10^(noise_figure/10)-1);                         %����Ƶ�Ч�����¶�, unit:K
T_A = 250;                                                  %����ƽ��������������TA����λ��K
NEDT = (T_rec+T_A)/sqrt(bandwith*integral_time);            %����������ȣ���λ��K
Ba = pi*antenna_diameter/wavelength;                        %���ߵ糤�Ȳ���
%%***************************����ɨ������Ƕȼ������*******************
%���÷���һ�����շ������߹���Ƶ�εĲ�����ȵ�ĳһ��������
sample_freq = 183.31e9;                                        %�������߹���Ƶ��
sample_factor = 1;                                          %����ϵ����Ϊ������������Ƶ�β������֮��
sample_wavelength = c/sample_freq;                          %�������߹���Ƶ�εĲ���
sample_beam=1.02*sample_wavelength/antenna_diameter*180/pi; %�������߹���Ƶ�ζ�Ӧ�������
sample_width = sample_factor*sample_beam;                   %�غ�����ɨ��������λ����
% %���÷����������յ�ǰ����Ƶ�εĲ�����ȵ�ĳһ��������
% sample_factor = 0.5;                                      %����ϵ����Ϊ��������뵱ǰƵ�ʲ������֮��
% sample_width = sample_factor*beam_width;                  %�غ�����ɨ��������λ����
% %���÷�������ֱ�Ӱ���ĳһ�Ƕ�ֵ����
% sample_width = 0.01;                                      %�غ�����ɨ��������λ����
%part1��end**************************************************************************************************************************************************


%%********************************************************part2����������ͼ�񳡾��������ռ����������ֵ********************************************
%����ѡ��ģ�����³�����ȡ��ӦƵ�ε�ģ������ͼ��
file_path = 'D:\��ǰ�Ĺ���\2015.03.21 ��������ͬ����GEO�����о�\������������\2016.10.09 쫷�sandy-NAM-20121029\����ͼ��';   %�ļ��洢Ŀ¼ 
TB_filename = 'HurricanSandy_50-3_H_29_00.mat';     %����ͼ���ļ������ó�����ΧΪ1500*1500����
TB_matfile = sprintf('%s\\%s', file_path,TB_filename);
load(TB_matfile);
TB=(pic);
T_max=max(max(TB));
T_min=min(min(TB));
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
%part2��end**************************************************************************************************************************************************


%%********************************************************part3��ģ����������ɨ��۲������̣�����۲����������ͼ��TA**************************************
%����ϵͳ���߷���ͼ����ָ�����
[Antenna_Pattern,HPBW,SLL,MBE] = RA_antenna_pattern_2D(Ba,Coordinate_Long,Coordinate_Lat,angle_Long,angle_Lat,illumination_taper);
sample_density = HPBW/sample_width;                   %����������������ı�ֵ������ÿ��������Χ�ڵĲ�������

sample_width_Lat = max(sample_width,d_Lat);                    %��γ�ȷ������߲����ĸ��Ƕ�
sample_width_Long = max(sample_width,d_Long);                  %�ھ��ȷ������߲����ĸ��Ƕ�
N_TA_Lat = round(angle_Lat/sample_width_Lat);                   %γ�ȷ�����������ɨ�����  
N_TA_Long = round(angle_Long/sample_width_Long);                %���ȷ�����������ɨ�����
Sample_Coordinate_Long = 0:sample_width:(N_TA_Long-1)*sample_width;
Sample_Coordinate_Lat = 0:sample_width:(N_TA_Lat-1)*sample_width;

%%%%%%%%%%%%%%%%����ģ��۲�����TA%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%��������߷���ͼ
Antenna_Pattern_Full = Antenna_Pattern_calc(AP_Coordinate_Long,AP_Coordinate_Lat,Ba,illumination_taper);
[AP_2D_Long, AP_2D_Lat] = meshgrid(AP_Coordinate_Long,AP_Coordinate_Lat);  %�����߷���ͼ����ľ�γ������
%δɨ�������ͼ��γ������
original_Coordinate_Long = linspace(0,angle_Long-d_Long,N_Long);
original_Coordinate_Lat = linspace(0,angle_Lat-d_Lat,N_Lat);
%��ʼ���۲����������ͼ��TA
TA=zeros(N_TA_Lat,N_TA_Long); 
matlabpool open ;
parfor sample_num_Lat=1:N_TA_Lat
     for sample_num_Long=1:N_TA_Long
         %�������߷���ͼ��ֵ�õ���ǰɨ��ָ��ķ���ͼ���������½��о��������ģ��ÿ�����صĹ۲�����TA 
         %���ߵ�ǰɨ��ָ��ľ�γ������
         current_center_Long = Sample_Coordinate_Long(sample_num_Long);
         current_center_Lat = Sample_Coordinate_Lat(sample_num_Lat);
         %�����ߵ�ǰɨ��ָ����Ϊ�µ�������㣬����ԭʼ����ϵҪ����µ�������ƽ�Ƶõ�
         current_Coordinate_Long = original_Coordinate_Long - current_center_Long;
         current_Coordinate_Lat = original_Coordinate_Lat - current_center_Lat;
         [current_2D_Long, current_2D_Lat] = meshgrid(current_Coordinate_Long,current_Coordinate_Lat);
         %�µ������µķ���ͼ�ö�ԭʼ���߷���ͼ��ֵ�õ���
         current_Antenna_Pattern = interp2(AP_2D_Long, AP_2D_Lat,Antenna_Pattern_Full,current_2D_Long, current_2D_Lat,'spline');  %����������ֵ���������
         current_Antenna_Pattern = current_Antenna_Pattern/sum(sum(current_Antenna_Pattern));
         TA(sample_num_Lat,sample_num_Long)=sum(sum(TB.* current_Antenna_Pattern)); 
    end
end
matlabpool close ;
%%%%��ģ��۲�����TA����ϵͳ����
TA_real = add_image_noise(TA,bandwith,integral_time,noise_figure);
figure;imagesc(Coordinate_Long,Coordinate_Lat,TA_real,[T_min T_max]);axis equal;xlim([-angle_Long/2,angle_Long/2]);ylim([-angle_Lat/2,angle_Lat/2]);
xlabel('���ȷ���'); ylabel('γ�ȷ���');title('�۲�����ͼ��TA');colorbar;
%part3��end**************************************************************************************************************************************************

%%********************************************************part4��BG��������*********************************************************************
d_Long_TA = angle_Long/(N_TA_Long);
d_Lat_TA = angle_Lat/(N_TA_Lat);
BG_Coordinate_Long = linspace(-angle_Long,angle_Long-d_Long_TA,2*N_TA_Long);
BG_Coordinate_Lat = linspace(-angle_Lat,angle_Lat-d_Lat_TA,2*N_TA_Lat);
Antenna_Pattern_BG = Antenna_Pattern_calc(BG_Coordinate_Long,BG_Coordinate_Lat,Ba,illumination_taper);
TA_BG = BG_deconv(TA,Antenna_Pattern_BG,T_rec,bandwith,integral_time);
figure;imagesc(Coordinate_Long,Coordinate_Lat,TA_BG,[T_min T_max]);axis equal;xlim([-angle_Long/2,angle_Long/2]);ylim([-angle_Lat/2,angle_Lat/2]);
xlabel('���ȷ���'); ylabel('γ�ȷ���');title('BG�����������ͼ��');colorbar;
%part3��end*****************************************************************************************************************************************


%%********************************************************part5����ʾ����ָ�겢�洢��������*********************************************************************
%������򾫶ȣ��ù۲�����TA������Tb��RMSE������
[MSE,PSNR] = Mean_Square_Error(TB,TA,10,0);
[MSE_BG,PSNR_BG] = Mean_Square_Error(TB,TA_BG,10,0);
[MSE_real,PSNR_real] = Mean_Square_Error(TB,TA_real,10,1);
%%%%%%%%%%��ʾ����õ�ϵͳָ��ͳ��񾫶�%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp([num2str(freq/1e9),'GHzƵ�Σ�',num2str(antenna_diameter),'�׿ھ���ʵ�׾�������غɣ�@taper=',num2str(illumination_taper),')']);
disp(['3dB�������=',num2str(roundn(HPBW,-3)),'�b','������ֱ���=',num2str(roundn(HPBW/180*pi*orbit_height,-1)),'����']);
disp(['����ɨ�������=',num2str(roundn(sample_width,-3)),'�b',',����ɨ�������=',num2str(roundn(sample_width/180*pi*orbit_height,-1)),'����,�����ܶ�=',num2str(roundn(sample_density,-1))]);
disp(['��һ�����ƽ=',num2str(roundn(SLL,-1)),'dB']);
disp(['������Ч��MBE=',num2str(roundn(MBE,-1)),'%']);
disp(['ʵ�׾����������������=',num2str(roundn(NEDT,-2)),'K']);  
disp([num2str(antenna_diameter),'�׿ھ���ʵ�׾�������غɳ������=',num2str(roundn(MSE,-2)),'K����ֵ�����=',num2str(roundn(PSNR,-1)),'dB']);
disp([num2str(antenna_diameter),'�׿ھ���ʵ�׾�������غ�BG�������=',num2str(roundn(MSE_BG,-2)),'K����ֵ�����=',num2str(roundn(PSNR_BG,-1)),'dB']);
disp([num2str(antenna_diameter),'�׿ھ���ʵ�׾�������غɼ���������=',num2str(roundn(MSE_real,-2)),'K����ֵ�����=',num2str(roundn(PSNR_real,-1)),'dB']);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if flag_save == 1
   tempstr=textscan(TB_filename,'%s', 'delimiter', '.');
   tempstr=tempstr{1,1};
   Scene = tempstr{size(tempstr,1)-1,1};
   FileName = sprintf('RA_%s_D%s_q%d_��%s_sample%s', Scene,num2str(round(antenna_diameter*1000)),illumination_taper,num2str(integral_time),num2str(roundn(sample_density,-1)));
   MatFileName = sprintf('%s.mat', FileName);
   save(['..\RA������\' MatFileName],'TA','TA_real','TA_BG','Antenna_Pattern','HPBW','SLL','MBE');    
end
%part5��end**************************************************************************************************************************************************

toc;