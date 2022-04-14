/* Sweet player controlled airstrike stuff

To use:

Call this line above _load:
	thread maps\_dpad_asset::rocket_barrage_init(); 

Call this line in your onPlayerSpawn function in your level:
		self thread maps\_dpad_asset::rocket_barrage_player_init();


You probably want to set up a level.radioguy for communication with the player.

Those string are the targetnames of script_structs in the map. 

*/
#include maps\_utility;
#include common_scripts\utility;
#include maps\_vehicle;
#include maps\hol2;
#using_animtree ("generic_human");

// needs to be called above _load in your level
airstrike_init()
{	
	level._effect["target_smoke"]				= loadfx ("env/smoke/fx_smoke_ground_marker_green_w");
	level._effect["rocket_trail"]				= loadfx("weapon/rocket/fx_lci_rocket_geotrail");
	level._effect["grenade_smoke"]			= loadfx("weapon/grenade/fx_smoke_grenade_generic");
	level._effect["air_napalm"]					= loadfx("maps/pel1/fx_napalm_midair_burst");
	
	level.rocketbarrage_traceLength = 4000;			// the furthest distance the player can fire
	level.barrage_charge_time = 30; 						// time in seconds until player can use again
	level.rocket_barrage_allowed = false;				// is the barrage allowed to be used now?
	level.friendly_check_radius = 700;					// friendlies in this radius will diallow barrage use
	

}

// needs to be threaded on each player in your onSpawn function in your level
airstrike_player_init()
{	
	self.rocket_targeting_on = false;							// is the player targeting at the moment?
	self.is_firing_rocket_barrage = false;				// the barrage being fired by the player?
	self.rocket_barrages_remaining = 3;						// number of barrages left
	self.rockets_are_out_times = 0;								// this is for the radio guys dialogue: keeping tally on how many barrages you have left
	self.rocket_barrage_friendly_fire_count = 0;	// this is for the radio guys dialogue: you aimed at an enemy
	self.rocket_barrage_ai_was_hit = false;				// this is for the radio guys dialogue: was enemy hit?
	self.rocket_barrage_ok = false;								// is the barrage fire valid?	
	
	self thread rocket_barrage_watcher();	
	self thread rocket_barrage_hud_elements_think();
}

// this basically stays on, looping. this keeps an eye on everything, allows, targeting
// etc.
rocket_barrage_watcher()
{
	self endon ("death");													// remember to put these on player functions for co-op
	self endon ("disconnect");										// remember to put these on player functions for co-op
	
	// Saftey checks		
	if (!isdefined(self.is_firing_rocket_barrage))
	{
		return;
	}
	
	if (!isdefined(level.rocket_barrage_allowed))
	{
		return;
	}
	
	for(;;)
	{
		// if the player isn't firing and firing is allowed at the moment
		if (!self.is_firing_rocket_barrage && level.rocket_barrage_allowed )
		{
			weap = self getcurrentweapon();
			
			// if the weapons is the rocket barrage and targeting isnt on
			if(self getcurrentweapon() == "rocket_barrage" && !self.rocket_targeting_on)
			{
				// begin targeting (smoke)
				self thread rocket_barrage_targeting();
				self.rocket_targeting_on = true;
				
				wait 0.5;		
			}	
			// if the weapon is rocket barrage and you're already targeting, turn it off
			else if(self getcurrentweapon() != "rocket_barrage" && self.rocket_targeting_on)
			{
				self.Rocket_Targeting_On = false;
							
				self notify("end rocket barrage targeting");	
				
				delete_spotting_target();
				
				wait 0.5;		
			}	
		}
		// if player is firing and the barrage is allowed
		else if (self.is_firing_rocket_barrage && level.rocket_barrage_allowed)
		{
			// if the player is trying to fire while the barrage is going, send a notify
			if(self getcurrentweapon() == "rocket_barrage")
			{
				self notify ("activate pressed during barage");
				wait 0.1;
			}
		}
		
		wait (0.05);
	}
}

