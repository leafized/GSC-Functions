// Status Level File

main()
{
	/#
	event1();
	#/
}

event1()
{
	/#
	maps\_status::scripter_task( "Event1", 5, 0 );
	maps\_status::scripter_subtask( "Objectives", 1, 100 );
	maps\_status::scripter_subtask( "Gameplay", 1, 100 );
	maps\_status::scripter_subtask( "IGC Camera", 1, 0 );
	maps\_status::scripter_subtask( "Animation", 1, 0 );	
	maps\_status::scripter_subtask( "FX (if applicable)", 1, 0 );
	#/
}