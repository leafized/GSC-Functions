#ifdef MP
#include scripts\codescripts\struct;
#include scripts\shared\callbacks_shared;
#include scripts\shared\clientfield_shared;
#include scripts\shared\math_shared;
#include scripts\shared\system_shared;
#include scripts\shared\util_shared;
#include scripts\shared\hud_util_shared;
#include scripts\shared\hud_message_shared;
#include scripts\shared\hud_shared;
#include scripts\shared\array_shared;
#include scripts\shared\rank_shared;
#include scripts\shared\flag_shared;
#include scripts\shared\killstreaks_shared;
#include scripts\shared\load_shared;
#include scripts\shared\weapons_shared;
#include scripts\shared\weapons\_weapons;
#include scripts\shared\persistence_shared;
#include scripts\shared\medals_shared;
#include scripts\shared\scoreevents_shared;
#include scripts\shared\visionset_mgr_shared;
    
#include scripts\mp\gametypes\_globallogic;
#include scripts\mp\gametypes\_globallogic_actor;
#include scripts\mp\gametypes\_globallogic_player;
#include scripts\mp\gametypes\_globallogic_vehicle;
#include scripts\mp\gametypes\_globallogic_score;
#include scripts\mp\gametypes\_globallogic_utils;
#include scripts\mp\gametypes\_globallogic_ui;
#include scripts\mp\gametypes\_loadout;
#include scripts\mp\killstreaks\_killstreaks;
#include scripts\mp\_contracts;
#include scripts\mp\_arena;
#endif

#ifdef ZM
#include scripts\codescripts\struct;
#include scripts\shared\callbacks_shared;
#include scripts\shared\clientfield_shared;
#include scripts\shared\math_shared;
#include scripts\shared\system_shared;
#include scripts\shared\util_shared;
#include scripts\shared\hud_util_shared;
#include scripts\shared\hud_message_shared;
#include scripts\shared\hud_shared;
#include scripts\shared\array_shared;
#include scripts\shared\aat_shared;
#include scripts\shared\rank_shared;
#include scripts\shared\ai\zombie_utility;
#include scripts\shared\ai\systems\gib;
#include scripts\shared\tweakables_shared;
#include scripts\shared\ai\systems\shared;
#include scripts\shared\ai\systems\blackboard;
#include scripts\shared\ai\systems\ai_interface;
#include scripts\shared\flag_shared;
#include scripts\shared\scoreevents_shared;
#include scripts\shared\lui_shared;
#include scripts\shared\scene_shared;
#include scripts\shared\vehicle_ai_shared;
#include scripts\shared\vehicle_shared;
#include scripts\shared\exploder_shared;
#include scripts\shared\ai_shared;
#include scripts\shared\doors_shared;
#include scripts\shared\gameskill_shared;
#include scripts\shared\laststand_shared;
#include scripts\shared\spawner_shared;
#include scripts\shared\visionset_mgr_shared;
    
#include scripts\zm\gametypes\_hud_message;
#include scripts\zm\gametypes\_globallogic;
#include scripts\zm\gametypes\_globallogic_audio;
#include scripts\zm\gametypes\_globallogic_score;
#include scripts\zm\_zm_lightning_chain;
#include scripts\zm\_util;
#include scripts\zm\_zm_zonemgr;
#include scripts\zm\_zm;
#include scripts\zm\_zm_bgb;
#include scripts\zm\_zm_score;
#include scripts\zm\_zm_stats;
#include scripts\zm\_zm_weapons;
#include scripts\zm\_zm_perks;
#include scripts\zm\_zm_equipment;
#include scripts\zm\_zm_utility;
#include scripts\zm\_zm_blockers;
#include scripts\zm\craftables\_zm_craftables;
#include scripts\zm\_zm_powerups;
#include scripts\zm\_zm_audio;
#include scripts\zm\_zm_spawner;
#include scripts\zm\_zm_playerhealth;
#include scripts\zm\_zm_magicbox;
#include scripts\zm\_zm_unitrigger;
#include scripts\zm\_zm_traps;
#include scripts\zm\_zm_laststand;
#include scripts\zm\bgbs\_zm_bgb_reign_drops;
#include scripts\zm\_zm_bgb_machine;
#include scripts\zm\_zm_bgb_token;
#include scripts\zm\_zm_powerup_fire_sale;
#include scripts\zm\aats\_zm_aat_fire_works;
#include scripts\zm\bgbs\_zm_bgb_round_robbin;
#endif

