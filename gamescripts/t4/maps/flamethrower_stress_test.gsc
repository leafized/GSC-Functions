#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim; 

main()
{
	maps\_load::main();
	
	level.num_flame_groups = 2;
	
	level.flame_enemies = getEntArray( "flame_enemy", "targetname" );
	for( i = 0; i < level.flame_enemies.size; i++ )
	{
		level.flame_enemies[i] thread magic_bullet_shield();
		level.flame_enemies[i].ignoreall = true;
	}
	
	for( i = 0; i < level.num_flame_groups; i++ )
	{
		level.flamer_arrays[i] = GetEntArray( "flamers"+i, "targetname" );
		for( j = 0; j < level.flamer_arrays[i].size; j++ )
		{
			level.flamer_arrays[i][j] thread magic_bullet_shield();
			level.flamer_arrays[i][j].a.flamethrowerShootTime_min = 10000; 
	    level.flamer_arrays[i][j].a.flamethrowerShootTime_max = 15000; 
	 
	    level.flamer_arrays[i][j].a.flamethrowerShootDelay_min = 0; 
	    level.flamer_arrays[i][j].a.flamethrowerShootDelay_max = 1;
	    level.flamer_arrays[i][j].ignoreall = true;
		}
	}
	
	wait( 10 );
	for( i = 0; i < level.num_flame_groups; i++ )
	{
		for( j = 0; j < level.flamer_arrays[i].size; j++ )
		{
	    level.fLamer_arrays[i][j].ignoreall = false;
		}
	}
	
	//begin_firing();
}

begin_firing()
{
	while( 1 )
	{
		for( i = 0; i < level.num_flame_groups; i++ )
		{
			level.flametargets[i] = GetEnt( "flametarget"+i, "targetname" );
			for( j = 0; j < level.flamer_arrays[i].size; j++ )
			{
				
				eyeOrigin = level.flamer_arrays[i][j] GetEye();                            
	
				forward = AnglesToForward( VectorToAngles( level.flametargets[i].origin - eyeOrigin ) );
	
				newTargetVec = eyeOrigin + vectorScale( forward, 64 );
				
				if( !isDefined( getEnt( "script_flametarget"+i+""+j, "targetname" ) ) )
				{
					org = Spawn( "script_origin", newTargetVec );
					org.targetname = "script_flametarget"+i+""+j;
					
					level.flamer_arrays[i][j] SetEntityTarget( org );
				}
				else
				{
					level.flamer_arrays[i][j] SetEntityTarget( getEnt( "script_flametarget"+i+""+j, "targetname" ) );
				}
			 
		    level.flamer_arrays[i][j].a.flamethrowerShootTime_min = 10000; 
		    level.flamer_arrays[i][j].a.flamethrowerShootTime_max = 15000; 
		 
		    level.flamer_arrays[i][j].a.flamethrowerShootDelay_min = 0; 
		    level.flamer_arrays[i][j].a.flamethrowerShootDelay_max = 1;
	
			}
		}
		wait( 0.05 );
	}
}