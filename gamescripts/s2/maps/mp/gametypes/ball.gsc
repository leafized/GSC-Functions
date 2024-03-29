/*******************************************************************
 * Decompiled By: AgreedBog381
 * Decompiled File: ball.gsc
 * Game: Call of Duty: WWII
 * Platform: PC
 * Function Count: 96
 * Decompile Time: 4798 ms
 * Timestamp: 8/24/2021 10:23:29 PM
*******************************************************************/

//Function Id: 0x00F9
//Function Number: 1
func_00F9()
{
	if(getdvar("1673") == "mp_background")
	{
		return;
	}

	maps\mp\gametypes\_globallogic::func_00D5();
	lib_01DD::func_8A0C();
	maps\mp\gametypes\_globallogic::func_8A0C();
	if(isusingmatchrulesdata())
	{
		level.var_5300 = ::func_5300;
		[[ level.var_5300 ]]();
		level thread maps\mp\_utility::func_7C13();
	}
	else
	{
		maps\mp\_utility::func_7BF8(level.var_3FDC,0,0,9);
		maps\mp\_utility::func_7BFA(level.var_3FDC,10);
		maps\mp\_utility::func_7BF9(level.var_3FDC,50);
		maps\mp\_utility::func_7BF7(level.var_3FDC,1);
		maps\mp\_utility::func_7C04(level.var_3FDC,1);
		maps\mp\_utility::func_7BF1(level.var_3FDC,0);
		maps\mp\_utility::func_7BE5(level.var_3FDC,1);
		setdynamicdvar("scr_ball_num_balls",1);
		level.var_6031 = 0;
		level.var_6035 = 0;
	}

	var_00 = getdvarint("scr_ball_num_balls",1);
	setomnvar("ui_uplink_num_balls",var_00);
	maps\mp\_utility::func_86EB(3);
	if(isdefined(game["round_time_to_beat"]))
	{
		maps\mp\_utility::func_86EB(game["round_time_to_beat"]);
		game["round_time_to_beat"] = undefined;
	}

	maps\mp\_utility::func_873B(1);
	level.var_6B42 = ::func_6B42;
	level.var_6BB6 = ::func_6BB6;
	level.var_4959 = 1;
	level.var_6CD1 = 1;
	level.var_6BAF = ::func_6BAF;
	level.var_6B5C = ::func_6B5C;
	level.var_3FC9 = ::func_6BBC;
	if(level.var_6031 || level.var_6035)
	{
		level.var_62AD = ::maps\mp\gametypes\_damage::func_3FC8;
	}

	game["dialog"]["drone_reset"] = "upl_dronereset";
	game["dialog"]["you_own_drone"] = "upl_allyowndrone";
	game["dialog"]["ally_own_drone"] = "upl_friend_holds";
	game["dialog"]["enemy_own_drone"] = "upl_enemyowndrone";
	game["dialog"]["ally_throw_score"] = "upl_uplinksuccess";
	game["dialog"]["ally_carry_score"] = "upl_dronedelievered";
	game["dialog"]["enemy_throw_score"] = "upl_enm_score_remote";
	game["dialog"]["enemy_carry_score"] = "upl_enm_score";
	game["dialog"]["pass_complete"] = "upl_dronetransfered";
	game["dialog"]["pass_intercepted"] = "upl_droneintercepted";
	game["dialog"]["ally_drop_drone"] = "upl_dronedropped";
	game["dialog"]["enemy_drop_drone"] = "upl_dronedropped";
	game["dialog"]["gametype"] = "upl_intro";
	if(getdvarint("2043"))
	{
		game["dialog"]["gametype"] = "hc_" + game["dialog"]["gametype"];
	}

	game["dialog"]["offense_obj"] = "upl_deliverdrone";
	game["dialog"]["defense_obj"] = "upl_deliverdrone";
	if(maps\mp\_utility::func_5705())
	{
		game["dialog"]["gametype"] = "grap_" + game["dialog"]["gametype"];
	}

	level thread func_1534();
}

//Function Id: 0x5300
//Function Number: 2
func_5300()
{
	maps\mp\_utility::func_8653();
	setdynamicdvar("scr_ball_roundswitch",0);
	maps\mp\_utility::func_7BF8("ball",0,0,9);
	setdynamicdvar("scr_ball_roundlimit",2);
	maps\mp\_utility::func_7BF7("ball",1);
	setdynamicdvar("scr_ball_winlimit",1);
	maps\mp\_utility::func_7C04("ball",1);
	setdynamicdvar("scr_ball_halftime",1);
	maps\mp\_utility::func_7BE5("ball",1);
	var_00 = getmatchrulesdata("ballData","numBalls");
	var_00 = max(1,var_00);
	setdynamicdvar("scr_ball_num_balls",var_00);
	setdynamicdvar("scr_ball_reset_time",getmatchrulesdata("ballData","ballResetTime"));
	setdynamicdvar("scr_ball_points_touchdown",getmatchrulesdata("ballData","carryScore"));
	setdynamicdvar("scr_ball_points_fieldgoal",getmatchrulesdata("ballData","throwScore"));
	setdynamicdvar("scr_ball_armor",getmatchrulesdata("ballData","armorValue"));
}

//Function Id: 0x6BAF
//Function Number: 3
func_6BAF()
{
	setclientnamemode("auto_change");
	if(game["status"] == "halftime")
	{
		setomnvar("ui_current_round",2);
	}
	else if(game["status"] == "overtime")
	{
		setomnvar("ui_current_round",3);
	}
	else if(game["status"] == "overtime_halftime")
	{
		setomnvar("ui_current_round",4);
	}

	if(!isdefined(game["switchedsides"]))
	{
		game["switchedsides"] = 0;
	}

	if(maps\mp\_utility::func_576C(game["status"]))
	{
		game["switchedsides"] = !game["switchedsides"];
	}

	if(game["switchedsides"])
	{
		var_00 = game["attackers"];
		var_01 = game["defenders"];
		game["attackers"] = var_01;
		game["defenders"] = var_00;
	}

	if(game["status"] == "overtime")
	{
		game["teamScores"]["allies"] = 0;
		setteamscore("allies",0);
		game["teamScores"]["axis"] = 0;
		setteamscore("axis",0);
	}

	maps\mp\_utility::func_86DC("allies",&"OBJECTIVES_BALL");
	maps\mp\_utility::func_86DC("axis",&"OBJECTIVES_BALL");
	if(level.var_910F)
	{
		maps\mp\_utility::func_86DB("allies",&"OBJECTIVES_BALL");
		maps\mp\_utility::func_86DB("axis",&"OBJECTIVES_BALL");
	}
	else
	{
		maps\mp\_utility::func_86DB("allies",&"OBJECTIVES_BALL_SCORE");
		maps\mp\_utility::func_86DB("axis",&"OBJECTIVES_BALL_SCORE");
	}

	maps\mp\_utility::func_86D8("allies",&"OBJECTIVES_BALL_HINT");
	maps\mp\_utility::func_86D8("axis",&"OBJECTIVES_BALL_HINT");
	level.iconalliesgoal = "waypoint_caster_friendly_goal";
	level.iconaxisgoal = "waypoint_caster_enemy_goal";
	level.iconneutralball = "waypoint_caster_neutral_ball";
	level.iconheldball = "waypoint_caster_held_ball";
	func_151C();
	var_02[0] = level.var_3FDC;
	var_02[1] = "blocker_ball";
	maps\mp\gametypes\_gameobjects::func_00F9(var_02);
	level thread func_7F58();
	lib_050D::func_10E4();
}

//Function Id: 0x6B42
//Function Number: 4
func_6B42(param_00)
{
	foreach(var_02 in level.var_1562)
	{
		var_02.var_A582[0] method_84E0();
	}

	maps\mp\gametypes\_gamelogic::func_2BAE(param_00);
}

//Function Id: 0x6BB6
//Function Number: 5
func_6BB6()
{
	var_00 = undefined;
	level.var_3B5C = "none";
	foreach(var_02 in level.var_1562)
	{
		var_02.var_A582[0] method_84E0();
	}

	if(game["status"] == "halftime" || game["status"] == "overtime_halftime")
	{
		if(game["teamScores"]["axis"] > game["teamScores"]["allies"])
		{
			level.var_3B5C = "axis";
			var_00 = "axis";
		}
		else if(game["teamScores"]["allies"] > game["teamScores"]["axis"])
		{
			level.var_3B5C = "allies";
			var_00 = "allies";
		}
		else if(game["status"] == "halftime")
		{
			var_00 = "overtime";
		}
		else if(isdefined(game["ball_overtime_team"]))
		{
			var_00 = game["ball_overtime_team"];
		}
		else
		{
			var_00 = "tie";
		}
	}
	else if(game["status"] == "overtime")
	{
		var_00 = "overtime_halftime";
	}

	function_018D("time limit, win: " + var_00 + ", allies: " + game["teamScores"]["allies"] + ", opfor: " + game["teamScores"]["axis"]);
	level thread maps\mp\gametypes\_gamelogic::func_36B9(var_00,game["end_reason"]["time_limit_reached"]);
}

