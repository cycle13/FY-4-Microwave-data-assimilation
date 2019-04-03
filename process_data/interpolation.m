function TA2 = interpolation(TA,Num_row,Num_col)
%   �������ܣ���ֵ���������ͷֱ���ͼ�񣬲�ֵ�����߷ֱ���***********************************
%            
%  
%   �������:
%    TA             ����������ͼ��1         
%    Num_row        ����ֵ������ 
%    Num_col        ����ֵ������ 
%   ���������
%    TA2            : ��ֵ��ĸ߷ֱ���ͼ��                                       
%   by �¿� 2016.06.24  ******************************************************  
      y_1=linspace(1,Num_row,Num_row);
      x_1=linspace(1,Num_col,Num_col);
      [col_1,row_1]=meshgrid(x_1,y_1);
      N_y_2=size(TA,1);
      N_x_2=size(TA,2);
      y_2=linspace(1,Num_row,N_y_2);
      x_2=linspace(1,Num_col,N_x_2);
      [col_2,row_2]=meshgrid(x_2,y_2);
      TA2 = interp2(col_2,row_2,TA,col_1,row_1,'spline');  %����������ֵ���������