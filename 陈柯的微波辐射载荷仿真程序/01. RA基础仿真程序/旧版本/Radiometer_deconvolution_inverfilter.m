%��������Ƶ�����˲�����ʵ�׾�����ƹ۲�ͼ����з������ԭ
%by �¿� 2015.11.10
clear
% close all
tic;

%%***************************���²��������ñ�־λ***********************************************************
flag_draw_TB = 0;                 %����ԭʼ����TB 
flag_draw_TA = 0;                 %�����۲�����TA
flag_noise = 0;                   %�Ƿ����۲������ı�־λ
flag_antenna_cal = 0;             %�������߷���ͼ����Ƶ�׵ı�־λ
flag_TA_cal = 0;                  %����۲�����Ƶ�׵ı�־λ
%*********************************************************************************************************
freq =36.5e9;                                       %instrment center frequency��unit:Hz
c=3e8;                                              %speed of light unit m/s
wavelength=c/freq;                                  %wave length unit:m
antenna_diameter=2;                                 %antenna diameter��refer to GEM, 2m Cassegrain��
Ba = pi*antenna_diameter/wavelength;  
x=0; 
%��������taper    
R = 6371;                                           %earth radius unit:km
orbit_height = 35786;                               %geostationary orbit heigth, unit:km

bandwith = 400*10^6;                                % radiometer receiver band width, unit:Hz
integral_time = 20*10^(-3);                          % radiometer integration time, unit:S
noise_figure= 5;
%%**********************��ȡ����ͼ�����ݲ���ֵ����************************************
%��ȡԭʼ�߷ֱ�������ͼ��
TBmat_path = 'D:\��ǰ�Ĺ���\2015.03.21 ��������ͬ����GEO�����о�\������������\2012.10.29 Hurricansandy1500-NAM'; 
matfile = sprintf('%s\\HurricanSandy_36_5_H.mat', TBmat_path);
load(matfile);
TB=pic;
T_max=max(max(TB));
T_min=min(min(TB));
[N_y_1,N_x_1]=size(pic);
if flag_draw_TB == 1 %��ʾԭʼ����ͼ��
   figure() ; imagesc(flipud(TB),[T_min T_max]);axis equal; xlim([1,N_x_1]);ylim([1,N_y_1]);colorbar('eastoutside');
end
%��ȡ���߷���ͼ�����ĵͷֱ�������ͼ��
TAmat_path = 'D:\���ʼ�����ϵͳ�׶�����2012.11.29�����¿��޸İ汾\ʵ�׾�����Ʒ���-�¿�\���ݷ���'; 
matfile = sprintf('%s\\RA_HurricanSandy_36_5_H_TA_q0_2_425_noiseless.mat', TAmat_path);
load(matfile);
%���²��ִ��븺������������ݷ���Ʋ���������ͼ�����ϵͳ����
TA_noiseless=TA;
if flag_noise == 1
   [TA,Noise]=add_image_noise(TA,bandwith,integral_time,noise_figure);
   Noise = interpolation(Noise,N_y_1,N_x_1);
end 
%���²��ִ��븺���ֵ���������ͷֱ���ͼ���Ϊԭʼ�߷ֱ���ͼ�񣬱��ֺ�ԭʼͼ������һ��
TA = interpolation(TA,N_y_1,N_x_1);
if flag_draw_TA == 1
   figure();imagesc(flipud(TA),[T_min T_max]);axis equal; xlim([1,N_x_1]);ylim([1,N_y_1]);colorbar('eastoutside');
end
%%************************************************************************

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%����ͼ���ھ��Ⱥ�γ�ȷ���ĽǶȷ�Χ%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%����ͼ���ھ��Ⱥ�γ�ȷ���ĽǶȷ�Χ
WRFfile_path = 'D:\��ǰ�Ĺ���\2015.03.21 ��������ͬ����GEO�����о�\WRF������ļ�'; 
WRF_Output_filename = sprintf('%s\\wrfout_d01.nc', WRFfile_path);
[angle_Longitude,angle_Latitude] = Image_Long_Lat_cal(WRF_Output_filename,R,orbit_height);
Fov_scope = [-angle_Latitude/2 angle_Latitude/2;-angle_Longitude/2 angle_Longitude/2];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

