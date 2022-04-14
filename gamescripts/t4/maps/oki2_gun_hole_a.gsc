#include maps\_utility;
#include maps\_anim;

main()
{
	
		level._effect["character_fire_death_sm"] = loadfx("env/fire/fx_fire_player_sm");
		level._effect["character_fire_death_torso"] = loadfx("env/fire/fx_fire_player_torso");
		level._effect["character_fire_pain_sm"] = loadfx("env/fire/fx_fire_player_sm_1sec");
		
		level._effect["fire_jet"] = loadfx("env/fire/flamethrower_fire");
		level._effect["boom"] = loadfx("maps/pel1/fx_beach_bunker_explosion_lg");
		level._effect["fire_boom"]= loadfx("maps/ber1/fx_traincar_fuel_explosion_lg");
		
		PrecacheItem( "m1garand" );
		PrecacheItem( "thompson" );
		PrecacheItem( "flamethrower" );
		PrecacheItem( "fraggrenade" );
		PrecacheItem( "m8_white_smoke" );
		
		level.player_secondaryoffhand = "smoke" ;
		level.player_switchweapon =  "flamethrower";
			
		maps\_model3::main( "artillery_jap_model3" );
		maps\_mganim::main();	
		//_load baby! 
		maps\_load::main();		
		
		thread setup_players();
		thread flame_jets();
		

	
}

setup_players()
{
		thread maps\_squad_manager::manage_spawners("gun1_guys",1,2,"gun1_flamed",1,undefined);
		thread setup_flame_damage();
		wait(3);
		players = get_players();
		players[0] giveweapon("flamethrower");
		players[0] switchtoweapon("flamethrower");
		
}


setup_flame_damage()
{
	trig = getent("fire_damage","targetname");
		
	trig waittill("trigger");	
	level notify("gun1_flamed");
	
	playfx(level._effect["boom"],trig.origin);

	bunker_flamers = getaiarray("axis");
	bunker_trigger = getent("bunker_trigger","targetname");
	for(i=0;i<bunker_flamers.size;i++)
	{
		if( bunker_flamers[i] istouching( bunker_trigger ) )
		{
			bunker_flamers[i] thread flamedeath();
		}
	}	

	wait(5);
	cave_flamers = getentarray("flamers","targetname");
	array_thread(cave_flamers,::bunker_flamers);
	setup_explosive_damage();	
}


setup_explosive_damage()
{
	trig = getent("fire_damage","targetname");
		
	trig waittill("trigger");	
	playfx(level._effect["fire_boom"], (292, 55, 22));

}


bunker_flamers()
{
	guy = self stalingradspawn();
	wait 1;
	guy thread flamedeath();
	
}

#using_animtree("generic_human");
flamedeath(reach_goal)
{
	
	anima[1] = %ai_flame_death_a;
	anima[1] = %ai_flame_death_b;
	anima[2] = %ai_flame_death_c;
	anima[3] = %ai_flame_death_d;
		
	self animscripts\death::flame_death_fx();
	if(isDefined(reach_goal))
	{
		self waittill("goal");
	}
	self.deathanim = anima[randomint(3)];		
	self dodamage(self.health + 100, self.origin);	
}

flame_jets()
{
	
	trig = getent("fire_damage","targetname");
	while(1)
	{
		trig waittill("damage");
		playfx(level._effect["fire_jet"], ( -125.5 ,210 ,97 ), (0,270,0));
	}
	
}