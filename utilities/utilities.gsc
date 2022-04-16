/*
    FUNCTION NAME: vectorScale
    FUNCTION INPUT: n/a
    DESCRIPTION: n/a
*/

vectorScale(vec, scale)
{
    vec = (vec[0] * scale, vec[1] * scale, vec[2] * scale);
    return vec;
}

/*
    FUNCTION NAME: divideColor
    FUNCTION INPUT: divideColor( 255, 0, 0 );
    DESCRIPTION: Converts RGB to floats for use with drawing
*/

divideColor(c1, c2, c3)
{
    return (c1 / 255, c2 / 255, c3 / 255);
}