#ifdef SP
#include scripts\shared\persistence_shared;
#include scripts\shared\scoreevents_shared;
#include scripts\codescripts\struct;
#include scripts\shared\callbacks_shared;
#include scripts\shared\clientfield_shared;
#include scripts\shared\math_shared;
#include scripts\shared\system_shared;
#include scripts\shared\util_shared;
#include scripts\shared\hud_util_shared;
#include scripts\shared\hud_message_shared;
#include scripts\shared\hud_shared;
#include scripts\shared\array_shared;
#include scripts\shared\rank_shared;
#include scripts\shared\flag_shared;
#include scripts\shared\ai_shared;
#include scripts\shared\exploder_shared;
#include scripts\shared\flagsys_shared;
#include scripts\shared\gameobjects_shared;
#include scripts\shared\load_shared;
#include scripts\shared\lui_shared;
#include scripts\shared\sound_shared;
#include scripts\shared\spawner_shared;
#include scripts\shared\laststand_shared;
#include scripts\shared\music_shared;
#include scripts\shared\player_shared;
#include scripts\shared\trigger_shared;
#include scripts\shared\scoreevents_shared;
#include scripts\shared\table_shared;
#include scripts\shared\challenges_shared;
#include scripts\shared\weapons_shared;
#include scripts\shared\weapons\_weapons;
#include scripts\shared\visionset_mgr_shared;

#include scripts\cp\gametypes\_globallogic;
#include scripts\cp\gametypes\_globallogic_actor;
#include scripts\cp\gametypes\_globallogic_player;
#include scripts\cp\gametypes\_globallogic_vehicle;
#include scripts\cp\gametypes\_hostmigration;
#include scripts\cp\_achievements;
#include scripts\cp\gametypes\_save;
#include scripts\cp\_laststand;
#include scripts\cp\_challenges;
#include scripts\cp\_collectibles;
#include scripts\cp\_decorations;
#include scripts\cp\_skipto;
#include scripts\cp\_util;
#include scripts\cp\_accolades;
#endif

#namespace infinityloader;

autoexec __init__sytem__()
{
    system::register("infinityloader", ::__init__, undefined, undefined);
}

autoexec repair()
{
    callback::on_connect(::FixBrokenStats);
}

__init__()
{
    callback::on_start_gametype(::init);
    callback::on_connect(::onPlayerConnect);
    callback::on_spawned(::onPlayerSpawned);
}

