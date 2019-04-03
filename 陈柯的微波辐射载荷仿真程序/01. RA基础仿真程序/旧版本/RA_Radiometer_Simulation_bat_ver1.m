%������ģ��ʵ�׾�������غɹ۲�����
%by �¿� 2015.11.10

clear;
close all;
tic;
%***************************���²��������ñ�־λ**********************************************************
flag_draw_TB = 1;                               %����ԭʼ����TB                     
flag_save = 0;                                  %���ݴ洢��־λ
MSE_offset  = 20;                               %�۲�ͼ����ԭʼͼ��Ա�ʱͼ���Եȥ�����л�����
%*********************************************************************************************************

%% ********************************************************part1��������غɲ�����ɨ�������������**************************************************************
%***************************���÷���Ʋ���******************************
%% ������ÿ��Ƶ����Ҫ�޸ĵķ���Ʋ���
freq = 428.763e9;                 %���������Ƶ�ʣ���λ:Hz
bandwith = 2000*10^6;              %����ƴ���, unit:Hz
noise_figure= 11;                  %���������ϵ��, unit:dB
antenna_diameter = 2.4;           %��������߿ھ� ��λ���� 
%% �����ǲ���ÿ��Ƶ���޸ĵķ���Ʋ���
c=3e8;                                                      %���� unit m/s
wavelength = c/freq;                                          %���� unit:m
R = 6371;                                                   %����뾶 unit:km
orbit_height = 35786;                                       %����߶ȣ���ǰΪ����ֹ�����, unit:km
integral_time = 20*10^(-3);                                 %����ʱ��, unit:S                                           
T_rec=290*(10^(noise_figure/10)-1);                         %����Ƶ�Ч�����¶�, unit:K
T_A = 250;                                                  %����ƽ��������������TA����λ��K
NEDT = (T_rec+T_A)/sqrt(bandwith*integral_time);            %����������ȣ���λ��K
Ba = pi*antenna_diameter/wavelength;                        %���ߵ糤�Ȳ���
illumination_taper = 1;                                     %the illumination taper //by thesis of G.M.Skofronick
%%***************************����ɨ������Ƕȼ������*******************
%���÷���һ�����շ������߹���Ƶ�εĲ�����ȵ�ĳһ��������
sample_freq = 424.763e9;                                    %�������߹���Ƶ��
sample_factor = 1;                                          %����ϵ����Ϊ������������Ƶ�β������֮��
sample_wavelength = c/sample_freq;                          %�������߹���Ƶ�εĲ���
sample_antenna_diameter = 2.4;
sample_beam=sample_wavelength/sample_antenna_diameter*180/pi; %�������߹���Ƶ�ζ�Ӧ�������
sample_width = sample_factor*sample_beam;                   %�غ�����ɨ��������λ����
% %���÷����������յ�ǰ����Ƶ�εĲ�����ȵ�ĳһ��������
% sample_factor = 0.5;                                      %����ϵ����Ϊ��������뵱ǰƵ�ʲ������֮��
% sample_width = sample_factor*beam_width;                  %�غ�����ɨ��������λ����
% %���÷�������ֱ�Ӱ���ĳһ�Ƕ�ֵ����
% sample_width = 0.01;                                      %�غ�����ɨ��������λ����
%%part1��end**************************************************************************************************************************************************


%% ********************************************************part2����������ͼ�񳡾��������ռ����������ֵ********************************************
%����ѡ��ģ�����³�����ȡ��ӦƵ�ε�ģ������ͼ��
file_path = 'D:\��ǰ�Ĺ���\2015.03.21 ��������ͬ����GEO�����о�\������������\2016.10.09 쫷�sandy-NAM-20121029\����ͼ��';   %�ļ��洢Ŀ¼ 
TB_filename = 'HurricanSandy_428-763_H_29_00.mat';     %����ͼ���ļ������ó�����ΧΪ1500*1500����
TB_matfile = sprintf('%s\\%s', file_path,TB_filename);
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
%part2��end**************************************************************************************************************************************************