//Function Id: 0x6BBC
//Function Number: 6
func_6BBC(param_00)
{
	foreach(var_02 in level.var_1562)
	{
		if(isdefined(var_02.var_2006) && var_02.var_2006 == self)
		{
			self.var_A95F = maps\mp\gametypes\_gameobjects::func_466D(var_02);
			var_02 thread maps\mp\gametypes\_gameobjects::func_866E();
			return;
		}
	}

	if(self getcurrentweapon() == "iw5_carrydrone_mp" && isdefined(self.var_20CC))
	{
		self.var_A95F = self.var_20CC;
	}
	else if(isdefined(self.var_6EA7) && self.var_6EA7)
	{
		var_04 = self getweaponslistprimaries();
		self.var_A95F = common_scripts\utility::func_98E7(var_04.size,var_04[0],undefined);
	}

	self.var_1561 = undefined;
}

//Function Id: 0x6B5C
//Function Number: 7
func_6B5C(param_00,param_01,param_02)
{
	if(game["state"] == "postgame" && game["teamScores"][param_01.var_01A7] > game["teamScores"][level.var_6C63[param_01.var_01A7]])
	{
		param_01.var_3B4B = 1;
	}
}

//Function Id: 0x1518
//Function Number: 8
func_1518()
{
	for(;;)
	{
		level waittill("connected",var_00);
		var_00 thread func_154B();
		var_00 thread func_155A();
	}
}

//Function Id: 0x154B
//Function Number: 9
func_154B()
{
	foreach(var_01 in level.var_1562)
	{
		var_01 func_1523(self);
	}
}

//Function Id: 0x7F58
//Function Number: 10
func_7F58()
{
	level.var_1554 = [];
	level.var_1562 = [];
	var_00 = getdvarint("scr_ball_num_balls",1);
	func_1519(var_00);
	func_151B("allies");
	func_151B("axis");
	level.var_0611["ball_trail"] = loadfx("vfx/trail/vfx_uplink_ball_trl");
	level.var_0611["ball_download"] = loadfx("vfx/trail/vfx_uplink_ball_trl2");
	level.var_0611["ball_download_end"] = loadfx("vfx/unique/vfx_uplink_ball_impact");
	level.var_0611["ball_goal_allies_blue"] = loadfx("vfx/unique/gridiron_goal_allies_blue");
	level.var_0611["ball_goal_allies_red"] = loadfx("vfx/unique/gridiron_goal_allies_red");
	level.var_0611["ball_goal_axis_blue"] = loadfx("vfx/unique/gridiron_goal_axis_blue");
	level.var_0611["ball_goal_axis_red"] = loadfx("vfx/unique/gridiron_goal_axis_red");
	level.var_0611["ball_goal_activated_red"] = loadfx("vfx/unique/vfx_uplink_ball_score");
	level.var_0611["ball_goal_activated_green"] = loadfx("vfx/unique/vfx_uplink_ball_score");
	level.var_0611["ball_goal_activated_blue"] = loadfx("vfx/unique/vfx_uplink_ball_score_friendly");
	level.var_0611["ball_goal_activated_orange"] = loadfx("vfx/unique/vfx_uplink_ball_score_friendly");
	level.var_0611["ball_goal_activated_yellow"] = loadfx("vfx/unique/vfx_uplink_ball_score");
	level.var_0611["ball_teleport"] = loadfx("vfx/unique/vfx_uplink_ball_glow");
	level.var_0611["ball_physics_impact"] = loadfx("vfx/treadfx/footstep_dust");
	level thread func_1518();
	func_152E();
	for(var_01 = 0;var_01 < var_00 && var_01 < level.var_1554.size;var_01++)
	{
		func_1552(var_01);
	}

	func_152A();
	func_1528();
	maps\mp\_utility::func_3FA5("prematch_done");
	lib_050D::func_908D(level.var_152B["allies"],level.var_152B["axis"]);
}

//Function Id: 0x151C
//Function Number: 11
func_151C()
{
	level.var_2B9D = [];
	var_00 = getentarray("flag_primary","targetname");
	foreach(var_02 in var_00)
	{
		switch(var_02.var_81E8)
		{
			case "_a":
				level.var_2B9D[game["attackers"]] = var_02.var_0116;
				break;

			case "_b":
				level.var_2B93 = var_02.var_0116;
				break;

			case "_c":
				level.var_2B9D[game["defenders"]] = var_02.var_0116;
				break;
		}
	}
}

//Function Id: 0x152E
//Function Number: 12
func_152E()
{
	level.var_1532 = (1000,1000,1000);
	level.var_1531 = (-1000,-1000,-1000);
	var_00 = getallnodes();
	if(var_00.size > 0)
	{
		foreach(var_02 in var_00)
		{
			level.var_1532 = lib_050D::func_3915(level.var_1532,var_02.var_0116);
			level.var_1531 = lib_050D::func_3914(level.var_1531,var_02.var_0116);
		}

		return;
	}

	level.var_1532 = level.var_907A;
	level.var_1531 = level.var_9077;
}

//Function Id: 0x152A
//Function Number: 13
func_152A()
{
	foreach(var_02, var_01 in level.var_152B)
	{
		var_01.var_9D65 = spawn("trigger_radius",var_01.var_0116 - (0,0,var_01.var_014F),0,var_01.var_014F,var_01.var_014F * 2);
		var_01.var_A223 = maps\mp\gametypes\_gameobjects::func_2837(var_02,var_01.var_9D65,[],(0,0,var_01.var_014F * 2.1));
		var_01.var_A223.var_4800 = var_01;
		var_01.var_A223 maps\mp\gametypes\_gameobjects::func_860A("friendly","waypoint_ball_defend");
		var_01.var_A223 maps\mp\gametypes\_gameobjects::func_860A("enemy","waypoint_ball_goal");
		var_01.var_A223 maps\mp\gametypes\_gameobjects::func_860E("friendly","waypoint_ball_defend");
		var_01.var_A223 maps\mp\gametypes\_gameobjects::func_860E("enemy","waypoint_ball_goal");
		if(var_02 == "allies")
		{
			maps\mp\_utility::func_863F(var_01.var_A223,level.iconalliesgoal,2);
		}
		else
		{
			maps\mp\_utility::func_863F(var_01.var_A223,level.iconaxisgoal,1);
		}

		var_01.var_A223 maps\mp\gametypes\_gameobjects::func_8A60("any");
		var_01.var_A223 maps\mp\gametypes\_gameobjects::func_0C30("enemy");
		var_01.var_A223 maps\mp\gametypes\_gameobjects::func_86B5(level.var_1562);
		var_01.var_A223 maps\mp\gametypes\_gameobjects::func_8A5A(0);
		var_01.var_A223.var_6BBF = ::func_1513;
		var_01.var_A223.var_1F84 = ::func_1527;
		var_01 thread func_8A29();
	}
}

//Function Id: 0x8A29
//Function Number: 14
func_8A29()
{
	var_00 = spawn("script_origin",self.var_0116);
	var_00.var_001D = self.var_001D;
	var_00 rotateyaw(-45,0.05);
	wait 0.05;
	var_01 = self.var_0116 + (0,0,5);
	var_02 = self.var_0116 + anglestoforward(var_00.var_001D) * 100 + (0,0,128);
	var_03 = bullettrace(var_01,var_02,0,self);
	var_04 = var_03["position"];
	if(var_03["fraction"] < 1)
	{
		var_04 = var_04 + var_03["normal"] * 5;
	}

	self.var_5A2C = spawn("script_model",var_04);
	self.var_5A2C setscriptmoverkillcam("explosive");
	var_00 delete();
}

//Function Id: 0x1528
//Function Number: 15
func_1528()
{
	foreach(var_02, var_01 in level.var_152B)
	{
		var_01.var_80A4["friendly"] = spawnfx(common_scripts\utility::func_44F5("ball_goal_activated_blue"),var_01.var_0116,(1,0,0));
		var_01.var_80A4["enemy"] = spawnfx(common_scripts\utility::func_44F5("ball_goal_activated_red"),var_01.var_0116,(1,0,0));
		if(var_02 == "allies")
		{
			var_01.var_80A4["broadcaster"] = spawnfx(common_scripts\utility::func_44F5("ball_goal_activated_orange"),var_01.var_0116,(1,0,0));
			continue;
		}

		var_01.var_80A4["broadcaster"] = spawnfx(common_scripts\utility::func_44F5("ball_goal_activated_yellow"),var_01.var_0116,(1,0,0));
	}

	level thread func_1548();
	foreach(var_04 in level.var_744A)
	{
		func_1529(var_04);
	}
}

