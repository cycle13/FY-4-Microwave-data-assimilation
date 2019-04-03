function TA_SIR = split_deconv_SIR3(sample_factor,N,TA,Block_num,N_TA_Lat,N_TA_Long,Antenna_Pattern_SIR,row_TA_Lat,col_TA_Long,TA_real_SIR1)
%������������TA�ָ�ɿ�ֱ���н�������
%���������
%TA���۲�����
%Block_num�������зֿ���
%N_TA_Lat������TA����Ŀ
%N_TA_Long������TA����Ŀ
        num = N_TA_Lat/Block_num;                                                                                         %�ֿ��ÿ���������
        TA_SIR_Block = zeros(num,num,(N_TA_Lat/num)^2);                                                                   %���񴢴����
        for i = 1:N_TA_Lat/num
            for j = 1:N_TA_Long/num                                                                                       %��ÿ�����񵥶�����SIR����
                    TA_SIR_Block(:,:,(i-1)*N_TA_Lat/num+j) = SIR_deconv3(sample_factor,N,TA((i-1)*num/sample_factor+1:i*num/sample_factor,(j-1)*num/sample_factor+1:j*num/sample_factor),Antenna_Pattern_SIR,row_TA_Lat,col_TA_Long,TA_real_SIR1((i-1)*num+1:i*num,(j-1)*num+1:j*num));
                    x=sprintf('��%d������--��%d������',(i-1)*N_TA_Lat/num+j,(N_TA_Lat/num)^2);
                    disp(x);
            end
        end
        TA_SIR = zeros(N_TA_Lat,N_TA_Long);
        for i = 1:N_TA_Lat/num
            for j = 1:N_TA_Long/num                                                                                        %���ֿ������ָ��������ͼ��
                TA_SIR((i-1)*num+1:i*num,(j-1)*num+1:j*num)=TA_SIR_Block(:,:,(i-1)*300/num+j);
            end
        end
end
