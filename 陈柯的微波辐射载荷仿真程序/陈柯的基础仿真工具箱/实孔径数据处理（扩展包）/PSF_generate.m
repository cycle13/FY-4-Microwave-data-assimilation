function PSF = PSF_generate(angle,col_num,row_num,d_sample,Ba,q)
%�������������򻯷��������Ҫ�ĵ���չ����PSF
%angel:�Ƕȷ�Χ��col_num,row_num�������ͼ������ص�����Ba�����߲��� = pi*�ھ�/������
%q����������taper��d_sample�������Ƕȼ��
PSF = zeros(row_num,col_num);
col_cordinator = zeros(1,row_num);
Fov_scope = [-angle angle];
col_antenna_num = 2*col_num-1;
col = linspace(Fov_scope(1),Fov_scope(2),col_antenna_num); 
Antenna_pattern = zeros(1,col_antenna_num);

for col_index = 1:col_antenna_num
    theta = abs(col(col_index));  
    if(sind(theta)<=0.00001)  %�����ĸΪ0ʱ����
        Antenna_pattern(col_index) = 1;
    else
        Antenna_pattern(col_index) = abs((2^(q+1)* factorial(q+1)*besselj(q+1,(Ba*sind(abs(theta))))/((Ba*sind(abs(theta)))^(q+1)))^2);
    end                
end 

for i = 1:row_num
    delta_angle=(i-1)*(d_sample);
    col_cordinator(i) = min(round(delta_angle/angle*col_num)+1,col_num);    
end

for i=1:row_num 
    col_Antenna_start = col_num+1-col_cordinator(i);
    col_Antenna_end = col_Antenna_start+col_num-1;       
    Antenna = Antenna_pattern(1,col_Antenna_start:col_Antenna_end);              
    PSF(i,:) = Antenna/sum(Antenna);            
end