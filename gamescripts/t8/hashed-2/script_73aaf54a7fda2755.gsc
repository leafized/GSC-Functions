// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using script_35598499769dbb3d;
#using script_3f9e0dc8454d98e1;
#using script_57f7003580bb15e0;
#using scripts\core_common\ai_shared.gsc;
#using scripts\core_common\callbacks_shared.gsc;
#using scripts\core_common\clientfield_shared.gsc;
#using scripts\core_common\spawner_shared.gsc;
#using scripts\core_common\system_shared.gsc;
#using scripts\zm_common\zm_behavior.gsc;
#using scripts\zm_common\zm_devgui.gsc;

#namespace namespace_1d05befd;

/*
	Name: function_89f2df9
	Namespace: namespace_1d05befd
	Checksum: 0x75AFCEF2
	Offset: 0x1C8
	Size: 0x44
	Parameters: 0
	Flags: AutoExec
*/
function autoexec function_89f2df9()
{
	system::register(#"hash_831eacd382054cc", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: namespace_1d05befd
	Checksum: 0x4F4724CC
	Offset: 0x218
	Size: 0x194
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	spawner::add_archetype_spawn_function(#"zombie", &function_65089f84);
	clientfield::register("actor", "zm_ai/zombie_electric_fx_clientfield", 21000, 1, "int");
	clientfield::register("actor", "zombie_electric_burst_clientfield", 21000, 1, "counter");
	clientfield::register("actor", "zombie_electric_water_aoe_clientfield", 21000, 1, "counter");
	clientfield::register("actor", "zombie_electric_burst_stun_friendly_clientfield", 21000, 1, "int");
	clientfield::register("toplayer", "zombie_electric_burst_postfx_clientfield", 21000, 1, "counter");
	callback::on_player_damage(&function_4639701a);
	level.var_f8eb6737 = function_4d1e7b48(#"hash_3a1f530cdb5f75f4");
	/#
		zm_devgui::function_c7dd7a17("", "");
	#/
}

/*
	Name: __main__
	Namespace: namespace_1d05befd
	Checksum: 0x80F724D1
	Offset: 0x3B8
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function __main__()
{
}

/*
	Name: function_65089f84
	Namespace: namespace_1d05befd
	Checksum: 0xBD0DEE7F
	Offset: 0x3C8
	Size: 0x72
	Parameters: 0
	Flags: Linked, Private
*/
function private function_65089f84()
{
	if(isdefined(self.var_9fde8624) && self.var_9fde8624 == #"zombie_electric")
	{
		zm_behavior::function_57d3b5eb();
		self thread clientfield::set("zm_ai/zombie_electric_fx_clientfield", 1);
		self.actor_killed_override = &function_1a47fb39;
	}
}

/*
	Name: function_4639701a
	Namespace: namespace_1d05befd
	Checksum: 0xA531D208
	Offset: 0x448
	Size: 0xB4
	Parameters: 1
	Flags: Linked, Private
*/
function private function_4639701a(params)
{
	if(isdefined(params.eattacker) && isdefined(params.eattacker.var_9fde8624) && isdefined(params.smeansofdeath) && params.eattacker.var_9fde8624 == #"zombie_electric" && params.smeansofdeath == "MOD_MELEE")
	{
		self status_effect::status_effect_apply(level.var_f8eb6737, undefined, self, 0);
	}
}

/*
	Name: function_1a47fb39
	Namespace: namespace_1d05befd
	Checksum: 0x38449093
	Offset: 0x508
	Size: 0x16C
	Parameters: 8
	Flags: Linked, Private
*/
function private function_1a47fb39(einflictor, attacker, idamage, smeansofdeath, weapon, vdir, shitloc, psoffsettime)
{
	self thread clientfield::set("zm_ai/zombie_electric_fx_clientfield", 0);
	if(!(isdefined(self.water_damage) && self.water_damage))
	{
		self thread zombie_utility::zombie_gib(idamage, attacker, vdir, self gettagorigin("j_spine4"), smeansofdeath, shitloc, undefined, undefined, weapon);
		var_e98404d8 = self getcentroid();
		gibserverutils::annihilate(self);
		function_25c6cba0(self, var_e98404d8);
		if(isdefined(self.b_in_water) && self.b_in_water)
		{
			self clientfield::increment("zombie_electric_water_aoe_clientfield");
			level thread function_79e38cc4(var_e98404d8);
		}
	}
}

/*
	Name: function_25c6cba0
	Namespace: namespace_1d05befd
	Checksum: 0x76A3E18F
	Offset: 0x680
	Size: 0x320
	Parameters: 2
	Flags: Linked, Private
*/
function private function_25c6cba0(entity, origin)
{
	entity clientfield::increment("zombie_electric_burst_clientfield");
	players = getplayers();
	for(i = 0; i < players.size; i++)
	{
		distance_sq = distancesquared(origin, players[i] getcentroid());
		if(isdefined(entity.b_in_water) && entity.b_in_water && (isdefined(players[i].b_in_water) && players[i].b_in_water) && distance_sq <= 250000)
		{
			players[i] status_effect::status_effect_apply(level.var_f8eb6737, undefined, players[i], 0);
			continue;
		}
		if(distance_sq <= 32400)
		{
			players[i] clientfield::increment_to_player("zombie_electric_burst_postfx_clientfield");
		}
	}
	zombies = getaiteamarray(level.zombie_team);
	foreach(zombie in zombies)
	{
		if(zombie.archetype == #"zombie" && (!isdefined(zombie.var_9fde8624) || zombie.var_9fde8624 != #"zombie_electric") && (isdefined(entity.b_in_water) && entity.b_in_water) && (isdefined(zombie.b_in_water) && zombie.b_in_water) && distancesquared(origin, zombie.origin) <= 250000)
		{
			zombie clientfield::set("zombie_electric_burst_stun_friendly_clientfield", 1);
			zombie ai::stun(5);
			zombie thread function_ef1b9d42();
		}
	}
}

/*
	Name: function_ef1b9d42
	Namespace: namespace_1d05befd
	Checksum: 0x2F035908
	Offset: 0x9A8
	Size: 0x3C
	Parameters: 0
	Flags: Linked, Private
*/
function private function_ef1b9d42()
{
	self endon(#"death");
	wait(5);
	self clientfield::set("zombie_electric_burst_stun_friendly_clientfield", 0);
}

/*
	Name: function_79e38cc4
	Namespace: namespace_1d05befd
	Checksum: 0xB174A28F
	Offset: 0x9F0
	Size: 0x146
	Parameters: 1
	Flags: Linked, Private
*/
function private function_79e38cc4(origin)
{
	var_74d136f5 = 0;
	time_step = 0.5;
	while(var_74d136f5 <= 1.5)
	{
		players = getplayers();
		for(i = 0; i < players.size; i++)
		{
			distance_sq = distancesquared(origin, players[i] getcentroid());
			if(isdefined(players[i].b_in_water) && players[i].b_in_water && distance_sq <= 40000)
			{
				players[i] status_effect::status_effect_apply(level.var_f8eb6737, undefined, players[i], 0);
			}
		}
		wait(time_step);
		var_74d136f5 = var_74d136f5 + time_step;
	}
}

