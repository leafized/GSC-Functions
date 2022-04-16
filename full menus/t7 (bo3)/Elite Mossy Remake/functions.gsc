#ifdef MP
do_online()
{
    if(level.inPrematchPeriod)
        return self iPrintLn("^1Error ^7Wait Till Pregame Is Over!");
        
    EnableOnlineMatch();
    level._online = true;
    self iPrintLn("^2You are now in an online match!");
}
#endif

#ifdef ZM
iPrintLn(String)
{
    self.iPrintLn notify("StopFade");
    self.iPrintLn.alpha = 1;
    self.iPrintLn SetText(String);
    self.iPrintLn thread hudFade(0, 4);
}    
#endif

MaxRank(player)
{ 
    player endon("disconnect");
    
    #ifdef MP
        player SetDStat( "playerstatslist", "rankxp", "statValue", 1457200 );
        player SetDStat( "playerstatslist", "rank", "statValue", 54 );
        player SetDStat( "playerstatslist", "plevel", "StatValue", 11 );
        player SetDStat( "playerstatslist", "paragon_rankxp", "statValue", 52542000 );
        player SetDStat( "playerstatslist", "paragon_rank", "statValue", 944 );
    #endif

    #ifdef ZM
        player SetDStat( "playerstatslist", "rankxp", "statValue", 1375000 );
        player SetDStat( "playerstatslist", "rank", "statValue", 34 );
        player SetDStat( "playerstatslist", "pLevel", "StatValue", 11 );
        player SetDStat( "playerstatslist", "paragon_rankxp", "statValue", 52345460 );
        player SetDStat( "playerstatslist", "paragon_rank", "statValue", 964 );
    #endif

    #ifdef SP
        player SetDStat( "playerstatslist", "rankxp", "statValue", 581651 );
        player SetDStat( "playerstatslist", "rank", "statValue", 19 );

    #endif
    
    self iPrintLn("Max Rank & Prestige ^2Set");
}

#ifdef ZM
grab_stats_from_table(player)
{
    player endon("disconnect");
    player.Isunlockingall = true;
    self iPrintLn("Unlocking All Challenges");
    if(player GetDStat("playerstatslist", "plevel", "statValue") < 10 && player GetDStat( "playerstatslist", "paragon_rank", "statValue" ) < 964)
    {
        player SetDStat( "playerstatslist", "rankxp", "statValue", 1375000 );
        player SetDStat( "playerstatslist", "rank", "statValue", 34 );
        player SetDStat( "playerstatslist", "pLevel", "StatValue", 11 );
        player SetDStat( "playerstatslist", "paragon_rankxp", "statValue", 52345460 );
        player SetDStat( "playerstatslist", "paragon_rank", "statValue", 964 );
        UploadStats(player);
        wait 1;
    }
    
    for(value=512;value<642;value++)
    {
        stat       = spawnStruct();
        stat.value = int( tableLookup( "gamedata/stats/zm/statsmilestones3.csv", 0, value, 2 ) );
        stat.type  = tableLookup( "gamedata/stats/zm/statsmilestones3.csv", 0, value, 3 );
        stat.name  = tableLookup( "gamedata/stats/zm/statsmilestones3.csv", 0, value, 4 );
        stat.split = tableLookup( "gamedata/stats/zm/statsmilestones3.csv", 0, value, 13 );
        
        switch( stat.type )
        {
            case "global":
                player setDStat("playerstatslist", stat.name, "statValue", stat.value);
                player setDStat("playerstatslist", stat.name, "challengevalue", stat.value);
            break;

            case "attachment":
                foreach( attachment in strTok(stat.split, " ") )
                {
                    player SetDStat("attachments", attachment, "stats", stat.name, "statValue", stat.value);
                    player SetDStat("attachments", attachment, "stats", stat.name, "challengeValue", stat.value);
                    for(i = 1; i < 8; i++)
                    {
                        player SetDStat("attachments", attachment, "stats", "challenge" + i, "statValue", stat.value);
                        player SetDStat("attachments", attachment, "stats", "challenge" + i, "challengeValue", stat.value);
                    }
                }
            break;

            default:
                foreach( weapon in strTok(stat.split, " ") )
                {               
                    player addWeaponStat( GetWeapon( weapon ), stat.name, stat.value ); 
                    player addRankXp("kill", GetWeapon( weapon ), undefined, undefined, 1, stat.value * 2 );
                }
            break;
        }
        wait .1;
    }
    
    UploadStats(player);
    player CompleteMapEE(player);
    self iPrintLn("Unlock all has been ^2completed");
    player.Isunlockingall = undefined;
}

CompleteMapEE(player)
{
    player endon("disconnect");
    Maps = array("zod", "castle", "island", "stalingrad", "genesis", "factory", "tomb", "theater", "prototype", "asylum", "moon", "sumpf", "cosmodrome", "temple");
    foreach(map in Maps)
    {
        player AddPlayerStat("darkops_" + map + "_ee", 1);
        player AddPlayerStat("darkops_" + map + "_super_ee", 1);
    }
}
#endif

#ifdef MP
grab_stats_from_table(player)
{
    player endon("disconnect");
    self iPrintLn("Unlocking All Challenges");
    player.Isunlockingall = true;
    if( player GetDStat( "playerstatslist", "paragon_rankxp", "statValue" ) != 52542000 )
    {
        player SetDStat( "playerstatslist", "rankxp", "statValue", 1457200 );
        player SetDStat( "playerstatslist", "rank", "statValue", 54 );
        player SetDStat( "playerstatslist", "plevel", "StatValue", 11 );
        player SetDStat( "playerstatslist", "paragon_rankxp", "statValue", 52542000 );
        player SetDStat( "playerstatslist", "paragon_rank", "statValue", 944 );
    }

    sort_stats_from_table( "mp_statstable", 0, 256, 9, 2, 3 );
    sort_stats_from_table( "statsmilestones1", 1, 239 );
    sort_stats_from_table( "statsmilestones2", 256, 483 );
    sort_stats_from_table( "statsmilestones3", 512, 767 );
    sort_stats_from_table( "statsmilestones4", 768, 929 );
    sort_stats_from_table( "statsmilestones5", 1024, 1494 );
    sort_stats_from_table( "statsmilestones6", 1500, 1515 ); 

    player unlock_all_challenges();
    player AddPlayerStat("score", 5000000);

    self SetDStat("afteractionreportstats", "lobbypopup", "none");
    self iPrintLn("Unlock All ^2Done");
    player.Isunlockingall = undefined;
}

sort_stats_from_table( table, sIndex, eIndex, value_column = 2, type_column = 3, name_column = 4, split_column = 13 )
{
    self endon("disconnect");
    
    if( !isDefined( level.custom_stats ) )
        level.custom_stats = [];
        
    level.custom_stats[ table ] = [];
    previous = "";

    for(value=sIndex;value<eIndex+1;value++)
    {
        stat         = spawnStruct();
        stat.value   = int( tableLookup( "gamedata/stats/mp/" + table + ".csv", 0, value, value_column ) );
        stat.type    = tableLookup( "gamedata/stats/mp/" + table + ".csv", 0, value, type_column );
        stat.name    = tableLookup( "gamedata/stats/mp/" + table + ".csv", 0, value, name_column );
        stat.index   = int( tableLookup( "gamedata/stats/mp/" + table + ".csv", 0, value, 0 ) );
        
        split = tableLookup( "gamedata/stats/mp/" + table + ".csv", 0, value, split_column );
        if( isDefined( split ) && split != "" )       
            stat.split = split;

        if( previous.type != stat.type || previous.name != stat.name || previous.value > stat.value )
        {
            if( isDefined( previous ) && previous != "" )
            {
                if( previous.type != "" && previous.name != "" && previous.value > 0 )
                    level.custom_stats[ table ][ level.custom_stats[ table ].size ] = previous;
            }
        }
        previous = stat;
    }
}

unlock_all_challenges()
{
    self endon("disconnect");

    tables       = [];
    stats        = ["kills", "kills_ability", "kills_weapon", "multikill_ability", "multikill_weapon", "kill_one_game_ability", "kill_one_game_weapon", "challenge1", "challenge2", "challenge3", "challenge4", "challenge5"];
    heroes       = ["heroes_mercenary", "heroes_outrider", "heroes_technomancer", "heroes_battery", "heroes_enforcer", "heroes_trapper", "heroes_reaper", "heroes_spectre", "heroes_firebreak"];
    hero_weapons = ["HERO_MINIGUN", "HERO_LIGHTNINGGUN", "HERO_GRAVITYSPIKES", "HERO_ARMBLADE", "HERO_ANNIHILATOR", "HERO_PINEAPPLEGUN", "HERO_BOWLAUNCHER", "HERO_CHEMICALGELGUN", "HERO_FLAMETHROWER"];
    weapons      = ["smg_fastfire", "lmg_heavy", "ar_standard", "pistol_burst", "sniper_fastbolt", "shotgun_fullauto"];
    
    for(i=1;i<6;i++)
    {
        self SetDStat("prestigetokens", i, "tokentype", "prestige_extra_cac", 1);
        self SetDStat("prestigetokens", i, "tokenspent", 1);
    }

    _setStats = 0;
    for(table=1;table<7;table++)
    {
        foreach( stat in level.custom_stats[ "statsmilestones" + table ] )
        {
            self iPrintLn( stat.type, " ", stat.name, " ^2", stat.value );
            if( stat.name == "" || stat.type == "" || stat.value == 0 )
                continue;

            switch( stat.type )
            {
                case "global":
                    self SetDStat("playerstatslist", stat.name, "statValue", stat.value);
                    self SetDStat("playerstatslist", stat.name, "challengevalue", stat.value);
                    _setStats += 2;
                break;

                case "gamemode":
                    foreach( gametype in strTok(stat.split, " ") )
                    {
                        self SetDStat("PlayerStatsByGameType", gametype, stat.name, "StatValue", stat.value);
                        self SetDStat("PlayerStatsByGameType", gametype, stat.name, "challengevalue", stat.value);
                        _setStats += 2;
                    }
                break;

                case "group":
                    foreach( group_name in strTok(stat.split, " ") )
                    {
                        self SetDStat("groupstats", group_name, "stats", stat.name, "challengevalue", stat.value);
                        _setStats += 1;
                    }
                break;

                case "killstreak":
                    foreach(streak_name in strTok(stat.split + " killstreak_autoturret killstreak_helicopter_gunner", " ") )
                    {
                        self addWeaponStat(level.killstreaks[ GetSubStr( streak_name, 11 ) ].weapon, stat.name, stat.value);
                        _setStats += 1;
                    }
                break;

                case isWeapon_category( stat.type ):
                    foreach( weapon in strTok(stat.split, " ") )
                    {               
                        self addWeaponStat( GetWeapon( weapon ), stat.name, stat.value ); 
                        self addRankXp("kill", GetWeapon( weapon ), undefined, undefined, 1, stat.value * 2 );
                        wait .2;
                        
                        index = GetBaseWeaponItemIndex( GetWeapon( weapon ) );
                        if(self GetDStat("itemstats", index, "plevel") != 15)
                        {
                            self SetDStat("itemstats", index, "plevel", 15);
                            for(i = 0; i < 3; i++)
                                self SetDStat("itemstats", index, "isproversionunlocked", i, 1);
                        }
                        _setStats += 8;
                    }
                break;

                case "attachment":
                    foreach( attachment in strTok(stat.split, " ") )
                    {
                        self SetDStat("attachments", attachment, "stats", stat.name, "statValue", stat.value);
                        self SetDStat("attachments", attachment, "stats", stat.name, "challengeValue", stat.value);
                        for(i = 1; i < 8; i++)
                        {
                            self SetDStat("attachments", attachment, "stats", "challenge" + i, "statValue", stat.value);
                            self SetDStat("attachments", attachment, "stats", "challenge" + i, "challengeValue", stat.value);
                        }
                        _setStats += 20;
                    }
                break;

                case "specialist":
                    foreach( specialist in strTok(stat.split, " ") )
                    {
                        self SetDStat("specialiststats", getIndexFromName( specialist, heroes ), "stats", stat.name, "statValue", stat.value);
                        self SetDStat("specialiststats", getIndexFromName( specialist, heroes ), "stats", stat.name, "challengeValue", stat.value);
                        _setStats += 2;
                    }
                    foreach( hero_weapon in hero_weapons )
                    {
                        self addWeaponStat(GetWeapon( hero_weapon ), stat.name, stat.value);
                        self addweaponstat(GetWeapon( hero_weapon ), "used", stat.value);
                        _setStats += 2;
                    }
                break;

                case "hero":
                    break; 

                case "bonuscard":
                    for(e=178;e<188;e++)
                    {
                        self SetDStat("itemstats", e, "stats", stat.name, "statvalue", 300);
                        self SetDStat("itemstats", e, "stats", stat.name, "challengevalue", 300);
                        _setStats += 2;
                    }
                break; 

                default:
                    self iPrintLn( "Unknown Data Type: ", stat.type );
                break;
            }

            if( _setStats > 170 )
            {
                _setStats = 0;
                uploadStats( self );
                wait .2;
            }
            wait .1;
        }
        uploadStats( self );
        wait 1;
    }
}
#endif

