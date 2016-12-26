x = linspace(0,8);
y = 2*x;
figure
h = plot(x,y);
pause

h.XDataSource = 'x';
h.YDataSource = 'y';

y = 4*x;
refreshdata