// Targeting thread, sets up the drawing of smoke
rocket_barrage_targeting()
{
	self endon ("end rocket barrage targeting");		
	self endon ("rocket barrage firing");
	self endon ("death");
	self endon ("disconnect");
				
	self notify("start rocket barrage targeting");	
	
	// targetpoint is a script_model with tag_origin, using playfxon tag for the smoke.
	// model moves around as player looks around
	targetpoint = spawn("script_model", get_players()[0].origin);
	targetpoint setmodel("tag_origin");
	self.rocket_barrage_target = targetpoint;
	
	wait (0.1);

	//self disableweapons();
		
	thread draw_smoke(targetpoint);

	for (;;)
	{

		// Trace to where the player is looking
		direction = self getPlayerAngles();
		direction_vec = anglesToForward( direction );
		eye = self getEye();
		
		// offset 2 units on the Z to fix the bug where it would drop through the ground sometimes
		trace = bullettrace( eye, eye + vector_multiply( direction_vec , level.rocketbarrage_traceLength ), 0, undefined );
		trace2 = bullettrace(  trace["position"]+(0,0,2),  trace["position"] - (0,0,100000), 0, undefined );
		
		// debug		
		//thread draw_line_for_time( eye, trace2["position"], 1, 0, 0, 0.05 );
		
		targetpoint.origin = trace2["position"];
		
		friends = getaiarray("allies");
		players = get_players();
		
		friends = array_merge(friends, players);
		
		for (i = 0; i < friends.size; i++)
		{
			if (distance(targetpoint.origin, friends[i].origin) > level.friendly_check_radius)
			{
				self.rocket_barrage_ok = true;
			}
			else
			{
				self.rocket_barrage_ok = false;		// disallow if friends and players are nearby
			}
		}
		
		self thread rocket_barrage_fire_watch(targetpoint.origin);
		
		wait (0.05);
	}
}

// draws the smoke every 2 frames or so
draw_smoke(targetpoint)
{
		self endon ("target smoke deleted");
		self endon ("death");
		self endon ("disconnect");
			
		wait (0.1);
		while (1)
		{
			playfxontag(level._effect["target_smoke"], targetpoint, "tag_origin");	
			wait 0.1;
		}
}

// this handles a lot of the radio guy functionality, what he says, etc.
// also tracks how many barrages are left.
rocket_barrage_fire_watch(fire_point)
{		
	self endon ("death");
	self endon ("disconnect");
		
		// confirming the player's fire
		if(self attackbuttonPressed( ) && !self.is_firing_rocket_barrage && self.rocket_barrage_ok)
		{
				self.is_firing_rocket_barrage = true;
				self.rocket_targeting_on = false;
				
				if (self.rocket_barrages_remaining == 3)
				{
					level thread rocket_barrage_radio_guy( "confirm_fire1" );
				}
				else if (self.rocket_barrages_remaining == 2)
				{
					level thread rocket_barrage_radio_guy( "confirm_fire2" );
				}
				else if (self.rocket_barrages_remaining == 1)
				{
					level thread rocket_barrage_radio_guy( "confirm_fire3" );
				}
								
				self.rocket_barrages_remaining--;				
				self thread rocket_barrage_fire(fire_point);
		}	
		// letting the player know how many shots are left
		else if(self attackbuttonPressed( ) && !self.is_firing_rocket_barrage && self.rocket_barrages_remaining <= 0)
		{
			if (self.rockets_are_out_times == 0)
			{
				level thread rocket_barrage_radio_guy( "0left1" );
				self.rockets_are_out_times++;
			}
			else if (self.rockets_are_out_times == 1)
			{
				level thread rocket_barrage_radio_guy( "0left2" );
				self.rockets_are_out_times++;
			}
			else if (self.rockets_are_out_times == 2)
			{
				level thread rocket_barrage_radio_guy( "0left3" );
				self.rockets_are_out_times = 0;
			}
		}
		// friendly fire! not firing!
		else if (self attackbuttonPressed( ) && !self.is_firing_rocket_barrage && !self.rocket_barrage_ok)
		{
			if (self.rocket_barrage_friendly_fire_count == 0)
			{
				level thread rocket_barrage_radio_guy( "friendly_fire1" );
				self.rocket_barrage_friendly_fire_count++;
			}
			else if (self.rocket_barrage_friendly_fire_count == 1)
			{
				level thread rocket_barrage_radio_guy( "friendly_fire2" );
				self.rocket_barrage_friendly_fire_count = 0;
			}
		}
}