init()
{
    level.player_out_of_playable_area_monitor = undefined;
    
    #ifdef SP
        level.callbackPlayerDamage = ::DamageOverride;
        level.callbackPlayerKilled = ::PlayerKilledOverride;
        level._Weapons  = EnumerateWeapons("weapon");
        level._Maps     = ["cp_mi_eth_prologue", "cp_mi_zurich_newworld", "cp_mi_sing_blackstation", "cp_mi_sing_biodomes", "cp_mi_sing_sgen", "cp_mi_sing_vengeance", "cp_mi_cairo_ramses", "cp_mi_cairo_infection", "cp_mi_cairo_aquifer", "cp_mi_cairo_lotus", "cp_mi_zurich_coalescence"];
        level._MapNames = ["Black Ops", "New World", "In Darkness", "Provocation", "Hypocanter", "Vengeance", "Rise & Fall", "Demon Within", "Sand Castle", "Lotus Towers", "Life"];
    #endif

    #ifdef MP
        level.onForfeit            = undefined;
        level.callbackPlayerDamage = ::DamageOverride;
        level.callbackPlayerKilled = ::PlayerKilledOverride;
        level._Weapons             = EnumerateWeapons("weapon");
        level._Killstreaks         = getArrayKeys(level.killstreaks);
        level.prematchPeriod       = 0;
    #endif

    #ifdef ZM
        level.overridePlayerDamage = ::_override_on_player_damage;
        level.callbackActorDamage  = ::_actor_damage_override_wrapper;
        level.SpawnPointsCustom    = ArrayCombine(struct::get_array("player_respawn_point_arena", "targetname"), struct::get_array("player_respawn_point", "targetname"), false, true);
        level._Perks               = getArrayKeys(level._custom_perks);
        level._PowerUps            = getArrayKeys(level.zombie_powerups);
        level._Weapons             = getArrayKeys(level.zombie_weapons);
        level._WeaponAAT           = getArrayKeys(level.AAT); 
        level._GobbleGums          = getArrayKeys(level.bgb);
        level thread CacheGobbleGums();
    #endif
    
    level.strings          = [];
    level.status           = ["Unverified", "Verified", "VIP", "Admin", "Co-Host", "Host"];
    level._Achievements    = ["CP_COMPLETE_PROLOGUE", "CP_COMPLETE_NEWWORLD", "CP_COMPLETE_BLACKSTATION", "CP_COMPLETE_BIODOMES", "CP_COMPLETE_SGEN", "CP_COMPLETE_VENGEANCE", "CP_COMPLETE_RAMSES", "CP_COMPLETE_INFECTION", "CP_COMPLETE_AQUIFER", "CP_COMPLETE_LOTUS", "CP_HARD_COMPLETE", "CP_REALISTIC_COMPLETE","CP_CAMPAIGN_COMPLETE", "CP_FIREFLIES_KILL", "CP_UNSTOPPABLE_KILL", "CP_FLYING_WASP_KILL", "CP_TIMED_KILL", "CP_ALL_COLLECTIBLES", "CP_DIFFERENT_GUN_KILL", "CP_ALL_DECORATIONS", "CP_ALL_WEAPON_CAMOS", "CP_CONTROL_QUAD", "CP_MISSION_COLLECTIBLES",  "CP_DISTANCE_KILL", "CP_OBSTRUCTED_KILL", "CP_MELEE_COMBO_KILL", "CP_COMPLETE_WALL_RUN", "CP_TRAINING_GOLD", "CP_COMBAT_ROBOT_KILL", "CP_KILL_WASPS", "CP_CYBERCORE_UPGRADE", "CP_ALL_WEAPON_ATTACHMENTS", "CP_TIMED_STUNNED_KILL", "CP_UNLOCK_DOA", "ZM_COMPLETE_RITUALS", "ZM_SPOT_SHADOWMAN", "ZM_GOBBLE_GUM", "ZM_STORE_KILL", "ZM_ROCKET_SHIELD_KILL", "ZM_CIVIL_PROTECTOR", "ZM_WINE_GRENADE_KILL", "ZM_MARGWA_KILL", "ZM_PARASITE_KILL", "MP_REACH_SERGEANT", "MP_REACH_ARENA", "MP_SPECIALIST_MEDALS", "MP_MULTI_KILL_MEDALS", "ZM_CASTLE_EE", "ZM_CASTLE_ALL_BOWS", "ZM_CASTLE_MINIGUN_MURDER", "ZM_CASTLE_UPGRADED_BOW", "ZM_CASTLE_MECH_TRAPPER", "ZM_CASTLE_SPIKE_REVIVE", "ZM_CASTLE_WALL_RUNNER", "ZM_CASTLE_ELECTROCUTIONER", "ZM_CASTLE_WUNDER_TOURIST", "ZM_CASTLE_WUNDER_SNIPER", "ZM_ISLAND_COMPLETE_EE", "ZM_ISLAND_DRINK_WINE", "ZM_ISLAND_CLONE_REVIVE", "ZM_ISLAND_OBTAIN_SKULL", "ZM_ISLAND_WONDER_KILL", "ZM_ISLAND_STAY_UNDERWATER", "ZM_ISLAND_THRASHER_RESCUE", "ZM_ISLAND_ELECTRIC_SHIELD", "ZM_ISLAND_DESTROY_WEBS", "ZM_ISLAND_EAT_FRUIT", "ZM_STALINGRAD_NIKOLAI", "ZM_STALINGRAD_WIELD_DRAGON", "ZM_STALINGRAD_TWENTY_ROUNDS", "ZM_STALINGRAD_RIDE_DRAGON", "ZM_STALINGRAD_LOCKDOWN", "ZM_STALINGRAD_SOLO_TRIALS", "ZM_STALINGRAD_BEAM_KILL", "ZM_STALINGRAD_STRIKE_DRAGON", "ZM_STALINGRAD_FAFNIR_KILL", "ZM_STALINGRAD_AIR_ZOMBIES", "ZM_GENESIS_EE", "ZM_GENESIS_SUPER_EE", "ZM_GENESIS_PACKECTOMY", "ZM_GENESIS_KEEPER_ASSIST", "ZM_GENESIS_DEATH_RAY", "ZM_GENESIS_GRAND_TOUR", "ZM_GENESIS_WARDROBE_CHANGE", "ZM_GENESIS_WONDERFUL", "ZM_GENESIS_CONTROLLED_CHAOS", "DLC2_ZOMBIE_ALL_TRAPS", "DLC2_ZOM_LUNARLANDERS", "DLC2_ZOM_FIREMONKEY", "DLC4_ZOM_TEMPLE_SIDEQUEST", "DLC4_ZOM_SMALL_CONSOLATION", "DLC5_ZOM_CRYOGENIC_PARTY", "DLC5_ZOM_GROUND_CONTROL", "ZM_DLC4_TOMB_SIDEQUEST", "ZM_DLC4_OVERACHIEVER", "ZM_PROTOTYPE_I_SAID_WERE_CLOSED", "ZM_ASYLUM_ACTED_ALONE", "ZM_THEATER_IVE_SEEN_SOME_THINGS"];
    level.WeaponCategories = ["Assault Rifles", "Submachine Guns", "Shotguns", "Light Machine Guns", "Sniper Rifles", "Launcher", "Pistols", "Specials"];
    level.saveGravity      = GetDvarInt("bg_gravity");
    
    level thread KillTriggers();
    level thread CacheCamos();
    level thread CacheWeapons();
    level thread onPlayerConnect();
}

