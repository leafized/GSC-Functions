#include maps\_utility;
#include maps\oki2_geo_callbacks;
main()
{
	//---------------------

	setExpFog(0, 4000, 0.566, 0.549, 0.467, 0);
	//level._effect["rain"] = loadfx("env/weather/fx_rain_lght");
	

	//----------------------
	

	maps\oki2_fx::main();
	maps\_load::main();
	

	

	wait(1);

	players = get_players();
	player = players[0];
	player thread rain();

	



//	VisionSetNaked("Okinawa2",0);
}

rain()
{
//	VisionSetNaked("Okinawa2",1);
	self endon("death");
	self endon("disconnect");
	for (;;)
	{
		playfx ( level._effect["rain"], self.origin + (0,0,0));
		wait (0.1);
	}


}