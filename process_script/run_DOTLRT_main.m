%edit by hongpengfei
%2018.10.31
function run_DOTLRT_main(time)

SOURCE_PATH=sprintf('/g3/wanghao/hpf/process_data/outfile/%s',time);                  %Դ�ļ�Ŀ¼  
DST_PATH=sprintf('/g3/wanghao/hpf/DOTLRT_20170510_chenke_0/data_sq/%s/',time);         %Ŀ���ļ�Ŀ¼
filename=sprintf('%s/meteorology_data.mat',SOURCE_PATH);
movefile(filename,DST_PATH_t);
DOTLRT_main 