d_f_x = 1/(angle_Longitude/180*pi);  %���ȷ���Ŀռ�Ƶ�����񣬵�λ��Hz/rad
d_f_y = 1/(angle_Latitude/180*pi);   %γ�ȷ���Ŀռ�Ƶ�����񣬵�λ��Hz/rad
d_radian_x = (angle_Longitude/180*pi)/N_x_1;  %���ȷ���Ŀռ����񣬵�λ��rad
d_radian_y = (angle_Latitude/180*pi)/N_y_1;   %γ�ȷ���Ŀռ����񣬵�λ��rad
radian_x = linspace(Fov_scope(2,1)/180*pi,Fov_scope(2,2)/180*pi,N_x_1).';   %���ȿռ����꣬��λ��rad
radian_y = linspace(Fov_scope(1,1)/180*pi,Fov_scope(1,2)/180*pi,N_y_1).';    %γ�ȿռ����꣬��λ��rad
[cordinate_x,cordinate_y] = meshgrid(radian_x,radian_y);    %�ռ��ά���꣬DFT������Ҫ�õ�
f_x = -round((N_x_1-1)/2)*d_f_x:d_f_x:round((N_x_1-1)/2)*d_f_x;
f_y = round((N_y_1-1)/2)*d_f_y:-d_f_y:-round((N_y_1-1)/2)*d_f_y;
[cordinate_f_x,cordinate_f_y] = meshgrid(f_x,f_y);    %�ռ��ά���꣬DFT������Ҫ�õ�

load('deconv.mat');    %��ȡ��ǰ�洢������ͼ������߷���ͼ��Ƶ��

if flag_antenna_cal == 1; 
   Antenna_G = circular_antenna_pattern_2D(Fov_scope,N_y_1,N_x_1,Ba,x); %�������߷���ͼ
   figure() ; imagesc(Antenna_G);axis equal; xlim([1,N_x_1]);ylim([1,N_y_1]);colorbar('eastoutside'); 

   f_G = spatial_DFT_2D(Antenna_G,f_x,f_y,d_radian_x,d_radian_y,cordinate_x,cordinate_y);%�������߷���ͼ�ĸ���Ҷ�任��
   f_G=f_G/max(max(f_G)); 
end
if flag_TA_cal == 1
   f_TA = spatial_DFT_2D(TA,f_x,f_y,d_radian_x,d_radian_y,cordinate_x,cordinate_y);%����������ͼ��ĸ���Ҷ�任��
end
if flag_noise == 1
   f_N = spatial_DFT_2D(Noise,f_x,f_y,d_radian_x,d_radian_y,cordinate_x,cordinate_y);%���������ĸ���Ҷ�任��
end
% save deconv.mat Antenna_G f_G f_TA

I = ones(N_y_1,N_x_1);
W = I./(I+I./(10*real(f_G)));%����Ȩ����
% W = I./(I+(abs(f_N).^2)./(abs(f_TA).^2));
% W = I;

% Antenna_Gs = spatial_IDFT_2D(W,radian_x,radian_y,d_f_x,d_f_y,cordinate_f_x,cordinate_f_y);
% figure() ; imagesc(Antenna_Gs);axis equal; xlim([1,N_x_1]);ylim([1,N_y_1]);colorbar('eastoutside'); 
% figure() ; mesh(Antenna_Gs);
% Antenna_Gs = Antenna_Gs/max(max(Antenna_Gs));
% figure() ; plot(Antenna_Gs(round(N_y_1/2),:));


f_TB_deconv = W.*f_TA./f_G;  %���˲����㷴���֮��ͼ�����
TB_deconv = spatial_IDFT_2D(f_TB_deconv,radian_x,radian_y,d_f_x,d_f_y,cordinate_f_x,cordinate_f_y);%���׽����渵��Ҷ�任�õ������ͼ��
figure() ; imagesc(flipud(TB_deconv),[T_min T_max]);axis equal; xlim([1,N_x_1]);ylim([1,N_y_1]);colorbar('eastoutside');

offset = 15;
MSE = Mean_Square_Error(TB,TB_deconv,offset,1)%���㷴���֮��ͼ����ԭʼ����ͼ���RMSE
toc;
