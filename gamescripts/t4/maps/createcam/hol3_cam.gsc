//Created by _createcam.gsc, if you need help talk to MikeD
main()
{
     // intro
     maps\_camsys::create_cam_node( "intro", (-127, -839, 677), (10, 90, 0), 0, 0, 0 );
     maps\_camsys::create_cam_node( "intro", (-129, -821, 427), (7, 90, 0), 3000, 0, 0 );
     maps\_camsys::create_cam_node( "intro", (-131, -827, 273), (3, 90, 0), 2000, 0, 0 );
     maps\_camsys::create_cam_node( "intro", (-130, -833, 43), (0, 90, 0), 2000, 0, 0 );

     // mid
     maps\_camsys::create_cam_node( "mid", (-2415, 1759, 193), (10, 30, 0), 0, 0, 0 );
     maps\_camsys::create_cam_node( "mid", (-2001, 1669, 169), (0, 45, 0), 3000, 0, 0 );
     maps\_camsys::create_cam_node( "mid", (-1645, 1627, 167), (0, 100, 0), 3000, 0, 0 );
     maps\_camsys::create_cam_node( "mid", (-1288, 1631, 131), (0, 125, 0), 3000, 0, 0 );

     // end
     maps\_camsys::create_cam_node( "end", (3301, 5022, 740), (19, 45, 0), 0, 0, 0 );
     maps\_camsys::create_cam_node( "end", (3879, 4864, 740), (19, 75, 0), 4000, 0, 0 );
     maps\_camsys::create_cam_node( "end", (4435, 4914, 740), (19, 100, 0), 4000, 0, 0 );
     maps\_camsys::create_cam_node( "end", (5024, 5254, 740), (19, 135, 0), 4000, 0, 0 );

}
