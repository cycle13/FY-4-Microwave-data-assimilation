function  spectrum = spatial_DFT_2D(T,f_x,f_y,d_radian_x,d_radian_y,cordinate_x,cordinate_y)
 %������ʵ�ֿռ�ͼ���ά��ɢ����Ҷ�任���ܣ����������
 %T������ռ�ͼ��f_x,f_y���ռ�Ƶ����ά���꣬��λHz/rad��d_radian_x,d_radian_y���ռ���ά�ϵķֱ��ʣ���λrad��cordinate_x,cordinate_y���ռ�������󣬵�λrad
   [N_y,N_x] = size(T);
   spectrum = zeros(N_y,N_x);
   matlabpool open ;
   parfor y =1:N_y
         for x=1:N_x
             spectrum(y,x) = sum(sum(T.*exp(-1i*2*pi*(f_x(x)*cordinate_x+f_y(y)*cordinate_y))))*d_radian_x*d_radian_y; 
         end
   end
   matlabpool close;