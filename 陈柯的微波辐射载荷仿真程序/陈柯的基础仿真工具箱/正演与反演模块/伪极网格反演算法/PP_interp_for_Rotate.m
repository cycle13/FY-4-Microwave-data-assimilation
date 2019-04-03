function [PP_V,PP_uv,uv_area_rotate,uv_sample_rotate,redundancy] = PP_interp_for_Rotate(visibility,uvsample,N,uv_to_pi)
%   �������ܣ�   ʵ�ֶ���תԲ�����е�Բ��uv�����ɼ��Ⱥ�����ֵ��α������ֲ�**********************************
%               ���ز�ֵ��Ŀɼ��Ⱥ���ֵ��α������uv����          
%  
%   �������:
%   visibility      ��ȥ����ǰ����תԲ�����пɼ���
%   uv_sample       ��ȥ����ǰ����תԲ������uv����������,���հ뾶��С�������У��Ƕȴ�-pi~pi���У���Ϊ�Ƕȣ���Ϊ�뾶��
%   N               : α�������������ֵ���α������Ϊ2N*2N
%   uv_to_pi        ��uvƽ�桪2pi��һ��Ƶ��ƽ�������ת������
%   ���������
%    PP_V           ����ֵ���α������ɼ��Ⱥ���������PPFFT���������˳��BV��BH�ֿ����У�����2N*2N����
%    PP_uv          ��α�����������uv���꣬����-pi~pi��Χ��һ����Ҳ�ǰ���PPFFT���������˳��BV��BH�ֿ����У�����2N*2N����                          
%   by �¿� 2016.06.24  ******************************************************  

% Բ�����Ӧ��uvƽ������[0 0]Ϊ���ĵ���ɢͬ��Բ

%%%%%%%%%%��uv�����뾶�������򣬴�С����ȡ����ͬ�뾶�Ŀɼ��ȺͲ����ֲ�
uvsample_radius=mean(abs(uvsample),2);                       %uv����ͬ��Բ�İ뾶
[num_radius,num_theta] = size(uvsample);                  %�뾶����ÿȦ�Ƕ���������İ뾶�������� 
visibility_radius_sorted = zeros(num_radius,num_theta);   %��ʼ�������Ŀɼ��Ⱥ�uv����ƽ��
uvsample_radius_sorted = zeros(num_radius,num_theta);
[sorted_radius,radius_index]=sort(uvsample_radius);       %�԰뾶����
for k=1:1:num_radius                                      %���ݰ뾶˳������ɼ��Ⱥ�uv�����ֲ�
        uvsample_radius_sorted(k,:)=uvsample(radius_index(k),:);
        visibility_radius_sorted(k,:)=visibility(radius_index(k),:);
end
visibility = visibility_radius_sorted;
uvsample = uvsample_radius_sorted;
%�������------------------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% �ǶȲ�ֵ %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ��ʼ���ǶȲ�ֵ��ɼ�����uv����ƽ��
PP_theta_interp_visibility = zeros(num_radius,N*4);
PP_theta_interp_uvsample = zeros(num_radius,N*4);
redundancy_zero = 0;                                             
% ÿһȦ����ֵ��ͬ���ĽǶ���
for k = 1:num_radius
    v_old = visibility(k,:);
    uvsample_old = uvsample(k,:);    
    if abs(uvsample_old(1)==0)                                     %������㴦
       v_new =  mean(v_old)*ones(1,N*4);                          %�������ֵ��������ƽ��
       uvsample_new = zeros(1,N*4);
       redundancy_zero = redundancy_zero+num_theta;               %����ߵ������ 
    else    
     [v_new,uvsample_new] = PP_theta_interp(v_old,uvsample_old,N); %��ÿȦ���нǶȲ�ֵ
    end   
    PP_theta_interp_visibility(k,:) = v_new;
    PP_theta_interp_uvsample(k,:) = uvsample_new;    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%��ͬһ�뾶����ͬ�ǶȵĿɼ��Ⱥ���ֵ��������ƽ����Ȼ��ȥ��һЩ���÷ǳ�����ͬ��Բ
