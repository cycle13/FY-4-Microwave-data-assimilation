function  AP = Antenna_Pattern_interp(antenna_pattern_angle,Antenna_Patter,angle)
%   �������ܣ����ò�ֵ������ָ���Ƕ�ֵ��Բ�ο�������ʵ�׾����߷���ͼ**********************************
%             ���ط���ͼȨֵ%  
%   �������:
%   antenna_pattern_angle        ������������ļн�
%   Antenna_Patter               : Բ�ο�������ʵ�׾����߷���ͼ
%   angle                        : ���߷���ͼ�ĽǶ�����
%   ���������
%   AP                           : ���߹�һ�����ʷ���ͼ                                       
%   by �¿� 2017.03.20  ******************************************************
AP = interp1(angle,Antenna_Patter,antenna_pattern_angle);%��ֵ�õ�ָ���Ƕȵ����߷���ͼ
AP(isnan(AP)) = 0;            %������ͼ�е�NaNֵ��Ϊ��
AP=AP/sum(sum(AP));           %���߷���ͼ��һ��