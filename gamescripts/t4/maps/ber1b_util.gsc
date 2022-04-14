// scripting by Bloodlust
// level design by BSouds

#include maps\_utility;

// set the squad on their freindlychains
set_friendlychain(value, key)
{
	players = get_players();
	fc_node = getnode(value, key);
	players[0] setfriendlychain(fc_node);
}

// delete unused MGs to free up entity count
kill_mgs(value)
{
	mg = getentarray(value, "script_noteworthy");

	for(i = 0; i < mg.size; i++)
	{
		mg[i] notify( "stop_using_built_in_burst_fire" );
		mg[i] notify( "stopfiring" );
		wait 0.1;
		mg[i] delete();
	}
}

// used to shoot Panzershrecks at the players and tank in Event 1
fire_shrecks(spwn, targt, time)
{
	shreck = spawn("script_model", spwn.origin);
	shreck.angles = targt.angles;
	shreck setmodel("weapon_ger_panzershreck_rocket");
	wait 0.1;
	shreck moveTo(targt.origin, time);
	shreck thread shrecksmoke(time);
	wait time;
	playfx(level._effect["rocket_explode"], shreck.origin);
	radiusdamage(shreck.origin, 128, 300, 35);
	earthquake(0.3, 1.5, shreck.origin, 512);
	shreck delete();
}

// the smoke trail for the panzershrecks
shrecksmoke(time)
{
	fxcounter = 0;
	
	while(time > 0)
	{
		time = time - 0.1;

		playfx(level._effect["rocket_trail"], self.origin);

		wait 0.1;
	}
}

// used to spawn in specific AI characters
// thanks for the help Chris_P!
#using_animtree("generic_human");
ber1b_spawner(value, key)
{	
	if(value == "moab_bunker_gunner_01" || value == "moab_bunker_gunner_02")
	{
		spawner = getent(value, key);
		guy = spawner stalingradspawn();

		if(!maps\_utility::spawn_failed(guy))
		{
			guy.animname = value;
			guy.deathanim = %death_explosion_up10;
			guy.goalradius = 16;
			guy.targetname = value;
			guy.script_noteworthy = spawner.script_noteworthy;
		
			wait 0.1;
			spawner delete();
		}
	}
	
	else
	{
		spawners = getentarray(value, key);
		for(i=0;i<spawners.size;i++)
		{
			guy = spawners[i] stalingradspawn();
			
			if(!maps\_utility::spawn_failed(guy))
			{
				guy.targetname = value;
				guy.target = spawners[i].target;
				guy.script_noteworthy = spawners[i].script_noteworthy;
				guy.goalradius = 128;
				
				if(value == "wavers")
				{
					guy.targetname = value;
					guy.ignoreall = true;
					guy.ignoreme = true;
					guy.goalradius = 32;
					guy thread magic_bullet_shield();
					guy.animname = value;
					guy.allowdeath = true;
				}

				wait 0.1;
				spawners[i] delete();
			}
		}
	}
}

// tanks fire on random targets in the play area as they move up with the players
tank_targets(tank, target_array)
{
	level endon("move_tanks_up");

	tank_target = getentarray(target_array, "targetname");
	tank clearturrettarget();
	
	while(1)
	{
		tanktarget = tank_target[randomInt(tank_target.size)];
		offset = (( 72 - randomint( 2 * 72 )), ( 72 - randomint( 2 * 72 )), 0);
		
		tank setturrettargetent(tanktarget, offset);
		tank waittill ("turret_on_target");
		
		counter = 0;
		
		players = get_players();
		for(i = 0; i < players.size; i++)
		{
			dist = distancesquared(players[i].origin, tanktarget.origin + offset);
			
			if(dist < 384*384)
			{
				counter++;
			}
		}
		
		if(players.size > 1 && counter > 1)
		{
			continue; 			// if more than one player in the blast area, dont shoot
		}
		else if(counter > 0) 	// If player SINGLE PLAYER
		{
			continue;
		}
		else
		{//	level thread drawline( tank.origin, tanktarget.origin + offset );
			tank fireWeapon();
			wait(randomfloatrange(6, 10));
			tank clearturrettarget();
		}
	}
}

// draws a line from point A to point B. thanks Mike!
drawline(pos1, pos2, time, color)
{
/#
	if(!isdefined(time))
	{
		time = 3;
	}
	
	if(!isdefined(color))
	{
		color = (1, 1, 1);
	}
	
	timer = gettime() + (time * 1000);
	
	while(getTime() < timer)
	{
		line(pos1, pos2, color);
		wait(0.05);
	}
#/
}

// If you find yourself alone, riding in green fields with the sun on your face,
// do not be troubled; for you are in Elysium, and you are already dead!
elysium()
{		
	self waittill("goal");
	self delete();
}

// wait till goal then bloody death
elysium_bloody()
{		
	self waittill("goal");
	self thread bloody_death();
}

// get rid of unused or unavailable AI 
killoff(value, team)
{
	soylent = getaiarray(team);
	for(i = 0; i < soylent.size; i++)
	{
		if(isdefined(soylent[i].script_aigroup) &&  (soylent[i].script_aigroup == value))
		{
			if(issentient(soylent[i]))
			{
				soylent[i] thread stop_magic_bullet_shield();
				soylent[i] thread bloody_death();
			}
			else
			{
				soylent[i] delete();
			}
		}
	}
}

// Fake death - modified version of Sean's bloody_death
bloody_death()
{
	self endon("death");

	if(!issentient(self) || !isalive(self))
	{
		return;
	}

	if(isdefined(self.bloody_death) && self.bloody_death)
	{
		return;
	}

	self.bloody_death = true;
	wait(randomfloatrange(1, 3));

	tags = [];
	tags[0] = "j_hip_le";
	tags[1] = "j_hip_ri";
	tags[2] = "j_head";
	tags[3] = "j_spine4";
	tags[4] = "j_elbow_le";
	tags[5] = "j_elbow_ri";
	tags[6] = "j_clavicle_le";
	tags[7] = "j_clavicle_ri";
	
	for(i = 0; i < 2 + randomint(3); i++)
	{
		random = randomintrange(0, tags.size);
		playfxontag(level.fleshhit, self, tags[random]);
		wait(randomfloat(0.2));
	}

	self dodamage(self.health + 50, self.origin);
}