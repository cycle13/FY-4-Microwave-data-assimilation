function T= Circle_IDFT_2D(V,xi,eta,uv_sample,uvarea)
%   �������ܣ�   ����Բ�����DFT�����㷨**********************************
%               ����ͨ����Բ�����зǾ���uv������ͨ�������Ȩ���Ȼ���������Ӧ�õ�DFT�㷨%               
%  
%   �������:
%    V              ������ɼ��Ⱥ���         
%    xi             ������ͼ��ÿ��Ħ��������� 
%    eta            ������ͼ��ÿ��Ħ���������
%    uv_sample      ���ɼ��Ⱥ�����Ӧ��uvƽ�����������
%    uvarea         ��Բ����ÿ���ɼ���������Ӧ��uv����������Ǹ�����
%   ���������
%    T              : ���ݵõ��Ķ�ά����ͼ��                                       
%   by �¿� 2016.06.24  ******************************************************  
   N_xi = length(xi);
   N_eta = length(eta);
   T=zeros(N_eta,N_xi);    %��ʼ���ؽ���Ķ�άDFT�������� 
   for p=1:N_xi
      for  q=1:N_eta
             T(q,p) =real(sum(sum(V.*exp(1i*2*pi*(real(uv_sample)*xi(p)+imag(uv_sample)*eta(q))).*uvarea)));
      end
   end   
   