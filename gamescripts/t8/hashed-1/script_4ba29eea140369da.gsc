// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using script_14f4a3c583c77d4b;
#using script_2255a7ad3edc838f;
#using script_27c22e1d8df4d852;
#using script_3b7405881c081f6;
#using script_6021ce59143452c3;
#using script_6e3c826b1814cab6;
#using scripts\core_common\aat_shared.gsc;
#using scripts\core_common\array_shared.gsc;
#using scripts\core_common\bots\bot_action.gsc;
#using scripts\core_common\callbacks_shared.gsc;
#using scripts\core_common\laststand_shared.gsc;
#using scripts\core_common\system_shared.gsc;
#using scripts\core_common\util_shared.gsc;
#using scripts\core_common\values_shared.gsc;
#using scripts\zm_common\zm.gsc;
#using scripts\zm_common\zm_hero_weapon.gsc;
#using scripts\zm_common\zm_laststand.gsc;
#using scripts\zm_common\zm_pack_a_punch_util.gsc;
#using scripts\zm_common\zm_perks.gsc;
#using scripts\zm_common\zm_player.gsc;
#using scripts\zm_common\zm_score.gsc;
#using scripts\zm_common\zm_utility.gsc;
#using scripts\zm_common\zm_weapons.gsc;

#namespace zm_trial_friendly_fire;

