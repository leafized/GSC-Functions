
#include maps\_vehicle;
#include maps\_vehicle_aianim;
#include maps\_utility;
#include common_scripts\utility;
#using_animtree( "vehicles" );

main( model, type )
{
	// set up some default values.
	if( !IsDefined( model ) )
	{
		model = "vehicle_usa_aircraft_f4ucorsair";
	}
	
	if( !IsDefined( type ) )
	{
		type = "player_corsair";
	}

	// set up the vehicle. (see _vehicle for nicely commented explanations of these functions.)
	build_template( type, model, undefined );
	build_localinit( ::init_local );
	build_deathmodel( model, "vehicle_usa_aircraft_f4ucorsair" );  // TODO change to actual deathmodel when we get it
	build_deathfx( "explosions/large_vehicle_explosion", undefined, "explo_metal_rand" );  // TODO change to actual explosion fx/sound when we get it
	build_life( 99999, 5000, 15000 );
	build_team( "allies" );

//	
//	// Bomb stuff: TODO update with actual explosion fx, sound, and bomb model when we get them
//	//  quakepower, quaketime, quakeradius, range, min_damage, max_damage
//	maps\_planeweapons::build_bomb_explosions( type, 0.5, 2.0, 1024, 768, 400, 25 );
//	maps\_planeweapons::build_bombs( type, "com_trashbag", "explosions/fx_mortarExp_dirt", "artillery_explosion" );
	
//	// turret stuff: TODO update with actual turret models and types when we get them
//	turretType = "stuka_mg";
//	turretModel = "weapon_miniturret_crusader2";
//	build_turret( turretType, "tag_gunLeft", turretModel, true );
//	build_turret( turretType, "tag_gunRight", turretModel, true );
	// end turret stuff

//	precache_instruments();
	precache_models();
	init_hud_shaders();
	init_weapons( type );
}

precache_instruments()
{
//	PrecacheShader( "corsair_altimeter" );
//	PrecacheShader( "corsair_attitude" );
//	PrecacheShader( "corsair_speed" );
//	PrecacheShader( "corsair_heading" );
}

precache_models()
{
	PrecacheModel( "tag_origin" );
}

init_hud_shaders()
{
	add_shader( "waypoint", "aircraft_bomb_indicator" );
	add_shader( "waypoint_offscreen", "aircraft_indicator_icon_green" );

	add_shader( "ground_target", "aircraft_bomb_indicator" );
	add_shader( "air_target", "aircraft_enemy_indicator" );
	add_shader( "air_target_offscreen", "aircraft_indicator_icon_red" );
	add_shader( "air_friendly_offscreen", "aircraft_indicator_icon_red" );
}

add_shader( shader_reference, shader_name )
{
	PrecacheShader( shader_name );

	if( !IsDefined( level.hud_shaders ) )
	{
		level.hud_shaders = [];
	}

	level.hud_shaders[shader_reference] = shader_name;
}

init_local()
{
	self thread wait_for_pilot();
	self give_weapons();
}

kill_driver()
{
	println("******************KILLING DRIVER");
	driver = self getvehicleowner();
	
	if ( isdefined(driver) )
	{
		driver DoDamage( driver.health + 1, ( 0, 0, 0 ) ); 
	}	
}


// This waits for a player to become the pilot and sets everything up.
wait_for_pilot()
{
	if( IsDefined( self.wait_for_pilot ) && !self.wait_for_pilot )
	{
		return;
	}

	self MakeVehicleUsable();
	self.team = "allies";
	self.gforce = 0;

	self waittill( "trigger", other );
	other thread g_force( self );
	other thread instruments( self );
	self thread weapon_management();
}

//-------------//
// Instruments //
//-------------//

