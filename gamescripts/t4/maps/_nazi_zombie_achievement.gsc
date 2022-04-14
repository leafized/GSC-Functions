#include maps\_utility; 
#include common_scripts\utility; 
#include maps\_zombiemode_utility; 

init()
{
	level thread init_achievement_variable();
	players = getplayers();
	for(i = 0 ; i < players.size; i++)
	{
		players[i] thread track_general_contractor();
		players[i] thread track_WMD_achievement();
		players[i] thread tracks_highroller_achievement();
		//players[i] thread track_hell_hound_kills();
		players[i] thread track_perk_a_holic();
		players[i] thread survive_rounds_without_revive();
		players[i] thread track_instant_melee_kills();
		players[i] thread track_headshot_count();
		players[i] thread track_total_zombie_killed();
		players[i] thread track_trap_killed();
	}
}
init_achievement_variable()
{
	set_zombie_var("Achievement_General_Contractor", 10);
	set_zombie_var("Achievement_WMD", 5);
	set_zombie_var("Achievement_HighRoller", 5000);
	//set_zombie_var("Achievement_Hell_Hound_kills", 5);
	set_zombie_var("Achievement_Survivor_1", 10);
	//set_zombie_var("Achievement_Survivor_2", 15);
	set_zombie_var("Achievement_Insta_Melee_Kills", 3);
	set_zombie_var("Achievement_Headshot_count", 150);
	set_zombie_var("Achievement_Crypt_Keeper", 200);
}
track_trap_killed()
{
	while(IsDefined(self))
	{
		if(IsDefined(self.barrel_killed) && IsDefined(self.electric_killed) && IsDefined(self.pendulum_killed) && IsDefined(self.propeller_killed))
		{
			if((self.barrel_killed == self.electric_killed) && (self.barrel_killed == self.pendulum_killed) && (self.barrel_killed == self.propeller_killed))
			{
				/#
					self iprintln( "'Its a Trap!' Achievement Earned" );
				#/

				self giveachievement_wrapper( "DLC2_ZOMBIE_ALL_TRAPS" ); 
				return;


			}
				
		}
		wait(0.5);
	}

}
track_total_zombie_killed()
{
	
	while(IsDefined(self))
	{
		if(IsDefined(self.kill_tracker))
		{
			if(self.kill_tracker >= level.zombie_vars["Achievement_Crypt_Keeper"])
			{
				/#
					self iprintln( "'Fertilizer Man' Achievement Earned" );
				#/

				self giveachievement_wrapper( "DLC2_ZOMBIE_KILLS" ); 
				return;
			}

		}

		wait(0.5);

	}

}

track_headshot_count()
{

	while(IsDefined(self))
	{

		if(IsDefined(self.headshot_count))
		{
			if(self.headshot_count >= level.zombie_vars["Achievement_Headshot_count"])
			{
				/#
					self iprintln( "'Deadhead' Achievement Earned" );
				#/

				self giveachievement_wrapper( "DLC2_ZOMBIE_HEADSHOTS" ); 
				return;

			}
			
		}

		wait(0.5);


	}


}
track_instant_melee_kills()
{
	instant_melee_kill = 0;
	self.last_kill_method = "none";
	self endon("brawler_achievement_unlocked");

	while(IsDefined(self))
	{
		while(level.zombie_vars["Achievement_Insta_Melee_Kills"] == 1)
		{
			self waittill_either("zombie_killed", "insta_kill_over");
			if(self.last_kill_method == "MOD_MELEE" && level.zombie_vars["Achievement_Insta_Melee_Kills"] == 1)
			{
				instant_melee_kill += 1;
			}
			else
			{
				instant_melee_kill = 0;
				continue;
			}

			if(instant_melee_kill >= level.zombie_vars["Achievement_Insta_Melee_Kills"])
			{
				/#
					self iprintln( "'Big Brawler' Achievement Earned" );
				#/
				
				self giveachievement_wrapper( "DLC2_ZOMBIE_MELEE_KILLS" ); 
				self notify("brawler_achievement_unlocked");
			}

		}

		wait(0.1);

		instant_melee_kill = 0;

	}

}

survive_rounds_without_revive()
{
	self endon("I_am_down");
	Achievement_unlock = false;
	while(IsDefined(self))
	{

		if(IsDefined(level.round_number) && level.round_number == level.zombie_vars["Achievement_Survivor_1"] && Achievement_unlock == false)
		{
			/#
				self iprintln( "'Soul Survivor' Achievement Earned" );
			#/

			self giveachievement_wrapper( "DLC2_ZOMBIE_SURVIVOR" ); 
			Achievement_unlock = true;
			break;
		}

		wait(0.5);
		

	}


}
track_perk_a_holic()
{
	while(IsDefined(self))
	{


		if(IsDefined(self.perk_hud) && self.perk_hud.size == 4)
		{
			/#
				self iprintln( "'Perk-a-Holic' Achievement Earned" );
			#/

			self giveachievement_wrapper( "DLC2_ZOMBIE_ALL_PERKS" ); 
			break;
		}

		wait(0.5);
	}



}

track_general_contractor()
{
	self.board_repair = 0;

	while(IsDefined(self))
	{
		if(self.board_repair >= level.zombie_vars["Achievement_General_Contractor"])
		{
			/#
				self iprintln( "'Hammer Time' Achievement Earned" );
			#/

			self giveachievement_wrapper( "DLC2_ZOMBIE_REPAIR_BOARDS" ); 
			break;

		}

		wait(0.5);

	}

}
track_WMD_achievement()
{

	//self.zombie_nuked = 0;
	while(IsDefined(self))
	{
		self waittill("nuke_triggered");
		wait(2);
		if(IsDefined(self.zombie_nuked) && self.zombie_nuked.size == 1)
		{
			/#
				self iprintln( "'Weapon of Minor Destruction' Achievement Earned" );
			#/

			self giveachievement_wrapper( "DLC2_ZOMBIE_NUKE_KILLS" ); 
			break;

		}

	}

}
tracks_highroller_achievement()
{

	while(IsDefined(self))
	{

		if(self.score_total >= level.zombie_vars["Achievement_HighRoller"])
		{
			/#
				self iprintln( "'Big Baller' Achievement Earned" );
			#/

			self giveachievement_wrapper( "DLC2_ZOMBIE_POINTS" ); 
			break;


		}
		wait(0.5);

	}


}