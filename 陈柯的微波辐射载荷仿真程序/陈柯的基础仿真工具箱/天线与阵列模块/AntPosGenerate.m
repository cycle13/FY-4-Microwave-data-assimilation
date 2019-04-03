function [ant_pos,ant_num] = AntPosGenerate(array_type,array_num,min_spacing,ant_pos_theta,ant_pos_radius,angle_rotate)
%   �������ܣ���ά�ۺϿ׾���������λ�ò�������**********************************
%  
%   �������:
%    array_type     ����������         
%    array_num      ����Ԫ���� 
%    min_spacing    ����Ԫ��С��࣬��λ������
%    ant_pos_theta  ��ÿ����Ԫ�ĽǶ�λ�ã�only for ��תԲ����
%    ant_pos_radius ��ÿ����Ԫ�İ뾶λ�ã�only for ��תԲ����
%    angle_rotate   ��ÿ����ת�ĽǶȣ�    only for ��תԲ����
%   ���������
%    ant_pos  :       ��һ����������λ�ã�һά�������飬����Ϊ���߸�����ʵ��x�ᣬ�鲿y�ᣬ��λ������
                                        %�������תԲ�����У����Ƕ�ά�������飬����Ϊ���߸���������Ϊ��ת����
%   by �¿� 2016.06.24  ******************************************************

    %���е���ʽ��AntennaPositionHELP()
switch array_type        
        case 'Y_shape' %����Y����           
            cell = array_num/3-1:-1:0;
            cell1 = (-1i)*cell;
            cell2 = (cell+1)*exp(1i*pi/6);
            cell3 = (cell*exp(1i*pi*5/6)+1i);
%             cell1 = (-1i)*cell*exp(1i*pi/6);
%             cell2 = (cell+1)*exp(1i*pi/6)*exp(1i*pi/6);
%             cell3 = (cell*exp(1i*pi*5/6)+1i)*exp(1i*pi/6);
            ant_pos_x = real([cell1 cell2 cell3]);
            ant_pos_y = imag([cell1 cell2 cell3]);
            ant_pos = (ant_pos_x+1i*ant_pos_y)*min_spacing; %��������λ�� 
            ant_num = length(ant_pos);                      %�������߸���
            
        case 'y_shape'%��׼Y����            
            cell = (array_num-1)/3:-1:1;
            cell1 = (-1i)*cell;
            cell2 = cell*exp(1i*pi/6);
            cell3 = cell*exp(1i*pi*5/6);
%             cell1 = (-1i)*cell*exp(1i*pi/6);
%             cell2 = cell*exp(1i*pi/6)*exp(1i*pi/6);
%             cell3 = cell*exp(1i*pi*5/6)*exp(1i*pi/6);
            ant_pos_x = [0 real([cell1 cell2 cell3])];
            ant_pos_y = [0 imag([cell1 cell2 cell3])];
            ant_pos = (ant_pos_x+1i*ant_pos_y)*min_spacing; %��������λ��
            ant_num = length(ant_pos);                      %�������߸���
            
        case 'T_shape' %T����
            cell = array_num/3:-1:1;
            cell1 = (-1i)*cell;
            cell2 = cell;
            cell3 = (-1)*cell;
            ant_pos_x = real([cell1 cell2 cell3]);
            ant_pos_y = imag([cell1 cell2 cell3]);
            ant_pos = (ant_pos_x+1i*ant_pos_y)*min_spacing; %��������λ��
            ant_num = length(ant_pos);                      %�������߸���
            
        case 'U_shape' %U����            
            cell = array_num/3:-1:1;
            cell1 = (1i)*cell;
            cell2 = cell-1;
            cell3 = cell1+array_num/3-1;
            ant_pos_x = real([cell1 cell2 cell3]);
            ant_pos_y = imag([cell1 cell2 cell3]);
            ant_pos = (ant_pos_x+1i*ant_pos_y)*min_spacing; %��������λ��
            ant_num = length(ant_pos);                      %�������߸���
            
         case 'O_shape'  %����Բ����
            ant_pos_index = linspace(0,2*pi,array_num+1);
            ant_pos_index = ant_pos_index(1:array_num);
            circle_norm_radius = min_spacing/2/sin(pi/array_num);
            ant_pos = circle_norm_radius*exp(1i*ant_pos_index);%��������λ�� 
            ant_num = length(ant_pos);                         %�������߸���
            
         case 'O_Rotate_shape'  %��תԲ����   
           % ��תԲ����������λ��
            x = cosd(ant_pos_theta).*ant_pos_radius;
            y = sind(ant_pos_theta).*ant_pos_radius;
            ant_pos(1,:) = x+1i*y; %����λ�ã�Ϊʵ�����鲿֮��       
            for k = 1:length(angle_rotate) %ÿ����ת֮�������λ��
                x = cosd(ant_pos_theta+sum(angle_rotate(1:k))).*ant_pos_radius;
                y = sind(ant_pos_theta+sum(angle_rotate(1:k))).*ant_pos_radius;
                ant_pos(k+1,:) = x+1i*y;                       %ÿ����ת֮�����������λ��
            end 
            ant_num = size(ant_pos,2);                         %�������߸���
            
         case  'CLA'     %��Բ��դ������� 
            ant_num = 0;                                       %�������߸���
            r0 = 1;
            N_grid=ceil(sqrt(4*array_num*(array_num-1)/pi));
            nGrid = round(N_grid/2);
            dr=4*r0/N_grid;
            scale = 1/dr;
            r = r0*scale;
            originx = r; originy = r;   %����CLAԲ��λ��
            r1 = r-dr*scale/2;
            r2 = r1+dr*scale;
            Gridposx = 0:nGrid; Gridposy = 0:nGrid;
            for ii = 1:length(Gridposx)
                for jj = 1:length(Gridposy)
                    dist = sqrt((originx-Gridposx(ii))^2+(originy-Gridposy(jj))^2);
                    if dist>=r1&&dist<=r2
                        ant_num = ant_num+1;
                        pos(1,ant_num) = Gridposx(ii)+1i*Gridposy(jj);                    
                    end
                end
            end
            r0 = 1*scale;
            theta = 0:2*pi/array_num:2*pi-pi/array_num;
            x = r0*cos(theta)+originx;
            y = r0*sin(theta)+originy;
            figure();plot(x,y,'.','linewidth',5,'Markersize',25);hold on
            plot(real(pos),imag(pos),'Ms','Linewidth',3,'Markersize',5,'Markerfacecolor','M');
            
            alpha = 0:pi/50:2*pi;
            r = [r1,r2];
            for ii = 1:2
                x = r(ii)*cos(alpha)+originx;
                y = r(ii)*sin(alpha)+originy;
                plot(x,y,'R');
                axis equal
            end
            legend('UCA element','CLA element'); 
            x = r0*cos(alpha)+originx;
            y = r0*sin(alpha)+originy;
            plot(x,y,'--K');
            gx = 0:nGrid;
            gy = 0:nGrid;
            for ii = 1:length(gy)
                plot((ii-1)*ones(1,length(gy)),gy,':K');
            end
            for ii = 1:length(gx)
                plot(gx,(ii-1)*ones(1,length(gx)),':K');
            end
            xlabel('x/x_g');
            ylabel('y/y_g');
            axis([-1.5 length(gy)+1 -1 length(gy)]);
            set(gca,'XTick',0:1:length(gy));
            set(gca,'YTick',0:1:length(gy));
            ant_pos = pos*min_spacing;                          %��������λ��            
end