GetKillStreakNames(killstreaks)
{
    if(level.killstreaks[killstreaks].menuName == "killstreak_helicopter_player_gunner")
        String = "Mothership";
    else if(level.killstreaks[killstreaks].menuName == "killstreak_uav")
        String = "UAV";
    else if(level.killstreaks[killstreaks].menuName == "killstreak_counteruav")
        String = "Counter-UAV";
    else
        String = MakeLocalizedString(level.killstreaks[killstreaks].menuName);
    
    return String;
}

onPlayerConnect()
{
    if(bool(level.AntiJoin))
        Kick(self GetEntityNumber());
        
    if(self isHost())
        self thread initializeSetup(5, self);
        
    #ifdef ZM self.iPrintLn = self createText("default", 1, "LEFT", "BOTTOM", -400, -185, 3, 0, "", (1, 1, 1)); #endif
}

onPlayerSpawned()
{
    self SetBlur(0, .01);
}

MenuAccessSpawn()
{
    self endon("disconnect");
    
    if(self IsHost())
    {
        #ifdef MP self waittill("spawned_player"); #endif
        #ifdef SP self waittill("spawned_player"); #endif
        #ifdef ZM level flag::wait_till("initial_blackscreen_passed"); #endif
        self FreezeControls(false);
    }
    
    self IPrintLn("Elite Mossy Remake Menu Ready. Press ^2Aim & Knife ^7To Open");
    self IPrintLn("Access Level: ^2" + level.status[self.access] + ". ^7Created By ^2ItsFebiven. ^7Base By ^2Extinct");
}