rocket_barrage_fire(firepoint)
{
	self endon ("death");
	self endon ("disconnect");
	fire_point = spawn("script_origin", firepoint);
	
			// check where the firepoint is
	if (level.script == "hol2")
	{
		level notify ("airstrike_called");
				// near woodstiger
		woodstiger_area = getentarray("woodstiger_airstrike_area", "targetname");
		for (i=0; i < woodstiger_area.size; i++)
		{
			if (fire_point istouching(woodstiger_area[i]))
			{
				if (flag("woodstiger_inplace"))
				{
					thread call_airstrike("woodstiger", fire_point);
				}
				else
				{
					thread call_strafing_run("woodstrafe", fire_point);
				}
			}
		}

				// near gulchtiger
		gulchtiger_area = getentarray("gulchtiger_airstrike_area", "targetname");
		for (i=0; i < gulchtiger_area.size; i++)
		{
			if (fire_point istouching(gulchtiger_area[i]))
			{
				if (flag("gulchtiger_inplace")&& !flag("gulchtiger_inloop"))
				{
					thread call_airstrike("gulchtiger", fire_point);
				}
				else
				{
					thread call_strafing_run("gulchstrafe", fire_point);
				}
			}
		}
		
				// in front of graveyard
		f_gyard_area = getentarray("front_graveyard_strafing_area", "targetname");
		for (i=0; i < f_gyard_area.size; i++)
		{
			if (fire_point istouching(f_gyard_area[i]) && !flag("gulchtiger_inloop"))
			{
				thread call_strafing_run("gravefront", fire_point);
			}
			else if (fire_point istouching(f_gyard_area[i]) && flag("gulchtiger_inloop"))
			{
				thread call_airstrike("woodstiger", fire_point);
			}
		}
		hq_area = getentarray("hq_strafing_area", "targetname");
		for (i=0; i < hq_area.size; i++)
		{
			if (fire_point istouching(hq_area[i]))
			{
				thread call_strafing_run("hq", fire_point);
			}
		}
		
		churchside_area = getentarray("churchside_strafing_Area", "targetname");
		for (i=0; i < churchside_area.size; i++)
		{
			if (fire_point istouching(churchside_area[i]))
			{
				thread call_strafing_run("churchside", fire_point);
			}
		}
		
		flak_area = getentarray("flak_strafing_area", "targetname");
		for (i=0; i < flak_area.size; i++)
		{
			if (fire_point istouching(flak_area[i]))
			{
				thread call_strafing_run("flak", fire_point);
			}
		}
		
		
	}
	
			
			
	self notify ("rocket barrage firing");
		
	// remove smoke
	delete_spotting_target();
	
	// wait until recharge	
	wait (level.barrage_charge_time);
	




	self.rocket_barrage_ai_was_hit = false;
	
	// reset weaqpons ammo after recharge
	self SetWeaponAmmoClip( "rocket_barrage", 1 );
	
	self notify ("rocket barrage recharging");
	self.rocket_barrage_fired_at_time = gettime();
	
	self.is_firing_rocket_barrage = false;
}

// rocket barrage is actually firing now
//       This stuff is from before I hol2ized it


// get rid of the spotting target, just delete it
delete_spotting_target()
{
	self endon ("death");
	self endon ("disconnect");
			
	if (isdefined(self.rocket_barrage_target))
	{
		self.rocket_barrage_target delete();
	}	
	self notify ("target smoke deleted");
			
}

