#include common_scripts\utility; 
#include maps\_utility;
#include maps\_zombiemode_utility;

initAmmoBox()
{
	trig = getent("ammo_box", "targetname");
	
	trig.is_available = 1;
	trig.zombie_cost = 10000;
	trig.in_use = 0;
	trig sethintstring(&"ZOMBIE_AMMO_BOX");
	trig setCursorHint( "HINT_NOICON" );
	
	//hinge = getent("ammo_box_hinge", "targetname");
	//trig.target enableBind();
	//trig.target linkTo(hinge);
	
	while(1)
	{
		trig waittill( "trigger", who );
		
		if(trig.is_available)
		{				
			if( is_player_valid( who ) )
			{
				if( who.score >= trig.zombie_cost )
				{				
					if(!trig.in_use)
					{
						trig.in_use = 1;
						trig.is_available = 0;
						
						trig trigger_off();
						
						play_sound_at_pos( "purchase", who.origin );
						
						//trig thread openSumpfAmmoBoxLid();
						//hinge rotateRoll(75, 2);
						//hinge waittill("rotateDone");
						
						//self waittill("lidOpened");
						
						players = get_players();

						for (i = 0; i < players.size; i++)
						{
							primaryWeapons = players[i] GetWeaponsListPrimaries(); 

							for( x = 0; x < primaryWeapons.size; x++ )
							{
								players[i] GiveMaxAmmo( primaryWeapons[x] );
							}
						}
						
						//set the score to 0
						who maps\_zombiemode_score::minus_to_player_score( who.score );
						
						//trig thread closeAmmoBoxLid();
						//hinge rotatePitch(-75, 2);
						//hinge waittill("rotateDone");
						//self waittill("lidClosed");
						
						//level waittill("spinLeverUp");
										
						trig trigger_on();
						
						trig.is_available = 1;
						trig.in_use = 0;					
					}
				}
			}
		}
	}
}

/*openSumpfAmmoBoxLid()
{
	self.target rotatePitch(90, 3);
	self.target waittill("rotateDone");
	self notify("lidOpen");
}

openSumpfAmmoBoxLid()
{
	self.target rotatePitch(-90, 3);
	self.target waittill("rotateDone");
	self notify("lidClosed");
}*/

