/*-----------------------------------------------------
Status file for Rhineland 1
-----------------------------------------------------*/

main()
{
/#
	event1();
	event2();
	event3();
#/
}

//
// syntax reminders:
// - scripter_task( name, days, percent, note )
// - scripter_subtask( name, days, percent, note )
// - scripter_microtask( name, days, percent, note )
//  (above is the same for builder_task, etc.)
// - task( type, name, main_task, sub_task, days, percent, note )


event1()
{
/#
	maps\_status::scripter_task( "Event 1", 1, 0);
		maps\_status::scripter_subtask( "Objectives", 5, 0 );
		maps\_status::scripter_subtask( "Gameplay", 1, 0);
		maps\_status::scripter_subtask( "IGC Camera", 1, 0 );
		maps\_status::scripter_subtask( "Animation", 1, 0 );
		maps\_status::scripter_subtask( "FX", 1, 0 );
#/
}

event2()
{
/#
	maps\_status::scripter_task( "Event 2", 1, 0);
		maps\_status::scripter_subtask( "Objectives", 5, 0 );
		maps\_status::scripter_subtask( "Gameplay", 1, 0);
		maps\_status::scripter_subtask( "IGC Camera", 1, 0 );
		maps\_status::scripter_subtask( "Animation", 1, 0 );
		maps\_status::scripter_subtask( "FX", 1, 0 );
#/
}

event3()
{
/#
	maps\_status::scripter_task( "Event 3", 1, 0);
		maps\_status::scripter_subtask( "Objectives", 5, 0 );
		maps\_status::scripter_subtask( "Gameplay", 1, 0);
		maps\_status::scripter_subtask( "IGC Camera", 1, 0 );
		maps\_status::scripter_subtask( "Animation", 1, 0 );
		maps\_status::scripter_subtask( "FX", 1, 0  );
#/
}