// sets up the hud bar for the player, kinda buggy (flashes when you fire),
// might be handled in code later, but at least this works for now
rocket_barrage_hud_elements_think()
{
	self endon ("death");
	self endon ("disconnect");
			
	x_placement = 100;
	y_placement = 425;
	
	barsize_x = 72;
	barsize_y = 10;
	bar_difference_x = 6;
	bar_difference_y = 4;
	
	// background bar
	self.rocket_hud_elem_background = newclienthudelem(self);	
	self.rocket_hud_elem_background.x = x_placement;
	self.rocket_hud_elem_background.y = y_placement;
	self.rocket_hud_elem_background setshader( "black", barsize_x, barsize_y );
	self.rocket_hud_elem_background.alignX = "left";
	self.rocket_hud_elem_background.alignY = "bottom";
	self.rocket_hud_elem_background.alpha =1;
	self.rocket_hud_elem_background.foreground = true;
	self.rocket_hud_elem_background.sort = 1;	

	// foreground bar
	self.rocket_hud_elem_foreground = newclienthudelem(self);
	self.rocket_hud_elem_foreground.x = x_placement + (bar_difference_x / 2);
	self.rocket_hud_elem_foreground.y = y_placement - (bar_difference_y / 2);
	self.rocket_hud_elem_foreground setshader( "white", (barsize_x - bar_difference_x) , (barsize_y - bar_difference_y) );
	self.rocket_hud_elem_foreground.alignX = "left";
	self.rocket_hud_elem_foreground.alignY = "bottom";
	self.rocket_hud_elem_foreground.alpha = 1;	
	self.rocket_hud_elem_foreground.foreground = true;
	self.rocket_hud_elem_foreground.sort = 2;	
	
	thread rocket_barrage_hud_elements_show();
			
	while (1)
	{
		self waittill ("rocket barrage firing");
		self.rocket_hud_elem_foreground	ScaleOverTime( 0.05, 1, (barsize_y - bar_difference_y) );
		self.rocket_hud_elem_foreground.color = (1,0,0);
		wait (0.05);
		self.rocket_hud_elem_foreground	ScaleOverTime( level.barrage_charge_time - 0.05, (barsize_x - bar_difference_x), (barsize_y - bar_difference_y) );
		wait (level.barrage_charge_time / 3);
		self.rocket_hud_elem_foreground.color = (1,0.5,0);		
		wait (level.barrage_charge_time / 3);
		self.rocket_hud_elem_foreground.color = (1,1,0);		
		wait (level.barrage_charge_time / 3);
		self.rocket_hud_elem_foreground.color = (1,1,1);				
	}
}

// display / turn off the hud elems depending on notifies
rocket_barrage_hud_elements_show()
{
	self endon ("death");
	self endon ("disconnect");
			
	while (1)
	{
			self.rocket_hud_elem_background.alpha = 0;
			self.rocket_hud_elem_foreground.alpha = 0;
			self waittill_any ("start rocket barrage targeting", "activate pressed during barage");		
			self.rocket_hud_elem_background.alpha = 1;
			self.rocket_hud_elem_foreground.alpha = 1;
			self waittill_any ("end rocket barrage targeting", "rocket barrage firing", "activate pressed during barage" );	
	}
}

// the actual sounds for the guy to play depending on the anim_sound, which is a string
rocket_barrage_radio_guy( anim_sound )
{
	/*
	if (isdefined(level.radioguy.isplayingsound) && level.radioguy.isplayingsound)
	{
		return;
	}
	
	switch( anim_sound )
	{
		case "init":
			level.radioguy playsound ("Pel01_G2A_RADI_004A", "sounddone");	// called
			level.radioguy.isplayingsound = true;
			break;
	}
	// make sure his sounds dont overlap
	level.radioguy waittill ("sounddone");
	level.radioguy.isplayingsound = false;
	*/
}



// check to see if AI are nearby the impacts
rocket_barrage_check_if_ai_hit(damageradius, hitpoint, which_player)
{
	ai = getaiarray("axis");
	
	for (i = 0; i < ai.size; i++)
	{
		if (isdefined (ai[i]))
		{
			if (distance(hitpoint, ai[i].origin) < damageradius)
			{
				if (isdefined(which_player))
				{
					which_player.rocket_barrage_ai_was_hit = true;
				}
			}
		}
	}
}

strafe_go(spawngroup, runpath, fire_point)
{
	scripted_spawn_go(spawngroup);
	wait 0.3;
	spitfire = getent("spitfire_at_"+runpath, "targetname");
	spitfire startpath();
	firenode = getvehiclenode (runpath+"1_start_fire", "script_noteworthy");
	endnode =  getvehiclenode (runpath+"1_end_fire", "script_noteworthy");
	spitfire thread custom_strafe(fire_point,firenode, endnode );
		
	wait 1.5;
	spitfire = getent("spitfire_at_"+runpath+"2", "targetname");
	spitfire startpath();
	firenode = getvehiclenode (runpath+"2_start_fire", "script_noteworthy");
	endnode =  getvehiclenode (runpath+"2_end_fire", "script_noteworthy");
	spitfire thread custom_strafe(fire_point,firenode, endnode );
}

