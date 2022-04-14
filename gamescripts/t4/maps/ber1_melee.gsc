// scripting by Bloodlust

#include maps\_anim;
#include maps\_utility;

// play a random vignette at a random location
// k/v pair of node_scripted and spawner have to match. i.e: "melee", "targetname"
// set spawnaxis to true if you want to spawn an Axis AI instead of grab a random one thats already alive
// optional trigger to wait for before starting
main(value, key, spawnaxis, trigger)
{
	level.vignette = [];
	level.vignette[0] = "knife_bash_shoot";		// pin down with knife, get bashed, then shot
	level.vignette[1] = "sandbag";				// jump on sandbag and spray with weapon
	level.vignette[2] = "melee1";				// unknown
	level.vignette[3] = "melee2";				// unknown
	level.vignette[4] = "bayonette";			// joug a fool!
	
	level.sandbag_count = 0;
	level.vignette0_count = 0;
	level.vignette_count = 0;
	axis = undefined;
	russian = undefined;
	russian1 = undefined;
	russian2 = undefined;
	inodes = getnodearray(value, key);

	assertex( IsDefined( inodes ), "For some reason inodes is undefined!!! FIX ME!" );
	assertex( inodes.size > 0, "For some reason inodes has a SIZE of 0!!! FIX ME!" );
	
	if(isdefined(trigger))
	{
		trigger waittill("trigger");
	}

	while(1)
	{
		num = randomint(5);
		
		if(num != 1)	// no Germans needed for the sandbag vignette
		{
			if(spawnaxis)
			{
				spawners = getentarray(value, key);
				spawner = spawners[randomInt(spawners.size)];
				axis = spawner stalingradspawn();
			
				if(!maps\_utility::spawn_failed(axis))
				{
					axis.targetname = "german";
					axis.ignoreall = true;
					axis.ignoreme = true;
					axis.goalradius = 32;
					axis.animname = "german";
					axis.allowdeath = false;
					axis thread magic_bullet_shield();
				}
			}
			else
			{
				axisguys = getaiarray("axis");

				for(i = 0; i < axisguys.size; i++)
				{
					axis = axisguys[randomInt(axisguys.size)];
					
					if(isdefined(axis.script_noteworthy))
					{
						continue;
					}
					else if(issentient(axis))
					{
						axis.targetname = "german";
						axis.ignoreall = true;
						axis.ignoreme = true;
						axis.goalradius = 32;
						axis.animname = "german";
						axis.allowdeath = false;
						axis thread magic_bullet_shield();
						
						break;
					}
				}
			}
		}
		
		// never have to worry about spawning in a Russian, theres always more than ants at a picnic!
		russki = getaiarray("allies");
		
		if(num != 0)	// only one Russian is need per vignette unless its "knife_bash_shoot"
		{
			for(i = 0; i < russki.size; i++)
			{
				if(isdefined(russki[i].script_noteworthy))
				{
					continue;
				}
				else if(issentient(russki[i]))
				{
					russian = russki[i];
					russian.targetname = "russian";
					russian.ignoreall = true;
					russian.ignoreme = true;
					russian.goalradius = 32;
					russian thread magic_bullet_shield();
					russian.animname = "russian";
					russian.allowdeath = false;
					
					break;
				}
			}
		}
		else
		{
			level.vignette0_count++;
			
			counter = 0;
			
			for(i = 0; i < russki.size; i++)
			{
				if(isdefined(russki[i].script_noteworthy))
				{
					continue;
				}
				else if(issentient(russki[i]))
				{
					counter++;
					
					if(counter > 2)
					{
						counter = 0;
						break;
					}
					
					russian = russki[i];
					russian.ignoreall = true;
					russian.ignoreme = true;
					russian.goalradius = 32;
					russian.allowdeath = false;
					russian thread magic_bullet_shield();
					russian.animname = "russian" + counter;
					russian.targetname = "russian" + counter;
				}
			}
		}

		level.vignette_count++;
		
		if(level.vignette_count < 5)
		{
			if(num == 0)
			{
				if(level.vignette0_count > 8)
				{
					russian1 = getent("russian1", "targetname");
					russian2 = getent("russian2", "targetname");
					level thread knife_bash_shoot(axis, russian1, russian2, inodes, num);
				}
			}
			
			if(num == 1)
			{
				level thread sandbagger(russian, num);	// the node gets setup inside this function
			}
			
			if(num != 0 && num != 1)
			{
				level thread random_melee_anims(axis, russian, inodes, num);
			}
			
			wait (randomfloatrange(10, 15) + 1);
		}
		else
		{
			// if 5 vignettes are playing, wait a bit for a couple to finish
			level.vignette_count = 0;
			wait 30;
		}
	}
}

