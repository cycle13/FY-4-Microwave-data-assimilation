function V = ASR_DFT_2D_parallel(T,Fov_xi,Fov_eta,d_xi,d_eta,uv_sample,G,flag_FringWashing,FringWashing_factor)
%   �������ܣ������ۺϿ׾���ʽ������ͼ�����ɼ��Ⱥ���*****************************
%             ���м���汾
%  
%   �������:
%    T              �����볡�����·ֲ�         
%    Fov_xi         ������ͼ��ÿ��Ħ����� 
%    Fov_eta        ������ͼ��ÿ��Ħ�����
%    d_xi           ������ͼ��ÿ�����صĦ�������
%    d_eta          ������ͼ��ÿ�����صĦ�������
%    uv_sample      ��uvƽ�����������
%    G              :��Ԫ���߷���ͼ
%   ���������
%    V              : uvƽ��������Ӧ��ÿ��ɼ��Ⱥ���                                       
%   by �¿� 2016.06.24  ******************************************************

if  flag_FringWashing == 1  %����ɼ��Ⱥ�����ʱ����������ƺ�����
    matlabpool open;
    [N1,N2]=size(uv_sample); 
    V=zeros(N1,N2);
    parfor j=1:N2    
       for k=1:N1
           u = real(uv_sample(k,j));
           v = imag(uv_sample(k,j));
           FringWashing = sinc(-1*FringWashing_factor*(u*Fov_xi+v*Fov_eta));
           V(k,j)=sum(sum(((T.*G.*FringWashing).*exp(-1i*2*pi*(u*Fov_xi+v*Fov_eta)))))*d_xi*d_eta;
        end;
    end;
    matlabpool close
else
    matlabpool open ;
    [N1,N2]=size(uv_sample); 
    V=zeros(N1,N2);
    parfor j=1:N2    
       for k=1:N1
           u = real(uv_sample(k,j));
           v = imag(uv_sample(k,j));
           V(k,j)=sum(sum(((T.*G).*exp(-1i*2*pi*(u*Fov_xi+v*Fov_eta)))))*d_xi*d_eta;
        end;
    end;
    matlabpool close
end



