// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using script_18f0d22c75b141a7;
#using script_47fb62300ac0bd60;
#using script_545a0bac37bda541;
#using scripts\core_common\callbacks_shared.gsc;
#using scripts\core_common\challenges_shared.gsc;
#using scripts\core_common\contracts_shared.gsc;
#using scripts\core_common\scoreevents_shared.gsc;
#using scripts\core_common\system_shared.gsc;
#using scripts\core_common\util_shared.gsc;
#using scripts\mp_common\gametypes\globallogic_score.gsc;
#using scripts\mp_common\gametypes\globallogic_utils.gsc;
#using scripts\mp_common\util.gsc;

#namespace contracts;

/*
	Name: function_89f2df9
	Namespace: contracts
	Checksum: 0x89AD72E1
	Offset: 0x100
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec function_89f2df9()
{
	system::register(#"contracts", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: contracts
	Checksum: 0xA3936BE
	Offset: 0x148
	Size: 0x54
	Parameters: 0
	Flags: None
*/
function __init__()
{
	if(!isdefined(level.challengescallbacks))
	{
		level.challengescallbacks = [];
	}
	init_player_contract_events();
	callback::on_finalize_initialization(&finalize_init);
}

/*
	Name: finalize_init
	Namespace: contracts
	Checksum: 0x2896F08F
	Offset: 0x1A8
	Size: 0x1DC
	Parameters: 0
	Flags: None
*/
function finalize_init()
{
	callback::on_connect(&on_player_connect);
	if(can_process_contracts())
	{
		register_player_contract_event(#"headshot", &on_headshot_kill);
		register_player_contract_event(#"hash_4b92edc69ea525fc", &function_a0045e6a);
		register_player_contract_event(#"hash_10b0c56ae630070d", &function_8af6a5a);
		challenges::registerchallengescallback("playerKilled", &contract_kills);
		challenges::registerchallengescallback("gameEnd", &function_a4c8ce2a);
		globallogic_score::registercontractwinevent(&contract_win);
		register_player_contract_event(#"ekia", &function_71eb8a5a, 1);
		register_player_contract_event(#"objective_ekia", &function_660b0026);
		level.var_79a93566 = &function_902ef0de;
		level.var_c3e2bb05 = 1;
		/#
			thread devgui_setup();
		#/
	}
}

/*
	Name: on_player_connect
	Namespace: contracts
	Checksum: 0x66938D86
	Offset: 0x390
	Size: 0x3C
	Parameters: 0
	Flags: None
*/
function on_player_connect()
{
	if(can_process_contracts())
	{
		self setup_player_contracts(3, &function_90a854d2);
	}
}

/*
	Name: can_process_contracts
	Namespace: contracts
	Checksum: 0x6ABFA6E0
	Offset: 0x3D8
	Size: 0xA2
	Parameters: 0
	Flags: None
*/
function can_process_contracts()
{
	if(getdvarint(#"hash_5f85c5979e163766", 0) == 0)
	{
		return 0;
	}
	if(getdvarint(#"contracts_enabled_mp", 1) == 0)
	{
		return 0;
	}
	if(!sessionmodeismultiplayergame())
	{
		return 0;
	}
	if(level.var_aa5e6547 === 1)
	{
		return 0;
	}
	return challenges::canprocesschallenges();
}

/*
	Name: contract_kills
	Namespace: contracts
	Checksum: 0x5896F41
	Offset: 0x488
	Size: 0x27A
	Parameters: 1
	Flags: None
*/
function contract_kills(data)
{
	victim = data.victim;
	attacker = data.attacker;
	player = attacker;
	weapon = data.weapon;
	time = data.time;
	iskillstreak = isdefined(data.einflictor) && isdefined(data.einflictor.killstreakid);
	if(!iskillstreak && isdefined(level.iskillstreakweapon))
	{
		iskillstreakweapon = [[level.iskillstreakweapon]](weapon);
	}
	if(iskillstreak || iskillstreakweapon === 1)
	{
		switch(weapon.statname)
		{
			case "dart":
			{
				player function_fd9fb79b(#"hash_49548f9cffbc23b1");
				break;
			}
			case "ac130":
			{
				player function_fd9fb79b(#"hash_5ec4310df5255d7c");
				break;
			}
			case "recon_car":
			{
				player function_fd9fb79b(#"hash_57e191df429b849b");
				break;
			}
			case "planemortar":
			{
				player function_fd9fb79b(#"hash_4510de827483df7f");
				break;
			}
			case "remote_missile":
			{
				player function_fd9fb79b(#"hash_35d3b04e631ba3a4");
				break;
			}
			case "ai_tank_marker":
			{
				player function_fd9fb79b(#"hash_2a79ee2bb63d7c94");
				break;
			}
			default:
			{
				break;
			}
		}
	}
}

/*
	Name: function_a34653da
	Namespace: contracts
	Checksum: 0x34330EC9
	Offset: 0x710
	Size: 0x72
	Parameters: 1
	Flags: None
*/
function function_a34653da(weapon)
{
	if(!isdefined(weapon))
	{
		return 0;
	}
	if(!isdefined(weapon.attachments))
	{
		return 0;
	}
	var_97f022b3 = weapon.attachments.size;
	if(self getweaponoptic(weapon) != "")
	{
		var_97f022b3--;
	}
	return var_97f022b3;
}

/*
	Name: function_71eb8a5a
	Namespace: contracts
	Checksum: 0x1E57D6E3
	Offset: 0x790
	Size: 0x474
	Parameters: 1
	Flags: None
*/
function function_71eb8a5a(weapon)
{
	player = self;
	if(level.hardcoremode)
	{
		player function_fd9fb79b(#"hash_473a8eefc745db7b");
	}
	var_6b9aa5a0 = undefined;
	weaponclass = util::getweaponclass(weapon);
	if(!isdefined(weaponclass))
	{
		weaponclass = #"unspecified";
	}
	switch(weaponclass)
	{
		case "weapon_assault":
		{
			var_6b9aa5a0 = #"hash_1005918e22a7865b";
			break;
		}
		case "weapon_lmg":
		{
			var_6b9aa5a0 = #"hash_151c8e7a35e1e380";
			break;
		}
		case "weapon_pistol":
		{
			var_6b9aa5a0 = #"hash_250c2d8ef2261723";
			break;
		}
		case "weapon_cqb":
		{
			var_6b9aa5a0 = #"hash_5262d5b92e0fdc2";
			break;
		}
		case "weapon_smg":
		{
			var_6b9aa5a0 = #"hash_2173bc0bfcbdf90f";
			break;
		}
		case "weapon_sniper":
		{
			var_6b9aa5a0 = #"hash_21762ab1513fddf";
			break;
		}
		case "weapon_tactical":
		{
			var_6b9aa5a0 = #"hash_1a4fe101c7aab2d";
			break;
		}
		default:
		{
			break;
		}
	}
	if(isdefined(var_6b9aa5a0))
	{
		player function_fd9fb79b(var_6b9aa5a0);
	}
	var_8a4cfbd = 0;
	if(weapon.var_76ce72e8)
	{
		scoreevents = globallogic_score::function_3cbc4c6c(weapon.var_2e4a8800);
		var_8a4cfbd = isdefined(scoreevents) && scoreevents.var_fcd2ff3a === 1;
	}
	if(var_8a4cfbd)
	{
		player function_a54e2068(#"hash_6b52fb637a3c29cb");
	}
	else if(weapon.var_b76e0a09)
	{
		player function_a54e2068(#"hash_31a6484e36a0a20f");
	}
	loadout_primary_weapon = player loadout::function_18a77b37("primary");
	loadout_secondary_weapon = player loadout::function_18a77b37("secondary");
	var_97f022b3 = player function_a34653da(weapon);
	var_2d9746d0 = player function_a34653da(loadout_primary_weapon);
	var_31d860d9 = player function_a34653da(loadout_secondary_weapon);
	if(var_97f022b3 >= 3)
	{
		if(loadout_primary_weapon === weapon && var_2d9746d0 >= 3)
		{
			player function_fd9fb79b(#"hash_1ed264699cc951b");
		}
		else if(loadout_secondary_weapon === weapon && var_31d860d9 >= 3)
		{
			player function_fd9fb79b(#"hash_264228bd931f8deb");
		}
	}
	if(var_97f022b3 >= 5)
	{
		if(loadout_primary_weapon === weapon && var_2d9746d0 >= 5)
		{
			player function_fd9fb79b(#"hash_d18e3651f508489");
		}
		else if(loadout_secondary_weapon === weapon && var_31d860d9 >= 5)
		{
			player function_fd9fb79b(#"hash_469703d9a67cf0dd");
		}
	}
}

/*
	Name: function_660b0026
	Namespace: contracts
	Checksum: 0x506CC28A
	Offset: 0xC10
	Size: 0x24
	Parameters: 0
	Flags: None
*/
function function_660b0026()
{
	self function_a54e2068(#"hash_674ddfad917fa524");
}

/*
	Name: function_fd9fb79b
	Namespace: contracts
	Checksum: 0x9A24EBF7
	Offset: 0xC40
	Size: 0x5C
	Parameters: 2
	Flags: None
*/
function function_fd9fb79b(var_38280f2f, delta = 1)
{
	if(self is_contract_active(var_38280f2f))
	{
		self function_902ef0de(var_38280f2f, delta);
	}
}

/*
	Name: function_902ef0de
	Namespace: contracts
	Checksum: 0x62CBF751
	Offset: 0xCA8
	Size: 0x3C4
	Parameters: 2
	Flags: Private
*/
function private function_902ef0de(var_38280f2f, delta)
{
	/#
		if(getdvarint(#"scr_contract_debug_multiplier", 0) > 0)
		{
			delta = delta * getdvarint(#"scr_contract_debug_multiplier", 1);
		}
	#/
	if(delta <= 0)
	{
		return;
	}
	target_value = self.pers[#"contracts"][var_38280f2f].target_value;
	old_progress = (isdefined(self.pers[#"contracts"][var_38280f2f].current_value) ? self.pers[#"contracts"][var_38280f2f].current_value : self.pers[#"contracts"][var_38280f2f].var_59cb904f);
	if(old_progress == target_value)
	{
		return;
	}
	new_progress = int(old_progress + delta);
	if(new_progress > target_value)
	{
		new_progress = target_value;
	}
	if(new_progress != old_progress)
	{
		self.pers[#"contracts"][var_38280f2f].current_value = new_progress;
		if(isdefined(level.var_90031a39[var_38280f2f]))
		{
			self luinotifyevent(#"hash_4b04b1cb4b3498d0", 2, level.var_90031a39[var_38280f2f], new_progress);
		}
	}
	if(old_progress < target_value && target_value <= new_progress)
	{
		var_9d12108c = (isdefined(self.timeplayed[self.team]) ? self.timeplayed[self.team] : 0);
		self.pers[#"contracts"][var_38280f2f].var_be5bf249 = (self stats::function_441050ca(#"time_played_total") - self.pers[#"hash_5651f00c6c1790a4"]) + var_9d12108c;
		if(isdefined(level.var_90031a39[var_38280f2f]))
		{
			self luinotifyevent(#"hash_1739c4bd5baf83bc", 1, level.var_90031a39[var_38280f2f]);
		}
	}
	/#
		if(getdvarint(#"scr_contract_debug", 0) > 0)
		{
			iprintln((((function_9e72a96(var_38280f2f) + "") + new_progress) + "") + target_value);
			if(old_progress < target_value && target_value <= new_progress)
			{
				iprintln(function_9e72a96(var_38280f2f) + "");
			}
		}
	#/
}

/*
	Name: function_90a854d2
	Namespace: contracts
	Checksum: 0x8D2383CA
	Offset: 0x1078
	Size: 0x1C2
	Parameters: 1
	Flags: None
*/
function function_90a854d2(slot)
{
	/#
		if(getdvarint(#"hash_657185da33fd5f8", 0) > 0)
		{
			var_38280f2f = #"hash_6a1133003efe7380";
			switch(slot)
			{
				case 0:
				{
					return {#hash_59cb904f:98, #target_value:100, #hash_416a1e35:10011, #hash_38280f2f:#"hash_2abfdc6b42b44644"};
				}
				case 1:
				{
					return {#hash_59cb904f:195, #target_value:200, #hash_416a1e35:10004, #hash_38280f2f:#"hash_2173bc0bfcbdf90f"};
				}
				case 2:
				{
					return {#hash_59cb904f:48, #target_value:50, #hash_416a1e35:10009, #hash_38280f2f:#"hash_250c2d8ef2261723"};
				}
				default:
				{
					break;
				}
			}
			return undefined;
		}
	#/
	return function_d17bcd3c(slot);
}

/*
	Name: function_a4c8ce2a
	Namespace: contracts
	Checksum: 0xC0004C0B
	Offset: 0x1248
	Size: 0x74
	Parameters: 1
	Flags: None
*/
function function_a4c8ce2a(data)
{
	if(!isdefined(data))
	{
		return;
	}
	player = data.player;
	if(!isplayer(player))
	{
		return;
	}
	player function_c5958b54();
	player function_78083139();
}

/*
	Name: contract_win
	Namespace: contracts
	Checksum: 0x4803F46D
	Offset: 0x12C8
	Size: 0x2C
	Parameters: 1
	Flags: None
*/
function contract_win(winner)
{
	winner function_fd9fb79b(#"hash_1832bdb2f1aba003");
}

/*
	Name: function_c5958b54
	Namespace: contracts
	Checksum: 0x69B05BCA
	Offset: 0x1300
	Size: 0x4BC
	Parameters: 0
	Flags: None
*/
function function_c5958b54()
{
	var_c421e6b = undefined;
	switch(level.var_12323003)
	{
		case "ball":
		case "hash_7e279a00003eea98":
		{
			var_c421e6b = #"hash_34477f0475c38164";
			break;
		}
		case "hash_2f6e1c35e35e3cfe":
		case "bounty":
		{
			var_c421e6b = #"hash_4985d4f734fdbfce";
			break;
		}
		case "clean":
		case "hash_75d2a641c68a5246":
		{
			var_c421e6b = #"hash_25c3abc9e09fbf61";
			break;
		}
		case "conf":
		case "hash_40e7fa1f82c9a9a9":
		{
			var_c421e6b = #"hash_2156d88add08f25f";
			break;
		}
		case "control":
		case "hash_1acc245ba0adf546":
		{
			var_c421e6b = #"hash_512615d6a9739dfa";
			break;
		}
		case "ctf":
		case "hash_7eee54ba2b077140":
		{
			var_c421e6b = #"hash_42b7ebc5926b0008";
			break;
		}
		case "dem":
		case "hash_69f97b66f80cb88b":
		{
			var_c421e6b = #"hash_36472e9b2de73d63";
			break;
		}
		case "dm":
		case "dm_hc":
		{
			var_c421e6b = #"hash_5dbf89f59ac323e3";
			break;
		}
		case "hash_2b1e0466676a9e7d":
		case "dom":
		{
			var_c421e6b = #"hash_33860b3e1663bea9";
			break;
		}
		case "escort":
		case "hash_6999ad920e0c2033":
		{
			var_c421e6b = #"hash_38fb96360f792879";
			break;
		}
		case "hash_2c9bf6486c8d5123":
		case "gun":
		{
			var_c421e6b = #"hash_f916a0b9718fb8";
			break;
		}
		case "hash_36ec512a45b61e1c":
		case "infect":
		{
			var_c421e6b = #"hash_53542c30ea90ca02";
			break;
		}
		case "koth":
		case "hash_4d813729d9a4bebd":
		{
			var_c421e6b = #"hash_7e50b569c6374446";
			break;
		}
		case "prop":
		case "hash_5fa2c7e9d9b8185c":
		{
			var_c421e6b = #"hash_6b23bf478e392be0";
			break;
		}
		case "sas":
		case "hash_2f2a3faa406faca6":
		{
			var_c421e6b = #"hash_4bba29532de87a59";
			break;
		}
		case "sd":
		case "hash_7a9ce625ed68488a":
		{
			var_c421e6b = #"hash_67b25dee32314d8d";
			break;
		}
		case "hash_26793195d075d72":
		case "hash_73c82b5838fb050a":
		{
			var_c421e6b = #"hash_1d7bdd403c90dda6";
			break;
		}
		case "tdm":
		{
			var_c421e6b = #"hash_598fa84b33596a56";
			break;
		}
		case "hash_2ad10ed6e94a349c":
		{
			var_c421e6b = #"hash_d55e7fc2ab89041";
			break;
		}
		default:
		{
			break;
		}
	}
	if(isdefined(var_c421e6b))
	{
		self function_fd9fb79b(var_c421e6b);
		self function_fd9fb79b(#"hash_20583033219fa6aa");
	}
	if(globallogic_utils::function_308e3379())
	{
		self function_fd9fb79b(#"hash_1ffdd36f8bcda97d");
	}
}

/*
	Name: on_headshot_kill
	Namespace: contracts
	Checksum: 0xDA9CE855
	Offset: 0x17C8
	Size: 0x54
	Parameters: 0
	Flags: None
*/
function on_headshot_kill()
{
	if(level.hardcoremode)
	{
		self function_fd9fb79b(#"hash_1246b2a33b8739f4");
	}
	self function_fd9fb79b(#"hash_2abfdc6b42b44644");
}

/*
	Name: function_a0045e6a
	Namespace: contracts
	Checksum: 0x2253CFFE
	Offset: 0x1828
	Size: 0x24
	Parameters: 0
	Flags: None
*/
function function_a0045e6a()
{
	self function_fd9fb79b(#"hash_5903b7c9559be1e");
}

/*
	Name: function_8af6a5a
	Namespace: contracts
	Checksum: 0xAFF4C9A2
	Offset: 0x1858
	Size: 0x24
	Parameters: 0
	Flags: None
*/
function function_8af6a5a()
{
	self function_fd9fb79b(#"hash_31951837e7c9b9ef");
}

/*
	Name: devgui_setup
	Namespace: contracts
	Checksum: 0xDC71994C
	Offset: 0x1888
	Size: 0xE4
	Parameters: 0
	Flags: None
*/
function devgui_setup()
{
	/#
		var_74757534 = "";
		wait(3);
		function_e07e542b(var_74757534, undefined);
		function_17a92a99(var_74757534);
		function_b308be00(var_74757534);
		function_b8984e1a(var_74757534);
		function_1379e87e(var_74757534);
		function_50a60581(var_74757534);
		function_ef925b75(var_74757534);
		function_d1de9a1b(var_74757534);
	#/
}

/*
	Name: function_17a92a99
	Namespace: contracts
	Checksum: 0x6DB755DE
	Offset: 0x1978
	Size: 0x35C
	Parameters: 1
	Flags: None
*/
function function_17a92a99(var_1d89ece6)
{
	/#
		var_78a6fb52 = var_1d89ece6 + "";
		var_c8d599b5 = "";
		util::function_3f749abc(var_78a6fb52 + "", var_c8d599b5 + "");
		util::function_3f749abc(var_78a6fb52 + "", var_c8d599b5 + "");
		util::function_3f749abc(var_78a6fb52 + "", var_c8d599b5 + "");
		util::function_3f749abc(var_78a6fb52 + "", var_c8d599b5 + "");
		util::function_3f749abc(var_78a6fb52 + "", var_c8d599b5 + "");
		util::function_3f749abc(var_78a6fb52 + "", var_c8d599b5 + "");
		util::function_3f749abc(var_78a6fb52 + "", var_c8d599b5 + "");
		util::function_3f749abc(var_78a6fb52 + "", var_c8d599b5 + "");
		util::function_3f749abc(var_78a6fb52 + "", var_c8d599b5 + "");
		util::function_3f749abc(var_78a6fb52 + "", var_c8d599b5 + "");
		util::function_3f749abc(var_78a6fb52 + "", var_c8d599b5 + "");
		util::function_3f749abc(var_78a6fb52 + "", var_c8d599b5 + "");
		util::function_3f749abc(var_78a6fb52 + "", var_c8d599b5 + "");
		util::function_3f749abc(var_78a6fb52 + "", var_c8d599b5 + "");
		util::function_3f749abc(var_78a6fb52 + "", var_c8d599b5 + "");
		util::function_3f749abc(var_78a6fb52 + "", var_c8d599b5 + "");
		util::function_3f749abc(var_78a6fb52 + "", var_c8d599b5 + "");
		util::function_3f749abc(var_78a6fb52 + "", var_c8d599b5 + "");
		util::function_3f749abc(var_78a6fb52 + "", var_c8d599b5 + "");
		util::function_3f749abc(var_78a6fb52 + "", var_c8d599b5 + "");
	#/
}

/*
	Name: function_b308be00
	Namespace: contracts
	Checksum: 0xC76743CB
	Offset: 0x1CE0
	Size: 0x12C
	Parameters: 1
	Flags: None
*/
function function_b308be00(var_1d89ece6)
{
	/#
		var_78a6fb52 = var_1d89ece6 + "";
		var_c8d599b5 = "";
		util::function_3f749abc(var_78a6fb52 + "", var_c8d599b5 + "");
		util::function_3f749abc(var_78a6fb52 + "", var_c8d599b5 + "");
		util::function_3f749abc(var_78a6fb52 + "", var_c8d599b5 + "");
		util::function_3f749abc(var_78a6fb52 + "", var_c8d599b5 + "");
		util::function_3f749abc(var_78a6fb52 + "", var_c8d599b5 + "");
		util::function_3f749abc(var_78a6fb52 + "", var_c8d599b5 + "");
	#/
}

/*
	Name: function_b8984e1a
	Namespace: contracts
	Checksum: 0xB5E10A6D
	Offset: 0x1E18
	Size: 0x154
	Parameters: 1
	Flags: None
*/
function function_b8984e1a(var_1d89ece6)
{
	/#
		var_78a6fb52 = var_1d89ece6 + "";
		var_c8d599b5 = "";
		util::function_3f749abc(var_78a6fb52 + "", var_c8d599b5 + "");
		util::function_3f749abc(var_78a6fb52 + "", var_c8d599b5 + "");
		util::function_3f749abc(var_78a6fb52 + "", var_c8d599b5 + "");
		util::function_3f749abc(var_78a6fb52 + "", var_c8d599b5 + "");
		util::function_3f749abc(var_78a6fb52 + "", var_c8d599b5 + "");
		util::function_3f749abc(var_78a6fb52 + "", var_c8d599b5 + "");
		util::function_3f749abc(var_78a6fb52 + "", var_c8d599b5 + "");
	#/
}

/*
	Name: function_1379e87e
	Namespace: contracts
	Checksum: 0xB4F93D42
	Offset: 0x1F78
	Size: 0x104
	Parameters: 1
	Flags: None
*/
function function_1379e87e(var_1d89ece6)
{
	/#
		var_78a6fb52 = var_1d89ece6 + "";
		var_c8d599b5 = "";
		util::function_3f749abc(var_78a6fb52 + "", var_c8d599b5 + "");
		util::function_3f749abc(var_78a6fb52 + "", var_c8d599b5 + "");
		util::function_3f749abc(var_78a6fb52 + "", var_c8d599b5 + "");
		util::function_3f749abc(var_78a6fb52 + "", var_c8d599b5 + "");
		util::function_3f749abc(var_78a6fb52 + "", var_c8d599b5 + "");
	#/
}

/*
	Name: function_50a60581
	Namespace: contracts
	Checksum: 0x451A070D
	Offset: 0x2088
	Size: 0x36C
	Parameters: 1
	Flags: None
*/
function function_50a60581(var_1d89ece6)
{
	/#
		var_78a6fb52 = var_1d89ece6 + "";
		var_c8d599b5 = "";
		util::function_3f749abc(var_78a6fb52 + "", var_c8d599b5 + #"hash_1832bdb2f1aba003");
		util::function_3f749abc(var_78a6fb52 + "", var_c8d599b5 + #"hash_34477f0475c38164");
		util::function_3f749abc(var_78a6fb52 + "", var_c8d599b5 + #"hash_4985d4f734fdbfce");
		util::function_3f749abc(var_78a6fb52 + "", var_c8d599b5 + #"hash_2156d88add08f25f");
		util::function_3f749abc(var_78a6fb52 + "", var_c8d599b5 + #"hash_42b7ebc5926b0008");
		util::function_3f749abc(var_78a6fb52 + "", var_c8d599b5 + #"hash_36472e9b2de73d63");
		util::function_3f749abc(var_78a6fb52 + "", var_c8d599b5 + #"hash_5dbf89f59ac323e3");
		util::function_3f749abc(var_78a6fb52 + "", var_c8d599b5 + #"hash_33860b3e1663bea9");
		util::function_3f749abc(var_78a6fb52 + "", var_c8d599b5 + #"hash_38fb96360f792879");
		util::function_3f749abc(var_78a6fb52 + "", var_c8d599b5 + #"hash_f916a0b9718fb8");
		util::function_3f749abc(var_78a6fb52 + "", var_c8d599b5 + #"hash_5ddd56ee74eede05");
		util::function_3f749abc(var_78a6fb52 + "", var_c8d599b5 + #"hash_7e50b569c6374446");
		util::function_3f749abc(var_78a6fb52 + "", var_c8d599b5 + #"hash_6b23bf478e392be0");
		util::function_3f749abc(var_78a6fb52 + "", var_c8d599b5 + #"hash_4bba29532de87a59");
		util::function_3f749abc(var_78a6fb52 + "", var_c8d599b5 + #"hash_67b25dee32314d8d");
		util::function_3f749abc(var_78a6fb52 + "", var_c8d599b5 + #"hash_598fa84b33596a56");
		util::function_3f749abc(var_78a6fb52 + "", var_c8d599b5 + #"hash_d55e7fc2ab89041");
	#/
}

/*
	Name: function_ef925b75
	Namespace: contracts
	Checksum: 0x6834BE4F
	Offset: 0x2400
	Size: 0xB4
	Parameters: 1
	Flags: None
*/
function function_ef925b75(var_1d89ece6)
{
	/#
		var_78a6fb52 = var_1d89ece6 + "";
		var_c8d599b5 = "";
		util::function_3f749abc(var_78a6fb52 + "", var_c8d599b5 + "");
		util::function_3f749abc(var_78a6fb52 + "", var_c8d599b5 + "");
		util::function_3f749abc(var_78a6fb52 + "", var_c8d599b5 + "");
	#/
}

/*
	Name: function_d1de9a1b
	Namespace: contracts
	Checksum: 0x43A8425F
	Offset: 0x24C0
	Size: 0xDC
	Parameters: 1
	Flags: None
*/
function function_d1de9a1b(var_1d89ece6)
{
	/#
		var_78a6fb52 = var_1d89ece6 + "";
		var_c8d599b5 = "";
		util::function_3f749abc(var_78a6fb52 + "", var_c8d599b5 + "");
		util::function_3f749abc(var_78a6fb52 + "", var_c8d599b5 + "");
		util::function_3f749abc(var_78a6fb52 + "", var_c8d599b5 + "");
		util::function_3f749abc(var_78a6fb52 + "", var_c8d599b5 + "");
	#/
}

