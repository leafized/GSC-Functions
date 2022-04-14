// _createart generated.  modify at your own risk. Changing values should be fine.
main()
{

	level.tweakfile = true;
 

	//* Fog section * 

	setdvar("scr_fog_exp_halfplane", "4353");
	setdvar("scr_fog_exp_halfheight", "5000");
	setdvar("scr_fog_nearplane", "1024");
	setdvar("scr_fog_red", "0.53125");
	setdvar("scr_fog_green", "0.507813");
	setdvar("scr_fog_blue", "0.5");
	setdvar("scr_fog_baseheight", "0");

	setVolFog(1024, 3353, 5000, 0, 0.5, 0.507813, 0.5, 0);
	VisionSetNaked( "mp_atoll", 0 );

}

