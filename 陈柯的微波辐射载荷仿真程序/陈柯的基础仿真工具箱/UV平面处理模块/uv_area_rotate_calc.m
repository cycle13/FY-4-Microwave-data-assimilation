function [uv_area,uv_sample]= uv_area_rotate_calc(uvsample)

%   �������ܣ�������תԲ�����е�ÿ������������***********
%             
%  
%   �������:
%    uvsample   :     ��һ����������λ�ã���λ������
%   ���������
%    uv_area    :   ÿ���������Ӧ��uv�������    

%   by �¿� 2016.09.01  ******************************************************
[num_radius,num_theta] = size(uvsample);

radius = abs(uvsample(:,1));                             %ͬ��Բÿ���뾶����
theta = angle(uvsample(2,:));

theta_area = zeros(1,num_theta);
theta_area(1) =  (wrapToPi(abs(theta(1)-theta(num_theta)))+wrapToPi(abs(theta(2)-theta(1))))/2/(2*pi);
theta_area(num_theta) =  (wrapToPi(abs(theta(num_theta)-theta(num_theta-1)))+wrapToPi(abs(theta(1)-theta(num_theta))))/2/(2*pi);
for n = 2:(num_theta-1)
    theta_area(n) = (wrapToPi(abs(theta(n)-theta(n-1)))+wrapToPi(abs(theta(n+1)-theta(n))))/2/(2*pi);
end


% ��ʼ��uv_sample �� uvarea 
uv_sample = 0;                                           %��������[0 0]��
uv_area = pi*(radius(2)/2)^2;                            %��������[0 0]���Ӧ���������

%����ͬ��Բ˳�����ÿ��Բ�ϵ�uv���������겢���սǶ�����
for k = 2:num_radius
    %����ÿ��uv�������Ӧ���������
    if k == 2
       area = (pi*((radius(k+1) + radius(k))/2)^2 - pi*(radius(k)/2)^2).*theta_area;                   %�����һȦͬ��Բ������
    elseif k == num_radius
       area = (pi*((3*radius(k) - radius(k-1))/2)^2 - pi*((radius(k) + radius(k-1))/2)^2).*theta_area; %�������һȦͬ��Բ������
    else
       area = (pi*((radius(k+1) + radius(k))/2)^2 - pi*((radius(k) + radius(k-1))/2)^2).*theta_area;   %�����м�Ȧͬ��Բ������
    end
    %��ÿһȦ��uv�������������浽uv_sample �� uv_area��
    uv_sample = [uv_sample uvsample(k,:)];    
    uv_area =  [uv_area area];   
end

