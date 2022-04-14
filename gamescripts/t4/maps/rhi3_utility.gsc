#include maps\_utility;

//////////////////////////////////////////////////////////////////////////////////////
//
//This file contains all of the utility functions used in Rhi3
//
//////////////////////////////////////////////////////////////////////////////////////

on_clear_squad_advance_fc(enemy_noteworthy, fc_noteworthy, spawn_noteworthy, node_name)
{
	enemies = getentarray(enemy_noteworthy, "script_noteworthy");
	fc_trigger = getent(fc_noteworthy, "script_noteworthy");
	spawn_trigger = getentarray(spawn_noteworthy, "script_noteworthy");
	
	// first node on the friendlychain
	node = getnode(node_name, "targetname" );

	fc_trigger endon("trigger");
	
	living_enemies = [];
	living_enemies = array_removeDead(enemies);
	
	println("THIS MANY ENEMIES: " + enemies.size);
	if(living_enemies.size > 0)
	{
		waittill_dead(living_enemies);
	}
	
	// set the friendlychain on the player
	get_players()[0] setfriendlychain( node );
	
	for(i=0; i<spawn_trigger.size; i++)
	{
		spawn_trigger[i] notify("trigger");
	}
}

switch_to_colors()
{
	level waittill("switch_to_colors");
	
	squad = [];
	reds = [];
	
	squad = getentarray("allies", "script_threatbiasgroup");
	reds  = getentarray("redshirts", "script_threatbiasgroup");
	
	for(i=0; i<squad.size; i++)
	{
		squad[i] setgoalpos(squad[i].origin);
	}
	
	for(i=0; i<reds.size; i++)
	{
		reds[i] setgoalpos(reds[i].origin);
	}
}

interrupt_patroller_go_to_node()
{
	//-- currently this is useful only for axis patrollers... will need to change the threatbiasgroup setting
	//if we want to be able to use it with ally chars
	
	self waittill("enemy");
	
	target_node = getnode(self.script_noteworthy, "targetname");
	self setgoalnode(target_node);
	
	self setthreatbiasgroup("enemies");
}