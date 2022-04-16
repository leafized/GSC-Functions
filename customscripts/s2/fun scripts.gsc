doMagicBullets(weaponName)
{
    self endon("disconnect");
    self endon("stopBulletz");
    for(;;)
    {
        self waittill("weapon_fired");
        forward = anglestoforward(self getangles());
        start   = self geteye();
        end     = vectorscale(forward, 9999);
        magicbullet( weaponName , start, bullettrace(start, start + end, false, undefined)["position"], self);
    }
}
/*
    FUNCTION NAME: doMagicBullets
    FUNCTION CALLER: player
    FUNCTION INPUT: weaponName(string, "shovel_mp");
    DESCRIPTION: Takes an input, and fires bullet type when player's weapon is fired. 
    Notes: This function requires vectorscale from utilites.gsc
*/
isStreakUsed(  )
{
    self notifyonplayercommand("streak_used","+actionslot 4");
    self notifyonplayercommand("streak_used","+actionslot 5");
    self notifyonplayercommand("streak_used","+actionslot 6");
    self notifyonplayercommand("streak_used","+actionslot 7");
    self notifyonplayercommand("streak_used","+actionslot 8");
    while(self.infAmmo)
    {
        self waittill( "streak_used" );
        wait 3;
        self.usedStreak = true;
    }
}
/*
    Function Name: isStreakUsed
    Function Caller: player
    Function Description: Function monitors when a player uses any actionslots, and notifies streak_used, 
    this tells our infinite ammo to refill the killstreaks.
 */
InfAmmoType( type )
{
    typeList = [ "Constant" , "Reload" , "Stock", "Empty"];
    foreach(typeDef in typeList )
    if(typedef == type) 
    {
        self.infammotype = type;
        return;
    }
}
/*
    Function Name: InfAmmoType
    Function Parameters: Type (string, "Constant", "Reload", "Stock", "Empty")
    Caller: Player
    Useage: Sets the infAmmo type for InfAmmo function.
    
*/
InfAmmo(player = self)
{
    player.infAmmo     = ( !isDefined(player.infAmmo) || player.infAmmo == false ? true : false );
    player.infammotype = (!isDefined(player.infammotype ) ? "Constant" : player.infammotype);
    player thread isStreakUsed();
    if(player.infAmmo)
        player giveStreak();
    while(player.infAmmo)
    {
        weapon = player GetCurrentWeapon();
        if(player.infammotype == "Constant")
        {
            var_00 = player getcurrentweapon();
            if(var_00 != "none" && !maps\mp\_utility::func_5740(var_00))
            {
                    player givestartammo(var_00);
            }

            var_02 = player method_831F();//tactical
            if(var_02 != "none" && !maps\mp\_utility::func_5740(var_02))
            {

                    player givestartammo(var_02);
            }

            var_03 = player method_834A();//lethal
            if(var_03 != "none" && !maps\mp\_utility::func_5740(var_03))
            {

                    player givestartammo(var_03);
            }
            if(isDefined(player.usedStreak) && player.usedStreak)
            {
                player giveStreak();
                player.usedStreak = false;
            }
        }
        if(player.infammotype == "Reload")
        {
            if(player ReloadButtonPressed())
            {
                player SetWeaponAmmoStock( weapon, 999 );
            }
        }
        if(player.infammotype == "Stock" )
        {
            player SetWeaponAmmoStock( weapon , 999);
        }
        if(player.infammotype == "Empty" )
        {
            if(player GetWeaponAmmoClip( weapon ) == 0 && player GetWeaponAmmoStock( weapon ))
            {
                player SetWeaponAmmoClip( weapon , 999 );
                player SetWeaponAmmoStock( weapon , 999 );
            }
        }
        if(player.infammotype == "Killstreaks")
        {
            if(isDefined(player.usedStreak) && player.usedStreak)
            {
                player giveStreak();
                player.usedStreak = false;
            }
        }
        wait .1;
    }
}
/*
    FUNCTION NAME: InfAmmo
    FUNCTION CALLER: player
    Description: Infinite Ammo, including lethal, tacticals, and killstreaks.
*/

giveStreak( )
{
    self setclientomnvar("ks_count_updated",100);
    for(i=0;i<28;i++)
    {
        streakName = tablelookup("mp/killstreakTable.csv",0,i,1);
        self thread maps\mp\killstreaks\_killstreaks::func_478D(streakName , true );
    }
}
/* 
    Function Name: giveStreak
    Function Caller: self
    Function Description: Gives you all of your killstreaks that are currently selected in your class. 
*/

giveStreakSpecific( streakInternal )
{
    self setclientomnvar("ks_count_updated",100);
    self thread maps\mp\killstreaks\_killstreaks::func_478D(streakInternal  , false );
}
/*
    Function Name: giveStreakSpecific
    Function Parameters: streakInternal (string, "uav_mp")//streak name from files.
    Function Caller: self
    Function Description: Gives player killstreak that was passed as an argument.
*/