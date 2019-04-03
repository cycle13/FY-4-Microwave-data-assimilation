function  angle = vector_angle_calc(theta_axis,phi_axis,theta,phi)
%   �������ܣ�����������ϵ��һ���ο�������һ����������֮��ļн�**********************************
%            ���ؼнǾ���
%  
%   �������:
%    theta_axis ���ο��������춥��
%    phi_axis   ���ο������ķ�λ��
%    theta      : ����������춥��
%    phi        : ��������ķ�λ��
%   ���������
%    angle      : �нǾ���                                       
%   by �¿� 2016.09.24  ******************************************************
[num_row,num_col] = size(theta);
angle = zeros(num_row,num_col);
axis = [sind(theta_axis)*cosd(phi_axis);sind(theta_axis)*sind(phi_axis);cosd(theta_axis)];
x = sind(theta).*cosd(phi);
y = sind(theta).*sind(phi);
z = cosd(theta);
for row = 1:num_row
    for col = 1:num_col
        if isnan(theta(row,col))
            angle(row,col) = NaN;
        else
            coordinate = [x(row,col);y(row,col);z(row,col)]; 
            dot_product = dot(axis,coordinate);
            if dot_product>1
               dot_product =1; 
            end
            angle(row,col) = acosd(dot_product);  
        end
    end
end




