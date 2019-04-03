function [uvsample,Num_angle,Num_radius,d_radius] = UV_Uniform_Circle(Tb,xi_max,eta_max,factor_delta_uv,Num_angle,factor_max_radius)
%   �������ܣ���uv����ƽ���ϲ���һ���ǶȺͰ뾶�����ȼ��������UVԲ������ƽ�棬��������uv����������**********************************
%            ���ӹ����Ǹ���Ҫ���������ͼ��ʹ��Բ��������ȫ����ͼ�����߲���Ƶ��*factor_max_radius
%   �������:
%    Tb             ��Ҫ���������ͼ��         
%    xi_max         ��%����ͼ��η��򣨼����ȷ��򣩵����ֵ,ͼ��ռ䷶ΧΪ-��max--��max 
%    eta_max        ��%����ͼ��Ƿ��򣨼�γ�ȷ��򣩵����ֵ,ͼ��ռ䷶ΧΪ-��max--��max
%    factor_delta_uv����С��౶�����ӣ�Ĭ�ϰ뾶��С���Ӧ�õ���1/2*xi_max����ʵ�ʰ뾶��С���Ϊ��׼���/factor_delta_uv
%    Num_angle      ��ÿһ��Բ���ϵ�uv��������
%    factor_max_radius �����뾶�������ӣ�Ĭ�����뾶Ϊͼ����߲���Ƶ�ʣ�ʵ�����뾶ΪĬ�ϰ뾶*factor_max_radius
%   ���������
%    uvsample       : ���ȼ����UVԲ������ƽ�����в��������꣬����Ȧ��ʼ��Ȧ����
%    Num_angle      ��ÿһ��Բ���ϵ�uv��������
%    Num_radius     ���뾶��������ͬ��Բ������
%    d_radius       ���뾶���                ��λ������
                                    
%   by �¿� 2016.06.24  ******************************************************

   % ����ͼ�����Ƶ�ʲ���һ���뾶���ȼ����UVԲ����������
   d_angle = (2*pi/Num_angle);
   angle = linspace(-pi,pi-d_angle,Num_angle);
   
   radius_extend = 1;
   [N_eta,N_xi] = size(Tb);
   if mod(N_xi,2)==0
      u = ceil((N_xi/2)/(2*xi_max)/cos(pi/4))+radius_extend;
   else
      u = ceil((N_xi-1)/2/(2*xi_max)/cos(pi/4))+radius_extend;
   end
   if mod(N_eta,2)==0
      v = ceil((N_eta/2)/(2*eta_max)/cos(pi/4))+radius_extend;
   else
      v = ceil((N_eta-1)/2/(2*eta_max)/cos(pi/4))+radius_extend;
   end
   disp(u);disp(v);
   delta_u = 1/(factor_delta_uv*2*xi_max);delta_v =1/(factor_delta_uv*2*eta_max);
   d_radius = min(delta_u,delta_v);max_radius = max(u,v)*factor_max_radius;
   Num_radius = ceil(max_radius/d_radius);
   uvsample = 0;
   for k = 1:1:Num_radius
       current_radius = k*d_radius; 
       uv_single_circle =  current_radius*exp(1i*angle);
       uvsample = [uvsample uv_single_circle];
   end
   
   
   
   