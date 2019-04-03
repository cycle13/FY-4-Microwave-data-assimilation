  function [SLL,mark_SLL,Null_BW] = SLL_of_AP(Antenna_Pattern_dB,theta)
%   �������ܣ�����һά���߷���ͼ�ĵ�һ�����ƽ**********************************
%  
%   �������:
%    Antenna_Pattern_dB��һά����ͼ����          
%    theta          ������ͼ��Ӧ�Ƕ���������
%   ���������
%    SSL            ����һ�����ƽ����λ��dB 
%    mark_SSL       ��λ����ţ�
%   by �¿� 2016.09.02  ****************************************************** 

   Antenna_Pattern_max = max(Antenna_Pattern_dB);
   N = length(theta);
   index_max = find(Antenna_Pattern_dB == Antenna_Pattern_max);
   for k = index_max:N-1
       if (Antenna_Pattern_dB(k+1)-Antenna_Pattern_dB(k)) > 0;
           Null_BW = theta(k);
           mark_Null = k;
           break;
       end       
   end
   SLL = max(Antenna_Pattern_dB(mark_Null:N));
   mark_SLL = find(Antenna_Pattern_dB == SLL);
   mark_SLL = mark_SLL(1);
   
%    for k = mark_Null:N-1
%        if (Antenna_Pattern_dB(k+1)-Antenna_Pattern_dB(k)) < 0;
%            SSL =Antenna_Pattern_dB(k);
%            mark_SSL = k;
%            break;
%        end       
%    end
  
   
     
