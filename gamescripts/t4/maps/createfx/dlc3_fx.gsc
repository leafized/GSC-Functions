#include common_scripts\utility; 
#include maps\_utility;

main()
{
// Electricity Plays From Top Of Main Frame Inside The Coil
mainframe_link_all = getEnt( "mainframe_link_all", "targetname" );
if( isDefined( mainframe_link_all ) )
{
     	ent = maps\_utility::createExploder( "zombie_mainframe_link_all" );
     	ent.v[ "origin" ] = ( mainframe_link_all.origin );
     	ent.v[ "angles" ] = ( 270, 0, 0 );
     	ent.v[ "fxid" ] = "zombie_mainframe_link_all";
     	ent.v[ "delay" ] = 0;
     	ent.v[ "exploder" ] = 101;
     	ent.v[ "soundalias" ] = "nil";
}
    	
// Electrical Coil Bulbs On Top Of Mainframe 
mainframe_links = getEntArray( "fx_mainframe_link", "targetname" );
if( isDefined( mainframe_links[ 0 ] ) )
{
			for( x = 0 ; x < mainframe_links.size; x++ )
 			{
     	ent = maps\_utility::createExploder( "zombie_mainframe_link_single" );
     	ent.v[ "origin" ] = ( mainframe_links[ x ].origin );
     	ent.v[ "angles" ] = ( mainframe_links[ x ].angles );
     	ent.v[ "fxid" ] = "zombie_mainframe_link_single";
     	ent.v[ "delay" ] = 0;
     	ent.v[ "soundalias" ] = "nil";
     	
     	if( isDefined( mainframe_links[ x ].script_noteworthy ) )
     	{
     		if( mainframe_links[ x ].script_noteworthy == "0" ) // Teleporter 0
     		{
     			ent.v[ "exploder" ] = 102;
     		}
     		else if( mainframe_links[ x ].script_noteworthy == "1" ) // Teleporter 1
     		{
     			ent.v[ "exploder" ] = 103;
     		}
     		else // Teleporter 2
     		{
     			ent.v[ "exploder" ] = 104;
     		}
     	}
     	else
     	{
     		ent.v[ "exploder" ] = 104;
     	}
   	 }
}

// Electricity Played At Each Of Three Teleport Pad On Floor When Used
pads = getEntArray( "fx_elec_pads", "targetname" );
if( isDefined( pads[ 0 ] ) )
{
			for( x = 0 ; x < pads.size; x++ )
 			{
     	ent = maps\_utility::createExploder( "transporter_beam" );
     	ent.v[ "origin" ] = ( 1261.84, 1275.33, 199 );
     	ent.v[ "angles" ] = ( 270, 0, 0 );
     	ent.v[ "fxid" ] = "transporter_beam";
     	ent.v[ "delay" ] = 0;
     	ent.v[ "soundalias" ] = "nil";
     	
     	if( isDefined( pads[ x ].script_noteworthy ) )
     	{
     		if( pads[ x ].script_noteworthy == "0" ) // Teleporter 0
     		{
     			ent.v[ "exploder" ] = 201;
     		}
     		else if( pads[ x ].script_noteworthy == "1" ) // Teleporter 1
     		{
     			ent.v[ "exploder" ] = 301;
     		}
     		else
     		{
     			ent.v[ "exploder" ] = 401;
     		}
     	}
     	else
     	{
     		ent.v[ "exploder" ] = 201;
     	}
 
     	ent = maps\_utility::createExploder( "transporter_pad_start" );
     	ent.v[ "origin" ] = ( 1261.96, 1275.22, 199 );
     	ent.v[ "angles" ] = ( 270, 180, 180 );
     	ent.v[ "fxid" ] = "transporter_pad_start";
     	ent.v[ "delay" ] = 0;
     	ent.v[ "soundalias" ] = "nil";
     	
     	if( isDefined( pads[ x ].script_noteworthy ) )
     	{
     		if( pads[ x ].script_noteworthy == "0" ) // Teleporter 0
     		{
     			ent.v[ "exploder" ] = 202;
     		}
     		else if( pads[ x ].script_noteworthy == "1" ) // Teleporter 1
     		{
     			ent.v[ "exploder" ] = 302;
     		}
     		else
     		{
     			ent.v[ "exploder" ] = 402;
     		}
     	}
     	else
     	{
     		ent.v[ "exploder" ] = 202;
     	}
    	}
}

// Electricity At Very Top Of Mainframe
mainframe_linked = getEnt( "fx_mainframe_linked", "targetname" );
if( isDefined( mainframe_linked ) )
{
     	ent = maps\_utility::createExploder( "zombie_mainframe_linked" );
     	ent.v[ "origin" ] = ( mainframe_linked.origin );
     	ent.v[ "angles" ] = ( mainframe_linked.angles );
     	ent.v[ "fxid" ] = "zombie_mainframe_linked";
     	ent.v[ "delay" ] = 0;
     	ent.v[ "exploder" ] = 101;
     	ent.v[ "soundalias" ] = "nil";
}

// These Are At The Main Frame Teleport Pad On Floor
beam = getEnt( "fx_mainframe_beam", "targetname" );
if( isDefined( beam ) )
{
     	ent = maps\_utility::createExploder( "zombie_mainframe_beam" );
     	ent.v[ "origin" ] = ( beam.origin );
     	ent.v[ "angles" ] = ( 270, 0, 0 );
     	ent.v[ "fxid" ] = "zombie_mainframe_beam";
     	ent.v[ "delay" ] = 0;
     	ent.v[ "exploder" ] = 106;
     	ent.v[ "soundalias" ] = "nil";
 
     	ent = maps\_utility::createExploder( 	"zombie_mainframe_beam_start" );
     	ent.v[ "origin" ] = ( beam.origin );
     	ent.v[ "angles" ] = ( 270, 0, 0 );
     	ent.v[ "fxid" ] = "zombie_mainframe_beam_start";
     	ent.v[ "delay" ] = 0;
     	ent.v[ "exploder" ] = 105;
     	ent.v[ "soundalias" ] = "nil";
     	
     	ent = maps\_utility::createExploder( "zombie_mainframe_flat" );
     	ent.v[ "origin" ] = ( beam.origin );
     	ent.v[ "angles" ] = ( 270, 180, 180 );
     	ent.v[ "fxid" ] = "zombie_mainframe_flat";
     	ent.v[ "delay" ] = 0;
     	ent.v[ "exploder" ] = 106;
     	ent.v[ "soundalias" ] = "nil";
     	
     	ent = maps\_utility::createExploder( "zombie_mainframe_flat_start" );
     	ent.v[ "origin" ] = ( beam.origin );
     	ent.v[ "angles" ] = ( 270, 0, 0 );
     	ent.v[ "fxid" ] = "zombie_mainframe_flat_start";
     	ent.v[ "delay" ] = 0;
     	ent.v[ "exploder" ] = 105;
     	ent.v[ "soundalias" ] = "nil";
}

// These Are In Black Teleport Box For Flashbacks
room = getEnt( "teleport_room_0", "targetname" );
if( isDefined( room ) )
{
     	ent = maps\_utility::createExploder( "zombie_flashback_american" );
     	ent.v[ "origin" ] = ( room.angles[0] - 0.08, room.angles[1] + 40.023, room.angles[2] + 59.73 );
     	ent.v[ "angles" ] = ( 0, 270, 0 );
     	ent.v[ "fxid" ] = "zombie_flashback_american";
     	ent.v[ "delay" ] = 0;
     	ent.v[ "exploder" ] = 901;
     	ent.v[ "soundalias" ] = "nil";
}
room = getEnt( "teleport_room_1", "targetname" );
if( isDefined( room ) )
{
     	ent = maps\_utility::createExploder( "zombie_flashback_american" );
     	ent.v[ "origin" ] = ( room.angles[0] - 0.08, room.angles[1] + 40.023, room.angles[2] + 59.73 );
     	ent.v[ "angles" ] = ( 0, 270, 0 );
     	ent.v[ "fxid" ] = "zombie_flashback_american";
     	ent.v[ "delay" ] = 0;
     	ent.v[ "exploder" ] = 902;
     	ent.v[ "soundalias" ] = "nil";
}
room = getEnt( "teleport_room_2", "targetname" );
if( isDefined( room ) )
{
     	ent = maps\_utility::createExploder( "zombie_flashback_american" );
     	ent.v[ "origin" ] = ( room.angles[0] - 0.08, room.angles[1] + 40.023, room.angles[2] + 59.73 );
     	ent.v[ "angles" ] = ( 0, 270, 0 );
     	ent.v[ "fxid" ] = "zombie_flashback_american";
     	ent.v[ "delay" ] = 0;
     	ent.v[ "exploder" ] = 903;
     	ent.v[ "soundalias" ] = "nil";
}
room = getEnt( "teleport_room_3", "targetname" );
if( isDefined( room ) )
{
     	ent = maps\_utility::createExploder( "zombie_flashback_american" );
     	ent.v[ "origin" ] = ( room.angles[0] - 0.08, room.angles[1] + 40.023, room.angles[2] + 59.73 );
     	ent.v[ "angles" ] = ( 0, 270, 0 );
     	ent.v[ "fxid" ] = "zombie_flashback_american";
     	ent.v[ "delay" ] = 0;
     	ent.v[ "exploder" ] = 904;
     	ent.v[ "soundalias" ] = "nil";
}

 // Electricity At Teleporter Top When Used
 trans_start = getEntArray( "fx_trans_start", "targetname" );
 if( isDefined( trans_start[ 0 ] ) )
 {
 			for( x = 0 ; x < trans_start.size; x++ )
 			{ 
     	ent = maps\_utility::createExploder( "transporter_start" );
     	ent.v[ "origin" ] = ( trans_start[ x ].origin );
     	ent.v[ "angles" ] = ( trans_start[ x ].angles );
     	ent.v[ "fxid" ] = "transporter_start";
     	ent.v[ "delay" ] = 0;
     	ent.v[ "soundalias" ] = "nil";
     	
     	if( isDefined( trans_start[ x ].script_noteworthy ) )
     	{
     		if( trans_start[ x ].script_noteworthy == "0" ) // Teleporter 0
     		{
     			ent.v[ "exploder" ] = 202;
     		}
     		else if( trans_start[ x ].script_noteworthy == "1" ) // Teleporter 1
     		{
     			ent.v[ "exploder" ] = 302;
     		}
     		else // Teleporter 2
     		{
     			ent.v[ "exploder" ] = 402;
     		}
     	}
     	else
     	{
     		ent.v[ "exploder" ] = 104;
     	}
  	}
}
 
 // Electricity At Teleporter Power Generator Looking Things
 zombie_dif_spots = getEntArray( "fx_tele_gen", "targetname" );
 if( isDefined( zombie_dif_spots[ 0 ] ) )
 {
 			for( x = 0 ; x < zombie_dif_spots.size; x++ )
 			{
     	ent = maps\_utility::createExploder( "zombie_difference" );
     	ent.v[ "origin" ] = ( zombie_dif_spots[ x ].origin );
     	ent.v[ "angles" ] = ( zombie_dif_spots[ x ].angles );
     	ent.v[ "fxid" ] = "zombie_difference";
     	ent.v[ "delay" ] = 0;
     	ent.v[ "soundalias" ] = "nil";
     	
     	if( isDefined( zombie_dif_spots[ x ].script_noteworthy ) )
     	{
     		if( zombie_dif_spots[ x ].script_noteworthy == "0" ) // Teleporter 0
     		{
     			ent.v[ "exploder" ] = 102;
     		}
     		else if( zombie_dif_spots[ x ].script_noteworthy == "1" ) // Teleporter 1
     		{
     			ent.v[ "exploder" ] = 103;
     		}
     		else // Teleporter 2
     		{
     			ent.v[ "exploder" ] = 104;
     		}
     	}
     	else
     	{
     		ent.v[ "exploder" ] = 104;
     	}
   	 }
 }
 
 // Steam From The Mainframe Coils
 steam_spots = getEntArray( "fx_mainframe_steam", "targetname" );
 if( isDefined( steam_spots[ 0 ] ) )
 {
 			for( x = 0 ; x < steam_spots.size; x++ )
 			{
     	ent = maps\_utility::createExploder( "zombie_mainframe_steam" );
     	ent.v[ "origin" ] = ( steam_spots[ x ].origin );
     	ent.v[ "angles" ] = ( steam_spots[ x ].angles );
     	ent.v[ "fxid" ] = "zombie_mainframe_steam";
     	ent.v[ "delay" ] = 1.5;
     	ent.v[ "soundalias" ] = "nil";
     	
     	if( isDefined( steam_spots[ x ].script_noteworthy ) && steam_spots[ x ].script_noteworthy == "bridge" )
     	{
     		ent.v[ "exploder" ] = 500;
     	}
     	else
     	{
     		ent.v[ "exploder" ] = 106;
     	}
    }
 }
 
 // Steam Played At Teleports / Mainframe After Use
 heatSinks = getEntArray( "fx_heatsink", "targetname" );
 if( isDefined( heatSinks[ 0 ] ) )
 {
 			for( x = 0 ; x < heatSinks.size; x++ )
 			{
     	ent = maps\_utility::createExploder( "zombie_heat_sink" );
     	ent.v[ "origin" ] = ( heatSinks[ x ].origin );
     	ent.v[ "angles" ] = ( heatSinks[ x ].angles );
     	ent.v[ "fxid" ] = "zombie_heat_sink";
     	ent.v[ "delay" ] = 2.5;
     	ent.v[ "exploder" ] = 106;
     	ent.v[ "soundalias" ] = "nil";
     	
     	if( isDefined( heatSinks[ x ].script_noteworthy ) )
     	{
     		if( heatSinks[ x ].script_noteworthy == "mainframe" ) // MainFrame
     		{
     			ent.v[ "exploder" ] = 106;
     		}
     		else if( heatSinks[ x ].script_noteworthy == "0" ) // Teleporter 0
     		{
     			ent.v[ "exploder" ] = 201;
     		}
     		else if( heatSinks[ x ].script_noteworthy == "1" ) // Teleporter 1
     		{
     			ent.v[ "exploder" ] = 301;
     		}
     		else // Teleporter 2
     		{
     			ent.v[ "exploder" ] = 401;
     		}
     	}
     	else
     	{
     		ent.v[ "exploder" ] = 201;
     	}
    	}
 }
 
// Electricity In Teleports Placed Bottom Of Inner Blue Orbish Thing
trans_amb = getEntArray( "fx_trans_amb", "targetname" );
if( isDefined( trans_amb[ 0 ] ) )
{
			for( x = 0 ; x < trans_amb.size; x++ )
 			{
     	ent = maps\_utility::createExploder( "transporter_ambient" );
     	ent.v[ "origin" ] = ( trans_amb[ x ].origin );
     	ent.v[ "angles" ] = ( trans_amb[ x ].angles );
     	ent.v[ "fxid" ] = "transporter_ambient";
     	ent.v[ "delay" ] = 0;
     	ent.v[ "exploder" ] = 102;
     	ent.v[ "soundalias" ] = "nil";
     	
     	if( isDefined( trans_amb[ x ].script_noteworthy ) )
     	{
     		if( trans_amb[ x ].script_noteworthy == "0" ) // Teleporter 0
     		{
     			ent.v[ "exploder" ] = 102;
     		}
     		else if( trans_amb[ x ].script_noteworthy == "1" ) // Teleporter 1
     		{
     			ent.v[ "exploder" ] = 103;
     		}
     		else // Teleporter 2
     		{
     			ent.v[ "exploder" ] = 104;
     		}
     	}
     	else
     	{
     		ent.v[ "exploder" ] = 102;
     	}
    	}
}

// Electricity In Big Generator On Coils That Turns On With Power
elec_gen_spots = getEntArray( "elec_gen_idle", "targetname" );
if( isDefined( elec_gen_spots[ 0 ] ) )
{
 			for( x = 0 ; x < elec_gen_spots.size; x++ )
 			{
     	ent = maps\_utility::createExploder( "zombie_elec_gen_idle" );
     	ent.v[ "origin" ] = ( elec_gen_spots[ x ].origin );
     	ent.v[ "angles" ] = ( elec_gen_spots[ x ].angles );
     	ent.v[ "fxid" ] = "zombie_elec_gen_idle";
     	ent.v[ "delay" ] = 0;
     	ent.v[ "exploder" ] = 101;
     	ent.v[ "soundalias" ] = "nil";
    }
}
 
// Lamp Rays/Coronas That Turn On With Power
light_spots = getEntArray( "fx_light_spot", "targetname" );
if( isDefined( light_spots[ 0 ] ) )
{
 			for( x = 0 ; x < light_spots.size; x++ )
 			{
     	ent = maps\_utility::createExploder( "mp_light_lamp_no_eo" );
     	ent.v[ "origin" ] = ( light_spots[ x ].origin );
     	ent.v[ "angles" ] = ( light_spots[ x ].angles );
     	ent.v[ "fxid" ] = "mp_light_lamp_no_eo";
     	ent.v[ "delay" ] = 0;
     	ent.v[ "exploder" ] = 600;
     	ent.v[ "soundalias" ] = "nil";
    }
}
}