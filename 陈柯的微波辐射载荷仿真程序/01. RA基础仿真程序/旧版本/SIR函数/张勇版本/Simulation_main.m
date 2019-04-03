clear;
close all;
%%***************************���²��������ñ�־λ�͹������**********************************************************
flag_draw_TB = 0;                               %����ԭʼ����TB                     
flag_save = 1;                                  %���ݴ洢��־λ
RMSE_offset  = 0;                               %�۲�ͼ����ԭʼͼ��Ա�ʱͼ���Եȥ�����л�����
R = 6371;                                       %����뾶 unit:km
orbit_height = 35786;                           %����߶ȣ���ǰΪ����ֹ�����, unit:km
%*********************************************************************************************************

%% ********************************************************part1����������ͼ�񳡾��������ռ����������ֵ********************************************
%����ѡ��ģ�����³�����ȡ��ӦƵ�ε�ģ������ͼ��
file_path = 'F:\11.14_pattern_correct\wlf����\sandy����ͼ��';   %�ļ��洢Ŀ¼
%���㳡���ھ��Ⱥ�γ�ȷ���Ĺ۲�Ƿ�Χ
coordinate_filename = sprintf('%s\\coords.mat', file_path);
[angle_Long,angle_Lat] = Image_Long_Lat_calc(coordinate_filename,R,orbit_height);
scene_name = 'HurricanSandy_29_00';
% ����Ҫ���������ͨ�����
for freq_index = 7
	TB_filename = sprintf('%s_C%s_H.mat', scene_name,num2str(freq_index));
	TB_matfile = sprintf('%s\\%s', file_path,TB_filename);
    %load('F:\11.14_pattern_correct\wlf����\sandy����ͼ��\test');
 	load(TB_matfile);
	TB=(pic);
%     TB=pic(125:174,125:174);
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
	AP_Coordinate_Long = linspace(-angle_Long,angle_Long-d_Long,2*N_Long+1);
	AP_Coordinate_Lat = linspace(-angle_Lat,angle_Lat-d_Lat,2*N_Lat+1);
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
		case 14,freq= 88.2e9;   bandwith = 2000e6;   noise_figure= 7;  antenna_diameter = 5; 
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
    
        for illumination_taper = 0                                  %the illumination taper //by thesis of G.M.Skofronick
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
		sample_factor = 0.5;                                          %sample_factor����ȡ0.5��1��2�ȣ���Ϊ������Ҫ������ͼ����зֿ飬���ȡ������ֵ�Ļ������ܲ��ܽ��۲�ͼ�������ֿ�
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
		[Antenna_Pattern,HPBW,SLL,MBE] = RA_antenna_pattern_2D(Ba,Coordinate_Long,Coordinate_Lat,angle_Long,angle_Lat,illumination_taper,freq_index,0);
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
		%parpool open ;
		%pool=parpool('local',2); 
		% pool = startmatlabpool(2);
		% parfor sample_num_Lat=1:N_TA_Lat
		for sample_num_Lat=1:N_TA_Lat
			for sample_num_Long=1:N_TA_Long
				%�������߷���ͼƽ�����������½��о��������ģ��ÿ�����صĹ۲�����TA  
				row_current=row_TA_Lat(sample_num_Lat);
				col_current=col_TA_Long(sample_num_Long);
				Antenna_Pattern_current = Antenna_Pattern_Full(N_Lat+1-row_current+1:2*N_Lat+1-row_current,N_Long+1-col_current+1:2*N_Long+1-col_current);
				Antenna_Pattern_current = Antenna_Pattern_current/sum(sum(Antenna_Pattern_current));
				TA(sample_num_Lat,sample_num_Long)=sum(sum(TB.* Antenna_Pattern_current));        
			end
		end
		% closematlabpool;
		%if isempty(gcp('nocreate'))==0  
		%    delete(gcp('nocreate'));  
		%end 
		%parpool close ;
		%%%%��ģ��۲�����TA����ϵͳ����
		TA_real = add_image_noise(TA,bandwith,integral_time,noise_figure);
% 		figure;imagesc(Coordinate_Long,Coordinate_Lat,TA_real,[T_min T_max]);axis equal;xlim([-angle_Long/2,angle_Long/2]);ylim([-angle_Lat/2,angle_Lat/2]);
% 		xlabel('���ȷ���'); ylabel('γ�ȷ���');title(['�۲�����ͼ��TA@Ch.',num2str(freq_index)]);colorbar;
% 		saveas(gcf,['F:\11.14_pattern_correct\SIR������\�۲�����ͼ��TA@Ch',num2str(freq_index),'.png']);
		%part3��end**************************************************************************************************************************************************
		
		%% ********************************************************part4��SIR�ֿ鼰��������*********************************************************************
        tic;
        Block_num = 6;                                                                                              %���ݷֿ�����
        num = N_Lat/Block_num;                                                                                      %��x������y�������µ���
        AP_Coordinate_Long = linspace(-angle_Long/3,(angle_Long-d_Long)/3,2*num+1);                                 %��ķ���ͼ��Ӧ������    
        AP_Coordinate_Lat = linspace(-angle_Lat/3,(angle_Lat-d_Lat)/3,2*num+1);
        Antenna_Pattern_SIR =  Antenna_Pattern_calc(AP_Coordinate_Long,AP_Coordinate_Lat,Ba,illumination_taper);    %������ߴ�һ�µ����߷���ͼ
        %TA_SIR = split_deconv_SIR(TA,Block_num,N_Lat,N_Long,Antenna_Pattern_SIR,row_TA_Lat,col_TA_Long);            %��TA����SIR����
        %%%%%%%%%���Ƶ������������ܵ�����%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		N=30;
        RMSE_real_SIR=zeros(1,N);
        norm_RMSE_real_SIR=zeros(1,N);
        Corr_coefficient_nosie_SIR=zeros(1,N);
        for k=1:N
            x=sprintf('��%d�ε���',k);
            disp(x);
			if(k<2)
