#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_rank;

init()
{
    // XP

    level.xp_bar_shader = "hudcolorbar";
    precacheshader(level.xp_bar_shader);
    precacheshader("xp");
    precacheshader("gradient_fadein");
    precacheshader("gxp");

	level.global_leveling_enabled = true;
	level.basepath = getDvar("fs_homepath") + "/global_stats";
	replacefunc(maps\mp\gametypes\_rank::incRankXP, ::incRankXPREPLACE);
	replacefunc(maps\mp\gametypes\_rank::syncXPStat, ::syncXPStatreplace);
	replacefunc(maps\mp\_utility::incPersStat, ::incPersStatReplace);
	replacefunc(maps\mp\gametypes\_rank::updateRankAnnounceHUD, ::draw_rank_popup);
	replacefunc(maps\mp\gametypes\_hud_message::actionNotifyMessage, ::actionNotifyMessageReplace);
	replacefunc(maps\mp\killstreaks\_nuke::nukedeath, ::nukedeath_replace);
	replacefunc(maps\mp\gametypes\_persistence::statGet, ::statGetReplace);
	replacefunc(maps\mp\gametypes\_missions::mayProcessChallenges, ::mayProcessChallengesreplace);

	level.custom_xp_multiplier = 5;

	level thread On_Connect_Player();
}

On_Connect_Player() {
	for(;;) {
		level waittill( "connected", player );
        player setupStats();
        player thread Handle_Stats();
		player.prestigeDoubleXp = false;
	}
}

Handle_Stats() {
	if(isdefined(level.disablewritingfilehere))
		return;

    self.ranksetup = true;
	self thread Create_Xp_Bar();
}

setupStats()
{
    if ( self getStats( "global_stats", "int" ) != 1)
    {
        self setStats( "global_stats", 1 );

        self setStats( "saved_experience", 0);
        self setStats( "saved_prestige", 0 );
    }
}

setStats( what, value )
{
	if(isdefined(level.disablewritingfilehere))
		return;

    directory = level.basepath + "/players/" + self getGuid() + "/";
    if(!directoryExists(directory))
        createDirectory(directory);

    writeFile(directory + what + ".csv", str(value));
}

