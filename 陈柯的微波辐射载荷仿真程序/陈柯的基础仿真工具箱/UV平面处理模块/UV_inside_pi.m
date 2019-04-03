function [uv_inside_pi,V_inside_pi] = UV_inside_pi(uv_sample,uv_sample_pi,V)
%   �������ܣ���uv������ƽ����ѡ����[-pi,pi]��Χ��*****************************
%             ��Ϊ��������ͼ����DFT�任�����Ƶ�ʹ�һ�������[-pi,pi]��
%               ����������Ƶ�ʻ����Χ���Է����и�Ӱ��
%  
%   �������:
%    uv_sample      ��uvƽ�����������,��λ������         
%    uv_sample_pi   ��uvƽ��������[-pi,pi]��Χ��һ��������꣬������
%    V              ���ɼ��Ⱥ���ֵ  

%   ���������
%   uv_inside_pi    : [-pi,pi]��Χ�ڵ�uvƽ������㣬��λ������ 
%   V_inside_pi     : [-pi,pi]��Χ�ڵĿɼ��Ⱥ���ֵ
%   by �¿� 2016.06.24  ******************************************************
num_uv = length(uv_sample);
count =1;
for k =1:num_uv
    if abs(real(uv_sample_pi(k)))<=pi && abs(imag(uv_sample_pi(k)))<=pi
       uv_inside_pi(1,count) = uv_sample(k);
       V_inside_pi(1,count) =  V(k);
       count = count+1;
    end
end