//Function Id: 0x1552
//Function Number: 16
func_1552(param_00)
{
	var_01 = level.var_1554[param_00];
	var_02 = spawn("script_model",var_01.var_0116);
	var_02 setmodel("npc_soccer_ball_01");
	var_02 notsolid();
	var_02 thread func_6FA2();
	var_03 = 24;
	var_04 = getent("ball_pickup_" + param_00 + 1,"targetname");
	if(isdefined(var_04))
	{
		var_04.var_0116 = var_02.var_0116;
	}
	else
	{
		var_04 = spawn("trigger_radius",var_02.var_0116 - (0,0,var_03 / 2),0,var_03,var_03);
	}

	var_04 enablelinkto();
	var_04 linkto(var_02);
	var_04.var_66F0 = 1;
	var_05 = [var_02];
	var_06 = maps\mp\gametypes\_gameobjects::func_27D6("any",var_04,var_05,(0,0,32),1,0,1);
	var_06.var_695F = 1;
	var_06 maps\mp\gametypes\_gameobjects::func_0C1D("any");
	var_06 func_155D();
	var_06 maps\mp\gametypes\_gameobjects::func_8A60("any");
	var_06.var_698F = 1;
	var_06.var_6993 = 1;
	var_06.var_0C33 = 0;
	var_06.var_201C = "iw5_carrydrone_mp";
	var_06.var_59D8 = 1;
	var_06.var_A965 = 0;
	var_06.var_A581 = (0,0,30);
	var_06.var_1F84 = ::func_150E;
	var_06.var_6B62 = ::func_1535;
	var_06.var_866E = ::func_1550;
	var_06.var_6B93 = ::func_1538;
	var_06.var_201D = ::func_153A;
	var_06.var_50CB = 0;
	var_06.var_5B7F = 0;
	var_06.var_7D25 = 1;
	var_06 func_150A(var_01);
	level.var_1562[level.var_1562.size] = var_06;
	var_06 func_1522();
	var_06 thread func_1530(param_00);
	setomnvar("ui_broadcaster_game_mode_status_1",-1);
	setomnvar("ui_broadcaster_game_mode_status_2",-1);
	setomnvar("ui_broadcaster_game_mode_status_3",3);
}

//Function Id: 0x6FA2
//Function Number: 17
func_6FA2()
{
	self endon("death");
	for(;;)
	{
		self waittill("physics_impact",var_00,var_01,var_02,var_03);
		var_04 = level.var_0611["ball_physics_impact"];
		if(isdefined(var_03) && isdefined(level.var_0611["ball_physics_impact_" + var_03]))
		{
			var_04 = level.var_0611["ball_physics_impact_" + var_03];
		}

		playfx(var_04,var_00,var_01);
		var_05 = vectordot(var_02,var_01);
		if(var_05 > 0.5)
		{
			self method_8617("grid_ball_bounce");
		}

		wait(0.3);
	}
}

//Function Id: 0x1530
//Function Number: 18
func_1530(param_00)
{
	if(param_00 > 4 || param_00 < 0)
	{
		return;
	}

	for(;;)
	{
		var_01 = common_scripts\utility::func_A715("pickup_object","dropped","reset");
		switch(var_01)
		{
			case "pickup_object":
				setomnvar("ui_uplink_ball_carrier" + param_00 + 1,self.var_2006 getentitynumber());
				break;
	
			case "dropped":
				setomnvar("ui_uplink_ball_carrier" + param_00 + 1,-2);
				break;
	
			case "reset":
				setomnvar("ui_uplink_ball_carrier" + param_00 + 1,-1);
				break;
	
			default:
				break;
		}
	}
}

//Function Id: 0x155D
//Function Number: 19
func_155D()
{
	maps\mp\gametypes\_gameobjects::func_860A("friendly","waypoint_ball");
	maps\mp\gametypes\_gameobjects::func_860A("enemy","waypoint_ball");
	maps\mp\gametypes\_gameobjects::func_860E("friendly","waypoint_ball");
	maps\mp\gametypes\_gameobjects::func_860E("enemy","waypoint_ball");
	maps\mp\_utility::func_863F(self,level.iconneutralball,3);
}

//Function Id: 0x155C
//Function Number: 20
func_155C()
{
	maps\mp\gametypes\_gameobjects::func_860A("friendly","waypoint_ball_friendly");
	maps\mp\gametypes\_gameobjects::func_860A("enemy","waypoint_ball_enemy");
	maps\mp\gametypes\_gameobjects::func_860E("friendly","waypoint_ball_friendly");
	maps\mp\gametypes\_gameobjects::func_860E("enemy","waypoint_ball_enemy");
	if(self.var_6DB2 == "allies")
	{
		maps\mp\_utility::func_863F(self,level.iconheldball,2);
		return;
	}

	maps\mp\_utility::func_863F(self,level.iconheldball,1);
}

//Function Id: 0x155B
//Function Number: 21
func_155B()
{
	maps\mp\gametypes\_gameobjects::func_860A("friendly","waypoint_ball");
	maps\mp\gametypes\_gameobjects::func_860A("enemy","waypoint_ball");
	maps\mp\gametypes\_gameobjects::func_860E("friendly","waypoint_ball");
	maps\mp\gametypes\_gameobjects::func_860E("enemy","waypoint_ball");
	maps\mp\_utility::func_863F(self,level.iconneutralball,3);
}

//Function Id: 0x155E
//Function Number: 22
func_155E()
{
	maps\mp\gametypes\_gameobjects::func_860A("friendly","waypoint_ball");
	maps\mp\gametypes\_gameobjects::func_860A("enemy","waypoint_ball");
	maps\mp\gametypes\_gameobjects::func_860E("friendly","waypoint_ball");
	maps\mp\gametypes\_gameobjects::func_860E("enemy","waypoint_ball");
	maps\mp\_utility::func_863F(self,level.iconneutralball,3);
}

//Function Id: 0x151D
//Function Number: 23
func_151D()
{
	self.var_A582[0] method_808C();
	self.var_1521 = 0;
}

//Function Id: 0x1522
//Function Number: 24
func_1522()
{
	if(!func_1521())
	{
		var_00 = self.var_A582[0];
		playfxontag(common_scripts\utility::func_44F5("ball_trail"),var_00,"tag_weapon");
		self.var_1521 = 1;
	}
}

//Function Id: 0x1523
//Function Number: 25
func_1523(param_00)
{
	if(func_1521())
	{
		var_01 = self.var_A582[0];
		playfxontagforclients(common_scripts\utility::func_44F5("ball_trail"),var_01,"tag_weapon",param_00);
	}
}

//Function Id: 0x1524
//Function Number: 26
func_1524()
{
	if(func_1521())
	{
		var_00 = self.var_A582[0];
		stopfxontag(common_scripts\utility::func_44F5("ball_trail"),var_00,"tag_weapon");
	}

	self.var_1521 = 0;
}

//Function Id: 0x1521
//Function Number: 27
func_1521()
{
	return isdefined(self.var_1521) && self.var_1521;
}

//Function Id: 0x153A
//Function Number: 28
func_153A()
{
	self endon("disconnect");
	thread func_153E();
	thread func_1551();
	self.var_2016 waittill("dropped");
}

//Function Id: 0x153E
//Function Number: 29
func_153E()
{
	level endon("game_ended");
	self endon("disconnect");
	self endon("death");
	self endon("drop_object");
	for(;;)
	{
		self waittill("ball_pass",var_00);
		if(var_00 != "iw5_carrydrone_mp")
		{
			continue;
		}

		if(!isdefined(self.var_6EA9))
		{
			self iclientprintlnbold("No Pass Target");
			continue;
		}

		break;
	}

	if(isdefined(self.var_2016))
	{
		thread func_153B();
		var_01 = self.var_6EA9;
		var_02 = self.var_6EA9.var_0116;
		wait(0.15);
		if(isdefined(self.var_6EA9))
		{
			var_01 = self.var_6EA9;
		}

		self.var_2016 thread func_153C(self,var_01,var_02);
	}
}

//Function Id: 0x153C
//Function Number: 30
func_153C(param_00,param_01,param_02)
{
	func_1550(1);
	if(isdefined(param_01))
	{
		param_02 = param_01.var_0116;
	}

	var_03 = (0,0,40);
	var_04 = vectornormalize(param_02 + var_03 - self.var_A582[0].var_0116);
	var_05 = var_04 * 1000;
	self.var_776C = magicgrenademanual("gamemode_ball",self.var_A582[0].var_0116,var_05,30,param_00,1,1);
	if(isdefined(param_01))
	{
		self.var_776C method_81D9(param_01);
	}

	self.var_A582[0] linkto(self.var_776C);
	func_151D();
	func_151A();
	func_1517();
	thread func_1537();
	thread func_1536();
	thread func_153D();
}

//Function Id: 0x151A
//Function Number: 31
func_151A()
{
	if(isdefined(self.var_5A2C))
	{
		self.var_5A2C delete();
	}

	self.var_5A2C = spawn("script_model",self.var_A582[0].var_0116);
	self.var_5A2C linkto(self.var_A582[0]);
	self.var_5A2C method_80B1();
	self.var_5A2C setscriptmoverkillcam("explosive");
}