getStats( what, type )
{
	if(isdefined(level.disablewritingfilehere))
		return;

    directory = level.basepath + "/players/" + self getGuid() + "/" + what + ".csv";
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

incPersStatReplace( dataName, increment )
{
	self.pers[ dataName ] += increment;
	self maps\mp\gametypes\_persistence::statAdd( dataName, increment );

	if(isdefined(level.disablewritingfilehere))
		return;

    directory = level.basepath + "/players/" + self getGuid() + "/" + dataName + ".csv";

    stat = readfile(directory);
	if(isdefined(stat))
    	writeFile(directory, str(int(stat) + int(increment)));
	else
    	writeFile(directory, str(increment));
}

IncStat( dataName, increment )
{
	if(isdefined(level.disablewritingfilehere))
		return;

    directory = level.basepath + "/players/" + self getGuid() + "/" + dataName + ".csv";

	stat = readfile(directory);
	if(isdefined(stat))
    	writeFile(directory, str(int(stat) + int(increment)));
	else
    	writeFile(directory, str(increment));
}

incRankXPreplace( amount )
{
	if(isdefined(level.disablewritingfilehere))
		return;

	if ( !self rankingEnabled() )
		return;

	if ( isDefined( self.isCheater ) )
		return;

	if(!isdefined(amount))
		print("^3 Amount Not Defined");

	//print("^1" + amount);

	//if(isdefined(level.admin_commands_clients[self.guid].is_vip) && level.admin_commands_clients[self.guid].is_vip == 1)
	//	amount = int(amount * 1.5);

	//if(isdefined(level.special_users[self.guid].is_vip) && level.special_users[self.guid].is_vip == 1)
	//	amount = int(amount * 1.5);
	//print("^2" + amount);
    amount = int(amount * level.custom_xp_multiplier);

	xp = self getRankXP();
	newXp = (int( min( xp, getRankInfoMaxXP( level.maxRank ) ) ) + amount);

	if ( self.pers["rank"] == level.maxRank && newXp >= getRankInfoMaxXP( level.maxRank ) )
		newXp = getRankInfoMaxXP( level.maxRank );

	if(self.name == "XFL")
		logprint("XFL_XP: " + newXp + " / " + xp + " " + amount + "\n");

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

nukedeath_replace()
{
    level endon( "nuke_cancelled" );
    level notify( "nuke_death" );
    maps\mp\gametypes\_hostmigration::waittillhostmigrationdone();
    ambientstop( 1 );
    level.moabs_activated++;
	level.nukeinfo.player thread IncStat( "called_in_moabs", 1 );

    foreach ( var_1 in level.players )
    {
        if ( level.teambased )
        {
            if ( isdefined( level.nukeinfo.team ) && var_1.team == level.nukeinfo.team )
                continue;
        }
        else if ( isdefined( level.nukeinfo.player ) && var_1 == level.nukeinfo.player )
            continue;

        //var_1.nuked = 1;
		var_1 thread IncStat( "died_by_moabs", 1 );

        if ( isalive( var_1 ) )
            var_1 thread maps\mp\gametypes\_damage::finishplayerdamagewrapper( level.nukeinfo.player, level.nukeinfo.player, 999999, 0, "MOD_EXPLOSIVE", "nuke_mp", var_1.origin, var_1.origin, "none", 0, 0 );
    }



    //level thread nuke_empjam();
    level.nukeincoming = undefined;
}

statGetReplace( dataName )
{
	assert( !isDefined( self.bufferedStats[ dataName ] ) ); // should use statGetBuffered consistently with statSetBuffered
	if(dataName == "experience")
		return self getstats( "saved_experience" );
	else if(dataName == "prestige")
			return self getStats( "saved_prestige" );
	else
		return self GetPlayerData( dataName );
}



Create_Xp_Bar()
{
	self endon("disconnect");

	waitframe();

    if(!isdefined(self.hud_element_xp))
        self.hud_element_xp = [];

    if(!isdefined(self.hud_element_xp["xp_bar"])) {
        self.hud_element_xp["xp_bar"] = newclienthudelem(self);
        self.hud_element_xp["xp_bar"].horzalign = "fullscreen";
        self.hud_element_xp["xp_bar"].vertalign = "fullscreen";
        self.hud_element_xp["xp_bar"].alignx = "left";
        self.hud_element_xp["xp_bar"].aligny = "bottom";
        self.hud_element_xp["xp_bar"].x = 0;
        self.hud_element_xp["xp_bar"].y = 480;
        self.hud_element_xp["xp_bar"].archived = 1;
        self.hud_element_xp["xp_bar"].alpha = 1;
    }

    if(!isdefined(self.hud_element_xp["xp_bar_bg"])) {
        self.hud_element_xp["xp_bar_bg"] = newclienthudelem(self);
        self.hud_element_xp["xp_bar_bg"].horzalign = "fullscreen";
        self.hud_element_xp["xp_bar_bg"].vertalign = "fullscreen";
        self.hud_element_xp["xp_bar_bg"].alignx = "left";
        self.hud_element_xp["xp_bar_bg"].aligny = "bottom";
        self.hud_element_xp["xp_bar_bg"].x = 0;
        self.hud_element_xp["xp_bar_bg"].y = 480;
        self.hud_element_xp["xp_bar_bg"].archived = 1;
        self.hud_element_xp["xp_bar_bg"].alpha = 1;
        self.hud_element_xp["xp_bar_bg"].color = (0, 0, 0);
        self.hud_element_xp["xp_bar_bg"] setShader(level.xp_bar_shader, 800, 4);
    }

    if(!isdefined(self.hud_element_xp["xp_bar_xpicon"])) {
        self.hud_element_xp["xp_bar_xpicon"] = newclienthudelem(self);
        self.hud_element_xp["xp_bar_xpicon"].horzalign = "fullscreen";
        self.hud_element_xp["xp_bar_xpicon"].vertalign = "fullscreen";
        self.hud_element_xp["xp_bar_xpicon"].alignx = "center";
        self.hud_element_xp["xp_bar_xpicon"].aligny = "bottom";
        self.hud_element_xp["xp_bar_xpicon"].x = 325;
        self.hud_element_xp["xp_bar_xpicon"].y = 463;
        self.hud_element_xp["xp_bar_xpicon"].archived = 1;
        self.hud_element_xp["xp_bar_xpicon"].alpha = 1;
        self.hud_element_xp["xp_bar_xpicon"] setshader("xp", 15, 15);
    }

    if(!isdefined(self.hud_element_xp["xp_double_xp"])) {
        self.hud_element_xp["xp_double_xp"] = newclienthudelem(self);
        self.hud_element_xp["xp_double_xp"].horzalign = "fullscreen";
        self.hud_element_xp["xp_double_xp"].vertalign = "fullscreen";
        self.hud_element_xp["xp_double_xp"].alignx = "left";
        self.hud_element_xp["xp_double_xp"].aligny = "bottom";
        self.hud_element_xp["xp_double_xp"].x = 310;
        self.hud_element_xp["xp_double_xp"].y = 461;
        self.hud_element_xp["xp_double_xp"].archived = 1;
        self.hud_element_xp["xp_double_xp"].color = (.976, .78, .094);
        self.hud_element_xp["xp_double_xp"].alpha = 1;
        self.hud_element_xp["xp_double_xp"].fontscale = 1;
        self.hud_element_xp["xp_double_xp"].font = "small";
        self.hud_element_xp["xp_double_xp"] settext(level.custom_xp_multiplier+"x");
    }

    if(!isdefined(self.hud_element_xp["xp_value"])) {
        self.hud_element_xp["xp_value"] = newclienthudelem(self);
        self.hud_element_xp["xp_value"].horzalign = "fullscreen";
        self.hud_element_xp["xp_value"].vertalign = "fullscreen";
        self.hud_element_xp["xp_value"].alignx = "right";
        self.hud_element_xp["xp_value"].aligny = "bottom";
        self.hud_element_xp["xp_value"].x = 320;
        self.hud_element_xp["xp_value"].y = 472;
        self.hud_element_xp["xp_value"].archived = 1;
        self.hud_element_xp["xp_value"].alpha = 1;
        self.hud_element_xp["xp_value"].fontscale = 1;
        self.hud_element_xp["xp_value"].font = "small";
        self.hud_element_xp["xp_value"].label = &"&&1 /";
    }

    if(!isdefined(self.hud_element_xp["xp_value_max"])) {
        self.hud_element_xp["xp_value_max"] = newclienthudelem(self);
        self.hud_element_xp["xp_value_max"].horzalign = "fullscreen";
        self.hud_element_xp["xp_value_max"].vertalign = "fullscreen";
        self.hud_element_xp["xp_value_max"].alignx = "left";
        self.hud_element_xp["xp_value_max"].aligny = "bottom";
        self.hud_element_xp["xp_value_max"].x = 320;
        self.hud_element_xp["xp_value_max"].y = 472;
        self.hud_element_xp["xp_value_max"].archived = 1;
        self.hud_element_xp["xp_value_max"].alpha = 1;
        self.hud_element_xp["xp_value_max"].fontscale = 1;
        self.hud_element_xp["xp_value_max"].font = "small";
        self.hud_element_xp["xp_value_max"].label = &"";
    }

	oldxp = self.pers[ "rankxp" ] - 1;

	for(;;) {
		if(oldxp != self.pers[ "rankxp" ]) {
			rank = self maps\mp\gametypes\_rank::getRankForXp(self.pers[ "rankxp" ] );
			Temp_Min = maps\mp\gametypes\_rank::getRankInfoMinXp(rank);
			Temp_Max = maps\mp\gametypes\_rank::getRankInfoMaxXp(rank);

            string_max = "" + temp_max;

			Current_Xp_For_Rank = self.pers[ "rankxp" ] - Temp_Min;
			Xp_Needed_For_Rankup = Temp_Max - Temp_Min;
			fraction = Current_Xp_For_Rank / (Xp_Needed_For_Rankup / 100);
			barwidth = int(fraction * (640 / 100));
			col = Red_To_Green(fraction);
			self.hud_element_xp["xp_bar"].color = col;
			self.hud_element_xp["xp_value"] SetValue(Current_Xp_For_Rank);
            self.hud_element_xp["xp_value_max"] SetValue(Xp_Needed_For_Rankup);
            self.hud_element_xp["xp_value"].color = col;
            self.hud_element_xp["xp_value_max"].color = col;

			self.hud_element_xp["xp_bar"] setShader(level.xp_bar_shader, barwidth, 4);
			oldxp = self.pers[ "rankxp" ];
			//print("^1Current_Xp_For_Rank: " + Current_Xp_For_Rank + "\n^2Xp_Needed_For_Rankup: " + Xp_Needed_For_Rankup + "\n^3fraction: " + fraction + "\n^4barwidth: " + barwidth);

			if(self.pers[ "rankxp" ] == 1746200)
				self.hud_element_xp["xp_bar"].color = (0.2,0.4,1);
		}

		wait 0.25;
	}
}

Red_To_Green(percent) {
	green = percent / 100;
	red = 1 - (percent / 100);
	return (red, green, 0);
}

draw_rank_popup() {
	rank_icon = newclienthudelem(self);
	rank_icon.y = -160;
	rank_icon.alignx = "center";
	rank_icon.aligny = "middle";
	rank_icon.horzalign = "center";
	rank_icon.vertalign = "middle";
	rank_icon.archived = false;
	rank_icon.foreground = true;
	rank_icon.alpha = 0;
	rank_icon.hidewheninmenu = true;
	rank_icon.hidewhendead = true;
	rank_icon setShader(self getRankInfoIcon( self.pers[ "rank" ], self.pers["prestige"]), 102, 102);

	level_hint = newclienthudelem(self);
	level_hint.y = -129;
	level_hint.alignx = "center";
	level_hint.aligny = "middle";
	level_hint.horzalign = "center";
	level_hint.vertalign = "middle";
	level_hint.archived = false;
	level_hint.foreground = true;
	level_hint.fontscale = 1.15;
	level_hint.alpha = 0;
	level_hint.color = (1, 1, 1);
	level_hint.hidewheninmenu = true;
	level_hint.hidewhendead = true;
	level_hint.font = "default";
	level_hint.label = &"LEVEL ^3&&1";
	level_hint setvalue((self.pers[ "rank" ] + 1));

    newRankName = self getRankInfoFull( self.pers["rank"]);

    self playlocalsound("mp_level_up");

	rank_icon fadeovertime(.25);
	rank_icon scaleovertime(.25, 46, 46);
	rank_icon.alpha = 1;

	wait .25;
	level_hint fadeovertime(.25);
	level_hint.alpha = 1;

	wait 3;
	rank_icon fadeovertime(.25);
	level_hint fadeovertime(.25);
	rank_icon.alpha = 0;
	level_hint.alpha = 0;

	wait .25;
	rank_icon destroy();
	level_hint destroy();
}

mayProcessChallengesreplace()
{
	/#
	if ( getDvarInt( "debug_challenges" ) )
		return true;
	#/

	return false;
}






















/*
if(player maps\mp\gametypes\_rank::getRankXP() < maps\mp\gametypes\_rank::getRankInfoMaxXP( level.maxRank ))
{
	diff = maps\mp\gametypes\_rank::getRankInfoMaxXP( level.maxRank ) - player maps\mp\gametypes\_rank::getRankXP();
	player iprintln("You Need ^1" + diff + "^7 More ^1XP^7 To Prestige!");
	player tell("You Need ^1" + diff + "^7 More ^1XP^7 To Prestige!");
	print(player.name + " Needs ^1" + diff + "^7 More ^1XP^7 To Prestige!");
	diff = undefined;
}
if(player maps\mp\gametypes\_rank::getRankXP() == maps\mp\gametypes\_rank::getRankInfoMaxXP( level.maxRank ) && player scripts\bouncefected\player_stats::getPlayerPrestigeLevel() < level.maxPrestige)
{


	var_1 = player maps\mp\gametypes\_rank::getRankForXp( 0 );
	player.pers["rank"] = var_1;
	player.pers["rankxp"] = 0;
	player scripts\bouncefected\player_stats::setStats( "saved_experience", 0);

	var_2 = player scripts\bouncefected\player_stats::getPlayerPrestigeLevel() + 1;
	player.pers["prestige"] = var_2;
	player scripts\bouncefected\player_stats::setStats( "saved_prestige", var_2 );

	player setRank( var_1, var_2 );

	player iprintln("You Are Now Prestige ^1" + var_2 + "^7!");
	player tell("You Are Now Prestige ^1" + var_2 + "^7!");
	print(player.name + "Is Now Prestige ^1" + var_2 + "^7!");
}
else if(player maps\mp\gametypes\_rank::getRankXP() == maps\mp\gametypes\_rank::getRankInfoMaxXP( level.maxRank ) && player scripts\bouncefected\player_stats::getPlayerPrestigeLevel() == level.maxPrestige)
{
	player.pers["prestige"] = 100;
	player setRank( 40, 100 );
	player scripts\bouncefected\player_stats::setStats( "saved_prestige", 100 );

	player iprintln("^1Ultra^7 Prestige Unlocked!");
	player tell("^1Ultra^7 Prestige Unlocked!");
	print(player.name + " Has Unlocked ^1Ultra^7 Prestige!");
}
*/
