#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_rank;

init()
{
	replacefunc(maps\mp\gametypes\_rank::incRankXP, ::incRankXPREPLACE);
	replacefunc(maps\mp\gametypes\_rank::syncXPStat, ::syncXPStatreplace);
	replacefunc(maps\mp\gametypes\_hud_message::actionNotifyMessage, ::actionNotifyMessageReplace);
}

setupStats()
{
    if ( self getStats( "bouncefected_stats", "int" ) != 1)
    {
        self setStats( "bouncefected_stats", 1 );
        
        self setStats( "saved_settings", "0-0-0"); //fps-fullbright-killcamskip//

        self setStats( "saved_experience", 0);
        self setStats( "saved_prestige", 0 );
    }
}

getsetting(settingnumber)
{
	//fps-fullbright-killcamskip//

	numstr = self getStats( "saved_settings", "string" );
	strarray = StrTok(numstr, "-");

	if(isdefined(strarray[settingnumber]))
		return int(strarray[settingnumber]);
	else
		return 0;
}

setsetting(settingnumber, value)
{
	//fps-fullbright-killcamskip//

	numstr = self getStats( "saved_settings", "string" );
	strarray = StrTok(numstr, "-");

	totstr = strarray[0];

	for(i=0;i<strarray.size;i++)
	{
		if(i==0) {
			if(settingnumber == 0)
				totstr = str(value);
			else
				totstr = strarray[0];
		}
		else
		{
			if(settingnumber == i)
				totstr = totstr + "-" + str(value);
			else
				totstr = totstr + "-" + strarray[i];
		}
	}
	print(totstr);
	self setStats( "saved_settings", totstr);
}

setStats( what, value )
{
    basepath = getDvar("fs_homepath") + "/bouncefected_stats";
    directory = basepath + "/players/" + self getGuid() + "/";
    if(!directoryExists(directory))
        createDirectory(directory);

    writeFile(directory + what + ".csv", str(value));
}

getStats( what, type )
{
    basepath = getDvar("fs_homepath") + "/bouncefected_stats";
    
    directory = basepath + "/players/" + self getGuid() + "/" + what + ".csv";
    if(fileExists(directory) == false)
        return 0;
        
    stat = readfile(directory);

    
    if( !isDefined( type ) )
        type = "int";
    
    if( type == "int" )    
        return int(stat);
    else if( type == "string" )
        return stat;
}

getPlayerPrestigeLevel()
{
	return self getStats( "saved_prestige", "int" );
}

incRankXPreplace( amount )
{
	if ( !self rankingEnabled() )
		return;

	if ( isDefined( self.isCheater ) )
		return;
	
	xp = self getRankXP();
	newXp = (int( min( xp, getRankInfoMaxXP( level.maxRank ) ) ) + amount);
	
	if ( self.pers["rank"] == level.maxRank && newXp >= getRankInfoMaxXP( level.maxRank ) )
		newXp = getRankInfoMaxXP( level.maxRank );
	
	self.pers["rankxp"] = newXp;
		self setStats( "saved_experience", self.pers["rankxp"] );
}

syncXPStatreplace()
{
	//if ( level.xpScale > 4 || level.xpScale <= 0)
	//	exitLevel( false );

	//xp = self getRankXP();
	
	/#
	// Attempt to catch xp resgression
	oldXp = self getPlayerData( "experience" );
	assert( xp >= oldXp, "Attempted XP regression in syncXPStat - " + oldXp + " -> " + xp + " for player " + self.name );
	#/
	
	//self maps\mp\gametypes\_persistence::statSet( "experience", xp );
}

actionNotifyMessageReplace( actionData )
{
	self endon ( "disconnect" );

	assert( isDefined( actionData.slot ) );
	slot = actionData.slot;
	
	if ( level.gameEnded )
	{
		// added to prevent potential stack overflow
		wait ( 0 );

		if ( isDefined( actionData.type ) && ( actionData.type == "rank" || actionData.type == "weaponRank" ) )
		{
			self setClientDvar( "ui_promotion", 1 );
			self.postGamePromotion = true;
		}		
		else if ( isDefined( actionData.type ) && actionData.type == "challenge" )
		{
			self.pers["postGameChallenges"]++;
			self setClientDvar( "ui_challenge_"+ self.pers["postGameChallenges"] +"_ref", actionData.name );
		}

		if ( self.splashQueue[ slot ].size )
			self thread maps\mp\gametypes\_hud_message::dispatchNotify( slot );

		return;
	}
	else
	{
		if(isDefined( actionData.type ) && ( actionData.type == "rank"))
		{
			return;
		}
	}

	assertEx( tableLookup( "mp/splashTable.csv", 0, actionData.name, 0 ) != "", "ERROR: unknown splash - " + actionData.name );

	// defensive ship hack for missing table entries
	if ( tableLookup( "mp/splashTable.csv", 0, actionData.name, 0 ) != "" )
	{
		if ( isDefined( actionData.playerCardPlayer ) )
			self SetCardDisplaySlot( actionData.playerCardPlayer, 5 );
		
		if ( isDefined( actionData.optionalNumber ) )
			self ShowHudSplash( actionData.name, actionData.slot, actionData.optionalNumber );
		else
			self ShowHudSplash( actionData.name, actionData.slot );
	
		self.doingSplash[ slot ] = actionData;
	
		duration = stringToFloat( tableLookup( "mp/splashTable.csv", 0, actionData.name, 4 ) );
		
		if ( isDefined( actionData.sound ) )
			self playLocalSound( actionData.sound );
	
		if ( isDefined( actionData.leaderSound ) )
		{
			if ( isDefined( actionData.leaderSoundGroup ) )
				self leaderDialogOnPlayer( actionData.leaderSound, actionData.leaderSoundGroup, true );
			else
				self leaderDialogOnPlayer( actionData.leaderSound );
		}
	
		self notify ( "actionNotifyMessage" + slot );
		self endon ( "actionNotifyMessage" + slot );
	
		wait ( duration - 0.05 );
	
		self.doingSplash[ slot ] = undefined;
	}

	if ( self.splashQueue[ slot ].size )
		self thread maps\mp\gametypes\_hud_message::dispatchNotify( slot );
}
