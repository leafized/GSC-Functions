menuMonitor()
{
    self endon("disconnected");
    self endon("end_menu");
    while( true )
    {
        if(!self.menu["isLocked"])
        {
            if(!bool(self.menu["isOpen"]))
            {
                if( self meleeButtonPressed() && self adsButtonPressed() )
                {
                    self menuOpen();
                    wait .2;
                }               
            }
            else 
            {
                if( self attackButtonPressed() || self adsButtonPressed() )
                {
                    self.menu[ self getCurrentMenu() + "_cursor" ] += self attackButtonPressed();
                    self.menu[ self getCurrentMenu() + "_cursor" ] -= self adsButtonPressed();
                    self scrollingSystem();
                    
                    wait .15;
                }
                
                else if( (self ActionSlotThreeButtonPressed() || self ActionSlotFourButtonPressed()) && ( !IsSubStr(self getCurrentMenu(), "client_") || !self isInMain() ) )
                {
                    self.menu[ "submenu_cursor" ] += self ActionSlotThreeButtonPressed();
                    self.menu[ "submenu_cursor" ] -= self ActionSlotFourButtonPressed();
                    
                    if(self getSubmenuCurs() > getSubmenus().size-1)
                        self setSubmenuCurs( 0 );
                        
                    if(self getSubmenuCurs() < 0)
                        self setSubmenuCurs( getSubmenus().size-1 );
                        
                     self thread newMenu( self getSubmenus()[getSubmenuCurs()].p1 );
                    
                    wait .15;
                }
                
                else if( self useButtonPressed() )
                {
                    menu = self.eMenu[self getCursor()];
                    self thread doOption(menu.func, menu.p1, menu.p2, menu.p3, menu.p4, menu.p5);
                    wait .15;
                }
                
                else if( self meleeButtonPressed() )
                {
                    if( self isInMain() )
                        self menuClose();
                    else
                        self newMenu();
                        
                    wait .2;
                }
            }
        }
        wait .05;
    }
}

doOption(func, p1, p2, p3, p4, p5, p6)
{
    if(!isdefined(func))
        return;
    if(isdefined(p6))
        self thread [[func]](p1,p2,p3,p4,p5,p6);
    else if(isdefined(p5))
        self thread [[func]](p1,p2,p3,p4,p5);
    else if(isdefined(p4))
        self thread [[func]](p1,p2,p3,p4);
    else if(isdefined(p3))
        self thread [[func]](p1,p2,p3);
    else if(isdefined(p2))
        self thread [[func]](p1,p2);
    else if(isdefined(p1))
        self thread [[func]](p1);
    else
        self thread [[func]]();
}

menuOpen()
{
    self endon("MenuClosed");
    self.menu["isOpen"] = true;
    self SetBlur(13, .01);
    self menuOptions();
    self drawText(); 
    #ifdef MP visionset_mgr::activate("visionset", "sentinel_visionset", self, 0, 90000, 0); #endif
    #ifdef ZM visionset_mgr::activate("visionset", "zm_bgb_eye_candy_vs_3", self);  #endif
    #ifdef SP visionset_mgr::activate("visionset", "overdrive", self);  #endif
    self newMenu(self getSubmenus()[getSubmenuCurs()].p1);
    self updateScrollbar();
}

menuClose()
{
    self SetBlur(0, .01);
    self destroyAll(self.menu["OPT"]);
    #ifdef MP visionset_mgr::deactivate("visionset", "sentinel_visionset", self); #endif
    #ifdef ZM visionset_mgr::deactivate("visionset", "zm_bgb_eye_candy_vs_3", self); #endif
    #ifdef SP visionset_mgr::deactivate("visionset", "overdrive", self); #endif
    self notify("MenuClosed");
    self.menu["isOpen"] = false;
}

drawText()
{
    self endon("MenuClosed");
    if(!isDefined(self.menu["OPT"]))
        self.menu["OPT"] = [];
        
    self.menu["OPT"]["BG"] = self createRectangle("CENTER", "CENTER", 0, 0, 1000, 1000, (0, 0, 0), "white", 0, .6);
        
    for(e=0;e<3;e++)
    {
        fontscale = 1.7;
        if(e == 1)
            fontscale = 1.9;
        
        self.menu["OPT"]["TITLE" + e] = self createText("default", fontscale, "CENTER", "CENTER", -140 + (e * 140), -205, 3, 0, "", (1, 1, 1));//185    
        self.menu["OPT"]["TITLE" + e] thread hudFade(1, .2);
    }
    self refreshTitle();

    for(e=0;e<15;e++)
    {
        self.menu["OPT"][e] = self createText("default", 1.5, "CENTER", "TOP", 0, (level.console ? 30 : 60) + (e * 18), 3, 0, "", (1, 1, 1));
        self.menu["OPT"][e] thread hudFade(1, .2);
    }
    self setMenuText();
}