% 				TA_real_SIR1=TA_real;
                TA_real_SIR1=interpolation(TA_real,N_Lat,N_Long);
			else 
				TA_real_SIR1=TA_real_SIR;
			end
			TA_real_SIR= split_deconv_SIR3(sample_factor,k,TA_real,Block_num,N_Lat,N_Long,Antenna_Pattern_SIR,row_TA_Lat,col_TA_Long,TA_real_SIR1);
			[RMSE_real_SIR(k),norm_RMSE_real_SIR(k)] = Root_Mean_Square_Error(TB,TA_real_SIR,RMSE_offset,0);
            Corr_coefficient_nosie_SIR(k)=TB_correlation_coefficient(TB,TA_real_SIR,RMSE_offset);
            disp([num2str(k),'�ε���ʱԭʼͼ���봦����ͼ������ϵ��Ϊ',num2str(roundn(Corr_coefficient_nosie_SIR(k),-4)),'@�ŵ�ch',num2str(freq_index)]);
            disp([num2str(k),'�ε���ʱԭʼͼ���봦����ͼ���RMSE=',num2str(roundn(RMSE_real_SIR(k),-4)),'K��,��һ��RMSE=',num2str(roundn(norm_RMSE_real_SIR(k),-4))]);
            FileName=sprintf('TA_real_SIR%s�ε���@�ŵ�ch%s',num2str(k),num2str(freq_index));
            MatFileName = sprintf('%s.mat', FileName);
            save(['F:\11.14_pattern_correct\test3\' MatFileName],'TA_real_SIR'); 
            k=k+1;
        end
        toc;
        
        
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%��ѵĵ�������%%%%%%%%%%%%%%%%%%%%
%         N=1;
% 		while(1)
%             x=sprintf('��%d�ε���',N);
%             disp(x);
% 			if(norm_RMSE_real_SIR_1<norm_RMSE_real2)
% 				break;
% 			end
% 			if(N<2)
% 				norm_RMSE_real_SIR_1=1000;
% 				TA_real_SIR1=TA_real;
% 			else 
% 				norm_RMSE_real_SIR_1=norm_RMSE_real2;
% 				TA_real_SIR1=TA_real_SIR2;
% 			end
% 			TA_real_SIR2= split_deconv_SIR3(N,TA_real,Block_num,N_Lat,N_Long,Antenna_Pattern_SIR,row_TA_Lat,col_TA_Long,TA_real_SIR1);
% 			[RMSE_real2,norm_RMSE_real2] = Root_Mean_Square_Error(TB,TA_real_SIR2,RMSE_offset,0);
% 			N=N+1;
%         end
%         TA_real_SIR=TA_real_SIR2;
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%��ѵĵ�������%%%%%%%%%%%%%%%%%%%%
        
        
% 		figure;imagesc(Coordinate_Long,Coordinate_Lat,TA_SIR,[T_min T_max]);axis equal;xlim([-angle_Long/2,angle_Long/2]);ylim([-angle_Lat/2,angle_Lat/2]);
% 		xlabel('���ȷ���'); ylabel('γ�ȷ���');title(['����SIR�����������ͼ��@Ch.',num2str(freq_index)]);colorbar;
 		figure;imagesc(Coordinate_Long,Coordinate_Lat,TA_real_SIR,[T_min T_max]);axis equal;xlim([-angle_Long/2,angle_Long/2]);ylim([-angle_Lat/2,angle_Lat/2]);
		xlabel('���ȷ���'); ylabel('γ�ȷ���');title(['����SIR�����������ͼ��@Ch.',num2str(freq_index)]);colorbar;       
		%part3��end*****************************************************************************************************************************************
		
		
		%% ********************************************************part5����ʾ����ָ�겢�洢��������************************************************
		%������򾫶ȣ��ù۲�����TA������Tb��RMSE������
		[RMSE_real,norm_RMSE_real] = Root_Mean_Square_Error(TB,TA_real,RMSE_offset,0);
		[RMSE,norm_RMSE] = Root_Mean_Square_Error(TB,TA,RMSE_offset,0);
% 		[RMSE_SIR,norm_RMSE_SIR] = Root_Mean_Square_Error(TB,TA_SIR,RMSE_offset,0);
% 		[RMSE_real_SIR,norm_RMSE_real_SIR] = Root_Mean_Square_Error(TB,TA_real_SIR,RMSE_offset,0);
%         Corr_coefficient_nonosie_SIR = TB_correlation_coefficient(TB,TA_SIR,RMSE_offset);
%         Corr_coefficient_nosie_SIR = TB_correlation_coefficient(TB,TA_real_SIR,RMSE_offset);
        Corr_coefficient_norm = TB_correlation_coefficient(TB,TA_real,RMSE_offset);
		
		%%%%%%%%%%��ʾ����õ�ϵͳָ��ͳ��񾫶�%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		disp(['Ch.',num2str(freq_index),'--',num2str(freq/1e9),'GHzƵ�Σ�',num2str(antenna_diameter),'�׿ھ���ʵ�׾�������غɣ�@taper=',num2str(illumination_taper),')']);
		disp(['3dB�������=',num2str(roundn(HPBW,-3)),'�b','������ֱ���=',num2str(roundn(HPBW/180*pi*orbit_height,-1)),'����']);
		disp(['����ɨ�������=',num2str(roundn(sample_width/180*pi*orbit_height,-1)),'����,�����ܶ�=',num2str(roundn(sample_density,-1))]);
		disp(['��һ�����ƽ=',num2str(roundn(SLL,-1)),'dB']);
		disp(['������Ч��MBE=',num2str(roundn(MBE,-1)),'%']);
		disp(['ʵ�׾����������������=',num2str(roundn(NEDT,-2)),'K']);  
		disp([num2str(antenna_diameter),'�׿ھ���ʵ�׾�������غ��������RMSE=',num2str(roundn(RMSE,-2)),'K��,��һ��RMSE=',num2str(roundn(norm_RMSE,-3))]);
% 		disp([num2str(antenna_diameter),'�׿ھ���ʵ�׾�������غ�����SIR�ؽ�RMSE=',num2str(roundn(RMSE_SIR,-2)),'K��,��һ��RMSE=',num2str(roundn(norm_RMSE_SIR,-3))]);
		disp([num2str(antenna_diameter),'�׿ھ���ʵ�׾�������غ��������RMSE=',num2str(roundn(RMSE_real,-2)),'K��,��һ��RMSE=',num2str(roundn(norm_RMSE_real,-3))]);
% 		disp([num2str(antenna_diameter),'�׿ھ���ʵ�׾�������غ�����SIR�ؽ�RMSE=',num2str(roundn(RMSE_real_SIR,-2)),'K��,��һ��RMSE=',num2str(roundn(norm_RMSE_real_SIR,-3))]);
        disp([num2str(antenna_diameter),'�׿ھ���ʵ�׾�������غɷֱ��ʲ�������TA_real�볡������TB�����ϵ��=',num2str(roundn(Corr_coefficient_norm,-3)),'@�ŵ�ch',num2str(freq_index)]);
%         disp([num2str(antenna_diameter),'�׿ھ���ʵ�׾�������غɷֱ���������ǿ����TA_SIR�볡������TB�����ϵ��=',num2str(roundn(Corr_coefficient_nonosie_SIR,-3)),'@�ŵ�ch',num2str(freq_index)]);
%         disp([num2str(antenna_diameter),'�׿ھ���ʵ�׾�������غɷֱ���������ǿ����TA_real_SIR�볡������TB�����ϵ��=',num2str(roundn(Corr_coefficient_nosie_SIR,-3)),'@�ŵ�ch',num2str(freq_index)]);
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		if flag_save == 1
			FileName = sprintf('RA_%s_C%d_H_D%s_q%d_��%s_sample%s',scene_name,freq_index,num2str(round(antenna_diameter*1000)),illumination_taper,num2str(integral_time),num2str(roundn(sample_density,-1)));
			MatFileName = sprintf('%s.mat', FileName);
            save(['F:\11.14_pattern_correct\test3\' MatFileName],'N','TA','TA_real','Antenna_Pattern','HPBW','SLL','MBE','RMSE','RMSE_real','RMSE_real_SIR'); 
            save(['F:\11.14_pattern_correct\test3\' MatFileName],'Corr_coefficient_norm','Corr_coefficient_nosie_SIR','norm_RMSE','norm_RMSE_real','norm_RMSE_real_SIR','-append');
% 			save(['F:\11.14_pattern_correct\factor=0.5\��������Ϊ20\' MatFileName],'TA','TA_real','TA_SIR','TA_real_SIR','Antenna_Pattern','HPBW','SLL','MBE','RMSE','RMSE_SIR','RMSE_real','RMSE_real_SIR'); 
% 			save(['F:\11.14_pattern_correct\factor=0.5\��������Ϊ20\' MatFileName],'Corr_coefficient_norm','Corr_coefficient_nonosie_SIR','Corr_coefficient_nosie_SIR','norm_RMSE','norm_RMSE_SIR','norm_RMSE_real','norm_RMSE_real_SIR','-append'); 
		end
	end
%part5��end**************************************************************************************************************************************************
end
