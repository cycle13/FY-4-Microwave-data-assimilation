%������ʵ�ֶ�ά����ͼ���ۺϿ׾��������ݷ��� 
%������֧�ֶ�������������·���
%�汾�� Ver1.0 
%��Ȩ���� by �¿� ���пƼ���ѧ ����ѧԺ 2016.10.25

tic;
close all
clear


%���澲̬��������
RMSE_offset = 20;  %�۲�ͼ����ԭʼͼ��Ա�ʱͼ���Եȥ�����л�����
R = 6371;                     %����뾶 unit:km
orbit_height = 35786;         %����߶ȣ���ǰΪ����ֹ�����, unit:km
flag_Resolution_Enhancement  = 1;               %ʹ�÷ֱ�����ǿ�����־λ
Resolution_Enhancement_name = 'BG';             %��ѡ�㷨��BG��WienerFilter��SIR��ODC
flag_draw_TB = 0;
flag_draw_TA = 0;
flag_draw_TA_Enhancement = 1;
flag_save = 0;


%% ********************************************************part1����������ͼ�񳡾��������ռ����������ֵ****************************************************
   %����ͼ���ļ�Ŀ¼
   TBmat_path = 'D:\��ǰ�Ĺ���\2015.03.21 ��������ͬ����GEO�����о�\01. ������������\2016.09.30 쫷�ʺ�rainbow-GFS-20151002\����ͼ��'; 
   %���㳡���ھ��Ⱥ�γ�ȷ���Ĺ۲�Ƿ�Χ,ȷ���ӳ�
   coordinate_filename = sprintf('%s\\coords.mat', TBmat_path);
   [angle_Long,angle_Lat] = Image_Long_Lat_calc(coordinate_filename,R,orbit_height);
   scene_name = 'HurricanRainbow_03_06';
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
   %%%%%%%%%%�����ⲿ����ͼ��%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
   %����ѡ��ģ�����³�����ȡ��ӦƵ�ε�ģ������ͼ��
   TB_filename = sprintf('%s_C%s_H.mat', scene_name,num2str(freq_index));
   TB_matfile = sprintf('%s\\%s', TBmat_path,TB_filename);
   load(TB_matfile);
   TB=(pic);
   T_max=max(max(TB));
   T_min=min(min(TB));
   [N_Lat,N_Long] = size(TB);
   
   switch freq_index   %����Ƶ��,��λ:Hz  %����, ��λ:Hz     %����ϵ��,��λ:dB   %���߿ھ�����λ����
        case 1, T_min=220;
        case 2, T_min=235;
        case 3, T_min=235;
        case 4, T_min=240;
        case 5, T_min=239;
        case 6, T_min=231;
        case 7, T_min=220;
        case 14,T_min = 210;
        case 18, T_min=230;
        case 19, T_min=240;
        case 20, T_min=225;
        case 21, T_min=225;
        case 22, T_min=225;
        case 23, T_min=200;
        case 24, T_min=215;
        case 25, T_min =225;
        case 26, T_min=235;
        case 27, T_min=240;
        case 28, T_min=237;
        case 29, T_min=212;
        case 30, T_min=227;
        case 31, T_min =230; 
        case 32, T_min=220;
        case 33, T_min=205;           
   end
   
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
   
   
   TAmat_path = 'E:\�ٶ���ͬ����\�¿µ�΢�������غɷ������\RA������';
   if freq_index<15
   antenna_diameter = 5000;
   else 
   antenna_diameter = 2400;    
   end
   sample_interval = 12;
   integral_time = 0.04; 
   illumination_taper_num = 2;
   
   %���ò�ͬtaperֵʱ��Ҫ�洢�ı���
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
   
   
 for illumination_taper = 0:illumination_taper_num-1
   
   TA_filename = sprintf('RA_%s_C%d_H_D%d_q%d_��%s_sample%d', scene_name,freq_index,antenna_diameter,illumination_taper,num2str(integral_time),sample_interval); %����ͼ���ļ���
   if flag_Resolution_Enhancement == 1;
       TA_filename = sprintf('%s_%s', TA_filename,Resolution_Enhancement_name);
   end
    TA_filename = sprintf('%s.mat', TA_filename);
    TAMatFileName = sprintf('%s\\%s',TAmat_path,TA_filename);
    load(TAMatFileName);
    %�����۲�����TA      
    if flag_draw_TA == 1
    figure;imagesc(Coordinate_Long,Coordinate_Lat,TA,[T_min T_max]);axis equal;xlim([-angle_Long/2,angle_Long/2]);ylim([-angle_Lat/2,angle_Lat/2]);
    xlabel('���ȷ���'); ylabel('γ�ȷ���');title(['�۲�����ͼ��TA@Ch.',num2str(freq_index),'@taper=',num2str(illumination_taper)]);colorbar;
    end
    %�����ֱ�����ǿ�����Ĺ۲�����TA_RE 
    if flag_Resolution_Enhancement  == 1;
       if flag_draw_TA_Enhancement == 1
        figure;imagesc(Coordinate_Long,Coordinate_Lat,TA_RE,[T_min T_max]);axis equal;xlim([-angle_Long/2,angle_Long/2]);ylim([-angle_Lat/2,angle_Lat/2]);
        xlabel('���ȷ���'); ylabel('γ�ȷ���');title([Resolution_Enhancement_name,'��ǿ����ͼ��TA@Ch.',num2str(freq_index),'@taper=',num2str(illumination_taper)]);colorbar;
       end
    end
    
   %��ÿ��channel����taperֵ�������б�ֵ
   RMSE_taper(illumination_taper+1) = RMSE;
   Corr_coefficient_taper(illumination_taper+1) =Corr_coefficient;
   Corr_coefficient_RE_taper(illumination_taper+1) =Corr_coefficient_RE;
   NEDT_taper(illumination_taper+1) = NEDT;  
   HPBW_taper(illumination_taper+1) = HPBW;
   ground_resolution_taper(illumination_taper+1) = ground_resolution;
   SLL_taper(illumination_taper+1) = SLL;
   MBE_taper(illumination_taper+1) = MBE;
   if  flag_Resolution_Enhancement == 1
   RMSE_RE_taper(illumination_taper+1) = RMSE_RE;
   Corr_coefficient_RE_taper(illumination_taper+1) =Corr_coefficient_RE;
   factor_opt_taper(illumination_taper+1)=factor_opt;
   end 
 end
   %������channel�������б�ֵ
   RMSE_list = [RMSE_list;RMSE_taper];
   Corr_coefficient_list =[Corr_coefficient_list;Corr_coefficient_taper];
   NEDT_list = [NEDT_list;NEDT_taper];  
   HPBW_list = [HPBW_list;HPBW_taper];
   ground_resolution_list = [ground_resolution_list;ground_resolution_taper];
   SLL_list = [SLL_list;SLL_taper];
   MBE_list =[MBE_list;MBE_taper];
   if  flag_Resolution_Enhancement == 1
   RMSE_RE_list = [RMSE_RE_list;RMSE_RE_taper];
   Corr_coefficient_RE_list =[Corr_coefficient_RE_list;Corr_coefficient_RE_taper];
   factor_opt_list=[factor_opt_list;factor_opt_taper];
   end 
 end
  


%part1��end****************************************************************************************************************************************************************

disp(['ʵ�׾�������غɶ�����������',scene_name,'@',Resolution_Enhancement_name,'�ֱ�����ǿ�㷨�����','������']);
disp('taper=0, taper=1')
disp('----------------------------------------------')
disp('�۲�RMSE');
disp(roundn(RMSE_list,-2));
if  flag_Resolution_Enhancement == 1
disp('----------------------------------------------')
disp('�ֱ�����ǿ������RMSE');
disp(roundn(RMSE_RE_list,-2));
end
disp('----------------------------------------------')
disp(['�۲����ϵ��']);
disp(roundn(Corr_coefficient_list,-3));
if  flag_Resolution_Enhancement == 1
disp('----------------------------------------------')
disp(['�ֱ�����ǿ���������ϵ��']);
disp(roundn(Corr_coefficient_RE_list,-3));
disp('----------------------------------------------')
disp(['�ֱ�����ǿ���Ų���ֵfactor']);
disp(factor_opt_list);
end
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
   SaveFileName = sprintf('RA_%s_D%d_��%s_sample%d',scene_name,antenna_diameter,num2str(integral_time),sample_interval);
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