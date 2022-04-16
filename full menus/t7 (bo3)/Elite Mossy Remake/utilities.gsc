createText(font, fontScale, align, relative, x, y, sort, alpha, text, color, isLevel)
{
    if(isDefined(isLevel))
        textElem = level hud::createServerFontString(font, fontScale);
    else 
        textElem = self hud::createFontString(font, fontScale);

    textElem hud::setPoint(align, relative, x, y);
    textElem.hideWhenInMenu = true;
    textElem.archived = false;

    textElem.sort           = sort;
    textElem.alpha          = alpha;
    textElem.color = color;

    textElem SetText(text);
    return textElem;
}

createRectangle(align, relative, x, y, width, height, color, shader, sort, alpha, server)
{
    if(isDefined(server))
        boxElem = newHudElem();
    else
        boxElem = newClientHudElem(self);

    boxElem.elemType = "icon";
    boxElem.color = color;
    if(!level.splitScreen)
    {
        boxElem.x = -2;
        boxElem.y = -2;
    }
    boxElem.hideWhenInMenu = true;
    boxElem.archived = false;
    
    boxElem.width          = width;
    boxElem.height         = height;
    boxElem.align          = align;
    boxElem.relative       = relative;
    boxElem.xOffset        = 0;
    boxElem.yOffset        = 0;
    boxElem.children       = [];
    boxElem.sort           = sort;
    boxElem.alpha          = alpha;
    boxElem.shader         = shader;

    boxElem hud::setParent(level.uiParent);
    boxElem setShader(shader, width, height);
    boxElem.hidden = false;
    boxElem hud::setPoint(align, relative, x, y);
    return boxElem;
}

isInArray( array, text )
{
    for(e=0;e<array.size;e++)
        if( array[e] == text )
            return true;
    return false;        
}

getName()
{
    name = self.name;
    if(name[0] != "[")
        return name;
    for(a = name.size - 1; a >= 0; a--)
        if(name[a] == "]")
            break;
    return(getSubStr(name, a + 1));
}

destroyAll(array)
{
    if(!isDefined(array))
        return;
    keys = getArrayKeys(array);
    for(a=0;a<keys.size;a++)
    if(isDefined(array[keys[a]][0]))
        for(e=0;e<array[keys[a]].size;e++)
            array[keys[a]][e] destroy();
    else
        array[keys[a]] destroy();
}
    
bool(variable)
{
    return isdefined(variable) && int(variable);
}

toUpper( string )
{
    if( !isDefined( string ) || string.size <= 0 )
        return "";
    alphabet = strTok("A;B;C;D;E;F;G;H;I;J;K;L;M;N;O;P;Q;R;S;T;U;V;W;X;Y;Z;0;1;2;3;4;5;6;7;8;9; ;-;_", ";");
    final    = "";
    for(e=0;e<string.size;e++)
        for(a=0;a<alphabet.size;a++)
            if(IsSubStr(toLower(string[e]), toLower(alphabet[a])))         
                final += alphabet[a];
    return final;            
}

hudFade(alpha, time)
{
    self endon("StopFade");
    self fadeOverTime(time);
    self.alpha = alpha;
    wait time;
}

hudMoveX(x, time)
{
    self moveOverTime(time);
    self.x = x;
    wait time;
}

hudMoveY(y, time)
{
    self moveOverTime(time);
    self.y = y;
    wait time;
}

hasMenu()
{
    if( IsDefined( self.access ) && self.access != "None" )
        return true;
    return false;    
}

getSubmenusColourAccess(access)
{
    switch(access)
    {
        case 2:
            colour = (1, 1, 0);
            break;
            
        case 3:
            colour = (1, 0, 1);
            break;
            
        case 4:
            colour = (0, 1, 1);
            break;
            
        default:
            colour = (1, 1, 1);
            break;
    }
        
    return colour;
}
