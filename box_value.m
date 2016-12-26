function box_value(hObj,event,hcb,hax) %#ok<*INUSL
        % Called when boxes are used
        v = get(hObj,'Value');
        I = find(hcb==hObj);
        %[axes visibility]:
        s = {'off','on'};
        ycol_r = {[1 1 1]*0.8,'r'}; % ycolor for red plot axes
        if I == 1
            set(hax(I),'Visible','off')
        else
            set(hax(I),'Visible','on')
        end
        %[line visibility]:
        hl = findobj(hax(I),'Type','line'); % line handles
        set(hl,'Visible',s{v+1})