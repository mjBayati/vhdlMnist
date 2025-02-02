w1 = importdata('./fixed_data/w1_fi.dat',',',0);
w2 = importdata('./fixed_data/w2_fi.dat',',',0);
b1 = importdata('./fixed_data/b1_fi.dat',',',0);
b2 = importdata('./fixed_data/b2_fi.dat',',',0);

te_data = importdata('./fixed_data/te_data_fi.dat',',',0);
te_label = importdata('./fixed_data/te_label.dat',',',0);

wl=16;
w_f =6; 
T=numerictype(1,wl,w_f);
F=fimath('RoundMode','floor',...
         'OverflowMode','Saturate',...
         'ProductMode','SpecifyPrecision',...
         'ProductWordLength',wl,...
         'ProductFractionLength',w_f,...
         'SumMode','KeepLSB',...
         'SumWordLength',wl,...
         'SumFractionLength',w_f);
         
w1=fi(w1,T,F);
w2=fi(w2,T,F);
b1=fi(b1,T,F);
b2=fi(b2,T,F);

te_data = fi(te_data,T,F);

fd = fopen('./Hex_data/w1_2s_comp.hex','w');
fprintf(fd,'16''h%c%c%c%c\n',hex(reshape(w1, size(w1,1)*size(w1,2),1))');
fclose(fd);

fd = fopen('./Hex_data/w2_2s_comp.hex','w');
fprintf(fd,'16''h%c%c%c%c\n',hex(reshape(w2, size(w2,1)*size(w2,2),1))');
fclose(fd);

fd = fopen('./Hex_data/b1_2s_comp.hex','w');
fprintf(fd,'16''h%c%c%c%c\n',hex(b1)');
fclose(fd);

fd = fopen('./Hex_data/b2_2s_comp.hex','w');
fprintf(fd,'16''h%c%c%c%c\n',hex(b2)');
fclose(fd);


fd = fopen('./Hex_data/te_data_2s_comp.hex','w');
fprintf(fd,'16''h%c%c%c%c\n',hex(reshape(te_data' , size(te_data,1)*size(te_data,2),1) )');
fclose(fd);