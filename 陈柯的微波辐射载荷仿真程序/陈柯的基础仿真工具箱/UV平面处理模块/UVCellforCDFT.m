function [uv_sample,uv_area]= UVCellforCDFT(ant_pos)

%   �������ܣ�����Բ��˳��������Բ�����е�uv�����������ÿ������������***********
%             ����Բ�����е�uv�����ֲ�����[0 0]Ϊ���ĵ���ɢͬ��Բ
%  
%   �������:
%    ant_pos  :     ��һ����������λ�ã���λ������
%   ���������
%    uv_sample  :   ����Բ�����ж�Ӧ��uvƽ����������꣬һά������ֵ��ʵ��u�ᣬ�鲿v�ᣬ��һ��Ԫ��Ϊԭ�㣬Ȼ����Բ�ܰ뾶����˳��洢
%    uv_area    :   ÿ���������Ӧ��uv�������    

%   by �¿� 2016.06.24  ******************************************************
ant_num = size(ant_pos,2);  %�������߸���
if mod(ant_num,2) == 0   %ż��������
       num_radius = ant_num/2; num_theta = ant_num; %����Բ����Ԫ������UV������뾶������ÿȦ��������
else                     %����������    
       num_radius = (ant_num-1)/2; num_theta = 2*ant_num;
end
radius_index = 2:(num_radius+1) ;                        %����뾶�����߱��
radius = abs(ant_pos(radius_index)-ant_pos(1));          %ͬ��Բÿ���뾶����
start_angle = angle(ant_pos(radius_index)-ant_pos(1));   %ͬ��ԲÿȦ��ʼλ��

% ��ʼ��uv_sample �� uvarea 
uv_sample = 0;                                           %��������[0 0]��
uv_area = pi*(radius(1)/2)^2;                            %��������[0 0]���Ӧ���������
step_angle = (0:num_theta-1)*2*pi/num_theta;             %ÿһȦ�ϵĽǶȼ��

%����ͬ��Բ˳�����ÿ��Բ�ϵ�uv���������겢���սǶ�����
for k = 1:num_radius
    current_radius = radius(k);                          %��ǰͬ��Բ�İ뾶              
    current_start_angle = start_angle(k);                %��ǰͬ��Բ��ʼ��
    %��ÿһȦUV�����㰴�սǶ����򣬴ӣ�-pi��--pi��ʱ������
    current_angle = wrapToPi(current_start_angle+step_angle);
    sorted_angle =  sort(current_angle,2,'ascend');     
    current_uv = current_radius*exp(1i*sorted_angle);    %��ǰͬ��Բuv����
    %����ÿ��uv�������Ӧ���������
    if k == 1
       area = (pi*((radius(k+1) + radius(k))/2)^2 - pi*(radius(k)/2)^2)/num_theta;                   %�����һȦͬ��Բ������
    elseif k == num_radius
       area = (pi*((3*radius(k) - radius(k-1))/2)^2 - pi*((radius(k) + radius(k-1))/2)^2)/num_theta; %�������һȦͬ��Բ������
    else
       area = (pi*((radius(k+1) + radius(k))/2)^2 - pi*((radius(k) + radius(k-1))/2)^2)/num_theta;   %�����м�Ȧͬ��Բ������
    end
    current_uvarea = area*ones(1,num_theta);
    %��ÿһȦ��uv�������������浽uv_sample �� uvarea��
    uv_sample = [uv_sample current_uv];    
    uv_area =  [uv_area current_uvarea];   
end