call_strafing_run(runpath, fire_point)
{
	if (runpath == "gravefront")
	{
		level thread strafe_go(8,runpath,fire_point);
	}
	
	if (runpath == "hq")
	{
		level thread strafe_go(100,runpath, fire_point);
	}
	
	if (runpath == "churchside")
	{
		level thread strafe_go(101,runpath, fire_point);
		
	}
	
	if (runpath == "flak")
	{
		level thread strafe_go(102, runpath, fire_point);
	}
	if (runpath == "woodstrafe")
	{
		level thread strafe_go(120,runpath,fire_point);
	}
	if (runpath == "gulchstrafe")
	{
		level thread strafe_go(121, runpath, fire_point);
	}
		
}

call_airstrike(runpath, fire_point)
{
	if (runpath == "woodstiger")
	{
		level thread strafe_go(7, runpath, fire_point);
		woods_tiger = getent("woods_tiger", "targetname");
		gulch_tiger = getent("gulch_tiger", "targetname");
		getvehiclenode ("woodstiger2_end_fire", "script_noteworthy") waittill ("trigger");
		woods_tiger.health = 2;
		wait 1;
		if (isdefined(gulch_tiger) && gulch_tiger.health > 1 && flag("gulchtiger_inloop"))
		{
			gulch_tiger.health = 2;
			radiusdamage(gulch_tiger.origin, 1000, 10000,8000);
			flag_set("gulchtiger_dead");
		}
		if (isdefined(woods_tiger)&& woods_tiger.health > 1)
		{
			radiusdamage(woods_tiger.origin, 1000, 10000,8000);
			// wait for a plane to hit this node, then just blow up all the enemies with timed intervals
		}


		flag_set("woodstiger_dead");
	}
	
	if (runpath == "gulchtiger")
	{
		level thread strafe_go(22, runpath, fire_point);
		node = getvehiclenode("gulchtiger1_end_fire", "script_noteworthy");
		node waittill ("trigger"); 
		
		gulch_panzer = getent("gulch_panzer", "targetname");
		if (isdefined(gulch_panzer))
			gulch_panzer.health = 2;
		flag_set("planes_came");
	
		gulch_tiger = getent("gulch_tiger", "targetname");
		if (isdefined(gulch_tiger))
			gulch_tiger.health = 2;

		wait 1;
		if (isdefined(gulch_tiger) && gulch_tiger.health > 0)
		{
			radiusdamage(gulch_tiger.origin, 500, 2000,800);
		}
		
		if (isdefined(gulch_panzer) && gulch_panzer.health > 0)
		{
			radiusdamage(gulch_panzer.origin, 500, 2000,800);
		}
		flag_set("gulchtiger_dead");
	}
}



callStrike_bombEffect( plane )
{

		bomb = spawnbomb( plane.origin, plane.angles );
		bomb moveGravity( vector_scale( anglestoforward( plane.angles ), 2000 ), 2 );
		bomb thread maps\_planeweapons::bomb_wiggle();
		trace_dist = 64;
	
	while( 1 )
	{
		vec1 = bomb.origin;
		direction = AnglesToForward( ( 90, 0, 0 ) );
		vec2 = vec1 + vectorScale( direction, 10000 );
		trace_result = BulletTrace( vec1, vec2, false, undefined );

		dist = Distance( bomb.origin, trace_result["position"] );
//		println( "Dist ", dist );

		//if( !IsDefined( old_dist ) )
		// Check the distance, in order to blow up... Failsafe, if the bomb happened to go through the ground
		// the >= 10000 should pickup and blowup.
		if( dist < trace_dist || dist >= 10000 )
		{
				break;
		}

//		if( IsDefined( self.origin ) )
//		{
//			print3d( ( self.origin +( 0, 0, 16 ) ), self.origin, ( 1, 1, 1 ), 1, 1 );
//			print3d( ( self.origin +( 0, 0, 32 ) ), dist, ( 1, 1, 1 ), 1, 1 );
//			print3d( ( self.origin +( 0, 0, 48 ) ), trace_result["surfacetype"], ( 1, 1, 1 ), 1, 1 );
//		}
//		line( vec1, trace_result["position"] );

		wait( 0.05 );
	}
		
		
		
		bombOrigin = bomb.origin;
		bombAngles = bomb.angles;
		playfx( level._effect["snow_exp"], bomb.origin );

		radiusDamage( bomb.origin, 512, 400, 30); 
		bomb delete();
}


