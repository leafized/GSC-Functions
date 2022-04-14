// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\core_common\clientfield_shared.csc;
#using scripts\core_common\struct.csc;
#using scripts\core_common\util_shared.csc;

#namespace gibclientutils;

/*
	Name: main
	Namespace: gibclientutils
	Checksum: 0xAB3427A1
	Offset: 0x228
	Size: 0xBC
	Parameters: 0
	Flags: AutoExec
*/
function autoexec main()
{
	clientfield::register("actor", "gib_state", 1, 9, "int", &_gibhandler, 0, 0);
	clientfield::register("playercorpse", "gib_state", 1, 15, "int", &_gibhandler, 0, 0);
	level.var_ad0f5efa = [];
	level thread _annihilatecorpse();
}

/*
	Name: function_3aa023f1
	Namespace: gibclientutils
	Checksum: 0xE7027F20
	Offset: 0x2F0
	Size: 0x306
	Parameters: 1
	Flags: Linked, Private
*/
function private function_3aa023f1(name)
{
	if(!isdefined(name))
	{
		return undefined;
	}
	gibdef = level.var_ad0f5efa[name];
	if(isdefined(gibdef))
	{
		return gibdef;
	}
	definition = struct::get_script_bundle("gibcharacterdef", name);
	if(!isdefined(definition))
	{
		/#
			assertmsg("" + name);
		#/
		return undefined;
	}
	gibpiecelookup = [];
	gibpiecelookup[2] = "annihilate";
	gibpiecelookup[8] = "head";
	gibpiecelookup[16] = "rightarm";
	gibpiecelookup[32] = "leftarm";
	gibpiecelookup[128] = "rightleg";
	gibpiecelookup[256] = "leftleg";
	var_90aba050 = [];
	foreach(gibflag, gibpiece in gibpiecelookup)
	{
		if(!isdefined(gibpiece))
		{
			/#
				assertmsg("" + gibflag);
			#/
			continue;
		}
		gibstruct = spawnstruct();
		gibstruct.gibmodel = definition.(gibpiece + "_gibmodel");
		gibstruct.gibtag = definition.(gibpiece + "_gibtag");
		gibstruct.gibfx = definition.(gibpiece + "_gibfx");
		gibstruct.gibfxtag = definition.(gibpiece + "_gibeffecttag");
		gibstruct.gibdynentfx = definition.(gibpiece + "_gibdynentfx");
		gibstruct.gibcinematicfx = definition.(gibpiece + "_gibcinematicfx");
		gibstruct.gibsound = definition.(gibpiece + "_gibsound");
		gibstruct.gibhidetag = definition.(gibpiece + "_gibhidetag");
		var_90aba050[gibflag] = gibstruct;
	}
	level.var_ad0f5efa[name] = var_90aba050;
	return var_90aba050;
}

/*
	Name: function_9fe14ca3
	Namespace: gibclientutils
	Checksum: 0x86EF1CF0
	Offset: 0x600
	Size: 0x366
	Parameters: 2
	Flags: Linked, Private
*/
function private function_9fe14ca3(entity, gibflag)
{
	if(gibflag == 8)
	{
		part = "head";
	}
	else
	{
		if(gibflag == 16 || gibflag == 32)
		{
			part = "arms";
		}
		else if(gibflag == 128 || gibflag == 256)
		{
			part = "legs";
		}
	}
	if(!isdefined(part))
	{
		return undefined;
	}
	name = entity getplayergibdef(part);
	if(!isdefined(name))
	{
		/#
			assertmsg("" + gibflag);
		#/
		return undefined;
	}
	gibdef = level.var_ad0f5efa[name];
	if(isdefined(gibdef))
	{
		return gibdef;
	}
	definition = struct::get_script_bundle("playeroutfitgibdef", name);
	if(!isdefined(definition))
	{
		/#
			assertmsg("" + name);
		#/
		return undefined;
	}
	gibpiecelookup = [];
	gibpiecelookup[0] = "left";
	gibpiecelookup[1] = "right";
	var_90aba050 = [];
	foreach(side, gibpiece in gibpiecelookup)
	{
		if(!isdefined(gibpiece))
		{
			continue;
		}
		gibstruct = spawnstruct();
		gibstruct.gibmodel = definition.(gibpiece + "_gibmodel");
		gibstruct.gibtag = definition.(gibpiece + "_gibtag");
		gibstruct.gibfx = definition.(gibpiece + "_gibfx");
		gibstruct.gibfxtag = definition.(gibpiece + "_gibeffecttag");
		gibstruct.gibdynentfx = definition.(gibpiece + "_gibdynentfx");
		gibstruct.gibcinematicfx = definition.(gibpiece + "_gibcinematicfx");
		gibstruct.gibsound = definition.(gibpiece + "_gibsound");
		gibstruct.gibhidetag = definition.(gibpiece + "_gibhidetag");
		var_90aba050[side] = gibstruct;
	}
	level.var_ad0f5efa[name] = var_90aba050;
	return var_90aba050;
}

