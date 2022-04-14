// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using script_23789ec11f581cd0;
#using script_256b8879317373de;
#using script_2dc48f46bfeac894;
#using script_545a0bac37bda541;
#using script_57f7003580bb15e0;
#using script_59408f14f772675a;
#using script_7133a4d461308099;
#using scripts\core_common\callbacks_shared.gsc;
#using scripts\core_common\clientfield_shared.gsc;
#using scripts\core_common\math_shared.gsc;
#using scripts\core_common\scoreevents_shared.gsc;
#using scripts\core_common\system_shared.gsc;
#using scripts\core_common\util_shared.gsc;

#namespace namespace_b5dd0093;

/*
	Name: function_89f2df9
	Namespace: namespace_b5dd0093
	Checksum: 0x4597D17C
	Offset: 0x190
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec function_89f2df9()
{
	system::register(#"hash_4d07333d2c72a82", &init_shared, undefined, undefined);
}

/*
	Name: init_shared
	Namespace: namespace_b5dd0093
	Checksum: 0xC7C78316
	Offset: 0x1D8
	Size: 0x25C
	Parameters: 0
	Flags: Linked
*/
function init_shared()
{
	ability_player::register_gadget_activation_callbacks(36, &gadget_on, &gadget_off);
	ability_player::register_gadget_possession_callbacks(36, &hero_weapon::gadget_hero_weapon_on_give, &hero_weapon::gadget_hero_weapon_on_take);
	ability_player::register_gadget_ready_callbacks(36, &hero_weapon::gadget_hero_weapon_ready);
	clientfield::register("clientuimodel", "hudItems.localHealActive", 1, 1, "int");
	clientfield::register("allplayers", "tak_5_heal", 1, 1, "counter");
	callback::on_death(&function_d58bf295);
	callback::on_spawned(&function_a5b7c42d);
	callback::on_actor_damage(&function_1c0720fc);
	callback::on_player_damage(&function_1c0720fc);
	callback::on_player_killed_with_params(&on_player_killed);
	weapon = getweapon("eq_localheal");
	if(isdefined(weapon) && weapon.name != #"none")
	{
		level.var_c34a20f5 = getscriptbundle(weapon.var_4dd46f8a);
	}
	else
	{
		level.var_c34a20f5 = getscriptbundle("localheal_custom_settings");
	}
	globallogic_score::function_5a241bd8(weapon, &function_2100fa40);
	globallogic_score::function_86f90713(weapon, &function_4afb5c9d);
}

/*
	Name: function_d58bf295
	Namespace: namespace_b5dd0093
	Checksum: 0x2FB3F84C
	Offset: 0x440
	Size: 0xE4
	Parameters: 1
	Flags: Linked
*/
function function_d58bf295(params)
{
	entity = self;
	if(!isdefined(entity.var_1d79aad6) || (isdefined(entity.var_1d79aad6.var_1d79aad6.var_21de13e3) ? entity.var_1d79aad6.var_21de13e3 : 0) == 0)
	{
		self.var_894f7879[#"cleanse_buff"] = 0;
		return;
	}
	entity player::function_b933de24("cleanse_buff");
	entity function_c075723c("hudItems.localHealActive", 0);
	entity function_c7dcfe36(1, 0);
}

/*
	Name: function_a5b7c42d
	Namespace: namespace_b5dd0093
	Checksum: 0x43D8B747
	Offset: 0x530
	Size: 0x4E
	Parameters: 0
	Flags: Linked
*/
function function_a5b7c42d()
{
	player = self;
	player function_c7dcfe36(1, 0);
	player.var_1d79aad6 = undefined;
	player.var_b6672e47 = undefined;
	player.var_9db94fe3 = undefined;
}

/*
	Name: function_2100fa40
	Namespace: namespace_b5dd0093
	Checksum: 0x35F57238
	Offset: 0x588
	Size: 0x108
	Parameters: 5
	Flags: Linked
*/
function function_2100fa40(attacker, victim, weapon, attackerweapon, meansofdeath)
{
	if(!isdefined(attacker) || !isdefined(attackerweapon) || !isdefined(attacker.var_9db94fe3) || !isplayer(attacker.var_9db94fe3) || attacker.team == victim.team)
	{
		return false;
	}
	if(isdefined(attacker.var_b6672e47) && attacker.var_b6672e47 && attacker === attacker.var_9db94fe3 && (!isdefined(level.iskillstreakweapon) || ![[level.iskillstreakweapon]](attackerweapon)))
	{
		return true;
	}
	return false;
}

/*
	Name: function_4afb5c9d
	Namespace: namespace_b5dd0093
	Checksum: 0x1E72664D
	Offset: 0x698
	Size: 0x62
	Parameters: 4
	Flags: Linked
*/
function function_4afb5c9d(attacker, victim, weapon, attackerweapon)
{
	attacker.var_e374a90c = isdefined(attacker.var_b6672e47) && attacker.var_b6672e47;
	return function_2100fa40(attacker, victim, weapon);
}

/*
	Name: function_1c0720fc
	Namespace: namespace_b5dd0093
	Checksum: 0xA00E04DC
	Offset: 0x708
	Size: 0x1C4
	Parameters: 1
	Flags: Linked
*/
function function_1c0720fc(params)
{
	player = self;
	if(!isdefined(player.var_1d79aad6) || (isdefined(player.var_1d79aad6.var_1d79aad6.var_21de13e3) ? player.var_1d79aad6.var_21de13e3 : 0) == 0)
	{
		return;
	}
	diff = player.var_66cb03ad - (max(player.maxhealth, player.health - params.idamage));
	if(diff >= 25)
	{
		var_852b4a29 = int(diff / 25);
		player.var_1d79aad6.var_21de13e3 = max(player.var_1d79aad6.var_21de13e3 - var_852b4a29, 0);
		if(player.var_1d79aad6.var_21de13e3 > 0)
		{
			player player::function_2a67df65("cleanse_buff", player.var_1d79aad6.var_21de13e3 * 25, undefined, 1);
		}
		else
		{
			player player::function_b933de24("cleanse_buff", 1);
			player thread function_c04c8002();
		}
	}
}

/*
	Name: function_c04c8002
	Namespace: namespace_b5dd0093
	Checksum: 0x650BAD78
	Offset: 0x8D8
	Size: 0x72
	Parameters: 0
	Flags: Linked
*/
function function_c04c8002()
{
	self endon(#"disconnect", #"death");
	level endon(#"game_ended");
	self notify("2c5ea250cf8b9681");
	self endon("2c5ea250cf8b9681");
	wait(1);
	self.var_1d79aad6 = undefined;
	self.var_b6672e47 = undefined;
	self.var_9db94fe3 = undefined;
}

/*
	Name: on_player_killed
	Namespace: namespace_b5dd0093
	Checksum: 0xD1918CE1
	Offset: 0x958
	Size: 0x134
	Parameters: 1
	Flags: Linked
*/
function on_player_killed(params)
{
	player = self;
	attacker = params.eattacker;
	weapon = params.weapon;
	if(!isdefined(attacker) || !isplayer(attacker))
	{
		return;
	}
	if(isdefined(player.var_b6672e47) && player.var_b6672e47 && player === player.var_9db94fe3 && util::function_fbce7263(player.team, attacker.team))
	{
		attacker activecamo::function_896ac347(weapon, #"showstopper", 1);
		scoreevents::processscoreevent(#"hash_32b207d17e4776c1", attacker, player.var_9db94fe3, weapon);
	}
}

/*
	Name: has_target
	Namespace: namespace_b5dd0093
	Checksum: 0x59753833
	Offset: 0xA98
	Size: 0x3E
	Parameters: 0
	Flags: None
*/
function has_target()
{
	return isdefined(self.var_1d79aad6) && isdefined(self.var_1d79aad6.targets) && self.var_1d79aad6.targets.size > 0;
}

/*
	Name: function_c075723c
	Namespace: namespace_b5dd0093
	Checksum: 0xEE0D7053
	Offset: 0xAE0
	Size: 0x4C
	Parameters: 2
	Flags: Linked
*/
function function_c075723c(str_field_name, n_value)
{
	if(isplayer(self))
	{
		self clientfield::set_player_uimodel(str_field_name, n_value);
	}
}

/*
	Name: function_c7dcfe36
	Namespace: namespace_b5dd0093
	Checksum: 0x6C4DA0BC
	Offset: 0xB38
	Size: 0x4C
	Parameters: 2
	Flags: Linked
*/
function function_c7dcfe36(slot, value)
{
	if(isplayer(self))
	{
		self function_820a63e9(slot, value);
	}
}

/*
	Name: function_e68d45e7
	Namespace: namespace_b5dd0093
	Checksum: 0xE58CD126
	Offset: 0xB90
	Size: 0x3EC
	Parameters: 3
	Flags: Linked
*/
function function_e68d45e7(weapon, var_e2959480, var_7b8559d4)
{
	player = self;
	if(player == var_e2959480)
	{
		maxhealth = player.var_66cb03ad + (var_7b8559d4 * 25);
		var_c993fb53 = min(level.var_c34a20f5.var_9131fe6b, maxhealth);
		diff = int((max(maxhealth - var_c993fb53, 0)) / 25);
		var_7b8559d4 = var_7b8559d4 - diff;
	}
	if(var_7b8559d4 <= 0)
	{
		player.health = self.var_66cb03ad;
		return;
	}
	if(!player.var_1d79aad6.var_21de13e3 || player == var_e2959480)
	{
		player.var_b6672e47 = 1;
		player.var_9db94fe3 = var_e2959480;
		if(player == var_e2959480)
		{
			player playsoundtoplayer(#"hash_74180c0cc64f28b", player);
			player playsoundtoallbutplayer(#"hash_74180c0cc64f28b", player);
		}
		else
		{
			player playsound(#"hash_74180c0cc64f28b");
		}
		player callback::callback(#"hash_24e698e565a21a44");
		player function_c075723c("hudItems.localHealActive", 1);
		player clientfield::increment("tak_5_heal");
		var_d3c0f4a7 = function_4d1e7b48(#"wound");
		player status_effect::function_408158ef(var_d3c0f4a7.var_67e2281d, var_d3c0f4a7.var_18d16a6b);
		var_d3c0f4a7 = function_4d1e7b48(#"wound_radiation");
		player status_effect::function_408158ef(var_d3c0f4a7.var_67e2281d, var_d3c0f4a7.var_18d16a6b);
		if(player != var_e2959480)
		{
			scoreevents::processscoreevent(#"hash_443259a06e49440f", var_e2959480, player, weapon);
			var_e2959480.var_1d79aad6.var_e2e4899c = var_e2959480.var_1d79aad6.var_e2e4899c + 1;
		}
		player.var_1d79aad6.var_21de13e3 = player.var_1d79aad6.var_21de13e3 + var_7b8559d4;
		if(player.var_1d79aad6.var_21de13e3 > 2)
		{
			player.var_1d79aad6.var_21de13e3 = 2;
		}
		var_e2959480.var_b6971302 = 1;
		player player::function_2a67df65("cleanse_buff", player.var_1d79aad6.var_21de13e3 * 25);
		player.health = self.var_66cb03ad;
		player player::function_d1768e8e();
	}
}

/*
	Name: function_903b9495
	Namespace: namespace_b5dd0093
	Checksum: 0xDFF27DF0
	Offset: 0xF88
	Size: 0x1D0
	Parameters: 2
	Flags: Linked
*/
function function_903b9495(weapon, var_e2959480)
{
	player = self;
	var_4e843ec0 = (isdefined((player != var_e2959480 ? level.var_c34a20f5.var_a2a05449 : (isdefined(level.var_c34a20f5.var_c114af76) ? level.var_c34a20f5.var_c114af76 : 0))) ? (player != var_e2959480 ? level.var_c34a20f5.var_a2a05449 : (isdefined(level.var_c34a20f5.var_c114af76) ? level.var_c34a20f5.var_c114af76 : 0)) : 0);
	player function_e68d45e7(weapon, var_e2959480, var_4e843ec0);
	if(isdefined(self.var_121392a1))
	{
		foreach(effect in self.var_121392a1)
		{
			if(effect.var_3cf2d21 == #"hacking")
			{
				continue;
			}
			if(isdefined(level._status_effects[effect.var_67e2281d].end))
			{
				effect status_effect::function_408158ef(effect.var_67e2281d, effect.var_18d16a6b);
			}
		}
	}
}

/*
	Name: function_9fe3d492
	Namespace: namespace_b5dd0093
	Checksum: 0xC44513D3
	Offset: 0x1160
	Size: 0x6E
	Parameters: 0
	Flags: Linked
*/
function function_9fe3d492()
{
	player = self;
	if(!isdefined(player.var_1d79aad6))
	{
		player.var_1d79aad6 = spawnstruct();
	}
	if(!isdefined(player.var_1d79aad6.var_21de13e3))
	{
		player.var_1d79aad6.var_21de13e3 = 0;
	}
}

/*
	Name: function_ee175021
	Namespace: namespace_b5dd0093
	Checksum: 0xBC80BFB2
	Offset: 0x11D8
	Size: 0xA4
	Parameters: 2
	Flags: None
*/
function function_ee175021(array, entnum)
{
	var_66ac8e3e = undefined;
	foreach(var_8712c5b8 in array)
	{
		if(var_8712c5b8.entnum == entnum)
		{
			var_66ac8e3e = var_8712c5b8;
			break;
		}
	}
	return var_66ac8e3e;
}

/*
	Name: gadget_on
	Namespace: namespace_b5dd0093
	Checksum: 0x5FE823F1
	Offset: 0x1288
	Size: 0x21C
	Parameters: 2
	Flags: Linked
*/
function gadget_on(slot, weapon)
{
	player = self;
	player notify(#"hash_1fc72d26f9bee4eb");
	player endon(#"hash_1fc72d26f9bee4eb", #"disconnect");
	player function_9fe3d492();
	player.var_1d79aad6.var_e2e4899c = 0;
	player.var_1d79aad6.targets = [];
	var_660b71a5 = player function_45fd00c6();
	foreach(potentialtarget in var_660b71a5)
	{
		if(isalive(potentialtarget))
		{
			if(!isdefined(player.var_1d79aad6.targets))
			{
				player.var_1d79aad6.targets = [];
			}
			else if(!isarray(player.var_1d79aad6.targets))
			{
				player.var_1d79aad6.targets = array(player.var_1d79aad6.targets);
			}
			player.var_1d79aad6.targets[player.var_1d79aad6.targets.size] = potentialtarget;
			potentialtarget function_9fe3d492();
		}
	}
	player function_6628dc23(slot, weapon);
}

/*
	Name: gadget_off
	Namespace: namespace_b5dd0093
	Checksum: 0x7A9AEC62
	Offset: 0x14B0
	Size: 0x38
	Parameters: 2
	Flags: Linked
*/
function gadget_off(slot, weapon)
{
	player = self;
	player notify(#"hash_4889384a249efc16");
}

/*
	Name: function_6628dc23
	Namespace: namespace_b5dd0093
	Checksum: 0xC32689BB
	Offset: 0x14F0
	Size: 0x34C
	Parameters: 2
	Flags: Linked
*/
function function_6628dc23(slot, weapon)
{
	player = self;
	var_1edc9e27 = 0;
	player.var_b6971302 = 0;
	var_671e9ac0 = 0;
	foreach(target in player.var_1d79aad6.targets)
	{
		if(!isdefined(target))
		{
			continue;
		}
		friendly = target;
		var_f3a994b7 = friendly.maxhealth - friendly.health;
		if(var_f3a994b7 > 50)
		{
			scoreevents::processscoreevent(#"hash_66aed2c0af3fe6bd", player, friendly, weapon);
		}
		if(!var_671e9ac0 && isdefined(level.var_ac6052e9) && isdefined(level.playgadgetsuccess))
		{
			var_9194a036 = [[level.var_ac6052e9]]("localHealSuccessLineCount", 0) * 25;
			if(var_f3a994b7 > (isdefined(var_9194a036) ? var_9194a036 : 0))
			{
				player thread [[level.playgadgetsuccess]](weapon, undefined, undefined, friendly);
				var_671e9ac0 = 1;
			}
		}
		if(isdefined(level.var_ee93e2d4))
		{
			friendly [[level.var_ee93e2d4]](weapon, player);
		}
		friendly function_903b9495(weapon, player);
		player function_903b9495(weapon, player);
	}
	if(isdefined(level.var_c34a20f5.var_2f50349f) && level.var_c34a20f5.var_2f50349f)
	{
		if(player.var_1d79aad6.var_e2e4899c >= (isdefined(level.var_c34a20f5.var_9d1454f5) ? level.var_c34a20f5.var_9d1454f5 : 0))
		{
			var_1edc9e27 = 1;
			player function_e68d45e7(weapon, player, (isdefined(level.var_c34a20f5.var_12af1c65) ? level.var_c34a20f5.var_12af1c65 : 0));
			player status_effect::function_6519f95f();
		}
	}
	self luinotifyevent(#"hash_1c27b5e4f3724ea3", 2, player.var_b6971302, var_1edc9e27);
}

/*
	Name: function_45fd00c6
	Namespace: namespace_b5dd0093
	Checksum: 0x42EFABBF
	Offset: 0x1848
	Size: 0x1E6
	Parameters: 0
	Flags: Linked
*/
function function_45fd00c6()
{
	players = getplayers(self.team);
	if(isdefined(level.var_52a2e58a))
	{
		players = [[level.var_52a2e58a]](players);
	}
	if(sessionmodeiscampaigngame())
	{
		var_67b4687a = getactorteamarray(self.team);
		foreach(friendly in var_67b4687a)
		{
			if(!isdefined(players))
			{
				players = [];
			}
			else if(!isarray(players))
			{
				players = array(players);
			}
			players[players.size] = friendly;
		}
	}
	foreach(index, friendly in players)
	{
		if(friendly == self || ((isdefined(friendly.var_1d79aad6.var_1d79aad6.var_21de13e3) ? friendly.var_1d79aad6.var_21de13e3 : 0)))
		{
			players[index] = undefined;
		}
	}
	return players;
}