//Function Id: 0x1517
//Function Number: 32
func_1517()
{
	self.var_A582[0].var_6A2D = self.var_A582[0] method_80B1();
}

//Function Id: 0x154C
//Function Number: 33
func_154C()
{
	if(isdefined(self.var_A582[0].var_6A2D))
	{
		self.var_A582[0] method_80B0(self.var_A582[0].var_6A2D);
		self.var_A582[0].var_6A2D = undefined;
	}
}

//Function Id: 0x1537
//Function Number: 34
func_1537()
{
	self endon("pass_end");
	self.var_776C waittill("projectile_impact_player",var_00);
	self.var_9D65 notify("trigger",var_00);
}

//Function Id: 0x1536
//Function Number: 35
func_1536()
{
	self.var_776C waittill("death");
	var_00 = self.var_A582[0];
	if(!isdefined(self.var_2006) && !self.var_50CB)
	{
		if(var_00.var_0116 != var_00.var_162D + (0,0,4000))
		{
			func_1542((0,0,10));
		}
	}

	func_154C();
	var_00 notify("pass_end");
}

//Function Id: 0x1551
//Function Number: 36
func_1551()
{
	level endon("game_ended");
	self endon("disconnect");
	self endon("death");
	self endon("drop_object");
	var_00 = getdvarfloat("scr_ball_shoot_extra_pitch",-4);
	var_01 = getdvarfloat("scr_ball_shoot_force",500);
	for(;;)
	{
		self waittill("weapon_fired",var_02);
		if(var_02 != "iw5_carrydrone_mp")
		{
			continue;
		}

		break;
	}

	if(isdefined(self.var_2016))
	{
		var_03 = self getangles();
		var_03 = var_03 + (var_00,0,0);
		var_03 = (clamp(var_03[0],-85,85),var_03[1],var_03[2]);
		var_04 = anglestoforward(var_03);
		thread func_153B();
		wait 0.05;
		self method_8617("grid_ball_throw");
		thread func_1515(self.var_2016);
		self.var_2016 func_151A();
		self.var_2016 thread func_1543(var_04 * var_01,self);
	}
}

//Function Id: 0x153B
//Function Number: 37
func_153B()
{
	self endon("death");
	self endon("disconnect");
	self.var_6EA7 = 1;
	self method_812A(0);
	while("iw5_carrydrone_mp" == self getcurrentweapon())
	{
		wait 0.05;
	}

	self method_812A(1);
	self.var_6EA7 = 0;
}

//Function Id: 0x1543
//Function Number: 38
func_1543(param_00,param_01)
{
	func_1550(1);
	func_1542(param_00,param_01);
}

//Function Id: 0x1542
//Function Number: 39
func_1542(param_00,param_01)
{
	var_02 = self.var_A582[0];
	var_02.var_6C43 = undefined;
	func_1522();
	level notify("broadcaster_throw_ball",self.var_5B7E,self,vectornormalize(param_00));
	var_02 physicslaunchserver(var_02.var_0116,param_00);
	thread func_1544();
	thread func_1545(param_01);
	thread func_1540();
	thread func_1547();
	thread func_1546(param_01);
}

//Function Id: 0x154D
//Function Number: 40
func_154D()
{
	self.var_50CB = 0;
	var_00 = self.var_A582[0];
	playsoundatpos(var_00.var_0116,"grid_ball_out_of_bounds");
	playfx(common_scripts\utility::func_44F5("ball_teleport"),var_00.var_0116);
	thread maps\mp\gametypes\_gameobjects::func_7E30();
}

//Function Id: 0x1544
//Function Number: 41
func_1544()
{
	self endon("reset");
	self endon("pickup_object");
	var_00 = self.var_A582[0];
	var_01[0] = 200;
	var_01[1] = 200;
	var_01[2] = 1000;
	var_02[0] = 200;
	var_02[1] = 200;
	var_02[2] = 200;
	for(;;)
	{
		for(var_03 = 0;var_03 < 2;var_03++)
		{
			if(var_00.var_0116[var_03] > level.var_1531[var_03] + var_01[var_03])
			{
				level notify("broadcaster_ball_end",var_00,1);
				func_154D();
				return;
			}

			if(var_00.var_0116[var_03] < level.var_1532[var_03] - var_02[var_03])
			{
				level notify("broadcaster_ball_end",var_00,1);
				func_154D();
				return;
			}
		}

		wait 0.05;
	}
}

//Function Id: 0x1545
//Function Number: 42
func_1545(param_00)
{
	self endon("reset");
	self endon("pickup_object");
	self endon("score_event");
	var_01 = getdvarfloat("scr_ball_reset_time",15);
	var_02 = 10;
	var_03 = 3;
	if(var_01 >= var_02)
	{
		setomnvar("ui_broadcaster_game_mode_status_1",var_03);
		setomnvar("ui_broadcaster_game_mode_status_2",-1);
		var_04 = getomnvar("ui_broadcaster_game_mode_status_3");
		if(!isdefined(param_00))
		{
			if(var_04 == 1 || var_04 == 4 || var_04 == 5)
			{
				setomnvar("ui_broadcaster_game_mode_status_3",5);
			}
			else
			{
				setomnvar("ui_broadcaster_game_mode_status_3",7);
			}
		}
		else if(var_04 == 1 || var_04 == 4 || var_04 == 5)
		{
			setomnvar("ui_broadcaster_game_mode_status_3",4);
		}
		else
		{
			setomnvar("ui_broadcaster_game_mode_status_3",6);
		}

		wait(var_03);
		var_01 = var_01 - var_03;
	}

	setomnvar("ui_broadcaster_game_mode_status_1",int(var_02));
	setomnvar("ui_broadcaster_game_mode_status_2",-1);
	setomnvar("ui_broadcaster_game_mode_status_3",0);
	if(var_02 > 4)
	{
		wait(4);
		level notify("broadcaster_ball_end",self.var_A582[0],1);
		wait(var_02 - 4);
	}
	else
	{
		wait(var_02);
		level notify("broadcaster_ball_end",self.var_A582[0],1);
	}

	func_154D();
}

//Function Id: 0x1540
//Function Number: 43
func_1540()
{
	self.var_A582[0] endon("physics_finished");
	thread func_153F();
	wait(0.1);
	for(;;)
	{
		if(maps\mp\gametypes\_gameobjects::func_5808())
		{
			level notify("broadcaster_ball_end",self.var_A582[0],1);
			func_154D();
			return;
		}

		wait 0.05;
	}
}

//Function Id: 0x153F
//Function Number: 44
func_153F()
{
	self endon("pickup_object");
	self endon("reset");
	self endon("score_event");
	var_00 = self.var_A582[0];
	var_00 endon("death");
	var_00 waittill("physics_finished");
	if(maps\mp\gametypes\_gameobjects::func_5808())
	{
		func_154D();
	}
}

//Function Id: 0x1547
//Function Number: 45
func_1547()
{
	var_00 = self.var_A582[0];
	var_00 endon("physics_finished");
	func_1558(var_00);
}

//Function Id: 0x1546
//Function Number: 46
func_1546(param_00)
{
	var_01 = self.var_A582[0];
	var_02 = self.var_9D65;
	var_01 endon("physics_finished");
	for(;;)
	{
		var_02 waittill("trigger",var_03);
		if(isdefined(param_00) && param_00 == var_03 && var_03 func_72F0())
		{
			continue;
		}

		if(self.var_34B1 >= gettime())
		{
			continue;
		}

		if(var_01.var_0116 == var_01.var_162D + (0,0,4000))
		{
			continue;
		}

		if(!func_150E(var_03))
		{
			thread func_1541();
		}
	}
}

//Function Id: 0x1541
//Function Number: 47
func_1541()
{
	var_00 = self.var_A582[0];
	if(!var_00 method_8524())
	{
		return;
	}

	var_01 = var_00 method_841B();
	var_02 = length(var_01) / 10;
	var_03 = -1 * vectornormalize(var_01);
	var_00 method_84E0();
	var_00 physicslaunchserver(var_00.var_0116,var_03 * var_02);
}

//Function Id: 0x153D
//Function Number: 48
func_153D()
{
	var_00 = self.var_A582[0];
	var_00 endon("pass_end");
	func_1558(var_00);
}

//Function Id: 0x1558
//Function Number: 49
func_1558(param_00)
{
	for(;;)
	{
		foreach(var_05, var_02 in level.var_152B)
		{
			if(self.var_5B80 == var_05)
			{
				continue;
			}

			if(!var_02.var_A223 func_1527())
			{
				continue;
			}

			var_03 = distance(param_00.var_0116,var_02.var_0116);
			if(var_03 <= var_02.var_014F)
			{
				level notify("broadcaster_ball_end",param_00,0);
				thread func_1559(var_02);
				return;
			}

			if(isdefined(param_00.var_6C43))
			{
				var_04 = func_5D90(param_00.var_6C43,param_00.var_0116,var_02.var_0116,var_02.var_014F);
				if(var_04)
				{
					level notify("broadcaster_ball_end",param_00,0);
					thread func_1559(var_02);
					return;
				}
			}
		}

		wait 0.05;
	}
}

