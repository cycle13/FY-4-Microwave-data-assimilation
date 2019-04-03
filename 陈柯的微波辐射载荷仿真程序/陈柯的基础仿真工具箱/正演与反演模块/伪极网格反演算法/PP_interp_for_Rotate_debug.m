function [PP_V,PP_uv,uv_area_rotate,uv_sample_rotate] = PP_interp_for_Rotate_debug(visibility,uvsample,N,Tb_modify,d_xi,d_eta,uv_to_DFT,uv_to_pi)
%   �������ܣ�   ʵ�ֶ���תԲ�����е�Բ��uv�����ɼ��Ⱥ�����ֵ��α������ֲ�**********************************
%               ���ز�ֵ��Ŀɼ��Ⱥ���ֵ��α������uv���� 
%               debug���԰汾���ڲ����и�����ʾ��ֵ���ȴ���
%  
%   �������:
%   visibility      ��ȥ����ǰ����תԲ�����пɼ���
%   uvsample       ��ȥ����ǰ����תԲ������uv����������,���հ뾶��С�������У���Ϊ�Ƕȣ���Ϊ�뾶��
%   N               : α�������������ֵ���α������Ϊ2N*2N
%   Tb_modify       ����������ͼ�����������
%   uv_to_DFT,      ��uvƽ�桪DFTƽ�������ת������
%   uv_to_pi        ��uvƽ�桪2pi��һ��Ƶ��ƽ�������ת������
%   d_xi,d_eta      : ͼ��Ķ�ά������ߴ�
%   ���������
%   PP_V            ����ֵ���α������ɼ��Ⱥ���������PPFFT���������˳��BV��BH�ֿ����У�����2N*2N����
%   PP_uv           ��α�����������uv���꣬����-pi~pi��Χ��һ����Ҳ�ǰ���PPFFT���������˳��BV��BH�ֿ����У�����2N*2N����                          
%   by �¿� 2016.06.24  ******************************************************  

% Բ�����Ӧ��uvƽ������[0 0]Ϊ���ĵ���ɢͬ��Բ

%%%%%%%%%%��uv�����뾶�������򣬴�С����ȡ����ͬ�뾶�Ŀɼ��ȺͲ����ֲ�
uvsample_radius=abs(uvsample(:,1));                       %uv����ͬ��Բ�İ뾶
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

%%%%%%%%%% �ǶȲ�ֵ %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ��ʼ���ǶȲ�ֵ��ɼ�����uv����ƽ��
PP_theta_interp_visibility = zeros(num_radius,N*4);
PP_theta_interp_uvsample = zeros(num_radius,N*4);
redundancy_zero = 0;                                             
% ��ֵ��ͬһ����λ����
for k = 1:num_radius
    v_old = visibility(k,:);
    uvsample_old = uvsample(k,:);    
    if abs(uvsample_old(1)==0)
       v_new =  v_old(1).*ones(1,N*4);
       uvsample_new = uvsample_old(1).*ones(1,N*4);
       redundancy_zero = redundancy_zero+num_theta;                        %����ߵ������
    else    
     [v_new,uvsample_new] = PP_theta_interp(v_old,uvsample_old,N); 
    end    
%%%%%%%%%%%%�Ա�ÿһ��ͬ��Բ�ϵĽǶȲ�ֵ�뾫ȷֵ�����%%%%%%%%%%%%%%%%%%%%%%%%
%     uv_sample_DFT = real(uvsample_new)/real(uv_to_pi)*real(uv_to_DFT)+1i*imag(uvsample_new)/imag(uv_to_pi)*imag(uv_to_DFT); % 2pi--uv--DFT ����ת��
%     V_DFT = Brute_Force_Transform_DFT(Tb_modify,real(uv_sample_DFT),imag(uv_sample_DFT))*d_xi*d_eta;
%     figure;plot(abs(v_new),'-rs');hold on;plot(abs(V_DFT),'-b*'); title([num2str(k),'�ǶȲ�ֵ�ɼ�����׼ȷֵ�Ա�']) ;      
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    PP_theta_interp_visibility(k,:) = v_new;
    PP_theta_interp_uvsample(k,:) = uvsample_new;    
