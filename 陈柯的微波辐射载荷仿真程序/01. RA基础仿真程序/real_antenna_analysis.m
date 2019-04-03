%%%%%%%%%%%�������Բ�οھ���ʵ�׾����߽��з�����������Լ�����Ʋ�ͬ�׾��ն��µ�����������Ч��%%%%%%%%%%%%%%
tic;
clear;
close all;

freq = 50.3e9;                       %ϵͳ����Ƶ�ʣ���λ:Hz
c=3e8;                               %����
wavelength=c/freq; 
antenna_diameter=3.7;                %������غ�����ֱ�����ο�GEM������2�ף�
Ba = pi*antenna_diameter/wavelength;  %%%����ʲô����������
num_taper=5;                         %����amplitued taper

num_Full = 18000;
d_angle=180/num_Full;                %unit degree
theta_all=d_angle:d_angle:90-d_angle;%��ĸ�Ƕȷ�Χ
theta_max = asind(10/Ba); 
theta=d_angle:d_angle:theta_max;     %���ӽǶȷ�Χ
theta_ant_max = 180/Ba*10;
theta_ant = -theta_ant_max:d_angle:theta_ant_max;

num_theta = length(theta_all);
num_beam_efficiency = length(theta);
beam_efficiency=zeros(num_taper,num_beam_efficiency);
coordinate=zeros(1,num_beam_efficiency);
Antenna_pattern=zeros(1,length(theta_ant));
denominator = 0;
numerator = 0;
mark_Null = zeros(1,num_taper);
mark_3dB = zeros(1,num_taper);

for q=0:1:num_taper-1
    %�����ĸ  
    for n=1:num_theta
        u=Ba*sind(theta_all(n));
        du=Ba*cosd(theta_all(n))*d_angle*pi/180;
        denominator=denominator+(besselj(q+1,u))^2/u^(2*q+1)/sqrt(1-(sind(theta_all(n)))^2)*du;
    end
%�������
    for m=1:num_beam_efficiency
        for n=1:m
            u=Ba*sind(theta(n));
            du=Ba*cosd(theta(n))*d_angle*pi/180;
            numerator=numerator+(besselj(q+1,u))^2/u^(2*q+1)/sqrt(1-(sind(theta(n)))^2)*du;
        end
        beam_efficiency(q+1,m)=numerator/denominator;
        numerator=0;
        coordinate(m)=Ba*sind(theta(m));
    end

    %calculating antenna pattern
    for n=1:length(theta_ant)
        if(sind(abs(theta_ant(n)))<=0.00001)  %�����ĸΪ0ʱ����    
           Antenna_pattern(n) = Antenna_pattern(n-1);     
        else
           Antenna_pattern(n) = abs((2^(q+1)* factorial(q+1)*besselj(q+1,(Ba*sind(abs(theta_ant(n)))))/((Ba*sind(abs(theta_ant(n))))^(q+1)))^2);  
        end
    end
    Antenna_pattern=Antenna_pattern/max(Antenna_pattern);
    Antenna_pattern_dB=10*log10(abs(Antenna_pattern));
    [HPBW,mark_3] = HPBW_of_AP(Antenna_pattern,theta_ant);     
    [~,~,Null_BW_half] = SLL_of_AP(Antenna_pattern_dB,theta_ant);     %�������߷���ͼ����㲨����ȡ���һ�����ƽ�������ص�һ����λ��
    disp(Null_BW_half)
    mark_3dB(q+1) = find(abs(theta-HPBW/2)==min(abs(theta-HPBW/2)));
    mark_Null(q+1) = find(abs(theta-Null_BW_half)==min(abs(theta-Null_BW_half)));
    MBE = beam_efficiency(q+1,mark_Null(q+1));
    disp(q);disp(MBE);
    denominator = 0;
end

% ��������Ч��
figure;
plot(coordinate,beam_efficiency(1,:),'-b','LineWidth',2) ;hold on;
plot(coordinate(mark_Null(1)),beam_efficiency(1,mark_Null(1)),'k.','MarkerSize',24);hold on;
plot(coordinate(mark_3dB(1)),beam_efficiency(1,mark_3dB(1)),'kx','MarkerSize',10);hold on;

plot(coordinate,beam_efficiency(2,:),'-c','LineWidth',2);hold on;
plot(coordinate(mark_Null(2)),beam_efficiency(2,mark_Null(2)),'k.','MarkerSize',24);hold on;
plot(coordinate(mark_3dB(2)),beam_efficiency(2,mark_3dB(2)),'kx','MarkerSize',10);hold on;

plot(coordinate,beam_efficiency(3,:),'-r','LineWidth',3);hold on;
plot(coordinate(mark_Null(3)),beam_efficiency(3,mark_Null(3)),'k.','MarkerSize',24);hold on;
plot(coordinate(mark_3dB(3)),beam_efficiency(3,mark_3dB(3)),'kx','MarkerSize',10);hold on;

plot(coordinate,beam_efficiency(4,:),'-g','LineWidth',2);hold on;
plot(coordinate(mark_Null(4)),beam_efficiency(4,mark_Null(4)),'k.','MarkerSize',24);hold on;
plot(coordinate(mark_3dB(4)),beam_efficiency(4,mark_3dB(4)),'kx','MarkerSize',10);hold on;

plot(coordinate,beam_efficiency(5,:),'-y','LineWidth',2);hold on;
plot(coordinate(mark_Null(5)),beam_efficiency(5,mark_Null(5)),'k.','MarkerSize',24);hold on;
plot(coordinate(mark_3dB(5)),beam_efficiency(5,mark_3dB(5)),'kx','MarkerSize',10);hold on;

axis([0,10,0.4,1]);
grid on;
toc;