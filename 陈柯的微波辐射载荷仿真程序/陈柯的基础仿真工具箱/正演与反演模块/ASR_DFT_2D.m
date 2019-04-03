function V = ASR_DFT_2D(T,Fov_xi,Fov_eta,d_xi,d_eta,uv_sample,G,flag_FringWashing,FringWashing_factor)
%   �������ܣ������ۺϿ׾���ʽ����ɼ��Ⱥ���**********************************%             
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
%   by �¿� 2016.06.24  ******************************************************   
[N1,N2]=size(uv_sample); 
V=zeros(N1,N2);
if  flag_FringWashing == 1  %����ɼ��Ⱥ�����ʱ����������ƺ�����
  for k=1:1:N1    
     for j=1:1:N2,
       u = real(uv_sample(k,j));
       v = imag(uv_sample(k,j));
       FringWashing = sinc((u*Fov_xi+v*Fov_eta)*FringWashing_factor);
       V(k,j)=sum(sum((T.*G.*FringWashing.*exp(-1i*2*pi*(u*Fov_xi+v*Fov_eta)))))*d_xi*d_eta;
     end;
   end;
else
    for k=1:1:N1    
       for j=1:1:N2,
        u = real(uv_sample(k,j));
        v = imag(uv_sample(k,j));
        V(k,j)=sum(sum((T.*G).*exp(-1i*2*pi*(u*Fov_xi+v*Fov_eta))))*d_xi*d_eta;
       end;
    end;
end



    