end 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%��ͬһ�뾶��ͬ��Բ����ƽ����Ȼ��ȥ��һЩ���÷ǳ�����ͬ��Բ%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
radius_redunt=sorted_radius;                        %������uv�����뾶
uvlength=UV_unique(radius_redunt);                 %ȥ����֮��õ���ͬ�İ뾶��С
num_radius_unique = length(uvlength)-1;             %��ͬ�뾶������
uv_radius_unique = zeros(num_radius_unique+1,N*4);  
v_radius_unique = zeros(num_radius_unique+1,N*4);
redundancy_unique = zeros(num_radius_unique+1,N*4);
%�ǶȲ�ֵ���uv����������;�ȷ�ɼ���ֵ���Լ��洢��ֵ��������
uv_sample_DFT = zeros(num_radius_unique+1,N*4);
V_DFT = zeros(num_radius_unique+1,N*4);
angle_rmse = zeros(num_radius_unique+1,1);
for k =1:1:(num_radius_unique+1)                    %��ͬһ�뾶��ͬ��Բ���������ƽ������Ϊ�Ƕ�ֵ��ͬ
    index_number=[radius_redunt==uvlength(k)];
    uv_radius_unique(k,:) = mean(PP_theta_interp_uvsample(index_number,:),1);
    v_radius_unique(k,:) = mean(PP_theta_interp_visibility(index_number,:),1); 
    redundancy_unique(k,:) = sum(index_number)*ones(1,N*4);
    %�ǶȲ�ֵ���uv����������;�ȷ�ɼ���ֵ��Ȼ��Ͳ�ֵ�ɼ���ֵ�Աȣ��õ���ֵ���%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    uv_sample_DFT(k,:) = real(uv_radius_unique(k,:))/real(uv_to_pi)*real(uv_to_DFT)+1i*imag(uv_radius_unique(k,:))/imag(uv_to_pi)*imag(uv_to_DFT); % 2pi--uv--DFT ����ת��
    V_DFT(k,:) = Brute_Force_Transform_DFT(Tb_modify,real(uv_sample_DFT(k,:)),imag(uv_sample_DFT(k,:)))*d_xi*d_eta; 
    angle_rmse(k) = sqrt(sum(((real(V_DFT(k,:)-v_radius_unique(k,:))).^2)/(N*4)))+1i*sqrt(sum(((imag(V_DFT(k,:)-v_radius_unique(k,:))).^2)/(N*4))); 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
%������ͬ�뾶Ȧ�ϵĽǶȲ�ֵ���
figure;semilogy(real(angle_rmse),'-b*');hold on;semilogy(imag(angle_rmse),'-ro');title(' �ǶȲ�ֵ�ɼ���ʵ�����鲿���');
%����ԭʼ���߰뾶��С��������ԭʼ��������
uv_sample_unique = real(uv_radius_unique)/real(uv_to_pi)+1i*imag(uv_radius_unique)/imag(uv_to_pi);  %2pi��һ��Ƶ��ƽ�桪uvƽ������ת��
radius_unique = abs(uv_sample_unique(:,1));
figure;stem(radius_unique,'fill');title('ԭʼ��������');
%�������ޣ�ȥ��һЩ���ķǳ����Ļ���
radius_threshold = 0.2;     %���߰뾶������ֵ��С�ڸ�ֵ�Ķ������߽�ֻ����һ��,��λ������
uv_radius_nonredunt = uv_radius_unique(1,:);
v_radius_nonredunt =  v_radius_unique(1,:);
redundancy  = [redundancy_zero];
for k =1:1:(num_radius_unique)                               %ȥ��һЩ���÷ǳ�����ͬ��Բ      
    if radius_unique(k+1)-radius_unique(k)>radius_threshold  %�뾶��ֵ        
        uv_radius_nonredunt = [uv_radius_nonredunt;uv_radius_unique(k+1,:)];
        v_radius_nonredunt = [v_radius_nonredunt;v_radius_unique(k+1,:)];  
        redundancy = [redundancy,redundancy_unique(k+1,:)];
    end    
