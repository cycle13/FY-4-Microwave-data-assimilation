function [uvsample,redundancy,uv_area] = Visibility2D_uvsample_nonredunt(uvsample_redunt,array_type,ant_pos,N)
%   �������ܣ�ȥ��UVƽ����������㣬�õ�����ƽ���ɼ��Ⱥ��������**********************************% 
%             ����Ǿ���Բ�����У��������ÿ��uv�����������
%  
%   �������:
%    V_redunt       ������Ŀɼ��Ⱥ��� 
%    uvsample_redunt�������uv����ƽ������
%    array_type     ����������
%    ant_pos        ������λ��
%   ���������
%    V_nonredunt    : ����ƽ����Ŀɼ��Ⱥ��� 
%    uvsample       : ȥ������uv����ƽ�����꣬��V_nonreduntλ�ö�Ӧ
%    redundancy_sum : ����ϵ������ÿ������������ȵĵ����� 
%    uv_area        : ÿ��uv�������������ֻ�Ծ���Բ������������
%   by �¿� 2016.06.24  ******************************************************

%%%%%%%%%%%%%%%%%%%%%%%%%��תԲ������ʹ�ýǶȲ�ֵ���uvsample
if (strcmpi('O_Rotate_shape',array_type))   
    %%%%%%%%%%��uv�����뾶�������򣬴�С����ȡ����ͬ�뾶�Ŀɼ��ȺͲ����ֲ�
    uvsample_radius=mean(abs(uvsample_redunt),2);             %uv����ͬ��Բ�İ뾶
    [num_radius,num_theta] = size(uvsample_redunt);           %�뾶����ÿȦ�Ƕ���������İ뾶�������� 
    uvsample_radius_sorted = zeros(num_radius,num_theta);
    [sorted_radius,radius_index]=sort(uvsample_radius);       %�԰뾶����
    for k=1:1:num_radius                                      %���ݰ뾶˳������ɼ��Ⱥ�uv�����ֲ�
        uvsample_radius_sorted(k,:)=uvsample_redunt(radius_index(k),:);
    end
    uvsample = uvsample_radius_sorted;
    %�������-
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% �ǶȲ�ֵ %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % ��ʼ���ǶȲ�ֵ��ɼ�����uv����ƽ��
    PP_theta_interp_uvsample = zeros(num_radius,N*4);
    redundancy_zero = 0;                                             
    % ÿһȦ����ֵ��ͬ���ĽǶ���
    for k = 1:num_radius    
        uvsample_old = uvsample(k,:);    
        if abs(uvsample_old(1)==0)                                     %������㴦       
           uvsample_new = zeros(1,N*4);
           redundancy_zero = redundancy_zero+num_theta;               %����ߵ������
        else    
           [uvsample_new] = PP_theta_uvsample(uvsample_old,N); %��ÿȦ���нǶȲ�ֵ
        end   
       PP_theta_interp_uvsample(k,:) = uvsample_new;    
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%��ͬһ�뾶����ͬ�ǶȵĿɼ��Ⱥ���ֵ��������ƽ����Ȼ��ȥ��һЩ���÷ǳ�����ͬ��Բ
    radius_redunt=sorted_radius;                        %������uv�����뾶
    uvlength=UV_unique(radius_redunt);                  %ȥ����֮��õ���ͬ�İ뾶��С
    num_radius_unique = length(uvlength)-1;             %��ͬ�뾶������
    uv_radius_unique = zeros(num_radius_unique+1,N*4);  
    redundancy_unique = zeros(num_radius_unique+1,N*4);
    for k =1:1:(num_radius_unique+1)                    %��ͬһ�뾶��ͬ��Բ���������ƽ������Ϊ�Ƕ�ֵ��ͬ
        index_number=[abs(radius_redunt-uvlength(k))<1e-4];
        uv_radius_unique(k,:) = mean(PP_theta_interp_uvsample(index_number,:),1);
        redundancy_unique(k,:) = sum(index_number)*ones(1,N*4);
    end
    %�������ޣ�ȥ��һЩ���ķǳ����Ļ���
    radius_unique = mean(abs(uv_radius_unique),2);
    radius_threshold = 0.2;     %���߰뾶������ֵ��С�ڸ�ֵ�Ķ������߽�ֻ����һ��,��λ������
    uv_radius_nonredunt = [uv_radius_unique(1,:)];
    redundancy  = [redundancy_zero];
    for k =1:1:(num_radius_unique)                               %ȥ��һЩ���÷ǳ�����ͬ��Բ      
        if radius_unique(k+1)-radius_unique(k)>radius_threshold  %�뾶��ֵ          
            uv_radius_nonredunt = [uv_radius_nonredunt;uv_radius_unique(k+1,:)];
            redundancy = [redundancy,redundancy_unique(k+1,:)];
        end    
    end
    % baseline_radius = real(uv_radius_nonredunt(:,1))/real(uv_to_pi)+1i*imag(uv_radius_nonredunt(:,1))/imag(uv_to_pi); 
    % % figure;stem(abs(baseline_radius),'fill');title('ȥ�����Ļ�������');
    %�뾶ȥ�������-------------------------------------------------------------
    %�ԽǶȲ�ֵ���ͬ��Բuv��������ÿ�����������������ڼ�����תԲ�����еĵ�Ч���߷���ͼ
    [uv_area,uvsample] = uv_area_rotate_calc(uv_radius_nonredunt);    
    
%%%%%%%%%%%%%%%%%%%%%%%%%Բ������ȥ��������㼰�ɼ��Ⱥ�����ƽ��
else if (strcmpi('O_shape',array_type))     
        [uvsample,uv_area] = UVCellforCDFT(ant_pos);
        num_redunt = size(uvsample_redunt);
        redundancy = zeros(1,length(uvsample));    
        threshold = 1e-6;    
        for k = 1:1:num_redunt
            u = real(uvsample_redunt(k));
            v = imag(uvsample_redunt(k));
            position = find(abs(real(uvsample)-u)<threshold & abs(imag(uvsample)-v)<threshold);
            redundancy(position) = redundancy(position)+1;
        end                    
     
%%%%%%%%%%%%%%%%%%%%%%%%%�������������������ȥ��������㼰�ɼ��Ⱥ�����ƽ��        
    else                                     
        uvsample=UV_unique(uvsample_redunt);
        num_redunt = size(uvsample_redunt);
        redundancy = zeros(1,length(uvsample));    
        threshold = 1e-6;    
        for k = 1:1:num_redunt
            u = real(uvsample_redunt(k));
            v = imag(uvsample_redunt(k));
            position = find(abs(real(uvsample)-u)<threshold & abs(imag(uvsample)-v)<threshold);
            redundancy(position) = redundancy(position)+1;            
        end                                   
     end
end





