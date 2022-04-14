// If your map.gsc is around 50kb in size then you can find this on Line: 920 or so.

// If your nazi_zombie_MAPNAME.gsc is around 10kb then you are using the Dlc3_code file, you need to use the edited dlc3_code.gsc

// you can also just search for this "electric_trap_think( enable_flag )".


// Then just replace the old one with this.
electric_trap_think( enable_flag )
{	
	self sethintstring("turn power on");
	self.zombie_cost = 100;
	
	self thread electric_trap_dialog();

	// get a list of all of the other triggers with the same name
	triggers = getentarray( self.targetname, "targetname" );
	flag_wait( "electricity_on" );


	// Get the damage trigger.  This is the unifying element to let us know it's been activated.
	//self.zombie_dmg_trig = getEnt(self.target,"targetname");
	//self.zombie_dmg_trig.in_use = 0;

	// Set buy string
	self sethintstring("turn on trap [ cost: "+self.zombie_cost+"]");

	// Getting the light that's related is a little esoteric, but there isn't
	// a better way at the moment.  It uses linknames, which are really dodgy.
	light_name = "";	// scope declaration
	damage_trigger = "";
	tswitch = getent(self.script_linkto,"script_linkname");
	switch ( tswitch.script_linkname )
	{
	case "10":	// wnuenn
	case "11":
		light_name = "zapper_light_wuen";
		damage_trigger = "zapper_damage_wuen";
		break;

	case "20":	// warehouse
	case "21":
		light_name = "zapper_light_warehouse";
		damage_trigger = "zapper_damage_warehouse";
		break;

	case "30":	// Bridge
	case "31":
		light_name = "zapper_light_bridge";
		damage_trigger = "zapper_damage_bridge";
		break;
	}
	// Get the damage trigger.  This is the unifying element to let us know it's been activated.
	self.zombie_dmg_trig = getEnt(damage_trigger,"targetname");
	self.zombie_dmg_trig.in_use = 0;
	
	// The power is now on, but keep it disabled until a certain condition is met
	//	such as opening the door it is blocking or waiting for the bridge to lower.
	if ( !flag( enable_flag ) )
	{
		self trigger_off();
		zapper_light_red( light_name );
		flag_wait( enable_flag );
		self trigger_on();
	}
	
	// Open for business!  
	zapper_light_green( light_name );
	
	while(1)
	{
		//valve_trigs = getentarray(self.script_noteworthy ,"script_noteworthy");		
	
		//wait until someone uses the valve
		self waittill("trigger",who);
		if( who in_revive_trigger() )
		{
			continue;
		}
		
		if( is_player_valid( who ) )
		{
			if( who.score >= self.zombie_cost )
			{				
				if(!self.zombie_dmg_trig.in_use)
				{
					self.zombie_dmg_trig.in_use = 1;

					//turn off the valve triggers associated with this trap until available again
					array_thread (triggers, ::trigger_off);

					play_sound_at_pos( "purchase", who.origin );
					self thread electric_trap_move_switch(self);
					//need to play a 'woosh' sound here, like a gas furnace starting up
					self waittill("switch_activated");
					//set the score
					who maps\_zombiemode_score::minus_to_player_score( self.zombie_cost );

					//this trigger detects zombies walking thru the flames
					self.zombie_dmg_trig trigger_on();

					//play the flame FX and do the actual damage
					self thread activate_electric_trap();					

					//wait until done and then re-enable the valve for purchase again
					self waittill("elec_done");
					
					clientnotify(self.script_string +"off");
										
					//delete any FX ents
					if(isDefined(self.fx_org))
					{
						self.fx_org delete();
					}
					if(isDefined(self.zapper_fx_org))
					{
						self.zapper_fx_org delete();
					}
					if(isDefined(self.zapper_fx_switch_org))
					{
						self.zapper_fx_switch_org delete();
					}
										
					//turn the damage detection trigger off until the flames are used again
			 		self.zombie_dmg_trig trigger_off();
					wait(25);

					array_thread (triggers, ::trigger_on);

					//COLLIN: Play the 'alarm' sound to alert players that the traps are available again (playing on a temp ent in case the PA is already in use.
					//speakerA = getstruct("loudspeaker", "targetname");
					//playsoundatposition("warning", speakera.origin);
					self notify("available");

					self.zombie_dmg_trig.in_use = 0;
				}
			}
		}
	}
}