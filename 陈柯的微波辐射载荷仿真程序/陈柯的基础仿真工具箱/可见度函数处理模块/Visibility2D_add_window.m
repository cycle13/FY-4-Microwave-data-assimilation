function V_window = Visibility2D_add_window(uv,V,window_name)
%   �������ܣ��Զ�ά�ɼ��Ⱥ����Ӵ�����**********************************
%             ֧�֡�rectwin������bartlett������blackman����"hamming","hanning", 'circle blackman'���ִ�����
%  
%   �������:
%    uv             ��uvƽ����������꣬�Բ�����һ��          
%    V              ��δ�Ӵ��ɼ��Ⱥ��� 
%    window_name    ������������
%   ���������
%    V_window       : �Ӵ�֮��Ŀɼ��Ⱥ���                                       
%   by �¿� 2016.06.24  ******************************************************
   
   [num_v,num_u] = size(V);                %�ɼ��Ⱥ���������
   p_V = sqrt(real(uv).^2+imag(uv).^2);    %uvƽ��ÿ�������㵽ԭ��ľ���
   w = zeros(num_v,num_u);                 %��ʼ�������� 
   pmax = max(max(abs(uv),[],1));          %uv�������뾶
   pmax_circle_blackman = pmax/sqrt(3);    %'circle blackman'�����õ����뾶
   for n = 1:num_u
       for m= 1:num_v
           p = p_V(m,n);             
           switch lower(window_name)% �ɼ��Ⱥ����Ӵ�
             case 'rectwin',  w(m,n)=1; % ���δ�                   
             case 'blackman', w(m,n)=0.42+0.5*cos(pi*p/pmax)+0.08*cos(2*pi*p/pmax); 
             case 'bartlett', w(m,n)=1-(p/pmax);
             case 'hamming',  w(m,n)=0.54+0.46*cos(pi*p/pmax); 
             case 'hanning',  w(m,n)=0.5+0.5*cos(pi*p/pmax);
             case 'circle blackman'     % Բ��blackman������corbella 2012 ��GRSL����Reduction of secondary lobes in aperture synthesis radiometry
                  if p> pmax_circle_blackman
                     w(m,n)=0;
                  else
                     w(m,n)=0.42+0.5*cos(pi*p/pmax)+0.08*cos(2*pi*p/pmax); 
                  end
           end   
        end
   end
   V_window=V.*w; 