%% ********************************************************part3��ģ����������ɨ��۲������̣�����۲����������ͼ��TA**************************************
% sample_width_Lat = max(sample_width,d_Lat);                    %��γ�ȷ������߲����ĸ��Ƕ�
% sample_width_Long = max(sample_width,d_Long);                  %�ھ��ȷ������߲����ĸ��Ƕ�
sample_width_Lat = 2*d_Lat;                                      %��γ�ȷ������߲����ĸ��Ƕ�
sample_width_Long = 2*d_Long;                                    %�ھ��ȷ������߲����ĸ��Ƕ�
sample_width = min(sample_width_Lat,sample_width_Long);
N_TA_Lat = round(angle_Lat/sample_width_Lat);                    %γ�ȷ�����������ɨ�����  
N_TA_Long = round(angle_Long/sample_width_Long);                 %���ȷ�����������ɨ�����  
%��������ÿ��ɨ�貨��ָ��Ƕ�Ӧ������ͼ���С��б��
row_TA_Lat = zeros(1,N_TA_Lat);                                  %����ÿ��ɨ�貨��ָ��Ƕ�Ӧ������ͼ���б��
col_TA_Long = zeros(1,N_TA_Long);                                %����ÿ��ɨ�貨��ָ��Ƕ�Ӧ������ͼ���б��
for i = 1:N_TA_Lat  %�б��
    delta_angle=(i-1)*(sample_width_Lat);
    row_TA_Lat(i) = min(round(delta_angle/angle_Lat*N_Lat)+1,N_Lat);    
end
for i = 1:N_TA_Long  %�б��
    delta_angle=(i-1)*(sample_width_Long);
    col_TA_Long(i) = min(round(delta_angle/angle_Long*N_Long)+1,N_Long);    
end
%��ʼҪ����Ĳ���
TA_taper = zeros(N_TA_Lat,N_TA_Long,illumination_taper+1);
TA_real_taper = zeros(N_TA_Lat,N_TA_Long,illumination_taper+1);
TA_BG_taper = zeros(N_TA_Lat,N_TA_Long,illumination_taper+1);
Antenna_Pattern_taper = zeros(N_Lat,N_Long,illumination_taper+1);
HPBW_taper = zeros(1,illumination_taper+1);
SLL_taper = zeros(1,illumination_taper+1);
MBE_taper = zeros(1,illumination_taper+1);
sample_density_taper = zeros(1,illumination_taper+1);
MSE_real_taper = zeros(1,illumination_taper+1);
PSNR_real_taper = zeros(1,illumination_taper+1);
MSE_taper = zeros(1,illumination_taper+1);
PSNR_taper = zeros(1,illumination_taper+1);
MSE_BG_taper = zeros(1,illumination_taper+1);
PSNR_BG_taper = zeros(1,illumination_taper+1);
MSE_real_BG_taper = zeros(1,illumination_taper+1);
PSNR_real_BG_taper = zeros(1,illumination_taper+1);
index_min_taper = zeros(1,illumination_taper+1);
%����ϵͳ���߷���ͼ����ָ�����
for taper =  0:1: illumination_taper
[Antenna_Pattern,HPBW,SLL,MBE] = RA_antenna_pattern_2D(Ba,Coordinate_Long,Coordinate_Lat,angle_Long,angle_Lat,taper);
sample_density = HPBW/sample_width;%����������������ı�ֵ������ÿ��������Χ�ڵĲ������� 

%��ʼ���۲����������ͼ��TA  
TA=zeros(N_TA_Lat,N_TA_Long);
%%%%%%%%%%%%%%%%����ģ��۲�����TA%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Antenna_Pattern_Full = Antenna_Pattern_calc(AP_Coordinate_Long,AP_Coordinate_Lat,Ba,taper);

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
%%%%��ģ��۲�����TA����ϵͳ����
TA_real = add_image_noise(TA,bandwith,integral_time,noise_figure);
figure;imagesc(Coordinate_Long,Coordinate_Lat,TA_real,[T_min T_max]);axis equal;xlim([-angle_Long/2,angle_Long/2]);ylim([-angle_Lat/2,angle_Lat/2]);
xlabel('���ȷ���'); ylabel('γ�ȷ���');title(['�۲�����ͼ��TA@taper=',num2str(taper)]);colorbar;
%part3��end**************************************************************************************************************************************************

%% ********************************************************part4��BG��������*********************************************************************
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
    [MSE_array(i),~] = Mean_Square_Error(TB,TA_real_BG,MSE_offset,0);
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
%part4��end*****************************************************************************************************************************************


%������򾫶ȣ��ù۲�����TA������Tb��RMSE������
[MSE_real,PSNR_real] = Mean_Square_Error(TB,TA_real,MSE_offset,1);
[MSE,PSNR] = Mean_Square_Error(TB,TA,MSE_offset,0);
[MSE_BG,PSNR_BG] = Mean_Square_Error(TB,TA_BG,MSE_offset,1);
[MSE_real_BG,PSNR_real_BG] = Mean_Square_Error(TB,TA_real_BG,MSE_offset,0);

