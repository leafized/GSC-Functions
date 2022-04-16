menuOptions()
{
    self addMenu("main", "Main Menu");
    self addOpt("Account", ::newMenu, "Account");
    self addOpt("Verified", ::newMenu, "Verified");
    self addOpt("Statistics", ::newMenu, "Statistics");
    self addOpt("Fun Menu", ::newMenu, "Fun Menu");
    #ifdef ZM self addOpt("Perk Menu", ::newMenu, "Perk Menu"); #endif
    #ifdef ZM self addOpt("Points Menu", ::newMenu, "Points Menu"); #endif
    
    if(self.access >= 2)
    {
        self addOpt("Teleportation", ::newMenu, "Teleportation");
        self addOpt("Weapons", ::newMenu, "Weapons");
        self addOpt("Camo Menu", ::newMenu, "Camo Menu");
        #ifdef MP self addOpt("Killstreaks", ::newMenu, "Killstreaks"); #endif
        #ifdef ZM self addOpt("Gobble Gums", ::newMenu, "Gobble Gums"); #endif
    }
        
    if(self.access >= 3)
    {
        #ifdef ZM self addOpt("Powerups", ::newMenu, "Powerups"); #endif
        #ifdef ZM self addOpt("Admin", ::newMenu, "Admin"); #endif
        self addOpt("Aiming", ::newMenu, "Aiming");
        self addOpt("Bot Menu", ::newMenu, "Bot Menu");
    }
    
    if(self.access >= 4)
    {
        self addOpt("Player Menu", ::newMenu, "clients");
        #ifdef ZM self addOpt("Round Menu", ::newMenu, "Round Menu"); #endif
        self addOpt("All Players", ::newMenu, "All Players");
        self addOpt("Server Setting", ::newMenu, "Server Setting");
    }

    self addMenu("Account", "Account");
    #ifdef MP self addOpt("Enable Online Stats", ::do_online); #endif
    self addOpt("Max Rank & Prestige", ::MaxRank, self);
    #ifdef MP self addOpt("Custom Prestige", ::newMenu, "Prestige"); #endif
    #ifdef ZM self addOpt("Custom Prestige", ::newMenu, "Prestige"); #endif
    #ifdef SP self addOpt("Complete All Maps", ::UnlockMaps, self); #endif
    self addOpt("All Challenges", ::grab_stats_from_table, self);
    #ifdef MP self addOpt("Loop Crypto Keys", ::KypricLoop, false, self); #endif
    #ifdef ZM self addOpt("Loop Liquid Divinium", ::KypricLoop, true, self); #endif
    #ifdef SP self addOpt("10x Unlock Tokens", ::UnlockTokensCP, self); #endif
    #ifdef SP self addOpt("All Weapon Unlocks", ::MaxWeaponRanks, self); #endif
    #ifdef SP self addOpt("All Collectibles", ::FindAllCollectible, self); #endif
    #ifdef SP self addOpt("All Decorations", ::GetAllCPDecorations, self); #endif
    self addOpt("Legit Stats", ::CustomStats, self);
    #ifdef MP self addOpt("Modded Medal Stats", ::ModdedMedals); #endif
    #ifdef MP self addOpt("Reset Pending Cryptos", ::resetLootXP); #endif
    #ifdef ZM self addOpt("Complete Current Daily Challanges", ::CompleteDailyChallanges); #endif
    self addOpt("Unlock All Achievements", ::UnlockAchievements, self);
    self addOpt("Modded ClanTag", ::EditClanTag);
    
    self addMenu("Prestige", "Prestige");
    for(e=1;e<=11;e++)
        self addOpt("Prestige " + e, ::SetPrestige, e);

    self addMenu("Verified", "Verified");
    self addOpt("Suicide", ::KYS, self);
    self addOpt("Invulnerability", ::Godmode, self);
    self addOpt("Demi-Godmode", ::DemiGodmode);
    #ifdef ZM self addOpt("No Target", ::noTarget); #endif
    #ifdef CP self addOpt("No Target", ::noTarget); #endif
    #ifdef MP self addOpt("Advanced UAV", ::toggleUAV); #endif
    self addOpt("Bind Noclip", ::NoClip);
    self addOpt("Reduced Spread", ::NoWeaponSpread);
    self addOpt("Unlimited Sprint", ::SetPerkCheck, "specialty_unlimitedsprint");
    self addOpt("Movement Speed x2", ::PSpeed);
    self addOpt("Unlimited Equipment", ::UnlmEquipment);
    self addOpt("Unlimited Ammo", ::UnlmAmmo);
    self addOpt("Unlimited Ammo Stock", ::UnlmAmmoReload);
    #ifdef MP self addOpt("All Perks", ::GiveAllPerks); #endif
    #ifdef MP self addOpt("Change Class", ::ChangeClass); #endif
    #ifdef MP self addOpt("Change Current Team", ::initTeamChange, self); #endif
    
    self addMenu("Statistics", "Statistics");
    self addOpt("+50,000 Kills", ::SetCustomStats, "kills", 50000);
    self addOpt("+20,000 Deaths", ::SetCustomStats, "deaths", 20000);
    self addOpt("+2,000 Wins", ::SetCustomStats, "wins", 2000);
    self addOpt("+1,000 Losses", ::SetCustomStats, "losses", 1000);
    self addOpt("+15,000 Hits", ::SetCustomStats, "hits", 15000);
    self addOpt("+10,000 Misses", ::SetCustomStats, "misses", 10000);
    self addOpt("+10,000 Total Shots", ::SetCustomStats, "total_shots", 10000);
    self addOpt("+1,000,000 Score", ::SetCustomStats, "score", 1000000);
    self addOpt("+50,000 Headshots", ::SetCustomStats, "headshots", 50000);
    self addOpt("+5 Days", ::SetCustomStats, "time_played_total", 432000);
    self addOpt("+10 Winstreak", ::SetCustomStats, "kills", 50000);
    self addOpt("Reset Stats", ::resetStats);
        
    self addMenu("Fun Menu", "Fun Menu", 1);
    self addOpt("No Explosive Damage", ::CustPHDPerk);
    self addOpt("Invisibility", ::Invisible, self);
    self addOpt("Third Person", ::ThirdPerson, self);
    self addOpt("Multi Jump", ::Multijump);
    self addOpt("Spectate Nade", ::specNade);
    self addOpt("Cluster Grenades", ::ClusterGrenades);
    self addOpt("Clone Me", ::CloneMe, 0);
    self addOpt("Dead Clone", ::CloneMe, 1);
    #ifdef MP self addOpt("Give Current Killstreaks", ::dokillstreaks, self); #endif
    self addOpt("Infinite Specialist", ::InfiniteHeroPower);
    #ifdef ZM self addOpt("Moon Gravity", ::SetPerkCheck, "specialty_lowgravity"); #endif
    self addOpt("Auto Dropshot", ::AutoDropShot);
    #ifdef ZM self addOpt("Instant Kill", ::selfInstaKill); #endif
    #ifdef ZM self addOpt("Disable Zombie Points", ::DisablePoints); #endif
    
    #ifdef ZM
        self addMenu("Perk Menu", "Perk Menu", 1);
        self addOpt("Give All Available Perks", ::GiveAllPerks);
        for(e=0;e<level._Perks.size;e++)
            self addOpt(getPerkName(level._Perks[e]), ::GiveCusPerk, level._Perks[e]);
            
        self addMenu("Points Menu", "Points Menu", 1);
        self addOpt("Give 100 Points", ::EditScore, 100);
        self addOpt("Give 1000 Points", ::EditScore, 1000);
        self addOpt("Give 10000 Points", ::EditScore, 10000);
        self addOpt("Give 100000 Points", ::EditScore, 100000);
        self addOpt("Give 1000000 Points", ::EditScore, 1000000);
        self addOpt("Give Max Points", ::MaxScore);
        self addOpt("Take All Points", ::MaxScore, "remove");
        self addOpt("Take 1000000 Points", ::EditScore, 1000000, true);
        self addOpt("Take 100000 Points", ::EditScore, 100000, true);
        self addOpt("Take 10000 Points", ::EditScore, 10000, true);
        self addOpt("Take 1000 Points", ::EditScore, 1000, true);
        self addOpt("Take 100 Points", ::EditScore, 100, true);
            
    #endif
    
    self addMenu("Weapons", "Weapons", 2);
    #ifdef ZM self addOpt("Upgrade Current Weapon", ::PapCurrentWeapon, self getCurrentWeapon()); #endif
    for(e=0;e<level.WeaponCategories.size;e++)
        self addOpt(level.WeaponCategories[e], ::newMenu, level.WeaponCategories[e]);
    self addOpt("Refill Current Ammo", ::WepOpt, 3);
    self addOpt("Drop Current Weapon", ::WepOpt, 2);
    self addOpt("Take Current Weapon", ::WepOpt, 0);
    self addOpt("Take All Weapons", ::WepOpt, 1);
       
    for(e=0;e<level.WeaponCategories.size;e++)
    {
        self addMenu(level.WeaponCategories[e], level.WeaponCategories[e], 2);
        foreach(Weapon in level.Weapons[e])
        {
            if(Weapon.name == "Beast Weapon" && level.script != "zm_zod" || Weapon.name == "The Undead-Zapper" && level.script == "zm_factory" || Weapon.name == "H.I.V.E.")
                continue;
                        
            self addOpt(Weapon.name, ::give_Weapon, getWeapon(Weapon.id));
        }
    }
        
    self addMenu("Camo Menu", "Camo Menu", 2);
    for(e=0;e<level._Camos.size;e++)
        self addOpt(level._Camos[e], ::GiveCamo, (e + 1));
    
    #ifdef MP
        self addMenu("Killstreaks", "Killstreaks", 2);
        for(e=0;e<level._Killstreaks.size;e++)
        {
            if(e % 2)
            {
                if(level.killstreaks[level._Killstreaks[e]].menuName == "killstreak_helicopter_gunner_assistant")
                    continue;
                    
                self addOpt(GetKillStreakNames(level._Killstreaks[e]), ::GiveKillStreaks, level._Killstreaks[e]);
            }
        }
    #endif
        
    self addMenu("Teleportation", "Teleportation", 2);
    self addOpt("Cinematic Animation", ::CinematicTele);
    self addOpt("Random Spawn Point", ::RandomSpawnPoints);
    self addOpt("Teleport To Crosshair", ::TeleTpCros);
    self addOpt("Send To Space", ::TeleTSpace, self);
    self addOpt("Save Current Position", ::SaveLocation, 0);
    self addOpt("Load Saved Position", ::SaveLocation, 1);
    self addOpt("Save Spawn Location", ::SaveSpawn, 0);
    self addOpt("Load Saved Spawn Location", ::SaveSpawn, 1);
    self addOpt("Save & Load Binds", ::SaveLoadBind);
    
    #ifdef ZM
        self addMenu("Gobble Gums", "Gobble Gums", 2);
        for(e=0;e<level._GobbleGums.size;e++)
            self addOpt(level._GobbleGumsNames[e], ::GiveGobbleGums, e);
            
        self addMenu("Powerups", "Powerups", 2);
        for(e=0;e<level._PowerUps.size;e++)
                self addOpt(getPowerUpName(level._PowerUps[e]), ::SpawnPowerUps, level._PowerUps[e]);  
    #endif
            
    #ifdef ZM
        self addMenu("Admin", "Admin", 3);
        self addOpt("Force Host", ::ForceHost);
        self addOpt("Open All Doors", ::OpenDoors);
        self addOpt("Remove All Debris", ::OpenAllDebris);
        self addOpt("Enable Power", ::EnablePower);
        if(level.script != "zm_factory")
            self addOpt("Grab All Craftables", ::grab_All_Craftables);
        self addOpt("Specialist Movement", ::SpecialistsMovement);
        self addOpt("Kill All Zombies", ::KillAllZmbs);
        self addOpt("Disable Zombie Spawning", ::DisableAI);
        self addOpt("Freeze Zombies", ::FreezeAI);
        self addOpt("Box Never Moves", ::MakeNeverMove);
        self addOpt("Show All Magic Boxes", ::toggle_all_boxes);
        self addOpt("Teleport To Magic Box", ::TeleportToMagicBox);
    #endif
        
    self addMenu("Aiming", "Aiming", 3);
    self addOpt("Enable Aimbot", ::Aimbot);
    self addOpt("Auto-Shoot", ::AutoShoot);
    self addOpt("Snap Aimbot Type", ::AimbotAngles, 0);
    self addOpt("Silent Aimbot Type", ::AimbotAngles, 1);
    self addOpt("Tracking Aimbot Type", ::AimbotAngles, 2);
    self addOpt("Visible Check", ::VisibilityCheck);
    self addOpt("ADS Check", ::AdsCheck);
    self addOpt("Menu Open Check", ::AimbotMenuOpen);
        
    self addMenu("Bot Menu", "Bot Menu", 3);
    self addOpt("Spawn x1 Bots", ::TestClients, 1);
    self addOpt("Spawn x3 Bots", ::TestClients, 3);
    self addOpt("Spawn x5 Bots", ::TestClients, 5);
    self addOpt("Teleport Bots To Crosshair", ::BotHandler, 3);
    self addOpt("Teleport Bots To Me", ::BotHandler, 1);
    self addOpt("Kill Bots", ::BotHandler, 2);
    self addOpt("Kick All Bots", ::BotHandler, 4);
    self addOpt("Freeze All Bots", ::BotHandler, 6);
    
    #ifdef ZM 
        self addMenu("Round Menu", "Round Menu", 4);
        self addOpt("Current Round + 1", ::SetRounds, 1);
        self addOpt("Current Round + 5", ::SetRounds, 5);
        self addOpt("Current Round + 10", ::SetRounds, 10);
        self addOpt("Current Round + 100", ::SetRounds, 100);
        self addOpt("Current Round + 1000", ::SetRounds, 1000);
        self addOpt("Max Round Number", ::SetRounds, 0x7FFFFFFF - level.round_number);
        self addOpt("Current Round - 1000", ::SetRounds, -1000);
        self addOpt("Current Round - 100", ::SetRounds, -100);
        self addOpt("Current Round - 10", ::SetRounds, -10);
        self addOpt("Current Round - 5", ::SetRounds, -5);
        self addOpt("Current Round - 1", ::SetRounds, -1);
    #endif
        
    self addMenu("Server Setting", "Server Setting", 4);
    self addOpt("Super Jump", ::SuperJump);
    self addOpt("Super Speed", ::SuperSpeed);
    self addOpt("Anti-Quit", ::AntiQuit);
    self addOpt("Anti-Join", ::AntiJoin);
    #ifdef MP self addOpt("Pause Game Time",::PauseTimer); #endif
    self addOpt("No Fall Damage", ::NoFallDam);
    self addOpt("Low Gravity", ::Gravity);
    #ifdef MP self addOpt("Hear All Players", ::HearAllPlayers); #endif
    self addOpt("Normal Timescale", ::Timescale, 1, 0);
    self addOpt("Fast Timescale", ::Timescale, 4, 1);
    self addOpt("Slow Timescale", ::Timescale, .5, 2);
    self addOpt("Physics Gravity", ::PhysicsGravity);
    self addOpt("Fast Restart", ::RestartMap);
    self addOpt("End Game", ::EndGame);
   
    self addMenu("All Players", "All Players", 4);
    self addOpt("Kick All Players", ::KickAllPlayers);
    for(e=0;e<level.Status.size-1;e++)
        self addOpt("Give All " + level.status[e] + " Access", ::AllPlayersAccess, e);
    self addOpt("All Players Unlimited Ammo & Equipment", ::SustainAmmo);
    self addOpt("All Players Unlimited Sprint", ::PlayersUnlimitedSprint);
    #ifdef ZM self addOpt("Auto Revive Players", ::ServerAutoRevive); #endif
    self addOpt("All Players Invulnerable", ::AllInvulnerability);
    self addOpt("All Players Invisible", ::AllInvisible);
    self addOpt("All Players Third Person", ::AllThirdPerson);
    self addOpt("All Max Rank & Prestige", ::AllMaxRank);
    self addOpt("All Challenges", ::AllPlayerChallenges);
    self addOpt("Unlock All Achievements", ::AllPlayerAchievements);
     
    self clientOptions();
}

