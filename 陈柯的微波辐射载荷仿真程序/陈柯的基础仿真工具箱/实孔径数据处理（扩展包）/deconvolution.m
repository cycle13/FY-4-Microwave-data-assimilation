% ͼ���������%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [TB_deconv,Antenna_Gs] = deconvolution(TA,PSF_Long,PSF_Lat,k_Long,k_Lat)
%PSF_Long��PSF_Lat����ά��PSF����;k_Long,k_Lat:���򻯲�����flag_draw_AP��������������PSF�ı�־λ��TA������ͼ��
%����TB_deconv�������������ͼ��Antenna_Gs�������֮��ĵ�Ч����ͼ
       num_Latitude = size(PSF_Lat,1);
       col_pix = size(PSF_Long,2);
       row_pix = size(PSF_Lat,2);       
       TB_Long_deconv = zeros(num_Latitude,col_pix);
       TB_deconv = zeros(row_pix,col_pix);       
       inv_PSF_Long = PSF_inversion(PSF_Long,k_Long);
       inv_PSF_Lat = PSF_inversion(PSF_Lat,k_Lat);
       for index_Lat=1:num_Latitude    
           TB_Long_deconv(index_Lat,:) = (inv_PSF_Long*TA(index_Lat,:).').';
       end
       for index_Long=1:col_pix
           TB_deconv(:,index_Long) = (inv_PSF_Lat*TB_Long_deconv(:,index_Long));
       end
       
       A = inv_PSF_Lat*PSF_Lat;   %�����֮��ĵ�Ч����ͼ
       Antenna_Gs = A(round(row_pix/2),:)/max(A(round(row_pix/2),:));
       