#include maps\_utility;
main()
{
	maps\_load::main();
	watersimenable(true);
	setVolFog(30, 7000, 0, 0, 0.4, 0.425, 0.44, 0.0);
	
	VisionSetNaked("pel1",0.1);

	level thread viewpos_dvar();
}

viewpos_dvar()
{
	wait_for_first_player();

	hud = NewDebugHudElem();
	hud.x = 400;
	hud.y = 400;
	hud.alpha = 0; 

	SetDvar( "show_viewpos", "0" );

	players = get_players();
	while( 1 )
	{
		if( GetDvarInt( "show_viewpos" ) > 0 )
		{
			hud.alpha = 1;
			hud SetText( "viewpos " + players[0].origin  );
		}
		else
		{
			hud.alpha = 0;
		}

		wait( 0.5 );
	}
}