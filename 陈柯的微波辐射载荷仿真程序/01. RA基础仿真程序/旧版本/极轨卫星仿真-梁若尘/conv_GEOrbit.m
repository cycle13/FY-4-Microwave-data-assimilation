function [ TA ] = conv_GEOrbit( TB,SateZenith_angle_TA,SateZenith_angle_TB,Ba,q,factor)
%
%
[TA_num_Latitude,TA_num_Longitude] = size(SateZenith_angle_TA);                                                           %TA����
[num_Latitude,num_Longitude] = size(SateZenith_angle_TB);                                                                 %TB����
TA = zeros(TA_num_Latitude,TA_num_Longitude);


switch q
    case 0
    null_beam_width=0.187*factor;
    case 1
    null_beam_width=0.251*factor;
    case 2
    null_beam_width=0.312*factor;
    case 3
    null_beam_width=0.371*factor;
    case 4
    null_beam_width=0.428*factor;
end

matlabpool open ;
parfor num_sample_Latitude=1:TA_num_Latitude
    for num_sample_Longitude=1:TA_num_Longitude  
% for num_sample_Latitude=7
%     for num_sample_Longitude=7
pattern = zeros(num_Latitude,num_Longitude);                                                                %��ʼ������ͼ
theta_1 = imag(SateZenith_angle_TA(num_sample_Latitude,num_sample_Longitude))*pi/180;                                %ָ����γ�ȵ�����ɨ��Ƕ�
phi_1 = real(SateZenith_angle_TA(num_sample_Latitude,num_sample_Longitude))*pi/180;                          
% Latitude_start = Lat(num_sample_Latitude,num_sample_Longitude);                                             %��ȡ����TA������ϢXXX
% Longitude_start= Long(num_sample_Latitude,num_sample_Longitude);                                            %��ȡ����TAγ����ϢXXX
% if (min(min(Lat))<Latitude_start)&& (Latitude_start<max(max(Lat))) && (min(min(Long))<Longitude_start)&&(Longitude_start<max(max(Long)))     %ȡTB��ɨ�辭γ�ȹ�����ĵ���м���
for num_row = 1:num_Latitude
        for num_col = 1: num_Longitude
%             Latitude_end   = XLAT(num_row,num_col);                                                         %��ȡ����TB�ľ�����Ϣ
%             Longitude_end  = XLONG(num_row,num_col);                                                        %��ȡ����TB��γ����Ϣ

%             X1 = R*acos(sind(Latitude_start)*sind(Latitude_start) + cosd(Latitude_start)*cosd(Latitude_start)*cosd(Longitude_start-Longitude_end));     %����γ��ת��Ϊ����
%             Y1 = R*acos(sind(Latitude_start)*sind(Latitude_end) + cosd(Latitude_start)*cosd(Latitude_end)*cosd(Longitude_start-Longitude_start))  ;    
%             X1 = real(X1);
%             Y1 = real(Y1);
%             angle_Longitude = X1/height_orbit*180/pi;
%             angle_Latitude =  Y1/height_orbit*180/pi;
%             angle_Longitude = abs(Longitude_start-Longitude_end);
%             angle_Latitude =  abs(Latitude_start-Latitude_end);
%             Y1 = angle_Latitude*height_orbit;  
%             X1 = angle_Longitude*height_orbit;                                                            %ɨ�跽����X1,Y1ѡȡ˳���й�
%             theta = sqrt(angle_Longitude^2+angle_Latitude^2);
                        
%             Ys = height_orbit*a;                                                                          %ת��Ϊ����
%             Xs = height_orbit*b;

            theta_2 = imag(SateZenith_angle_TB(num_row ,num_col))*pi/180;                                   %ָ����γ�ȵ�����ɨ��Ƕ�
            phi_2 = real(SateZenith_angle_TB(num_row ,num_col))*pi/180;                                  
            alph = acosd((1/cos(theta_1)^2+1/cos(theta_2)^2+tan(phi_1)^2+tan(phi_2)^2-(tan(theta_1)-tan(theta_2))^2-(tan(phi_1)-tan(phi_2))^2)/(2*sqrt(1/cos(theta_1)^2+tan(phi_1)^2)*sqrt(1/cos(theta_2)^2+tan(phi_2)^2)))
%����ת��%            
%             Xp = ((X1*Ys-Xs*Y1)*sin(phi)+X1*height_orbit*cot(theta))/((Xs-X1)*cos(phi)+(Ys-Y1)*sin(phi)+height_orbit*cot(theta));
%             Yp = ((Xs*Y1-X1*Ys)*cos(phi)+Y1*height_orbit*cot(theta))/((Xs-X1)*cos(phi)+(Ys-Y1)*sin(phi)+height_orbit*cot(theta));
%             Zp = -(height_orbit*X1*cos(phi)+Y1*height_orbit*sin(phi))/((Xs-X1)*cos(phi)+(Ys-Y1)*sin(phi)+height_orbit*cot(theta));
%             r = sqrt(Xp^2+Yp^2+Zp^2);
%             alph = acosd(height_orbit/r)                                                           %ת��Ϊ�۲��
           if alph<(3*null_beam_width) 
                if(sind(alph)<=0.00001)  %�����ĸΪ0ʱ����
                pattern(num_row,num_col) = 1;
                else
                pattern(num_row,num_col) = abs((2^(q+1)* factorial(q+1)*besselj(q+1,(Ba*sind(abs(alph))))/((Ba*sind(abs(alph)))^(q+1)))^2);         %���㷽��ͼ����
                end
           end
        end
end
% end

 Antenna_pattern=pattern/sum(sum(pattern));
 
 TA(num_sample_Latitude,num_sample_Longitude)=sum(sum(TB.* Antenna_pattern));
    end
end
matlabpool close;


end