//Function Id: 0x1527
//Function Number: 50
func_1527(param_00)
{
	var_01 = self.var_4800;
	if(var_01.var_152C)
	{
		return 0;
	}

	return 1;
}

//Function Id: 0x1513
//Function Number: 51
func_1513(param_00)
{
	var_01 = getdvarint("scr_ball_points_touchdown",2);
	if(!isdefined(param_00) || !isdefined(param_00.var_2016))
	{
		return;
	}

	if(isdefined(param_00.var_2016.var_80AA) && param_00.var_2016.var_80AA > gettime())
	{
		return;
	}

	param_00.var_2016.var_80AA = gettime() + 10000;
	param_00 maps\mp\_events::func_9ABB(var_01);
	func_1514(param_00,1);
	param_00 thread func_155A();
	var_02 = self.var_4800.var_01A7;
	var_03 = maps\mp\_utility::func_45DE(var_02);
	thread func_2CDB("enemy_throw_score",var_02,"status");
	thread func_2CDB("ally_throw_score",var_03,"status");
	if(func_8B6F(var_03,var_01))
	{
		var_04 = self.var_4800.var_5A2C;
		var_05 = var_04 getentitynumber();
		var_06 = var_04.var_002B;
		if(!isdefined(var_06))
		{
			var_06 = 0;
		}

		param_00.var_2AB8 = gettime();
		level.ball_final_killcam = 1;
		maps\mp\gametypes\_final_killcam::func_7B32(5,param_00,param_00,param_00 getentitynumber(),var_05,var_06,"none",0,0,undefined,"score");
	}

	func_154A(self.var_4800);
	func_154F(var_03);
	if(isdefined(param_00.var_8B11))
	{
		param_00.var_8B11.var_54F5 = 0;
	}

	var_07 = param_00.var_2016;
	var_07.var_5B7F = 1;
	var_07 func_1550(1);
	var_07 thread func_154E(self.var_4800);
	func_1526(var_03,var_01);
}

//Function Id: 0x155A
//Function Number: 52
func_155A()
{
	waittillframeend;
	var_00 = maps\mp\_utility::func_4628("fieldgoal");
	var_01 = maps\mp\_utility::func_4628("touchdown");
	var_02 = getdvarint("scr_ball_points_fieldgoal",1);
	var_03 = getdvarint("scr_ball_points_touchdown",2);
	maps\mp\_utility::func_867B(var_00 * var_02 + var_01 * var_03);
}

//Function Id: 0x8B6F
//Function Number: 53
func_8B6F(param_00,param_01)
{
	var_02 = maps\mp\gametypes\_gamescore::func_063E(param_00);
	var_03 = maps\mp\gametypes\_gamescore::func_063E(maps\mp\_utility::func_45DE(param_00));
	return var_02 + param_01 >= var_03;
}

//Function Id: 0x5D90
//Function Number: 54
func_5D90(param_00,param_01,param_02,param_03)
{
	var_04 = vectornormalize(param_01 - param_00);
	var_05 = vectordot(var_04,param_00 - param_02);
	var_05 = var_05 * var_05;
	var_06 = param_00 - param_02;
	var_06 = var_06 * var_06;
	var_07 = param_03 * param_03;
	return var_05 - var_06 + var_07 >= 0;
}

//Function Id: 0x1559
//Function Number: 55
func_1559(param_00)
{
	func_154A(param_00);
	var_01 = getdvarint("scr_ball_points_fieldgoal",1);
	if(isdefined(self.var_80AA) && self.var_80AA > gettime())
	{
		return;
	}

	self.var_80AA = gettime() + 10000;
	var_02 = param_00.var_01A7;
	var_03 = maps\mp\_utility::func_45DE(var_02);
	thread func_2CDB("enemy_throw_score",var_02,"status");
	thread func_2CDB("ally_throw_score",var_03,"status");
	if(isdefined(self.var_5B7E))
	{
		self.var_5B7F = 1;
		self.var_5B7E maps\mp\_events::func_3AA1(var_01);
		func_1514(self.var_5B7E,0);
		self.var_5B7E thread func_155A();
		if(isdefined(self.var_5A2C) && func_8B6F(var_03,var_01))
		{
			var_04 = self.var_5A2C;
			var_05 = var_04 getentitynumber();
			var_06 = var_04.var_002B;
			if(!isdefined(var_06))
			{
				var_06 = 0;
			}

			var_07 = self.var_5B7E;
			param_00.var_5A2C.var_2AB8 = gettime();
			level.ball_final_killcam = 1;
			maps\mp\gametypes\_final_killcam::func_7B32(5,param_00.var_5A2C,var_07,var_07 getentitynumber(),var_05,var_06,"none",0,0,undefined,"score");
		}
	}

	if(isdefined(self.var_5A2C))
	{
		self.var_5A2C unlink();
	}

	func_154F(var_03);
	thread func_154E(param_00);
	func_1526(var_03,var_01);
	setomnvar("ui_broadcaster_game_mode_status_1",-1);
	if(isdefined(self.var_5B7E))
	{
		setomnvar("ui_broadcaster_game_mode_status_2",self.var_5B7E getentitynumber());
	}
	else
	{
		setomnvar("ui_broadcaster_game_mode_status_2",-1);
	}

	if(var_03 == "allies")
	{
		setomnvar("ui_broadcaster_game_mode_status_3",1);
		return;
	}

	setomnvar("ui_broadcaster_game_mode_status_3",2);
}

//Function Id: 0x1526
//Function Number: 56
func_1526(param_00,param_01)
{
	level maps\mp\gametypes\_gamescore::func_47BD(param_00,param_01,1);
	if(game["status"] == "overtime")
	{
		game["ball_overtime_team"] = param_00;
		game["round_time_to_beat"] = maps\mp\_utility::func_4589();
		level thread maps\mp\gametypes\_gamelogic::func_36B9("overtime_halftime",game["end_reason"]["switching_sides"]);
		return;
	}

	if(game["status"] == "overtime_halftime")
	{
		var_02 = maps\mp\gametypes\_gamescore::func_063E(param_00);
		var_03 = maps\mp\gametypes\_gamescore::func_063E(maps\mp\_utility::func_45DE(param_00));
		if(var_02 >= var_03)
		{
			level thread maps\mp\gametypes\_gamelogic::func_36B9(param_00,game["end_reason"]["score_limit_reached"]);
			return;
		}
	}
}

//Function Id: 0x154E
//Function Number: 57
func_154E(param_00)
{
	self notify("score_event");
	self.var_50CB = 1;
	param_00.var_152C = 1;
	var_01 = self.var_A582[0];
	if(isdefined(self.var_776C))
	{
		self.var_776C delete();
	}

	var_01 method_84E0();
	maps\mp\gametypes\_gameobjects::func_0C1D("none");
	func_155E();
	var_02 = 0.4;
	var_03 = 1.2;
	var_04 = 1;
	playsoundatpos(param_00.var_0116,"grid_goal_scored");
	var_05 = var_02 + var_04;
	var_06 = var_05 + var_03;
	var_01 moveto(param_00.var_0116,var_02,0,var_02);
	var_01 rotatevelocity((1080,1080,0),var_06,var_06,0);
	wait(var_05);
	param_00.var_152C = 0;
	var_01 movez(4000,var_03,var_03 * 0.1,0);
	wait(var_03);
	maps\mp\gametypes\_gameobjects::func_0C1D("any");
	func_154D();
}

//Function Id: 0x1514
//Function Number: 58
func_1514(param_00,param_01)
{
	if(!isdefined(param_00.var_6EB4) || !isdefined(param_00.var_6EB3))
	{
		return;
	}

	if(param_00.var_6EB4 + 3000 < gettime())
	{
		return;
	}

	param_00.var_6EB3 maps\mp\_events::func_1563();
	if(param_01)
	{
		param_00 maps\mp\gametypes\_missions::func_7750("ch_ball_alleyoop");
	}
}

//Function Id: 0x154A
//Function Number: 59
func_154A(param_00)
{
	param_00.var_80A4["friendly"] method_805C();
	param_00.var_80A4["enemy"] method_805C();
	param_00.var_80A4["broadcaster"] method_805C();
	foreach(var_02 in level.var_744A)
	{
		var_03 = func_1525(var_02);
		if(var_03 == "broadcaster")
		{
			param_00.var_80A4["broadcaster"] showtoclient(var_02);
			continue;
		}

		if(var_03 == param_00.var_01A7)
		{
			param_00.var_80A4["friendly"] showtoclient(var_02);
			continue;
		}

		param_00.var_80A4["enemy"] showtoclient(var_02);
	}

	triggerfx(param_00.var_80A4["friendly"]);
	triggerfx(param_00.var_80A4["enemy"]);
	triggerfx(param_00.var_80A4["broadcaster"]);
}