spawnbomb( origin, angles )
{
	bomb = spawn( "script_model", origin );
	bomb.angles = angles;
	bomb setModel( "aircraft_bomb" );
	
	return bomb;
}

vector_scale(vec, scale)
{
	vec = (vec[0] * scale, vec[1] * scale, vec[2] * scale);
	return vec;
}

plane_shake_player()
{
	self endon ("death");
	breakit = 0;
	while (breakit ==0)
	{
		players = get_players();
		for (i=0; i < players.size; i++)
		{
			dist = distance(players[i].origin, self.origin);
			if (dist < 3300)
			{
				wait 0.3;
				earthquake(0.2, 4.5, players[i].origin, 1000);
				breakit++;
				break;
			}
		}
		wait 0.2;
	}
}

custom_strafe(o_spot, startfire_node, endfire_node)
{
	self thread plane_shake_player();
	self endon ("death");
	spot = spawn("script_origin", o_spot.origin);
			// ticks a var once the stopfire node is hit and stops firing
	startfire_node waittill_trig_n_notify("empty_notify", self);
	
	self.ticker = 0;
			// ticks a var once the stopfire node is hit and stops firing
	endfire_node thread trig_node_tick(self);
	
	vec =  self.origin - spot.origin;
	groundvec = (self.origin[0], self.origin[1], spot.origin[2]) - spot.origin;
	n_groundvec = vectornormalize(groundvec);
	spot.origin = spot.origin + (n_groundvec*2000);
	while(1)
	{
		spot.origin = spot.origin - (n_groundvec*250);
		vec =  self.origin - spot.origin;
		dist = distance(spot.origin, self.origin);
		groundvec = (self.origin[0], self.origin[1], spot.origin[2]) - spot.origin;
		n_groundvec = vectornormalize(groundvec);
		
		ground_ang = vectortoangles( n_groundvec );
		groundr_ang = anglestoright(ground_ang);
		groundr_vec = vectornormalize(groundr_ang);
		
		rspot = spot.origin - (groundr_vec*75);
		lspot = spot.origin + (groundr_vec*75);
		
		lgun = self gettagorigin("tag_gunLeft");
		rgun = self gettagorigin("tag_gunRight");
		
		
		angle = vectortoangles( vec );;
		self.angles = (angle);
		
		wait 0.1;
		magicbullet("m1a1_coaxial_mg", rgun, rspot);
		bullettracer(rgun, rspot, true);
		throughvec = vectornormalize(rgun - rspot);
		trace = bulletTrace( rgun, rspot, false, undefined );
		traceHit = trace["position"];
		dist = distance(tracehit, spot.origin);
		
				// this loop is because the bullets are hitting the skybox and/or portal brushes
		if (dist > 2000)
		{
			counter = 0;
			while (dist > 4000 || counter < 10)
			{
				rgun = rgun - (throughvec*1000);
				magicbullet("m1a1_coaxial_mg", rgun, rspot);
				bullettracer(rgun, rspot, true);
				trace = bulletTrace( rgun, rspot, false, undefined );
				traceHit = trace["position"];
				dist = distance(tracehit, spot.origin);
				counter ++;
				wait 0.001;
			}
		}
		playfx (level._effect["snow_exp"], traceHit);
		traceHit = trace["position"];
		dist = distance(tracehit, get_players()[0].origin);
		if (dist > 150)
		{
			radiusdamage(tracehit, 150, 1000, 500);
		}
		
		
		
		magicbullet("m1a1_coaxial_mg", lgun, lspot);
		bullettracer(lgun, lspot, true);
		trace = bulletTrace( self.origin, lspot, false, undefined );
		traceHit = trace["position"];
		dist = distance(tracehit, get_players()[0].origin);
		if (dist > 150)
		{
			radiusdamage(tracehit, 150, 1000, 500);
		}
		
		if (self.ticker > 0)
			break;

	}
	spot delete();
}

trig_node_tick(plane)
{
	while (1)
	{
		self waittill ("trigger", triggerer);
		if (plane == triggerer)
			break;
	}
	plane.ticker ++;
}
	