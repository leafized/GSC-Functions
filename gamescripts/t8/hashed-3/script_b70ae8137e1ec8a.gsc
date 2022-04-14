// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using script_3affe3aaa3f22cb0;
#using script_3f65948f90646f7c;
#using script_3f9e54c7a9a7e1e2;
#using script_64ab2b950d85b8ad;
#using script_6842e9297547c313;
#using script_8210b63db522f15;
#using scripts\core_common\callbacks_shared.gsc;
#using scripts\core_common\struct.gsc;
#using scripts\core_common\system_shared.gsc;
#using scripts\mp_common\gametypes\globallogic.gsc;

#namespace namespace_a8c3133c;

/*
	Name: function_89f2df9
	Namespace: namespace_a8c3133c
	Checksum: 0xBD8BB707
	Offset: 0x110
	Size: 0x44
	Parameters: 0
	Flags: AutoExec
*/
function autoexec function_89f2df9()
{
	system::register(#"hash_5659ac71cc033a46", &__init__, undefined, #"hash_7a6bd16c1773964b");
}

/*
	Name: __init__
	Namespace: namespace_a8c3133c
	Checksum: 0xD26120FB
	Offset: 0x160
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	namespace_fa6b9ef8::function_90ee7a97(#"hash_7993541af41c24ec", &function_2613aeec);
}

/*
	Name: function_2613aeec
	Namespace: namespace_a8c3133c
	Checksum: 0x89199F56
	Offset: 0x1A0
	Size: 0x264
	Parameters: 1
	Flags: Linked
*/
function function_2613aeec(enabled)
{
	if(enabled)
	{
		callback::add_callback(#"hash_48bcdfea6f43fecb", &function_1c4b5097);
		callback::add_callback(#"hash_4b1a02a87458f191", &function_4ac25840);
		spawn_struct = struct::get("cu17_trigger_struct", "targetname");
		if(!isdefined(spawn_struct))
		{
			return;
		}
		radius = (isdefined(spawn_struct.radius) ? spawn_struct.radius : 200);
		height = (isdefined(spawn_struct.height) ? spawn_struct.height : 125);
		trigger = spawn("trigger_radius_use", spawn_struct.origin, 0, radius, height, 1);
		if(!isdefined(trigger))
		{
			return;
		}
		trigger triggerignoreteam();
		trigger setinvisibletoall();
		trigger setteamfortrigger(#"none");
		trigger setcursorhint("HINT_NOICON");
		trigger usetriggerignoreuseholdtime();
		trigger function_4bf6de9a(1);
		trigger usetriggerrequirelookat();
		trigger sethintstring(#"hash_5082ca83a4dd1416");
		trigger callback::function_35a12f19(&function_2043936c);
		trigger thread update_trigger_visibility();
	}
}

/*
	Name: function_80635b6f
	Namespace: namespace_a8c3133c
	Checksum: 0x7D0C3579
	Offset: 0x410
	Size: 0xC8
	Parameters: 0
	Flags: Linked
*/
function function_80635b6f()
{
	foreach(item_name in array(#"hash_4da28db320e11353", #"hash_5a5f9a4b9aede3f4", #"hash_12d0b662134986e2"))
	{
		item = self namespace_b376ff3f::function_7fe4ce88(item_name);
		if(isdefined(item))
		{
			return item;
		}
	}
}

/*
	Name: function_1c4b5097
	Namespace: namespace_a8c3133c
	Checksum: 0xA0AC46A7
	Offset: 0x4E0
	Size: 0x24C
	Parameters: 1
	Flags: Linked
*/
function function_1c4b5097(item)
{
	var_a6762160 = item.var_a6762160;
	if(var_a6762160.name == #"hash_4da28db320e11353" || var_a6762160.name == #"hash_5a5f9a4b9aede3f4" || var_a6762160.name == #"hash_12d0b662134986e2")
	{
		var_40e2a4c8 = getcharacterassetname(self getcharacterbodytype(), currentsessionmode());
		if(var_40e2a4c8 !== #"hash_f66f1d73b4acc45" && var_40e2a4c8 !== #"hash_29e6a0007c925dd4" && var_40e2a4c8 !== #"hash_22648ce3a4423d8f")
		{
			return;
		}
		if(!isdefined(level.var_ca57a3b8))
		{
			level.var_ca57a3b8 = [];
		}
		else if(!isarray(level.var_ca57a3b8))
		{
			level.var_ca57a3b8 = array(level.var_ca57a3b8);
		}
		level.var_ca57a3b8[level.var_ca57a3b8.size] = self;
	}
	else if(var_a6762160.name == #"hash_206ddd5a88e8c7c1")
	{
		var_c503939b = globallogic::function_e9e52d05();
		if(var_c503939b <= function_c816ea5b())
		{
			if(self character_unlock::function_f0406288(#"hash_7993541af41c24ec"))
			{
				self character_unlock::function_c8beca5e(#"hash_7993541af41c24ec", #"hash_418312990213bc41", 1);
			}
		}
	}
}

/*
	Name: function_4ac25840
	Namespace: namespace_a8c3133c
	Checksum: 0xCDDDA5E2
	Offset: 0x738
	Size: 0x1E2
	Parameters: 1
	Flags: Linked
*/
function function_4ac25840(var_d32e67b4)
{
	if(isdefined(level.var_b3fe1248) && level.var_b3fe1248)
	{
		return;
	}
	var_c503939b = globallogic::function_e9e52d05();
	if(var_c503939b <= function_c816ea5b())
	{
		foreach(team in level.teams)
		{
			if(teams::function_9dd75dad(team) && !teams::is_all_dead(team))
			{
				players = getplayers(team);
				foreach(player in players)
				{
					if(player character_unlock::function_f0406288(#"hash_7993541af41c24ec"))
					{
						player character_unlock::function_c8beca5e(#"hash_7993541af41c24ec", #"hash_418312990213bc41", 1);
					}
				}
			}
		}
		level.var_b3fe1248 = 1;
	}
}

/*
	Name: update_trigger_visibility
	Namespace: namespace_a8c3133c
	Checksum: 0xBA50340F
	Offset: 0x928
	Size: 0x174
	Parameters: 0
	Flags: Linked
*/
function update_trigger_visibility()
{
	self endon(#"death");
	level endon(#"game_ended");
	level.var_ca57a3b8 = [];
	while(true)
	{
		foreach(player in level.var_ca57a3b8)
		{
			if(!isdefined(player))
			{
				continue;
			}
			if(isdefined(player.var_b60fee90) && player.var_b60fee90)
			{
				continue;
			}
			if(distancesquared(player.origin, self.origin) > 250 * 250)
			{
				continue;
			}
			item = player function_80635b6f();
			if(isdefined(item))
			{
				self setvisibletoplayer(player);
				continue;
			}
			self setinvisibletoplayer(player);
		}
		wait(0.5);
	}
}

/*
	Name: function_2043936c
	Namespace: namespace_a8c3133c
	Checksum: 0x134379B7
	Offset: 0xAA8
	Size: 0x1DC
	Parameters: 1
	Flags: Linked
*/
function function_2043936c(trigger_struct)
{
	player = trigger_struct.activator;
	if(!isplayer(player))
	{
		return;
	}
	item = player function_80635b6f();
	if(isdefined(item))
	{
		point = function_4ba8fde(#"hash_206ddd5a88e8c7c1");
		if(isdefined(point) && isdefined(point.var_a6762160))
		{
			forward = anglestoforward(player.angles);
			droppos = player function_1188c2e8();
			dropitem = player item_drop::drop_item(point.var_a6762160.weapon, 1, point.var_a6762160.amount, point.id, droppos, player.angles);
			player namespace_b376ff3f::function_5852cb7b(item.var_bd027dd9);
			var_129fa609 = player function_80635b6f();
			player.var_b60fee90 = 1;
			if(!isdefined(var_129fa609))
			{
				arrayremovevalue(level.var_ca57a3b8, player);
			}
		}
		self setinvisibletoplayer(player);
	}
}

/*
	Name: function_1188c2e8
	Namespace: namespace_a8c3133c
	Checksum: 0xFEE3FEE6
	Offset: 0xC90
	Size: 0xDA
	Parameters: 0
	Flags: Linked, Private
*/
function private function_1188c2e8()
{
	var_6e5341fb = struct::get_array("cu17_drop_point", "targetname");
	if(isdefined(var_6e5341fb) && isarray(var_6e5341fb))
	{
		var_2e4ef4d0 = arraysortclosest(var_6e5341fb, self.origin);
		if(isdefined(var_2e4ef4d0[0]))
		{
			return var_2e4ef4d0[0].origin;
		}
	}
	forward = anglestoforward(self.angles);
	return (self.origin + (36 * forward)) + vectorscale((0, 0, 1), 10);
}

/*
	Name: function_c816ea5b
	Namespace: namespace_a8c3133c
	Checksum: 0xA69042BE
	Offset: 0xD78
	Size: 0xDA
	Parameters: 0
	Flags: Linked, Private
*/
function private function_c816ea5b()
{
	maxteamplayers = (isdefined(getgametypesetting(#"maxteamplayers")) ? getgametypesetting(#"maxteamplayers") : 1);
	switch(maxteamplayers)
	{
		case 1:
		{
			return 5;
		}
		case 2:
		{
			return 3;
		}
		case 4:
		default:
		{
			return 2;
		}
		case 5:
		{
			return 2;
		}
	}
}