/*
	Name: function_c0099e86
	Namespace: gibclientutils
	Checksum: 0x4E90D68
	Offset: 0x970
	Size: 0xBA
	Parameters: 2
	Flags: Linked
*/
function function_c0099e86(entity, gibflag)
{
	gibpiece = function_9fe14ca3(entity, gibflag);
	if(!isdefined(gibpiece))
	{
		return undefined;
	}
	if(gibflag == 8)
	{
		side = 0;
	}
	else
	{
		if(gibflag == 16 || gibflag == 128)
		{
			side = 1;
		}
		else if(gibflag == 32 || gibflag == 256)
		{
			side = 0;
		}
	}
	return gibpiece[side];
}

/*
	Name: function_69db754
	Namespace: gibclientutils
	Checksum: 0x1D780E81
	Offset: 0xA38
	Size: 0xC8
	Parameters: 2
	Flags: Linked, Private
*/
function private function_69db754(entity, gibflag)
{
	if(isplayer(entity) || entity isplayercorpse())
	{
		return function_c0099e86(entity, gibflag);
	}
	if(isdefined(entity.gib_data))
	{
		var_90aba050 = function_3aa023f1(entity.gib_data.gibdef);
	}
	else
	{
		var_90aba050 = function_3aa023f1(entity.gibdef);
	}
	return var_90aba050[gibflag];
}