getIndexFromName( string, array )
{
    foreach(index, name in array)
    {
        if( name == string )
            return index;
    }
    return undefined;
}

isWeapon_category( weapon )
{
    return isSubStr( weapon, "weapon_" ) ? weapon : "  ";
}

UnlockAchievements(player)
{
    if(isDefined(player.AllAchievements))
        return;

    player endon("disconnect");
    player.AllAchievements = true;
    self iPrintLn("Unlocking All Achievements");
    foreach(Achivement in level._Achievements)
    {
        #ifdef MP player GiveAchievement(Achivement); #endif
        #ifdef ZM player zm_utility::giveachievement_wrapper(Achivement); #endif
        wait .1;
    }
    self iPrintLn("All Achievements: ^2Unlocked");
}

#ifdef MP
resetLootXP()
{
    self SetDStat("mp_loot_xp_due", 0);
}
#endif

CustomStats(player)
{
        
    player endon("disconnect");
    player SetDStat("PlayerStatsList", "time_played_total", "StatValue", randomIntRange(172800, 691200));
    player SetDStat("PlayerStatsList", "headshots", "StatValue", 56245);
    player SetDStat("PlayerStatsList", "melee_kills", "StatValue", randomIntRange(2000, 5000));
    player SetDStat("PlayerStatsList", "grenade_kills", "StatValue", randomIntRange(2000, 5000));
    wait .5;
    player SetDStat("PlayerStatsList", "total_shots", "StatValue", randomIntRange(7000, 9000));
    player SetDStat("PlayerStatsList", "hits", "StatValue", randomIntRange(2000, 5000));
    player SetDStat("PlayerStatsList", "misses", "StatValue", randomIntRange(2000, 5000));
    player SetDStat("PlayerStatsList", "deaths", "StatValue", randomIntRange(10000, 14000));
    wait .5;
    player SetDStat("PlayerStatsList", "kills", "StatValue", randomIntRange(13000, 17000));
    player SetDStat("playerstatslist", "losses", "statValue", randomIntRange(400, 670));
    player SetDStat("PlayerStatsList", "score", "StatValue", randomIntRange(7000000, 15000000));
    player SetDStat("PlayerStatsList", "wins", "StatValue", randomIntRange(500, 1200));
    
    self iPrintLn("Legit Stats ^2Done");
    uploadStats(player);
}

#ifdef MP
ModdedMedals()
{
    self endon("disconnect");
    for(row=1;row<512;row++)
    {
        scoreInfoTableID = scoreevents::getScoreEventTableID();
        event            = tableLookupColumnForRow(scoreInfoTableID, row, 0);
        self medals::CodeCallback_Medal(row);
        self SetDStat("playerstatslist", "medal_" + event, "statValue", RandomIntRange(5930, 25000));
        wait .05;
    }
    uploadStats(self);
    self iPrintLn("All Medals Stats ^2Done");
}
#endif

KypricLoop(Val, player)
{

    player endon("disconnect");
    if(!isDefined(player.KypricNum))
        player.KypricNum = 0;

    player.LoopCrypto = !bool(player.LoopCrypto);
    player iPrintLn("Currency Loop " + (!player.LoopCrypto ? "^1OFF" : "^2ON") );

    #ifdef MP player SetDStat("mp_loot_xp_due", 0);
    wait 1; #endif

    while(player.LoopCrypto)
    {
        player GiveLoot(player, Val, 35);
        player.KypricNum += 35;
        #ifdef MP self iPrintLn(player.name + " Total Keys: ^2" + player.KypricNum); #endif
        wait 1;
    }
}

GiveLoot(player, IsVials = false, amount)
{
    player endon("disconnect");
    
    IsVials = int(IsVials);
    IsVials = isDefined(IsVials) && IsVials;
    
    amount = int(amount);
    if(!isdefined(amount)) amount = 1;
    if(!isVials) amount *= 100;

    player ReportLootReward((isVials * 2) + 1, amount);
    uploadstats(player);
    wait .1;
}


RestartMap()
{
    map_restart(0);
}

EndGame()
{
    KillServer();
}

SuperJump()
{
    level.SuperJump = !bool(level.SuperJump);
    self iPrintLn("Super Jump " + (level.SuperJump ? "^2ON" : "^1OFF") );

    if(level.SuperJump)
        foreach(player in level.players)
            player thread AllSuperJump();
}

NoFallDam()
{
    self iPrintLn("No Fall Damage " + (GetDvarInt("bg_fallDamageMinHeight") == 9999 ? "^1OFF" : "^2ON") );
    SetDvar("bg_fallDamageMinHeight", (GetDvarInt("bg_fallDamageMinHeight") != 9999 ? 9999 : 256));
    SetDvar("bg_fallDamageMaxHeight", (GetDvarInt("bg_fallDamageMaxHeight") != 9999 ? 9999 : 512));
}