/*
	Name: function_89f2df9
	Namespace: zm_trial_friendly_fire
	Checksum: 0x8A42E52
	Offset: 0x150
	Size: 0x44
	Parameters: 0
	Flags: AutoExec
*/
function autoexec function_89f2df9()
{
	system::register(#"zm_trial_friendly_fire", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: zm_trial_friendly_fire
	Checksum: 0x533D41F1
	Offset: 0x1A0
	Size: 0x5C
	Parameters: 0
	Flags: None
*/
function __init__()
{
	if(!zm_trial::function_b47f6aba())
	{
		return;
	}
	zm_trial::register_challenge(#"friendly_fire", &function_d1de6a85, &function_9e7b3f4d);
}

/*
	Name: __main__
	Namespace: zm_trial_friendly_fire
	Checksum: 0xDFA61850
	Offset: 0x208
	Size: 0x2C
	Parameters: 0
	Flags: None
*/
function __main__()
{
	if(!zm_trial::function_b47f6aba())
	{
		return;
	}
	function_d8d095d5();
}

/*
	Name: function_d8d095d5
	Namespace: zm_trial_friendly_fire
	Checksum: 0xC8826201
	Offset: 0x240
	Size: 0xC4
	Parameters: 0
	Flags: None
*/
function function_d8d095d5()
{
	bot_action::function_ab03ca93(#"hash_4dfeb08c20a14b8b");
	bot_action::function_ab03ca93(#"hash_2b648e8ce3814bbb");
	bot_action::function_ab03ca93(#"hash_2c8e9cd5fbd53e70");
	bot_action::function_ab03ca93(#"hash_e1311542f5782b5");
	bot_action::function_ab03ca93(#"hash_354b896513d0581d");
	bot_action::function_ab03ca93(#"hash_81c373345c076c1");
}

/*
	Name: function_d1de6a85
	Namespace: zm_trial_friendly_fire
	Checksum: 0x2A4D080D
	Offset: 0x310
	Size: 0x2A4
	Parameters: 1
	Flags: Private
*/
function private function_d1de6a85(var_9e0a2a85 = 1)
{
	level endon(#"hash_7646638df88a3656");
	if(function_7a600918(var_9e0a2a85))
	{
		var_9e0a2a85 = zm_trial::function_5769f26a(var_9e0a2a85);
	}
	level.var_3c2226ce = namespace_59ff1d6c::function_901b751c(#"hash_3f8f02e8109b6e93");
	namespace_59ff1d6c::function_928be07c(var_9e0a2a85);
	callback::on_player_damage(&on_player_damage);
	level.var_edae191d = 1;
	var_6a94fd5e = 4 - getplayers().size;
	var_be33ceec = #"allies";
	level notify(#"hash_d3e36871aa6829f");
	for(i = 0; i < var_6a94fd5e; i++)
	{
		do
		{
			bot = bot::add_bot(var_be33ceec);
		}
		while(!isdefined(bot));
		bot.var_247fdf5 = 1;
		wait(1);
		if(bot util::is_spectating())
		{
			bot zm_player::spectator_respawn_player();
		}
	}
	foreach(player in getplayers())
	{
		if(isbot(player))
		{
			player thread function_e2c5e34c();
			player thread function_6aa8dd73();
		}
	}
	level.var_cd0fc105 = level.var_4804edae;
	level.var_4804edae = 0;
	zm::register_actor_damage_callback(&function_c4e6367a);
}

/*
	Name: function_9e7b3f4d
	Namespace: zm_trial_friendly_fire
	Checksum: 0xBFAA496F
	Offset: 0x5C0
	Size: 0x1EE
	Parameters: 1
	Flags: Private
*/
function private function_9e7b3f4d(round_reset)
{
	namespace_59ff1d6c::function_928be07c(level.var_3c2226ce);
	level.var_3c2226ce = undefined;
	callback::remove_on_player_damage(&on_player_damage);
	level.var_edae191d = undefined;
	foreach(player in getplayers())
	{
		if(isbot(player))
		{
			player val::reset("zm_trial_friendly_fire", "ignoreall");
			player val::reset("zm_trial_friendly_fire", "ignoreme");
		}
		if(isdefined(player.var_247fdf5) && player.var_247fdf5)
		{
			bot::remove_bot(player);
		}
	}
	level thread bot::populate_bots();
	if(isinarray(level.actor_damage_callbacks, &function_c4e6367a))
	{
		arrayremovevalue(level.actor_damage_callbacks, &function_c4e6367a, 0);
	}
	level.var_4804edae = level.var_cd0fc105;
	level.var_cd0fc105 = undefined;
}

/*
	Name: on_player_damage
	Namespace: zm_trial_friendly_fire
	Checksum: 0x6E69FAF9
	Offset: 0x7B8
	Size: 0x19E
	Parameters: 1
	Flags: Private
*/
function private on_player_damage(params)
{
	if(isplayer(params.eattacker) && !isbot(params.eattacker) && params.idamage >= self.health && params.eattacker != self)
	{
		zm_trial::fail(#"hash_6e2a00b7d2d6e510", array(params.eattacker));
		return;
	}
	if(isbot(self) && isdefined(params.einflictor) && isplayer(params.einflictor.activated_by_player) && !isbot(params.einflictor.activated_by_player) && params.idamage >= self.health)
	{
		zm_trial::fail(#"hash_6e2a00b7d2d6e510", array(params.einflictor.activated_by_player));
		return;
	}
}

/*
	Name: function_e2c5e34c
	Namespace: zm_trial_friendly_fire
	Checksum: 0xB21E1757
	Offset: 0x960
	Size: 0xC0
	Parameters: 0
	Flags: Private
*/
function private function_e2c5e34c()
{
	self endon(#"disconnect");
	level endon(#"hash_7646638df88a3656");
	while(true)
	{
		self val::reset("zm_trial_friendly_fire", "ignoreme");
		wait(randomintrange(3, 5));
		if(function_e1378d07())
		{
			self val::set("zm_trial_friendly_fire", "ignoreme", 1);
		}
		wait(randomintrange(5, 10));
	}
}

/*
	Name: function_e1378d07
	Namespace: zm_trial_friendly_fire
	Checksum: 0xD920EDFE
	Offset: 0xA28
	Size: 0xBE
	Parameters: 0
	Flags: Private
*/
function private function_e1378d07()
{
	foreach(player in getplayers())
	{
		if(isalive(player) && !isbot(player) && !player laststand::player_is_in_laststand())
		{
			return true;
		}
	}
	return false;
}

/*
	Name: function_c4e6367a
	Namespace: zm_trial_friendly_fire
	Checksum: 0xF941FCDA
	Offset: 0xAF0
	Size: 0xD2
	Parameters: 12
	Flags: Private
*/
function private function_c4e6367a(inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, boneindex, surfacetype)
{
	if(isplayer(attacker) && isbot(attacker) && level.round_number <= 20)
	{
		damage = int(damage * 0.5);
	}
	return damage;
}

/*
	Name: function_6aa8dd73
	Namespace: zm_trial_friendly_fire
	Checksum: 0xF5CBC1D7
	Offset: 0xBD0
	Size: 0x434
	Parameters: 0
	Flags: None
*/
function function_6aa8dd73()
{
	self endon(#"disconnect");
	if(self laststand::player_is_in_laststand() || !isalive(self) || self util::is_spectating())
	{
		self waittill(#"player_revived", #"spawned");
	}
	if(level.round_number >= 20)
	{
		self zm_hero_weapon::function_1bb7f7b1(3);
		var_98cb6e9 = array::randomize(array(#"hash_4dfeb08c20a14b8b", #"hash_2b648e8ce3814bbb", #"hash_2c8e9cd5fbd53e70", #"hash_e1311542f5782b5", #"hash_354b896513d0581d", #"hash_81c373345c076c1"));
		n_repacks = 4;
		self zm_perks::function_cc24f525();
	}
	else
	{
		if(level.round_number >= 10)
		{
			self zm_hero_weapon::function_1bb7f7b1(2);
			var_98cb6e9 = array::randomize(array(#"hash_4dfeb08c20a14b8b", #"hash_2b648e8ce3814bbb", #"hash_2c8e9cd5fbd53e70", #"hash_e1311542f5782b5", #"hash_354b896513d0581d", #"hash_81c373345c076c1"));
			n_repacks = 2;
		}
		else
		{
			self zm_hero_weapon::function_1bb7f7b1(1);
			var_98cb6e9 = array::randomize(array(#"ar_accurate_t8", #"ar_fastfire_t8", #"ar_stealth_t8", #"ar_modular_t8", #"smg_capacity_t8", #"tr_powersemi_t8"));
		}
	}
	foreach(w_primary in self getweaponslistprimaries())
	{
		self takeweapon(w_primary);
	}
	for(i = 0; i < zm_utility::get_player_weapon_limit(self); i++)
	{
		weapon = getweapon(var_98cb6e9[i]);
		weapon = self zm_weapons::give_build_kit_weapon(weapon);
		if(isdefined(level.aat_in_use) && level.aat_in_use && zm_weapons::weapon_supports_aat(weapon) && isdefined(n_repacks))
		{
			self thread aat::acquire(weapon);
			self zm_pap_util::repack_weapon(weapon, n_repacks);
		}
	}
	self switchtoweapon(weapon);
}

