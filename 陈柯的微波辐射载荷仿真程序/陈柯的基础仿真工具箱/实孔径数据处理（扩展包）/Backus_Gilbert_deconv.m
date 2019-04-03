function [TA_RE,min_R,TA_PDF_RE] = Backus_Gilbert_deconv(TA,TB,angle_x,angle_y,Ba,illumination_taper,NEDT,num_R,max_R,RMSE_offset,flag_PDF_calc,TA_PDF)
%   �������ܣ� �Դ��й۲�����������ͼ��TA����BG������������ͼ��ֱ��ʺ;���****************
%              ����BG���ؽ��������ͼ��
%  
%   �������:
%    TA           �����ؽ��ĵͷֱ�������ͼ��TA
%    TB           : �����߷ֱ�������ͼ��
% angle_x         :x�᷽��Ƕȷ�Χ
% angle_y         ��y�᷽��Ƕȷ�Χ
% Nx              ��TAͼ����x�����ظ���
% Ny              ��TAͼ����y�����ظ���
% Ba              �����߷���ͼ���㺯��
% illumination_taper :  ���߷���ͼ����׶��
% NEDT            : ����ƽ��ջ�������
% num_R           :  %rֵ���Ե���
% RMSE_offset     �� %�۲�ͼ����ԭʼͼ��Ա�ʱͼ���Եȥ�����л�����

%   ���������
%    TA_RE        : BG�ֱ�����ǿ�������ͼ�� 
%    min_R        : ʵ��BG���Ч��ʱ��Rֵ
%   by �¿� 2016.12.22  ******************************************************

  %rֵ��̽���� 
[Ny,Nx] = size(TA);  
d_x = angle_x/(Nx);
d_y = angle_y/(Ny);
BG_Coordinate_Long = linspace(-angle_x,angle_x-d_x,2*Nx);
BG_Coordinate_Lat = linspace(-angle_y,angle_y-d_y,2*Ny);
Antenna_Pattern_BG = Antenna_Pattern_calc(BG_Coordinate_Long,BG_Coordinate_Lat,Ba,illumination_taper);
RMSE_array = zeros(1,num_R);                                           
TA_RE_array = zeros(Ny,Nx,num_R);
R = linspace(max_R/num_R,max_R,num_R);
for i = 1:num_R                                                     %��N_r��rֵ������̽
    TA_RE = BG_deconv_real(TA,Antenna_Pattern_BG,NEDT,R(i));
    [RMSE_array(i),~] = Mean_Square_Error(TB,TA_RE,RMSE_offset,0);
    TA_RE_array(:,:,i) = TA_RE;                                %��ÿһ��rֵ��ͼ�񴢴�
end
index_min = find(RMSE_array == min(RMSE_array));                %�ҳ�MSE����Сֵ����Ϊ���Ż���R����
TA_RE = TA_RE_array(:,:,index_min);                             %ȡ��MSE��С��ͼ��
min_R = R(index_min);
%��ʾ��ͬR����ʱ��۲�RMSE�ı仯����
% figure;stem(R,RMSE_array,'fill','r-.');xlabel('R'); ylabel('MSE');title('��ͬRֵ�µ�BG�����ͼ���MSE'); 
%����ֻȡĳһ����Rʱ��BG����
% TA_real_BG = BG_deconv_real(TA_real,Antenna_Pattern_BG,T_rec,bandwith,integral_time,0.3);
if flag_PDF_calc == 1
   TA_PDF_RE = BG_deconv_real(TA_PDF,Antenna_Pattern_BG,NEDT,min_R);
end
%����������TA��BG�ؽ�ͼ��
% TA_BG = BG_deconv(TA,Antenna_Pattern_BG);