#ifdef SP
DamageOverride(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, boneIndex, vSurfaceNormal)
{
    if(bool(self.godmode) || bool(self.noclipExt) || IsDefined(self.CamRunning) || bool(self.SpecGod))
        return;
        
    if(bool(self.DemiGodmode))
    {
        self FakeDamageFrom(vDir);
        return;
    }
    
    if((isDefined(self.PHDPerk) && self.PHDPerk) && (sMeansOfDeath == "MOD_SUICIDE" || sMeansOfDeath == "MOD_PROJECTILE" || sMeansOfDeath == "MOD_PROJECTILE_SPLASH" || sMeansOfDeath == "MOD_GRENADE" || sMeansOfDeath == "MOD_GRENADE_SPLASH" || sMeansOfDeath == "MOD_EXPLOSIVE"))
        return 0;
        
    self [[globallogic_player::Callback_PlayerDamage]](eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, boneIndex, vSurfaceNormal);
}

PlayerKilledOverride(eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration, enteredResurrect)
{
    if(bool(self.godmode) || bool(self.noclipExt) || IsDefined(self.CamRunning) || bool(self.SpecGod))
        return;
    
    self [[globallogic_player::Callback_PlayerKilled]](eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration, enteredResurrect);
}
#endif

#ifdef MP
DamageOverride(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, boneIndex, vSurfaceNormal)
{
    if(bool(self.godmode) || bool(self.noclipExt) || IsDefined(self.CamRunning) || bool(self.SpecGod))
        return;
        
    if(bool(self.DemiGodmode))
    {
        self FakeDamageFrom(vDir);
        return;
    }
    
    if((isDefined(self.PHDPerk) && self.PHDPerk) && (sMeansOfDeath == "MOD_SUICIDE" || sMeansOfDeath == "MOD_PROJECTILE" || sMeansOfDeath == "MOD_PROJECTILE_SPLASH" || sMeansOfDeath == "MOD_GRENADE" || sMeansOfDeath == "MOD_GRENADE_SPLASH" || sMeansOfDeath == "MOD_EXPLOSIVE"))
        return 0;
        
    self [[globallogic_player::Callback_PlayerDamage]](eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, boneIndex, vSurfaceNormal);
}

PlayerKilledOverride(eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration, enteredResurrect)
{
    if(bool(self.godmode) || bool(self.noclipExt) || IsDefined(self.CamRunning) || bool(self.SpecGod))
        return;
    
    self [[globallogic_player::Callback_PlayerKilled]](eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration, enteredResurrect);
}
#endif

#ifdef ZM
_override_on_player_damage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime)
{
    if(bool(level.ZombieKnockback) && eAttacker.is_zombie)
        self SetVelocity(((AnglesToForward(VectorToAngles(self GetOrigin() - eAttacker GetOrigin())) + (0, 0, 5)) * (1337, 1337, 350)));
        
    if((isDefined(self.PHDPerk) && self.PHDPerk) && (sMeansOfDeath == "MOD_SUICIDE" || sMeansOfDeath == "MOD_PROJECTILE" || sMeansOfDeath == "MOD_PROJECTILE_SPLASH" || sMeansOfDeath == "MOD_GRENADE" || sMeansOfDeath == "MOD_GRENADE_SPLASH" || sMeansOfDeath == "MOD_EXPLOSIVE"))
        return 0;

    if(bool(self.SpecGod))
        return 0;

    if(bool(self.DemiGodmode))
    {
        self FakeDamageFrom(vDir);
        return 0;
    }

    if(isDefined(level.overridePlayerDamageOverSelf))
        damage = [[level.overridePlayerDamageOverSelf]](eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime);
    else
        damage = zm::player_damage_override(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime);
    
    return damage;
}

_actor_damage_override_wrapper(inflictor, attacker, damage, flags, meansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, boneIndex, modelIndex, surfaceType, vSurfaceNormal)
{
    zm::actor_damage_override_wrapper(inflictor, attacker, damage, flags, meansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, boneIndex, modelIndex, surfaceType, vSurfaceNormal);
    
    if(bool(attacker.ShowHitMarkers) || bool(level.ShowHitMarkers))
        attacker thread zombie_utility::show_hit_marker();
}
#endif

