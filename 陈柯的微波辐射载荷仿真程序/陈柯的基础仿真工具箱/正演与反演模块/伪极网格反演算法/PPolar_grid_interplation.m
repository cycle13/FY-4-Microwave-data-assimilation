function [V_ASR_PP,uv_sample_PP,uv_area_rotate,uv_sample_rotate,redundancy] = PPolar_grid_interplation(V_ASR,uv_sample,N,Tb_modify,d_xi,d_eta,uv_to_DFT,uv_to_pi,ant_num,array_type,flag_debug_mode) 
%   �������ܣ���ͬ��Բ����״��uvƽ�������ֵ��α���������uvƽ�����**********************************
%               
%   �������:
%    V_ASR          ��ͬ��Բ����״�Ŀɼ��Ⱥ���          
%    uv_sample      ��ͬ��Բ����״��uv���������꣬Ҫ���Ƕ�2pi�Ѿ���һ���˵�����
%    N              ��α�������������ֵ���α������Ϊ2N*2N
%   Tb_modify       ����������ͼ�����������
%   uv_to_DFT,      ��uvƽ�桪DFTƽ�������ת������
%   uv_to_pi        ��uvƽ�桪2pi��һ��Ƶ��ƽ�������ת������
%   d_xi,d_eta      : ͼ��Ķ�ά������ߴ�
%   ant_num         ���������߸���         
%   array_type      ���������ͣ�α�������ֵֻ֧�־���Բ�������תԲ���� 
%   flag_debug_mode ������ģʽ��־λ

%   ���������
%    V_ASR_PP       : ��ֵ���α������ɼ��Ⱥ���������PPFFT���������˳��BV��BH�ֿ����У�����2N*2N����
%    uv_sample_PP   ��α�����������uv���꣬����-pi~pi��Χ��һ����Ҳ�ǰ���PPFFT���������˳��BV��BH�ֿ����У�����2N*2N���� 
%   by �¿� 2016.06.24  ******************************************************   

if (strcmpi('O_Rotate_shape',array_type))
    if flag_debug_mode == 0
    %��תԲ�����е�α�������ֵ
       [V_ASR_PP,uv_sample_PP,uv_area_rotate,uv_sample_rotate,redundancy] = PP_interp_for_Rotate(V_ASR,uv_sample,N,uv_to_pi); 
    else
    %��תԲ�����е�α�������ֵ--���԰汾
       [V_ASR_PP,uv_sample_PP,uv_area_rotate,uv_sample_rotate] = PP_interp_for_Rotate_debug(V_ASR,uv_sample,N,Tb_modify,d_xi,d_eta,uv_to_DFT,uv_to_pi);  
    end
else if (strcmpi('O_shape',array_type)) %����Բ������        
        %�������Բ������uv����ƽ��İ뾶����ÿȦ��������
        if mod(ant_num,2) == 0   %ż��������
           num_radius = ant_num/2; num_theta = ant_num; %����Բ����Ԫ������UV������뾶������ÿȦ��������
        else                     %����������    
           num_radius = (ant_num-1)/2; num_theta = 2*ant_num;
        end
        if flag_debug_mode == 0
        %����Բ�����е�α�������ֵ
           [V_ASR_PP,uv_sample_PP] = PP_interp(V_ASR,uv_sample,num_radius,num_theta,N);
        else
        %����Բ�����е�α�������ֵ--���԰汾
           [V_ASR_PP,uv_sample_PP] = PP_interp_debug(V_ASR,uv_sample,num_radius,num_theta,N,Tb_modify,d_xi,d_eta,uv_to_DFT,uv_to_pi);
        end
    else
        error([array_type,'���в��ܽ���α�������ֵ']);        
    end
        
end