AllSuperJump()
{
    self endon("disconnect");
    while(level.SuperJump)
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

SuperSpeed()
{
    if(!isDefined(level.SaveGSpeed))
        level.SaveGSpeed =  GetDvarString("g_speed");

    self iPrintLn("Super Speed " + (GetDvarString("g_speed") == "500" ? "^1OFF" : "^2ON") );
    SetDvar("g_speed", (GetDvarString("g_speed") != "500" ? "500" : level.SaveGSpeed));
}

Godmode(player)
{
    if(bool(player.DemiGodmode))
        player DemiGodmode();

    player.godmode = !bool(player.godmode);
    self iPrintLn("Invulnerability " + (!player.godmode ? "^1OFF" : "^2ON") );
    player endon("disconnect");
    level endon("game_ended");
    while(player.godmode)
    {
        player EnableInvulnerability();
        wait 1;
    }

    player DisableInvulnerability();
}

DemiGodmode()
{
    if(bool(self.godmode))
        self Godmode(self);

    self.DemiGodmode = !bool(self.DemiGodmode);
    self iPrintLn("Demi-Godmode " + (!self.DemiGodmode ? "^1OFF" : "^2ON") );
}

NoClip()
{
    self endon("disconnect");
    level endon("game_ended");
    self.noclipBind = !bool(self.noclipBind);
    if(self.noclipBind)
    {
        self iPrintLn("NoClip Bind To ^2[{+frag}]");
        while(self.noclipBind)
        {
            if(bool(self.menu["isOpen"]) && self fragButtonPressed())
            {
                self iPrintLn("^1Error ^7Close The Menu To Use NoClip");
                while(self fragButtonPressed())
                    wait .05;
            }
            
            if(self fragButtonPressed() && IsAlive(self) && !bool(self.menu["isOpen"]))
            {
                self.noclipExt = true;
                self disableWeapons();
                self disableOffHandWeapons();
                clip = spawnSM(self.origin);
                self playerLinkTo(clip);
                self Hide();
                while(self.noclipBind)
                {
                    vec = anglesToForward(self getPlayerAngles());
                    end = (vec[0] * 60, vec[1] * 60, vec[2] * 60);
                    if(self attackButtonPressed())
                        clip.origin = clip.origin + end;
                    if(self adsButtonPressed())
                        clip.origin = clip.origin - end;
                    if(!IsAlive(self) || !self.noclipBind || self MeleeButtonPressed())
                        break;
                        
                    wait .05;
                }
                clip delete();
                self enableWeapons();
                self enableOffHandWeapons();
                self.noclipExt = undefined;
            }
            wait .05;
        }
    }
    else
        self iPrintLn("NoClip ^1OFF");
}

spawnSM(origin, model, angles, time)
{
    if(IsDefined(time))
        wait time;
    ent = spawn("script_model", origin);
    if(IsDefined(model))
        ent setModel(model);
    if(IsDefined(angles))
        ent.angles = angles;

    return ent;
}

getCursorPos(Dist = 99999)
{
    return bulletTrace(self getEye(), self getEye() + vectorScale(anglesToforward(self getPlayerAngles()), Dist), false, self)["position"];
}

NoWeaponSpread()
{
    self.NoWeaponSpread = !bool(self.NoWeaponSpread);
    self iPrintLn("Reduced Spread " + (!self.NoWeaponSpread ? "^1OFF" : "^2ON") );
    if(self.NoWeaponSpread)
        self SetSpreadOverride(1);
    else
        self ResetSpreadOverride();
}
    
PSpeed()
{
    self endon("disconnect");
    level endon("game_ended");
    self notify("StopPSpeed");
    
    self.PSpeed = !bool(self.PSpeed);
    self iPrintLn("Movement Speed x2 " + (!self.PSpeed ? "^1OFF" : "^2ON") );
    self SetMoveSpeedScale(self.PSpeed ? 2.5 : 1);
    
    self endon("StopPSpeed");
    while(self.PSpeed)
    {
        if(IsAlive(self))
            self SetMoveSpeedScale(2);

        wait .3;
    }
}

give_Weapon(weapon)
{
    #ifdef SP
    self TakeWeapon(self GetCurrentWeapon());
    self GiveWeapon(weapon);
    self SwitchToWeaponImmediate(weapon);
    self GiveMaxAmmo(weapon);
    #endif
    
    #ifdef MP self TakeWeapon(self GetCurrentWeapon());
    self TakeWeapon(self GetCurrentWeapon());
    self GiveWeapon(weapon);
    self SwitchToWeaponImmediate(weapon);
    self GiveMaxAmmo(weapon);
    #endif

    #ifdef ZM self zm_weapons::weapon_give(weapon, undefined, undefined, undefined, true); #endif
}

#ifdef MP
GiveKillStreaks(Killstreak)
{
    if(self.pers["killstreaks"].size >= level.maxInventoryScoreStreaks)
        return self IPrintLn("^1Error ^7Max Ammout Of Killstreaks Owned");
        
    self killstreaks::give( "inventory_" + Killstreak );
}

HearAllPlayers()
{
    level.HearAllPlayers = !bool(level.HearAllPlayers);
    self iPrintLn("Hear All Players " + (!level.HearAllPlayers ? "^1OFF" : "^2ON") );
    SetMatchTalkFlag("DeadChatWithDead", level.HearAllPlayers);
    SetMatchTalkFlag("DeadChatWithTeam", level.HearAllPlayers);
    SetMatchTalkFlag("DeadHearTeamLiving", level.HearAllPlayers);
    SetMatchTalkFlag("DeadHearAllLiving", level.HearAllPlayers);
    SetMatchTalkFlag("EveryoneHearsEveryone", level.HearAllPlayers);
}
#endif

KYS(player)
{
    if(bool(player.godmode))
        self Godmode(self);
    
    if(player hasMenu() && bool(self.menu["isOpen"]))
        player menuClose();
        
    #ifdef MP player Suicide(); #endif
    #ifdef ZM player DoDamage(player.health + 1, player.origin); #endif
    #ifdef SP player DoDamage(player.health + 1, player.origin); #endif
}

SetCustomStats(stat, value)
{
    self AddDStat("PlayerStatsList", stat, "StatValue", value);
    wait .2;
    self iPrintLn("Added " + value + " To ^2" + stat);
    uploadStats(self);
}

resetStats()
{
    self SetDStat("PlayerStatsList", "time_played_total", "StatValue", 0);
    self SetDStat("PlayerStatsList", "headshots", "StatValue", 0);
    self SetDStat("PlayerStatsList", "melee_kills", "StatValue", 0);
    self SetDStat("PlayerStatsList", "grenade_kills", "StatValue", 0);
    wait .2;
    uploadStats(self);
    self SetDStat("PlayerStatsList", "total_shots", "StatValue", 0);
    self SetDStat("PlayerStatsList", "hits", "StatValue", 0);
    self SetDStat("PlayerStatsList", "misses", "StatValue", 0);
    self SetDStat("PlayerStatsList", "deaths", "StatValue", 0);
    wait .2;
    uploadStats(self);
    self SetDStat("PlayerStatsList", "kills", "StatValue", 0);
    self SetDStat("playerstatslist", "losses", "statValue", 0);
    self SetDStat("PlayerStatsList", "wins", "StatValue", 0);
    self SetDStat("PlayerStatsList", "score", "StatValue", 0);
    self iPrintLn("Legit Stats ^2Done");
    uploadStats(self);
}

EditClanTag()
{
    self SetDStat("clanTagStats", "clanName", "^B^");
    self iPrintLn("Clan Tag ^2Set");
}

Multijump(currentNum = 0)
{
    self endon("disconnect");
    level endon("game_ended");

    self.Multijump = !bool(self.Multijump);
    self iPrintLn("Multi Jump " + (!bool(self.Multijump) ? "^1OFF" : "^2ON") );
    
    if(bool(self.Multijump))
        self setPerk("specialty_fallheight");
    else
        self unSetPerk("specialty_fallheight");
        
    while(bool(self.Multijump))
    {
        if(self JumpButtonPressed() && currentNum < 15)
        {
            self setVelocity(self getVelocity() + (0, 0, 250));
            currentNum++;
        }
        if(currentNum == 15 && self isOnGround())
            currentNum = 0;

        wait .1;
    }
}

Invisible(player)
{
    player endon("disconnect");
    level endon("game_ended");
    player.CantSeeMe = !bool(player.CantSeeMe);
    player iPrintLn("Invisible " + (!player.CantSeeMe ? "^1OFF" : "^2ON") );
    if(player.CantSeeMe)
    {
        player endon("stopInvs");
        while(player.CantSeeMe)
        {
            player Hide();
            player waittill("spawned_player");
        }
    }
    else
    {
        player notify("stopInvs");
        player Show();
    }
}

ThirdPerson(player)
{
    player endon("disconnect");
    player.ThirdPerson = !bool(player.ThirdPerson);
    player iPrintLn("Third Person " + (!player.ThirdPerson ? "^1OFF" : "^2ON") );
    if(player.ThirdPerson)
    {
        player endon("StopThPerson");
        while(player.ThirdPerson)
        {
            player SetClientThirdPerson(1);
            player waittill("spawned_player");
        }
    }
    else
    {
        player SetClientThirdPerson(0);
        player notify("StopThPerson");
    }
}

CustPHDPerk()
{
    self.PHDPerk = !bool(self.PHDPerk);
    self iPrintLn("No Explosive Damage " + (!self.PHDPerk ? "^1OFF" : "^2ON") );
}

specNade()
{
    self endon("disconnect");
    level endon("game_ended");
    self endon("StopspecNade");
    self.specNade = !bool(self.specNade);
    self iPrintLn("Spectate Nade " + (!self.specNade ? "^1OFF" : "^2ON") );
    if(self.specNade)
    {
        while(self.specNade)
        {
            self waittill("grenade_fire", grenade, weapname);
            self.SpecGod = true;
            SavedAngles    = self.angles;
            self disableWeapons();
            self disableOffHandWeapons();
            self Hide();
            self playerLinkTo(grenade);
            self setPlayerAngles(VectorToAngles(grenade.origin - self.origin));
            self thread NadeAngles(grenade);
            self waittill("explode");
            self unlink();
            if(!bool(self.CantSeeMe))
                self Show();
            self setPlayerAngles(SavedAngles);
            self enableWeapons();
            self enableOffHandWeapons();
            self.SpecGod = undefined;
        }
    }
    else
        self notify("StopspecNade");
}

NadeAngles(grenade)
{
    self endon("disconnect");
    level endon("game_ended");
    self endon("StopspecNade");
    while(self.specNade)
    { 
        self setPlayerAngles(VectorToAngles(grenade.origin - self.origin));
        wait .05;
    }
}

CloneMe(Val)
{
    self iPrintLn("Clone ^2Spawned");
    clone = self ClonePlayer(Val ? 1 : 99999, self getCurrentWeapon(), self);
    
    if(Val)
        clone startRagDoll(1);
        
    clone thread DeleteAfter30();
}

DeleteAfter30()
{
    self endon("death");
    self endon("deleted");
    wait 30;
    self delete();
}

ClusterGrenades()
{
    self endon("disconnect");
    level endon("game_ended");
    self notify("Stop_ClusterGrenades");
    self.ClusterGrenades = !bool(self.ClusterGrenades);
    self iPrintLn("Cluster Grenades " + (!self.ClusterGrenades ? "^1OFF" : "^2ON") );
    self endon("Stop_ClusterGrenades");
    while(self.ClusterGrenades)
    {
        self waittill("grenade_fire", grenade, weapon);
        
        if(bool(self.ClusterGrenadesActive))
            continue;
            
        self thread GrenadeSplit(grenade, weapon);
    }
}

grenadesplit(grenade, weapon)
{
    self endon("disconnect");
    level endon("game_ended");
    lastspot = (0,0,0);
    while(isdefined(grenade))
    {
        lastspot = (grenade GetOrigin());
        wait .025;
    }
    
    self.ClusterGrenadesActive = true;
    
    Array = [(250,0,250), (250,250,250), (250,-250,250), (-250,0,250), (-250,250,250), (-250,-250,250), (0,0,250), (0,250,250), (0,-250,250)];
    for(i=0;i<Array.size;i++)
        self MagicGrenadeType(weapon, lastspot, Array[i], 2);
        
    wait .025;
    self.ClusterGrenadesActive = undefined;
}

UnlmEquipment()
{
    self endon("disconnect");
    level endon("game_ended");
    self.UnlmEquipment = !bool(self.UnlmEquipment);
    self iPrintLn("Unlimited Equipment " + (!self.UnlmEquipment ? "^1OFF" : "^2ON") );
    if(self.UnlmEquipment)
    {
        self endon("StopUlimEq");
        while(IsDefined(self.UnlmEquipment))
        {
            self giveMaxAmmo(self getCurrentOffHand());
            wait .05;
        }
    }
    else
        self notify("StopUlimEq");
}
    
UnlmAmmo()
{
    self endon("disconnect");
    level endon("game_ended");
    self notify("stopUnlmAmmo");
    self.UnlmAmmo = !bool(self.UnlmAmmo);
    if(bool(self.UnlmAmmoReload))
    {   
        self.UnlmAmmoReload = undefined;
        self notify("stopUnlmAmmoReload");
    }
    self endon("stopUnlmAmmo");
    self iPrintLn("Unlimited Ammo " + (!self.UnlmAmmo ? "^1OFF" : "^2ON") );
    while(IsDefined(self.UnlmAmmo))
    {
        Weapon = self getCurrentWeapon();
        self setWeaponAmmoClip(Weapon, Weapon.clipsize);
        self giveMaxAmmo(Weapon);
        self util::waittill_any("weapon_fired", "weapon_change");
    }
}

UnlmAmmoReload()
{
    self endon("disconnect");
    level endon("game_ended");
    self notify("stopUnlmAmmoReload");
    self.UnlmAmmoReload = !bool(self.UnlmAmmoReload);
    if(bool(self.UnlmAmmo))
    {
        self.UnlmAmmo = undefined;
        self notify("stopUnlmAmmo");
    }
    self endon("stopUnlmAmmoReload");
    self iPrintLn("Unlimited Ammo - No Reload " + (!self.UnlmAmmoReload ? "^1OFF" : "^2ON") );
    while(IsDefined(self.UnlmAmmo))
    {
        self endon("stopUnlmAmmo");
        while(IsDefined(self.UnlmAmmo))
        {
            self giveMaxAmmo(self getCurrentWeapon());
            self util::waittill_any("reload", "weapon_change");
        }
    }
}

WepOpt(i)
{
    Weap = self GetCurrentWeapon();
    switch(i)
    {
        case 0:
            self iPrintLn("Taken ^1Weapon");
            self TakeWeapon(Weap);
            break;

        case 1:
            self iPrintLn("All Weapons ^1Taken");
            self TakeAllWeapons();
            break;

        case 2:
            self iPrintLn("Dropped ^2Weapon");
            self DropItem(Weap);
            break;

        case 3:
            self giveMaxAmmo(Weap);
            self giveMaxAmmo(self getCurrentOffHand());
            self iPrintLn("Max Ammo ^2Given");
            break;
    }
}

CustomCinematic(End, bool, angle)
{
    self endon("disconnect");
    level endon("game_ended");
    player = self;
    player DisableWeapons();
    player.CamRunning = true;
    if(!bool(player.CantSeeMe))
        player Hide();
    Cam = spawnSM(player.origin, "tag_origin", player.angles);
    player PlayerLinkToAbsolute(Cam);
    Cam moveto(player.origin + vectorScale(anglestoforward(player.angles + (0, -180, 0)), 4000) + (0, 0, 5000), 3, 1.5, 1.5);
    Cam rotateto(Cam.angles + (55, 0, 0), 3, 1.5, 1.5);
    wait 3;
    Cam moveto(End, 3, 1.5, 1.5);
    wait .5;
    if(IsDefined(bool))
        Cam rotateto(angle.angles, 2.5, 1.25, 1.25);
    else
        Cam rotateto((Cam.angles[0]-55, Cam.angles[1], 0), 3, 1.5, 1.5);
    wait 2.5;
    self unlink();
    Cam delete();
    if(!bool(player.CantSeeMe))
        player Show();
    player EnableWeapons();
    player.CamRunning = undefined;
}

RandomSpawnPoints()
{   
    #ifdef MP RandSpawnP = level.SpawnPoints[RandomInt(level.SpawnPoints.size)]; #endif
    #ifdef ZM RandSpawnP = level.SpawnPointsCustom[RandomInt(level.SpawnPointsCustom.size)]; #endif
    #ifdef SP RandSpawnP = level.SpawnPoints[RandomInt(level.SpawnPoints.size)]; #endif
    if(IsDefined(self.CinematicTele) && self.CinematicTele)
        self CustomCinematic(RandSpawnP.origin, 1, RandSpawnP);
    else
    {
        self SetOrigin(RandSpawnP.origin);
        self SetPlayerAngles(RandSpawnP.angles);
    }
}
    
SaveLocation(Val)
{
    if(Val == 0)
    {
        self.SaveLocation      = self.origin;
        self.SaveLocationAngle = self.angles;
        if(!IsDefined(self.SaveLocTog))
            self.SaveLocTog = true;
            
        self iPrintLn("Current Position: ^2Saved");
    }
    else if(Val == 1)
    {
        if(!IsDefined(self.SaveLocTog))
            return self iPrintLnBold("^1Error: ^7No Location Saved");
            
        self SetPlayerAngles(self.SaveLocationAngle);
        self SetOrigin(self.SaveLocation);
        self iPrintLn("Saved Position: ^2Loaded");
    }
    else
    {
        self.SaveLocTog        = undefined;
        self.SaveLocation      = undefined;
        self.SaveLocationAngle = undefined;
    }
}

SaveSpawn(Val)
{
    self endon("disconnect");
    level endon("game_ended");
    if(Val == 0)
    {
        self notify("StopSpawnSave");
        self.SaveSpawn      = self.origin;
        self.SaveSpawnAngle = self.angles;
        if(!IsDefined(self.SaveSpawnTog))
            self.SaveSpawnTog = true;
        self endon("StopSpawnSave");
        self iPrintLn("Spawn Position: ^2Saved");
        while(IsDefined(self.SaveSpawnTog))
        {
            self waittill("spawned_player");
            self SetPlayerAngles(self.SaveSpawnAngle);
            self SetOrigin(self.SaveSpawn);
        }
    }
    else if(Val == 1)
    {
        if(!IsDefined(self.SaveSpawnTog))
            return self iPrintLnBold("^1Error: ^7No Location Saved");
            
        self iPrintLn("Spawn Position: ^2Loaded");
        self SetPlayerAngles(self.SaveSpawnAngle);
        self SetOrigin(self.SaveSpawn);
    }
    else
    {
        self notify("StopSpawnSave");
        self.SaveSpawnTog   = undefined;
        self.SaveSpawn      = undefined;
        self.SaveSpawnAngle = undefined;
    }
}

TeleTpCros()
{
    self SetOrigin(self getCursorPos(1000));
}

TeleTSpace(player)
{
    x = randomIntRange(-75, 75);
    y = randomIntRange(-75, 75);
    z = 45;
    
    location = (0 + x, 0 + y, 500000 + z);
    player setOrigin(location);
    if(player != self)
        self IPrintLnBold(player.name + " Is Now In ^2Space");
    else
        player iPrintLn("You Are Now In ^2Space");
        
}

SaveLoadBind()
{
    self.SaveLoadBind = !bool(self.SaveLoadBind);
    if(self.SaveLoadBind)
    {
        self endon("disconnect");
        level endon("game_ended");
        self iPrintLn("Press [{+actionslot 3}] To ^2Save^7 - Press [{+actionslot 4}] To ^2Load");
        while(self.SaveLoadBind)
        {
            if(self ActionSlotThreeButtonPressed() || self ActionSlotFourButtonPressed())
            {
                if(!Bool(self.menu["isOpen"]))
                {
                    if(self ActionSlotThreeButtonPressed())
                    {
                        SaveLoadBindOrigin = self.origin;
                        SaveLoadBindAngle  = self.angles;
                        self iPrintLn("Current Location: ^2Saved");
                        wait .1;
                    }
                    if(self ActionSlotFourButtonPressed())
                    {
                        self SetOrigin(SaveLoadBindOrigin);
                        self SetPlayerAngles(SaveLoadBindAngle);
                        self iPrintLn("Saved Location: ^2Loaded");
                        wait .1;
                    }
                }
            }
            wait .05;
        }
    }
}

CinematicTele()
{
    self.CinematicTele = !bool(self.CinematicTele);
    self iPrintLn("Cinematic Animation " + (!self.CinematicTele ? "^1OFF" : "^2ON") );
}

KillTriggers(i = 0)
{
    hurtTriggers = GetEntArray("trigger_out_of_bounds", "classname");
    level.KillTriggers = !bool(level.KillTriggers);
    foreach(trigger in hurtTriggers)
    {
        if(level.KillTriggers)
        {
            level.SaveKillTriggersOrigin[i] = trigger.origin;
            trigger.origin = (0, 0, 99999);
        }
        else
            trigger.origin = level.SaveKillTriggersOrigin[i];
            
        i++;
    }
}

Aimbot() 
{
    self endon("disconnect");
    level endon("game_ended");
    level endon("game_ended");
    self.Aimbot = !bool(self.Aimbot);
    self iPrintLn("Aimbot " + (!self.Aimbot ? "^1OFF" : "^2ON") );
    if(!isDefined(self.CheckAimbot))
        self CheckAimbot();
        
    #ifdef SP
    while(self.Aimbot)
    {
        wait .025;
        aimAt = undefined;
        foreach(Zombie in GetAIArray())
        {
            if(!isAlive(Zombie) || Zombie.team == self.team || (self.menu["isOpen"] && Bool(self.AimbotMenuOpen)))
                continue;

            if(bool(self.iVisible) && !bulletTracePassed(self getEye(), Zombie.origin, false, undefined) || bool(self.iAim) && !self PlayerAds())
                continue;

            if(isDefined(aimAt))
            {
                if(closer(self getEye(), Zombie getTagOrigin("j_mainroot"), aimAt getTagOrigin("j_mainroot")))
                    aimAt = Zombie;
            }
            else
                aimAt = Zombie;
        }

        if(self.iAngles == 2 )
            self setPlayerAngles(VectorToAngles(aimAt getTagOrigin(self.iAimFor) - self getTagOrigin("j_head")));

        if(bool(self.AutoShoot) || self AttackButtonPressed() && IsDefined(aimAt) && !self IsReloading() && !self IsMantling())
        {
            if(self.iAngles == 0)
                self setPlayerAngles(VectorToAngles(aimAt getTagOrigin(self.iAimFor) - self getTagOrigin("j_head")));

            if(bool(self.AutoShoot) || self.iAngles == 1 || !bool(self.iVisible))
                aimAt DoDamage(self.iDamagePlayer, self.origin, self, undefined, "none", self.Killfeed, 0, self getCurrentWeapon());
        }
    }
    #endif
    
    #ifdef ZM
    while(self.Aimbot)
    {
        wait .025;
        aimAt = undefined;
        foreach(Zombie in zombie_utility::get_round_enemy_array())
        {
            if(!isAlive(Zombie) || (self.menu["isOpen"] && Bool(self.AimbotMenuOpen)))
                continue;

            if(bool(self.iVisible) && !bulletTracePassed(self getEye(), Zombie.origin, false, undefined) || bool(self.iAim) && !self PlayerAds())
                continue;

            if(isDefined(aimAt))
            {
                if(closer(self getEye(), Zombie getTagOrigin("j_mainroot"), aimAt getTagOrigin("j_mainroot")))
                    aimAt = Zombie;
            }
            else
                aimAt = Zombie;
        }

        if(self.iAngles == 2 )
            self setPlayerAngles(VectorToAngles(aimAt getTagOrigin(self.iAimFor) - self getTagOrigin("j_head")));

        if(bool(self.AutoShoot) || self AttackButtonPressed() && IsDefined(aimAt) && !self IsReloading() && !self IsMantling())
        {
            if(self.iAngles == 0)
                self setPlayerAngles(VectorToAngles(aimAt getTagOrigin(self.iAimFor) - self getTagOrigin("j_head")));

            if(bool(self.AutoShoot) || self.iAngles == 1 || !bool(self.iVisible))
                aimAt DoDamage(aimAt.health, aimat GetOrigin(), self);
        }
    }
    #endif
       
    #ifdef MP 
    while(self.Aimbot)
    {
        wait .025;
        aimAt = undefined;
        foreach(Client in level.players)
        {
            if(!isAlive(Client) || Client == self || Client IsHost() || self IsOnLadder() || self IsReloading() || self IsMeleeing() || self IsMantling() || (self.menu["isOpen"] && Bool(self.AimbotMenuOpen)))
                continue;

            if(bool(self.iVisible) && !bulletTracePassed(self getEye(), Client.origin, false, undefined) || bool(self.iAim) && !self PlayerAds() || level.teambased && Client.team == self.team)
                continue;

            if(isDefined(aimAt))
            {
                if(closer(self getEye(), Client getTagOrigin("j_mainroot"), aimAt getTagOrigin("j_mainroot")))
                    aimAt = Client;
            }
            else
                aimAt = Client;
        }

        if(self.iAngles == 2 )
            self setPlayerAngles(VectorToAngles(aimAt getTagOrigin(self.iAimFor) - self getTagOrigin("j_head")));

        if(bool(self.AutoShoot) || self AttackButtonPressed() && IsDefined(aimAt) && !self IsReloading() && !self IsMantling())
        {
            if(self.iAngles == 0)
                self setPlayerAngles(VectorToAngles(aimAt getTagOrigin(self.iAimFor) - self getTagOrigin("j_head")));

            if(bool(self.AutoShoot) || self.iAngles == 1 || !bool(self.iVisible))
            {
                if(bool(self.AutoShoot))
                    MagicBullet(self getCurrentWeapon(), self.origin, aimAt.origin, self, aimAt);
  
                aimAt DoDamage(self.iDamagePlayer, self.origin, self, undefined, "none", self.Killfeed, 0, self getCurrentWeapon());
            }
        }
    
    }
    #endif
}

CheckAimbot()
{
    self.CheckAimbot   = true;
    self.iDamagePlayer = 200;
    self.iAimFor       = "j_head";
    self.Killfeed      = "MOD_HEAD_SHOT";
    self.iDist         = 10000;        
    self.iAngles       = 0;
    self.iVisible      = false;
}

AimbotMenuOpen()
{
    self.AimbotMenuOpen = !bool(self.AimbotMenuOpen);
    self iPrintLn("Menu Open Check " + (!self.AimbotMenuOpen ? "^1OFF" : "^2ON") );
}

AimbotAngles(Val)
{
    Opt = array("Snap", "Silent", "Tracking");
    self.iAngles = Val;
    self iPrintLn("Aimbot Type Set: ^2" + Opt[Val] );
}

AutoShoot()
{
    self.AutoShoot = !bool(self.AutoShoot);
    self iPrintLn("Auto Shoot " + (!self.AutoShoot ? "^1OFF" : "^2ON") );
} 

AimbotDamage(Val)
{
    self.iDamagePlayer = Val;
}

AimbotTarget(Val)
{
    self.Killfeed = (Val > 0 ? "MOD_RIFLE_BULLET" : "MOD_HEAD_SHOT");
    Tag             = strTok("j_head;j_mainroot;j_clavicle_ri;back_mid;j_hip_ri;j_knee_ri;j_knee_le",";");
    self.iAimFor  = Tag[Val];
}

AimbotDistance(Val)
{
    self.iDist = Val;
}

VisibilityCheck() 
{
    self.iVisible = !bool(self.iVisible);
    self iPrintLn("Visibility Check " + (!self.VisibilityCheck ? "^1OFF" : "^2ON") );
}

AdsCheck()
{
    self.iAim = !bool(self.iAim);
    self iPrintLn("Ads Check " + (!self.iAim ? "^1OFF" : "^2ON") );
}

TestClients(BotNum)
{
    for(i=0;i<BotNum;i++)
    {    
        bot = addtestclient();
        wait .1;
        bot.pers["isBot"] = 1;
        bot.equipment_enabled = 1;
        #ifdef ZM bot thread ForceBotSpawn(); #endif
    }
}

ForceBotSpawn()
{
    while(self.sessionstate != "spectator")
        wait .2;

    self [[level.spawnPlayer]]();
}

isBot()
{
    return (isDefined(self.pers["isBot"]) && self.pers["isBot"] ? true : false);
}

BotHandler(i)
{
    switch(i)
    {
        case 1:
            self IPrintLnBold("All Bots ^2Teleported");
            foreach(player in level.players)
                if(player isBot())
                    player SetOrigin(self.origin);
            break;

        case 2:
            self IPrintLnBold("All Bots ^1Killed");
            foreach(player in level.players)
                if(player isBot())
                    player Suicide();
            break;

        case 3:
            self IPrintLnBold("All Bots ^2Teleported");
            foreach(player in level.players)
                if(player isBot())
                    player SetOrigin(self getCursorPos());
            break;

        case 4:
            foreach(player in level.players)
                if(player isBot())
                    kick(player getEntityNumber());
            break;

        case 5:
            self IPrintLnBold("All Bots ^2Spawned");
            foreach(player in level.players)
                if(player isBot())
                    player [[level.spawnPlayer]]();
            break;
            
        case 6:
            level.BotsFrozen = !bool(level.BotsFrozen);
            foreach(player in level.players)
                if(player isBot())
                    player FreezeControls(level.BotsFrozen);
            break;
    }
}

ClientOpts(player, func)
{  
    player endon("disconnect");
    level endon("game_ended");
    switch(func)
    {
        case 0:
            if(player == self)
                return;
                
            Kick(player GetEntityNumber());
            break;
            
        case 1:
            player.IsFrozen = !bool(player.IsFrozen);
            if(player.IsFrozen)
            {
                self iPrintLn(player.name + " ^1Frozen");
                player endon("StopFrezee");
                while(player.IsFrozen)
                {
                    player Freezecontrols(true);
                    player waittill("spawned_player");
                }
            }
            else
            {
                self iPrintLn(player.name + " ^2UnFrozen");
                player Freezecontrols(false);
                player notify("StopFrezee");
            }
            break;
            
         case 2:
            player SetOrigin(self.origin + (-10, 0, 0));
            self iPrintLn(player.name + " Teleported To ^2Me");
            break;
            
        case 3:
            player SetRank(0, 0);
            self iPrintLn(player.name + " Has Been ^1Faked Deranked");
            break;

        case 4:
            self SetOrigin(player.origin + (-10, 0, 0));
            self iPrintLn("Teleported To ^2" + player.name);
            break;
    }
}
    
Timescale(Val, StringIndex)
{
    Speed = ["Normal", "Fast", "Slow"];
    setDvar("timescale", Val);
    iPrintLn("Time Scale Set: ^2" + Speed[StringIndex]);
}

PhysicsGravity()
{
    DvarName = ["phys_gravity_ragdoll", "phys_gravity"];
    for(e=0;e<2;e++)
        setDvar(DvarName[e], getDvarString("phys_gravity") != "-10" ? "-10" : "-800");
        
    self iPrintLn("Low Physics Gravity " + (getDvarString("phys_gravity") != "-10" ? "^1OFF" : "^2ON") );
}

SustainAmmo()
{
    SetDvar("player_sustainAmmo", !GetDvarInt("player_sustainAmmo"));
    self iPrintLn("Unlimited Ammo & Equipment " + (!GetDvarInt("player_sustainAmmo") ? "^1OFF" : "^2ON") );
}

PlayersUnlimitedSprint()
{
    level.PlayersUnlimitedSprint = !bool(level.PlayersUnlimitedSprint);
    SetDvar("player_sprintUnlimited", level.PlayersUnlimitedSprint);
    self iPrintLn("Unlimited Sprint " + (!level.PlayersUnlimitedSprint ? "^1OFF" : "^2ON") );
}

Gravity()
{
    SetDvar("bg_gravity", GetDvarInt("bg_gravity") == level.saveGravity ?  250 : level.saveGravity);
    self iPrintLn("Low Gravity " + (GetDvarInt("bg_gravity") == level.saveGravity ? "^1OFF" : "^2ON") );
}

AntiQuit()
{
    level.AntiQuit = !bool(level.AntiQuit);
    SetMatchFlag("disableIngameMenu", level.AntiQuit);
    self iPrintLn("AntiQuit " + (!level.AntiQuit ? "^1OFF" : "^2ON") );
}

AntiJoin()
{
    level.AntiJoin = !bool(level.AntiJoin);
    self iPrintLn("AntiJoin " + (!level.AntiJoin ? "^1OFF" : "^2ON") );
}

#ifdef MP
PauseTimer()
{
    level.PauseTimer = !bool(level.PauseTimer);
    if(level.PauseTimer)
        globallogic_utils::pauseTimer();
    else
        globallogic_utils::resumeTimer();
        
    self iPrintLn("Pause Game Timer " + (!level.PauseTimer ? "^1OFF" : "^2ON") );
}
#endif

CompleteDailyChallanges()
{
    self endon("disconnect");
    self iPrintLn("Completing Current Daily Challanges");
    for(e=768;e<808;e++)
    {
        statname  = tableLookup("gamedata/stats/zm/statsmilestones4.csv", 0, e, 4);
        statvalue = tableLookup("gamedata/stats/zm/statsmilestones4.csv", 0, e, 2);
        self AddPlayerStat(toUpper(statname), int(statvalue));
        wait .1;
        UploadStats(self);
    }
    self iPrintLn("Current Daily Challanges: ^2Done");
}

noTarget()
{
    self.ignoreme = !bool(self.ignoreme);
    self.ignorme_count = self.ignoreMe * 999;
    self iPrintLn("No Target " + (!self.ignoreme ? "^1OFF" : "^2ON") );
}

SetPerkCheck(perk)
{
    if(self hasPerk(perk))
    {
        self unSetPerk(perk);
        self iPrintLn("Perk: " + perk + " ^1Taken");
    }
    else
    {
        self setPerk(perk);
        self iPrintLn("Perk: " + perk + " ^2Set");
    }
}

FixBrokenStats()
{
    if(self getdstat("playerstatslist", "plevel", "statvalue") < 0) self setDStat("playerstatslist", "plevel", "statvalue", 0);
    if(self getdstat("playerstatslist", "rankxp", "statvalue") < 0) self setDStat("playerstatslist", "rankxp", "statvalue", 0);
    if(self getdstat("playerstatslist", "rank", "statvalue") < 0) self setDStat("playerstatslist", "rank", "statvalue", 0);
    if(self getdstat("playerstatslist", "paragon_rank", "statvalue") < 0) self setDStat("playerstatslist", "paragon_rank", "statvalue", 0);
    if(self getdstat("playerstatslist", "paragon_rankxp", "statvalue") < 0) self setDStat("playerstatslist", "paragon_rankxp", "statvalue", 0);
    uploadStats(self);
    
}

#ifdef MP
GiveAllPerks()
{
    self endon("disconnect");
    self iPrintLn("All Perks ^2Given");
    self setperk("specialty_additionalprimaryweapon");
    self setperk("specialty_armorpiercing");
    self setperk("specialty_armorvest");
    self setperk("specialty_bulletaccuracy");
    self setperk("specialty_bulletdamage");
    self setperk("specialty_bulletflinch");
    self setperk("specialty_bulletpenetration");
    self setperk("specialty_deadshot");
    self setperk("specialty_delayexplosive");
    self setperk("specialty_detectexplosive");
    self setperk("specialty_disarmexplosive");
    self setperk("specialty_earnmoremomentum");
    self setperk("specialty_explosivedamage");
    self setperk("specialty_extraammo");
    self setperk("specialty_fallheight");
    self setperk("specialty_fastads");
    self setperk("specialty_fastequipmentuse");
    self setperk("specialty_fastladderclimb");
    self setperk("specialty_fastmantle");
    self setperk("specialty_fastmeleerecovery");
    self setperk("specialty_fastreload");
    self setperk("specialty_fasttoss");
    self setperk("specialty_fastweaponswitch");
    self setperk("specialty_finalstand");
    self setperk("specialty_fireproof");
    self setperk("specialty_flakjacket");
    self setperk("specialty_flashprotection");
    self setperk("specialty_gpsjammer");
    self setperk("specialty_grenadepulldeath");
    self setperk("specialty_healthregen");
    self setperk("specialty_holdbreath");
    self setperk("specialty_immunecounteruav");
    self setperk("specialty_immuneemp");
    self setperk("specialty_immunemms");
    self setperk("specialty_immunenvthermal");
    self setperk("specialty_immunerangefinder");
    self setperk("specialty_killstreak");
    self setperk("specialty_longersprint");
    self setperk("specialty_loudenemies");
    self setperk("specialty_marksman");
    self setperk("specialty_movefaster");
    self setperk("specialty_nomotionsensor");
    self setperk("specialty_noname");
    self setperk("specialty_nottargetedbyairsupport");
    self setperk("specialty_nokillstreakreticle");
    self setperk("specialty_nottargettedbysentry");
    self setperk("specialty_pin_back");
    self setperk("specialty_pistoldeath");
    self setperk("specialty_proximityprotection");
    self setperk("specialty_quickrevive");
    self setperk("specialty_quieter");
    self setperk("specialty_reconnaissance");
    self setperk("specialty_rof");
    self setperk("specialty_scavenger");
    self setperk("specialty_showenemyequipment");
    self setperk("specialty_stunprotection");
    self setperk("specialty_shellshock");
    self setperk("specialty_sprintrecovery");
    self setperk("specialty_showonradar");
    self setperk("specialty_stalker");
    self setperk("specialty_twogrenades");
    self setperk("specialty_twoprimaries");
    self setperk("specialty_unlimitedsprint");
}

ChangeClass()
{
    self endon("death");
    self endon("disconnect");
    level.var_f817b02b = true;
    self globallogic_ui::beginclasschoice();
    self waittill("changed_class");
    self loadout::giveloadout(self.team, self.pers["class"]);
    level.var_f817b02b = undefined;
}

initTeamChange(player)
{
    if(player.team == "allies")
    {
        player iPrintLn("Team Set: ^2Axis");
        player changeTeam("axis");
    }
    else
    {
        player iPrintLn("Team Set: ^2Allies");
        player changeTeam("allies");
    }
}

changeTeam(team)
{
    self endon("disconnect");
    self.switching_teams = 1;
    self.joining_team    = team;
    self.leaving_team    = self.pers["team"];
    self.pers["team"] = team;
    self.team = team;
    self.sessionteam = self.pers["team"];
    self globallogic_ui::updateobjectivetext();
    self notify("end_respawn");
}

dokillstreaks(player)
{
    globallogic_score::_setplayermomentum(player, 9999);
}

toggleUAV()
{
    self.AdvanedUAV = !bool(self.AdvanedUAV);
    self iPrintLn("Advanced UAV " + (!self.AdvanedUAV ? "^1OFF" : "^2ON") );
    self setclientuivisibilityflag("g_compassShowEnemies", (self.AdvanedUAV ? 1 : 0));
}
#endif

GiveCamo(Camo)
{
    weapon = self GetCurrentWeapon();
    self TakeWeapon(weapon);
    #ifdef MP self giveWeapon(weapon, self CalcWeaponOptions(camo, 0, 0)); #endif
    #ifdef SP self giveWeapon(weapon, self CalcWeaponOptions(camo, 0, 0)); #endif
    #ifdef ZM self giveWeapon(weapon, self CalcWeaponOptions(camo, 0, 0), self GetBuildKitAttachmentCosmeticVariantIndexes(weapon, self zm_weapons::is_weapon_upgraded(self getCurrentWeapon()))); #endif
    self SwitchToWeaponImmediate(weapon);
    iPrintLn("Custom Camo ^2Set");
}

InfiniteHeroPower()
{
    level endon("game_ended");
    level endon("game_end");
    self endon("disconnect");
    level endon("game_ended");

    self.InfiniteHeroPower = !bool(self.InfiniteHeroPower);
    self iPrintLn("Infinite Specialist " + (!self.InfiniteHeroPower ? "^1OFF" : "^2ON") );
    while(self.InfiniteHeroPower)
    {
        if(self GadgetIsActive(0))
            self GadgetPowerSet(0, 99);
        else if(self GadgetPowerGet(0) < 100)
            self GadgetPowerSet(0, 100);
        wait .025;
    }
}

#ifdef ZM
GiveAllPerks()
{
    self endon("disconnect");
    if(self.num_perks == level._Perks.size)
    {
        for(e=0;e<level._Perks.size;e++)
            self notify(level._Perks[e] + "_stop");

        return;
    }

    self zm_utility::give_player_all_perks();
}
    
getPerkName(perk)
{
    perkID   = ["fastreload", "quickrevive", "armorvest", "additionalprimaryweapon", "doubletap2", "widowswine", "staminup", "deadshot", "electriccherry"];
    perkName = ["Speed Cola", "Quick Revive", "Jugger-Nog", "Mule Kick", "Double Tap Root Beer", "Widow's Wine", "Stamin-Up", "Deadshot Daiquiri", "Electric Cherry"];

    for(e=0;e<perkID.size;e++)
        if(perk == "specialty_" + perkID[e])
            return perkName[e];

    return perk;
}

GiveCusPerk(perk)
{
    self endon("disconnect");
    if(self hasPerk(perk))
    {
        self notify(perk + "_stop");
        return;
    }

    if(!self.IS_DRINKING)
    {
        self zm_perks::Give_Perk(perk, 0);

        gun = self zm_perks::perk_give_bottle_begin(perk);
        evt = self util::waittill_any_return("fake_death", "death", "player_downed", "weapon_change_complete", "perk_abort_drinking", "disconnect");

        if(evt == "weapon_change_complete")
            self zm_perks::perk_give_bottle_end(gun, perk);

        self notify("burp");
    }
    else
        self zm_perks::Give_Perk(perk, 0);
}

MaxScore(Remove)
{
    if(!isDefined(Remove))
        self zm_score::add_to_player_score(4194303);
    else
        self zm_score::minus_to_player_score(4194303);
}
    
EditScore(Val, take)
{
    if(self.score == 4194303 && isDefined(take))
        return;

    if(!isDefined(take))
        self zm_score::add_to_player_score(Val);
    else
        self zm_score::minus_to_player_score(Val);
}
    
GiveGobbleGums(GumID)
{
    GumID = level._GobbleGums[GumID];
    self bgb::give(GumID);
    iPrintLn("Gobble Gum ^2Given");
}

PapCurrentWeapon(Weapon)
{
    SaveAAt = self.AAT[Weapon];
    self.AAT[Weapon] = undefined;

    Upgrade = !(zm_weapons::is_weapon_upgraded(Weapon));

    if(Upgrade && !zm_weapons::can_upgrade_weapon(Weapon))
        return;

    NewWeapon = (Upgrade ? zm_weapons::get_upgrade_weapon(Weapon) : zm_weapons::get_base_weapon(Weapon));

    WeaponOpts = self GetWeaponOptions(weapon);
    BuildKit = self GetBuildKitAttachmentCosmeticVariantIndexes(Weapon);
    BuildNewWeapon = getWeapon(NewWeapon.rootweapon.name);


    self TakeWeapon(Weapon);
    self giveWeapon(BuildNewWeapon, self CalcWeaponOptions(randomInt(138), 0, 0), BuildKit);
    self SwitchToWeaponImmediate(BuildNewWeapon);

    if(isDefined(SaveAAt))
    {
        wait .1;
        self GiveAATWeapon(SaveAAt, self, true);
    }
}

GiveAATWeapon(AAT, player, string)
{
    current_weapon = player getCurrentWeapon();
    current_weapon = player zm_weapons::switch_from_alt_weapon(current_weapon);
    player AAT::acquire(current_weapon, (isDefined(string) ? AAT : level._WeaponAAT[AAT]));
}

ServerAutoRevive()
{
    level.AutoRevive = !bool(level.AutoRevive);
    self iPrintLn("Auto Revive " + (!level.AutoRevive ? "^1OFF" : "^2ON") );
    while(level.AutoRevive)
    {
        foreach(player in level.players)
            if(player laststand::player_is_in_laststand())
                player zm_laststand::auto_revive(player);

        wait .5;
    }
}

KillAllZmbs(type)
{
    zombies = GetAIArray();
    if(zombies.size < 0)
        return;

    foreach(zomb in zombies)
        zomb DoDamage(zomb.health * 2, zomb.origin);
        
    self iPrintLn("All Zombies ^2Killed");
}

TeleportToMagicBox()
{
    Chest = level.chests[level.chest_index];
    origin = Chest.zbarrier.origin;
    FORWARD = AnglesToForward(Chest.zbarrier.angles);
    right = AnglesToRight(Chest.zbarrier.angles);
    var_d9191ee9 = VectorToAngles(right);
    var_f2857d87 = origin - 48 * right;
    switch(randomInt(3))
    {
        case 0:
            var_f2857d87 = var_f2857d87 + 16 * right;
            break;
        case 1:
            var_f2857d87 = var_f2857d87 + 16 * FORWARD;
            break;
        case 2:
            var_f2857d87 = var_f2857d87 - 16 * right;
            break;
        case 3:
            var_f2857d87 = var_f2857d87 - 16 * FORWARD;
            break;
    }
    self SetOrigin(var_f2857d87);
    self SetPlayerAngles(var_d9191ee9);
}

toggle_all_boxes()
{
    if(!isDefined(level.show_all_boxes))
    {
        level.show_all_boxes = true;
        self iPrintLn("Show All Magic Boxes ^2ON");
        Array::thread_all(level.chests, ::show_mystery_box);
        Array::thread_all(level.chests, ::enable_all_chests);
        Array::thread_all(level.chests, ::fire_sale_box_fix);

        if(GetDvarString("magic_chest_movable") == "1")
            setDvar("magic_chest_movable", "0");
    }   
    else if(level.show_all_boxes != "waiting")
    {
        self iPrintLn("Show All Magic Boxes ^1OFF");
        level notify("stop_showing_all_boxes");
        level.show_all_boxes = "waiting";

        Array::thread_all(level.chests, ::remove_mystery_box);
        if(!isDefined(level.joker_disabled))
            setDvar("magic_chest_movable", "1");
    }
}
    
fire_sale_box_fix()
{
    level endon("stop_showing_all_boxes");
    while(true)
    {
        level waittill("fire_sale_off");
        self.was_temp = undefined;
    }
}

enable_all_chests()
{
    level endon("stop_showing_all_boxes");
    while(isDefined(self)) 
    {
        self.zbarrier waittill("closed");
        thread zm_unitrigger::register_static_unitrigger(self.unitrigger_stub, zm_magicbox::magicbox_unitrigger_think);
    }
}

get_chest_index()
{
    foreach(index, chest in level.chests)
    {
        if(self == chest)
            return index;
    }
    return undefined;
}

show_mystery_box()
{
    if(self zm_magicbox::is_chest_active() || self get_chest_index() == level.chest_index)
        return;
        
    self thread zm_magicbox::show_chest(); 
}

remove_mystery_box(chest_index = self get_chest_index())
{
    if(chest_index == level.chest_index)
        return;
    if(!isDefined(level.removing_count))
        level.removing_count = 0;
    
    while(self.hidden)
        wait .1;

    level.chests[chest_index].was_temp = 1;
    zm_powerup_fire_sale::remove_temp_chest(chest_index);

    level.removing_count++;
    if(level.removing_count == level.chests.size - 1)
    {
        level.show_all_boxes = undefined;
        level.removing_count = 0;
    }
}

MakeNeverMove()
{ 
    level.chests[level.chest_index].no_fly_away = (!isDefined(level.chests[level.chest_index].no_fly_away) ? true : undefined);
    self iPrintLn("Box Never Moves " + (!level.chests[level.chest_index].no_fly_away ? "^1OFF" : "^2ON") );
}

DisableAI()
{
    SetDvar("ai_disableSpawn", (GetDvarString("ai_disableSpawn") == "0" ? "1" : "0"));
    self iPrintLn("Disable Zombie Spawning " + (GetDvarString("ai_disableSpawn") == "0" ? "^1OFF" : "^2ON") );
}

FreezeAI()
{
    SetDvar("g_ai", (GetDvarString("g_ai") == "0" ? "1" : "0"));
    self iPrintLn("Freeze Zombies " + (GetDvarString("g_ai") == "1" ? "^1OFF" : "^2ON") );
}

SetRounds(value)
{
    if(!RoundNextValidator())
    {
        self iPrintLn("^1Error: ^7Cannot adjust the round at this time.");
        return;
    }

    level._next_round = int(get_roundnumber() + value);

    if(!isdefined(level.old_round_wait_func))
        level.old_round_wait_func = level.round_wait_func;

    level.round_wait_func = ::RoundWaitHook;

    if(!isdefined(level.old_func_get_zombie_spawn_delay))
        level.old_func_get_zombie_spawn_delay = level.func_get_zombie_spawn_delay;
    
    level.func_get_zombie_spawn_delay = ::RoundNextHook;
    hash_98efd7b6::func_8824774d(level._next_round);
    self iPrintLn("Round adjusted by ^2" + value);
}

RoundWaitHook()
{
    [[level.old_round_wait_func]]();
    set_roundNumber(level._next_round - 1);
}

RoundNextHook(round)
{
    set_roundNumber(level._next_round);
    level._next_round++;
    
    if(level.zombie_total < 0)
        level.zombie_total = 0;

    return [[level.old_func_get_zombie_spawn_delay]](int(min(level._next_round - 1, 100)));
}

get_roundnumber()
{
    return world.var_48b0db18 ^ 115;
}

set_roundNumber(number)
{
    if(!isdefined(number))
        return;

    number = int(number);

    level.round_number = number;
    world.var_48b0db18 = number ^ 115;
    SetRoundsPlayed(number);
}

RoundNextValidator()
{
    if(!level flag::get("begin_spawning"))
        return 0;
    zombies = GetAITeamArray(level.zombie_team);
    if(!isdefined(zombies) || zombies.size < 1)
        return 0;
    if(isdefined(level.var_35efa94c))
        if(![[level.var_35efa94c]]())
            return 0;
    if(isdefined(level.var_dfd95560) && level.var_dfd95560)
        return 0;
    return 1;
}

SpawnPowerUps(powerup)
{
    Location = self getCursorPos(250);
    self zm_powerups::specific_powerup_drop(powerup, Location);
    self iPrintLn("Powerup ^2Spawned");
}

getPowerUpName(PowerUp)
{
    PowerUpID   = ["double_points", "carpenter", "fire_sale", "free_perk", "full_ammo", "insta_kill", "nuke", "minigun", "bonus_points_player", "ww_grenade", "bonus_points_team", "shield_charge", "genesis_random_weapon"];
    PowerUpName = ["Double Points", "Carpenter", "Fire Sale", "Perk-A-Cola", "Max Ammo", "Insta-Kill", "Nuke", "Death Machine", "Bonus Points", "Widows Wine", "Bonus Points Team", "Shield Charge Bottle", "Random Weapon"];
    
    for(e=0;e<PowerUpID.size;e++)
        if(PowerUp == PowerUpID[e])
            return PowerUpName[e];
    
    return constructString(replaceChar(PowerUp, "_", " "));
}

selfInstaKill()
{
    self.personal_instakill = !bool(self.personal_instakill);
    self iPrintLn("Instant Kill " + (!self.personal_instakill ? "^1OFF" : "^2ON") );
}

DisablePoints()
{
    self.inhibit_scoring_from_zombies = !bool(self.inhibit_scoring_from_zombies);
    self iPrintLn("Disable Points " + (!self.inhibit_scoring_from_zombies ? "^1OFF" : "^2ON") );
}

SpecialistsMovement()
{
    level.SpecialistsMovement = !bool(level.SpecialistsMovement);
    self iPrintLn("Specialists Movement " + (!level.SpecialistsMovement ? "^1OFF" : "^2ON") );
    SetDvar("doublejump_enabled", level.SpecialistsMovement);
    SetDvar("playerEnergy_enabled", level.SpecialistsMovement);
    SetDvar("wallrun_enabled", level.SpecialistsMovement);
    SetDvar("sprintLeap_enabled", level.SpecialistsMovement);
}

OpenDoors()
{
    if(isDefined(level.all_doors_open) && !moon_doors_supported())
        return;

    
    level.all_doors_open = !bool(level.all_doors_open);
    self iPrintLn("All Doors " + (!level.all_doors_open ? "^1Closed" : "^2Open") );
    types = array("zombie_door", "zombie_airlock_buy");

    foreach(type in types)
    {
        zombie_doors = GetEntArray(type, "targetname");
        for(i=0;i<zombie_doors.size;i++)
        {
            if(zombie_doors[i]._door_open == 1 && !level.all_doors_open)
                zombie_doors[i] thread SetDoorsClosed();

            else if(zombie_doors[i]._door_open == 0 && level.all_doors_open)
                zombie_doors[i] thread SetDoorsOpen();
        } 
    }
}
    
moon_doors_supported()
{
    array = array("zm_sumpf", "zm_asylum", "zm_factory", "zm_theater", "zm_cosmodrome");

    if(isInArray(array, GetDvarString("mapname")))
        return true;

    return false;    
}

SetDoorsOpen()
{
    while(isdefined(self.door_is_moving) && self.door_is_moving)
        wait .05;

    self zm_blockers::door_opened(0);
}

SetDoorsClosed(Bool)
{
    while(isdefined(self.door_is_moving) && self.door_is_moving)
        wait .05;

    self zm_blockers::door_opened(0);

    if(!isDefined(Bool))
    {
        all_trigs = GetEntArray(self.target, "target");
        foreach(trig in all_trigs)
        {
            cost = (isdefined(self.zombie_cost) ? self.zombie_cost : 1000);
            trig zm_utility::set_hint_string(trig, "default_buy_door", cost);
            trig TriggerEnable(1);
        }
    }
}

OpenAllDebris()
{
    if(isDefined(level.OpenAllDebris))
        return;

    self iPrintLn("All Debris ^2Cleared");
    level.OpenAllDebris = true;
    zombie_debris = GetEntArray("zombie_debris", "targetname");
    foreach(debris in zombie_debris)
    {
        debris.zombie_cost = 0;
        debris notify("trigger", self, true);
    }
}

EnablePower(size = 0)
{
    if(level flag::get("power_on"))
        return;

    self iPrintLn("Power ^2Enabled");
    Arrays = array("use_elec_switch", "zombie_vending", "zombie_door");
    presets = array("elec", "power", "master");

    for(e=0;e<3;e++)
        size += Arrays[e].size;
    for(e=0;e<size;e++)
        level flag::set("power_on" + e);
        
    foreach(preset in presets)
    {
        trig = getEnt("use_" + preset + "_switch", "targetname");
        if(isDefined(trig))
        {
            trig notify("trigger", self);
            break;
        }
    }
    level flag::set("power_on");
}

grab_All_Craftables()
{
    if(isdefined(level.all_parts_required))
        return;

    level.all_parts_required = true;
    foreach(s_craftable in level.zombie_include_craftables)
    {
        foreach(s_piece in s_craftable.a_piecestubs)
        {
            if(isdefined(s_piece.pieceSpawn))
                self zm_craftables::player_take_piece(s_piece.pieceSpawn);
        }
    }
}
#endif

SetPrestige(Prestige)
{
    self SetDStat("playerstatslist", "plevel", "StatValue", Prestige);
    if(self GetDStat("playerstatslist", "plevel", "statValue") < 10 && self GetDStat( "playerstatslist", "paragon_rank", "statValue" ) > 56)
    {
        self SetDStat( "playerstatslist", "paragon_rankxp", "statValue", 0 );
        self SetDStat( "playerstatslist", "paragon_rank", "statValue", 0 );
        self SetDStat( "playerstatslist", "rankxp", "statValue", 1375000 );
        self SetDStat( "playerstatslist", "rank", "statValue", 34 );
    }
    else if(self GetDStat("playerstatslist", "plevel", "statValue") > 10)
    {
        self SetDStat( "playerstatslist", "rankxp", "statValue", 1375000 );
        self SetDStat( "playerstatslist", "rank", "statValue", 34 );
        self SetDStat( "playerstatslist", "paragon_rankxp", "statValue", 52345460 );
        self SetDStat( "playerstatslist", "paragon_rank", "statValue", 964 );
    }
    self iPrintLn("Prestige Set: ^2" + Prestige);
}

ForceHost()
{
    if(getDvarString("party_connectTimeout") != "0")
    {
        self iPrintLn("Force Host ^2ON");
        SetDvar("lobbySearchListenCountries", "0,103,6,5,8,13,16,23,25,32,34,24,37,42,44,50,71,74,76,75,82,84,88,31,90,18,35");
        SetDvar("excellentPing", 3);
        SetDvar("goodPing", 4);
        SetDvar("terriblePing", 5);
        SetDvar("migration_forceHost", 1);
        SetDvar("migration_minclientcount", 12);
        SetDvar("party_connectToOthers", 0);
        SetDvar("party_dedicatedOnly", 0);
        SetDvar("party_dedicatedMergeMinPlayers", 12);
        SetDvar("party_forceMigrateAfterRound", 0);
        SetDvar("party_forceMigrateOnMatchStartRegression", 0);
        SetDvar("party_joinInProgressAllowed", 1);
        SetDvar("allowAllNAT", 1);
        SetDvar("party_keepPartyAliveWhileMatchmaking", 1);
        SetDvar("party_mergingEnabled", 0);
        SetDvar("party_neverJoinRecent", 1);
        SetDvar("party_readyPercentRequired", .25);
        SetDvar("partyMigrate_disabled", 1);
    }
    else
    {
        self iPrintLn("Force Host ^1OFF");
        SetDvar("lobbySearchListenCountries", "");
        SetDvar("excellentPing", 30);
        SetDvar("goodPing", 100);
        SetDvar("terriblePing", 500);
        SetDvar("migration_forceHost", 0);
        SetDvar("migration_minclientcount", 2);
        SetDvar("party_connectToOthers", 1);
        SetDvar("party_dedicatedOnly", 0);
        SetDvar("party_dedicatedMergeMinPlayers", 2);
        SetDvar("party_forceMigrateAfterRound", 0);
        SetDvar("party_forceMigrateOnMatchStartRegression", 0);
        SetDvar("party_joinInProgressAllowed", 1);
        SetDvar("allowAllNAT", 1);
        SetDvar("party_keepPartyAliveWhileMatchmaking", 1);
        SetDvar("party_mergingEnabled", 1);
        SetDvar("party_neverJoinRecent", 0);
        SetDvar("partyMigrate_disabled", 0);
    }
}

AutoDropShot()
{
    self.AutoDropShot = !bool(self.AutoDropShot);
    self iPrintLn("Auto Drop Shot " + (!self.AutoDropShot ? "^1OFF" : "^2ON") );
    if(self.AutoDropShot)
    {
        self endon("StopAutoDropShot");
        while(self.AutoDropShot)
        {
            self waittill("weapon_fired");
            self SetStance("prone");
        }
        
    }
    else
        self notify("StopAutoDropShot");
}

KickAllPlayers()
{
    foreach(player in level.players)
        if(!player IsHost())
            Kick(player GetEntityNumber());
}
        
AllInvulnerability()
{
    level.AllInvulnerability = !bool(level.AllInvulnerability);
    self iPrintLn("All Players Invulnerability " + (!level.AllInvulnerability ? "^1OFF" : "^2ON") );
    foreach(player in level.players)
    {
        if(player.godmode == level.AllInvulnerability || player IsHost())
            continue;
            
        player Godmode(player);
    }
}

AllInvisible()
{
    level.AllInvisible = !bool(level.AllInvisible);
    self iPrintLn("All Players Invisible " + (!level.AllInvisible ? "^1OFF" : "^2ON") );
    foreach(player in level.players)
    {
        if(player.CantSeeMe == level.AllInvisible || player IsHost())
            continue;
            
            player Invisible(player);
    }
}

AllThirdPerson()
{
    level.AllThirdPerson = !bool(level.AllThirdPerson);
    self iPrintLn("All Players Third Person " + (!level.AllThirdPerson ? "^1OFF" : "^2ON") );
    foreach(player in level.players)
    {
        if(player.ThirdPerson == level.AllThirdPerson || player IsHost())
            continue;
            
        player ThirdPerson(player);
    }
}

AllMaxRank()
{
    self iPrintLn("All Players ^2Max Rank & Prestige");
    foreach(player in level.players)
    {
        if(!player IsHost())
            self MaxRank(player);
    }
}
    
AllPlayerChallenges()
{ 
    foreach(player in level.players)
    {
        if(!player IsHost() || !bool(player.Isunlockingall))
            player grab_stats_from_table(player); 
    }
}
        
AllPlayerAchievements()
{
    foreach(player in level.players)
    {
        if(!player IsHost())
            player UnlockAchievements(player);
    }
}
        
#ifdef SP
grab_stats_from_table(player)
{
    self iPrintLn("Unlocking All Challenges");
    for(e=512;e<589;e++)
    {
        Stat  = tableLookup("gamedata/stats/cp/statsmilestones3.csv", 0, e, 4);
        Value = tableLookup("gamedata/stats/cp/statsmilestones3.csv", 0, e, 6);
        
        player SetDStat("PlayerStatsList", Stat, "statValue", Value);
        player SetDStat("PlayerStatsList", Stat, "challengevalue", Value);
        wait .1;
    }
    
    UploadStats(player);
    self iPrintLn("Completed All Challenges ^2Done");
}

MaxWeaponRanks(player)
{
    self iPrintLn("Unlocking All Weapon Ranks");  
    for(e=1;e<36;e++)
    {
        weapon = tableLookup("gamedata/stats/cp/cp_statstable.csv", 0, e, 4);
        player addRankXp("kill", GetWeapon(weapon), undefined, undefined, 1, int(600));
        player addWeaponStat(GetWeapon(weapon), "kills", int(600) + randomIntRange(240, 928));
        player addweaponstat(GetWeapon(weapon), "headshots", int(600) + randomIntRange(240, 928));
        player addweaponstat(GetWeapon(weapon), "shots", int(600));
        player addweaponstat(GetWeapon(weapon), "hits", int(600));
        player addweaponstat(GetWeapon(weapon), "used", int(600) + randomIntRange(240, 928));
        player addweaponstat(GetWeapon(weapon), "misses", (int(600) * randomInt(5) / 2));


        player AddDStat("ItemStats", e, "stats", "kills", "statValue", int(600) + randomIntRange(240, 928));
        player AddDStat("ItemStats", e, "stats", "used", "statValue", int(600) + randomIntRange(240, 928));
        wait .05;
    }

    for(e=1;e<60;e++)
    {
        currentWeaponXP = player GetDStat("ItemStats", e, "xp");
        player SetDStat("ItemStats", e, "xp", 1000000 + currentWeaponXP);
        UploadStats(player);
    }
    
    player MaxWeaponRanksOptic();
    UploadStats(player);
    self iPrintLn("All Weapon Ranks ^2Done");
}

MaxWeaponRanksOptic()
{
    for(e=1;e<36;e++)
    {
        weapon     = tableLookup("gamedata/stats/cp/cp_statstable.csv", 0, e, 4);
        attachment = tableLookup("gamedata/stats/cp/cp_statstable.csv", 0, e, 8);
        
        foreach(attach in strTok(attachment, " "))
        {
            self SetDStat("attachments", attach, "stats", "kills", "statValue", 700);
            self SetDStat("attachments", attach, "stats", "kills", "challengeValue", 700);
            for(i = 1; i < 8; i++)
            {
                self SetDStat("attachments", attach, "stats", "challenge" + i, "statValue", 700);
                self SetDStat("attachments", attach, "stats", "challenge" + i, "challengeValue", 700);
            }
        }
    }
}

FindAllCollectible(player)
{
    player.FindAllCollectible = true;
    for(e=0;e<level._Maps.size;e++)
    {
        for(f=0;f<10;f++)
        {
            player SetDStat("PlayerStatsByMap", level._Maps[e], "collectibles", f, 1);
            player SetDStat("PlayerStatsByMap", level._Maps[e] + "_nightmares", "collectibles", f, 1);
            player AddRankXPValue("picked_up_collectible", 500);
        }

        player SetDStat("PlayerStatsByMap", level._Maps[e], "allCollectiblesCollected", 1);
        player notify("give_achievement", "CP_MISSION_COLLECTIBLES");
        wait .05;
    }
    player AddPlayerStat("career_collectibles", 54);
    player playlocalsound("uin_collectible_pickup");
    player SetDStat("PlayerStatsList", "ALL_COLLECTIBLES_COLLECTED", "statValue", 1);
    player GiveDecoration("cp_medal_all_collectibles");
    player notify("give_achievement", "CP_ALL_COLLECTIBLES");
    UploadStats(player);
    self iPrintLn("All Collectibles ^2Found");
}

GetAllCPDecorations(player)
{
    player.GetAllCPDecorations = true;
    a_decorations = player GetDecorations();
    for(i=0;i<a_decorations.size;i++)
        player GiveDecoration(a_decorations[i].name);

    UploadStats(player);
    self iPrintLn("All Decorations ^2Given");
}

UnlockMaps(player, map)
{
    player.score = randomIntRange(370000, 920000);
    player SetDStat("PlayerStatsList", "time_played_total", "StatValue", 2419200);
    player SetDStat("PlayerStatsList", "SCORE", "statValue", randomIntRange(370000, 920000));
    player SetDStat("PlayerStatsList", "headshots", "StatValue", 56245);
    player SetDStat("PlayerStatsList", "kills", "StatValue", 56245);
    player SetDStat("PlayerStatsList", "melee_kills", "StatValue", randomIntRange(2000, 5000));
    player SetDStat("PlayerStatsList", "grenade_kills", "StatValue", randomIntRange(2000, 5000));
    player SetDStat("PlayerStatsList", "total_shots", "StatValue", randomIntRange(7000, 9000));
    player SetDStat("PlayerStatsList", "hits", "StatValue", randomIntRange(2000, 5000));
    player SetDStat("PlayerStatsList", "misses", "StatValue", randomIntRange(2000, 5000));
    player SetDStat("PlayerStatsList", "deaths", "StatValue", randomIntRange(150000, 200000));
    
    if(!isDefined(map))
    {
        foreach(mapname in level._Maps)
        {
            player SetDStat("PlayerStatsByMap", mapname, "hasBeenCompleted", 1);
            
            player SetDStat("PlayerStatsByMap", mapname, "currentStats", "SCORE", randomIntRange(370000, 920000));
            player SetDStat("PlayerStatsByMap", mapname, "highestStats", "SCORE", randomIntRange(370000, 920000));
            for(i=0;i<100;i++)
            {
                player SetDStat("PlayerStatsByMap", mapname, "completedDifficulties", i, 1);
                player SetDStat("PlayerStatsByMap", mapname, "receivedXPForDifficulty", i, 1);
            }
        }
    }
    else
    {
        player SetDStat("PlayerStatsByMap", map, "hasBeenCompleted", 1);
        player SetDStat("PlayerStatsByMap", map, "currentStats", "SCORE", randomIntRange(370000, 920000));
        player SetDStat("PlayerStatsByMap", map, "highestStats", "SCORE", randomIntRange(370000, 920000));
        
        for(i=0;i<100;i++)
        {
            player SetDStat("PlayerStatsByMap", map, "completedDifficulties", i, 1);
            player SetDStat("PlayerStatsByMap", map, "receivedXPForDifficulty", i, 1);
        }
    }
    player AddRankXp("complete_mission_heroic");
    player UnlockNightmareMaps();
    self iPrintLn("Completed All Maps ^2Done");
}

UnlockNightmareMaps(player)
{
    foreach(mapname in level._Maps)
    {
        player SetDStat("PlayerStatsByMap", mapname + "_nightmares", "hasBeenCompleted", 1);
        player SetDStat("PlayerStatsByMap", mapname + "_nightmares", "currentStats", "SCORE", randomIntRange(370000, 920000));
        player SetDStat("PlayerStatsByMap", mapname + "_nightmares", "highestStats", "SCORE", randomIntRange(370000, 920000));
        for(i=0;i<100;i++)
        {
            player SetDStat("PlayerStatsByMap", mapname + "_nightmares", "completedDifficulties", i, 1);
            player SetDStat("PlayerStatsByMap", mapname + "_nightmares", "receivedXPForDifficulty", i, 1);
        }
    }
}

UnlockTokensCP(player)
{
    player GiveUnlockToken(10);
    UploadStats(player);
    self iPrintLn("10x Unlock Tokens ^2Given");
}
#endif