#ifdef MP
CacheWeapons()
{
    level.Weapons = [];
    weapNames = [];
    weapon_types = array("assault", "smg", "cqb", "lmg", "sniper", "launcher", "pistol", "special");

    foreach(weapon in level._Weapons)
        weapNames[weapNames.size] = weapon.name;

    for(i=0;i<weapon_types.size;i++)
    {
        level.Weapons[i] = [];
        for(e=1;e<147;e++)
        {
            weapon_categ = tableLookup("gamedata/stats/mp/mp_statstable.csv", 0, e, 2);
            weapon_name  = TableLookupIString("gamedata/stats/mp/mp_statstable.csv", 0, e, 3);
            weapon_id    = tableLookup("gamedata/stats/mp/mp_statstable.csv", 0, e, 4);
            if(weapon_categ == "weapon_" + weapon_types[i])
            {
                if(IsInArray(weapNames, weapon_id))
                {
                    weapon = spawnStruct();
                    weapon.name = weapon_name;
                    weapon.id = weapon_id;
                    level.Weapons[i][level.Weapons[i].size] = weapon;
                }
            }
        }
    }

    foreach(weapon in level._Weapons)
    {
        if((killstreaks::is_killstreak_weapon(weapon) || !weapons::is_primary_weapon(weapon) || !weapons::is_side_arm(weapon)) && !IsSubStr("melee_", weapon.name))
            continue;
            
        isInArray = false;
        for(e=0;e<level.Weapons.size;e++)
        {
            for(i=0;i<level.Weapons[e].size;i++)
            {
                if(isDefined(level.Weapons[e][i]) && level.Weapons[e][i].id == weapon.name)
                {
                    isInArray = true;
                    break;
                }
            }
        } 
        if(!isInArray && weapon.displayname != "")
        {
            weapons      = spawnStruct();
            weapons.name = MakeLocalizedString(weapon.displayname);
            weapons.id   = weapon.name;
            level.Weapons[7][level.Weapons[7].size] = weapons;
        }
    }
    
    extras      = ["defaultweapon", "baseweapon"];
    extrasNames = ["Default Weapon", "Base Weapon"];
    foreach(index, extra in extras)
    {
        weapons = spawnStruct();
        weapons.name = extrasNames[index];
        weapons.id = extra;
        level.Weapons[7][level.Weapons[7].size] = weapons;
    }
}
#endif

#ifdef ZM
CacheWeapons()
{
    level.Weapons = [];
    weapNames     = [];
    weapon_types  = ["assault", "smg", "cqb", "lmg", "sniper", "launcher", "pistol", "special"];

    foreach(weapon in level._Weapons)
        weapNames[weapNames.size] = weapon.name;

    for(i=0;i<weapon_types.size;i++)
    {
        level.Weapons[i] = [];
        for(e=1;e<100;e++)
        {
            weapon_categ = tableLookup("gamedata/stats/zm/zm_statstable.csv", 0, e, 2);
            weapon_name = TableLookupIString("gamedata/stats/zm/zm_statstable.csv", 0, e, 3);
            weapon_id = tableLookup("gamedata/stats/zm/zm_statstable.csv", 0, e, 4);
            if(weapon_categ == "weapon_" + weapon_types[i])
            {
                if(IsInArray(weapNames, weapon_id))
                {
                    weapon = spawnStruct();
                    weapon.name = weapon_name;
                    weapon.id = weapon_id;
                    level.Weapons[i][level.Weapons[i].size] = weapon;
                }
            }
        }
    }

    foreach(weapon in level._Weapons)
    {
        isInArray = false;
        for(e=0;e<level.Weapons.size;e++)
        {
            for(i=0;i<level.Weapons[e].size;i++)
                if(isDefined(level.Weapons[e][i]) && level.Weapons[e][i].id == weapon.name)
                    isInArray = true;
        } 
        if(!isInArray && weapon.displayname != "")
        {
            weapons = spawnStruct();
            weapons.name = MakeLocalizedString(weapon.displayname);
            weapons.id = weapon.name;
            level.Weapons[7][level.Weapons[7].size] = weapons;
        }
    }

    extras = ["zombie_beast_grapple_dwr", "minigun", "defaultweapon", "tesla_gun"];
    extrasNames = ["Beast Weapon", "Death Machine", "Default Weapon", "The Undead-Zapper"];
    foreach(index, extra in extras)
    {
        weapons = spawnStruct();
        weapons.name = extrasNames[index];
        weapons.id = extra;
        level.Weapons[7][level.Weapons[7].size] = weapons;
    }
}

