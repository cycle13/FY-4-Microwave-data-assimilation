function [PP_V,PP_uv] = PP_interp_debug(visibility,uvsample,num_radius,num_theta,N,Tb_modify,d_xi,d_eta,uv_to_DFT,uv_to_pi)
%   �������ܣ�   ʵ�ֶԾ���Բ�����е�Բ��uv�����ɼ��Ⱥ�����ֵ��α������ֲ�**********************************
%               ���ز�ֵ��Ŀɼ��Ⱥ���ֵ��α������uv���� 
%               �������԰汾���ڲ����и�����ʾ��ֵ���ȴ���
%  
%   �������:
%   visibility      ������Բ�����пɼ���
%   uvsample       �� ����Բ������uv����������
%   N               : α�������������ֵ���α������Ϊ2N*2N
%   Tb_modify       ����������ͼ�����������
%   uv_to_DFT,      ��uvƽ�桪DFTƽ�������ת������
%   uv_to_pi        ��uvƽ�桪2pi��һ��Ƶ��ƽ�������ת������
%   d_xi,d_eta      : ͼ��Ķ�ά������ߴ�
%   ���������
%   PP_V            ����ֵ���α������ɼ��Ⱥ���������PPFFT���������˳��BV��BH�ֿ����У�����2N*2N����
%   PP_uv           ��α�����������uv���꣬����-pi~pi��Χ��һ����Ҳ�ǰ���PPFFT���������˳��BV��BH�ֿ����У�����2N*2N����                          
%   by �¿� 2016.06.24  ******************************************************  

% Բ�����Ӧ��uvƽ������[0 0]Ϊ���ĵ���ɢͬ��Դ

%������ֵǰ������ɼ��Ⱥ�����ֵ�ֲ�%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
V_draw1 = zeros(num_theta,num_radius+1);
V_draw1(:,1) = visibility(1);
V_draw1(:,2:num_radius+1) = reshape(visibility(2:length(visibility)),num_theta,num_radius);
uv_draw1 = zeros(num_theta,num_radius+1);
uv_draw1(:,1) = uvsample(1);
uv_draw1(:,2:num_radius+1) = reshape(uvsample(2:length(uvsample)),num_theta,num_radius);
X = real(uv_draw1);
Y = imag(uv_draw1);
figure;h = pcolor(X,Y,abs(V_draw1));set( h, 'linestyle', 'none');title('ԭʼ�ɼ��ȷ�ֵ�ֲ�'); 

%%%%%%%%%% �ǶȲ�ֵ %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ��ʼ���ǶȲ�ֵ��ɼ�����uv����ƽ��
PP_theta_interp_visibility = zeros(1,1+N*4*num_radius);
PP_theta_interp_visibility(1) = visibility(1);
PP_theta_interp_uvsample = zeros(1,1+N*4*num_radius);
PP_theta_interp_uvsample(1) = uvsample(1);
%�ǶȲ�ֵ�������
angle_interp_rmse = zeros(1,num_radius);
uv_radius = zeros(1,num_radius+1);
% ��ֵ��ͬһ����λ����
for k = 1:num_radius
    index_old = (k-1)*num_theta+2:k*num_theta+1;
    v_old = visibility(index_old);
    uvsample_old = uvsample(index_old);
    [v_new,uvsample_new]= PP_theta_interp(v_old,uvsample_old,N); 
%%%%%%%%%%%%%%%%%%%%%%�Ա�ÿһ��ͬ��Բ�ϵĽǶȲ�ֵ�뾫ȷֵ�����%%%%%%%%%%%%%%%
    uv_sample_DFT = real(uvsample_new)/real(uv_to_pi)*real(uv_to_DFT)+1i*imag(uvsample_new)/imag(uv_to_pi)*imag(uv_to_DFT); % 2pi--uv--DFT ����ת��
    V_DFT = Brute_Force_Transform_DFT(Tb_modify,real(uv_sample_DFT),imag(uv_sample_DFT))*d_xi*d_eta;
%     figure;plot(abs(v_new),'-rs');hold on;plot(abs(V_DFT),'-b*'); title([num2str(k),'�ǶȲ�ֵ�ɼ�����׼ȷֵ�Ա�']) ; 
    angle_interp_rmse(k) = sqrt(sum(((real(V_DFT-v_new)).^2)/length(v_new)))+1i*sqrt(sum(((imag(V_DFT-v_new)).^2)/length(v_new)));
    uv_radius(k+1) = mean(abs(real(uvsample_new)/real(uv_to_pi)+1i*imag(uvsample_new)/imag(uv_to_pi)));   %����ÿһȦ�Ļ��߰뾶��С
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    index_new = (k-1)*N*4+2:k*N*4+1;                %ȷ����ֵ��Ŀɼ������ 
    PP_theta_interp_visibility(index_new) = v_new;
    PP_theta_interp_uvsample(index_new) = uvsample_new;    