/*
	Name: _annihilatecorpse
	Namespace: gibclientutils
	Checksum: 0xBBB1E23
	Offset: 0xB08
	Size: 0x240
	Parameters: 0
	Flags: Linked, Private
*/
function private _annihilatecorpse()
{
	while(true)
	{
		waitresult = undefined;
		waitresult = level waittill(#"corpse_explode");
		localclientnum = waitresult.localclientnum;
		body = waitresult.body;
		origin = waitresult.position;
		if(!util::is_mature() || util::is_gib_restricted_build())
		{
			continue;
		}
		if(isdefined(body) && _hasgibdef(body) && body isragdoll())
		{
			cliententgibhead(localclientnum, body);
			cliententgibrightarm(localclientnum, body);
			cliententgibleftarm(localclientnum, body);
			cliententgibrightleg(localclientnum, body);
			cliententgibleftleg(localclientnum, body);
		}
		if(isdefined(body) && _hasgibdef(body) && body.archetype == #"human")
		{
			if(randomint(100) >= 50)
			{
				continue;
			}
			if(isdefined(origin) && distancesquared(body.origin, origin) <= 14400)
			{
				body.ignoreragdoll = 1;
				body _gibentity(localclientnum, 50 | 384, 1);
			}
		}
	}
}

/*
	Name: _clonegibdata
	Namespace: gibclientutils
	Checksum: 0x77C28495
	Offset: 0xD50
	Size: 0x1D6
	Parameters: 3
	Flags: Linked, Private
*/
function private _clonegibdata(localclientnum, entity, clone)
{
	clone.gib_data = spawnstruct();
	clone.gib_data.gib_state = entity.gib_state;
	clone.gib_data.gibdef = entity.gibdef;
	clone.gib_data.hatmodel = entity.hatmodel;
	clone.gib_data.head = entity.head;
	clone.gib_data.legdmg1 = entity.legdmg1;
	clone.gib_data.legdmg2 = entity.legdmg2;
	clone.gib_data.legdmg3 = entity.legdmg3;
	clone.gib_data.legdmg4 = entity.legdmg4;
	clone.gib_data.torsodmg1 = entity.torsodmg1;
	clone.gib_data.torsodmg2 = entity.torsodmg2;
	clone.gib_data.torsodmg3 = entity.torsodmg3;
	clone.gib_data.torsodmg4 = entity.torsodmg4;
	clone.gib_data.torsodmg5 = entity.torsodmg5;
}

/*
	Name: _getgibbedstate
	Namespace: gibclientutils
	Checksum: 0xC1CC393A
	Offset: 0xF30
	Size: 0x76
	Parameters: 2
	Flags: Linked, Private
*/
function private _getgibbedstate(localclientnum, entity)
{
	if(isdefined(entity.gib_data) && isdefined(entity.gib_data.gib_state))
	{
		return entity.gib_data.gib_state;
	}
	if(isdefined(entity.gib_state))
	{
		return entity.gib_state;
	}
	return 0;
}

/*
	Name: _getgibbedlegmodel
	Namespace: gibclientutils
	Checksum: 0xF7D34AE0
	Offset: 0xFB0
	Size: 0x15A
	Parameters: 2
	Flags: Linked, Private
*/
function private _getgibbedlegmodel(localclientnum, entity)
{
	gibstate = _getgibbedstate(localclientnum, entity);
	rightleggibbed = gibstate & 128;
	leftleggibbed = gibstate & 256;
	if(rightleggibbed && leftleggibbed)
	{
		return (isdefined(entity.gib_data) ? entity.gib_data.legdmg4 : entity.legdmg4);
	}
	if(rightleggibbed)
	{
		return (isdefined(entity.gib_data) ? entity.gib_data.legdmg2 : entity.legdmg2);
	}
	if(leftleggibbed)
	{
		return (isdefined(entity.gib_data) ? entity.gib_data.legdmg3 : entity.legdmg3);
	}
	return (isdefined(entity.gib_data) ? entity.gib_data.legdmg1 : entity.legdmg1);
}

/*
	Name: _getgibextramodel
	Namespace: gibclientutils
	Checksum: 0xDE24FDB6
	Offset: 0x1118
	Size: 0xCC
	Parameters: 3
	Flags: Linked, Private
*/
function private _getgibextramodel(localclientnumm, entity, gibflag)
{
	if(gibflag == 4)
	{
		return (isdefined(entity.gib_data) ? entity.gib_data.hatmodel : entity.hatmodel);
	}
	if(gibflag == 8)
	{
		return (isdefined(entity.gib_data) ? entity.gib_data.head : entity.head);
	}
	/#
		assertmsg("");
	#/
}

/*
	Name: _getgibbedtorsomodel
	Namespace: gibclientutils
	Checksum: 0x3DF54EE8
	Offset: 0x11F0
	Size: 0x15A
	Parameters: 2
	Flags: Linked, Private
*/
function private _getgibbedtorsomodel(localclientnum, entity)
{
	gibstate = _getgibbedstate(localclientnum, entity);
	rightarmgibbed = gibstate & 16;
	leftarmgibbed = gibstate & 32;
	if(rightarmgibbed && leftarmgibbed)
	{
		return (isdefined(entity.gib_data) ? entity.gib_data.torsodmg2 : entity.torsodmg2);
	}
	if(rightarmgibbed)
	{
		return (isdefined(entity.gib_data) ? entity.gib_data.torsodmg2 : entity.torsodmg2);
	}
	if(leftarmgibbed)
	{
		return (isdefined(entity.gib_data) ? entity.gib_data.torsodmg3 : entity.torsodmg3);
	}
	return (isdefined(entity.gib_data) ? entity.gib_data.torsodmg1 : entity.torsodmg1);
}

/*
	Name: _gibpiecetag
	Namespace: gibclientutils
	Checksum: 0x1DB711C0
	Offset: 0x1358
	Size: 0x74
	Parameters: 3
	Flags: Linked, Private
*/
function private _gibpiecetag(localclientnum, entity, gibflag)
{
	if(!_hasgibdef(self))
	{
		return;
	}
	gibpiece = function_69db754(entity, gibflag);
	if(isdefined(gibpiece))
	{
		return gibpiece.gibfxtag;
	}
}

/*
	Name: function_ba120c50
	Namespace: gibclientutils
	Checksum: 0xC65F4DDD
	Offset: 0x13D8
	Size: 0x72
	Parameters: 1
	Flags: Linked, Private
*/
function private function_ba120c50(gibflags)
{
	var_ec7623a6 = 0;
	if(gibflags & 12)
	{
		var_ec7623a6 = var_ec7623a6 | 1;
	}
	if(gibflags & 48)
	{
		var_ec7623a6 = var_ec7623a6 | 2;
	}
	if(gibflags & 384)
	{
		var_ec7623a6 = var_ec7623a6 | 4;
	}
	return var_ec7623a6;
}

/*
	Name: _gibentity
	Namespace: gibclientutils
	Checksum: 0x33AF80C1
	Offset: 0x1458
	Size: 0x42E
	Parameters: 3
	Flags: Linked, Private
*/
function private _gibentity(localclientnum, gibflags, shouldspawngibs)
{
	entity = self;
	if(!_hasgibdef(entity))
	{
		return;
	}
	currentgibflag = 2;
	gibdir = undefined;
	var_8e57b530 = undefined;
	if(isplayer(entity) || entity isplayercorpse())
	{
		yaw_bits = (gibflags >> 9) & (8 - 1);
		yaw = getanglefrombits(yaw_bits, 3);
		gibdir = anglestoforward((0, yaw, 0));
	}
	while(gibflags >= currentgibflag)
	{
		if(gibflags & currentgibflag)
		{
			if(currentgibflag == 2)
			{
				if(isplayer(entity) || entity isplayercorpse())
				{
					var_c0c9eae3 = entity function_4976d5ee();
					_playgibfx(localclientnum, entity, var_c0c9eae3[#"fx"], var_c0c9eae3[#"tag"]);
				}
				else
				{
					gibpiece = function_69db754(entity, currentgibflag);
					if(isdefined(gibpiece))
					{
						_playgibfx(localclientnum, entity, gibpiece.gibfx, gibpiece.gibfxtag);
						if(isdefined(gibpiece.gibcinematicfx))
						{
							if(function_92beaa28(localclientnum))
							{
								_playgibfx(localclientnum, entity, gibpiece.gibcinematicfx, gibpiece.gibfxtag);
							}
						}
						_playgibsound(localclientnum, entity, gibpiece.gibsound);
					}
				}
				entity hide();
				entity.ignoreragdoll = 1;
			}
			else
			{
				gibpiece = function_69db754(entity, currentgibflag);
				if(isdefined(gibpiece))
				{
					if(shouldspawngibs)
					{
						var_cd61eb7d = function_ba120c50(currentgibflag);
						entity thread _gibpiece(localclientnum, entity, gibpiece.gibmodel, gibpiece.gibtag, gibpiece.gibdynentfx, gibdir, var_8e57b530, var_cd61eb7d);
					}
					_playgibfx(localclientnum, entity, gibpiece.gibfx, gibpiece.gibfxtag);
					if(isdefined(gibpiece.gibcinematicfx))
					{
						if(function_92beaa28(localclientnum))
						{
							_playgibfx(localclientnum, entity, gibpiece.gibcinematicfx, gibpiece.gibfxtag);
						}
					}
					_playgibsound(localclientnum, entity, gibpiece.gibsound);
				}
			}
			_handlegibcallbacks(localclientnum, entity, currentgibflag);
		}
		currentgibflag = currentgibflag << 1;
	}
}

/*
	Name: _setgibbed
	Namespace: gibclientutils
	Checksum: 0xC3A6C62
	Offset: 0x1890
	Size: 0x8A
	Parameters: 3
	Flags: Linked, Private
*/
function private _setgibbed(localclientnum, entity, gibflag)
{
	gib_state = _getgibbedstate(localclientnum, entity) | (gibflag & (512 - 1));
	if(isdefined(entity.gib_data))
	{
		entity.gib_data.gib_state = gib_state;
	}
	else
	{
		entity.gib_state = gib_state;
	}
}

/*
	Name: _gibcliententityinternal
	Namespace: gibclientutils
	Checksum: 0xD321F4E
	Offset: 0x1928
	Size: 0x1AC
	Parameters: 3
	Flags: Linked, Private
*/
function private _gibcliententityinternal(localclientnum, entity, gibflag)
{
	if(!util::is_mature() || util::is_gib_restricted_build())
	{
		return;
	}
	if(!isdefined(entity) || !_hasgibdef(entity))
	{
		return;
	}
	if(entity.type !== "scriptmover")
	{
		return;
	}
	if(isgibbed(localclientnum, entity, gibflag))
	{
		return;
	}
	if(!_getgibbedstate(localclientnum, entity) < 16)
	{
		legmodel = _getgibbedlegmodel(localclientnum, entity);
		entity detach(legmodel, "");
	}
	_setgibbed(localclientnum, entity, gibflag);
	entity setmodel(_getgibbedtorsomodel(localclientnum, entity));
	entity attach(_getgibbedlegmodel(localclientnum, entity), "");
	entity _gibentity(localclientnum, gibflag, 1);
}

/*
	Name: _gibclientextrainternal
	Namespace: gibclientutils
	Checksum: 0x1E21CE29
	Offset: 0x1AE0
	Size: 0x1DC
	Parameters: 3
	Flags: Linked, Private
*/
function private _gibclientextrainternal(localclientnum, entity, gibflag)
{
	if(!util::is_mature() || util::is_gib_restricted_build())
	{
		return;
	}
	if(!isdefined(entity))
	{
		return;
	}
	if(entity.type !== "scriptmover")
	{
		return;
	}
	if(isgibbed(localclientnum, entity, gibflag))
	{
		return;
	}
	gibmodel = _getgibextramodel(localclientnum, entity, gibflag);
	if(isdefined(gibmodel) && entity isattached(gibmodel, ""))
	{
		entity detach(gibmodel, "");
	}
	if(gibflag == 8)
	{
		if(isdefined((isdefined(entity.gib_data) ? entity.gib_data.torsodmg5 : entity.torsodmg5)))
		{
			entity attach((isdefined(entity.gib_data) ? entity.gib_data.torsodmg5 : entity.torsodmg5), "");
		}
	}
	_setgibbed(localclientnum, entity, gibflag);
	entity _gibentity(localclientnum, gibflag, 1);
}

/*
	Name: _gibhandler
	Namespace: gibclientutils
	Checksum: 0xBF43390B
	Offset: 0x1CC8
	Size: 0x1B2
	Parameters: 7
	Flags: Linked, Private
*/
function private _gibhandler(localclientnum, oldvalue, newvalue, bnewent, binitialsnap, fieldname, wasdemojump)
{
	entity = self;
	if(isplayer(entity) || entity isplayercorpse())
	{
		if(!util::is_mature() || util::is_gib_restricted_build())
		{
			return;
		}
	}
	else
	{
		if(isdefined(entity.maturegib) && entity.maturegib && (!util::is_mature() || !isshowgibsenabled()))
		{
			return;
		}
		if(isdefined(entity.restrictedgib) && entity.restrictedgib && !isshowgibsenabled())
		{
			return;
		}
	}
	gibflags = oldvalue ^ newvalue;
	shouldspawngibs = !newvalue & 1;
	if(bnewent)
	{
		gibflags = 0 ^ newvalue;
	}
	entity _gibentity(localclientnum, gibflags, shouldspawngibs);
	entity.gib_state = newvalue;
}

/*
	Name: _gibpiece
	Namespace: gibclientutils
	Checksum: 0x12173CB7
	Offset: 0x1E88
	Size: 0x34C
	Parameters: 8
	Flags: Linked
*/
function _gibpiece(localclientnum, entity, gibmodel, gibtag, gibfx, gibdir, var_8e57b530, var_bf41adc0)
{
	if(!isdefined(gibtag) || !isdefined(gibmodel))
	{
		return;
	}
	startposition = entity gettagorigin(gibtag);
	startangles = entity gettagangles(gibtag);
	endposition = startposition;
	endangles = startangles;
	forwardvector = undefined;
	if(!isdefined(startposition) || !isdefined(startangles))
	{
		return false;
	}
	if(isdefined(gibdir) && !isdefined(var_8e57b530))
	{
		startposition = (0, 0, 0);
		forwardvector = gibdir;
		forwardvector = forwardvector * randomfloatrange(100, 500);
	}
	else
	{
		waitframe(1);
		if(isdefined(entity))
		{
			endposition = entity gettagorigin(gibtag);
			endangles = entity gettagangles(gibtag);
		}
		else
		{
			endposition = startposition + (anglestoforward(startangles) * 10);
			endangles = startangles;
		}
		if(!isdefined(endposition) || !isdefined(endangles))
		{
			return false;
		}
		scale = randomfloatrange(0.6, 1);
		dir = (randomfloatrange(0, 0.2), randomfloatrange(0, 0.2), randomfloatrange(0.2, 0.7));
		if(isdefined(gibdir) && isdefined(var_8e57b530) && var_8e57b530 > 0)
		{
			dir = gibdir + dir;
			scale = var_8e57b530;
		}
		forwardvector = vectornormalize(endposition - startposition);
		forwardvector = forwardvector * scale;
		forwardvector = forwardvector + dir;
	}
	if(isdefined(entity))
	{
		gibentity = createdynentandlaunch(localclientnum, gibmodel, endposition, endangles, startposition, forwardvector, gibfx, 1, !(isdefined(level.var_2f78f66c) && level.var_2f78f66c));
		if(isdefined(gibentity))
		{
			setdynentbodyrenderoptionspacked(gibentity, entity getbodyrenderoptionspacked(), var_bf41adc0);
		}
	}
}

/*
	Name: _handlegibcallbacks
	Namespace: gibclientutils
	Checksum: 0x70A0C52C
	Offset: 0x21E0
	Size: 0xC4
	Parameters: 3
	Flags: Linked, Private
*/
function private _handlegibcallbacks(localclientnum, entity, gibflag)
{
	if(isdefined(entity._gibcallbacks) && isdefined(entity._gibcallbacks[gibflag]))
	{
		foreach(callback in entity._gibcallbacks[gibflag])
		{
			[[callback]](localclientnum, entity, gibflag);
		}
	}
}

/*
	Name: _handlegibannihilate
	Namespace: gibclientutils
	Checksum: 0xA2335CA1
	Offset: 0x22B0
	Size: 0x7C
	Parameters: 1
	Flags: Linked, Private
*/
function private _handlegibannihilate(localclientnum)
{
	entity = self;
	entity endon(#"death");
	entity waittillmatch({#notetrack:"gib_annihilate"}, #"_anim_notify_");
	cliententgibannihilate(localclientnum, entity);
}

/*
	Name: _handlegibhead
	Namespace: gibclientutils
	Checksum: 0xCC7F78CF
	Offset: 0x2338
	Size: 0x7C
	Parameters: 1
	Flags: Linked, Private
*/
function private _handlegibhead(localclientnum)
{
	entity = self;
	entity endon(#"death");
	entity waittillmatch({#notetrack:"gib = \"head\""}, #"_anim_notify_");
	cliententgibhead(localclientnum, entity);
}

/*
	Name: _handlegibrightarm
	Namespace: gibclientutils
	Checksum: 0xDF41FE5C
	Offset: 0x23C0
	Size: 0x7C
	Parameters: 1
	Flags: Linked, Private
*/
function private _handlegibrightarm(localclientnum)
{
	entity = self;
	entity endon(#"death");
	entity waittillmatch({#notetrack:"gib = \"arm_right\""}, #"_anim_notify_");
	cliententgibrightarm(localclientnum, entity);
}

/*
	Name: _handlegibleftarm
	Namespace: gibclientutils
	Checksum: 0xA7949FE5
	Offset: 0x2448
	Size: 0x7C
	Parameters: 1
	Flags: Linked, Private
*/
function private _handlegibleftarm(localclientnum)
{
	entity = self;
	entity endon(#"death");
	entity waittillmatch({#notetrack:"gib = \"arm_left\""}, #"_anim_notify_");
	cliententgibleftarm(localclientnum, entity);
}

/*
	Name: _handlegibrightleg
	Namespace: gibclientutils
	Checksum: 0xFF595C34
	Offset: 0x24D0
	Size: 0x7C
	Parameters: 1
	Flags: Linked, Private
*/
function private _handlegibrightleg(localclientnum)
{
	entity = self;
	entity endon(#"death");
	entity waittillmatch({#notetrack:"gib = \"leg_right\""}, #"_anim_notify_");
	cliententgibrightleg(localclientnum, entity);
}

/*
	Name: _handlegibleftleg
	Namespace: gibclientutils
	Checksum: 0xB40DB692
	Offset: 0x2558
	Size: 0x7C
	Parameters: 1
	Flags: Linked, Private
*/
function private _handlegibleftleg(localclientnum)
{
	entity = self;
	entity endon(#"death");
	entity waittillmatch({#notetrack:"gib = \"leg_left\""}, #"_anim_notify_");
	cliententgibleftleg(localclientnum, entity);
}

/*
	Name: _hasgibdef
	Namespace: gibclientutils
	Checksum: 0x3C3641F4
	Offset: 0x25E0
	Size: 0x88
	Parameters: 1
	Flags: Linked, Private
*/
function private _hasgibdef(entity)
{
	return isdefined(entity.gib_data) && isdefined(entity.gib_data.gibdef) || isdefined(entity.gibdef) || (isdefined(entity getplayergibdef("arms")) && isdefined(entity getplayergibdef("legs")));
}

/*
	Name: _playgibfx
	Namespace: gibclientutils
	Checksum: 0xD2317F83
	Offset: 0x2670
	Size: 0x102
	Parameters: 4
	Flags: Linked
*/
function _playgibfx(localclientnum, entity, fxfilename, fxtag)
{
	if(isdefined(fxfilename) && isdefined(fxtag) && entity hasdobj(localclientnum))
	{
		fx = util::playfxontag(localclientnum, fxfilename, entity, fxtag);
		if(isdefined(fx))
		{
			if(isdefined(entity.team))
			{
				setfxteam(localclientnum, fx, entity.team);
			}
			if(isdefined(level.setgibfxtoignorepause) && level.setgibfxtoignorepause)
			{
				setfxignorepause(localclientnum, fx, 1);
			}
		}
		return fx;
	}
}

/*
	Name: _playgibsound
	Namespace: gibclientutils
	Checksum: 0x5A68A21B
	Offset: 0x2780
	Size: 0x44
	Parameters: 3
	Flags: Linked
*/
function _playgibsound(localclientnum, entity, soundalias)
{
	if(isdefined(soundalias))
	{
		playsound(localclientnum, soundalias, entity.origin);
	}
}

/*
	Name: addgibcallback
	Namespace: gibclientutils
	Checksum: 0x922B322
	Offset: 0x27D0
	Size: 0xDE
	Parameters: 4
	Flags: Linked
*/
function addgibcallback(localclientnum, entity, gibflag, callbackfunction)
{
	/#
		assert(isfunctionptr(callbackfunction));
	#/
	if(!isdefined(entity._gibcallbacks))
	{
		entity._gibcallbacks = [];
	}
	if(!isdefined(entity._gibcallbacks[gibflag]))
	{
		entity._gibcallbacks[gibflag] = [];
	}
	gibcallbacks = entity._gibcallbacks[gibflag];
	gibcallbacks[gibcallbacks.size] = callbackfunction;
	entity._gibcallbacks[gibflag] = gibcallbacks;
}

/*
	Name: cliententgibannihilate
	Namespace: gibclientutils
	Checksum: 0x2DB5EADE
	Offset: 0x28B8
	Size: 0x7C
	Parameters: 2
	Flags: Linked
*/
function cliententgibannihilate(localclientnum, entity)
{
	if(!util::is_mature() || util::is_gib_restricted_build())
	{
		return;
	}
	entity.ignoreragdoll = 1;
	entity _gibentity(localclientnum, 50 | 384, 1);
}

/*
	Name: cliententgibhead
	Namespace: gibclientutils
	Checksum: 0xF6D35110
	Offset: 0x2940
	Size: 0x34
	Parameters: 2
	Flags: Linked
*/
function cliententgibhead(localclientnum, entity)
{
	_gibclientextrainternal(localclientnum, entity, 8);
}

/*
	Name: cliententgibleftarm
	Namespace: gibclientutils
	Checksum: 0xB45E9EF4
	Offset: 0x2980
	Size: 0x54
	Parameters: 2
	Flags: Linked
*/
function cliententgibleftarm(localclientnum, entity)
{
	if(isgibbed(localclientnum, entity, 16))
	{
		return;
	}
	_gibcliententityinternal(localclientnum, entity, 32);
}

/*
	Name: cliententgibrightarm
	Namespace: gibclientutils
	Checksum: 0x2A123C72
	Offset: 0x29E0
	Size: 0x54
	Parameters: 2
	Flags: Linked
*/
function cliententgibrightarm(localclientnum, entity)
{
	if(isgibbed(localclientnum, entity, 32))
	{
		return;
	}
	_gibcliententityinternal(localclientnum, entity, 16);
}

/*
	Name: cliententgibleftleg
	Namespace: gibclientutils
	Checksum: 0x54B5280C
	Offset: 0x2A40
	Size: 0x34
	Parameters: 2
	Flags: Linked
*/
function cliententgibleftleg(localclientnum, entity)
{
	_gibcliententityinternal(localclientnum, entity, 256);
}

/*
	Name: cliententgibrightleg
	Namespace: gibclientutils
	Checksum: 0xF366D8DC
	Offset: 0x2A80
	Size: 0x34
	Parameters: 2
	Flags: Linked
*/
function cliententgibrightleg(localclientnum, entity)
{
	_gibcliententityinternal(localclientnum, entity, 128);
}

/*
	Name: createscriptmodelofentity
	Namespace: gibclientutils
	Checksum: 0xCEF493E9
	Offset: 0x2AC0
	Size: 0x330
	Parameters: 2
	Flags: None
*/
function createscriptmodelofentity(localclientnum, entity)
{
	clone = spawn(localclientnum, entity.origin, "script_model");
	clone.angles = entity.angles;
	_clonegibdata(localclientnum, entity, clone);
	gibstate = _getgibbedstate(localclientnum, clone);
	if(!util::is_mature() || util::is_gib_restricted_build())
	{
		gibstate = 0;
	}
	if(!_getgibbedstate(localclientnum, entity) < 16)
	{
		clone setmodel(_getgibbedtorsomodel(localclientnum, entity));
		clone attach(_getgibbedlegmodel(localclientnum, entity), "");
	}
	else
	{
		clone setmodel(entity.model);
	}
	if(gibstate & 8)
	{
		if(isdefined((isdefined(clone.gib_data) ? clone.gib_data.torsodmg5 : clone.torsodmg5)))
		{
			clone attach((isdefined(clone.gib_data) ? clone.gib_data.torsodmg5 : clone.torsodmg5), "");
		}
	}
	else
	{
		if(isdefined((isdefined(clone.gib_data) ? clone.gib_data.head : clone.head)))
		{
			clone attach((isdefined(clone.gib_data) ? clone.gib_data.head : clone.head), "");
		}
		if(!gibstate & 4 && isdefined((isdefined(clone.gib_data) ? clone.gib_data.hatmodel : clone.hatmodel)))
		{
			clone attach((isdefined(clone.gib_data) ? clone.gib_data.hatmodel : clone.hatmodel), "");
		}
	}
	return clone;
}

/*
	Name: isgibbed
	Namespace: gibclientutils
	Checksum: 0x8798F384
	Offset: 0x2DF8
	Size: 0x38
	Parameters: 3
	Flags: Linked
*/
function isgibbed(localclientnum, entity, gibflag)
{
	return _getgibbedstate(localclientnum, entity) & gibflag;
}

/*
	Name: isundamaged
	Namespace: gibclientutils
	Checksum: 0xF72246D9
	Offset: 0x2E38
	Size: 0x2E
	Parameters: 2
	Flags: None
*/
function isundamaged(localclientnum, entity)
{
	return _getgibbedstate(localclientnum, entity) == 0;
}

/*
	Name: gibentity
	Namespace: gibclientutils
	Checksum: 0x38B8C3A9
	Offset: 0x2E70
	Size: 0x66
	Parameters: 2
	Flags: Linked
*/
function gibentity(localclientnum, gibflags)
{
	self _gibentity(localclientnum, gibflags, 1);
	self.gib_state = _getgibbedstate(localclientnum, self) | (gibflags & (512 - 1));
}

/*
	Name: handlegibnotetracks
	Namespace: gibclientutils
	Checksum: 0xBB905F6F
	Offset: 0x2EE0
	Size: 0xAC
	Parameters: 1
	Flags: None
*/
function handlegibnotetracks(localclientnum)
{
	entity = self;
	entity thread _handlegibannihilate(localclientnum);
	entity thread _handlegibhead(localclientnum);
	entity thread _handlegibrightarm(localclientnum);
	entity thread _handlegibleftarm(localclientnum);
	entity thread _handlegibrightleg(localclientnum);
	entity thread _handlegibleftleg(localclientnum);
}

/*
	Name: playergibleftarm
	Namespace: gibclientutils
	Checksum: 0xB8D783E4
	Offset: 0x2F98
	Size: 0x2C
	Parameters: 1
	Flags: None
*/
function playergibleftarm(localclientnum)
{
	self gibentity(localclientnum, 32);
}

/*
	Name: playergibrightarm
	Namespace: gibclientutils
	Checksum: 0x30E5F3DD
	Offset: 0x2FD0
	Size: 0x2C
	Parameters: 1
	Flags: None
*/
function playergibrightarm(localclientnum)
{
	self gibentity(localclientnum, 16);
}

/*
	Name: playergibleftleg
	Namespace: gibclientutils
	Checksum: 0xF4A090CF
	Offset: 0x3008
	Size: 0x2C
	Parameters: 1
	Flags: None
*/
function playergibleftleg(localclientnum)
{
	self gibentity(localclientnum, 256);
}

/*
	Name: playergibrightleg
	Namespace: gibclientutils
	Checksum: 0x8994BD1F
	Offset: 0x3040
	Size: 0x2C
	Parameters: 1
	Flags: None
*/
function playergibrightleg(localclientnum)
{
	self gibentity(localclientnum, 128);
}

/*
	Name: playergiblegs
	Namespace: gibclientutils
	Checksum: 0x54144A3C
	Offset: 0x3078
	Size: 0x4C
	Parameters: 1
	Flags: None
*/
function playergiblegs(localclientnum)
{
	self gibentity(localclientnum, 128);
	self gibentity(localclientnum, 256);
}

/*
	Name: playergibtag
	Namespace: gibclientutils
	Checksum: 0x4BDF8577
	Offset: 0x30D0
	Size: 0x2A
	Parameters: 2
	Flags: None
*/
function playergibtag(localclientnum, gibflag)
{
	return _gibpiecetag(localclientnum, self, gibflag);
}

