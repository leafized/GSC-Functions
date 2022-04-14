// Status Level File for Holland 3

main()
{
/#
	event1();
	event2();
	event3();
	event4();
#/
}


event1()
{
/#
		maps\_status::scripter_task( "Event1", 5, 0 );
		maps\_status::scripter_subtask( "Objectives", 1, 100 );
		maps\_status::scripter_subtask( "Gameplay", 1, 100 );
		maps\_status::scripter_subtask( "Animation", 1, 100 );
		maps\_status::scripter_subtask( "IGC Camera", 1, 100 );
		maps\_status::scripter_subtask( "FX (if applicable)", 1, 100 );
#/
}


event2()
{
/#
		maps\_status::scripter_task( "Event2", 5, 0 );
		maps\_status::scripter_subtask( "Objectives", 1, 100 );
		maps\_status::scripter_subtask( "Gameplay", 1, 100 );
		maps\_status::scripter_subtask( "Animation", 1, 100 );
		maps\_status::scripter_subtask( "FX (if applicable)", 1, 100 );
#/
}


event3()
{
/#
		maps\_status::scripter_task( "Event3", 5, 0 );
		maps\_status::scripter_subtask( "Objectives", 1, 100 );
		maps\_status::scripter_subtask( "Gameplay", 1, 85 );
		maps\_status::scripter_subtask( "IGC Camera", 1, 100 );
		maps\_status::scripter_subtask( "Animation", 1, 100 );
		maps\_status::scripter_subtask( "FX (if applicable)", 1, 100 );
#/
}



event4()
{
/#
		maps\_status::scripter_task( "Event4", 5, 0 );
		maps\_status::scripter_subtask( "Objectives", 1, 100 );
		maps\_status::scripter_subtask( "Gameplay", 1, 65 );
		maps\_status::scripter_subtask( "Animation", 1, 100 );	
		maps\_status::scripter_subtask( "FX (if applicable)", 1, 100 );
#/
}


