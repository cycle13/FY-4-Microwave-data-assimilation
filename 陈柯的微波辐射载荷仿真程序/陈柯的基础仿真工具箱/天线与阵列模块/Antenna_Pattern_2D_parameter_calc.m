function  [HPBW,SLL,MBE] = Antenna_Pattern_2D_parameter_calc(Antenna_Pattern,Coordinate_x,Coordinate_y,angle_x,angle_y,channel_index,flag_draw_pattern,Ba,taper)
%   �������ܣ�����һ����ά���߷���ͼָ��**********************************
%            ����3dB������ȡ���㲨��λ�á�����Ч�ʡ���һ�԰��ƽ������ͼ����
%  
%   �������:
%    Coordinate_x ��x�᷽�����꣬��λ���Ƕ�
%    Coordinate_y ��y�᷽�����꣬��λ���Ƕ�
%    angle_x      : x��Ƕȷ�Χ
%    angle_y      : y��Ƕȷ�Χ
%    Ba           : ���ߵ糤�Ȳ���
%    taper        : �׾��նȣ�
%   ���������
%    Antenna_Pattern : ���߹�һ�����ʷ���ͼ  
%    HPBW            : �빦�ʲ������ 
%    SLL             ����һ�����ƽ
%    MBE             ��������Ч��
%   by �¿� 2016.06.24  ******************************************************

%�����һ���ۺϿ׾����ʷ���ͼ�������
row = length(Coordinate_y);col = length(Coordinate_x);
Antenna_Pattern = interpolation(Antenna_Pattern,row,col);
Antenna_Pattern_norm=Antenna_Pattern/max(max(Antenna_Pattern)); %���߷���ͼ���ֵ��һ��
Antenna_Pattern_dB=10*log10(abs(Antenna_Pattern_norm));         %dB���߷���ͼ
[peak_row,~] =find(Antenna_Pattern_norm ==1) ;
%�������߷���ͼ

% if flag_draw_pattern == 1
% % figure;mesh(Coordinate_x,Coordinate_y,Antenna_Pattern_norm);xlim([-angle_x/2,angle_x/2]);ylim([-angle_y/2,angle_y/2]);
% % xlabel('x');ylabel('y');zlabel('AP');title('ʵ�׾����߹�һ�����ʷ���ͼ-��ά');
% figure;imagesc(Coordinate_x,Coordinate_y,Antenna_Pattern_norm);axis equal;xlim([-angle_x/2,angle_x/2]);ylim([-angle_y/2,angle_y/2]);
% xlabel('x');ylabel('y');title(['ʵ�׾����߹�һ�����ʷ���ͼ-ƽ��@Ch.',num2str(channel_index)]);
% figure;imagesc(Coordinate_x,Coordinate_y,Antenna_Pattern_dB);axis equal;xlim([-angle_x/2,angle_x/2]);ylim([-angle_y/2,angle_y/2]);
% xlabel('x');ylabel('y');title(['ʵ�׾����߹�һ�����ʷ���ͼ-ƽ��dB@Ch.',num2str(channel_index)]);
% end
%����phy�ǵ���0��ƽ���һά����ͼ���������3dB�������
d_x =abs( Coordinate_x(2)-Coordinate_x(1));
num_col = length(Coordinate_x);
theta = Coordinate_x;
Antenna_Pattern_1D = Antenna_Pattern_norm(peak_row(1),:);
scale_factor = 5;                                                                   % ��һά����ͼʱ�����ı�������
d_x_scale = d_x/scale_factor;
theta_scale = linspace(-angle_x/2,angle_x/2-d_x_scale,num_col*scale_factor);        %x��������
Antenna_Pattern_1D_scale = interp1(theta,Antenna_Pattern_1D,theta_scale,'spline');      %����������ֵ���������
Antenna_Pattern_1D_dB_scale = 10*log10(abs(Antenna_Pattern_1D_scale)); 
[HPBW,mark_3dB] = HPBW_of_AP(Antenna_Pattern_1D_scale,theta_scale);     %�������߷���ͼ��3dB������ȣ�������3dB��λ��
[SLL,mark_SLL,Null_theta] = SLL_of_AP(Antenna_Pattern_1D_dB_scale,theta_scale);     %�������߷���ͼ����㲨����ȡ���һ�����ƽ�������ص�һ����λ��
MBE = AP_Main_Beam_efficiency_Gail(Ba,Null_theta,taper);
if flag_draw_pattern == 1
%������=0�����ϵ�һά�ۺϿ׾�����ͼ
figure;hPlot=plot(theta_scale,Antenna_Pattern_1D_scale,'LineWidth',3); makedatatip(hPlot,mark_3dB);xlim([-angle_x/2,angle_x/2]);
xlabel('\theta');ylabel('AP-norm');title(['ʵ�׾����߷���ͼ����@y=0@Ch.',num2str(channel_index)]);grid on;
figure;hPlot=plot(theta_scale,Antenna_Pattern_1D_dB_scale,'LineWidth',3); makedatatip(hPlot,mark_SLL);xlim([-angle_x/2,angle_x/2]);
xlabel('\theta');ylabel('AP-norm-dB');title(['ʵ�׾����߷���ͼ����dB@y=0@Ch.',num2str(channel_index)]);grid on;
end