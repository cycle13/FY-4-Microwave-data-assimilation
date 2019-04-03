function angle_info = Transform_cosine_coordinate(xi,eta)
%   �������ܣ��ռ�����ת������һ����ά�ռ䷽λ��������ת�����Ƕ�����**********
%            
%  
%   �������:
%    xi             ����ά�ռ��ÿ�����صĦ��������         
%    eta            ����ά�ռ��ÿ�����صĦ��������
%   ���������
%    angle_info     : ת����Ķ�ά�ռ�ÿ�����صķ�λ�Ǧպ���׽Ǧ� ���Ը�����ʽ�������+i��                                     
%   by �¿� 2016.06.24  ******************************************************  
[row,col] = size(xi);
angle_info = zeros(row,col);
theta = zeros(row,col);
phy = zeros(row,col);
for m=1:1:row
    for n=1:1:col
        theta(m,n)=asind(sqrt(xi(m,n)^2+eta(m,n)^2));
        phy(m,n) = angle(xi(m,n)+1i*eta(m,n))*180/pi;
        angle_info(m,n) = theta(m,n)+1i*phy(m,n);
    end
end