TA_taper(:,:,taper+1) = TA;
TA_real_taper(:,:,taper+1) = TA_real;
TA_BG_taper(:,:,taper+1) = TA_BG;
Antenna_Pattern_taper(:,:,taper+1) = Antenna_Pattern;
HPBW_taper(taper+1) = HPBW;
SLL_taper(taper+1)= SLL;
MBE_taper(taper+1) = MBE;
sample_density_taper(taper+1) = sample_density;
MSE_real_taper(taper+1) = MSE_real;
PSNR_real_taper(taper+1) = PSNR_real;
MSE_taper(taper+1) = MSE;
PSNR_taper(taper+1) = PSNR;
MSE_BG_taper(taper+1) = MSE_BG;
PSNR_BG_taper(taper+1) = PSNR_BG;
MSE_real_BG_taper(taper+1) = MSE_real_BG;
PSNR_real_BG_taper(taper+1) = PSNR_real_BG;
index_min_taper(taper+1) = index_min;
end


%% ********************************************************part5����ʾ����ָ�겢�洢��������*********************************************************************
%%%%%%%%%%��ʾ����õ�ϵͳָ��ͳ��񾫶�%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for taper =  0:1: illumination_taper
    TA = TA_taper(:,:,taper+1);
    TA_real = TA_real_taper(:,:,taper+1);
    TA_BG = TA_BG_taper(:,:,taper+1);
    Antenna_Pattern = Antenna_Pattern_taper(:,:,taper+1);
    HPBW = HPBW_taper(taper+1);
    SLL = SLL_taper(taper+1);
    MBE = MBE_taper(taper+1);
    sample_density = sample_density_taper(taper+1);
    MSE_real = MSE_real_taper(taper+1);
    PSNR_real = PSNR_real_taper(taper+1);
    MSE = MSE_taper(taper+1) ;
    PSNR =PSNR_taper(taper+1);
    MSE_BG =MSE_BG_taper(taper+1);
    PSNR_BG = PSNR_BG_taper(taper+1);
    MSE_real_BG =MSE_real_BG_taper(taper+1);
    PSNR_real_BG = PSNR_real_BG_taper(taper+1);
    index_min = index_min_taper(taper+1);
    
disp([num2str(freq/1e9),'GHzƵ�Σ�',num2str(antenna_diameter),'�׿ھ���ʵ�׾�������غɣ�@taper=',num2str(taper),')']);
disp(['3dB�������=',num2str(roundn(HPBW,-3)),'�b','������ֱ���=',num2str(roundn(HPBW/180*pi*orbit_height,-1)),'����']);
disp(['����ɨ�������=',num2str(roundn(sample_width,-3)),'�b',',����ɨ�������=',num2str(roundn(sample_width/180*pi*orbit_height,-1)),'����,�����ܶ�=',num2str(roundn(sample_density,-1))]);
disp(['��һ�����ƽ=',num2str(roundn(SLL,-1)),'dB']);
disp(['������Ч��MBE=',num2str(roundn(MBE,-1)),'%']);
disp(['ʵ�׾����������������=',num2str(roundn(NEDT,-2)),'K']);  
disp([num2str(antenna_diameter),'�׿ھ���ʵ�׾�������غ�����������=',num2str(roundn(MSE,-2)),'K����ֵ�����=',num2str(roundn(PSNR,-1)),'dB']);
disp([num2str(antenna_diameter),'�׿ھ���ʵ�׾�������غ�����BG�ؽ����=',num2str(roundn(MSE_BG,-2)),'K����ֵ�����=',num2str(roundn(PSNR_BG,-1)),'dB']);
disp([num2str(antenna_diameter),'�׿ھ���ʵ�׾�������غ�����������=',num2str(roundn(MSE_real,-2)),'K����ֵ�����=',num2str(roundn(PSNR_real,-1)),'dB']);
disp([num2str(antenna_diameter),'�׿ھ���ʵ�׾�������غ�����BG�ؽ����=',num2str(roundn(MSE_real_BG,-2)),'K@R=',num2str(roundn(index_min,-2)),',��ֵ�����=',num2str(roundn(PSNR_real_BG,-1)),'dB']);
disp('--------------------------------------------------')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if flag_save == 1
   tempstr=textscan(TB_filename,'%s', 'delimiter', '.');
   tempstr=tempstr{1,1};
   Scene = tempstr{size(tempstr,1)-1,1};
   FileName = sprintf('RA_%s_D%s_q%d_��%s_sample%s', Scene,num2str(round(antenna_diameter*1000)),taper,num2str(integral_time),num2str(roundn(sample_density,-1)));
   MatFileName = sprintf('%s.mat', FileName);
   save(['..\RA������\' MatFileName],'TA','TA_real','TA_BG','Antenna_Pattern','TA_real_BG','HPBW','SLL','MBE','MSE','MSE_BG','MSE_real','MSE_real_BG','index_min');    
end
end
%part5��end**************************************************************************************************************************************************

toc;