getSubmenus()
{
    self endon("MenuClosed");
    
    if(IsDefined( self.submenus ))
        return self.submenus;
        
    self.submenus = [];
    for(e=0;e<self.eMenu.size;e++)
    {
        if(isDefined(self.eMenu[e].func) && self.eMenu[e].func == ::newMenu)
            self.submenus[self.submenus.size] = self.eMenu[e];
    }
        
    return self.submenus;
}

getSubmenuCurs()
{ 
    return self.menu[ "submenu_cursor" ];
}

setSubmenuCurs( val )
{ 
    self.menu[ "submenu_cursor" ] = val;
}

refreshTitle()
{
    self endon("MenuClosed");
    if(IsSubStr(self getCurrentMenu(), "client_") || !self isInMain())
    {
        for(e=0;e<3;e++)
        {
            if(e == 1)
            {
                self.menu["OPT"]["TITLE" + e ] setText(self.MenuTitle);
                self.menu["OPT"]["TITLE" + e ].color = (getSubmenusColourAccess(self.currentMenuColour)[0], getSubmenusColourAccess(self.currentMenuColour)[1], getSubmenusColourAccess(self.currentMenuColour)[2]);
            }
            else
            {
                self.menu["OPT"]["TITLE" + e ] setText( "" );
                self.menu["OPT"]["TITLE" + e ].color = (1, 1, 1);
            }
        }
    }
    else
    {
    
        for(e=0;e<3;e++)
        {
            self.menu["OPT"]["TITLE" + e ] setText(self getSubmenus()[revalueTitles(getSubmenuCurs() + (e - 1), getSubmenus())].opt);
            if(e == 1)
            {
                self.menu["OPT"]["TITLE" + e ].color = (getSubmenusColourAccess(self.currentMenuColour)[0], getSubmenusColourAccess(self.currentMenuColour)[1], getSubmenusColourAccess(self.currentMenuColour)[2]);
            }
            else
                self.menu["OPT"]["TITLE" + e ].color = (1, 1, 1);
        }
            
    }
}
    
isInMain()
{
    self endon("MenuClosed");
    for(e=0;e<getSubmenus().size;e++)
        if( getSubmenus()[e].p1 == getCurrentMenu() )
            return true;
            
    return false;
}
 
revalueTitles(value, array)
{
    if(value < 0) return value + array.size;
    if(value >= array.size) return value - array.size;
    return value;
}

scrollingSystem()
{
    if(self getCursor() >= self.eMenu.size || self getCursor() < 0 || self getCursor() == 13)
    {
        if(self getCursor() <= 0)
            self.menu[ self getCurrentMenu() + "_cursor" ] = self.eMenu.size -1;
        else if(self getCursor() >= self.eMenu.size)
            self.menu[ self getCurrentMenu() + "_cursor" ] = 0;
        self setMenuText();
        self updateScrollbar();
    }
    if(self getCursor() >= 14)
        self setMenuText();
    else 
        self updateScrollbar();
}

updateScrollbar()
{
    self endon("MenuClosed");
    curs = self getCursor();
    if(curs >= 14)
        curs = 13;
        
    self notify("stop_text_effects");
    wait .05;  
    self.menu["OPT"][curs] thread flashElemMonitor( self );  
    self.menu["OPT"][curs] thread flashElem( 1, .5, .13, self );   
}

setMenuText()
{
    self endon("MenuClosed");
    ary = 0;
    if(self getCursor() >= 14)
        ary = self getCursor() - 13;
        
    for(e=0;e<20;e++)
    {
        if(isDefined(self.eMenu[ e ].opt))
            self.menu["OPT"][ e ] setText( self.eMenu[ ary + e ].opt );
        else     
            self.menu["OPT"][ e ] setText( "" );
    }
}
        
flashElem( alpha1, alpha2, time, player )
{
    player endon("MenuClosed");
    player endon("stop_text_effects");
    self.fontScale = 1.9;
    for(;;)
    {
        r          = randomint(255); g = randomint(255); b = randomint(255);
        self.color = ( (r / 255), (g / 255), (b / 255) );
        self fadeOverTime(.2);
        wait .2;
    }
}

flashElemMonitor( player )
{
    player endon("MenuClosed");
    player waittill("stop_text_effects");  
    self.color     = (1, 1, 1);
    self.fontScale = 1.5;
}
