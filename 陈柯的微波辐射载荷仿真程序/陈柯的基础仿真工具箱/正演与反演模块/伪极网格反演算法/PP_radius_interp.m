function [v_radius_interp,uv_radius_interp]= PP_radius_interp(visibility,uvsample,N,v0)
%   �������ܣ�   α������뾶��ֵ����**********************************
%               ��uvƽ��ͬһ�Ƕȵ�һ���뾶�������ֵ��α�������Ӧ�ľ��Ȱ뾶��������          
%  
%   �������:
%   visibility      �����뾶��ֵ�Ŀɼ��Ⱥ���
%   uvsample        �����뾶��ֵ��uv����ƽ�棬Ӧ����ͬһ�Ƕȵ�һ���뾶�ϵĲ����㣬ע�⣺�ò������Ƕ�2pi��һ���������ֵ
%   N               : Ҫ��ֵ��α���������
%   v0              ����㴦�Ŀɼ��Ⱥ���ֵ
%   ���������
%   v_radius_interp ���뾶��ֵ��Ŀɼ��Ⱥ���ֵ������ΪN
%   uv_radius_interp���뾶��ֵ���uv����ƽ�棬����ΪN                         
%   by �¿� 2016.06.24  ******************************************************

uv_theta = mean(angle(uvsample)); %��ǰ�뾶�ĽǶ�ֵ
num_radius = length(visibility);  %��ǰ�뾶�ϲ��������
uv_radius = abs(uvsample);        %ÿ��������İ뾶ֵ
% �жϸýǶ����ڷ�Χ
switch floor(4*abs(uv_theta)/pi)
    case {0}
        uv_theta_mod = abs(uv_theta);
    case {1}
        uv_theta_mod = pi/2 - abs(uv_theta);
    case {2}
        uv_theta_mod = abs(uv_theta)-pi/2;
    case {3,4}
        uv_theta_mod = pi-abs(uv_theta);
end        
% % ����Բ���������뾶����α���������뾶
reference_radius = pi;          %α������ķ�ΧΪ[-pi~pi]
max_radius = max(uv_radius);    %��ǰuv���������뾶��ͬ����һ����[-pi~pi]
reference_radius_max = reference_radius/abs(cos(uv_theta_mod)); %��ǰ�Ƕȶ�Ӧ��α���������뾶ֵ
%�������ɼ��Ȱ뾶С��α�������Ӧ�뾶�����ֵ����ô��Ե�ǰ�����������Χ���㣬����α������뾶
if max_radius<reference_radius_max
    extend_num =ceil((reference_radius_max-max_radius)/max_radius*num_radius); 
    uv_radius_extend = max_radius+(1:extend_num+2)*(reference_radius_max-max_radius)/extend_num;
    radius_extend = [uv_radius uv_radius_extend];
    v_extend = ones(1,extend_num+2)*0;
    visibility_extend = [visibility v_extend];
else
    radius_extend = uv_radius;
    visibility_extend = visibility;    
end
%���㾶���ֵ���uvƽ�����������
% α��������İ뾶ֵ
if uv_theta>(-pi/4+1e-6) && uv_theta<=(3*pi/4+1e-6)
    radius_interp =  reference_radius_max*[0:N-1]/N;   
else
    radius_interp =  reference_radius_max*[1:N]/N;
end
% �����ֵ���uvƽ����������꣨�ǶȲ��䣩
uv_radius_interp = radius_interp*exp(1i*uv_theta);

visibility = [v0 visibility_extend];   %�������ֵ
uv_radius = [0 radius_extend];   
v_radius_interp = zeros(1,N);   

%����������ֵ 
% v_interp = interp1(uv_radius,real(visibility),radius_interp,'spline')+1i* interp1(uv_radius,imag(visibility),radius_interp,'spline');

%�������ղ�ֵ
window_length = 7;
flag_same_position = 0;
flag_radius_beyond = 0;
for i = 1:N
    radius_current=radius_interp(i);            %��ǰ����ֵ��İ뾶ֵ 
    %  ���α�������İ뾶������ɼ��Ȳ���ĳ��İ뾶��ͬ����ֱ���øĵ������ɼ��Ⱥ���ֵ������Ҫ��ֵ��
    if min(abs(uv_radius-radius_current))<=1e-6
        v_radius_interp(i) = visibility(abs(uv_radius-radius_current)==min(abs(uv_radius-radius_current)));
        flag_same_position = 1;
    end
    %�����ǰα�������İ뾶�Ѿ���������ɼ��ȵ����뾶�������־λ
    if radius_current>max_radius
        flag_radius_beyond =1;
    end
    %�趨�����������ղ�ֵ�Ŀɼ������ݴ���
    index_min = find(abs(radius_current-uv_radius) == min(abs(radius_current-uv_radius)) , 1 );%�ҳ��뱻��ֵ��α���������ӽ�������uv������
    if flag_same_position ==0 && flag_radius_beyond==0      
       if index_min>window_length && (index_min+window_length)<=length(uv_radius)
            uv_radius_Lag = uv_radius((index_min-window_length):(index_min+window_length));
            visibility_Lag = visibility((index_min-window_length):(index_min+window_length));%  
        else if index_min<=window_length
            uv_radius_Lag = uv_radius(1:(index_min+window_length));
            visibility_Lag = visibility(1:(index_min+window_length));% 
            else
            uv_radius_Lag = uv_radius((index_min-window_length):length(uv_radius));
            visibility_Lag = visibility((index_min-window_length):length(uv_radius));%     
            end
            
        end
        v_radius_interp(i)=lagrange_interp(uv_radius_Lag,real(visibility_Lag),radius_current)+1i*lagrange_interp(uv_radius_Lag,imag(visibility_Lag),radius_current);
    else if flag_radius_beyond == 1
        v_radius_interp(i) = visibility(index_min);
         end
    end
    flag_radius_beyond = 0;
    flag_same_position = 0;    
end

