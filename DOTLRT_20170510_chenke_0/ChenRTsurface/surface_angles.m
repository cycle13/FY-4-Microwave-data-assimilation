%% ���ڰ���Ҫ����angles.mat�ļ����ṩ����������
%%% angles(1��num_surf_angles)       ��˹-���õ������ʽ�Ĳ�ֵ��
%%% num_surf_angles                  ��˹-���õ������ʽ�Ĳ�ֵ����Ŀ

%%% content
clc
clear
givepath
angles=[0:10:90];
num_surf_angles=size(angles,2);

save([mainpath,subpath,'angles.mat'],'angles','num_surf_angles');