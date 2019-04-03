function [TA_RE,index_min] = Wiener_Filter_deconv(TA,TB,Pattern,NEDT,SNR_num,RMSE_offset)
%   �������ܣ� �Դ��й۲�����������ͼ��TA����Wiener_Filter������������ͼ��ֱ��ʺ;���****************
%              ����Wiener_Filter���ؽ��������ͼ��
%  
%   �������:
%    TA           �����ؽ��ĵͷֱ�������ͼ��TA
%    TB           : �����߷ֱ�������ͼ��
%    Pattern      �����߷���ͼ����
%    NEDT         : ����ƽ��ջ�������
%   ���������
%    TB           : Wiener_Filter�ؽ��������ͼ��                                       
%   by �¿� 2016.12.22  ******************************************************

%      [row,col] = size(TA_real);
%      Antenna_Pattern_WF = interpolation(Antenna_Pattern,row,col);
%      Spectrum_TA = fftshift(fft2(TA_real));
%      Spectrum_NN = fftshift(fft2(NN));
%      Spectrum_AP = fftshift(fft2(Antenna_Pattern_WF));
%      Wiener_filter = (Spectrum_TA-Spectrum_NN)*pinv(Spectrum_AP.*Spectrum_TA);
%       Spectrum_TA = fftshift(fft2(TA_real))*d_Long*d_Lat;
%       Spectrum_TB = fftshift(fft2(TB))*d_Long*d_Lat;
%       Spectrum_AP = fftshift(fft2(Antenna_Pattern))*d_Long*d_Lat;
%       Spectrum_NN = NEDT^2;
%       Wiener_filter = (Spectrum_TB*(Spectrum_AP'))*pinv((Spectrum_TB*((abs(Spectrum_AP)).^2)+Spectrum_NN));
%       TA_WF = real(ifft2(ifftshift(Wiener_filter*Spectrum_TA)));

%ֱ�ӵ���MATLAB deconvwnr����
        [row,col] = size(TB);
        TA = interpolation(TA,row,col);
        cf = abs(fft2(TA)).^2;
%       SNR_num = 100;
        RMSE_WF_analysis = zeros(1,SNR_num);
        for k = 1:1:SNR_num
            TA_RE = deconvwnr(TA, Pattern,numel(TA)*k*NEDT^2./cf);
            RMSE_WF_analysis(k) = Root_Mean_Square_Error(TB,TA_RE,RMSE_offset,0);
        end
%         figure; plot(RMSE_WF_analysis);
        index_min = find(RMSE_WF_analysis==min(RMSE_WF_analysis));
        TA_RE = deconvwnr(TA, Pattern,numel(TA)*index_min*NEDT^2./cf);
        
        