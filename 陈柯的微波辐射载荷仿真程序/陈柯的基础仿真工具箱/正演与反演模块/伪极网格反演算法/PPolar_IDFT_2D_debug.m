function T_inv = PPolar_IDFT_2D_debug(V,Tb,factor_PP,d_xi,d_eta)
%   �������ܣ�   ���ù����ݶȵ�����ʵ��α��������Բ�����е��ۺϿ׾�����ͼ��**********************************
%               
%  
%   �������:
%   V               ��α�������ϵĿɼ��Ⱥ���ֵ������BV��BH�ֿ����У�Ϊ2N*2N����

%   ���������
%   T            ��   ���ݵõ�������ͼ�񣬳ߴ�ΪN*N

%������ֵ���α������ɼ���ģֵ�Ͳ�����ֲ�
figure;imagesc(abs(V));colorbar;title('Բ�������ֵ�����α������ɼ��Ⱥ�������');                    
%��һάFFT�任���ټ����α��������ϵĿɼ��Ⱥ���
V_FFT_PP = PPFFT(Tb,factor_PP,factor_PP)*d_xi*d_eta; 
figure;imagesc(abs(V_FFT_PP));colorbar;title('PPFFT�任�����α������ɼ��Ⱥ�������'); 
%�����ֵ�õ���α���������ϵĿɼ��Ⱥ�����ֵ���
MSE_VPP = Mean_Square_Error(abs(V_FFT_PP),abs(V),0,0); title('PPFFT��ASRα������ɼ��Ⱥ������Ȳ�ֵ'); 
disp(['α������ɼ��ȷ�ֵ��ֵ���=',num2str(MSE_VPP)]);     
%ͨ����ι����ݶȵ�����ʵ��α�������ݵõ�����ͼ��
T_inv = Pseudo_Polar_Inv(V)/(d_xi*d_eta);  %�������� 