/*
    FUNCTION NAME: BoxPrice
    HOW TO USE: Call the function and add an int as an arg to set the value
    EXAMPLE: self addOption(Submenu name, index, "Option Title", "Description", ::BoxPrice, 1000);
    DESCRIPTION: This function alters the mystery box price, int range can be as high or low as you want.
    NOTE: The example use may be slightly different to how your menu adds options. 
*/
BoxPrice(value)
{
    foreach(chest in level.chests) chest.zombie_cost = value;
}

/*
    FUNCTION NAME: NoFallDam
    HOW TO USE: Call the function as a toggle and the function will switch between the two setting dvars depending on if level.BO4NoFallD is defined or not.
    EXAMPLE: self addOptBool(level.BO4NoFallD, "No Fall", &BO4NoFallDam);
    DESCRIPTION: This function alters the fall damage.
    NOTE: The example use may be slightly different to how your menu adds options. 
*/
NoFallDam()
{
    level.BO4NoFallD = isDefined(level.BO4NoFallD) ? undefined : true;
    if(isDefined(self.BO4NoFallD))
    {
        SetDvar(#"bg_fallDamageMinHeight", 9999);
        SetDvar(#"bg_fallDamageMaxHeight", 9999);
    }
    else
    {
        setdvar(#"bg_falldamageminheight", 256);
        setdvar(#"bg_falldamagemaxheight", 512);
    }
}

/*
    FUNCTION NAME: SuperJump
    HOW TO USE: Call the function as a toggle and the function will switch between the two setting dvars depending on if level.SuperJump is defined or not.
    EXAMPLE: self addOptBool(level.SuperJump, "Super Jump", &SuperJump);
    DESCRIPTION: This function toggles superjump for everyone in the lobby
    NOTE: The example use may be slightly different to how your menu adds options. 
*/
SuperJump()
{
    level.SuperJump = isDefined(level.SuperJump) ? undefined : true;
    if(isDefined(level.SuperJump))
    {
        foreach(player in level.players)
            player thread AllSuperJump();
    }
}

AllSuperJump()
{
    self endon("disconnect");
    while(isDefined(level.SuperJump))
    {
        if(self JumpButtonPressed())
        {
            for(i=0;i<5;i++)
                self SetVelocity(self GetVelocity() + (0, 0, 140));

            while(!self IsOnGround())
                wait .05;
        }
        wait .05; 
    }
}

/*
    FUNCTION NAME: SuperSpeed
    HOW TO USE: Call the function as a toggle and the function will switch between the two setting dvars depending on if level.SuperSpeed is defined or not.
    EXAMPLE: self addOptBool(level.SuperSpeed, "Super Speed", &SuperSpeed);
    DESCRIPTION: This function toggles SuperSpeed for everyone in the lobby
    NOTE: The example use may be slightly different to how your menu adds options. 
    ADDITIONAL INFO: If you want to add this to an int slider then you can add "value" to the functions params, SuperSpeed(value), and then alter the setDvar part to this: setDvar("g_speed", value);
*/
SuperSpeed()
{
    level.SuperSpeed = isDefined(level.SuperSpeed) ? undefined : true;

    if(isDefined(level.SuperSpeed))
        setDvar("g_speed", 500);
    else
        setDvar("g_speed", 200);
}

/*
    FUNCTION NAME: B4Gravity
    HOW TO USE: Call the function as a toggle and the function will switch between the two setting dvars depending on if level.B4Gravity is defined or not.
    EXAMPLE: self addOptBool(level.B4Gravity, "Gravity", &B4Gravity);
    DESCRIPTION: This function toggles B4Gravity for everyone in the lobby
    NOTE: The example use may be slightly different to how your menu adds options. 
    ADDITIONAL INFO: If you want to add this to an int slider then you can add "value" to the functions params, B4Gravity(value), and then alter the setDvar part to this: setDvar("bg_gravity", value);
*/
B4Gravity()
{
    level.B4Gravity = isDefined(level.B4Gravity) ? undefined : true;
    if(isDefined(level.B4Gravity))
        SetDvar("bg_gravity", 100);
    else
        SetDvar("bg_gravity", 350);
}

/*
    FUNCTION NAME: AntiJoin
    HOW TO USE: Call the function as a toggle and the function will switch between the two setting dvars depending on if level.AntiJoin is defined or not.
    EXAMPLE: self addOpt("Anti Join", &AntiJoin);
    DESCRIPTION: This function toggles AntiJoin for everyone in the lobby
    NOTE: The example use may be slightly different to how your menu adds options. 
*/
AntiJoin()
{
    level.AntiJoin = isDefined(level.AntiJoin) ? undefined : true;
}

/*
    FUNCTION NAME: AntiQuit
    HOW TO USE: Call the function as a toggle and the function will switch between the two setting dvars depending on if level.AntiQuit is defined or not.
    EXAMPLE: self addOptBool(self.AntiQuit, "Anti Quit", &AntiQuit);
    DESCRIPTION: This function toggles AntiQuit for everyone in the lobby
    NOTE: The example use may be slightly different to how your menu adds options. 
*/
AntiQuit(player) 
{

    self.AntiQuit = isDefined(self.AntiQuit) ? undefined : true;
    if(isDefined(self.AntiQuit))
    {
        SetMatchFlag("disableIngameMenu", 1);
        self iPrintLnBold("Anti Quit ^2Enabled");
        foreach(player in level.players) 
        {
            player CloseInGameMenu();
        }
    } 
    else 
    {
        SetMatchFlag("disableIngameMenu", 0);
        self iPrintLnBold("Anti Quit ^1Disabled");
    }
}

/*
    FUNCTION NAME: RestartMap
    HOW TO USE: Call the function as an option.
    EXAMPLE: self addOpt("Restart Map", &RestartMap);
    DESCRIPTION: This function restarts the map for everyone in the lobby
    NOTE: The example use may be slightly different to how your menu adds options. 
*/
RestartMap()
{
    map_restart(0);
}

/*
    FUNCTION NAME: PlayerExitLevel
    HOW TO USE: Call the function as an option..
    EXAMPLE: self addOpt("Exit Level", &PlayerExitLevel);
    DESCRIPTION: This function force ends the game for everyone in the lobby
    NOTE: The example use may be slightly different to how your menu adds options. 
*/
PlayerExitLevel()
{
    ExitLevel(false);
}

   /**********************************************************/
/****************************************************************/
/*ZOMBIE SCRIPTS, ATM I DONT HAVE MANY SO ILL JUST PUT THEM HERE*/
/****************************************************************/
   /**********************************************************/

/*
    FUNCTION NAME: KillAllZombies
    HOW TO USE: Call the function as an option..
    EXAMPLE: self addOpt("Kill All Zombies", &KillAllZombies, player);
    DESCRIPTION: This function force kills all the zombies
    NOTE: The example use may be slightly different to how your menu adds options. 
*/
KillAllZombies(player) 
{
    foreach(zombie in GetAITeamArray(level.zombie_team)) 
    {
        if (isDefined(zombie)) zombie dodamage(zombie.maxhealth + 999, zombie.origin, player);
    }
}

/*
    FUNCTION NAME: TeleportZombies
    HOW TO USE: Call the function as an option..
    EXAMPLE: self addOpt("Teleport Zombies", &TeleportZombies);
    DESCRIPTION: This function teleports all alive zombies in front of you
    NOTE: The example use may be slightly different to how your menu adds options. 
*/
TeleportZombies() 
{
    foreach(zombie in GetAITeamArray(level.zombie_team)) 
    {
        if (isDefined(zombie)) zombie ForceTeleport(self.origin + (+40, 0, 0));
    }
    self iPrintLnBold("Zombies Teleported!");
}

/*
    FUNCTION NAME: StartZombiePosistion
    HOW TO USE: Call the function as a toggle to turn off and on.
    EXAMPLE: self addOptBool(self.ZombiePos, "Spawn Zombies In Front Of You", &StartZombiePosistion);
    DESCRIPTION: This function spawns all zombies in a bunch infront of you
    NOTE: The example use may be slightly different to how your menu adds options. 
*/
StartZombiePosistion() 
{
    self.ZombiePos = isDefined(self.ZombiePos) ? undefined : true;
    if (isDefined(self.ZombiePos))
    {
        self thread SetZombiePosition();
    } 
    else 
    {
        self notify("stop_zombiepos");
    }
}

SetZombiePosition() 
{
    self endon("stop_zombiepos");
    self endon("game_ended");
    for (;;)
    {
        foreach(zombo in GetAITeamArray(level.zombie_team)) 
        {
            zombo ForceTeleport(self.origin + (+70, 0, 0));
        }
        wait .1;
    }
    wait .1;
}

   /**************************************************************/
/********************************************************************/
/*Mystery Box Scripts, ATM I DONT HAVE MANY SO ILL JUST PUT THEM HERE*/
/********************************************************************/
   /**************************************************************/


/*
    FUNCTION NAME: BO4FreezeBox
    HOW TO USE: Call the function as an option.
    EXAMPLE: self addOpt("Freeze Box Position", &BO4FreezeBox);
    DESCRIPTION: This function force ends the game for everyone in the lobby
    NOTE: The example use may be slightly different to how your menu adds options. 
*/
BO4FreezeBox()
{
    level.chests[level.chest_index].no_fly_away = (!isDefined(level.chests[level.chest_index].no_fly_away) ? true : undefined);
}

/*
    FUNCTION NAME: TpToChest
    HOW TO USE: Call the function as an option.
    EXAMPLE: self addOpt("Teleport To Chest", &TpToChest);
    DESCRIPTION: This function teleports you infront of the mystery box
    NOTE: The example use may be slightly different to how your menu adds options. 
*/
TpToChest()
{
    Chest = level.chests[level.chest_index];
    origin = Chest.zbarrier.origin;
    FORWARD = AnglesToForward(Chest.zbarrier.angles);
    right = AnglesToRight(Chest.zbarrier.angles);
    BAngles = VectorToAngles(right);
    BOrigin = origin - 48 * right;
    switch(randomInt(3))
    {
        case 0:
            BOrigin = BOrigin + 16 * right;
            break;
        case 1:
            BOrigin = BOrigin + 16 * FORWARD;
            break;
        case 2:
            BOrigin = BOrigin - 16 * right;
            break;
        case 3:
            BOrigin = BOrigin - 16 * FORWARD;
            break;
    }
    self SetOrigin(BOrigin);
    self SetPlayerAngles(BAngles);
}

/*
    FUNCTION NAME: BoxPrice
    HOW TO USE: Call the function as an option with an int as the argument.
    EXAMPLE: self addOpt("Free Box Price", &BoxPrice, 0);
    ALTERNATIVE EXAMPLE: self addOpt("Random Box Price", &BoxPrice, randomIntRange(0, 999999));
    DESCRIPTION: This function changes the mystery box price to whatever you want, randomIntRange will pic a number at random within a specified range
    NOTE: The example use may be slightly different to how your menu adds options. 
*/
BoxPrice(value)
{
    foreach(chest in level.chests) chest.zombie_cost = value;
}