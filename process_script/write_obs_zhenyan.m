function write_obs_zhenyan( time,num_lat,num_lon,chan )
%edit by hongpengfei
%2018.11.10

%�������
obs_point=num_lat*num_lon;
tb=zeros(obs_point,chan);
load('C:\\Users\\hust\\Desktop\\maliya_data\\20180707180000\\GRAPES_angles.mat');
satazen_single=reshape(flipud(GRAPES_angles)',obs_point,1);
satazen=repmat(satazen_single,1,chan);
satazi=zeros(obs_point,chan);
solazen=zeros(obs_point,chan);
solazi=zeros(obs_point,chan);
lat_range=linspace(15,40,num_lat);
lat_single=reshape(repmat(lat_range,num_lat,1),obs_point,1);
lat=repmat(lat_single,1,chan);
lon_range=linspace(120,145,num_lon)';
lon_single=reshape(repmat(lon_range,1,num_lon),obs_point,1);
lon=repmat(lon_single,1,chan);
load ('C:\\Users\hust\\Desktop\\maliya_data\\20180707180000\\meteorology_data.mat');
isurf_height=repmat(reshape(GRAPESheight(:,:,1)',obs_point,1),1,chan);
isurf_type=repmat(reshape((2*GRAPESLAND)',obs_point,1),1,chan);
TSK=repmat(reshape(GRAPESTSK',obs_point,1),1,chan);


%�����ļ���
obs_dir=sprintf('F:\\file_write\\%s',time);
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


%���������춥��
%���ļ�
satazen_file=sprintf('%s\\satazen.txt',obs_dir);
fid=fopen(satazen_file,'w');
%ѭ��д������
for i=1:obs_point
    for j=1:chan
        fprintf(fid,'%8.2f\t',satazen(i,j));   
    end
    fprintf(fid,'\n');
end
fclose(fid);


%�������Ƿ�λ��
%���ļ�
satazi_file=sprintf('%s\\satazi.txt',obs_dir);
fid=fopen(satazi_file,'w'); 
%ѭ��д������
for i=1:obs_point
    for j=1:chan
        fprintf(fid,'%8.2f\t',satazi(i,j));    
    end
    fprintf(fid,'\n');
end
fclose(fid);


%����̫���춥��
%���ļ�
solzen_file=sprintf('%s\\solazen.txt',obs_dir);
fid=fopen(solzen_file,'w'); 
%ѭ��д������
for i=1:obs_point
    for j=1:chan
        fprintf(fid,'%8.2f\t',solazen(i,j));    
    end
    fprintf(fid,'\n');
end
fclose(fid);


%����̫����λ��
%���ļ�
solzen_file=sprintf('%s\\solazi.txt',obs_dir);
fid=fopen(solzen_file,'w'); 
%ѭ��д������
for i=1:obs_point
    for j=1:chan
        fprintf(fid,'%8.2f\t',solazi(i,j));   
    end
    fprintf(fid,'\n');
end
fclose(fid);


%����γ����Ϣ
%���ļ�
lat_file=sprintf('%s\\lat.txt',obs_dir);
fid=fopen(lat_file,'w');  
%ѭ��д������
for i=1:obs_point
    for j=1:chan
        fprintf(fid,'%8.2f\t',lat(i,j));   
    end
    fprintf(fid,'\n');
end
fclose(fid);


%��������Ϣ
%���ļ�
lon_file=sprintf('%s\\lon.txt',obs_dir);
fid=fopen(lon_file,'w');
%ѭ��д������
for i=1:obs_point
    for j=1:chan
        fprintf(fid,'%8.2f\t',lon(i,j));   
    end
    fprintf(fid,'\n');
end
fclose(fid);


%����ر�߶���Ϣ
%���ļ�
isurf_height_file=sprintf('%s\\surf_height.txt',obs_dir);
fid=fopen(isurf_height_file,'w');
%ѭ��д������
for i=1:obs_point
    for j=1:chan
        fprintf(fid,'%8.2f\t',surf_height(i,j));   
    end
    fprintf(fid,'\n');
end
fclose(fid);


%����ر�������Ϣ
%���ļ�
isurf_type_file=sprintf('%s\\surf_type.txt',obs_dir);
fid=fopen(isurf_type_file,'w');
%ѭ��д������
for i=1:obs_point
    for j=1:chan
        fprintf(fid,'%8.2f\t',surf_type(i,j));    
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