//Function Id: 0x154F
//Function Number: 60
func_154F(param_00)
{
	func_1549(param_00,"mp_obj_notify_pos_sml","mp_obj_notify_neg_sml");
}

//Function Id: 0x1549
//Function Number: 61
func_1549(param_00,param_01,param_02)
{
	var_03 = maps\mp\_utility::func_45DE(param_00);
	foreach(var_05 in level.var_744A)
	{
		if(var_05.var_01A7 == param_00)
		{
			var_05 method_8615(param_01);
			continue;
		}

		if(var_05.var_01A7 == var_03)
		{
			var_05 method_8615(param_02);
		}
	}
}

//Function Id: 0x150E
//Function Number: 62
func_150E(param_00)
{
	if(param_00 playerisweaponplantenabled())
	{
		return 0;
	}

	if(!isdefined(param_00))
	{
		return 0;
	}

	if(isdefined(param_00.var_A019) && param_00.var_A019)
	{
		return 0;
	}

	if(isdefined(self.var_34B1) && self.var_34B1 >= gettime())
	{
		return 0;
	}

	if(!param_00 common_scripts\utility::func_5851())
	{
		return 0;
	}

	if(param_00 isusingturret())
	{
		return 0;
	}

	if(isdefined(param_00.var_5FDD) && param_00.var_5FDD)
	{
		return 0;
	}

	if(isdefined(param_00.var_A255) && param_00.var_A255)
	{
		return 0;
	}

	var_01 = param_00 getcurrentweapon();
	if(isdefined(var_01))
	{
		if(!func_A267(var_01))
		{
			return 0;
		}
	}

	var_02 = param_00.var_20CC;
	if(isdefined(var_02) && param_00 method_833B())
	{
		if(!func_A267(var_02))
		{
			return 0;
		}
	}

	if(isdefined(param_00.var_3905) && param_00.var_3905 == 1)
	{
		return 0;
	}

	if(param_00 func_72F0())
	{
		return 0;
	}

	return 1;
}

//Function Id: 0xA267
//Function Number: 63
func_A267(param_00)
{
	if(param_00 == "none")
	{
		return 0;
	}

	if(param_00 == "iw5_carrydrone_mp")
	{
		return 0;
	}

	if(maps\mp\_utility::func_5740(param_00) && param_00 != "flamethrower_mp" && param_00 != "flamethrower_german_mp" && param_00 != "flamethrower_grenadier_mp" && param_00 != "flamethrower_german_grenadier_mp" && param_00 != "killstreak_molotov_cocktail_mp" && param_00 != "killstreak_molotov_cocktail_grenadier_mp")
	{
		return 0;
	}

	return 1;
}

//Function Id: 0x72F0
//Function Number: 64
func_72F0()
{
	return isdefined(self.var_6735) && self.var_6735 > gettime();
}

//Function Id: 0x1535
//Function Number: 65
func_1535(param_00)
{
	level notify("broadcaster_ball_end",self.var_A582[0],1);
	level.var_A239 = 0;
	var_01 = self.var_A582[0] getlinkedparent();
	if(isdefined(var_01))
	{
		self.var_A582[0] unlink();
	}

	self.var_A582[0] method_84E0();
	self.var_A582[0] maps\mp\_movers::func_67F9();
	self.var_A582[0] method_805B();
	self.var_A582[0] method_8511();
	self.var_9D65 maps\mp\_movers::func_93CE();
	self.var_2915.var_50D5 = 0;
	var_02 = 0;
	if(isdefined(self.var_776C))
	{
		var_02 = 1;
		self.var_776C delete();
	}

	var_03 = param_00.var_01A7;
	var_04 = maps\mp\_utility::func_45DE(param_00.var_01A7);
	if(var_02)
	{
		if(self.var_5B80 == param_00.var_01A7)
		{
			maps\mp\_utility::func_5C39("pass_complete",var_03,"status");
			param_00.var_6EB4 = gettime();
			param_00.var_6EB3 = self.var_5B7E;
			param_00 thread maps\mp\_matchdata::func_5E93("pass",param_00.var_0116);
		}
		else
		{
			maps\mp\_utility::func_5C39("you_own_drone",var_03,"status");
			maps\mp\_utility::func_5C39("enemy_own_drone",var_04,"status");
			param_00 maps\mp\_events::func_5415();
		}
	}
	else
	{
		maps\mp\_utility::func_5C39("you_own_drone",var_03,"status");
		maps\mp\_utility::func_5C39("enemy_own_drone",var_04,"status");
		param_00 thread maps\mp\_matchdata::func_5E93("pickup",param_00.var_0116);
	}

	param_00 method_8617("grid_ball_pickup");
	lib_0380::func_288B("grid_ball_pickup_plr",param_00,param_00);
	func_1549(var_03,"mp_obj_notify_pos_sml","mp_obj_notify_neg_sml");
	func_1524();
	self.var_5B7F = 0;
	self.var_5B7E = param_00;
	self.var_5B80 = param_00.var_01A7;
	self.var_6DB2 = param_00.var_01A7;
	func_155C();
	if(!isdefined(param_00.var_200D))
	{
		param_00.var_200D = 1;
	}
	else
	{
		param_00.var_200D = param_00.var_200D + 1;
	}

	param_00 method_82FA("iw5_carrydrone_mp",1);
	param_00.var_1561 = getdvarint("scr_ball_water_drop_delay",10);
	param_00 maps\mp\_utility::func_47A2("specialty_ballcarrier");
	param_00.var_1510 = self;
	param_00.var_0112 = 1;
	setomnvar("ui_broadcaster_game_mode_status_1",-1);
	setomnvar("ui_broadcaster_game_mode_status_2",self.var_2006 getentitynumber());
	if(self.var_2006.var_01A7 == "allies")
	{
		setomnvar("ui_broadcaster_game_mode_status_3",1);
	}
	else
	{
		setomnvar("ui_broadcaster_game_mode_status_3",2);
	}

	param_00.var_4B7F = param_00 hasperk("specialty_sprintfire",1);
	param_00 maps\mp\_utility::func_47A2("specialty_sprintfire");
	param_00 common_scripts\utility::func_0601();
	var_05 = getdvarint("scr_ball_armor",100);
	if(param_00 maps\mp\_utility::func_0649("specialty_improvedobjectives"))
	{
		var_05 = var_05 + 30;
		self.var_6993 = 2;
	}
	else
	{
		self.var_6993 = 1;
	}

	if(var_05 > 0)
	{
		param_00 thread maps\mp\perks\_perkfunctions::func_86BB(var_05);
	}
	else
	{
		param_00 thread maps\mp\perks\_perkfunctions::func_A06E();
	}

	param_00 thread func_7389(self);
	maps\mp\gametypes\_gamelogic::func_869D(param_00,1);
	param_00 thread drop_ball_if_invalid_carrier(self);
}

//Function Id: 0x0000
//Function Number: 66
drop_ball_if_invalid_carrier(param_00)
{
	level endon("game_ended");
	self endon("death");
	self endon("disconnect");
	self endon("faux_spawn");
	common_scripts\utility::func_A74B("mount_force_drop",1.5);
	if(isdefined(param_00.var_2006) && param_00.var_2006 == self)
	{
		var_01 = self getcurrentweapon();
		if(var_01 != "iw5_carrydrone_mp")
		{
			param_00 func_1550();
		}
	}
}

//Function Id: 0x1515
//Function Number: 67
func_1515(param_00)
{
	self endon("death");
	self endon("disconnect");
	param_00 endon("reset");
	var_01 = spawnstruct();
	var_01 endon("timer_done");
	var_01 thread func_9A0F(1.5);
	param_00 waittill("pickup_object");
	var_01 func_9A09();
	if(!isdefined(param_00.var_2006) || param_00.var_2006.var_01A7 == self.var_01A7)
	{
		return;
	}

	param_00.var_2006 endon("disconnect");
	var_01 thread func_9A0F(5);
	param_00.var_2006 waittill("death",var_02);
	var_01 func_9A09();
	if(!isdefined(var_02) || var_02 != self)
	{
		return;
	}

	var_01 thread func_9A0F(2);
	param_00 waittill("pickup_object");
	var_01 func_9A09();
	if(isdefined(param_00.var_2006) && param_00.var_2006 == self)
	{
		maps\mp\_events::func_6EB2();
	}
}

//Function Id: 0x9A0F
//Function Number: 68
func_9A0F(param_00)
{
	self endon("cancel_timer");
	wait(param_00);
	self notify("timer_done");
}

//Function Id: 0x9A09
//Function Number: 69
func_9A09()
{
	self notify("cancel_timer");
}

