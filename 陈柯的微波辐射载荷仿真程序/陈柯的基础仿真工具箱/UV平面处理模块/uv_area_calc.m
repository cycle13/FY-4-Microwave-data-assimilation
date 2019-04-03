function [uv_area,uv_sample]= uv_area_calc(uvsample)

%   �������ܣ��������Բ�����е�ÿ������������***********
%             
%  
%   �������:
%    uvsample   :     ��һ����������λ�ã���λ������
%   ���������
%    uv_area    :   ÿ���������Ӧ��uv�������    

%   by �¿� 2016.09.01  ******************************************************
[uvsample,uv_area] = UVCellforCDFT(ant_pos);
        num_redunt = size(uvsample_redunt);
        V_nonredunt = zeros(1,length(uvsample));
        redundancy = zeros(1,length(uvsample));    
        threshold = 1e-6;    
        for k = 1:1:num_redunt
            u = real(uvsample_redunt(k));
            v = imag(uvsample_redunt(k));
            position = find(abs(real(uvsample)-u)<threshold & abs(imag(uvsample)-v)<threshold);
            redundancy(position) = redundancy(position)+1;
            V_nonredunt(position) = V_nonredunt(position)+V_redunt(k);
        end
        for k = 1:length(uvsample)
            if 0 ~= redundancy(k)
               V_nonredunt(k) = V_nonredunt(k)/redundancy(k);
            end
        end                                  