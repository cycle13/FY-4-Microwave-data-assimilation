function write_TB_obs( time,num_lat,num_lon,obs_point,chan,input_dir,output_dir,scene_name )
%edit by hongpengfei
%2018.11.29

tb=zeros(obs_point,chan);
for i=1:chan
    TA_dir=sprintf('%s\\%s',input_dir,time);
    TA_file=sprintf('%s\\Typhoon%s_%s_%s_%s_C%s_H.mat',TA_dir,scene_name,time(7:8),time(9:10),time(11:12),num2str(i-2));
    if(exist(TA_file,'file')==2)
        load(TA_file);
        TbMap=TA(1:num_lat,1:num_lon);
        tb(:,i)=reshape(TbMap(:,:)',obs_point,1);
    else
        tb(:,i)=0;
    end
end

%�����ļ���
obs_dir=sprintf('%s\\%s',output_dir,time);
mkdir(obs_dir);

%����TB
%���ļ�
Tb_file=sprintf('%s\\tb.txt',obs_dir);
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
time_file=sprintf('%s\\time.txt',obs_dir);
fid=fopen(time_file,'w');
%д������
fprintf(fid,'%s\t%s\t%s\t%s\t%s',time(1:4),time(5:6),...
        time(7:8),(time(9:10)),time(11:12));
fclose(fid);


% time_test=sprintf('20180301%s',time(9:12))
% obs_dir=sprintf('%s\\%s',output_dir,time_test);
% mkdir(obs_dir);
% 
% %����TB
% %���ļ�
% Tb_file=sprintf('%s\\tb.txt',obs_dir);
% fid=fopen(Tb_file,'w');   
% %ѭ��д������
% for i=1:obs_point
%     for j=1:chan
%         fprintf(fid,'%8.2f\t',tb(i,j));   
%     end
%     fprintf(fid,'\n');
% end
% fclose(fid);
% 
% %����ʱ��
% %���ļ�
% time_file=sprintf('%s\\time.txt',obs_dir);
% fid=fopen(time_file,'w');
% %д������
% fprintf(fid,'%s\t%s\t%s\t%s\t%s',time_test(1:4),time_test(5:6),...
%         time_test(7:8),time_test(9:10),time_test(11:12));
% fclose(fid);

