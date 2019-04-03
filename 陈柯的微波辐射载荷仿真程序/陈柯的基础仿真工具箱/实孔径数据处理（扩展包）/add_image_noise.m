function [T]=add_image_noise(T,bandwith,integral_time,noise_figure)
%������Ϊ��������ͼ������������������ȸ��ݷ���Ʋ�������
%T����������ͼ��bandwith:����,integral_time������ʱ��,noise_figure������ϵ��               

T_rec=290*(10^(noise_figure/10)-1);                 % radiometer receiver noise temperature, unit:K
sampling_num = floor(bandwith*integral_time); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[row,col]=size(T);
var_matrix= zeros(row,col);    
for m=1:row
    for n=1:col 
            var_matrix(m,n)=(T(m,n)+T_rec)^2/sampling_num;
%     noise_matrix(m,n) = randn(1,1)*sqrt(var_matrix(m,n));
    end
end
noise_matrix = randn(row,col).*sqrt(var_matrix);
for m=1:row
    for n=1:col
        if(T(m,n)~=0)
            T(m,n)=T(m,n)+noise_matrix(m,n);
        end
    end
end