radius_redunt=sorted_radius;                        %������uv�����뾶
uvlength=UV_unique(radius_redunt);                  %ȥ����֮��õ���ͬ�İ뾶��С
num_radius_unique = length(uvlength)-1;             %��ͬ�뾶������
uv_radius_unique = zeros(num_radius_unique+1,N*4);  
v_radius_unique = zeros(num_radius_unique+1,N*4);
redundancy_unique = zeros(num_radius_unique+1,N*4);
for k =1:1:(num_radius_unique+1)                    %��ͬһ�뾶��ͬ��Բ���������ƽ������Ϊ�Ƕ�ֵ��ͬ
    index_number=[abs(radius_redunt-uvlength(k))<1e-4];
    uv_radius_unique(k,:) = mean(PP_theta_interp_uvsample(index_number,:),1);
    v_radius_unique(k,:) = mean(PP_theta_interp_visibility(index_number,:),1);
    redundancy_unique(k,:) = sum(index_number)*ones(1,N*4);
end
%����ԭʼ���߰뾶��С
uv_sample_unique = real(uv_radius_unique)/real(uv_to_pi)+1i*imag(uv_radius_unique)/imag(uv_to_pi);  %2pi��һ��Ƶ��ƽ�桪uvƽ������ת��
radius_unique = mean(abs(uv_sample_unique),2);
%�������ޣ�ȥ��һЩ���ķǳ����Ļ���
radius_threshold = 0.2;     %���߰뾶������ֵ��С�ڸ�ֵ�Ķ������߽�ֻ����һ��,��λ������
uv_radius_nonredunt = [uv_radius_unique(1,:)];
v_radius_nonredunt =  [v_radius_unique(1,:)];
redundancy  = [redundancy_zero];
for k =1:1:(num_radius_unique)                               %ȥ��һЩ���÷ǳ�����ͬ��Բ      
    if radius_unique(k+1)-radius_unique(k)>radius_threshold  %�뾶��ֵ          
        uv_radius_nonredunt = [uv_radius_nonredunt;uv_radius_unique(k+1,:)];
        v_radius_nonredunt = [v_radius_nonredunt;v_radius_unique(k+1,:)];  
        redundancy = [redundancy,redundancy_unique(k+1,:)];
    end    
end
num_radius_nonredunt = size(uv_radius_nonredunt,1)-1;
% baseline_radius = real(uv_radius_nonredunt(:,1))/real(uv_to_pi)+1i*imag(uv_radius_nonredunt(:,1))/imag(uv_to_pi); 
% % figure;stem(abs(baseline_radius),'fill');title('ȥ�����Ļ�������');
visibility = v_radius_nonredunt;    
uvsample = uv_radius_nonredunt;
%�뾶ȥ�������-------------------------------------------------------------

%�ԽǶȲ�ֵ���ͬ��Բuv��������ÿ�����������������ڼ�����תԲ�����еĵ�Ч���߷���ͼ
uvsample_real = real(uvsample)/real(uv_to_pi)+1i*imag(uvsample)/imag(uv_to_pi);  %2pi��һ��Ƶ��ƽ�桪uvƽ������ת��
[uv_area_rotate,uv_sample_rotate] = uv_area_rotate_calc(uvsample_real);


%%%%%%%%%% �����ֵ %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
PP_visibility = zeros(1,4*N*N);% ��ʼ����ֵ��ɼ���
PP_uv_sample = zeros(1,4*N*N); % ��ʼ����ֵ��uv����ƽ��
% ���հ뾶��ֵ
for k = 1:4*N
    v_old = visibility(2:num_radius_nonredunt,k).';
    uvsample_old = uvsample(2:num_radius_nonredunt,k).'; 
    [v_new,uvsample_new]= PP_radius_interp(v_old,uvsample_old,N,visibility(1,k));   %��ÿ���뾶���в�ֵ     
    index_new = (k-1)*N+1:k*N;                                                      %ȷ����ֵ��Ŀɼ������    
    PP_visibility(index_new) = v_new;
    PP_uv_sample(index_new) = uvsample_new;   
end 

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
     BV(N:-1:1,k) =   PP_visibility((k-1)*N+1+3*N*N:k*N+3*N*N);        %ˮƽ�����㣬���ų�2007���������Ƿ������ģ��� Create_Oversampled_Grid �����㷨����һ��
     BV_uv(N:-1:1,k) = PP_uv_sample((k-1)*N+1+3*N*N:k*N+3*N*N);
     BV(N+1:N+N,k) = PP_visibility((k-1)*N+1+N*N:k*N+N*N);
     BV_uv(N+1:N+N,k) = PP_uv_sample((k-1)*N+1+N*N:k*N+N*N);      
end

PP_V = [BV,BH];
PP_uv = [BV_uv,BH_uv];
