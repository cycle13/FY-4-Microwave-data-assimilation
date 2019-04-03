function  [HPBW,SLL,Null_BW,ASR_Pattern,MBE] = ASR_array_pattern_2D(array_type,xi,eta,xi_max,eta_max,uv_sample,uv_area,A,w,G,window_name,freq_index)
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
num_row = length(eta);
num_col = length(xi);
AF = zeros(num_row,num_col);
G = interpolation(G,num_row,num_col);
d_xi=2*xi_max/num_col;
d_eta=2*eta_max/num_row;

if (~strcmpi('O_Rotate_shape',array_type)) && (~strcmpi('O_shape',array_type))
   matlabpool open;
   parfor m = 1:num_row
       for n = 1:num_col      
           if (sqrt(xi(n)^2+eta(m)^2))<=1            
               AF(m,n)=real(A*sum(w.*exp(1i*2*pi*(real(uv_sample)*xi(n)+imag(uv_sample)*eta(m)))));               
           else
               AF(m,n)=NaN;
           end     
        end
   end
   matlabpool close;
else
   matlabpool open;
   parfor m = 1:num_row
       for n = 1:num_col       
           if (sqrt(xi(n)^2+eta(m)^2))<=1            
               AF(m,n)=real(sum(w.*uv_area.*exp(1i*2*pi*(real(uv_sample)*xi(n)+imag(uv_sample)*eta(m)))));               
           else
               AF(m,n)=NaN;
           end     
        end
   end
   matlabpool close;
end
%�����һ���ۺϿ׾����ʷ���ͼ�������
ASR_Pattern = AF.*G;                                    %�ۺϿ׾�����ͼ�����ۺϿ׾��������ӵ�˵�Ԫ���߷���ͼ
% ASR_Pattern=ASR_Pattern/sum(sum(ASR_Pattern));      %�ۺϿ׾�����ͼ��һ��
ASR_Pattern_norm=ASR_Pattern/max(max(ASR_Pattern)); %�ۺϿ׾�����ͼ���ֵ��һ��
ASR_Pattern_dB=10*log10(abs(ASR_Pattern_norm));       %dB�ۺϿ׾�����ͼ
[peak_row,~] =find(ASR_Pattern_norm ==1) ;
%�������߷���ͼ
% figure;mesh(xi,eta,ASR_Pattern_norm);xlim([-xi_max,xi_max]);ylim([-eta_max,eta_max]);
% xlabel('\xi');ylabel('\eta');zlabel('AP_syn');title([array_type,'ASR���з���ͼ-��ά@',window_name,'��']);
figure;
subplot(2,2,1);imagesc(xi,eta,ASR_Pattern_norm);axis equal;xlim([-xi_max,xi_max]);ylim([-eta_max,eta_max]);
xlabel('\xi');ylabel('\eta');title([array_type,'ASR���з���ͼ-ƽ��@Ch.',num2str(freq_index),',@',window_name,'��']);
subplot(2,2,2);imagesc(xi,eta,ASR_Pattern_dB);axis equal;xlim([-xi_max,xi_max]);ylim([-eta_max,eta_max]);
xlabel('\xi');ylabel('\eta');title([array_type,'ASR���з���ͼ-ƽ��dB@Ch.',num2str(freq_index),',@',window_name,'��']);
%����phy�ǵ���0��ƽ���һά����ͼ���������3dB�������
theta = asind(xi);
ASR_Pattern_1D_eta = ASR_Pattern_norm(peak_row,:);
scale_factor = 5;                                                               % ��һά����ͼʱ�����ı�������
d_xi_scale = d_xi/scale_factor;
theta_scale = asind(linspace(-xi_max,xi_max-d_xi_scale,num_col*scale_factor));        %����������
ASR_Pattern_1D_scale = interp1(theta,ASR_Pattern_1D_eta,theta_scale,'spline');  %����������ֵ���������
ASR_Pattern_1D_dB_scale = 10*log10(abs(ASR_Pattern_1D_scale)); 
[HPBW,mark_3dB] = HPBW_of_AP(ASR_Pattern_1D_scale,theta_scale);     %�������߷���ͼ��3dB������ȣ�������3dB��λ��
[SLL,mark_SLL,Null_BW] = SLL_of_AP(ASR_Pattern_1D_dB_scale,theta_scale);     %�������߷���ͼ����㲨����ȡ���һ�����ƽ�������ص�һ����λ��
%������=0�����ϵ�һά�ۺϿ׾�����ͼ
subplot(2,2,3);hPlot=plot(theta_scale,ASR_Pattern_1D_scale,'LineWidth',3); makedatatip(hPlot,mark_3dB);xlim([asind(-xi_max),asind(xi_max)]);
xlabel('\theta');ylabel('AP-syn-norm');title(['ASR���з���ͼ����@\eta=0@Ch.',num2str(freq_index),',@',window_name,'��']);grid on;
subplot(2,2,4);hPlot=plot(theta_scale,ASR_Pattern_1D_dB_scale,'LineWidth',3); makedatatip(hPlot,mark_SLL);xlim([asind(-xi_max),asind(xi_max)]);
xlabel('\theta');ylabel('AP-syn-norm-dB');title(['ASR���з���ͼ����dB@\eta=0@Ch.',num2str(freq_index),',@',window_name,'��']);grid on;

%����������Ч��
Main_lobe = 0;
Full_lobe = 0;
for m = 1:num_row
    for n = 1:num_col      
        Full_lobe = Full_lobe+abs(ASR_Pattern_norm(m,n));
        if asind(sqrt(xi(n)^2+eta(m)^2))<=Null_BW            
            Main_lobe = Main_lobe+abs(ASR_Pattern_norm(m,n));             
        end     
    end
 end
MBE = Main_lobe/Full_lobe*100;



