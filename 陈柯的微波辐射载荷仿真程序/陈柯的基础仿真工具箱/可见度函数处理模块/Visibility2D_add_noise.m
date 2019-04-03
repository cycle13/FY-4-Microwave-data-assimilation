function V_noise = Visibility2D_add_noise(V,uv_ant_info,T_noise_rec,T_noise_B,bandwidth,integral_time)
%   �������ܣ��Կɼ��Ⱥ�������ۺϿ׾�����ϵͳ������**********************************%             
%  
%   �������:
%    V              ���������ľ�ȷ�ɼ��Ⱥ��� 
%    uv_ant_info    ��ÿ���ɼ��ȶ�Ӧ��һ����Ԫ�������еı�ţ�Ϊһ������ʵ��Ϊ��Ԫ1���鲿Ϊ��Ԫ2
%    T_noise_rec    ��ÿ����Ԫ��Ӧ�Ľ��ջ�ͨ����Ч�������¶ȣ�Ϊһ���� ����λ��K
%    T_noise_B      ������ƽ���������¶ȣ���λ��K
%    bandwidth      �����ջ�ͨ���Ĵ��� 
%    integral_time  ��ϵͳ����ʱ��
%   ���������
%    V_noise       : ����֮��Ŀɼ��Ⱥ���                                       
%   by �¿� 2016.06.24  ******************************************************

[num_row,num_col] = size(V);                 %�ɼ��Ⱥ���������
delta_V = zeros(num_row,num_col);            %��ʼ��ÿ���ɼ��Ⱥ�����������׼��

noise_factor = sqrt(1/2/bandwidth/integral_time) ; 
TB = T_noise_B;

ant_num = length(T_noise_rec);
V_autocorrelation = zeros(1,ant_num);
for n =1:ant_num
    V_autocorrelation(n) = V((n-1)*ant_num+n);
end
%����ÿ���ɼ��Ⱥ�����������׼��㷨��Դ��Ruf 1988�����¡�Interferometric synthetic aperture
%microwave radiometry for the remote sensing of the Earth����ʽ��12����13��
for m = 1:num_row
    for n= 1:num_col
        Vi = V_autocorrelation(real(uv_ant_info(m,n)));
        Vk = V_autocorrelation(imag(uv_ant_info(m,n)));
        delta_V(m,n) = noise_factor*(sqrt(Vi*Vk+real(V(m,n))^2-imag(V(m,n))^2)+1i*sqrt(Vi*Vk+imag(V(m,n))^2-real(V(m,n))^2));
    end
end
noise_matrix = randn(num_row,num_col).*delta_V;  %���пɼ��Ⱥ�������������
V_noise = V+noise_matrix;                        %����



