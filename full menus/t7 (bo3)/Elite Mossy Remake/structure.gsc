initializeSetup( access, player, allaccess )
{
    if(isDefined(player.access) && access == player.access && !player isHost())
        return self iprintln("^1Error ^7" + player.name + " is already this access level.");
    if(isDefined(player.access) && player.access == 5 )
        return self iprintln("^1Error ^7You can not edit players with access level Host.");
    if(isDefined(player.access) && player == self)
        return self iprintln("^1Error ^7You can not edit you're own access level.");
            
    player notify("end_menu");
    player.access = access;
    
    if( player isMenuOpen() )
        player menuClose();

    player.menu = [];
    player.previousMenu = [];
    player.menu["isOpen"] = false;
    player.menu["isLocked"] = false;

    if( !isDefined(player.menu["current"]) )
         player.menu["current"] = "main";
         
    if(player != self && !IsDefined(allaccess))
        self IPrintLn(player.name + " Access Set " + level.Status[player.access]);
        
    player menuOptions();
    player thread MenuAccessSpawn();
    player thread menuMonitor();
}

AllPlayersAccess(access)
{
    if(level.players.size <= 1)
        return IPrintLn("^1Error: ^7No Players Found");
    
    self IPrintLn("All Players Access Set " + level.Status[access]);
    foreach(player in level.players)
    {
        if(player isHost() || player == self)
            continue;
            
        self thread initializeSetup(access, player, true);
        wait .1;
    }
}

newMenu( menu )
{
    if(!isDefined( menu ))
    {
        menu = self.previousMenu[ self.previousMenu.size -1 ];
        self.previousMenu[ self.previousMenu.size -1 ] = undefined;
    }
    else 
        self.previousMenu[ self.previousMenu.size ] = self getCurrentMenu();
        
    self setCurrentMenu( menu );
    self menuOptions();
    self setMenuText();
    self refreshTitle();
    self updateScrollbar();
}

addMenu( menu, title, access )
{
    self.storeMenu = menu;
    if(self getCurrentMenu() != menu)
        return;
        
    self.currentMenuColour = access;
    self.MenuTitle         = title;
    self.eMenu             = [];
    if(!isDefined(self.menu[ menu + "_cursor"]))
        self.menu[ menu + "_cursor"] = 0;
    if(!IsDefined(self.menu[ "submenu_cursor" ]))   
        self.menu[ "submenu_cursor" ] = 0;
}

addOpt( opt, func, p1, p2, p3, p4, p5 )
{
    if(self.storeMenu != self getCurrentMenu())
        return;
        
    option      = spawnStruct();
    option.opt  = opt;
    option.func = func;
    option.p1   = p1;
    option.p2   = p2;
    option.p3   = p3;
    option.p4   = p4;
    option.p5   = p5;
    self.eMenu[self.eMenu.size] = option;
}

addOptDesc( opt, title, shader, desc, func, p1, p2, p3, p4, p5 )
{
    if(self.storeMenu != self getCurrentMenu())
        return;
        
    option        = spawnStruct();
    option.opt    = opt;
    option.title  = title;
    option.shader = shader;
    option.desc   = desc;
    
    option.func   = func;
    option.p1     = p1;
    option.p2     = p2;
    option.p3     = p3;
    option.p4     = p4;
    option.p5     = p5;
    self.eMenu[self.eMenu.size] = option;
}

setCurrentMenu( menu )
{
    self.menu["current"] = menu;
}

getCurrentMenu()
{
    return self.menu["current"];
}

getCursor()
{
    return self.menu[ self getCurrentMenu() + "_cursor" ];
}

isMenuOpen()
{
    if( !isDefined(self.menu["isOpen"]) || !self.menu["isOpen"] )
        return false;
        
    return true;
}
