function TB_write_obs_batch( time,num_lat,num_lon,chan,input_TB_dir,input_meteo_dir,output_dir,b,c )
%edit by hongpengfei
%2018.11.20


obs_point=num_lat*num_lon;
tb=zeros(obs_point,chan);
TB_dir=sprintf('%s\\%s',input_TB_dir,time(1:12));
for i=1:chan
    TB_file=sprintf('%s\\C%d_2018-07-%s_%s_00',TB_dir,i+2,b);
    if(exist(TB_file,'file')==2)
        load(TA_file);
        tb(:,i)=reshape(TbMap(:,:,1)',obs_point,1);
    end
end
meteo_file=sprintf('%s\\%s\\meteorology_data.mat',input_meteo_dir,time(1:12));
load(meteo_file);
TSK=repmat(reshape(GRAPESTSK',obs_point,1),1,chan);

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

%����TSK��Ϣ
%���ļ�
TSK_file=sprintf('%s\\TSK.txt',obs_dir);
fid=fopen(TSK_file,'w');
%ѭ��д������
for i=1:obs_point
    for j=1:chan
        fprintf(fid,'%8.2f\t',TSK(i,j));    
    end
    fprintf(fid,'\n');
end
fclose(fid);

%����ʱ����Ϣ
time_file=sprintf('%s\\time.txt',obs_dir);
fid=fopen(time_file,'w');
%д������
fprintf(fid,'%s\t%s\t%s\t%s\t%s\t%s',time(1:4),time(5:6),...
        time(7:8),(time(9:10)),time(11:12),time(13:14));
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