end
num_radius_nonredunt = size(uv_radius_nonredunt,1)-1;
%�õ�ȥ�����Ļ��߰뾶��С������
baseline_radius = real(uv_radius_nonredunt(:,1))/real(uv_to_pi)+1i*imag(uv_radius_nonredunt(:,1))/imag(uv_to_pi); 
figure;stem(abs(baseline_radius),'fill');title('ȥ�����Ļ�������');
visibility = v_radius_nonredunt;    
uvsample = uv_radius_nonredunt;
%�뾶ȥ�������-------------------------------------------------------------%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%�ԽǶȲ�ֵ���ͬ��Բuv��������ÿ�����������������ڼ�����תԲ�����еĵ�Ч���߷���ͼ
uvsample_real = real(uvsample)/real(uv_to_pi)+1i*imag(uvsample)/imag(uv_to_pi);  %2pi��һ��Ƶ��ƽ�桪uvƽ������ת��
[uv_area_rotate,uv_sample_rotate] = uv_area_rotate_calc(uvsample_real);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% �����ǶȲ�ֵ��Ŀɼ��Ⱥ���ģֵ�ֲ�
X = real(uvsample.');
Y = imag(uvsample.');
figure;h = pcolor(X,Y,abs(visibility.'));set( h, 'linestyle', 'none');title('�ǶȲ�ֵ��ԭʼ�ɼ���ģֵ�ֲ�');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%% �����ֵ %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
PP_visibility = zeros(1,4*N*N);% ��ʼ����ֵ��ɼ���
PP_uv_sample = zeros(1,4*N*N); % ��ʼ����ֵ��uv����ƽ��
interp_rmse = zeros(4*N,N);
% ���հ뾶��ֵ
for k = 1:4*N
    v_old = visibility(2:num_radius_nonredunt,k).';
    uvsample_old = uvsample(2:num_radius_nonredunt,k).';
    [v_new,uvsample_new]= PP_radius_interp(v_old,uvsample_old,N,visibility(1,k)); 
    %�����ֵ���uv����������;�ȷ�ɼ���ֵ��Ȼ��Ͳ�ֵ�ɼ���ֵ�Աȣ��õ���ֵ���%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    uv_sample_DFT = real(uvsample_new)/real(uv_to_pi)*real(uv_to_DFT)+1i*imag(uvsample_new)/imag(uv_to_pi)*imag(uv_to_DFT);
    V_DFT = Brute_Force_Transform_DFT(Tb_modify,real(uv_sample_DFT),imag(uv_sample_DFT))*d_xi*d_eta;
%         figure;plot(abs(uvsample_new(2:N)),real(v_new(2:N)),'-rs');hold on;plot(abs(uvsample_new(2:N)),real(V_DFT(2:N)),'-b*');hold on;
%         plot(abs(uvsample_old),real(v_old),'-go');title([num2str(k),'���߾����ֵ�ɼ����뾫ȷֵʵ��']);
%         figure;plot(abs(uvsample_new(2:N)),imag(v_new(2:N)),'-rs');hold on;plot(abs(uvsample_new(2:N)),imag(V_DFT(2:N)),'-b*');
%         plot(abs(uvsample_old),imag(v_old),'-go');title([num2str(k),'���߾����ֵ�ɼ����뾫ȷֵ�鲿']);         
    if k<=2*N
        interp_rmse(k,:) =v_new-V_DFT; %         
    else
        interp_rmse(k,2:N) =v_new(1:N-1)-V_DFT(1:N-1); %         
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    index_new = (k-1)*N+1:k*N;  %ȷ����ֵ��Ŀɼ������    
    PP_visibility(index_new) = v_new;
    PP_uv_sample(index_new) = uvsample_new;   
end 
%����α������ͬ���η����ϵľ����ֵ���
realpart = abs(real(interp_rmse));imagpart = abs(imag(interp_rmse));
mrealpart = mean(realpart,1);mimagpart = mean(imagpart,1);
figure;semilogy(mrealpart,'-b*');hold on;semilogy(mimagpart,'-ro');title('�����ֵ�ɼ���ʵ�����鲿���');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
