function [w] = Visibility2D_window_calc(uvsample,window_name)
%   �������ܣ��Զ�ά�ɼ��Ⱥ����Ӵ�����**********************************
%             ֧�֡�rectwin������bartlett������blackman����"hamming","hanning", 'circle blackman'���ִ�����
%  
%   �������:
%    uv             ��uvƽ����������꣬�Բ�����һ��          
%    window_name    ������������
%   ���������
%    w              : ��ϵ��                                       
%   by �¿� 2016.06.24  ******************************************************
   
   [num_v,num_u] = size(uvsample);               %�ɼ�������������
   p_V = sqrt(real(uvsample).^2+imag(uvsample).^2);    %uvƽ��ÿ�������㵽ԭ��ľ���
   w = zeros(num_v,num_u);                 %��ʼ�������� 
   pmax = max(max(abs(uvsample),[],1));          %uv�������뾶
   pmax_circle_blackman = pmax/sqrt(3);    %'circle blackman'�����õ����뾶
   for n = 1:num_u
       for m= 1:num_v
           p = p_V(m,n);             
           switch lower(window_name)% �ɼ��Ⱥ����Ӵ�
             case 'rectwin'  % ���δ�
                   w(m,n)=1; 
             case 'gauss'    % ��˹��                   
%                  w(m,n)=exp(-6.5*((p/pmax)^2));
                   alpha = 2.25;
                   w(m,n)=exp(-0.5*((alpha*p/pmax)^2));
             case 'blackman' % blackman��
                   w(m,n)=0.42+0.5*cos(pi*p/pmax)+0.08*cos(2*pi*p/pmax); 
             case 'bartlett' % �����ش�
                   w(m,n)=1-(p/pmax);
             case 'hamming'  % ������
                   w(m,n)=0.54+0.46*cos(pi*p/pmax); 
             case 'hanning'  % ������
                   w(m,n)=0.5+0.5*cos(pi*p/pmax);
             case 'circle_blackman'     % Բ��blackman������corbella 2012 ��GRSL����Reduction of secondary lobes in aperture synthesis radiometry
                  if p> pmax_circle_blackman
                     w(m,n)=0;
%                      plot(real(uvsample(m,n)),imag(uvsample(m,n)),'bo');hold on;
                  else
                     w(m,n)=0.42+0.5*cos(pi*p/pmax_circle_blackman)+0.08*cos(2*pi*p/pmax_circle_blackman);
%                      plot(real(uvsample(m,n)),imag(uvsample(m,n)),'ro');hold on;
                  end
           end   
        end
   end
  
   
