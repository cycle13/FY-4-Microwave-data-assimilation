% ͼ���������ϵͳ��Ӧ����PSF�������%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function inv_PSF = PSF_inversion(PSF,regulation_para)
% PSF:ϵͳ��Ӧ������k:���򻯲���
[U,s,V] = csvd(PSF);
param = size(PSF,1);
inv_PSF = V(:,1:param)*diag(s(1:param)./(s(1:param).^2+regulation_para.^2))*U(:,1:param)';
%inv_PSF = V(:,1:param)*diag(1./s(1:param_Long))*U(:,1:param_Long)'; 
inv_PSF = APN(inv_PSF,PSF);