// Sets up and calculates the instruments for the plane.
instruments( plane )
{
	// Left side
	inner_x = 64;
	inner_y = 390;

	// Right Side
	outter_x = 128;
	inner_y = 422;	

	heading_shader 		= set_instrument( undefined, 35, 420 );
	heading_shader SetText( "Heading:");
	heading_shader.alignX = "right";

	heading_text		= set_instrument( undefined, 40, 420 );
	heading_text.alignX = "left";

//	attitude_shader 	= set_instrument( undefined, 128, 422 );
//	attitude_text 		= set_instrument( undefined, 128, 422 );

	altimeter_shader 	= set_instrument( undefined, 35, 435 );
	altimeter_shader SetText( "Altitude:" );
	altimeter_shader.alignX = "right";

	altimeter_text 		= set_instrument( undefined, 40, 435 );
	altimeter_text.alignX = "left";

	speed_shader 		= set_instrument( undefined, 35, 450 );
	speed_shader SetText( "Speed:" );
	speed_shader.alignX = "right";

	speed_text 			= set_instrument( undefined, 40, 450 );
	speed_text.alignX = "left";

	g_force_title = set_instrument( undefined, 35, 465 );
	g_force_title.alignX = "right";
	g_force_title SetText( "Gs:" );
	g_force_val = set_instrument( undefined, 40, 465 );
	g_force_val.alignX = "left";

	update_rate = 0.05;

	while( 1 )
	{
		wait( update_rate );

		// Atltitude
		alt = plane.origin[2] - level.sea_level;
		alt = int( alt / 12 );

		altimeter_text SetValue( alt );

		// Speed
		speed_text SetValue( int( plane GetSpeedMph() ) );

		// Heading
		heading = int( plane.angles[1] );

		heading_text SetValue( int( plane.angles[1] ) );

		// G-Force		
		g_force_val SetValue( plane.gforce );
	}
}

g_force( plane )
{
	plane endon( "death" );

	update_rate = 0.05;
	g_force_time = 1.0 / update_rate;
	playing_wingtip = false;

	wing_tip_l = undefined;
	wing_tip_r = undefined;

	curr_pos = plane.origin;
	curr_vel = ( 0, 0, 0 );
	while( 1 )
	{
		wait( update_rate );

		// G-Force		
		prev_pos = curr_pos;	
		prev_vel = curr_vel;
		curr_pos = plane.origin;
		curr_vel = vectorscale( curr_pos - prev_pos, g_force_time );
		accel = vectorscale( curr_vel - prev_vel, g_force_time );

		gravity = 1.0 / GetDvarFloat( "g_gravity" );
		g_force = ( accel[0] * gravity, accel[1] * gravity, accel[2] * gravity + 1 );
		
		plane_up = AnglesToUp( plane.angles );
		dot = vectordot( g_force, plane_up );

		plane.gforce = dot;

		if( !playing_wingtip && dot > 4 )
		{
			playing_wingtip = true;
			plane thread enable_wing_tip_trail();
		}
		else if( playing_wingtip && dot < 4 )
		{
			playing_wingtip = false;
			plane disable_wing_tip_trail();
		}
	}
}

enable_wing_tip_trail()
{
	self.wing_tip_fx_l = Spawn( "script_model", self GetTagOrigin( "tag_wingtipL" ) );
	self.wing_tip_fx_l SetModel( "tag_origin" );
	self.wing_tip_fx_l LinkTo( self, "tag_wingtipL", ( 0, 0, 0 ), ( 0, 0, 0 ) );
		
	self.wing_tip_fx_r = Spawn( "script_model", self GetTagOrigin( "tag_wingtipR" ) );
	self.wing_tip_fx_r SetModel( "tag_origin" );
	self.wing_tip_fx_r LinkTo( self, "tag_wingtipR", ( 0, 0, 0 ), ( 0, 0, 0 ) );

	wait( 0.05 );

	if( IsDefineD( self.wing_tip_fx_l ) )
	{
		PlayFXOnTag( level._effect["wing_tip"], self.wing_tip_fx_l, "tag_origin" );
	}

	if( IsDefineD( self.wing_tip_fx_r ) )
	{
		PlayFXOnTag( level._effect["wing_tip"], self.wing_tip_fx_r, "tag_origin" );
	}
}

disable_wing_tip_trail()
{
	if( IsDefineD( self.wing_tip_fx_l ) )
	{
		self.wing_tip_fx_l Delete();
	}

	if( IsDefineD( self.wing_tip_fx_r ) )
	{
		self.wing_tip_fx_r Delete();
	}
}

