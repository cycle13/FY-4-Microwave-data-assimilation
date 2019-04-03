function  T = spatial_IDFT_2D(spectrum,radian_x,radian_y,d_f_x,d_f_y,cordinate_f_x,cordinate_f_y)
 %������ʵ�ֿռ�ͼ���ά��ɢ�渵��Ҷ�任����
 %T������ռ�ͼ��d_f_x,d_f_y���ռ�Ƶ����ά�ϵķֱ��ʣ���λHz/rad��radian_x,radian_y���ռ���ά�ϵ����꣬��λrad��cordinate_f_x,cordinate_f_y���ռ�Ƶ���������
   [N_y,N_x] = size(spectrum);
   T = zeros(N_y,N_x);
   matlabpool open ;
   parfor y =1:N_y
         for x=1:N_x
             T(y,x) = real(sum(sum(spectrum.*exp(1i*2*pi*(radian_x(x)*cordinate_f_x+radian_y(y)*cordinate_f_y))))*d_f_x*d_f_y);              
         end
   end
   matlabpool close;