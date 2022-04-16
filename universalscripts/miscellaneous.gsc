/*
    FUNCTION NAME: setVision
    FUNCTION CALLER: player
    FUNCTION INPUT: setVision( "mpintro", 0.25 );
    DESCRIPTION: Sets a players vision
    NOTES: Only works on Zombies, For mp its host only ie visionSetNaked( vision, time );
*/

setVision(vision, time)
{
    self visionSetNaked( vision, time );
}