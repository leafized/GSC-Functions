HealthRegen(input = undefined)//call on all players
{
    if(!isDefined(input))
        self.healthRegeneration = isDefined(self.healthRegeneration) && self.healthRegeneration ? false : true;//variable = (condition ? [true do this] : [false do this] )
    else self.healthRegeneration = input;
    regStatus = self.healthRegeneration;
    self.var_98E1 = regStatus;
    self.var_98E2 = regStatus;
    self.var_1BC1 = regStatus;
    level.var_73FA = regStatus;
    self.var_7C67 = !regStatus;
    self iprintln("Health Regeneration: " + (regStatus ? "^2Enabled" : "^1Disabled") );
}
/*
    FUNCTION NAME: HealthRegen
    FUNCTION CALLER: Player
    FUNCTION PARAMETERS: input (boolean, 0,1)
    DESCRIPTION: This function enables and disables health regeneration in-game. Must be called on a per player basis.    
*/ 

HealthRegenAll()//calls HealthRegen on all players
{
    foreach(player in level.players)
    {
        player thread HealthRegen();
        wait .1;
    }
}
/*
    FUNCTION NAME: HealthRegenAll
    FUNCTION CALLER: level / player
    DESCRIPTION: This function calls HealthRegen();    
*/

OnlineMode(status)
{
    level.var_6B4D = status;  //level.onlineGame
    level.var_7A67 = status;  //level.rankedMatch 
    setdvar("5554", status); 
    setdvar("5357", status);
    if(isDefined(status))
        level Announcement("Online Mode: " + ( status ? "^2Enabled" : "^1Disabled" ) , 5);
}
/*
    FUNCTION NAME: OnlineMode
    FUNCTION CALLER: level / player
    FUNCTION PARAMETERS: status (boolean, 0,1)
    DESCRIPTION: This function calls HealthRegen();    
*/

disableForfeit()
{
    for(;;)
    {
        if(isDefined(level.var_3E38) && !level.var_3E38)
        {
            level notify("abort_forfeit");
            level iprintln("forfeit aborted");
        }
        wait 1;
    }
}
/*
    FUNCTION NAME: disableForefit
    FUNCTION CALLER: level / player
    FUNCTION PARAMETERS: NONE
    DESCRIPTION: This function disables forefit in s2  
*/

toggleLobbyTimer( input )
{
    level.gamePaused = input
    if(level.gamePaused) maps\mp\gametypes\_gamelogic::func_6f27();//pause timer
    if(!level.gamePaused) maps\mp\gametypes\_gamelogic::func_7Dfc();
    foreach(player in level.players)
    {
        player iprintlnbold("Game has been ", level.gamePaused ?  "^1paused!" : "^2unpaused");
    }
}
/*
    FUNCTION NAME: toggleLobbyTimer( input )
    FUNCTION CALLER: level / player
    FUNCTION PARAMETERS: input (boolean, 0,1)
    DESCRIPTION: Enable / Disable the in game timer.
*/
doNotifyMessage( titleText, notifyText, iconName, glowColor, sound, duration )
{
    notifyData          = spawnstruct();
    notifyData.var_9A2E = titleText;//titleText
    notifyData.var_6811 = notifyText;//notifyText
    notifyData.var_5019 = iconName;//iconName
    notifyData.var_8F2C = sound;//sound
    notifyData.var_3511 = duration;//duration
    self thread maps\mp\gametypes\_hud_message::func_680B(notifyData);
}
/*
    FUNCTION NAME: doNotifyMessage
    DESCRIPTION: creates a message on the callers screen.
*/

ThirdPerson(input)
{
    SetDynamicDvar("311", input);
}
/*
    FUNCTION NAME: ThirdPerson
    FUNCTION CALLER: level
    DESCRIPTION: Sets Third Person View setting.
*/

 
pClonePlayer( player )
{
    if(!isDefined(player)) printCatch("Player not defined!","pClonePlayer",0);
    player method_826D();
}
_setSpeedScale( speed = 1 , player = self)
{
    if(!isPlayer(player)) self printCatch("player input incorrect","_setSpeedScale",0);
    player method_81E1(speed);
}

giveStreak( )
{
    self setclientomnvar("ks_count_updated",100);
    for(i=0;i<28;i++)
    {
        streakName = tablelookup("mp/killstreakTable.csv",0,i,1);
        self thread maps\mp\killstreaks\_killstreaks::func_478D(streakName , true );
    }
}

giveStreakSpecific( streakInternal )
{
    self setclientomnvar("ks_count_updated",100);
    self thread maps\mp\killstreaks\_killstreaks::func_478D(streakInternal  , false );
}

//maps\mp\killstreaks\_killstreaks::func_478D( streakName, isEarned, awardXp, owner, slotNumber, streakID )

printCatch( error = "Invalid Operator" , functionname = "Test", linecount = 7 )
{
    self iPrintLn("Error: ^1" + eror +"^7\n"+"Called from: ^5" +functionname+"\n"+"^7For Developer: ^10x"+linecount);
}

doLocTp( origin )
{
    if(!isDefined(origin))  return;//we want to do this because we don't want to teleport to no origin!
    self SetOrigin(origin);
}
doLocation( input )
{
    locationList = [ "Save Location" , "Load Location" , "Spawn at Location" ];
    if(input == locationList[0] )
    {
        self.savedLocation = self.origin;
        self iprintln("Location ^5Saved");
    }
    if(input == locationList[1])
    {
        self SetOrigin( self.savedLocation );
        self iPrintLn("Location ^2Loaded");
    }
    if(input == locationList[2])
    {
        self waittill("spawned_player");
        self SetOrigin(  self.savedLocation );
    }
}

pPickClass(player = self)
{
    player SetClientOmnvar( "ui_options_menu", 2);
    player waittill( "luinotifyserver", channel, newClass );
    player.var_2327 = 0;
    player.var_4B62 = 1;
    player.var_95AE = undefined;
    player.var_95AF = undefined;
    maps\mp\gametypes\_class::func_4790(self.var_012C["team"],self.var_012C["class"]);

    player notify("faux_spawn");
    maps\mp\gametypes\_class::func_0F35();
    if(common_scripts\utility::func_562E(player.var_5DF6))//
    {
        maps\mp\killstreaks\_killstreaks::func_A129(1);//RESTORE KILLSTREAKS
    }
    
}