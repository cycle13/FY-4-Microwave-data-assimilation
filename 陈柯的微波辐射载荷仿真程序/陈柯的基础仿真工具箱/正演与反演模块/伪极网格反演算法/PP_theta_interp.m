function [v_theta_interp,uv_theta_interp]= PP_theta_interp(visibility,uvsample,N)
%   �������ܣ�   α������ǶȲ�ֵ����**********************************
%               ��uvƽ��һԲȦ�ϵĽǶȾ��ȼ��Ĳ������ֵ��α�������Ӧ�ĵ�б�ʽǶ���          
%  
%   �������:
%   visibility      �����ǶȲ�ֵ�Ŀɼ��Ⱥ���
%   uvsample        �����ǶȲ�ֵ��uv����ƽ�棬Ӧ����ͬһԲ���ϵĽǶȾ��ȼ��Ĳ�����
%   N               : Ҫ��ֵ��α���������
%   ���������
%   v_theta_interp  ���ǶȲ�ֵ��Ŀɼ��Ⱥ���ֵ������Ϊ4N
%   uv_theta_interp ���ǶȲ�ֵ���uv����ƽ�棬����Ϊ4N                         
%   by �¿� 2016.06.24  ******************************************************

M = length(visibility)/2;        %Ŀǰ��ֵ��ʽҪ��������Ϊż�� 
uv_radius = mean(abs(uvsample)); %��ǰ����ֵuvԲ���İ뾶
uv_theta = angle(uvsample);      %��ǰ����ֵuvԲ�������в�����ĽǶ�
% ��ֵ���α�������Ƕȣ��ֳ��ĸ����޷ֱ����
PP_theta = zeros(1,4*N);
PP_theta(1,1:N) = atan((-N/2+1:1:(N/2))/(N/2));
PP_theta(1,N+1:2*N) = pi/2+atan((-N/2+1:1:(N/2))/(N/2));
PP_theta(1,2*N+1:3*N) = pi+atan((-N/2+1:1:(N/2))/(N/2));
PP_theta(1,3*N+1:4*N) = 3*pi/2+atan((-N/2+1:1:(N/2))/(N/2));
%���Ƕȷ�ΧͶӰ��-pi����pi֮��
PP_theta = wrapToPi(PP_theta);
uv_theta = wrapToPi(uv_theta);

% ����α�������Ƕȿ��Լ���õ���ֵ���uv����������꣨�뾶���䣩
uv_theta_interp = uv_radius*exp(1i*PP_theta);
v_theta_interp = zeros(1,4*N);
interp_coeffcient = zeros(1,2*M); %��ֵϵ��
%�ǶȲ�ֵ����ֵ��ʽ��Դ���ųɲ�ʿ���Ĺ�ʽ��3-65��
for i = 1:4*N
    theta = PP_theta(i);             %��ǰҪ����ֵ��α������Ƕ�
    del_theta = abs(theta-uv_theta); %����ֵ�����������в�����ĽǶȾ��� 
    %�������ֵ�������е�ĳ�������غϣ�����Ҫ��ֵ��ֱ�Ӳ������в������ϵĿɼ��Ⱥ���ֵ
    
    if min(del_theta)<1e-6 
       v_theta_interp(i) = visibility(del_theta==min(del_theta));       
    elseif abs(max(del_theta)-2*pi)<1e-6
       v_theta_interp(i) = visibility(del_theta==max(del_theta));      
    else       
       for k = 1:2*M
           interp_coeffcient(k) = sin(1/2*(2*M-1)*(theta-uv_theta(k)))/(2*M*sin(1/2*(theta-uv_theta(k))));                      
       end
       v_theta_interp(i) = sum(visibility.*interp_coeffcient);  %�ǶȲ�ֵ��Ŀɼ��Ⱥ���ֵ
       %  v_theta_interp(i) = interp1(uv_theta,real(visibility),theta,'spline')+1i*interp1(uv_theta,imag(visibility),theta,'spline');����������ֵ 
    end
end
    