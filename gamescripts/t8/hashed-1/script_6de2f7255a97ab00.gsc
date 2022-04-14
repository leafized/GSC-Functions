// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using script_39bd5b6b799b1c9c;
#using script_3f65948f90646f7c;
#using script_55e622b35104ba68;
#using script_cb32d07c95e5628;
#using scripts\core_common\callbacks_shared.gsc;
#using scripts\core_common\clientfield_shared.gsc;
#using scripts\core_common\math_shared.gsc;
#using scripts\core_common\oob.gsc;
#using scripts\core_common\system_shared.gsc;
#using scripts\core_common\util_shared.gsc;
#using scripts\core_common\vehicle_shared.gsc;

#namespace namespace_8f74625a;

/*
	Name: function_89f2df9
	Namespace: namespace_8f74625a
	Checksum: 0x644F8167
	Offset: 0x3B8
	Size: 0x44
	Parameters: 0
	Flags: AutoExec
*/
function autoexec function_89f2df9()
{
	system::register(#"hash_c70352f852fda84", &__init__, undefined, #"item_world");
}

/*
	Name: __init__
	Namespace: namespace_8f74625a
	Checksum: 0x238C5F2E
	Offset: 0x408
	Size: 0xDC
	Parameters: 0
	Flags: Linked, Private
*/
function private __init__()
{
	if(!isdefined(getgametypesetting(#"useitemspawns")) || getgametypesetting(#"useitemspawns") == 0)
	{
		return;
	}
	level.var_a5f063d = [];
	/#
		level thread function_44b9dd1d();
	#/
	clientfield::register("scriptmover", "supply_drop_fx", 1, 1, "int");
	clientfield::register("scriptmover", "supply_drop_parachute_rob", 1, 1, "int");
}

/*
	Name: function_eaba72c9
	Namespace: namespace_8f74625a
	Checksum: 0x1CF31862
	Offset: 0x4F0
	Size: 0x4E6
	Parameters: 0
	Flags: Private
*/
function private function_eaba72c9()
{
	/#
		while(true)
		{
			if(getdvarint(#"hash_7364440898cf4b76", 0) > 0)
			{
				switch(getdvarint(#"hash_7364440898cf4b76", 0))
				{
					case 1:
					{
						level thread function_418e26fe();
						break;
					}
					case 2:
					{
						vehicletypes = array(#"hash_54469210eb79f8fa", #"hash_2c40642bbbab460d", #"hash_2f8f41949bf9944b");
						level thread function_418e26fe(undefined, 1, 1, 0, 1, vehicletypes[randomint(vehicletypes.size)]);
						break;
					}
				}
				setdvar(#"hash_7364440898cf4b76", 0);
			}
			if(getdvarint(#"hash_41d51e6f2ca1b9b1", 0) > 0)
			{
				switch(getdvarint(#"hash_41d51e6f2ca1b9b1", 0))
				{
					case 1:
					{
						level thread function_7d4a448f();
						break;
					}
				}
				setdvar(#"hash_41d51e6f2ca1b9b1", 0);
			}
			if(getdvarint(#"hash_5dc24c61c66f6fee", 0) > 0)
			{
				function_a88ee653();
			}
			if(getdvarint(#"hash_40d4ca5923d72b3d", 0) > 0)
			{
				players = getplayers();
				if(isdefined(players[0]))
				{
					switch(getdvarint(#"hash_40d4ca5923d72b3d", 0))
					{
						case 1:
						{
							level thread function_1b48df6d(players[0].origin);
							break;
						}
						case 2:
						{
							level thread function_1b48df6d(players[0].origin, 1);
							break;
						}
						case 3:
						{
							vehicletypes = array(#"hash_54469210eb79f8fa", #"hash_2c40642bbbab460d", #"hash_2f8f41949bf9944b");
							level thread function_1b48df6d(players[0].origin, 1, 1, vehicletypes[randomint(vehicletypes.size)]);
							break;
						}
						case 4:
						{
							function_8366d4d6(players[0].origin);
							break;
						}
						case 5:
						{
							vehicletypes = array(#"hash_660785b539889002", #"hash_54bf3cd56e8c5c4a", #"hash_6fdb3b0114439974", #"hash_327d1f9834b6b91e");
							level thread function_1b48df6d(players[0].origin, 1, 1, vehicletypes[randomint(vehicletypes.size)]);
							break;
						}
					}
				}
				setdvar(#"hash_40d4ca5923d72b3d", 0);
			}
			waitframe(1);
		}
	#/
}

/*
	Name: function_44b9dd1d
	Namespace: namespace_8f74625a
	Checksum: 0xB7A59F54
	Offset: 0x9E0
	Size: 0x1C4
	Parameters: 0
	Flags: Private
*/
function private function_44b9dd1d()
{
	/#
		while(!canadddebugcommand())
		{
			waitframe(1);
		}
		mapname = util::function_53bbf9d2();
		adddebugcommand(("" + mapname) + "");
		adddebugcommand(("" + mapname) + "");
		adddebugcommand(("" + mapname) + "");
		adddebugcommand(("" + mapname) + "");
		adddebugcommand(("" + mapname) + "");
		adddebugcommand(("" + mapname) + "");
		adddebugcommand(("" + mapname) + "");
		adddebugcommand(("" + mapname) + "");
		adddebugcommand(("" + mapname) + "");
		level thread function_eaba72c9();
	#/
}

/*
	Name: function_a88ee653
	Namespace: namespace_8f74625a
	Checksum: 0xFCAFE48E
	Offset: 0xBB0
	Size: 0x4A4
	Parameters: 0
	Flags: Private
*/
function private function_a88ee653()
{
	/#
		if(isdefined(level.var_b2513722))
		{
			var_52b56362 = (isdefined(level.var_52b56362) ? level.var_52b56362 : 0);
			deathcircle = level.var_fb91af8[var_52b56362];
			var_448914c2 = (isdefined(level.var_fb91af8[var_52b56362 + 1]) ? level.var_fb91af8[var_52b56362 + 1] : deathcircle);
			height = var_448914c2.origin[2];
			radius = 200;
			sphere(level.var_d1c35a7a, radius, (1, 0, 0));
			sphere(level.var_ebe9f3de, radius, (1, 0, 0));
			if(isdefined(level.var_1b269b78))
			{
				sphere(level.var_1b269b78, radius, (0, 1, 0));
				var_58d00116 = (level.var_1b269b78[0], level.var_1b269b78[1], height);
				line(level.var_1b269b78, var_58d00116, (0, 1, 0));
				sphere(var_58d00116, radius, (0, 1, 0));
			}
			if(isdefined(level.var_538928e3))
			{
				sphere(level.var_538928e3, radius, (0, 1, 0));
				var_fb4d4118 = (level.var_538928e3[0], level.var_538928e3[1], height);
				line(level.var_538928e3, var_fb4d4118, (0, 1, 0));
				sphere(var_fb4d4118, radius, (0, 1, 0));
			}
			sphere(level.var_daa6e3f, radius, (1, 0.5, 0));
			for(index = 1; index < level.var_57e06aea.size; index++)
			{
				line(level.var_57e06aea[index - 1], level.var_57e06aea[index], (1, 0, 0));
			}
			if(isdefined(level.var_ae7f6100) && isdefined(level.var_3e5e898c))
			{
				var_d54803e = level.var_3e5e898c;
				var_9c1af46d = (level.var_3e5e898c[0], level.var_ae7f6100[1], level.var_ae7f6100[2]);
				var_c46271bf = (level.var_ae7f6100[0], level.var_3e5e898c[1], level.var_3e5e898c[2]);
				var_99a8be82 = level.var_ae7f6100;
				line(var_d54803e, var_9c1af46d, (1, 1, 1));
				line(var_d54803e, var_c46271bf, (1, 1, 1));
				line(var_99a8be82, var_9c1af46d, (1, 1, 1));
				line(var_99a8be82, var_c46271bf, (1, 1, 1));
				sphere(var_d54803e, radius, (1, 1, 1));
				sphere(var_c46271bf, radius, (1, 1, 1));
				sphere(var_9c1af46d, radius, (1, 1, 1));
				sphere(var_99a8be82, radius, (1, 1, 1));
			}
		}
	#/
}

/*
	Name: function_c7bd0aa8
	Namespace: namespace_8f74625a
	Checksum: 0x8269FAF0
	Offset: 0x1060
	Size: 0x39C
	Parameters: 2
	Flags: Linked, Private
*/
function private function_c7bd0aa8(point, startpoint)
{
	/#
		assert(isvec(point));
	#/
	/#
		assert(isvec(startpoint));
	#/
	if(function_16bbdd8b(point))
	{
		return point;
	}
	/#
		assert(function_16bbdd8b(startpoint));
	#/
	min = level.var_3e5e898c;
	max = level.var_ae7f6100;
	var_1ccbeeaa = (point[0], point[1], 0);
	var_49e5fac9 = (startpoint[0], startpoint[1], 0);
	if(var_1ccbeeaa[0] < min[0])
	{
		var_dd00b78e = vectornormalize(var_1ccbeeaa - var_49e5fac9);
		/#
			assert(var_dd00b78e[0] != 0);
		#/
		t = (min[0] - var_49e5fac9[0]) / var_dd00b78e[0];
		var_1ccbeeaa = var_49e5fac9 + (var_dd00b78e * t);
	}
	else if(var_1ccbeeaa[0] > max[0])
	{
		var_dd00b78e = vectornormalize(var_1ccbeeaa - var_49e5fac9);
		/#
			assert(var_dd00b78e[0] != 0);
		#/
		t = (max[0] - var_49e5fac9[0]) / var_dd00b78e[0];
		var_1ccbeeaa = var_49e5fac9 + (var_dd00b78e * t);
	}
	if(var_1ccbeeaa[1] < min[1])
	{
		var_dd00b78e = vectornormalize(var_1ccbeeaa - var_49e5fac9);
		/#
			assert(var_dd00b78e[1] != 0);
		#/
		t = (min[1] - var_49e5fac9[1]) / var_dd00b78e[1];
		var_1ccbeeaa = var_49e5fac9 + (var_dd00b78e * t);
	}
	else if(var_1ccbeeaa[1] > max[1])
	{
		var_dd00b78e = vectornormalize(var_1ccbeeaa - var_49e5fac9);
		/#
			assert(var_dd00b78e[1] != 0);
		#/
		t = (max[1] - var_49e5fac9[1]) / var_dd00b78e[1];
		var_1ccbeeaa = var_49e5fac9 + (var_dd00b78e * t);
	}
	point = (var_1ccbeeaa[0], var_1ccbeeaa[1], point[2]);
	return point;
}

/*
	Name: function_13339b58
	Namespace: namespace_8f74625a
	Checksum: 0xBB966D5A
	Offset: 0x1408
	Size: 0x244
	Parameters: 1
	Flags: Linked, Private
*/
function private function_13339b58(var_d4bce8be)
{
	self endon(#"death");
	var_ee00b371 = #"hash_4f2b2f1b4df13119";
	idle_anim = #"hash_39265b4ed372175a";
	var_e1c31bea = #"hash_32ad963f25f115d2";
	if(isdefined(var_d4bce8be) && var_d4bce8be)
	{
		var_ee00b371 = #"hash_77322c90462ba8c";
		idle_anim = #"hash_780b50c0a9393f1d";
		var_e1c31bea = #"hash_ac2d4936b932903";
	}
	self animscripted("parachute_open", self.origin, self.angles, var_ee00b371, "normal", "root", 1, 0);
	self waittill(#"parachute_open");
	if(!(isdefined(self.var_b702030d) && self.var_b702030d))
	{
		self animscripted("parachute_idle", self.origin, self.angles, idle_anim, "normal", "root", 1, 0);
	}
	self waittill(#"hash_6c4de390ac1cb3d7");
	self unlink();
	self animscripted("parachute_closed", self.origin, self.angles, var_e1c31bea, "normal", "root", 1, 0);
	animlength = getanimlength("parachute_closed");
	wait(animlength * 0.35);
	self clientfield::set("supply_drop_parachute_rob", 0);
	wait(animlength * 0.65);
	self delete();
}

/*
	Name: function_71c31c8d
	Namespace: namespace_8f74625a
	Checksum: 0xE769DD0D
	Offset: 0x1658
	Size: 0x22
	Parameters: 0
	Flags: Linked, Private
*/
function private function_71c31c8d()
{
	self notify(#"hash_6ade3db3c3188274");
	self.var_7bea4af0 = 1;
}

/*
	Name: function_500a6615
	Namespace: namespace_8f74625a
	Checksum: 0xAE289F4D
	Offset: 0x1688
	Size: 0x694
	Parameters: 1
	Flags: Linked, Private
*/
function private function_500a6615(itemspawnlist = #"hash_696141fcc5f2e372")
{
	if(isdefined(self.supplydrop))
	{
		supplydrop = self.supplydrop;
		self.supplydrop = undefined;
		supplydrop.var_b2513722 = undefined;
		if(isdefined(supplydrop.var_d5552131))
		{
			supplydrop.var_d5552131.var_b2513722 = undefined;
		}
		supplydrop endon(#"death");
		supplydrop unlink();
		supplydrop show();
		supplydrop.angles = (0, supplydrop.angles[1], 0);
		startpoint = (supplydrop.origin[0], supplydrop.origin[1], min(10000, supplydrop.origin[2] - 200));
		endpoint = (supplydrop.origin[0], supplydrop.origin[1], -10000);
		travelspeed = isdefined(supplydrop.var_abd32694) && (supplydrop.var_abd32694 ? 400 : 200);
		var_d635e1bd = isdefined(supplydrop.var_abd32694) && (supplydrop.var_abd32694 ? 200 : 120);
		groundtrace = physicstraceex(startpoint, endpoint, vectorscale((-1, -1, -1), 0.5), vectorscale((1, 1, 1), 0.5), supplydrop, 32);
		groundpoint = groundtrace[#"position"] + (0, 0, var_d635e1bd);
		traveldistance = startpoint - groundpoint;
		movetime = traveldistance[2] / travelspeed;
		if(movetime < 0)
		{
			movetime = 1;
		}
		supplydrop moveto(groundpoint, movetime);
		supplydrop playsound("evt_supply_drop");
		var_f6dfa3da = isdefined(supplydrop.var_abd32694) && (supplydrop.var_abd32694 ? 0.25 : 1);
		wait(var_f6dfa3da);
		var_81b62996 = spawn("script_model", (0, 0, 0));
		var_81b62996.targetname = "supply_drop_chute";
		var_81b62996.origin = supplydrop.origin;
		var_81b62996.angles = supplydrop.angles;
		var_81b62996 setforcenocull();
		if(isdefined(supplydrop.var_abd32694) && supplydrop.var_abd32694 && isdefined(supplydrop.var_d5552131) && supplydrop.var_d5552131.scriptvehicletype === "player_tank")
		{
			var_81b62996 setmodel("p8_fxanim_wz_parachute_supplydrop_tank_fade");
			var_81b62996 clientfield::set("supply_drop_parachute_rob", 1);
			var_81b62996 useanimtree("generic");
			var_81b62996 linkto(supplydrop, "tag_origin", (0, 0, 0));
			var_81b62996 thread function_13339b58(1);
		}
		else
		{
			var_81b62996 setmodel("p8_fxanim_wz_parachute_supplydrop_fade");
			var_81b62996 clientfield::set("supply_drop_parachute_rob", 1);
			var_81b62996 useanimtree("generic");
			var_81b62996 linkto(supplydrop, "tag_origin", (0, 0, 0));
			var_81b62996 thread function_13339b58();
		}
		if(!(isdefined(supplydrop.var_7bea4af0) && supplydrop.var_7bea4af0))
		{
			supplydrop waittill(#"movedone", #"hash_6ade3db3c3188274");
		}
		if(isdefined(var_81b62996))
		{
			var_81b62996 notify(#"hash_6c4de390ac1cb3d7");
			var_81b62996.var_b702030d = 1;
		}
		if(isdefined(supplydrop.var_abd32694) && supplydrop.var_abd32694)
		{
			if(isdefined(supplydrop.var_d5552131))
			{
				supplydrop.var_d5552131 unlink();
				supplydrop.var_d5552131.overridevehicledamage = undefined;
				level.var_cd8f416a[level.var_cd8f416a.size] = supplydrop.var_d5552131;
				supplydrop.var_d5552131 thread function_e21ceb1b();
			}
			supplydrop delete();
		}
		else
		{
			supplydrop physicslaunch();
			supplydrop thread function_924a11ff(itemspawnlist);
			supplydrop thread function_e21ceb1b();
		}
	}
}

/*
	Name: function_e21ceb1b
	Namespace: namespace_8f74625a
	Checksum: 0xA62E6384
	Offset: 0x1D28
	Size: 0x370
	Parameters: 0
	Flags: Linked, Private
*/
function private function_e21ceb1b()
{
	self endon(#"death", #"movedone");
	var_9d85c40f = vectorscale((1, 1, 1), 10);
	previousorigin = self.origin;
	var_8bc27a4a = 0;
	while(true)
	{
		var_3769eb50 = getentitiesinradius(self.origin, 128, 1);
		var_15d21979 = abs(previousorigin - self.origin[2]);
		if(var_15d21979 > 4)
		{
			foreach(player in var_3769eb50)
			{
				if(isalive(player) && player istouching(self, var_9d85c40f))
				{
					if(isvehicle(self))
					{
						player dodamage(player.health + 1, player.origin, self, self, "none", "MOD_CRUSH");
						player playsound("evt_supply_crush");
						continue;
					}
					player dodamage(player.health + 1, player.origin, self, self, "none", "MOD_HIT_BY_OBJECT", 0, getweapon(#"supplydrop"));
					player playsound("evt_supply_crush");
				}
			}
		}
		if(isvehicle(self))
		{
			speed = abs(self getspeedmph());
			velocity = self getvelocity();
			var_80c2b29 = abs(velocity[2]);
			if(speed < 0.1 && var_80c2b29 < 0.1)
			{
				var_8bc27a4a++;
			}
			else
			{
				var_8bc27a4a = 0;
			}
			if(var_8bc27a4a >= 4)
			{
				return;
			}
		}
		previousorigin = self.origin;
		waitframe(1);
	}
}

/*
	Name: function_ba3be344
	Namespace: namespace_8f74625a
	Checksum: 0x87DC4899
	Offset: 0x20A0
	Size: 0x204
	Parameters: 0
	Flags: Linked, Private
*/
function private function_ba3be344()
{
	self endon(#"death");
	self notify(#"hash_57267dfd9e64c1c7");
	exitangle = 60;
	right = anglestoforward(self.angles + (0, exitangle, 0));
	left = anglestoforward(self.angles + (0, exitangle * -1, 0));
	var_7a66fccd = function_43e35f94();
	startpoint = self.origin;
	leftpoint = function_c7bd0aa8(startpoint + (left * var_7a66fccd), startpoint);
	rightpoint = function_c7bd0aa8(startpoint + (right * var_7a66fccd), startpoint);
	endpoint = rightpoint;
	if(distance2d(startpoint, leftpoint) < distance2d(startpoint, rightpoint))
	{
		endpoint = leftpoint;
	}
	var_57e06aea = function_eafcba42(startpoint, endpoint);
	self.var_57e06aea = var_57e06aea;
	self setspeed(50);
	wait(0.5);
	self thread function_c2edbefb(var_57e06aea);
	wait(0.5);
	self setspeed(100);
}

/*
	Name: function_3c597e8d
	Namespace: namespace_8f74625a
	Checksum: 0x244E5A29
	Offset: 0x22B0
	Size: 0x70
	Parameters: 0
	Flags: Linked, Private
*/
function private function_3c597e8d()
{
	var_6024133d = getentarray("map_corner", "targetname");
	if(var_6024133d.size)
	{
		return math::find_box_center(var_6024133d[0].origin, var_6024133d[1].origin);
	}
	return (0, 0, 0);
}

/*
	Name: function_43e35f94
	Namespace: namespace_8f74625a
	Checksum: 0x3CA8A8C5
	Offset: 0x2328
	Size: 0xE6
	Parameters: 0
	Flags: Linked, Private
*/
function private function_43e35f94()
{
	var_6024133d = getentarray("map_corner", "targetname");
	if(var_6024133d.size)
	{
		x = abs(var_6024133d[0].origin[0] - var_6024133d[1].origin[0]);
		y = abs(var_6024133d[0].origin[1] - var_6024133d[1].origin[1]);
		return max(x, y) / 2;
	}
	return 1000;
}

/*
	Name: function_67d7d040
	Namespace: namespace_8f74625a
	Checksum: 0x5A098F2A
	Offset: 0x2418
	Size: 0x156
	Parameters: 1
	Flags: Linked, Private
*/
function private function_67d7d040(var_d91c179d)
{
	supplydrop = spawn("script_model", (0, 0, 0));
	supplydrop.targetname = "supply_drop";
	supplydrop setmodel("wpn_t7_drop_box_wz");
	supplydrop setforcenocull();
	supplydrop useanimtree("generic");
	supplydrop.var_a64ed253 = 1;
	supplydrop.var_bad13452 = 0;
	supplydrop.targetname = (supplydrop getentitynumber() + "_stash_") + randomint(2147483647);
	supplydrop clientfield::set("dynamic_stash", 1);
	supplydrop clientfield::set("dynamic_stash_type", 1);
	supplydrop.var_ed175c5 = 1;
	supplydrop.var_b2513722 = var_d91c179d;
	return supplydrop;
}

/*
	Name: function_546afbb6
	Namespace: namespace_8f74625a
	Checksum: 0x98D3A755
	Offset: 0x2578
	Size: 0x128
	Parameters: 0
	Flags: Linked, Private
*/
function private function_546afbb6()
{
	self endon(#"death");
	var_dc66f988 = self getvelocity();
	var_2497a956 = 0;
	while(true)
	{
		velocity = self getvelocity();
		var_2497a956 = min(var_2497a956, velocity[2]);
		if(abs(velocity[2] - var_dc66f988[2]) > 100)
		{
			if(abs(var_2497a956) > 1000)
			{
				self setvehvelocity((0, 0, 0));
				self dodamage(self.health, self.origin, self);
			}
			return;
		}
		waitframe(1);
		var_dc66f988 = velocity;
	}
}

/*
	Name: function_a3832aa0
	Namespace: namespace_8f74625a
	Checksum: 0xCF32DE56
	Offset: 0x26A8
	Size: 0x1B6
	Parameters: 2
	Flags: Linked, Private
*/
function private function_a3832aa0(var_d91c179d, vehicletype)
{
	supplydrop = spawn("script_model", vectorscale((0, 0, -1), 64000));
	supplydrop setmodel("tag_origin");
	supplydrop useanimtree("generic");
	supplydrop.var_b2513722 = var_d91c179d;
	var_d5552131 = spawnvehicle(vehicletype, (0, 0, 0), (0, 0, 0));
	var_d5552131 linkto(supplydrop, "tag_origin", (0, 0, 0), vectorscale((0, 1, 0), 90));
	var_d5552131.var_b9b5403c = var_d5552131.health * 0.5;
	var_d5552131.overridevehicledamage = &function_9a275b1f;
	var_d5552131.var_b2513722 = var_d91c179d;
	var_d5552131.supplydrop = supplydrop;
	var_d5552131 makeusable();
	if(isdefined(var_d5552131.isphysicsvehicle) && var_d5552131.isphysicsvehicle)
	{
		var_d5552131 setbrake(1);
	}
	supplydrop.var_d5552131 = var_d5552131;
	supplydrop.var_abd32694 = 1;
	return supplydrop;
}

/*
	Name: function_16bbdd8b
	Namespace: namespace_8f74625a
	Checksum: 0xAD594A48
	Offset: 0x2868
	Size: 0x212
	Parameters: 1
	Flags: Linked, Private
*/
function private function_16bbdd8b(point)
{
	if(!isdefined(level.var_3e5e898c) || !isdefined(level.var_ae7f6100))
	{
		var_6024133d = getentarray("map_corner", "targetname");
		minx = min(var_6024133d[0].origin[0], var_6024133d[1].origin[0]);
		miny = min(var_6024133d[0].origin[1], var_6024133d[1].origin[1]);
		minz = -10;
		level.var_3e5e898c = (minx, miny, minz);
		maxx = max(var_6024133d[0].origin[0], var_6024133d[1].origin[0]);
		maxy = max(var_6024133d[0].origin[1], var_6024133d[1].origin[1]);
		maxz = 10;
		level.var_ae7f6100 = (maxx, maxy, maxz);
	}
	var_fa52306b = (point[0], point[1], 0);
	return function_fc3f770b(level.var_3e5e898c, level.var_ae7f6100, var_fa52306b);
}

/*
	Name: function_415bdb1d
	Namespace: namespace_8f74625a
	Checksum: 0x19F59700
	Offset: 0x2A88
	Size: 0x13A
	Parameters: 15
	Flags: Linked, Private
*/
function private function_415bdb1d(einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, vdamageorigin, psoffsettime, damagefromunderneath, modelindex, partname, vsurfacenormal)
{
	if(isdefined(self.vehicletype) && self.vehicletype == "vehicle_t8_mil_helicopter_transport_dark_wz" && (max(self.health - idamage, 0)) <= 0)
	{
		return 0;
	}
	if((max(self.health - idamage, 0)) <= self.var_b9b5403c)
	{
		self thread function_500a6615();
		self thread function_ba3be344();
		self.var_b9b5403c = 0;
	}
	return idamage;
}

/*
	Name: function_9a275b1f
	Namespace: namespace_8f74625a
	Checksum: 0xF4481816
	Offset: 0x2BD0
	Size: 0x1BA
	Parameters: 15
	Flags: Linked, Private
*/
function private function_9a275b1f(einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, vdamageorigin, psoffsettime, damagefromunderneath, modelindex, partname, vsurfacenormal)
{
	newhealth = max(self.health - idamage, 0);
	var_d4bce8be = isdefined(self.scriptvehicletype) && self.scriptvehicletype == "player_tank";
	if(!var_d4bce8be && newhealth <= self.var_b9b5403c)
	{
		if(isdefined(self.var_b2513722))
		{
			var_b2513722 = self.var_b2513722;
			var_b2513722 thread function_500a6615();
			var_b2513722 thread function_ba3be344();
		}
		else
		{
			if(isdefined(self.supplydrop))
			{
				self.supplydrop function_71c31c8d();
				self thread function_546afbb6();
			}
			self.var_b9b5403c = 0;
		}
	}
	if(newhealth <= 0)
	{
		self unlink();
		self.health = idamage + 1;
	}
	return idamage;
}

/*
	Name: function_eafcba42
	Namespace: namespace_8f74625a
	Checksum: 0xD24F1E35
	Offset: 0x2D98
	Size: 0x206
	Parameters: 5
	Flags: Linked, Private
*/
function private function_eafcba42(startpoint, endpoint, droppoint, maxheight, minheight)
{
	points = [];
	startpoint = trace_point(startpoint);
	endpoint = trace_point(endpoint);
	var_bb96e272 = vectornormalize(endpoint - startpoint);
	pathlength = distance2d(startpoint, endpoint);
	var_28021cac = int(pathlength / 5000);
	points[0] = startpoint;
	if(isdefined(droppoint))
	{
		var_66d25ef4 = distancesquared(startpoint, droppoint);
	}
	for(var_c742cad6 = 1; var_c742cad6 <= var_28021cac; var_c742cad6++)
	{
		var_a1bc57e1 = startpoint + ((var_bb96e272 * 5000) * var_c742cad6);
		if(isdefined(droppoint))
		{
			if(distancesquared(startpoint, var_a1bc57e1) >= var_66d25ef4 && (distancesquared(startpoint, points[points.size - 1])) <= var_66d25ef4)
			{
				points[points.size] = droppoint;
			}
		}
		points[points.size] = trace_point(var_a1bc57e1, undefined, maxheight, minheight);
		waitframe(1);
	}
	points[points.size] = endpoint;
	return points;
}

/*
	Name: trace_point
	Namespace: namespace_8f74625a
	Checksum: 0x69971FB2
	Offset: 0x2FA8
	Size: 0x14C
	Parameters: 4
	Flags: Linked, Private
*/
function private trace_point(point, var_5fd22b95 = 1, maxheight = 10000, minheight = 5000)
{
	startpoint = (point[0], point[1], maxheight);
	endpoint = (point[0], point[1], minheight);
	trace = groundtrace(startpoint, endpoint, 0, undefined, var_5fd22b95);
	if(!var_5fd22b95)
	{
		if(trace[#"surfacetype"] == "water" || trace[#"surfacetype"] == "watershallow")
		{
			return;
		}
	}
	if(isdefined(trace[#"position"]))
	{
		return trace[#"position"] + vectorscale((0, 0, 1), 2000);
	}
	return startpoint;
}

/*
	Name: function_8234217e
	Namespace: namespace_8f74625a
	Checksum: 0x8D193BD0
	Offset: 0x3100
	Size: 0x11A
	Parameters: 2
	Flags: Linked, Private
*/
function private function_8234217e(var_faa1ea31, vectors)
{
	/#
		assert(vectors.size > 0);
	#/
	var_54b25053 = vectors[0];
	bestdot = vectordot(var_54b25053, var_faa1ea31);
	for(index = 1; index < vectors.size; index++)
	{
		var_7aa67ca6 = vectordot(vectors[index], var_faa1ea31);
		if(abs(var_7aa67ca6) > abs(bestdot))
		{
			var_54b25053 = vectors[index];
			bestdot = var_7aa67ca6;
		}
	}
	if(bestdot < 0)
	{
		var_54b25053 = var_54b25053 * -1;
	}
	return var_54b25053;
}

/*
	Name: function_a40836e
	Namespace: namespace_8f74625a
	Checksum: 0x3B4EAF6
	Offset: 0x3228
	Size: 0x102
	Parameters: 1
	Flags: Linked, Private
*/
function private function_a40836e(angles)
{
	axises = [];
	axises[axises.size] = anglestoforward(angles);
	axises[axises.size] = anglestoright(angles);
	axises[axises.size] = anglestoup(angles);
	var_553ec518 = (1, 0, 0);
	worldup = (0, 0, 1);
	newforward = function_8234217e(var_553ec518, axises);
	var_1883753b = function_8234217e(worldup, axises);
	newangles = axistoangles(newforward, var_1883753b);
	return newangles;
}

/*
	Name: function_924a11ff
	Namespace: namespace_8f74625a
	Checksum: 0x2424D61F
	Offset: 0x3338
	Size: 0x20C
	Parameters: 1
	Flags: Linked, Private
*/
function private function_924a11ff(itemspawnlist)
{
	/#
		assert(isdefined(itemspawnlist));
	#/
	self endon(#"death");
	self thread item_drop::function_10ececeb(1, 80, 24, vectorscale((-1, -1, 0), 25), (25, 25, 50));
	self waittill(#"stationary");
	var_e68facee = isdefined(self getlinkedent());
	self clientfield::set("supply_drop_fx", 1);
	if(!namespace_ad5a0cd6::function_74e1e547(self.origin))
	{
		self delete();
		return;
	}
	neworigin = self.origin + (anglestoup(self.angles) * 27.5);
	self.angles = function_a40836e(self.angles);
	self.origin = neworigin - (anglestoup(self.angles) * 27.5);
	self dontinterpolate();
	self setmodel("p8_fxanim_wz_supply_stash_04_mod");
	items = self namespace_65181344::function_5eada592(itemspawnlist, 1);
	wait(60);
	if(isdefined(self))
	{
		self clientfield::set("supply_drop_fx", 0);
	}
}

/*
	Name: function_9e8348e4
	Namespace: namespace_8f74625a
	Checksum: 0x4F7396B2
	Offset: 0x3550
	Size: 0x2C
	Parameters: 0
	Flags: Linked, Private
*/
function private function_9e8348e4()
{
	self waittill(#"death");
	self thread function_500a6615();
}

/*
	Name: function_c2edbefb
	Namespace: namespace_8f74625a
	Checksum: 0xF7BA0454
	Offset: 0x3588
	Size: 0x1D4
	Parameters: 4
	Flags: Linked, Private
*/
function private function_c2edbefb(path, droppoint, var_86928932 = 1, var_2118f785 = undefined)
{
	self endon(#"death", #"hash_57267dfd9e64c1c7");
	for(pathindex = 1; pathindex < path.size; pathindex++)
	{
		var_f155e743 = 0;
		if(isdefined(droppoint))
		{
			var_f155e743 = distancesquared(path[pathindex], droppoint) < (128 * 128);
		}
		self function_a57c34b7(path[pathindex], var_f155e743 && var_86928932, 0);
		while(true)
		{
			if(var_f155e743)
			{
				if(distancesquared(droppoint, self.origin) < 128 * 128)
				{
					if(var_86928932)
					{
						wait(2);
					}
					self thread function_500a6615(var_2118f785);
					if(var_86928932)
					{
						wait(1);
					}
					break;
				}
			}
			else if(distancesquared(path[pathindex], self.origin) < 1500 * 1500)
			{
				break;
			}
			waitframe(1);
		}
	}
	self delete();
}

/*
	Name: function_15945f95
	Namespace: namespace_8f74625a
	Checksum: 0xD735E859
	Offset: 0x3768
	Size: 0x70
	Parameters: 0
	Flags: None
*/
function function_15945f95()
{
	var_6024133d = getentarray("map_corner", "targetname");
	if(var_6024133d.size)
	{
		return math::find_box_center(var_6024133d[0].origin, var_6024133d[1].origin);
	}
	return (0, 0, 0);
}

/*
	Name: function_ab6af198
	Namespace: namespace_8f74625a
	Checksum: 0x5811A884
	Offset: 0x37E0
	Size: 0x118
	Parameters: 0
	Flags: None
*/
function function_ab6af198()
{
	var_6024133d = getentarray("map_corner", "targetname");
	if(var_6024133d.size)
	{
		x = abs(var_6024133d[0].origin[0] - var_6024133d[1].origin[0]);
		y = abs(var_6024133d[0].origin[1] - var_6024133d[1].origin[1]);
		var_e39b9b61 = max(x, y);
		var_e39b9b61 = var_e39b9b61 * 0.75;
		return math::clamp(var_e39b9b61, 10000, var_e39b9b61);
	}
	return 10000;
}

/*
	Name: function_261b0e67
	Namespace: namespace_8f74625a
	Checksum: 0x41EF782E
	Offset: 0x3900
	Size: 0x304
	Parameters: 5
	Flags: Linked, Private
*/
function private function_261b0e67(spawnpoint, endpoint, droppoint, var_d9151bd0 = 1, vehicleoverride = undefined)
{
	var_47736ddd = array(spawnpoint, droppoint, endpoint);
	var_7366c0ff = spawnvehicle((isdefined(vehicleoverride) ? vehicleoverride : "vehicle_t8_mil_helicopter_transport_dark_wz_infiltration"), spawnpoint, vectortoangles(vectornormalize(endpoint - spawnpoint)));
	if(!isdefined(var_7366c0ff))
	{
		return;
	}
	var_7366c0ff endon(#"death");
	var_7366c0ff setforcenocull();
	var_7366c0ff.goalradius = 128;
	var_7366c0ff.goalheight = 128;
	var_7366c0ff.health = 10000;
	var_7366c0ff setspeed(125);
	var_7366c0ff setrotorspeed(1);
	var_7366c0ff vehicle::toggle_tread_fx(1);
	var_7366c0ff vehicle::toggle_exhaust_fx(1);
	var_7366c0ff vehicle::toggle_sounds(1);
	for(pathindex = 1; pathindex < var_47736ddd.size; pathindex++)
	{
		var_f155e743 = 0;
		if(isdefined(droppoint))
		{
			var_f155e743 = distancesquared(var_47736ddd[pathindex], droppoint) < (128 * 128);
		}
		var_7366c0ff function_a57c34b7(var_47736ddd[pathindex], 0, 0);
		while(true)
		{
			if(var_f155e743)
			{
				if(distancesquared(droppoint, var_7366c0ff.origin) < 128 * 128)
				{
					if(var_d9151bd0)
					{
						fx = playfx("wz/fx8_death_circle_cue", var_7366c0ff.origin, (1, 0, 0), (0, 0, 1));
					}
					break;
				}
			}
			else if(distancesquared(var_47736ddd[pathindex], var_7366c0ff.origin) < 1500 * 1500)
			{
				break;
			}
			waitframe(1);
		}
	}
	var_7366c0ff delete();
}

/*
	Name: function_7d4a448f
	Namespace: namespace_8f74625a
	Checksum: 0xA247F2F0
	Offset: 0x3C10
	Size: 0x644
	Parameters: 1
	Flags: Linked
*/
function function_7d4a448f(var_47d17dcb = 0)
{
	if(!(isdefined(level.var_d8958e58) && level.var_d8958e58))
	{
		return;
	}
	if(!isdefined(level.var_fb91af8) || level.var_fb91af8.size <= 0)
	{
		return;
	}
	var_52b56362 = (isdefined(level.var_52b56362) ? level.var_52b56362 : 0);
	deathcircle = level.var_fb91af8[var_52b56362];
	var_448914c2 = (isdefined(level.var_fb91af8[var_52b56362 + 1]) ? level.var_fb91af8[var_52b56362 + 1] : deathcircle);
	if(var_47d17dcb)
	{
		var_448914c2 = level.var_fb91af8[level.var_fb91af8.size - 1];
	}
	var_94f13d8b = 18000;
	mapcenter = namespace_67838d10::function_15945f95();
	var_66b35636 = namespace_67838d10::function_ab6af198();
	var_e1ae630e = var_448914c2.origin;
	var_e1ae630e = (var_e1ae630e[0], var_e1ae630e[1], var_94f13d8b);
	var_4f59c30d = var_448914c2.radius;
	if(!function_16bbdd8b(var_e1ae630e))
	{
		return;
	}
	var_396cbf6e = deathcircle.radius;
	var_be734526 = deathcircle.radius - var_4f59c30d;
	if(var_be734526 > 0)
	{
		var_e7993c63 = vectornormalize(var_e1ae630e - (deathcircle.origin[0], deathcircle.origin[1], var_94f13d8b));
		var_8df04549 = var_e1ae630e - (var_e7993c63 * var_4f59c30d);
		exitpoint = var_e1ae630e + (var_e7993c63 * var_4f59c30d);
	}
	else
	{
		degrees = randomint(360);
		var_8df04549 = (cos(degrees) * var_4f59c30d, sin(degrees) * var_4f59c30d, 0) + var_e1ae630e;
		exitpoint = ((cos(degrees) * -1) * var_4f59c30d, (sin(degrees) * -1) * var_4f59c30d, 0) + var_e1ae630e;
	}
	waitframe(1);
	droppoint = var_e1ae630e;
	var_8df04549 = function_c7bd0aa8(var_8df04549, droppoint);
	exitpoint = function_c7bd0aa8(exitpoint, droppoint);
	var_bb96e272 = vectornormalize(exitpoint - var_8df04549);
	var_142db926 = 5000;
	var_a2712870 = distance2d(deathcircle.origin, var_e1ae630e);
	var_6eae2ffb = (var_396cbf6e + var_a2712870) + var_142db926;
	var_429b69c0 = max(var_6eae2ffb, 15000);
	var_e9e24bda = max(var_396cbf6e, 45000);
	spawnpoint = var_8df04549 - (var_bb96e272 * var_429b69c0);
	spawnpoint = function_c7bd0aa8(spawnpoint, droppoint);
	endpoint = exitpoint + (var_bb96e272 * var_e9e24bda);
	endpoint = function_c7bd0aa8(endpoint, droppoint);
	level thread function_261b0e67(spawnpoint, endpoint, droppoint, 1);
	angles = vectortoangles(var_bb96e272);
	rightoffset = vectornormalize(anglestoright(angles)) * 1024;
	leftoffset = rightoffset * -1;
	var_ae85ee87 = var_bb96e272 * -1024;
	vehicleoverride = undefined;
	offset = (rightoffset + var_ae85ee87) + (0, 0, randomintrange(25, 50));
	level thread function_261b0e67(spawnpoint + offset, endpoint + offset, droppoint + offset, 0, vehicleoverride);
	offset = (leftoffset + var_ae85ee87) + (0, 0, randomintrange(-50, -25));
	level thread function_261b0e67(spawnpoint + offset, endpoint + offset, droppoint + offset, 0, vehicleoverride);
}

/*
	Name: function_418e26fe
	Namespace: namespace_8f74625a
	Checksum: 0x29F6C352
	Offset: 0x4260
	Size: 0x64E
	Parameters: 6
	Flags: Linked
*/
function function_418e26fe(var_2118f785 = undefined, helicopter = 0, var_58ca2822 = 1, var_541c190b = 0, var_d6388d1 = 0, vehicletype = undefined)
{
	if(!(isdefined(level.var_d8958e58) && level.var_d8958e58))
	{
		return;
	}
	if(!isdefined(level.var_fb91af8) || level.var_fb91af8.size <= 0)
	{
		return;
	}
	var_f5f2246e = (helicopter ? 10000 : 35000);
	var_52b56362 = (isdefined(level.var_52b56362) ? level.var_52b56362 : 0);
	deathcircle = level.var_fb91af8[var_52b56362];
	var_448914c2 = (isdefined(level.var_fb91af8[var_52b56362 + 1]) ? level.var_fb91af8[var_52b56362 + 1] : deathcircle);
	if(helicopter)
	{
		var_729c4495 = 5000;
	}
	else
	{
		var_729c4495 = 20000;
	}
	var_729c4495 = var_729c4495 + var_541c190b;
	var_94f13d8b = 2000 + var_729c4495;
	mapcenter = namespace_67838d10::function_15945f95();
	var_66b35636 = namespace_67838d10::function_ab6af198();
	var_e1ae630e = var_448914c2.origin;
	var_e1ae630e = (var_e1ae630e[0], var_e1ae630e[1], var_94f13d8b);
	var_4f59c30d = var_448914c2.radius;
	if(!function_16bbdd8b(var_e1ae630e))
	{
		return;
	}
	var_396cbf6e = deathcircle.radius;
	var_be734526 = deathcircle.radius - var_4f59c30d;
	degrees = randomint(360);
	var_8df04549 = (cos(degrees) * var_4f59c30d, sin(degrees) * var_4f59c30d, var_94f13d8b) + var_e1ae630e;
	exitpoint = ((cos(degrees) * -1) * var_4f59c30d, (sin(degrees) * -1) * var_4f59c30d, var_94f13d8b) + var_e1ae630e;
	waitframe(1);
	var_e2be9787 = 10;
	droppoint = undefined;
	for(index = 0; index < var_e2be9787; index++)
	{
		randompoint = lerpvector(var_8df04549, exitpoint, randomfloatrange(0, 1));
		if(function_16bbdd8b(randompoint))
		{
			droppoint = trace_point(randompoint, 0, undefined, -5000);
			if(isdefined(droppoint) && !oob::chr_party(droppoint))
			{
				droppoint = trace_point(randompoint, 0, var_f5f2246e, var_729c4495);
				break;
			}
		}
		waitframe(1);
	}
	if(!isdefined(droppoint))
	{
		return;
	}
	var_8df04549 = function_c7bd0aa8(var_8df04549, droppoint);
	var_8df04549 = trace_point(var_8df04549, undefined, var_f5f2246e, var_729c4495);
	exitpoint = function_c7bd0aa8(exitpoint, droppoint);
	exitpoint = trace_point(exitpoint, undefined, var_f5f2246e, var_729c4495);
	var_bb96e272 = vectornormalize(exitpoint - var_8df04549);
	var_429b69c0 = max(var_396cbf6e, 15000);
	var_e9e24bda = max(var_396cbf6e, 45000);
	spawnpoint = var_8df04549 - (var_bb96e272 * var_429b69c0);
	spawnpoint = function_c7bd0aa8(spawnpoint, droppoint);
	endpoint = exitpoint + (var_bb96e272 * var_e9e24bda);
	endpoint = function_c7bd0aa8(endpoint, droppoint);
	if(helicopter)
	{
		var_57e06aea = function_47ec98c4(spawnpoint, endpoint, droppoint, var_d6388d1, vehicletype, var_f5f2246e, var_729c4495);
	}
	else
	{
		var_57e06aea = function_b8dd1978(spawnpoint, endpoint, droppoint, var_2118f785, var_58ca2822);
	}
	level.var_1b269b78 = var_8df04549;
	level.var_538928e3 = exitpoint;
}

/*
	Name: function_b8dd1978
	Namespace: namespace_8f74625a
	Checksum: 0xF08B34D8
	Offset: 0x48B8
	Size: 0x2A6
	Parameters: 5
	Flags: Linked
*/
function function_b8dd1978(startpoint, endpoint, droppoint, var_2118f785 = undefined, var_58ca2822 = 1)
{
	var_57e06aea = array(startpoint, droppoint, endpoint);
	var_b2513722 = spawnvehicle("vehicle_t8_mil_air_transport_infiltration", startpoint, vectortoangles(vectornormalize(endpoint - startpoint)));
	if(!isdefined(var_b2513722))
	{
		return;
	}
	var_b2513722 setforcenocull();
	if(var_58ca2822)
	{
		function_58ca2822("warSupplyDropIncoming");
	}
	var_b2513722.goalradius = 128;
	var_b2513722.goalheight = 128;
	var_b2513722.var_57e06aea = var_57e06aea;
	var_b2513722.maxhealth = var_b2513722.health;
	var_b2513722.var_b9b5403c = var_b2513722.maxhealth * 0.5;
	var_b2513722 setspeed(100);
	var_b2513722 setrotorspeed(1);
	var_b2513722 vehicle::toggle_tread_fx(1);
	var_b2513722 vehicle::toggle_exhaust_fx(1);
	var_b2513722 vehicle::toggle_sounds(1);
	var_b2513722.var_5d0810d7 = 1;
	supplydrop = function_67d7d040(var_b2513722);
	if(!isdefined(var_b2513722))
	{
		return;
	}
	supplydrop linkto(var_b2513722, "tag_origin", vectorscale((0, 0, -1), 120));
	var_b2513722.supplydrop = supplydrop;
	var_b2513722 thread function_c2edbefb(var_57e06aea, droppoint, 0, var_2118f785);
	var_b2513722 thread function_9e8348e4();
	level.var_a5f063d[level.var_a5f063d.size] = supplydrop;
	return var_57e06aea;
}

/*
	Name: function_47ec98c4
	Namespace: namespace_8f74625a
	Checksum: 0xA829CF0C
	Offset: 0x4B68
	Size: 0x3E6
	Parameters: 7
	Flags: Linked
*/
function function_47ec98c4(startpoint, endpoint, droppoint, var_d91c179d = 0, vehicletype = undefined, maxheight = undefined, minheight = undefined)
{
	if(isdefined(var_d91c179d) && var_d91c179d && !isdefined(vehicletype))
	{
		return;
	}
	var_57e06aea = function_eafcba42(startpoint, endpoint, droppoint, maxheight, minheight);
	/#
		assert(var_57e06aea.size >= 2);
	#/
	startpoint = var_57e06aea[0];
	endpoint = var_57e06aea[var_57e06aea.size - 1];
	var_b2513722 = spawnvehicle("vehicle_t8_mil_helicopter_transport_dark_wz", startpoint, vectortoangles(vectornormalize(endpoint - startpoint)));
	if(!isdefined(var_b2513722))
	{
		return;
	}
	var_b2513722 setforcenocull();
	function_58ca2822("warSupplyDropIncoming");
	target_set(var_b2513722, (0, 0, 0));
	var_b2513722.goalradius = 128;
	var_b2513722.goalheight = 128;
	var_b2513722.var_57e06aea = var_57e06aea;
	var_b2513722.maxhealth = var_b2513722.health;
	var_b2513722.var_b9b5403c = var_b2513722.maxhealth * 0.5;
	var_b2513722.overridevehicledamage = &function_415bdb1d;
	var_b2513722 setspeed(100);
	var_b2513722 setrotorspeed(1);
	var_b2513722 vehicle::toggle_tread_fx(1);
	var_b2513722 vehicle::toggle_exhaust_fx(1);
	var_b2513722 vehicle::toggle_sounds(1);
	var_b2513722.var_5d0810d7 = 1;
	if(var_d91c179d)
	{
		supplydrop = function_a3832aa0(var_b2513722, vehicletype);
	}
	else
	{
		supplydrop = function_67d7d040(var_b2513722);
	}
	supplydrop linkto(var_b2513722, "tag_cargo_attach", vectorscale((0, 0, -1), 45));
	var_b2513722.supplydrop = supplydrop;
	var_b2513722 thread function_c2edbefb(var_57e06aea, droppoint);
	var_b2513722 thread function_9e8348e4();
	level.var_a5f063d[level.var_a5f063d.size] = supplydrop;
	level.supplydrop = supplydrop;
	level.var_b2513722 = var_b2513722;
	level.var_57e06aea = var_57e06aea;
	level.var_daa6e3f = droppoint;
	level.var_d1c35a7a = startpoint;
	level.var_ebe9f3de = endpoint;
	return var_57e06aea;
}

/*
	Name: function_1b48df6d
	Namespace: namespace_8f74625a
	Checksum: 0x1FF3F868
	Offset: 0x4F58
	Size: 0x296
	Parameters: 4
	Flags: Linked
*/
function function_1b48df6d(droppoint, helicopter = 0, var_d6388d1 = 0, vehicletype = undefined)
{
	/#
		assert(isvec(droppoint));
	#/
	if(!function_16bbdd8b(droppoint))
	{
		return;
	}
	maxheight = (helicopter ? 10000 : 35000);
	minheight = (helicopter ? 5000 : 20000);
	droppoint = trace_point(droppoint, 0, maxheight, minheight);
	mapcenter = function_3c597e8d();
	var_7a66fccd = function_43e35f94();
	if(var_7a66fccd == 0)
	{
		var_7a66fccd = 10000;
	}
	var_b98da7dd = droppoint - mapcenter;
	var_b98da7dd = (var_b98da7dd[0], var_b98da7dd[1], 0);
	var_b98da7dd = vectornormalize(var_b98da7dd);
	spawnpoint = mapcenter + (var_b98da7dd * var_7a66fccd);
	spawnpoint = (spawnpoint[0], spawnpoint[1], droppoint[2]);
	spawnpoint = function_c7bd0aa8(spawnpoint, droppoint);
	endpoint = mapcenter - (var_b98da7dd * var_7a66fccd);
	endpoint = (endpoint[0], endpoint[1], droppoint[2]);
	endpoint = function_c7bd0aa8(endpoint, droppoint);
	if(helicopter)
	{
		var_57e06aea = function_47ec98c4(spawnpoint, endpoint, droppoint, var_d6388d1, vehicletype);
	}
	else
	{
		var_57e06aea = function_b8dd1978(spawnpoint, endpoint, droppoint);
	}
}

/*
	Name: function_8366d4d6
	Namespace: namespace_8f74625a
	Checksum: 0xA328D41
	Offset: 0x51F8
	Size: 0x8C
	Parameters: 2
	Flags: Linked
*/
function function_8366d4d6(spawnpoint, itemspawnlist)
{
	supplydrop = function_67d7d040(undefined);
	supplydrop.origin = spawnpoint;
	struct = spawnstruct();
	struct.supplydrop = supplydrop;
	struct thread function_500a6615(itemspawnlist);
}

