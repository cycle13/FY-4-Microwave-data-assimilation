function [TA_SIR,Iteration_optimal] = Scatterometer_Image_Restruction(TA,TB,Block_num,sample_width_Lat,sample_width_Long,sample_factor,Ba,illumination_taper,angle_Long,angle_Lat,d_Long,d_Lat)
%   �������ܣ� �Դ��й۲�����������ͼ��TA����SIR�ֱ�����ǿ��������ͼ��ֱ��ʺ;���****************
%              ����SIR���ؽ��������ͼ��
%  
%   �������:
%    TA           �����ؽ��ĵͷֱ�������ͼ��TA
%    TB           : �����߷ֱ�������ͼ��
%Block_num        �������зֿ���
%sample_width_Lat ��γ�ȷ��������
%sample_width_Long�����ȷ��������
%sample_factor    ������ϵ��
% angle_Long      : Long�᷽��Ƕȷ�Χ
% angle_Lat       ��Lat�᷽��Ƕȷ�Χ
% Nx              ��TAͼ����x�����ظ���
% Ny              ��TAͼ����y�����ظ���
% Ba              �����߷���ͼ���㺯��
% illumination_taper :  ���߷���ͼ����׶��
% d_Long,d_Lat    ��Long,Lat�����ɨ����

%   ���������
%    TA_SIR       : SIR�ֱ�����ǿ�������ͼ�� 
%    opt_factor   : ʵ��SIR���Ч��ʱ�ĵ�������
%   by �¿� 2017.06.16  ******************************************************

%��������ÿ��ɨ�貨��ָ��Ƕ�Ӧ������ͼ���С��б��
 [N_Lat,N_Long] = size(TB);
 [N_TA_Lat,N_TA_Long] = size(TA);
 row_TA_Lat = zeros(1,N_TA_Lat);                                 %����ÿ��ɨ�貨��ָ��Ƕ�Ӧ������ͼ���б��
 col_TA_Long = zeros(1,N_TA_Long);                               %����ÿ��ɨ�貨��ָ��Ƕ�Ӧ������ͼ���б��
 for m = 1:N_TA_Lat  %�б��
    delta_angle=(m-1)*(sample_width_Lat);
	row_TA_Lat(m) = min(round(delta_angle/angle_Lat*N_Lat)+1,N_Lat); 
 end
 for m = 1:N_TA_Long  %�б��
	delta_angle=(m-1)*(sample_width_Long);
	col_TA_Long(m) = min(round(delta_angle/angle_Long*N_Long)+1,N_Long);    
 end
%  ��ͼ����зֿ鴦��
    num_TB_row = N_Lat/Block_num;  num_TB_col = N_Long/Block_num;                   %TB�ֿ��ÿ��������� 
    num_TA_row = N_TA_Lat/Block_num; num_TA_col = N_TA_Long/Block_num;              %TA�ֿ��ÿ���������                                                                 
%     TA_SIR_Block = zeros(num_TB_row,num_TB_col,(Block_num)^2);                      %���񴢴����

%  �������߷���ͼ
    AP_Coordinate_Long = linspace(-angle_Long/Block_num,(angle_Long-d_Long)/Block_num,2*num_TB_row+1);         %��ķ���ͼ��Ӧ������    
    AP_Coordinate_Lat = linspace(-angle_Lat/Block_num,(angle_Lat-d_Lat)/Block_num,2*num_TB_col+1);
    Antenna_Pattern_SIR =  Antenna_Pattern_calc(AP_Coordinate_Long,AP_Coordinate_Lat,Ba,illumination_taper);   %������ߴ�һ�µ����߷���ͼ  
    
%  �������Ż��ĵ�������  
   m = 1; n = 1;
   Iteration_initial = 30;                                                                                                      %����������
   TA_Block = TA((m-1)*num_TA_row+1:m*num_TA_row,(n-1)*num_TA_col+1:n*num_TA_col);
   TB_Block = TB((m-1)*num_TB_row+1:m*num_TB_row,(n-1)*num_TB_col+1:n*num_TB_col);   
  [~,Iteration_optimal] =  SIR_deconv(TA_Block,TB_Block,Antenna_Pattern_SIR,row_TA_Lat,col_TA_Long,Iteration_initial,sample_factor,1);
  
%  ��ÿ�����񵥶�����SIR����
   TA_SIR = zeros(N_Lat,N_Long);
%    Iteration_optimal = Iteration_optimal;
  for m = 1:Block_num
      for n = 1:Block_num                                                                                      
         TA_Block = TA((m-1)*num_TA_row+1:m*num_TA_row,(n-1)*num_TA_col+1:n*num_TA_col);
         TB_Block = TB((m-1)*num_TB_row+1:m*num_TB_row,(n-1)*num_TB_col+1:n*num_TB_col);  
         TA_SIR_Block = SIR(TA_Block,TB_Block,Antenna_Pattern_SIR,row_TA_Lat,col_TA_Long,Iteration_optimal,sample_factor,0);
         TA_SIR((m-1)*num_TB_row+1:m*num_TB_row,(n-1)*num_TB_col+1:n*num_TB_col)=TA_SIR_Block;
         x=sprintf('��%d������--��%d������',(m-1)*Block_num+n,(Block_num)^2);  disp(x);
      end
   end     
end

