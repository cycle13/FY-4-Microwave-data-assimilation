function [R] = TB_correlation_coefficient(TA1,TA2,offset)
%   �������ܣ�����������ͬ��Χ������ͼ�����ϵ��**********************************
%            ���ͼ�����ص�����һ�£��򽫵ͷֱ���ͼ���ֵ���߷ֱ���ͼ��
%  
%   �������:
%    TA1            �����Ƚϵı�׼����ͼ��1         
%    TA2            ����������ͼ��2 
%    offset         ������ѡ��Ƚϵķ�Χ��offset����ȥ����������%   
%   ���������
%    R              : ����ͼ������ϵ���������ȫ��ͬ��ͼ����Ϊ1 
%   
%   by �¿� 2016.12.14  ******************************************************  

  [row1,col1] = size(TA1);   
  [row2,col2] = size(TA2);
  %������ͼ������ص�����ֵ����ͬ
  if row1 == row2 && col1 == col2   %�������ͼ�����ص���ͬ
     row = row1;
     col = col1;     
  elseif row1 > row2
     row = row1;
     col = col1;
     TA2 = interpolation(TA2,row,col);     
  else
     row = row2;
     col = col2; 
     TA1 = interpolation(TA1,row,col);     
  end
  X = TA1(1+offset:(row-offset),1+offset:(col-offset));
  Y = TA2(1+offset:(row-offset),1+offset:(col-offset));
  R = corr2(X,Y);
 
  



  
  