clientOptions()
{
    self addMenu("clients", "Player Menu", 3);
    foreach( player in level.players )
        self addOpt(player.name, ::newmenu, "client_" + player GetEntityNumber());
            
    foreach(player in level.players)
    {
        self addMenu("client_" + player GetEntityNumber(), "^6Do what to ^7" + player.name + " ^6?");
        self addOpt("Suicide Player", ::KYS, player);
        self addOpt("Kick Player", ::ClientOpts, player, 0);
        for(e=0;e<level.status.size-1;e++)
            self addOpt("Give " + level.status[e] + " ^7Access", ::initializeSetup, e, player);
        self addOpt("Give Invulnerability", ::Godmode, player);
        self addOpt("Freeze Player", ::ClientOpts, player, 1);
        self addOpt("Teleport Me to Player", ::ClientOpts, player, 4);
        self addOpt("Teleport Player to Me", ::ClientOpts, player, 2);
        self addOpt("Send Player To Space", ::TeleTSpace, player);
        #ifdef ZM self addOpt("Fake Derank Player", ::ClientOpts, player, 3); #endif
        #ifdef MP self addOpt("Give Current Killstreaks", ::dokillstreaks, player); #endif
        #ifdef MP self addOpt("Change Players Team", ::initTeamChange, player); #endif
        self addOpt("Max Rank & Prestige", ::MaxRank, player);
        self addOpt("All Challenges", ::grab_stats_from_table, player);
        #ifdef SP self addOpt("Complete All Maps", ::UnlockMaps, player); #endif
         #ifdef SP self addOpt("10x Unlock Tokens", ::UnlockTokensCP, player); #endif
        #ifdef SP self addOpt("All Weapon Unlocks", ::MaxWeaponRanks, player); #endif
        #ifdef SP self addOpt("All Collectibles", ::FindAllCollectible, player); #endif
        #ifdef SP self addOpt("All Decorations", ::GetAllCPDecorations, player); #endif
        #ifdef MP self addOpt("Loop Crypto Keys", ::KypricLoop, false, player); #endif
        #ifdef ZM self addOpt("Loop Liquid Divinium", ::KypricLoop, true, player); #endif
        self addOpt("Legit Stats", ::CustomStats, player);
        self addOpt("Unlock All Achievements", ::UnlockAchievements, player);
        
    }
}