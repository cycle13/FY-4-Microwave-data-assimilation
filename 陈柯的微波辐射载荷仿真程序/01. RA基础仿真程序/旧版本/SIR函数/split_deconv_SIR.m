function [TA_SIR,opt_factor] = split_deconv_SIR(TA,TB,Block_num,sample_width_Lat,sample_width_Long,sample_factor,Ba,illumination_taper,angle_Long,angle_Lat,d_Long,d_Lat)
%������������TA�ָ�ɿ�ֱ���н�������
%���������
%
%TA���۲�����
%TB: ԭʼ����
%Block_num�������зֿ���
%sample_width_Lat��γ�ȷ��������
%sample_width_Long�����ȷ��������
%sample_factor������ϵ��
%Ba�����ߵ糤�Ȳ���
%illumination_taper������ϵ��
%
%
        [N_Lat,N_Long] = size(TB);
        [N_TA_Lat,N_TA_Long] = size(TA);
        row_TA_Lat = zeros(1,N_TA_Lat);                                 %����ÿ��ɨ�貨��ָ��Ƕ�Ӧ������ͼ���б��
		col_TA_Long = zeros(1,N_TA_Long);                               %����ÿ��ɨ�貨��ָ��Ƕ�Ӧ������ͼ���б��
        for i = 1:N_TA_Lat  %�б��
			delta_angle=(i-1)*(sample_width_Lat);
			row_TA_Lat(i) = min(round(delta_angle/angle_Lat*N_Lat)+1,N_Lat); 
        end
		for i = 1:N_TA_Long  %�б��
			delta_angle=(i-1)*(sample_width_Long);
			col_TA_Long(i) = min(round(delta_angle/angle_Long*N_Long)+1,N_Long);    
        end

        
        num_TB_row = N_Lat/Block_num;                                                                              %�ֿ��ÿ���������
        num_TB_col = N_Long/Block_num;                                                                             %�ֿ��ÿ���������       
        num_TA_row = N_TA_Lat/Block_num;  
        num_TA_col = N_TA_Long/Block_num;          
        TA_SIR_Block = zeros(num_TB_row,num_TB_col,(Block_num)^2);                                                               %���񴢴����

        AP_Coordinate_Long = linspace(-angle_Long/Block_num,(angle_Long-d_Long)/Block_num,2*num_TB_row+1);         %��ķ���ͼ��Ӧ������    
        AP_Coordinate_Lat = linspace(-angle_Lat/Block_num,(angle_Lat-d_Lat)/Block_num,2*num_TB_col+1);
        Antenna_Pattern_SIR =  Antenna_Pattern_calc(AP_Coordinate_Long,AP_Coordinate_Lat,Ba,illumination_taper);   %������ߴ�һ�µ����߷���ͼ       
        
        
        i = 2; j = 2;
        N = 23;                                                                                                      %����������
%         [~,N] =  N_cal(TA((i-1)*num_TA_row +1:i*num_TA_row,(j-1)*num_TA_col +1:j*num_TA_col),TB((i-1)*num_TB_row+1:i*num_TB_row,(j-1)*num_TB_col+1:j*num_TB_col),Antenna_Pattern_SIR,row_TA_Lat,col_TA_Long,N,sample_factor);
        for i = 1:Block_num
            for j = 1:Block_num                                                                                       %��ÿ�����񵥶�����SIR����
                    [TA_SIR_Block(:,:,(i-1)*Block_num+j),opt_factor] = SIR_deconv(TA((i-1)*num_TA_row +1:i*num_TA_row,(j-1)*num_TA_col +1:j*num_TA_col),TB((i-1)*num_TB_row+1:i*num_TB_row,(j-1)*num_TB_col+1:j*num_TB_col),Antenna_Pattern_SIR,row_TA_Lat,col_TA_Long,N,sample_factor);
                    x=sprintf('��%d������--��%d������',(i-1)*Block_num+j,(Block_num)^2);
                    disp(x);
            end
        end
        TA_SIR = zeros(N_Lat,N_Long);
        for i = 1:Block_num
            for j = 1:Block_num                                                                                      %���ֿ������ָ��������ͼ��
                TA_SIR((i-1)*num_TB_row+1:i*num_TB_row,(j-1)*num_TB_col+1:j*num_TB_col)=TA_SIR_Block(:,:,(i-1)*Block_num+j);
            end
        end
end

