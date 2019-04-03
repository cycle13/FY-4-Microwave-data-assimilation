function [V_nonredunt,uvsample,redundancy,uv_area] = Visibility2D_remove_redunt(V_redunt,uvsample_redunt,array_type,ant_pos)
%   �������ܣ�ȥ��UVƽ����������㣬�õ�����ƽ���ɼ��Ⱥ��������**********************************% 
%             ����Ǿ���Բ�����У��������ÿ��uv�����������
%  
%   �������:
%    V_redunt       ������Ŀɼ��Ⱥ��� 
%    uvsample_redunt�������uv����ƽ������
%    array_type     ����������
%    ant_pos        ������λ��
%   ���������
%    V_nonredunt    : ����ƽ����Ŀɼ��Ⱥ��� 
%    uvsample       : ȥ������uv����ƽ�����꣬��V_nonreduntλ�ö�Ӧ
%    redundancy_sum : ����ϵ������ÿ������������ȵĵ����� 
%    uv_area        : ÿ��uv�������������ֻ�Ծ���Բ������������
%   by �¿� 2016.06.24  ******************************************************

uv_area = 0;
redundancy = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%��תԲ�����в���ȥ��������ߣ�ȥ�����ں��淴�ݹ�����ʵ��
if (strcmpi('O_Rotate_shape',array_type))   
        V_nonredunt = V_redunt;
        uvsample = uvsample_redunt;
%%%%%%%%%%%%%%%%%%%%%%%%%Բ������ȥ��������㼰�ɼ��Ⱥ�����ƽ��
else if (strcmpi('O_shape',array_type))     
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
     
%%%%%%%%%%%%%%%%%%%%%%%%%�������������������ȥ��������㼰�ɼ��Ⱥ�����ƽ��        
    else                                     
        uvsample=UV_unique(uvsample_redunt);
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
     end
end