// German pins down a Russian with a knife to his throat
// German gets bashed by russian2, then shot
knife_bash_shoot(german, russian1, russian2, inodes, num)
{
	if(level.vignette0_count > 8)
	{
		/#
		iprintlnbold(level.vignette[num]);
		#/
		
		guys = [];
		guys[0] = german;
		guys[1] = russian1;
		guys[2] = russian2;
		
		anode = inodes[randomint(inodes.size)];
		
		anim_reach(guys, level.vignette[num] + "_reach", undefined, anode, undefined);
		
		if(isdefined(german.magic_bullet_shield))
		{
			german stop_magic_bullet_shield();
		}
		
		anim_single(guys, level.vignette[num], undefined, anode);
		
		german dodamage(german.health + 50, german.origin);
		
		if(isdefined(russian1.magic_bullet_shield))
		{
			russian1 stop_magic_bullet_shield();
		}
		
		if(isdefined(russian2.magic_bullet_shield))
		{
			russian2 stop_magic_bullet_shield();
		}
		
		anode = inodes[randomint(inodes.size)];
		russian1 setgoalnode(anode);
		anode = inodes[randomint(inodes.size)];
		russian2 setgoalnode(anode);
		
		russian1 thread run_and_die();
		russian2 thread run_and_die();

		level.vignette0_count = 0;
	}
}

// three different melee animations, played randomly
random_melee_anims(german, russian, inodes, num)
{
	guys = [];
	guys[0] = german;
	guys[1] = russian;
	
	anode = inodes[randomint(inodes.size)];
	
	anim_reach(guys, level.vignette[num] + "_reach", undefined, anode, undefined);
	anim_single(guys, level.vignette[num], undefined, anode);
	
	if(num != 4)
	{
		/#
		iprintlnbold(level.vignette[num]);
		#/
		
		if(isdefined(german.magic_bullet_shield))
		{
			german stop_magic_bullet_shield();
		}
		
		german dodamage(german.health + 50, german.origin);
		
		if(isdefined(russian.magic_bullet_shield))
		{
			russian stop_magic_bullet_shield();
		}
		
		anode = inodes[randomint(inodes.size)];
		russian setgoalnode(anode);
		russian thread run_and_die();
	}
	else
	{
		/#
		iprintlnbold(level.vignette[num]);
		#/
		
		if(isdefined(russian.magic_bullet_shield))
		{
			russian stop_magic_bullet_shield();
		}
		
		russian dodamage(russian.health + 50, russian.origin);
		
		if(isdefined(german.magic_bullet_shield))
		{
			german stop_magic_bullet_shield();
		}
		
		anode = inodes[randomint(inodes.size + 1)];
		german setgoalnode(anode);
		german thread run_and_die();
	}
}

// rush an MG42 nest, throw smoke, stand on the sandbags, kill everyone in range
sandbagger(russian, num)
{
	level.sandbag_count++;
	
	if(level.sandbag_count > 25)
	{
		/#
		iprintlnbold(level.vignette[num]);
		#/
		
		inodes = getnodearray("sandbag", "targetname");
		anode = inodes[randomint(inodes.size)];
		
		russian anim_reach_solo(russian, level.vignette[num] + "_reach", undefined, anode, undefined);
		
		// temp faked smoke grenade fx
//		level thread maps\_fx::script_playfx(level._effect["smokenade"], anode.origin);
		
		level thread anim_single_solo(russian, level.vignette[num], undefined, anode, undefined);
		
		germans = getaiarray("axis");
		for(i = 0; i < germans.size; i++)
		{
			dist = distancesquared(russian.origin, germans[i].origin);
				
			if(dist > 300*300)
			{
				continue;
			}
			else
			{
				if(isdefined(germans[i].magic_bullet_shield))
				{
					germans[i] stop_magic_bullet_shield();
				}
				
				waittillframeend;
				
				germans[i] dodamage(germans[i].health + 50, germans[i].origin);
			}
		}
		
		anode = inodes[randomint(inodes.size)];
		
		if(isdefined(russian.magic_bullet_shield))
		{
			russian stop_magic_bullet_shield();
		}
		
		russian setgoalnode(anode);
		russian thread run_and_die();
		
		level.sandbag_count = 0;
	}
}

// wait till goal then bloody death
run_and_die()
{		
	self waittill("goal");
	self thread fakedeath();
}

// Fake death - modified version of Sean's bloody_death
fakedeath()
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