    max_Long = double((max(max(GRAPESlon))));
    min_Long = double((min(min(GRAPESlon))));
    max_Lat = double((max(max(GRAPESlat))));
    min_Lat = double((min(min(GRAPESlat))));
    
    
    figure;%����millerƽ��ͶӰ��������½������
    axesm('miller','MapLatLimit',[min_Lat max_Lat],'MapLonLimit',[min_Long max_Long]);framem;  mlabel on;  plabel on;  gridm on; 
    load coast;plotm(lat,long,'-k','LineWidth', 1.8);%������½�ؽ���
    ylabel('γ��(\circ)');xlabel('���ȣ�\circ��');hold on; 
%     title('ch27-183.31��3GHz');
%     ATMSTitleName=sprintf('ATMS-TB-%s-%s',frequency,ATMS_time);
    h=pcolorm(double(GRAPESlat), double(GRAPESlon), double((TA(:,:)))); set(h,'edgecolor','none');colormap jet;colorbar;  %����ATMS����   
%        caxis([T_min, T_max]) ;
