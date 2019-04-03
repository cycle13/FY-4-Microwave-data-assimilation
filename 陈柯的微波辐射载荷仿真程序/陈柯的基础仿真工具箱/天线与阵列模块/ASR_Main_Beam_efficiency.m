function  [MBE] = ASR_Main_Beam_efficiency(array_type,uv_sample,uv_area,A,w,antenna_G,num,Null_BW,xi_max,eta_max)
%   �������ܣ������ۺϿ׾����߷���ͼ**********************************
%            ����3dB������ȡ�����Ч�ʡ���һ�԰������ͼ����
%  
%   �������:
%    array_type����������
%    xi        :�η�������������
%    eta       :�Ƿ�������������
%    xi_max    ������ͼ�ڦη�������ֵ,����ͼ�ռ䷶ΧΪ-��max--��max
%    eta_max   : ����ͼ�ڦǷ�������ֵ,����ͼ�ռ䷶ΧΪ-��max--��max
%    uv_sample ��uvƽ����������꣬�Բ�����һ��          
%    uv_area   : ÿ��uv�������������ֻ��Բ������������
%    A         : ÿ��uv�����������
%    G         : ��Ԫ���߷���ͼ
%   ���������
%    HPBW      : ����ͼ�빦�ʲ������                                       
%   by �¿� 2016.06.24  ******************************************************
AF = zeros(num,num);
G = interpolation(antenna_G,num,num);
d_xi=2*xi_max/num;
d_eta=2*eta_max/num;
xi = linspace(-xi_max,xi_max-d_xi,num);        %����������
eta = linspace(-eta_max,eta_max-d_eta,num);   %����������
Main_lobe = 0;
Full_lobe = 0;

if (~strcmpi('O_Rotate_shape',array_type)) && (~strcmpi('O_shape',array_type))
   matlabpool open;
   parfor m = 1:num
       for n = 1:num      
           if (sqrt(xi(n)^2+eta(m)^2))<=1            
               AF(m,n)=real(A*sum(w.*exp(1i*2*pi*(real(uv_sample)*xi(n)+imag(uv_sample)*eta(m)))));               
           else
               AF(m,n)=0;
           end     
        end
   end
   matlabpool close;
else
   matlabpool open;
   parfor m = 1:num
       for n = 1:num       
           if (sqrt(xi(n)^2+eta(m)^2))<=1            
               AF(m,n)=real(sum(w.*uv_area.*exp(1i*2*pi*(real(uv_sample)*xi(n)+imag(uv_sample)*eta(m)))));               
           else
               AF(m,n)=0;
           end     
        end
   end
   matlabpool close;
end
ASR_Pattern = AF.*G;                                    %�ۺϿ׾�����ͼ�����ۺϿ׾��������ӵ�˵�Ԫ���߷���ͼ
ASR_Pattern=ASR_Pattern/sum(sum(ASR_Pattern));         %�ۺϿ׾�����ͼ��һ��
ASR_Pattern_norm=ASR_Pattern/max(max(ASR_Pattern));   %�ۺϿ׾�����ͼ���ֵ��һ��
ASR_Pattern_dB=10*log10(abs(ASR_Pattern_norm));       %dB�ۺϿ׾�����ͼ
for m = 1:num
    for n = 1:num 
        Full_lobe = Full_lobe+abs(ASR_Pattern_norm(m,n));
        if asind(sqrt(xi(n)^2+eta(m)^2))<=Null_BW            
            Main_lobe = Main_lobe+abs(ASR_Pattern_norm(m,n));             
        end     
    end
 end
figure;imagesc(xi,eta,ASR_Pattern_norm);axis equal;xlim([-xi_max,xi_max]);ylim([-eta_max,eta_max]);xlabel('\xi');ylabel('\eta');title([array_type,'�ۺϿ׾����ʷ���ͼ-ƽ��']);
figure;imagesc(xi,eta,ASR_Pattern_dB);axis equal;xlim([-xi_max,xi_max]);ylim([-eta_max,eta_max]);xlabel('\xi');ylabel('\eta');title([array_type,'�ۺϿ׾����ʷ���ͼ-ƽ��dB']);
MBE = Main_lobe/Full_lobe*100;