//---------------//
// Setup Weapons //
//---------------//
init_weapons( type )
{
	if( !IsDefined( level.aircraft_weapons ) || !IsDefined( level.aircraft_weapons[type] ) )
	{
		// Sets up the tags the weapons will use.
		weapon_tags = [];
//		weapon_tags["mg"][0] = "tag_flash";
//		weapon_tags["mg"][1] = "tag_flash1";
//		weapon_tags["rocket"][0] = "tag_smallbomb01Left";
//		weapon_tags["rocket"][1] = "tag_smallbomb01Right";
//		weapon_tags["rocket"][2] = "tag_smallbomb02Left";
//		weapon_tags["rocket"][3] = "tag_smallbomb02Right";
//		weapon_tags["rocket"][4] = "tag_smallbomb03Left";
//		weapon_tags["rocket"][5] = "tag_smallbomb03Right";
//		weapon_tags["bomb"][0] = "tag_smallbomb01Left";
//		weapon_tags["bomb"][1] = "tag_smallbomb01Right";

		weapon_tags["mg"][0] = "tag_flash";
		weapon_tags["mg"][1] = "tag_flash1";
		weapon_tags["mg"][2] = "tag_flash2";
		weapon_tags["mg"][3] = "tag_flash3";
		weapon_tags["mg"][4] = "tag_flash4";
		weapon_tags["mg"][5] = "tag_flash5";
		weapon_tags["rocket"][0] = "tag_rocket1_right";
		weapon_tags["rocket"][1] = "tag_rocket1_left";
		weapon_tags["rocket"][2] = "tag_rocket2_right";
		weapon_tags["rocket"][3] = "tag_rocket2_left";
		weapon_tags["rocket"][4] = "tag_rocket3_right";
		weapon_tags["rocket"][5] = "tag_rocket3_left";
		weapon_tags["rocket"][6] = "tag_rocket4_right";
		weapon_tags["rocket"][7] = "tag_rocket4_left";
		weapon_tags["bomb"][0] = "tag_bomb_left";
		weapon_tags["bomb"][1] = "tag_bomb_right";
	
		// 50 Cal MGs
		//--------------------------------------------------------
		weapon = create_weapon();
		weapon.info["weapon"]						= "player_corsair_mg";
		weapon.info["weapon_localstring"]			= "undefined";
		weapon.info["sound_armed"]					= "cobra_weapon_change";
		weapon.info["hud_shader"]					= "veh_hud_hellfire";
		weapon.info["barrels"]						= 6;
		weapon.info["single_shot"]					= false;
		weapon.info["shader_target"]				= "veh_hud_target";
		weapon.info["shader_target_offscreen"]		= "veh_hud_target_offscreen";
		weapon.info["shader_invalid"]				= "veh_hud_target_invalid";
		weapon.info["shader_invalid_offscreen"]		= "veh_hud_target_invalid_offscreen";
		weapon.info["max_ammo"]						= 200;
		weapon.info["tags"]							= weapon_tags["mg"];
		weapon.info["reload_time"]					= 3;
		weapon.info["reload_sound"]					= "none";
		self add_weapon( weapon, type );

		// Rockets
		//--------------------------------------------------------
		weapon = create_weapon();
		weapon.info["weapon"]						= "player_corsair_rocket";
		weapon.info["weapon_localstring"]			= "undefined";
		weapon.info["sound_armed"]					= "cobra_weapon_change";
		weapon.info["hud_shader"]					= "veh_hud_hellfire";
		weapon.info["barrels"]						= 1;
		weapon.info["single_shot"]					= false;
		weapon.info["shader_target"]				= "veh_hud_target";
		weapon.info["shader_target_offscreen"]		= "veh_hud_target_offscreen";
		weapon.info["shader_invalid"]				= "veh_hud_target_invalid";
		weapon.info["shader_invalid_offscreen"]		= "veh_hud_target_invalid_offscreen";
		weapon.info["max_ammo"]						= 8;
		weapon.info["tags"]							= weapon_tags["rocket"];
		weapon.info["reload_time"]					= 5;
		weapon.info["reload_sound"]					= "none";
		self add_weapon( weapon, type );

		// Bombs
		//--------------------------------------------------------
		weapon = create_weapon();
		weapon.info["weapon"]						= "player_corsair_bomb";
		weapon.info["weapon_localstring"]			= "undefined";
		weapon.info["sound_armed"]					= "cobra_weapon_change";
		weapon.info["hud_shader"]					= "veh_hud_hellfire";
		weapon.info["barrels"]						= 1;
		weapon.info["single_shot"]					= false;
		weapon.info["shader_target"]				= "veh_hud_target";
		weapon.info["shader_target_offscreen"]		= "veh_hud_target_offscreen";
		weapon.info["shader_invalid"]				= "veh_hud_target_invalid";
		weapon.info["shader_invalid_offscreen"]		= "veh_hud_target_invalid_offscreen";
		weapon.info["max_ammo"]						= 2;
		weapon.info["tags"]							= weapon_tags["bomb"];
		weapon.info["reload_time"]					= 5;
		weapon.info["reload_sound"]					= "none";
		self add_weapon( weapon, type );
	}
}