//Function Id: 0x7389
//Function Number: 70
func_7389(param_00)
{
	self endon("disconnect");
	self endon("cancel_update_pass_target");
	var_01 = 0.8;
	for(;;)
	{
		var_02 = undefined;
		if(!self method_801D())
		{
			var_03 = anglestoforward(self getangles());
			var_04 = self geteye();
			var_05 = [];
			foreach(var_07 in level.var_744A)
			{
				if(var_07.var_01A7 != self.var_01A7)
				{
					continue;
				}

				if(!maps\mp\_utility::func_57A0(var_07))
				{
					continue;
				}

				if(!param_00 func_150E(var_07))
				{
					continue;
				}

				var_08 = var_07 geteye();
				var_09 = distancesquared(var_08,var_04);
				if(var_09 > 1000000)
				{
					continue;
				}

				var_0A = vectornormalize(var_08 - var_04);
				var_0B = vectordot(var_03,var_0A);
				if(var_0B > var_01)
				{
					var_07.var_6EA4 = var_0B;
					var_07.var_6EA8 = var_08;
					var_05[var_05.size] = var_07;
				}
			}

			var_05 = common_scripts\utility::func_7897(var_05,::func_2553);
			foreach(var_07 in var_05)
			{
				if(sighttracepassed(var_04,var_07.var_6EA8,0,self,var_07))
				{
					var_02 = var_07;
					break;
				}
			}
		}

		func_7321(var_02);
		wait 0.05;
	}
}

//Function Id: 0x72CC
//Function Number: 71
func_72CC()
{
	level waittill("joined_team",var_00);
}

//Function Id: 0x738A
//Function Number: 72
func_738A()
{
	if(!isdefined(self))
	{
		return;
	}

	self hudoutlinedisableforclients(level.var_744A);
	foreach(var_01 in level.var_744A)
	{
		var_01 hudoutlinedisableforclient(self);
	}

	var_03 = [];
	var_04 = [];
	var_05 = maps\mp\_utility::func_45DE(self.var_01A7);
	foreach(var_01 in level.var_744A)
	{
		if(var_01 == self)
		{
			continue;
		}

		if(var_01.var_01A7 == self.var_01A7)
		{
			var_03[var_03.size] = var_01;
			continue;
		}

		if(var_01.var_01A7 == var_05)
		{
			var_04[var_04.size] = var_01;
		}
	}

	if(isdefined(self.var_2016))
	{
		foreach(var_01 in var_03)
		{
			var_09 = isdefined(self.var_6EA9) && self.var_6EA9 == var_01;
			if(!var_09)
			{
				var_01 hudoutlineenableforclient(self,0,0);
			}
		}

		if(isdefined(self.var_6EA9))
		{
			self.var_6EA9 hudoutlineenableforclient(self,2,0);
		}

		if(var_04.size > 0)
		{
			self hudoutlineenableforclients(var_04,1,1);
		}

		if(var_03.size > 0)
		{
			self hudoutlineenableforclients(var_03,2,0);
		}
	}
}

//Function Id: 0x7321
//Function Number: 73
func_7321(param_00)
{
	if(isdefined(self.var_6EA9) && isdefined(param_00) && self.var_6EA9 == param_00)
	{
		return;
	}

	if(!isdefined(self.var_6EA9) && !function_0279(self.var_6EA9) && !isdefined(param_00))
	{
		return;
	}

	func_7245();
	if(isdefined(param_00))
	{
		var_01 = (0,0,70);
		self.var_6EA5 = param_00 maps\mp\_entityheadicons::func_869E(self,"waypoint_ball_pass_oh",var_01,30,30,0,0.05,0,1,0,0);
		self.var_6EA9 = param_00;
		var_02 = [];
		foreach(var_04 in level.var_744A)
		{
			if(var_04.var_01A7 == self.var_01A7 && var_04 != self && var_04 != param_00)
			{
				var_02[var_02.size] = var_04;
			}
		}

		self setclientomnvar("ui_uplink_can_pass",1);
		self setballpassallowed(1);
	}
}

//Function Id: 0x7245
//Function Number: 74
func_7245()
{
	if(isdefined(self.var_6EA5))
	{
		self.var_6EA5 destroy();
	}

	self setclientomnvar("ui_uplink_can_pass",0);
	var_00 = [];
	foreach(var_02 in level.var_744A)
	{
		if(var_02.var_01A7 == self.var_01A7 && var_02 != self)
		{
			var_00[var_00.size] = var_02;
		}
	}

	self.var_6EA9 = undefined;
	self setballpassallowed(0);
}

//Function Id: 0x2553
//Function Number: 75
func_2553(param_00,param_01)
{
	return param_00.var_6EA4 >= param_01.var_6EA4;
}

//Function Id: 0x1550
//Function Number: 76
func_1550(param_00)
{
	if(!isdefined(param_00))
	{
		param_00 = 0;
	}

	self.var_57A6 = 1;
	self.var_34B1 = gettime();
	self notify("dropped");
	var_01 = self.var_2006;
	if(isdefined(var_01) && var_01.var_01A7 != "spectator")
	{
		var_02 = var_01.var_0116;
		if(var_01 getstance() == "stand")
		{
			if(param_00 == 1)
			{
				var_02 = var_02 + (0,0,60);
			}
			else
			{
				var_02 = var_02 + (0,0,40);
			}
		}
		else if(var_01 getstance() == "crouch")
		{
			var_02 = var_02 + (0,0,40);
		}
		else
		{
			var_02 = var_02 + (0,0,20);
		}
	}
	else
	{
		var_02 = self.var_802F;
		var_02 = var_02 + (0,0,40);
	}

	var_03 = (0,0,0);
	for(var_04 = 0;var_04 < self.var_A582.size;var_04++)
	{
		self.var_A582[var_04].var_0116 = var_02;
		self.var_A582[var_04].var_001D = var_03;
		self.var_A582[var_04] method_805B();
	}

	self.var_9D65.var_0116 = var_02;
	func_151D();
	self.var_28D4 = self.var_9D65.var_0116;
	func_1511();
	func_1522();
	self.var_6DB2 = "any";
	func_155D();
	maps\mp\gametypes\_gameobjects::func_23DA();
	maps\mp\gametypes\_gameobjects::func_A0FE();
	maps\mp\gametypes\_gameobjects::func_A19B();
	self.var_57A6 = 0;
	if(!param_00)
	{
		var_05 = self.var_5B80;
		var_06 = maps\mp\_utility::func_45DE(var_05);
		maps\mp\_utility::func_5C39("ally_drop_drone",var_05,"status");
		maps\mp\_utility::func_5C39("enemy_drop_drone",var_06,"status");
		func_1542((0,0,80));
	}

	var_07 = spawnstruct();
	var_07.var_2016 = self;
	var_07.var_2AA8 = ::func_1539;
	self.var_9D65 thread maps\mp\_movers::func_4A27(var_07);
	return 1;
}

//Function Id: 0x1539
//Function Number: 77
func_1539(param_00)
{
}

//Function Id: 0x1509
//Function Number: 78
func_1509()
{
	var_00 = undefined;
	var_01 = common_scripts\utility::func_0F92(level.var_1554);
	foreach(var_03 in var_01)
	{
		if(var_03.var_50D5)
		{
			continue;
		}

		var_00 = var_03;
		break;
	}

	if(!isdefined(var_00))
	{
		return;
	}

	func_150A(var_00);
}

//Function Id: 0x150A
//Function Number: 79
func_150A(param_00)
{
	foreach(var_02 in self.var_A582)
	{
		var_02.var_162D = param_00.var_0116;
	}

	self.var_9D65.var_162D = param_00.var_0116;
	self.var_2915 = param_00;
	param_00.var_50D5 = 1;
}

//Function Id: 0x1538
//Function Number: 80
func_1538()
{
	func_1509();
	var_00 = self.var_A582[0];
	var_00 maps\mp\_movers::func_67F9();
	var_01 = var_00 getlinkedparent();
	if(isdefined(var_01))
	{
		var_00 unlink();
	}

	var_00 method_84E0();
	func_151D();
	if(isdefined(self.var_776C))
	{
		self.var_776C delete();
	}

	var_02 = "none";
	var_03 = self.var_5B80;
	if(isdefined(var_03))
	{
		var_02 = maps\mp\_utility::func_45DE(var_03);
	}

	func_1511();
	setomnvar("ui_broadcaster_game_mode_status_1",-1);
	setomnvar("ui_broadcaster_game_mode_status_2",-1);
	setomnvar("ui_broadcaster_game_mode_status_3",3);
	self.var_9D65 maps\mp\_movers::func_93CE();
	func_155B();
	maps\mp\gametypes\_gameobjects::func_870A(var_00.var_162D + (0,0,4000),(0,0,0));
	var_04 = 1.5;
	var_00 moveto(var_00.var_162D,var_04,0,var_04);
	var_00 rotatevelocity((0,720,0),var_04,0,var_04);
	playsoundatpos(var_00.var_162D,"grid_ball_reset");
	if(!self.var_5B7F && isdefined(var_03) && isdefined(var_02))
	{
		maps\mp\_utility::func_5C39("drone_reset",var_03,"status");
		maps\mp\_utility::func_5C39("drone_reset",var_02,"status");
		if(isdefined(self.var_5B7E))
		{
			thread maps\mp\_utility::func_9863("callout_ballreset",self.var_5B7E);
		}
	}

	self.var_6DB2 = "any";
	func_155B();
	thread func_151F(var_04);
	thread func_151E(var_00,var_04);
}

