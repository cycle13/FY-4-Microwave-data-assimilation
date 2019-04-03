function  Antenna_G = circular_antenna_pattern_2D(Fov_scope,N_y,N_x,Ba,taper)
%������ʵ��Բ�οھ����ߵĹ�һ����ά����ͼ����
%Fov_scope��Ҫ����ķ���ͼ��Χ����λ���Ƕȣ�N_y,N_x����ά����ķ���ͼ������Ba�����߲���pi*�ھ�/������taper���ھ�����ϵ��
   
   Antenna_G = zeros(N_y,N_x);
   pix_angle_y = linspace(Fov_scope(1,1),Fov_scope(1,2),N_y);   %γ�ȿռ����꣬��λ���Ƕ�
   pix_angle_x = linspace(Fov_scope(2,1),Fov_scope(2,2),N_x);   %���ȿռ����꣬��λ���Ƕ�
   
   for num_row = 1:N_y
        for num_col = 1: N_x
            %���λ��
            pix_point = pix_angle_x(num_col)+1i*pix_angle_y(num_row);
            if (abs(pix_point/90)<=1)
                theta = abs(pix_point);
                %����ָ���Ӧ��λ���ӳ���Χ�ڵķ�������߷���ͼ 
               if(sind(theta)<=1e-6)  %�����ĸΪ0ʱ����
                   Antenna_G(num_row,num_col) = 1;
               else
                   Antenna_G(num_row,num_col) = abs((2^(taper+1)* factorial(taper+1)*besselj(taper+1,(Ba*sind(abs(theta))))/((Ba*sind(abs(theta)))^(taper+1)))^2);
               end
            end
        end
   end
   
   Antenna_G=Antenna_G/sum(sum(Antenna_G));