// Status Level File

main()
{
	event1();
	event2();
	event2_2();
}

event1()
{
	maps\_status::scripter_task( "Event1", 5, 100, "done" );
		maps\_status::scripter_subtask( "Objectives", 1, 100, "done" );
		maps\_status::scripter_subtask( "Gameplay", 1, 100, "done" );
		maps\_status::scripter_subtask( "IGC Camera", 1, 100, "no igc" );
		maps\_status::scripter_subtask( "Animation", 1, 100, "got assets. Some don't work right" );	
		maps\_status::scripter_subtask( "FX", 1, 50, "need artillery explosions at beginning" );
}

event2()
{
	maps\_status::scripter_task( "Event2", 5, 100, "done" );
		maps\_status::scripter_subtask( "Objectives", 1, 100, "done" );
		maps\_status::scripter_subtask( "Gameplay", 1, 100, "done" );
		maps\_status::scripter_subtask( "Animation", 1, 100, "no canned animations" );	
		maps\_status::scripter_subtask( "FX (if applicable)", 1, 100, "no level specific fx yet" );
}

event2_2()
{
	maps\_status::scripter_task( "Event2_2", 5, 100, "" );
		maps\_status::scripter_subtask( "Objectives", 1, 100, "done" );
		maps\_status::scripter_subtask( "Gameplay", 1, 100, "done" );
		maps\_status::scripter_subtask( "IGC Camera", 1, 100, "no IGC" );
		maps\_status::scripter_subtask( "Animation", 1, 100, "no canned animations" );	
		maps\_status::scripter_subtask( "FX (if applicable)", 1, 100, "no level specific fx yet" );
}
