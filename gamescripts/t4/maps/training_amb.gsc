#include maps\_utility;
#include maps\_ambientpackage;


main()
{

	
	
	activateAmbientRoom( "outdoors_room", 0 );
	activateAmbientPackage( "outdoors_pkg", 0 );
	
	
	//start scripts
	level thread start_ship_horn();
} 

start_ship_horn()
{

	while(1)
	{
		wait(randomintrange(30,60));	
		playsoundatposition("ship_horn", ( -7076.5, -1507.5, 105) );
		wait(randomintrange(30,60));
	}


}