CacheGobbleGums()
{
    level._GobbleGumsNames = [];
    for(e=0;e<level._GobbleGums.size;e++)
        level._GobbleGumsNames[e] = constructString(replaceChar(getSubStr(level._GobbleGums[e], 7), "_", " "));
}
#endif

#ifdef SP
CacheWeapons()
{
    level.Weapons = [];
    weapNames = [];
    weapon_types = array("assault", "smg", "cqb", "lmg", "sniper", "launcher", "pistol", "special");

    foreach(weapon in level._Weapons)
        weapNames[weapNames.size] = weapon.name;

    for(i=0;i<weapon_types.size;i++)
    {
        level.Weapons[i] = [];
        for(e=1;e<100;e++)
        {
            weapon_categ = tableLookup("gamedata/stats/cp/cp_statstable.csv", 0, e, 2);
            weapon_name  = TableLookupIString("gamedata/stats/cp/cp_statstable.csv", 0, e, 3);
            weapon_id    = tableLookup("gamedata/stats/cp/cp_statstable.csv", 0, e, 4);
            if(weapon_categ == "weapon_" + weapon_types[i])
            {
                if(IsInArray(weapNames, weapon_id))
                {
                    weapon = spawnStruct();
                    weapon.name = weapon_name;
                    weapon.id = weapon_id;
                    level.Weapons[i][level.Weapons[i].size] = weapon;
                }
            }
        }
    }

    foreach(weapon in level._Weapons)
    {
        if(!weapons::is_primary_weapon(weapon) || !weapons::is_side_arm(weapon))
            continue;
            
        isInArray = false;
        for(e=0;e<level.Weapons.size;e++)
        {
            for(i=0;i<level.Weapons[e].size;i++)
            {
                if(isDefined(level.Weapons[e][i]) && level.Weapons[e][i].id == weapon.name)
                {
                    isInArray = true;
                    break;
                }
            }
        } 
        if(!isInArray && weapon.displayname != "")
        {
            weapons      = spawnStruct();
            weapons.name = MakeLocalizedString(weapon.displayname);
            weapons.id   = weapon.name;
            level.Weapons[7][level.Weapons[7].size] = weapons;
        }
    }
    
    extras      = ["defaultweapon"];
    extrasNames = ["Default Weapon"];
    foreach(index, extra in extras)
    {
        weapons = spawnStruct();
        weapons.name = extrasNames[index];
        weapons.id = extra;
        level.Weapons[7][level.Weapons[7].size] = weapons;
    }
}
#endif
CacheCamos()
{
    level._Camos = [];
    for(e=0;e<290;e++)
    {
        row = TableLookupRow("gamedata/weapons/common/weaponoptions.csv", e);
        
        if(!isdefined(row) || !isdefined(row.size) || row.size < 3)
            continue;
            
        if(row[1] != "camo")
            continue;
            
        level._Camos[level._Camos.size] = constructString(replaceChar(row[2], "_", " "));
    }
}

replaceChar(string, substring, replace)
{
    final = "";
    for(e=0;e<string.size;e++)
    {
        if(string[e] == substring)
            final += replace;
        else 
            final += string[e];
    }
    return final;
}

constructString(string)
{
    final = "";
    for(e=0;e<string.size;e++)
    {
        if(e == 0)
            final += toUpper(string[e]);
        else if(string[e-1] == " ")
            final += toUpper(string[e]);
        else 
            final += string[e];
    }
    return final;
}