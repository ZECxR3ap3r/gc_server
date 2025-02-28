#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_rank;
#include zec\maps\zec_utility;

init() {
	level.basepath = "C:/IW5-Data/global_stats";

	replacefunc(maps\mp\gametypes\_hud_message::actionNotifyMessage, ::actionNotifyMessageReplace);
	replacefunc(maps\mp\gametypes\_missions::mayProcessChallenges, ::mayProcessChallengesreplace);

    level.callbackplayerkilledMain 		= level.callbackPlayerKilled;
    setdvar("inf_xp", 1);

    level thread on_connect();
}

Prestige_Logic() {
	if(self.global_stats["xp"] == 1746199 && self.global_stats["prestige"] != 40) {
		var_1 = self maps\mp\gametypes\_rank::getRankForXp(0);
		self.global_stats["xp"] = 0;

		self.global_stats["prestige"] += 1;

		self setRank( var_1, self.global_stats["prestige"]);

		self iprintln("You Are Now Prestige ^1" + self.global_stats["prestige"] + "^7!");
		self tell("You Are Now Prestige ^1" + self.global_stats["prestige"] + "^7!");

        self notify("player_stats_updated");
	}
}

on_connect() {
    while(1) {
        level waittill("connected", player);

        player setclientdvar("inf_xp", getdvarint("inf_xp"));
    }
}

delay_tell(message) {
    wait 10;
    if(isdefined(self))
        self tell_raw(message);
}

update_stats_aftertime(time) {
    self endon("disconnect");

    while(1) {
        wait time;

        self notify("player_stats_updated");
    }
}

updateRank_hook(value) {
	newRankId = maps\mp\gametypes\_rank::getRankForXp(self.global_stats["xp"]);

	if(self.rank == newRankId)
		return false;

    if(self.global_stats["prestige"] != 40 && newRankId >= 79) {
        self.rank = 79;
	    self setRank(79);
        return false;
    }

    self.rank = newRankId;
    self setRank(newRankId);

	return true;
}

add_xp(value) {
    if(self.global_stats["prestige"] != 40) {
        if((self.global_stats["xp"] + value) > 1746199)
            self.global_stats["xp"] = 1746199;
        else
            self.global_stats["xp"] += int(value);
    }
    else {
        if((self.global_stats["xp"] + value) > maps\mp\gametypes\_rank::getRankInfoMaxXP(level.maxRank))
            self.global_stats["xp"] = maps\mp\gametypes\_rank::getRankInfoMaxXP(level.maxRank);
        else
            self.global_stats["xp"] += int(value);
    }

    self setclientdvar("inf_experience", self.global_stats["xp"]);
    self notify("player_stats_updated");

    newRankId = maps\mp\gametypes\_rank::getRankForXp(self.global_stats["xp"]);

    if(self.rank != newRankId) {
        self.rank = newRankId;
        self setrank(self.rank);
        self thread draw_rank_popup();
    }
}

push_client_stats_update() {
    players_dir = "C:/IW5-Data/global_stats/players/" + self.guid + "/infected_data.csv";

    while(1) {
        self waittill("player_stats_updated");

        if(fileexists(players_dir))
            writeFile(players_dir, csv_encode(self.global_stats));
    }
}

blank(amount) {
}

actionNotifyMessageReplace( actionData )
{
	self endon ( "disconnect" );

	assert( isDefined( actionData.slot ) );
	slot = actionData.slot;

	if ( level.gameEnded )
	{
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
	rank_icon setShader(tableLookup("mp/rankIconTable.csv", 0, maps\mp\gametypes\_rank::getRankForXp(self.global_stats["xp"]), self.global_stats["prestige"] + 1), 102, 102);

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
	level_hint.label = &"LEVEL ^8&&1";
	level_hint setvalue(maps\mp\gametypes\_rank::getRankForXp(self.global_stats["xp"]) + 1);

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

mayProcessChallengesreplace() {
	return false;
}