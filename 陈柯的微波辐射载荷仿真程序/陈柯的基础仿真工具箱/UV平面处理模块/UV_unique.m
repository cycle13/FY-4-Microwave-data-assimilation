function [uv_nonredunt]=UV_unique(uv_redunt)
%   �������ܣ������������һά����������ֵȥ�����õ�������ֵ*************************************
%             �������Ϊʵ��������ͨ���Ŵ����ӣ����Կ�������ֵ�ľ��� 
%   �������:
%    array_redunt  :    ��������ֵ��һά����,����Ϊ����
%
%   ���������
%    array_nonredunt  : ȥ��������ֵ֮���һά����
%
%   by �¿� 2016.06.24  ******************************************************
factor_gain = 1e5;
input_data(:,1)=real(uv_redunt);
input_data(:,2)=imag(uv_redunt);
gain_data=round(input_data*factor_gain);
[~,N_index]=unique(gain_data,'rows');
uv_nonredunt=input_data(N_index,:);
uv_nonredunt=uv_nonredunt(:,1)+1i*uv_nonredunt(:,2);
uv_nonredunt=uv_nonredunt.';
end

