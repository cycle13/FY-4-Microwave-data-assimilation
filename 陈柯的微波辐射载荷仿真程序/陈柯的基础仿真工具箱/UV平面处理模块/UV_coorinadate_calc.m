function [uv_sample,Num_U,Num_V] = UV_coorinadate_calc (P,Q,delta_u,delta_v,N_xi,N_eta)
%   �������ܣ������׼��������uvƽ����������꣬��matlab FFT�������걣��һ��******
%             ����ͼ�����ص���ż���֣�Ϊ�˺�DFT����һ�¡�   
%  
%   �������:
%    P              ��u�᷽�������ߣ���λ������         
%    Q              ��v�᷽�������ߣ���λ������
%    delta_u        ��u�᷽����С��࣬��λ������
%    delta_v        ��v�᷽����С��࣬��λ������
%    N_xi           ����������ͼ���ڦη������ص���
%    N_eta          ����������ͼ���ڦǷ������ص���

%   ���������
%    uv_sample      : ��׼��������uvƽ����������꣬��λ������
%    Num_U          ��u�᷽����������
%    Num_V          ��v�᷽����������
%   by �¿�  2016.06.24  ******************************************************
  
    if mod(N_xi,2)==0
        u_index = -P:1:P-1;Num_U = 2*P;
    else
        u_index = -P:1:P;Num_U = 2*P+1;
    end
    if mod(N_eta,2)==0
        v_index = -Q:1:Q-1;Num_V = 2*Q;
    else
        v_index = -Q:1:Q;Num_V = 2*Q+1;
    end
    
    [u_coordinate,v_coordinate] = meshgrid(u_index*delta_u,v_index*delta_v);  
    uv_sample = u_coordinate+1i*v_coordinate;
    