end
%������ͬ�뾶Ȧ�ϵĽǶȲ�ֵ���
figure;semilogy(real(angle_interp_rmse),'-b*');hold on;semilogy(imag(angle_interp_rmse),'-ro');title('�ǶȲ�ֵ�ɼ���ģֵ���'); 
figure;stem(uv_radius,'fill');title('��������');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% �����ǶȲ�ֵ��Ŀɼ��Ⱥ���ģֵ�ֲ�%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
V_draw1 = zeros(4*N,num_radius+1);
V_draw1(:,1) = PP_theta_interp_visibility(1);
V_draw1(:,2:num_radius+1) = reshape(PP_theta_interp_visibility(2:length(PP_theta_interp_visibility)),4*N,num_radius);
uv_draw1 = zeros(4*N,num_radius+1);
uv_draw1(:,1) = PP_theta_interp_uvsample(1);
uv_draw1(:,2:num_radius+1) = reshape(PP_theta_interp_uvsample(2:length(PP_theta_interp_uvsample)),4*N,num_radius);
X = real(uv_draw1);
Y = imag(uv_draw1);
figure;h = pcolor(X,Y,abs(V_draw1));set( h, 'linestyle', 'none');title('�ǶȲ�ֵ��ԭʼ�ɼ���ģֵ�ֲ�'); 

%%%%%%%%%% �����ֵ %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
PP_visibility = zeros(1,4*N*N);     % ��ʼ����ֵ��ɼ���
PP_uv_sample = zeros(1,4*N*N);      % ��ʼ����ֵ��uv����ƽ��
radius_interp_rmse = zeros(4*N,N);  % �����ֵ�������
% ���հ뾶��ֵ
for k = 1:4*N
    index_old = 1+(0:num_radius-1)*4*N+k;
    v_old = PP_theta_interp_visibility(index_old);
    uvsample_old = PP_theta_interp_uvsample(index_old);
    [v_new,uvsample_new]= PP_radius_interp(v_old,uvsample_old,N,visibility(1));
    %�����ֵ���uv����������;�ȷ�ɼ���ֵ��Ȼ��Ͳ�ֵ�ɼ���ֵ�Աȣ��õ���ֵ���%%%%%%%%%%
    uv_sample_DFT = real(uvsample_new)/real(uv_to_pi)*real(uv_to_DFT)+1i*imag(uvsample_new)/imag(uv_to_pi)*imag(uv_to_DFT); % 2pi--uv--DFT ����ת��
    V_DFT = Brute_Force_Transform_DFT(Tb_modify,real(uv_sample_DFT),imag(uv_sample_DFT))*d_xi*d_eta;
%         figure;plot(abs(uvsample_new(2:N)),real(v_new(2:N)),'-rs');hold on;plot(abs(uvsample_new(2:N)),real(V_DFT(2:N)),'-b*');hold on;
%         plot(abs(uvsample_old),real(v_old),'-go');title([num2str(k),'���߾����ֵ�ɼ����뾫ȷֵʵ��']);
%         figure;plot(abs(uvsample_new(2:N)),imag(v_new(2:N)),'-rs');hold on;plot(abs(uvsample_new(2:N)),imag(V_DFT(2:N)),'-b*');
%         plot(abs(uvsample_old),imag(v_old),'-go');title([num2str(k),'���߾����ֵ�ɼ����뾫ȷֵ�鲿']);      
    if k<=2*N
        radius_interp_rmse(k,:) =v_new-V_DFT; %         
    else
        radius_interp_rmse(k,2:N) =v_new(1:N-1)-V_DFT(1:N-1); %         
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    index_new = (k-1)*N+1:k*N;  %ȷ����ֵ��Ŀɼ������    
    PP_visibility(index_new) = v_new;
    PP_uv_sample(index_new) = uvsample_new;   
end 
%����α������ͬ���η����ϵľ����ֵ���
realpart = abs(real(radius_interp_rmse));imagpart = abs(imag(radius_interp_rmse));
mrealpart = mean(realpart,1);mimagpart = mean(imagpart,1);
figure;semilogy(mrealpart,'-b*');hold on;semilogy(mimagpart,'-ro');title('�����ֵ�ɼ���ʵ�����鲿���');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%���������ֵ��Ŀɼ��Ⱥ���ģֵ�ֲ�
V_resample = reshape(PP_visibility,N,4*N);
uv_resample = reshape(PP_uv_sample,N,4*N);
V_draw = zeros(4*N,N);
uv_draw = zeros(4*N,N);
V_draw(1:2*N,1:N) = V_resample(1:N,1:2*N).';
uv_draw(1:2*N,1:N) = uv_resample(1:N,1:2*N).';
V_draw(2*N+1:4*N,2:N) = V_resample(1:N-1,2*N+1:4*N).';
uv_draw(2*N+1:4*N,2:N) = uv_resample(1:N-1,2*N+1:4*N).';  
V_draw(2*N+1:4*N,1) = V_resample(1,1:2*N).';
X = real(uv_draw);
Y = imag(uv_draw);
figure;h = pcolor(X,Y,abs(V_draw));set( h, 'linestyle', 'none');title('�����ֵ��ԭʼ�ɼ���ģֵ�ֲ�'); 

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

