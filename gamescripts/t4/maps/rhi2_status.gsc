//
// file: rhi2_status.gsc
// description: status output script for rhineland2
// scripter: slayback
//
// syntax reminders:
// - scripter_task( name, days, percent, note )
// - scripter_subtask( name, days, percent, note )
// - scripter_microtask( name, days, percent, note )
//
// to show, change status_show dvar:
// - status_show [scripter]/[builder]
// - status_show off
//

build_status()
{
/#
	sweep1();
	barricade1();
	sweep2();
	convoywalk();
	bridge();
	church();
	
#/
}

sweep1()
{
/#
	maps\_status::scripter_task( "sweep", 5, 0 );
	maps\_status::scripter_subtask( "Objectives", 1, 100 );
	maps\_status::scripter_subtask( "Gameplay", 1, 100 );
	maps\_status::scripter_subtask( "IGC", 1, 100 );
	maps\_status::scripter_subtask( "Animation", 1, 0, "radioman anims delivered, not yet implemented" );
	maps\_status::scripter_subtask( "FX", 1, 100, "N/A" );
#/
}

barricade1()
{
/#
	maps\_status::scripter_task( "barricade1", 5, 0 );
	maps\_status::scripter_subtask( "Objectives", 1, 100 );
	maps\_status::scripter_subtask( "Gameplay", 1, 100 );
	maps\_status::scripter_subtask( "Animation", 1, 100, "N/A" );
	maps\_status::scripter_subtask( "FX", 1, 25, "waiting on real flame fx" );
#/
}

sweep2()
{
/#
	maps\_status::scripter_task( "sweep2", 5, 0 );
	maps\_status::scripter_subtask( "Objectives", 1, 100 );
	maps\_status::scripter_subtask( "Gameplay", 1, 100 );
	maps\_status::scripter_subtask( "Animation", 1, 0, "radioman anims delivered, not yet implemented" );
	maps\_status::scripter_subtask( "FX", 1, 100, "N/A" );
#/
}

convoywalk()
{
/#
	maps\_status::scripter_task( "convoywalk", 5, 0 );
	maps\_status::scripter_subtask( "Objectives", 1, 100 );
	maps\_status::scripter_subtask( "Gameplay", 1, 100 );
	maps\_status::scripter_subtask( "IGC", 1, 100 );
	maps\_status::scripter_subtask( "Animation", 1, 0, "N/A" );
	maps\_status::scripter_subtask( "FX", 1, 0, "N/A" );
#/
}

bridge()
{
/#
	maps\_status::scripter_task( "bridge", 5, 0 );
	maps\_status::scripter_subtask( "Objectives", 1, 100 );
	maps\_status::scripter_subtask( "Gameplay", 1, 100 );
	maps\_status::scripter_subtask( "Animation", 1, 0, "mg nest flap anims delivered, not yet implemented" );
	maps\_status::scripter_subtask( "FX", 1, 100, "N/A" );
#/
}

church()
{
/#
	maps\_status::scripter_task( "church", 5, 0 );
	maps\_status::scripter_subtask( "Objectives", 1, 100 );
	maps\_status::scripter_subtask( "Gameplay", 1, 100 );
	maps\_status::scripter_subtask( "IGC", 1, 100 );
	maps\_status::scripter_subtask( "Animation", 1, 100, "N/A" );
	maps\_status::scripter_subtask( "FX", 1, 100, "N/A" );
#/
}