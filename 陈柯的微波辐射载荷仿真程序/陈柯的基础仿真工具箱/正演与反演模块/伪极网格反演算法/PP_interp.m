function [PP_V,PP_uv] = PP_interp(visibility,uvsample,num_radius,num_theta,N)
%   �������ܣ�   ʵ�ֶԾ���Բ�����е�Բ��uv�����ɼ��Ⱥ�����ֵ��α������ֲ�**********************************
%               ���ز�ֵ��Ŀɼ��Ⱥ���ֵ��α������uv���� %               
%  
%   �������:
%   visibility      ������Բ�����пɼ���
%   uvsample       �� ����Բ������uv����������
%   N               : α�������������ֵ���α������Ϊ2N*2N
%   ���������
%   PP_V            ����ֵ���α������ɼ��Ⱥ���������PPFFT���������˳��BV��BH�ֿ����У�����2N*2N����
%   PP_uv           ��α�����������uv���꣬����-pi~pi��Χ��һ����Ҳ�ǰ���PPFFT���������˳��BV��BH�ֿ����У�����2N*2N����                          
%   by �¿� 2016.06.24  ******************************************************  

% Բ�����Ӧ��uvƽ������[0 0]Ϊ���ĵ���ɢͬ��Դ

%%%%%%%%%% �ǶȲ�ֵ %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ��ʼ���ǶȲ�ֵ��ɼ�����uv����ƽ��
PP_theta_interp_visibility = zeros(1,1+N*4*num_radius);
PP_theta_interp_visibility(1) = visibility(1);
PP_theta_interp_uvsample = zeros(1,1+N*4*num_radius);
PP_theta_interp_uvsample(1) = uvsample(1);
% ��ֵ��ͬһ����λ����
for k = 1:num_radius
    index_old = (k-1)*num_theta+2:k*num_theta+1;
    v_old = visibility(index_old);
    uvsample_old = uvsample(index_old);
    [v_new,uvsample_new]= PP_theta_interp(v_old,uvsample_old,N); 
    index_new = (k-1)*N*4+2:k*N*4+1;                %ȷ����ֵ��Ŀɼ������ 
    PP_theta_interp_visibility(index_new) = v_new;
    PP_theta_interp_uvsample(index_new) = uvsample_new;    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%% �����ֵ %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
PP_visibility = zeros(1,4*N*N);     % ��ʼ����ֵ��ɼ���
PP_uv_sample = zeros(1,4*N*N);      % ��ʼ����ֵ��uv����ƽ��
% ���հ뾶��ֵ
for k = 1:4*N
    index_old = 1+(0:num_radius-1)*4*N+k;
    v_old = PP_theta_interp_visibility(index_old);
    uvsample_old = PP_theta_interp_uvsample(index_old);
    [v_new,uvsample_new]= PP_radius_interp(v_old,uvsample_old,N,visibility(1));
    index_new = (k-1)*N+1:k*N;  %ȷ����ֵ��Ŀɼ������    
    PP_visibility(index_new) = v_new;
    PP_uv_sample(index_new) = uvsample_new;   
end 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%���ɼ��Ⱥ�������ΪBV��BH�ֿ�����%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
BV = zeros(2*N,N);
BH = zeros(2*N,N);
BV_uv =  zeros(2*N,N);
BH_uv = zeros(2*N,N);

for k = 1:N
     BH(N:-1:1,k) = PP_visibility((k-1)*N+1+2*N*N:k*N+2*N*N);          %��ֱ�����㣬���ų�2007���������Ƿ������ģ��� Create_Oversampled_Grid �����㷨����һ��
     BH_uv(N:-1:1,k) = PP_uv_sample((k-1)*N+1+2*N*N:k*N+2*N*N);
     BH(N+1:N+N,k) = PP_visibility((k-1)*N+1:k*N);
     BH_uv(N+1:N+N,k) = PP_uv_sample((k-1)*N+1:k*N); 
     BV(N:-1:1,k) =   PP_visibility((k-1)*N+1+3*N*N:k*N+3*N*N);  %ˮƽ�����㣬���ų�2007���������Ƿ������ģ��� Create_Oversampled_Grid �����㷨����һ��
     BV_uv(N:-1:1,k) = PP_uv_sample((k-1)*N+1+3*N*N:k*N+3*N*N);
     BV(N+1:N+N,k) = PP_visibility((k-1)*N+1+N*N:k*N+N*N);
     BV_uv(N+1:N+N,k) = PP_uv_sample((k-1)*N+1+N*N:k*N+N*N);      
end

PP_V = [BV,BH];
PP_uv = [BV_uv,BH_uv];

