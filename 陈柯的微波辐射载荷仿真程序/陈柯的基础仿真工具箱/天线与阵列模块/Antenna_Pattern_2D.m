function Antenna_norm_G = Antenna_Pattern_2D(antenna_type,antenna_size,angle_info)
%   %   �������ܣ�
%   �������ߵ���״�ͳߴ磬��ʽ��������ָ���ռ䷽���ϵĹ�һ��(���ֵΪ1)���߹��ʷ���ͼ
%  
%   �������: 
%     antenna_type   ��������״�������¼��������ѡ
%         'isotropic'  ���룬���������Ϊ1
%         'rectangle'   ���ο���
%         'circle'     Բ�ο���
%    antenna_size    �����߳ߴ磬�Ѿ��Բ�����һ���ĵ糤�ȣ���λ������
%    angle_info      ���Ƕ���Ϣ����������Щ�Ƕȵķ���ͼ��������3�����
%
%         
%   ���������
%   Antenna_norm_G  : ָ���Ƕȵ����߹�һ������ͼ


%   ��Ȩ���У��¿£�����ѧԺ�����пƼ���ѧ.
%   $�汾��: 1.0 $  $Date: 2016/06/30 $
[row,col] = size(angle_info);
Antenna_G = zeros(row,col);
switch lower(antenna_type)
    case 'rectangle'      % ���ο���
       lx = pi*antenna_size(1);
       ly = pi*antenna_size(2);            
       theta = real(angle_info);
       phy = imag(angle_info);
       for m = 1:row
           for n =1:col
               xi = sind(theta(m,n))*cosd(phy(m,n));
               eta = sind(theta(m,n))*sind(phy(m,n));
               Antenna_G = abs(sinc(lx*xi)*sinc(ly*eta))^2;
            end
       end
       Antenna_norm_G=Antenna_G/max(max(Antenna_G));
       %�������߽���

     case'isotropic'%���룬���������Ϊ1
       Antenna_norm_G = ones(row,col);
            %�������߽���

     case'circle'%Բ�ο���
       Ba = 2*pi*antenna_size;
       theta = real(angle_info);
       for m = 1:row
           for n =1:col   
                if(sind(theta(m,n))<=1e-5)  %�����ĸΪ0ʱ����
                    Antenna_G(m,n) = Antenna_G(m-1,n);
                else
                    Antenna_G(m,n) = abs((2* factorial(1)*besselj(1,(Ba*sind(theta(m,n))))/((Ba*sind(theta(m,n)))^(1)))^2);                    
                end
           end
       end
       Antenna_norm_G=Antenna_G/max(max(Antenna_G));
            %Բ�����߽���
end



