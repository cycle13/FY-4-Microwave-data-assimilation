function [uvsample,uv_ant_info]= UVCellforDFT(ant_pos)
%   �������ܣ������ۺϿ׾����е�uv����������*************************************
%              
%   �������:
%    ant_pos  :     ��һ����������λ�ã���λ������
%                   ���ant_posΪ��ά�����������ת�ۺϿ׾�����                    
%   
%    
%   ���������
%    uv_sample  :  ���ж�Ӧ��uvƽ����������꣬��������ʵ��u�ᣬ�鲿v��
%                  �������ת�ۿ׾����У�������������uv���������������������ת����
%    uv_ant_info:  ÿ��uv�������Ӧ���ۺϿ׾�������Ԫ���
%
%   by �¿� 2016.06.24  ******************************************************

ant_num = size(ant_pos,2);  %�������߸���
index = 1;     
 
for p = 1:ant_num
    for q = 1:ant_num
        uvsample(index,:) = ant_pos(:,p) - ant_pos(:,q);
        uv_ant_info(index,:) = (p+1i*q)*ones(size(ant_pos,1),1);
        index = index+1;
    end
end