// Only for initialization, Creates a "weapon" struct with the default parameters
create_weapon()
{
	ent = SpawnStruct();
	ent.info = [];

	// Set defaults
	ent.info["weapon"]						= undefined; // Name of the weapon
	ent.info["weapon_localstring"]			= undefined; // Localized String of the weapon
	ent.info["sound_armed"]					= "cobra_weapon_change"; // Sound for switching weapons
	ent.info["hud_shader"]					= undefined; // Hud shader
	ent.info["barrels"]						= 1; // Determines how many tags to shoot out of at once.
	ent.info["single_shot"]					= false; // Single shot, or not
//	ent.info["target_type"]					= undefined; // Copied from cobrapilot, used for ground/air.
	ent.info["shader_target"]				= "veh_hud_target"; // Shader used for targets
	ent.info["shader_target_offscreen"]		= "veh_hud_target_offscreen"; // Shaders used for targets offscreen
	ent.info["shader_invalid"]				= "veh_hud_target_invalid"; // 
	ent.info["shader_invalid_offscreen"]	= "veh_hud_target_invalid_offscreen";
	ent.info["max_ammo"]					= undefined; // Maximum ammo.
	ent.info["tags"]						= undefined; // The set of tags to fire from.
	ent.info["reload_time"]					= undefined; // Set the delay when weapon is reloading.
	ent.info["reload_sound"]				= undefined;

	// level.aircraft_keys are used for debug, so we don't miss any settings.
	level.aircraft_keys = [];
	index_names = GetArrayKeys( ent.info );
	for( q = 0; q < index_names.size; q++ )
	{
		level.aircraft_keys[q] = index_names[q];
	}
	
	return ent;
}

// Only for initialization, sets up the weapon settings.
add_weapon( weapon, type )
{	
	if( !IsDefined( level.aircraft_weapons ) )
	{
		level.aircraft_weapons = [];
	}

	// Debug, assert if missing any settings
	//----------------------------------------------------

	// Make sure all of the weapons are setup properly.
	for( i = 0; i < level.aircraft_keys.size; i++ )
	{
		index_name = level.aircraft_keys[i];
		assert( IsDefined( weapon.info[index_name] ) );
	}

	// Must have at least 1 tag
	assert( weapon.info["tags"].size > 0 );
	//----------------------------------------------------

	if( !IsDefined( level.aircraft_weapons[type] ) )
	{
		level.aircraft_weapons[type] = [];
	}

	// Set the current tag index to 0
	weapon.info["current_tag"] 		= 0;
	// Set the reloading
	weapon.info["reload_timestamp"]	= 0;
	// Set currentammo to max_ammo
	weapon.info["current_ammo"] 	= weapon.info["max_ammo"];

	// Add all of the weapon settings to the level.aircraft_weapons[vehicletype]
	level.aircraft_weapons[type][level.aircraft_weapons[type].size] = weapon.info;

	//Precache the weapons localized string name
	PrecacheString( weapon.info["weapon_localstring"] );
	
	//precache the weapon
	PrecacheItem( weapon.info["weapon"] );

	//precache the shaders
	PrecacheShader( weapon.info["hud_shader"] );
	PrecacheShader( weapon.info["shader_target"] );
	PrecacheShader( weapon.info["shader_target_offscreen"] );
	PrecacheShader( weapon.info["shader_invalid"] );
	PrecacheShader( weapon.info["shader_invalid_offscreen"] );
}

// Gives the plane it's weapons upon spawning in.
give_weapons()
{
	self.weapons = level.aircraft_weapons[self.vehicletype];
}

//---------------------------------//
// Handle weapon in-flight Section //
//---------------------------------//

