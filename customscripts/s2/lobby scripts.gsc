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