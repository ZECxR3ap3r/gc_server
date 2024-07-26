#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;

init() {
    level thread SettingDvars();
    level thread PlayerConnect();
    level thread PlayerConnected();
    level thread MonitorNuke();
    level.prevCallbackPlayerDamage = level.callbackPlayerDamage;
  	level.callbackPlayerDamage = ::onPlayerDamage;
}

PlayerConnect() {
    for (;;) {
        level waittill("connecting", player);
        if(isdefined(level.radarinuse)) {
            if ( getNumSurvivors() == 1 )
                player.spawnasinf = 1;
        }
    }
}

MonitorNuke() {
	level endon ( "game_ended" );
	while( 1 ) {
		level waittill("nuke_death"); // wait until the ppl are dying otherwise noab wouldnt be possible anymore :c
		owner = level.nukeInfo.player;
		if(isdefined(owner) && owner.team == "allies" && isalive( owner )) { 
			spawnPoints = maps\mp\gametypes\_spawnlogic::getSpawnpointArray( "mp_tdm_spawn" ); // use spawnpoints cus its the easiest way to have alot of random points instead of a specific or a custom origin array
			spawnPoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_SafeSpawn( spawnPoints ); // dont get a spawn near an enemy O_o
			owner setorigin(spawnpoint.origin); // explains itself
			owner setplayerangles(spawnpoint.angles); // explains itself
		}
	}
}

PlayerConnected() {
    for (;;) {
        level waittill("connected", player);
        player thread onPlayerSpawned();
        player thread doSplash();
        player thread onPlayerSpawned();
    }
}

SettingDvars() {
    setdvar("sv_cheats", 0);
    setdvar("jump_slowDownEnable", 0);
    setdvar("jump_disableFallDamage", 1);
    setdvar("jump_autobunnyhop", 1);
    setdvar("jump_height", 46);
    setdvar("sv_enableBounces", 1);
    setdvar("jump_stepSize", 256);
    setdvar("jump_ladderPushVel", 1024);
    setdvar("g_speed", 220);
    setdvar("g_gravity", 800);
    setdvar("player_sustainammo", 0);
    setdvar("scr_nukeTimer", 5);
    setdvar("g_playerCollision", 1);
    setdvar("g_playerEjection", 1);
    setdvar("g_playerCollisionEjectSpeed", 25);
    setdvar("g_TeamName_Allies", "^2SURVIVORS" );
    setdvar("g_TeamName_Axis", "^1INFECTED" );
    setdvar("player_sustainammo", 0);
}

doSplash() {
    self endon("disconnect");
    wait 6;
    notifyData = spawnstruct();
    notifyData.iconName = level.icontest;
    notifyData.titleText = "^1Gillette ^7Infected";
    notifyData.notifyText = "Welcome " + self.name + "!";
    notifyData.glowColor = (1, 0, 0);
    notifyData.duration = 7;
    notifyData.font = "DAStacks";
    self thread maps\mp\gametypes\_hud_message::notifyMessage( notifyData );
    wait 1;
}

onPlayerSpawned() {
    self endon("disconnect");
    for(;;) {
        self waittill("spawned_player");
        if(isdefined(self.spawnasinf)) {
            self maps\mp\gametypes\_menus::addToTeam( "axis" );	
		    maps\mp\gametypes\infect::updateTeamScores();
		    self.pers["gamemodeLoadout"] = level.infect_loadouts["axis"];
		    self maps\mp\gametypes\_class::giveLoadout( "axis", "gamemode", false, false  );
        }
	    self freezeControls(false);
	    if(!isdefined(self.afkwatcherenabled)) {
	    	self.afkwatcherenabled = 1;
        	self thread AFKWatcher();
        }
    }
}

AFKWatcher() {
	self endon("disconnect");
	level endon ( "game_ended" );
	wait 3;
	arg = 0;
    while(1) {
    	if(isdefined(self.isInitialInfected) && isAlive( self )) {
    		org = self.origin;
    		angle = self getplayerangles();
    		wait 1;
    		if(isAlive( self )) {
				if(distance(org, self.origin) <= 5 && angle == self getPlayerAngles())
					arg++;
				else
					arg = 0;
			}
			
			if(isdefined(arg) && arg >= 30)
				kick(self getEntityNumber(), "EXE_PLAYERKICKED_INACTIVE");
		}
		else if(self.team == "axis" && isAlive( self )) {
			org = self.origin;
    		angle = self getplayerangles();
    		wait 1;
			if(isAlive( self )) {
				if(distance(org, self.origin) <= 5 && angle == self getPlayerAngles())
					arg++;
				else
					arg = 0;
			}
		
			if(isdefined(arg) && arg >= 120)
				kick(self getEntityNumber(), "EXE_PLAYERKICKED_INACTIVE");
		}
		else
			wait 1;
    }
}

onPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset) {
	iDFlags = 4;
    if(sMeansOfDeath == "MOD_MELEE")
        iDamage = 100;
	self [[level.prevCallbackPlayerDamage]](eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset);
}

getNumSurvivors() {
	numSurvivors = 0;
	foreach ( player in level.players ) {
		if ( player.team == "allies" )
			numSurvivors++;
	}
	return numSurvivors;	
}

