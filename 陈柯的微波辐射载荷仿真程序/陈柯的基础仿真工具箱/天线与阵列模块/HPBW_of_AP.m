function [HPBW,index_3dB,amp_3dB] = HPBW_of_AP(Antenna_Pattern,theta)
%   �������ܣ�����һά���߷���ͼ��3dB�������**********************************
%  
%   �������:
%    Antenna_Pattern��һά����ͼ����          
%    theta          ������ͼ��Ӧ�Ƕ���������
%   ���������
%    HPBW           ��3dB������ȣ���λ���Ƕ� 
%    index_3dB      ��3dB ����ţ�
%    amp_3dB        ���빦�ʵ�ķ���
%   by �¿� 2016.06.24  ****************************************************** 

   Antenna_Pattern_max = max(Antenna_Pattern);
   N = length(theta);
   diff = Antenna_Pattern_max/3;
   theta_3dB_plus = 0;
   theta_3dB_minus = 0;
   index_3dB = 0;
   amp_3dB = 0;
   for k = 1:round(N/2)
       if abs(Antenna_Pattern(k)-0.5*Antenna_Pattern_max) < diff
           diff = abs(Antenna_Pattern(k)-0.5*Antenna_Pattern_max);
           theta_3dB_minus = theta(k);
           index_3dB = k;
           amp_3dB = Antenna_Pattern(k);
       end
   end
   diff = Antenna_Pattern_max/3;
   for k = N:-1:round(N/2)
       if abs(Antenna_Pattern(k)-0.5*Antenna_Pattern_max) < diff
           diff = abs(Antenna_Pattern(k)-0.5*Antenna_Pattern_max);
           theta_3dB_plus = theta(k);
           index_3dB = k;
           amp_3dB = Antenna_Pattern(k);
       end
   end
   HPBW = abs(theta_3dB_plus-theta_3dB_minus);   
