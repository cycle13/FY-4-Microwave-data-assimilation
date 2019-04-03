function TA_noiseless = Antenna_conv(TB,angle_x,angle_y,sample_width_x,sample_width_y,N_x,N_y,Ba,illumination_taper)
%   �������ܣ���RMSEʵ�ֶ�������ͬ��Χ������ͼ������Ƚ�**********************************
%            ���ͼ�����ص�����һ�£��򽫵ͷֱ���ͼ���ֵ���߷ֱ���ͼ��
%  
%   �������:
%    TB             : �����߷ֱ�������ͼ��
%   angle_x         : x�᷽��Ƕȷ�Χ
%   angle_y         ��y�᷽��Ƕȷ�Χ
%    Nx             ��TAͼ����x�����ظ���
%    Ny             ��TAͼ����y�����ظ���
% sample_width_x    : x��������
% sample_width_y    : y��������
% Ba                �����߷���ͼ���㺯��
% illumination_taper:  ���߷���ͼ����׶��
%   ���������
% TA_noiseless      : ����ɨ������Ĺ۲����� 
%   by �¿� 2016.12.22  ******************************************************  

N_TA_Lat = round(angle_x/sample_width_y);                   %γ�ȷ�����������ɨ�����  
N_TA_Long = round(angle_y/sample_width_x);                %���ȷ�����������ɨ�����  
%��������ÿ��ɨ�貨��ָ��Ƕ�Ӧ������ͼ���С��б��
row_TA_Lat = zeros(1,N_TA_Lat);                                 %����ÿ��ɨ�貨��ָ��Ƕ�Ӧ������ͼ���б��
col_TA_Long = zeros(1,N_TA_Long);                               %����ÿ��ɨ�貨��ָ��Ƕ�Ӧ������ͼ���б��
for i = 1:N_TA_Lat  %�б��
    delta_angle=(i-1)*(sample_width_y);
    row_TA_Lat(i) = min(round(delta_angle/angle_x*N_y)+1,N_y);    
end
for i = 1:N_TA_Long  %�б��
    delta_angle=(i-1)*(sample_width_x);
    col_TA_Long(i) = min(round(delta_angle/angle_y*N_x)+1,N_x);    
end
%%%%%%%%%%%%%%%%����ģ��۲�����TA%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
d_Long = angle_y/(N_x);                  %����ͼ�񾭶ȷ�����С��࣬���Ƕȷֱ���  
d_Lat = angle_x/(N_y);                     %����ͼ��γ�ȷ�����С��࣬���Ƕȷֱ��� 
AP_Coordinate_Long = linspace(-angle_y,angle_y-d_Long,2*N_x);
AP_Coordinate_Lat = linspace(-angle_x,angle_x-d_Lat,2*N_y);
Antenna_Pattern_Full = Antenna_Pattern_calc(AP_Coordinate_Long,AP_Coordinate_Lat,Ba,illumination_taper);
%��ʼ���۲����������ͼ��TA
TA_noiseless=zeros(N_TA_Lat,N_TA_Long);  
% matlabpool open ;
parfor sample_num_Lat=1:N_TA_Lat
     for sample_num_Long=1:N_TA_Long
         %�������߷���ͼƽ�����������½��о��������ģ��ÿ�����صĹ۲�����TA  
         row_current=row_TA_Lat(sample_num_Lat);
         col_current=col_TA_Long(sample_num_Long);
         Antenna_Pattern_current = Antenna_Pattern_Full(N_y+1-row_current+1:2*N_y+1-row_current,N_x+1-col_current+1:2*N_x+1-col_current) 
         Antenna_Pattern_current = Antenna_Pattern_current/sum(sum(Antenna_Pattern_current));
         TA_noiseless(sample_num_Lat,sample_num_Long)=sum(sum(TB.* Antenna_Pattern_current));        
    end
end
% matlabpool close ;