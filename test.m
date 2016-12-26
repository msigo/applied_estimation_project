x=1:100;
axesPosition = [110 40 200 200];  %# Axes position, in pixels
yWidth = 30;                      %# y axes spacing, in pixels
xLimit = [min(x) max(x)];         %# Range of x values
xOffset = -yWidth*diff(xLimit)/axesPosition(3);
h4=plot(x,1:100)
hax = [h4]; % axes handles
hcb = [0]; % checkbox handle (preallocate)
cb_text = {'r  ','m  ','b ','Plot '}; % checkbox text
for i = 1:1
    hcb(i) = uicontrol('Style','checkbox','Value',1,...
                       'Position',[-30+i*40 1 40 15],'String',cb_text{i});
end
set(hcb,'Callback',{@box_value,hcb,hax});