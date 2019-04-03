function write_TA_obs_Ruralizate_atms( time,num_lat,num_lon,obs_point,chan,input_dir,output_dir,scene_name )
%edit by hongpengfei
%2018.11.29

tb=zeros(obs_point,chan);
for i=1:chan
    TA_dir=sprintf('%s/%s',input_dir,time);
    TA_file=sprintf('%s/Typhoon%s_%s_%s_%s_C%s_H.mat',TA_dir,scene_name,time(7:8),time(9:10),time(11:12),num2str(i));
    if(exist(TA_file,'file')==2)
        load(TA_file);
        TA=interpolation(TA,num_lat,num_lon);
        tb(:,i)=reshape(TA,obs_point,1);
    else
        tb(:,i)=0;
    end
end

%�����ļ���
obs_dir=sprintf('%s/%s',output_dir,time);
mkdir(obs_dir);

%����TB
%���ļ�
Tb_file=sprintf('%s/tb.txt',obs_dir);
fid=fopen(Tb_file,'w');   
%ѭ��д������
for i=1:obs_point
    for j=1:chan
        fprintf(fid,'%8.2f\t',tb(i,j));   
    end
    fprintf(fid,'\n');
end
fclose(fid);

%����ʱ��
%���ļ�
time_file=sprintf('%s/time.txt',obs_dir);
fid=fopen(time_file,'w');
%д������
fprintf(fid,'%s\t%s\t%s\t%s\t%s',time(1:4),time(5:6),...
        time(7:8),(time(9:10)),time(11:12));
fclose(fid);

% %��������Ϣcloud
% %���ļ�
% Tb_file=sprintf('%s\\cloud.txt',obs_dir);
% fid=fopen(Tb_file,'w');   
% %ѭ��д������
% for i=1:obs_point
%     for j=1:chan
%         fprintf(fid,'%8.2f\t',tb(i,j));   
%     end
%     fprintf(fid,'\n');
% end
% fclose(fid);
