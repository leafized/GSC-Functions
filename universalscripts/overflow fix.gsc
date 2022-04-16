/*
    Notes: A Basic overflow fix that should work for T4, T5, T6, IW4, IW5, IW6
*/

/*      How to use level.strings

    Put level.strings = []; in init()

    -- Example

    init()
    {
        level.strings = [];
        level thread onPlayerConnect();
    }

*/

/*      How to use addToStringArray & watchForOverflow

    Put addToStringArray in your create text function
    Put watchForOverFlow in your create text function

    -- Example

    createText(font, fontSize, sort, text, align, relative, x, y, alpha, color)
    {
        textElem                = self createFontString(font, fontSize); // This is a example

        self addToStringArray(text); // This will set the text
        textElem thread watchForOverFlow(text); // This will watch for a otherflow
        
        return textElem;
    }

*/

/*      How to use fixOverflow

     Call on the host in onPlayerSpawned

     -- Example

    onPlayerSpawned()
    {
        if(self isHost()) // Checks for the host
            self thread fixOverflow(); // Only the host needs to run the overflow fix
    }

*/

fixOverflow() // Call this on the host in onPlayerSpawned
{
    level.overflow       = NewHudElem(); // Make a new hud elem
    level.overflow.alpha = 0;
    level.overflow setText("marker");
    
    while(1)
    {
        level waittill("CHECK_OVERFLOW");
        if(level.strings.size >= 45) // The amount of strings before we clear the hud texts
        {
            level.overflow ClearAllTextAfterHudElem(); // Clears all hud elems.
            level.strings = []; // Clear the string array
            level notify("FIX_OVERFLOW"); // Notify that we have fixed the strings
        }
    }
}

setSafeText(text) // Instead of using setText use setSafeText
{
    self notify("stop_TextMonitor");
    self addToStringArray(text);
    self thread watchForOverflow(text);
}

addToStringArray(text)
{
    if(!isInArray(level.strings, text))
    {
        level.strings[level.strings.size] = text;
        level notify("CHECK_OVERFLOW");
    }
}

watchForOverflow(text)
{
    self endon("stop_TextMonitor");
    
    while(isDefined(self))
    {
        self SetText(text);
        level waittill("FIX_OVERFLOW"); // Waits till we fix the strings
    }
}

/*    PS: This is still a wip the code is fine but the comments may change    *\