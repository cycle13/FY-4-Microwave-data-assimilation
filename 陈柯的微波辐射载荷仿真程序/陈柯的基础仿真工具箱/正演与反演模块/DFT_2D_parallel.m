function V  = DFT_2D_parallel(T,Fov_xi,Fov_eta,d_xi,d_eta,uv_sample)
%   �������ܣ���ά����Ҷ�任��ʽ������ͼ�����ɼ��Ⱥ���*****************************
%             ���м���汾
%  
%   �������:
%    T              �����볡�����·ֲ�         
%    Fov_xi         ������ͼ��ÿ��Ħ����� 
%    Fov_eta        ������ͼ��ÿ��Ħ�����
%    d_xi           ������ͼ��ÿ�����صĦ�������
%    d_eta          ������ͼ��ÿ�����صĦ�������
%    uv_sample      ��uvƽ�����������
%   ���������
%    V              : uvƽ��������Ӧ��ÿ��ɼ��Ⱥ���                                       
%   by �¿� 2016.09.15  ******************************************************
    matlabpool open ;
    [N1,N2]=size(uv_sample); 
    V=zeros(N1,N2);
    parfor j=1:N2    
       for k=1:N1
           u = real(uv_sample(k,j));
           v = imag(uv_sample(k,j));
           V(k,j)=sum(sum((T.*exp(-1i*2*pi*(u*Fov_xi+v*Fov_eta)))))*d_xi*d_eta;
        end;
    end;
    matlabpool close