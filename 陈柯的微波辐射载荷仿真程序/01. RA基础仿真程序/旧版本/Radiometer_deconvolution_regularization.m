%�����������򻯷���ʵ�׾�����ƹ۲�ͼ����з������ԭ
%by �¿� 2015.11.10
clear;
close all;
tic;

%%***************************���²��������ñ�־λ***********************************************************
flag_draw_TB = 1;                 %����ԭʼ����TB 
flag_draw_deconv_pattern = 1;     %�����������ĵ�Ч����ͼ
flag_opt = 0;                     %�Ƿ�������Ż����򻯲�������
flag_save = 0;                    %���ݴ洢��־λ

%*********************************************************************************************************

%%***************************���²���������ʵ�׾�������غɲ���*********************************************
freq =50.3e9;                                      %instrment center frequency��unit:Hz
freq_highest=425e9;
c=3e8;                                              %speed of light unit m/s
wavelength=c/freq;                                  %wave length unit:m
wavelength_highest=c/freq_highest;  

R = 6371;                                           %earth radius unit:km
orbit_height = 35786;                               %geostationary orbit heigth, unit:km

antenna_diameter=2;                                 %antenna diameter��refer to GEM, 2m Cassegrain��
q=0;                                                % the illumination taper //by thesis of G.M.Skofronick
beam_width=1.02*wavelength/antenna_diameter*180/pi;  %antenna 3dB beam width
beam_width_highest=1.02*wavelength_highest/antenna_diameter*180/pi;
sample_density=2;                                  % sample number @ each beam width
Ba = pi*antenna_diameter/wavelength; 

bandwith = 180*10^6;                                % radiometer receiver band width, unit:Hz
noise_figure= 5;
integral_time = 20*10^(-3);                          % radiometer integration time, unit:S
%*********************************************************************************************************

%%***************************���²����ǵ��뱻�������ͼ����Ϣ*********************************************
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%����ͼ���ھ��Ⱥ�γ�ȷ���ĽǶ��춥�Ƿ�Χ
WRFfile_path = 'D:\��ǰ�Ĺ���\2015.03.21 ��������ͬ����GEO�����о�\WRF������ļ�';   %Wrfout�ļ��洢Ŀ¼ 
WRF_Output_filename = sprintf('%s\\wrfout_d01.nc', WRFfile_path);
[angle_Longitude,angle_Latitude] = Image_Long_Lat_cal(WRF_Output_filename,R,orbit_height);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%��ȡԭʼ����ͼ��
TBmat_path = 'D:\��ǰ�Ĺ���\2015.03.21 ��������ͬ����GEO�����о�\������������\2012.10.29 Hurricansandy1500-NAM'; 
TBmatfile = sprintf('%s\\HurricanSandy_50_3_H_LGW.mat', TBmat_path);
load(TBmatfile);
%%��ȡ�۲�����ͼ�񣬼�������������ͼ�񣬴�ͼ�����������ġ�
TAmat_path = 'D:\���ʼ�����ϵͳ�׶�����2012.11.29�����¿��޸İ汾\ʵ�׾�����Ʒ���-�¿�\������'; 
TAmatfile = sprintf('%s\\RA_HurricanSandy_50_3_H_LGW_TA_q0_2_425_noiseless',TAmat_path);
load(TAmatfile);
TA=add_image_noise(flipud(TA),bandwith,integral_time,noise_figure);%��ͼ�����ӷ���ƹ۲�����

TB=flipud(pic);
T_max=max(max(pic));
T_min=min(min(pic));
[row_pix,col_pix] = size(TB);
num_pix = row_pix*col_pix;   %ԭʼͼ�����ص���
if  flag_draw_TB == 1;  %����ԭʼ����ͼ��
    figure() ; imagesc(TB,[T_min T_max]);axis equal; xlim([1,col_pix]);ylim([1,row_pix]);colorbar('eastoutside');
%     figure() ; imagesc(TA,[T_min T_max]);axis equal;colorbar('eastoutside');
end
%*********************************************************************************************************

%**********************���²��ֽ��з��������**************************************************************
d_Longitude = angle_Longitude/col_pix; %ԭʼ����ͼ����Ƕ�
d_Latitude = angle_Latitude/row_pix;
d_sample_Latitude = max(beam_width_highest/sample_density,d_Latitude); %�۲�������Ƕ�
d_sample_Longitude = max(beam_width_highest/sample_density,d_Longitude);
num_Latitude = min(round(angle_Latitude/d_sample_Latitude)+1,row_pix);     % sample pixels number measured by radiometer in latitude dirction  
num_Longitude = min(round(angle_Longitude/d_sample_Longitude)+1,col_pix);    % sample pixels number measured by radiometer in longitude dirction  

