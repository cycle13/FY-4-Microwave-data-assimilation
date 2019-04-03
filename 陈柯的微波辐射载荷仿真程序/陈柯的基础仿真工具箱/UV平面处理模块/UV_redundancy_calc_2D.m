function redundancy_sum = UV_redundancy_calc_2D(UVsample,ant_pos)
%   �������ܣ�����ɼ���uvƽ����������������ȣ��������䵹����**********************************
%            ���ڼ����ۺϿ׾������������
%   �������:
%    UVsample       ���������uv����������         
%    ant_pos        ����������������Ԫλ�� 
%
%   ���������
%    redundancy_sum : ����uv����������ȵĵ�����
%   by �¿� 2016.06.24  ******************************************************


threshold = 1e-4;   % �����ж��Ƿ�����ļ�С������
ant_num = size(ant_pos,2);
redundancy=zeros(1,length(UVsample));
U_coordinate = real(UVsample);
V_coordinate = imag(UVsample);
redundancy_sum=0;

% �õ�uvƽ���Ŀɼ��ȷֲ�
for p = 1:ant_num
    for q = 1:ant_num
        u =real(ant_pos(p)-ant_pos(q));
        v =imag(ant_pos(p)-ant_pos(q));
        position = find(abs(U_coordinate-u)<threshold & abs(V_coordinate-v)<threshold);
        redundancy(position) = redundancy(position)+1;
    end
end
% figure;stem(redundancy);  %�������ߵ�����ȷֲ�
% ���������������ȵ�����
for k = 1:length(UVsample)
    if 0 ~= redundancy(k)
        redundancy_sum = redundancy_sum+1/redundancy(k);
    end
end
