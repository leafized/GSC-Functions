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
    #ifdef WW2
        level.var_6B4D = status;  //level.onlineGame
        level.var_7A67 = status;  //level.rankedMatch 
        setdvar("5554", status); 
        setdvar("5357", status);
    #endif
    #ifdef MW2 
        le
    #endif
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