PSF_Long = PSF_generate(angle_Longitude,col_pix,num_Longitude,d_sample_Longitude,Ba,q); %���㾭�ȷ���ĵ���Ӧ����
PSF_Lat = PSF_generate(angle_Latitude,row_pix,num_Latitude,d_sample_Latitude,Ba,q);     %����γ�ȷ���ĵ���Ӧ����
 
k_Long = 0.058;  %���ȷ�������򻯲���
k_Lat = 0.06;    %γ�ȷ�������򻯲���

%�������Ż������򻯲���
if flag_opt == 1;  
   d_k_Long=0.001;  %��������
   d_k_Lat=0.01;
   k_Long_index = 8000*d_k_Long:d_k_Long:8100*d_k_Long;
   k_Lat_index = 800*d_k_Lat:d_k_Lat:810*d_k_Lat;
   num_k_Long = length(k_Long_index);  
   num_k_Lat = length(k_Lat_index);
   MSE_index = zeros(num_k_Long,num_k_Lat);
   matlabpool open ;
   parfor m=1:num_k_Long
       for n=1:num_k_Lat
           k_Long = k_Long_index(m);
           k_Lat = k_Lat_index(n);      
           TB_deconv = deconvolution(TA,PSF_Long,PSF_Lat,k_Long,k_Lat);
           MSE_index(m,n) = Mean_Square_Error(TB,TB_deconv,0,0);            
       end
   end
   matlabpool close ;
   [k_Long_opt,k_Lat_opt] = find(MSE_index==min(min(MSE_index)));%�ҳ���Χ��RMSE�Ĺ�ֵ����Ϊ���Ż������򻯲���
   k_Long = k_Long_index(k_Long_opt)
   k_Lat = k_Lat_index(k_Lat_opt)
end

[TB_deconv,Antenna_Gs] = deconvolution(TA,PSF_Long,PSF_Lat,k_Long,k_Lat); %���������
% figure() ; imagesc(TA,[T_min T_max]);axis equal; xlim([1,num_Longitude]);ylim([1,num_Latitude]);colorbar('eastoutside');
figure() ; imagesc(TB_deconv,[T_min T_max]); axis equal; xlim([1,col_pix]);ylim([1,row_pix]);colorbar('eastoutside');
MSE_deconv = Mean_Square_Error(TB,TB_deconv,0,1)  %��������ͼ����ԭʼͼ���RMSE
MSE_conv = Mean_Square_Error(TB,TA,0,0)
pecent = (MSE_conv-MSE_deconv)/MSE_conv

if flag_draw_deconv_pattern == 1  %���������������߷���ͼ��������3dB������ȼ���ֱ���
   N_ant = 8001;
   theta_x = linspace(-angle_Latitude/2,angle_Latitude/2,row_pix) ;
   theta = linspace(-angle_Latitude/2,angle_Latitude/2,N_ant) ;
   Antenna_Gsi=interp1(theta_x,Antenna_Gs,theta,'spline');   %�ѷ����������߷���ͼ��ֵ�ɵ�������  
   [HPBW,k_3dB] = HPBW_of_AP(Antenna_Gsi,theta);     %���㷴������ӵ�3dB�������
   ground_resolution = HPBW/180*pi*orbit_height    
   mark_3dB = round(N_ant-1)/2+abs(round(N_ant/2)-k_3dB); %3dB���λ��
   figure;hPlot=plot(theta,Antenna_Gsi,'LineWidth',2); makedatatip(hPlot,mark_3dB);xlim([theta(1),theta(N_ant)]);xlabel('\theta');title('��һ����������߷���ͼ');grid on;   
end
%*********************************************************************************************************


if flag_save==1  %�洢�����֮������ݽ��
   dirstr=textscan(matfile,'%s', 'delimiter', '\\');
   dirstr=dirstr{1,1};
   filename_str = dirstr(size(dirstr,1),1); 
   filename_str = filename_str{1,1};
   tempstr = textscan(filename_str,'%s', 'delimiter', '.');
   tempstr = tempstr{1,1};
   sourcefilename = tempstr{1,1};

   FileName = sprintf('RA_%s_TB_deconv_q%d_%d_%d', sourcefilename,q,antenna_diameter,round(freq_highest/1e9));
   MatFileName = sprintf('%s.mat', FileName);
   save (MatFileName, 'TB_deconv') 
end

toc;














