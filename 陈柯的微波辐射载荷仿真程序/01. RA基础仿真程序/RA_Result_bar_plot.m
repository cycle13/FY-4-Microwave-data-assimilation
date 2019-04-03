clear;
close all;

TAmat_path = 'E:\�ٶ���ͬ����\�¿µ�΢�������غɷ������\RA������';
scene_name = 'HurricanRainbow_03_06';
scenario = '̨��ʺ�';
antenna_diameter = 2400;
integral_time = 0.04; 
sample_interval = 12;
%��ȡWienerFilter�㷨������
Resolution_Enhancement_name = 'WienerFilter';
TA_filename = sprintf('RA_%s_D%d_��%s_sample%d_%s', scene_name,antenna_diameter,num2str(integral_time),sample_interval,Resolution_Enhancement_name); %����ͼ���ļ���
TAMatFileName = sprintf('%s_result_list.mat', TA_filename);   
TAMatFileName = sprintf('%s\\%s',TAmat_path,TAMatFileName);
load(TAMatFileName);
RMSE_RE_list_1 = RMSE_RE_list;
Corr_coefficient_RE_list_1 = Corr_coefficient_RE_list;
%��ȡBG�㷨������
Resolution_Enhancement_name = 'BG';
TA_filename = sprintf('RA_%s_D%d_��%s_sample%d_%s', scene_name,antenna_diameter,num2str(integral_time),sample_interval,Resolution_Enhancement_name); %����ͼ���ļ���
TAMatFileName = sprintf('%s_result_list.mat', TA_filename);   
TAMatFileName = sprintf('%s\\%s',TAmat_path,TAMatFileName);
load(TAMatFileName);
RMSE_RE_list_2 = RMSE_RE_list;
Corr_coefficient_RE_list_2 = Corr_coefficient_RE_list;

channel_start_index =1;
channel_end_index =37;
Corr_coefficient_min = min(min(Corr_coefficient_list))-0.01;
color=[1 0.5 0;0.2 0.8 0];
color2=[0 0.7 1;1 0.5 0;0.2 0.8 0];
BarWidth = 0.7;
i=channel_start_index:1:channel_end_index;
%%��ͬ��������׶�ȹ۲�
figure;
subplot(2,1,1);
set(gcf,'color','white');
h1 = bar([RMSE_list(i,1),RMSE_list(i,2)],BarWidth);
set(h1(1),'FaceColor',color(1,:))
set(h1(2),'FaceColor',color(2,:))
set(gca,'xtick',1:1:37)
xlabel('Ƶ��ͨ��');
ylabel('RMSE(K)');
title(['��ͬ��������׶�ȹ۲�����RMSE�Ա�----',scenario]);
legend('taper=0','taper=1');
subplot(2,1,2);
set(gcf,'color','white');
h2=bar([Corr_coefficient_list(i,1),Corr_coefficient_list(i,2)],BarWidth);
set(h2(1),'FaceColor',color(1,:))
set(h2(2),'FaceColor',color(2,:))
set(gca,'xtick',1:1:37)
xlabel('Ƶ��ͨ��');
ylabel('���ϵ��');
ylim([Corr_coefficient_min,1]);
title(['��ͬ��������׶�ȹ۲��������ϵ���Ա�----',scenario]);
legend('taper=0','taper=1');


%%taper = 0ʱͼ����ǿЧ��
figure;
BarWidth = 0.7;

i=channel_start_index:1:channel_end_index;
subplot(2,1,1);
set(gcf,'color','white');
h1 = bar([RMSE_list(i,1),RMSE_RE_list_1(i,1),RMSE_RE_list_2(i,1)],BarWidth);
set(h1(1),'FaceColor',color2(1,:))
set(h1(2),'FaceColor',color2(2,:))
set(h1(3),'FaceColor',color2(3,:))
set(gca,'xtick',1:1:37)
xlabel('Ƶ��ͨ��');
ylabel('RMSE(K)');
title(['taper=0ʱ�ֱ�����ǿ��۲�����RMSE�Ա�----',scenario]);
legend('ԭʼ�۲�','WienerFilter��ǿ','BG��ǿ');
subplot(2,1,2);
set(gcf,'color','white');
h2 = bar([Corr_coefficient_list(i,1),Corr_coefficient_RE_list_1(i,1),Corr_coefficient_RE_list_2(i,1)],BarWidth);
set(h2(1),'FaceColor',color2(1,:))
set(h2(2),'FaceColor',color2(2,:))
set(h2(3),'FaceColor',color2(3,:))
set(gca,'xtick',1:1:37)
xlabel('Ƶ��ͨ��');
ylabel('���ϵ��');
ylim([Corr_coefficient_min,1]);
title(['taper=0ʱ�ֱ�����ǿ��۲�����RMSE�Ա�----',scenario]);
legend('ԭʼ�۲�','WienerFilter��ǿ','BG��ǿ');

%%taper = 1ʱͼ����ǿЧ��
figure;
BarWidth = 0.7;

i=channel_start_index:1:channel_end_index;
subplot(2,1,1);
set(gcf,'color','white');
h1 = bar([RMSE_list(i,2),RMSE_RE_list_1(i,2),RMSE_RE_list_2(i,2)],BarWidth);
set(h1(1),'FaceColor',color2(1,:))
set(h1(2),'FaceColor',color2(2,:))
set(h1(3),'FaceColor',color2(3,:))
set(gca,'xtick',1:1:37)
xlabel('Ƶ��ͨ��');
ylabel('RMSE(K)');
title(['taper=1ʱ�ֱ�����ǿ��۲�����RMSE�Ա�----',scenario]);
legend('ԭʼ�۲�','WienerFilter��ǿ','BG��ǿ');
subplot(2,1,2);
set(gcf,'color','white');
h2 = bar([Corr_coefficient_list(i,2),Corr_coefficient_RE_list_1(i,2),Corr_coefficient_RE_list_2(i,2)],BarWidth);
set(h2(1),'FaceColor',color2(1,:))
set(h2(2),'FaceColor',color2(2,:))
set(h2(3),'FaceColor',color2(3,:))
set(gca,'xtick',1:1:37)
xlabel('Ƶ��ͨ��');
ylabel('���ϵ��');
ylim([Corr_coefficient_min,1]);
title(['taper=1ʱ�ֱ�����ǿ��۲�����RMSE�Ա�----',scenario]);
legend('ԭʼ�۲�','WienerFilter��ǿ','BG��ǿ');