// Handles firing the weapons.
weapon_management()
{
	self endon( "death" );
	self.current_weapon = 0;

	self thread weapon_fire();

	player = self GetVehicleOwner( self );

	if( level.xenon )
	{
		switch_button = "button_y";
	}
	else
	{
		switch_button = "]";
	}

	while( 1 )
	{
		if( player ButtonPressed( switch_button ) ) // TESTING WITH BUTTON_Y
		{
			next_weapon = self.current_weapon + 1;
			if( next_weapon > self.weapons.size - 1 )
			{
				next_weapon = 0;
			}

			self SetVehWeapon( self.weapons[next_weapon]["weapon"] );
			self.current_weapon = next_weapon;

			println( "^5Switched weapon to: " + self.weapons[next_weapon]["weapon"] );

			wait( 0.5 );
		}
		wait( 0.05 );
	}
}

weapon_fire()
{
	self endon( "death" );

	while( 1 )
	{
		self waittill( "turret_fire" );

		if( !self can_fire() )
		{
			continue;
		}

		// Since can_fire() will not let the current_weapon fire if it's reloading, once we can fire again, set the current_ammo
		// to the max_ammo.
		if( self.weapons[self.current_weapon]["current_ammo"] < 1 )
		{
			self.weapons[self.current_weapon]["current_ammo"] = self.weapons[self.current_weapon]["max_ammo"];
		}

		// self.current_weapon is the index number of the weapon.
		assert( IsDefined( self.current_weapon ) );

		// Fire the current weapon.
		for( i = 0; i < self.weapons[self.current_weapon]["barrels"]; i++ )
		{
			tag_num = self.weapons[self.current_weapon]["current_tag"];
			self FireWeapon( self.weapons[self.current_weapon]["tags"][tag_num] );
	
			println( "^3Weapon: " + self.weapons[self.current_weapon]["weapon"] + " Tag: " + self.weapons[self.current_weapon]["tags"][tag_num] + " Ammo: " + self.weapons[self.current_weapon]["current_ammo"] );
	
			// Increment the tag number, if the it's higher than the total amount of tags, then reset to 0.
			self.weapons[self.current_weapon]["current_tag"]++;
			if( self.weapons[self.current_weapon]["current_tag"] > self.weapons[self.current_weapon]["tags"].size - 1 )
			{
				self.weapons[self.current_weapon]["current_tag"] = 0;
			}

			// Decrement the current_ammo
			self.weapons[self.current_weapon]["current_ammo"]--;
			if( self.weapons[self.current_weapon]["current_ammo"] < 1 )
			{
				self.weapons[self.current_weapon]["reload_timestamp"] = GetTime() + ( self.weapons[self.current_weapon]["reload_time"] * 1000 );
			}

			if( self.weapons[self.current_weapon]["barrels"] > 1 )
			{
				if( RandomInt( 100 ) < 50 )
				{
					wait( RandomFloatRange( 0, 0.1 ) );
				}
			}
		}
	}
}

can_fire()
{
	// Check reloading.
	if( GetTime() < self.weapons[self.current_weapon]["reload_timestamp"] )
	{
		println( "^1 -- Weapon Reloading..." );
		return false;
	}

	return true;
}

//---------//
// Targets //
//---------//
set_target( ent, shader, offscreen_shader, offset )
{
	if( !IsDefined( offset ) )
	{
		target_set( ent, ( 0, 0, 0 ) );
	}
	else
	{
		target_set( ent, offset );
	}

	target_setshader( ent, level.hud_shaders[shader] );

	if( IsDefined( offscreen_shader ) )
	{
		target_setoffscreenshader( ent, level.hud_shaders[offscreen_shader] );
	}
}

//-----------//
// Waypoints //
//-----------//
set_waypoint( origin )
{
	ent = Spawn( "script_model", origin );

	set_target( ent, "waypoint", "waypoint_offscreen" );

	return ent;
}

clear_all_waypoints()
{
	players = get_players();

	for( i = 0; i < players.size; i++ )
	{
		if( IsDefined( players[i].current_waypoint ) )
		{
			players[i].current_waypoint Destroy();
		}
	}
}

//-----------------//
// Utility Section //
//-----------------//
set_instrument( shader, x, y )
{
	hud = NewClientHudElem( self );
	hud.location = 0;
	hud.alignX = "right";
	hud.alignY = "middle";
	hud.foreground = 1;
	hud.fontScale = 1;
	hud.sort = 20;
	hud.alpha = 1;
	hud.x = x;
	hud.y = y;

	if( IsDefined( shader ) )
	{
		hud.alignX = "center";
		hud.alignY = "middle";
		hud SetShader( shader, 96, 96 );
	}

	return hud;
}