//Function Id: 0x151E
//Function Number: 81
func_151E(param_00,param_01)
{
	playfxontag(level.var_0611["ball_download"],param_00,"tag_weapon");
	common_scripts\utility::func_A74B("pickup_object",param_01);
	stopfxontag(level.var_0611["ball_download"],param_00,"tag_weapon");
	self.var_80AA = 0;
}

//Function Id: 0x151F
//Function Number: 82
func_151F(param_00)
{
	self endon("pickup_object");
	wait(param_00);
	func_155D();
	playfx(level.var_0611["ball_download_end"],self.var_2915.var_487A);
	func_1522();
}

//Function Id: 0x1511
//Function Number: 83
func_1511()
{
	if(isdefined(self.var_2006))
	{
		self.var_2006.var_1561 = undefined;
		self.var_2006.var_6735 = gettime() + 500;
		self.var_2006 func_7245();
		self.var_2006 notify("cancel_update_pass_target");
		self.var_2006 maps\mp\_utility::func_0735("specialty_ballcarrier");
		self.var_2006.var_1510 = undefined;
		self.var_2006 thread maps\mp\perks\_perkfunctions::func_A06E();
		if(!self.var_2006.var_4B7F)
		{
			self.var_2006 maps\mp\_utility::func_0735("specialty_sprintfire");
		}

		self.var_2006 common_scripts\utility::func_0615();
		self.var_2006 setballpassallowed(0);
		self.var_2006 setclientomnvar("ui_uplink_can_pass",0);
		self.var_2006.var_0112 = 0;
	}
}

//Function Id: 0x1520
//Function Number: 84
func_1520(param_00)
{
	var_01 = self.var_0116 + (0,0,32);
	var_02 = self.var_0116 + (0,0,-1000);
	self.var_487A = playerphysicstrace(var_01,var_02);
}

//Function Id: 0x151B
//Function Number: 85
func_151B(param_00)
{
	var_01 = param_00;
	if(game["switchedsides"])
	{
		var_01 = maps\mp\_utility::func_45DE(var_01);
	}

	var_02 = common_scripts\utility::func_46B5("ball_goal_" + var_01,"targetname");
	if(isdefined(var_02))
	{
		var_02 func_1520();
		var_02.var_0116 = var_02.var_487A;
	}
	else
	{
		var_02 = spawnstruct();
		switch(level.var_015D)
		{
			default:
				break;
		}

		if(!isdefined(var_02.var_0116))
		{
			var_02.var_0116 = level.var_2B9D[param_00];
		}

		var_02 func_1520();
		var_02.var_0116 = var_02.var_487A;
	}

	var_02.var_014F = 70;
	var_02.var_01A7 = param_00;
	var_02.var_152C = 0;
	var_02.var_4D3F = 0;
	var_02.var_645F = -1;
	level.var_152B[param_00] = var_02;
}

//Function Id: 0x1519
//Function Number: 86
func_1519(param_00)
{
	var_01 = common_scripts\utility::func_46B7("ball_start","targetname");
	var_01 = common_scripts\utility::func_0F92(var_01);
	foreach(var_03 in var_01)
	{
		if(!isdefined(var_03.var_81E1))
		{
			var_03.var_81E1 = 100;
		}
	}

	var_01 = common_scripts\utility::func_7897(var_01,::func_2554);
	foreach(var_03 in var_01)
	{
		func_1508(var_03.var_0116);
	}

	var_07 = 30;
	if(var_01.size == 0)
	{
		var_08 = (0,0,0);
		switch(level.var_015D)
		{
			default:
				break;
		}

		if(!isdefined(var_08))
		{
			var_08 = level.var_2B93;
		}

		func_1508(var_08);
	}

	var_09 = param_00 - level.var_1554.size;
	if(var_09 <= 0)
	{
		return;
	}

	var_0A = level.var_1554[0].var_0116;
	var_0B = getnodesinradius(var_0A,175,20,50);
	for(var_0C = 0;var_0C < var_09 && var_0C < var_0B.size;var_0C++)
	{
		func_1508(var_0B[var_0C].var_0116);
	}
}

//Function Id: 0x1508
//Function Number: 87
func_1508(param_00)
{
	var_01 = 30;
	var_02 = spawnstruct();
	var_02.var_0116 = param_00;
	var_02 func_1520();
	var_02.var_0116 = var_02.var_487A + (0,0,var_01);
	var_02.var_50D5 = 0;
	level.var_1554[level.var_1554.size] = var_02;
}

//Function Id: 0x2554
//Function Number: 88
func_2554(param_00,param_01)
{
	return param_00.var_81E1 <= param_01.var_81E1;
}

//Function Id: 0x1534
//Function Number: 89
func_1534()
{
	for(;;)
	{
		level waittill("connected",var_00);
		var_00.var_1528 = [];
		var_00 thread func_72F2();
	}
}

//Function Id: 0x72F2
//Function Number: 90
func_72F2()
{
	self waittill("disconnect");
	func_7255();
}

//Function Id: 0x1529
//Function Number: 91
func_1529(param_00)
{
	var_01 = func_1525(param_00);
	if(var_01 == "broadcaster")
	{
		param_00 thread monitorbroadcasterfxchanged();
	}

	param_00 func_7255();
	foreach(var_06, var_03 in level.var_152B)
	{
		if(var_01 == "broadcaster")
		{
			var_04 = common_scripts\utility::func_98E7(var_06 == "allies","ball_goal_allies_blue","ball_goal_axis_red");
		}
		else if(var_03.var_01A7 == "allies")
		{
			if(var_01 == "axis")
			{
				var_04 = "ball_goal_allies_red";
			}
			else
			{
				var_04 = "ball_goal_allies_blue";
			}
		}
		else if(var_01 == "axis")
		{
			var_04 = "ball_goal_axis_blue";
		}
		else
		{
			var_04 = "ball_goal_axis_red";
		}

		var_05 = spawnfxforclient(common_scripts\utility::func_44F5(var_04),var_03.var_0116 + (0,0,15),param_00);
		function_014E(var_05,1);
		param_00.var_1528[var_04] = var_05;
		triggerfx(var_05);
	}
}

//Function Id: 0x1525
//Function Number: 92
func_1525(param_00)
{
	var_01 = param_00.var_01A7;
	if(param_00 method_8436())
	{
		var_01 = "broadcaster";
	}
	else if(var_01 != "allies" && var_01 != "axis")
	{
		var_01 = "allies";
	}

	return var_01;
}

//Function Id: 0x0000
//Function Number: 93
monitorbroadcasterfxchanged()
{
	self endon("disconnect");
	self endon("game_ended");
	for(;;)
	{
		self waittill("changeGoalFx");
		func_7255();
		foreach(var_04, var_01 in level.var_152B)
		{
			var_02 = common_scripts\utility::func_98E7(var_04 == "allies","ball_goal_allies_blue","ball_goal_axis_red");
			if(self.var_1E99.var_A4A8 == "first_person")
			{
				if(var_01.var_01A7 == "allies")
				{
					if(var_04 == self.var_1E99.var_9815.var_01A7)
					{
						var_02 = "ball_goal_allies_blue";
					}
					else
					{
						var_02 = "ball_goal_allies_red";
					}
				}
				else if(var_04 == self.var_1E99.var_9815.var_01A7)
				{
					var_02 = "ball_goal_axis_blue";
				}
				else
				{
					var_02 = "ball_goal_axis_red";
				}
			}

			var_03 = spawnfxforclient(common_scripts\utility::func_44F5(var_02),var_01.var_0116 + (0,0,15),self);
			function_014E(var_03,1);
			self.var_1528[var_02] = var_03;
			triggerfx(var_03);
		}

		wait 0.05;
	}
}

//Function Id: 0x7255
//Function Number: 94
func_7255()
{
	foreach(var_01 in self.var_1528)
	{
		if(isdefined(var_01))
		{
			var_01 delete();
		}
	}
}

//Function Id: 0x1548
//Function Number: 95
func_1548()
{
	for(;;)
	{
		level waittill("joined_team",var_00);
		func_1529(var_00);
	}
}

//Function Id: 0x2CDB
//Function Number: 96
func_2CDB(param_00,param_01,param_02)
{
	level endon("game_ended");
	wait(1.2);
	maps\mp\_utility::func_5C39(param_00,param_01,param_02);
}