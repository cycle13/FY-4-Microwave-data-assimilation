function [RMSE,norm_RMSE] = Root_Mean_Square_Error(TA1,TA2,offset,flag_draw)
%   �������ܣ���RMSEʵ�ֶ�������ͬ��Χ������ͼ������Ƚ�**********************************
%            ���ͼ�����ص�����һ�£��򽫵ͷֱ���ͼ���ֵ���߷ֱ���ͼ��
%  
%   �������:
%    TA1            �����Ƚϵı�׼����ͼ��1         
%    TA2            ����������ͼ��2 
%    offset         ������ѡ��Ƚϵķ�Χ��offset����ȥ����������
%    flag_draw      ����ͼ��׼λ��1����������ͼ��Ĳ�ֵͼ��
%   ���������
%    RMSE           : ����ͼ���RMSEֵ������������� 
%    norm_RMSE      : ��һ����������������ͼ���׼��Ĺ�һ��
%   by �¿� 2016.10.24  ******************************************************  

  [row1,col1] = size(TA1);   
  [row2,col2] = size(TA2);
  
  if row1 == row2 && col1 == col2   %�������ͼ�����ص���ͬ
     row = row1;
     col = col1;
     num_pix=(row-2*offset)*(col-2*offset)-1;
     delta_T=(TA1-TA2).^2;
     delta_T=delta_T(1+offset:(row-offset),1+offset:(col-offset));
     RMSE = sqrt(sum(sum(delta_T,1),2)/(num_pix-1));
     delta_T = sqrt(delta_T);
  elseif row1 > row2
     row = row1;
     col = col1;
     TA2 = interpolation(TA2,row,col);
     num_pix=(row-2*offset)*(col-2*offset)-1;
     delta_T=(TA1-TA2).^2;
     delta_T=delta_T(1+offset:(row-offset),1+offset:(col-offset));
     RMSE = sqrt(sum(sum(delta_T,1),2)/(num_pix-1));
     delta_T = sqrt(delta_T);
  else
     row = row2;
     col = col2; 
     TA1 = interpolation(TA1,row,col);
     num_pix=(row-2*offset)*(col-2*offset)-1;
     delta_T=(TA1-TA2).^2;
     delta_T=delta_T(1+offset:(row-offset),1+offset:(col-offset));
     RMSE = sqrt(sum(sum(delta_T,1),2)/(num_pix-1));
     delta_T = sqrt(delta_T);
  end
  
  std_TA1 = std2(TA1(offset+1:row1-offset,offset+1:col1-offset));
  norm_RMSE = RMSE/std_TA1;
  
%   MAX = max(max(TA1));
%   PSNR = 10*log10((MAX^2)/MSE);
  
  if flag_draw == 1
      figure() ; imagesc(delta_T);axis equal; xlim([1,col-2*offset]);ylim([1,row-2*offset]);colorbar('eastoutside');title('�в�ͼ��')
  end


  
  