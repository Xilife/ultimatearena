///fighter_list_ui

// Whenever you click on a name in the fighter list, this is the code that runs.

var WS = global.WSCALE;
var HS = global.HSCALE;

var d = sID;
if (d > 0 && global.DEATH_ARRAY[d] == 0 && instance_number(objUIWindow) < 100)
{
    with (objUIWindowCaption) 
    {
        if(caption == global.NAMES[d] + " - Fighter \#" + string(d))
            exit;
    }
    with (zui_main()) 
    {
        create_window_fighter(d);
    }
}

