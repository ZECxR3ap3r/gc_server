#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

init() {
	level.SpawnedPlayersCheck = [];
	
	level thread onplayerconnect();
}

onplayerconnect() {
	level endon("game_ended");
	for ( ;; ) {
		level waittill( "connected", player );
		if( !isdefined( level.SpawnedPlayersCheck[ player.name ] ) )
			level.SpawnedPlayersCheck[ player.name ] = 1;
		else
			player thread MovetoInf();
	}
}

MovetoInf() {
	self waittill("spawned_player");
	if ( self.team == "allies" ) {				
		self maps\mp\gametypes\_menus::addToTeam( "axis" );	
		maps\mp\gametypes\infect::updateTeamScores();
		self.pers["gamemodeLoadout"] = level.infect_loadouts["axis"];
		self maps\mp\gametypes\_class::giveLoadout( "axis", "gamemode", false, false  );
		
		foreach(player in level.players) {
			if ( isDefined(player.isInitialInfected ) )
				player thread maps\mp\gametypes\infect::setInitialToNormalInfected();
		}
	}		
}
