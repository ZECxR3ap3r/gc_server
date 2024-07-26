#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

/*
------------------------------------
Slasher (based on the mode from MWR and on Mike Myers/Hide and Seek)
Ported from IW4 to IW5
Created by: Wiizard
Version: 1.3
(c)2017-2022
-------------------------------------
TODO (for v1.3):
	- fix slasher repicking spectators instead of only survivors
	- fix pulse grenades for repicked slasher(s)
	- fix exfilled players being able to go into death barriers to enter afterlife mode
	- fix icon in bottom left for players who are spectating The Slasher to use hud_icon_mm instead of iw5_cardicon_sandman2
	- fix mantling collision (possibly ok? not sure though)
-------------------------------------
Change-Log:
v1.2.2 (8th August 2022):
- HUD changes
- FFA spawns for survivors
- Score carrys over to next round

v1.2 (7th August 2022):
- New HUD by ZECxR3ap3r

v1.1.2 (5th August 2022):
- Removed heli crash slowdown
- Added ZECxR3ap3r speed and bounce HUD

v1.1.1 (30th June 2022):
- Fixed Slasher grenades.

v1.1 (12th June 2022):
- check gillette.com/slasher for details.

v1.0-Open Beta 2 (April 2022):
- Added the signature Michael Myers skin for The Slasher.
- Added Pighead skin for final Survivor.
- Added Desert Eagle weapon for Survivors.
- Added Bayonet weapon for The Slasher.
- Added custom sounds.
- Added Extreme Conditioning Pro perk for both Survivors and The Slasher.
- Added the ability for players to use FPS Boost.
- Added the ability for The Slasher to return to spawn if he becomes stuck along with a 60 second cooldown.
- Fixed several bugs relating to gameplay experience.
- Other various bug fixes and improvements have been made to enhance the user experience. 

v1.0-Open Beta 1 (8th April 2022):
- Initial open beta test.
*/

init() {
	level.heli_start_nodes = getEntArray( "heli_start", "targetname" );
	assertEx( level.heli_start_nodes.size, "No \"heli_start\" nodes found in map!" );

	level.chopper_fx["explode"]["death"]["pavelow"] = loadFx("explosions/helicopter_explosion");
	level.chopper_fx["explode"]["large"] = loadfx ("explosions/helicopter_explosion_secondary_small");
	level.chopper_fx["explode"]["medium"] = loadfx ("explosions/aerial_explosion");
	level.chopper_fx["smoke"]["trail"] = loadfx ("smoke/smoke_trail_white_heli");
	level.chopper_fx["fire"]["trail"]["medium"] = loadfx ("fire/fire_smoke_trail_L_emitter");
	level.chopper_fx["fire"]["trail"]["large"] = loadfx ("fire/fire_smoke_trail_L");
	level.chopper_fx["damage"]["light_smoke"] = loadfx ("smoke/smoke_trail_white_heli_emitter");
	level.chopper_fx["damage"]["heavy_smoke"] = loadfx ("smoke/smoke_trail_black_heli_emitter");
	level.chopper_fx["damage"]["on_fire"] = loadfx ("fire/fire_smoke_trail_L_emitter");
	level.heli_sound["allies"]["hit"] = "cobra_helicopter_hit";
	level.heli_sound["allies"]["hitsecondary"] = "cobra_helicopter_secondary_exp";
	level.heli_sound["allies"]["damaged"] = "cobra_helicopter_damaged";
	level.heli_sound["allies"]["spinloop"] = "cobra_helicopter_dying_loop";
	level.heli_sound["allies"]["spinstart"] = "cobra_helicopter_dying_layer";
	level.heli_sound["allies"]["crash"] = "cobra_helicopter_crash";
	level.heli_sound["allies"]["missilefire"] = "weap_cobra_missile_fire";
	
	game["dialog"]["gametype"] = "";

	level.pushfx = loadfx("slasher/pushnade");
	level.circlefx = loadfx("slasher/slashercircle");
	level.leftplayers = [];
	
	level.ui_better_red = (0.6, 0.125, 0.125);
	level.ui_better_cyan = (0, 0.31, 0.557);
	
	level.SlasherPoints = spawnstruct();
	level.SlasherPoints.RadiusPoints = 25;
	level.SlasherPoints.SlasherKill = 100;
	level.SlasherPoints.ExfilSuccess = 200;
	level.SlasherPoints.LastSurvivor = 200;
	level.SlasherPoints.AliveBonus = 10;
	level.SlasherPoints.SlasherStunned = 10;
	level.SlasherPoints.FinalKill = 200;

	precacheShellShock("frag_grenade_mp");
	precacheShellShock("damage_mp");
	precacheRumble("artillery_rumble");
	precacheRumble("grenade_rumble");

	//precacheShader("mapselect_arrow");
	precacheShader("equipment_semtex");
	precacheshader("iw5_cardicon_revolver");
	precacheshader("waypoint_defend");
	precacheshader("waypoint_target");
	precacheshader("iw5_cardicon_sandman2");
	precacheshader("hud_icon_mm");
	precacheshader("line_horizontal");

	//precache slasher playermodels
	precachemodel("playermodel_vistic_mike_myers");
	precachemodel("tag_origin");
	precachemodel("viewhandsl_bo2_deluca2");

	//setup custom weapons
	precacheitem("iw5_knife_mp");
	precacheitem("iw5_slashnburn_mp");
	precacheitem("iw5_deserteagleiw3_mp");
	
	setDvarIfUninitialized("round", 1);
	setDvarIfUninitialized("maxround", 4);
  	setDvar("scr_war_scorelimit", 0);
	setDvar("scr_war_timelimit", 0);
	setDvar("scr_game_graceperiod", 0);
	setDvar("ui_allow_teamchange", 0);
	setDvar("scr_game_graceperiod", 0);
	setDvar("scr_game_matchstarttime", 0);
	setDvar("scr_game_playerwaittime", 0);
	setDvar("jump_height", 46);
	setDvar("g_speed", 235);
	setDvar("g_playercollision", 2);
	setDvar("g_playerejection", 2);
	setDvar("jump_stepSize", 256);
	setDvar("sv_enableBounces", 1);
	setDvar("jump_disableFallDamage", 1);
	setDvar("jump_slowdownEnable", 0);
	setDvar("jump_autoBunnyHop", 0);
	setDvar("sv_cheats", 0);
	setDvar("jump_ladderpushvel", 128);
	setDvar("g_hardcore", 1);
	setDvar("g_scorescolor_axis", "0.75 0.25 0.25 0.75");
	setDvar("g_scorescolor_allies", "0.25 0.75 0.25 0.75");
	setDvar("g_scorescolor_spectator", "0 0.85 1 1");
	setdvar("g_teamicon_axis", "hud_icon_mm");
    setdvar("g_teamicon_allies", "iw5_cardicon_sandman2");
	setdvar("g_teamicon_spectator", "cardicon_skull_black");
	makeDvarServerInfo( "ui_allow_classchange", 0);
	makeDvarServerInfo( "ui_allow_teamchange", 0);
	SetDvar( "ui_allow_classchange", 0);
	SetDvar( "ui_allow_teamchange", 0);

	mm\_loadcc::init(); 
	
	level.heliIsCrashing = false;
	level.heliHasCrashed = false;

  	level.ingame = false;
	level.finalPlayer = false;
	level.hideTime = 10; //set time until slasher releases
	level.blockWeaponDrops = true;
	level.killstreakRewards = false;
	level.escapeInit = false;
	level.countHeliPlayersEntered = 0;
	level.specNewPlayers = false;

	level thread startTheGame();
	level thread playerCounter();
	level thread countPlayersAlive();
  	level thread onplayerconnect();
  	
	turrets = GetEntArray("misc_turret","classname");
    for(i=0;i<turrets.size;i++)
        turrets[i] delete();
        
   if(getdvarint("round") == 1)
        setdvar("currentscores", "a");
}

randPlayer() {
	allies = getAllies();
	if(allies.size > 0) {
		num = allies[randomInt(allies.size)];
		return num;
	} 
	else
		return level.getSlasher;
}

onPlayerConnect() {
  	for(;;) {
   		level waittill("connected", player);
		if(level.ingame) {
			if(isDefined(level.leftplayers[player.name]) || level.finalPlayer) {
				player.reconnectAsSurvivor = 0;
				player iPrintlnBold("^1Please wait until the round is over!");
				//VisionSetNaked("cobra_sunset3", 0);
				//player VisionSetNakedForPlayer("cobra_sunset3", 0);
				player thread scripts\slasher\main::GhostRUn();
			} 
			else {
				player.reconnectAsSurvivor = 1;
				//VisionSetNaked("cobra_sunset3", 0);
				//player VisionSetNakedForPlayer("cobra_sunset3", 0);
			}
		}
		player thread onPlayerSpawned();
		player setclientDvar("cg_teamcolor_allies", "0 1 0 1" );
		player setclientDvar("cg_teamcolor_axis", "1 0 0 1" );
		player setclientDvar("cg_teamcolor_spectator", "0 0.85 1 1");
   		player setClientDvar("lowAmmoWarningNoAmmoColor1", 0, 0, 0, 0);
		player setClientDvar("lowAmmoWarningNoAmmoColor2", 0, 0, 0, 0);
		player thread AntiReconnect();
		player thread setTeam("allies");
		player thread monitorSlasherKill();
  	}
}

AntiReconnect() {
	myname = self.name;
	self waittill("disconnect");
	level.leftplayers[myname] = 1;
}

onPlayerSpawned(){
	self endon("disconnect");
	self.nameicon ="";
	for(;;) {
		self waittill("spawned_player");

		if(level.ingame) {
			//VisionSetNaked("cobra_sunset3", 0);
			//self VisionSetNakedForPlayer("cobra_sunset3", 0);
			setExpFog(500, 2000, 0.5, 0.5, 0.5, 1, 15);
		}
		
		self verifyTeam();
		self takeAllWeapons();
		self clearPerks();
		
		if(getdvarint("round") != 1) {
			cdvar = getdvar("currentscores");
			if(isdefined(cdvar)) {
			
				if(cdvar != "a") {
					str = strTok(cdvar, ",");
					if(isdefined(str)) {
						for(i = 0;i < str.size;i++) {
           					if(str[i] == self.name) {
           						self.score += int(str[i + 1]);
           						self.pers[ "score" ] = self.score;
           					}
           				}	
           			}
           		}
			}
		}
		
		self givePerk("specialty_fastmantle", true);
		
		if(self.team == "allies") {
			self GiveWeapon("iw5_deserteagleiw3_mp");
			self setweaponammoclip("iw5_deserteagleiw3_mp", 0);
			self setweaponammostock("iw5_deserteagleiw3_mp", 0);
			self.nameicon = "iw5_cardicon_sandman2";
			if(level.ingame && isDefined(self.reconnectAsSurvivor) && self.reconnectAsSurvivor == 1) {
				self setweaponammoclip("iw5_deserteagleiw3_mp", level.saveAmmoCountForReconnect);
				self setweaponammostock("iw5_deserteagleiw3_mp",0);
				weapon = self getCurrentWeapon();
				ammoClip = self getWeaponAmmoClip(weapon);
				//VisionSetNaked("cobra_sunset3", 0);
				//self VisionSetNakedForPlayer("cobra_sunset3", 0);
				if(self != level.getSlasher)
					self thread SlasherSound();
			}
			self setspawnweapon("iw5_deserteagleiw3_mp");
		} 
		
		if(!isDefined(self.welc) && self.team != "spectator") {
			self playLocalSound("mm_spawn");
			self thread Falldown();
			self.welc = true;
		}
		
		level notify("player_spawn", self);
		wait 5;
		if(self.team != "axis") {
			if(!isdefined(level.inendscreen))
				self thread scripts\slasher\main::SendNewNotification("Survive until Exfil arrives to pick you up!");
		}
		
		if(isdefined(self.namehudicon)){
			self.namehudicon destroy();
			self.namehudicon = newClientHudElem(self);
			self.namehudicon.x = 10;
			self.namehudicon.y = 465;
			self.namehudicon.alignx = "left";
			self.namehudicon.aligny = "bottom";
			self.namehudicon.horzalign = "fullscreen";
			self.namehudicon.vertalign = "fullscreen";
			self.namehudicon.alpha = 1;
			self.namehudicon.color = (1,1,1);
			self.namehudicon.archived = true;
			self.namehudicon.foreground = true;
			self.namehudicon.hidewheninmenu = true;
			self.namehudicon setshader(self.nameicon, 25, 25);
    		self.namehudicon thread scripts\slasher\main::SetAlphaLow();
		}
	}
}

CrouchTimer() {
	self endon("disconnect");
    level endon("game_ended");
    self.isinhidden = undefined;
    self.crouchtimer = 0;
    while(1) {
    	if(self getstance() == "crouch") {
    		wait 0.5;
    		if(self.crouchtimer != 4)
    			self.crouchtimer += 1;
    		else if(self.crouchtimer == 4)
    			self.isinhidden = 1;
    	}
    	else {
    		if(self.crouchtimer == 4)
    			self.isinhidden = undefined; 
    	}
    	wait .05;
    }
}

monitorGrenade(){
	self notifyOnPlayerCommand("gren", "+frag");
	for(;;) {
		self waittill("gren");
		if(self.slashernades > 0) {
			if(self hasWeapon("semtex_mp"))
				self _giveWeapon("semtex_mp");
		}
		waitframe();
	}
}
Falldown() {
	if(getDvarInt("round") == 1) 
		self playLocalSound("mm_intro");
	
	zoomHeight = 4000;
	slamzoom = true;
	extra_delay = 0;
	time = 3;

	fakePlayer = self cloneplayer(time);
	wait 0.05;
	
	self.health = 999999;
	self.maxhealth = self.health;
	self.alreadySpawnedSurv = 1;
	self.spawning_anim = 1;
	self hide();
	self _unsetperk("specialty_finalstand");
	self freezeControls( true );
	self disableweapons();
	setdvar("ui_allow_teamchange", 0);

	origin = self.origin;
	ent = spawn( "script_model", (69,69,69) );
	ent.origin = origin + ( 0, 0, zoomHeight );
	
	ent setmodel( "tag_origin" );
	ent.angles = self.angles;
	if(level.script == "mp_nuked")
		self PlayerLinkWeaponviewToDelta( ent, "tag_player", 1.0, 0, 0, 0, 0, true ); 
	else
		self PlayerLinkToAbsolute( ent, "tag_player", 1.0, 0, 0, 0, 0, true );
	
	wait 0.01;
	self playlocalsound("ui_camera_whoosh_in");
	self thread introscreen_generic_fade_in("black", 0.1, 0.2 );
	ent.angles = ( ent.angles[ 0 ] + 89, ent.angles[ 1 ], 0 );

	wait( extra_delay );	
	ent moveto ( origin + (0,0,0), time - 0.5, 0, time - 0.5 );

	wait ( time/2.5 );
	self thread introscreen_generic_fade_in("white", 0.4, 1.6, 0.3 );
	wait( time/5 );
	ent rotateto( ( ent.angles[ 0 ] - 89, ent.angles[ 1 ], 0 ), time/5, 0.3, time/11 );
	wait ( time/5 );
	self.spawning_anim = undefined;
	self show();

	if(isDefined(fakePlayer)) 
		fakePlayer delete();
	
	wait 0.2;
	self unlink();
	self freezeControls( false );
	self notify("LoadReaperHud");
	self.health = 100;
	self.maxhealth = self.health;
	self enableweapons();
	wait 2;
	if(isDefined(ent))
		ent delete();
}

introscreen_generic_fade_in( shader, time, fade_time, fade_in ) {
	if ( !isdefined( fade_time ) )
		fade_time = 1.5;
		
	introblack = newClientHudElem(self);
	introblack.x = 0;
	introblack.y = 0;
	introblack.horzAlign = "fullscreen";
	introblack.vertAlign = "fullscreen";
	introblack.foreground = true;
	introblack setShader(shader, 640, 480);
	
	if(isdefined(fade_in)) {
		introblack.alpha = 0;
		introblack fadeOverTime(fade_in); 
		introblack.alpha = 1;
		wait fade_in;
	}

	wait time;
	
	introblack fadeOverTime(1.5); 
	introblack.alpha = 0;
}

in_spawnSpectator(origin, angles) {
	self endon("joined_team");
	self endon("disconnect");
	self notify("spawned");
	self notify("end_respawn");
	self notify("joined_spectators");

	if(isdefined(self.namehudicon)){
		self.namehudicon destroy();
		self.namehudicon = newClientHudElem(self);
		self.namehudicon.x = 10;
		self.namehudicon.y = 465;
		self.namehudicon.alignx = "left";
		self.namehudicon.aligny = "bottom";
		self.namehudicon.horzalign = "fullscreen";
		self.namehudicon.vertalign = "fullscreen";
		self.namehudicon.alpha = 1;
		self.namehudicon.color = (1,1,1);
		self.namehudicon.archived = true;
		self.namehudicon.foreground = true;
		self.namehudicon.hidewheninmenu = true;
		self.namehudicon setshader(self.nameicon, 25, 25);
    	self.namehudicon thread scripts\slasher\main::SetAlphaLow();
	}

	//self VisionSetNakedForPlayer("cobra_sunset3", 0);
	setExpFog(500, 2000, 0.5, 0.5, 0.5, 1, 15);

	self stopLocalSound("mm_near");

	self maps\mp\gametypes\_playerlogic::setSpawnVariables();
	
	if ( isDefined( self.pers["team"] ) && self.pers["team"] == "spectator" && !level.gameEnded )
		self clearLowerMessage( "spawn_info" );
	
	self.sessionstate = "spectator";
	self.forcespectatorclient = -1;
	self ClearKillcamState();
	self.friendlydamage = undefined;

	if( isDefined( self.pers["team"] ) && self.pers["team"] == "spectator" )
		self.statusicon = "";
	else
		self.statusicon = "hud_status_dead";
	
	if ( level.teamBased && !level.splitscreen )
		self setDepthOfField(0, 128, 512, 4000, 6, 1.8);
		
	while(1) {
		self allowspectateteam("allies", true);
		self allowspectateteam("axis", true);
		self allowspectateteam("freelook", false);
		self allowspectateteam("none", false);
		wait 0.5;
	}
}

onPlayerDeath() {
	self endon("disconnect");
	for(;;) {
		self waittill("death");
		
		if(level.ingame && level.leftplayers[self.name] == 0)
			self forceTeam("spectator");
	}
}

playerCounter() {
	for(;;) {
		level.slashers = 0;
		level.survivors = 0;
		
		foreach ( player in level.players ) {
			if ( player.team == "axis" )
				level.slashers++;
			
			if ( player.team == "allies" && isalive(player))
				level.survivors++;
		}
		wait .05;
	}
}

verifyTeam() {
	waitframe();
    if(isdefined(level.ingame)) {
		if(!isDefined(self.team) && !self.team == "allies") {
			if(!isDefined(self.reconnectAsSurvivor)){
				self forceTeam("allies");
			} 
			else {
				self.sessionteam = "spectator";
				self maps\mp\gametypes\_menus::addToTeam("spectator");
				self.team = "spectator";
				self stopLocalSound("mm_near");
				self thread in_spawnSpectator(self.origin,self.angles);
			}
			if(self.team == "allies" && self.pers["deaths"] > 0) {
				self.sessionteam = "spectator";
				self maps\mp\gametypes\_menus::addToTeam("spectator");
				self.team = "spectator";
				self stopLocalSound("mm_near");
				self thread in_spawnSpectator(self.origin,self.angles);
			}
			if(!level.ingame && self.team == "axis" && level.specNewPlayers || !level.ingame && self.team == "allies" && level.specNewPlayers) {
				self.sessionteam = "spectator";
            	self maps\mp\gametypes\_menus::addToTeam("spectator");
            	self.team = "spectator";
				self stopLocalSound("mm_near");
            	self thread in_spawnSpectator(self.origin,self.angles);
			}
		}
    	else {
			if(isDefined(self.reconnectAsSurvivor) && self.reconnectAsSurvivor == 0) {
				self.sessionteam = "spectator";
				self maps\mp\gametypes\_menus::addToTeam("spectator");
				self.team = "spectator";
				self stopLocalSound("mm_near");
				self thread in_spawnSpectator(self.origin,self.angles);
			}
			if(!isDefined(self.reconnectAsSurvivor))
				self forceTeam("allies");
			if(self.team == "allies" && self.pers["deaths"] > 0) {
				self.sessionteam = "spectator";
				self maps\mp\gametypes\_menus::addToTeam("spectator");
				self.team = "spectator";
				self stopLocalSound("mm_near");
				self thread in_spawnSpectator(self.origin,self.angles);
			}
			if(!level.ingame && self.team == "axis" && level.specNewPlayers || !level.ingame && self.team == "allies" && level.specNewPlayers) {
				//fix for survivor/slasher death on exfil end-game
				self.sessionteam = "spectator";
            	self maps\mp\gametypes\_menus::addToTeam("spectator");
            	self.team = "spectator";
				self stopLocalSound("mm_near");
            	self thread in_spawnSpectator(self.origin,self.angles);
			}
        	if(self.team == "spectator") {
				//self VisionSetNakedForPlayer("cobra_sunset3", 0);
				setExpFog(500, 2000, 0.5, 0.5, 0.5, 1, 15);
            	self stopLocalSound("mm_near");
        	}
			if(self.team == "axis" && level.finalPlayer) {
				self.sessionteam = "spectator";
            	self maps\mp\gametypes\_menus::addToTeam("spectator");
            	self.team = "spectator";
				self stopLocalSound("mm_near");
            	self thread in_spawnSpectator(self.origin,self.angles);
			}
        }
    }
}

startTheGame() {
	level endon("started");
	level notify("startgame");

    while(level.players.size < 3) {
		if(!isDefined(level.waitInfo)) {
			level.waitInfo = level createServerFancyText("bigfixed", 0.75, "center", "center", 0, -205, "Waiting For Players");
			level.waitInfo.glowalpha = 0;
			level.waitInfo.color = level.ui_better_red;
			level.waitInfo.glowcolor = level.ui_better_red;
			while(level.players.size < 3) {
				level.waitInfo ScaleOverTime(0.7, 50, 50);

				level.waitInfo setText("Waiting For Players.");
				wait 0.7;
				level.waitInfo setText("Waiting For Players..");
				wait 0.7;
				level.waitInfo setText("Waiting For Players...");
				wait 0.7;
			}
		}
		wait 1;
	}

	if(getDvarInt("round") == 1) 
		level thread spawnintroheli();

	level.waitInfo setText("Starting Round ^1" + getDvarInt("round") + "^7 Now!");
	level.waitInfo fadeOverTime(5);
	level.waitInfo.alpha = 0;
	wait 5;
	level.waitInfo destroy();
	
    wait 5;
	foreach(player in level.players) player playLocalSound("mm_reveal");
	//VisionSetNaked("cobra_sunset3", 15);
	setExpFog(500, 2000, 0.5, 0.5, 0.5, 1, 15);
	level thread initialCountDown();
}

spawnintroheli() {
	level endon("heli_crashed");
	if(!level.ingame && !isDefined(level.ibirdy) && isDefined(level.heliIsCrashing) && !level.heliIsCrashing) {
		level.heliIsCrashing = true;

		foreach(player in level.players) 
			player PlayLocalSound("mm_intro_cobra_inbound");
		map = getDvar("mapname");
		if(map != "mp_overwatch")
			level.ihelispawn = (1000,10000,7000);
		else
			level.ihelispawn = (1000,10000,19000);
		
		level.iflyto = level.spawnpoints[randomint(level.spawnpoints.size)].origin+(0,0,100);

		level.ibirdy = spawnHelicopter(randPlayer(), level.ihelispawn, VectorToAngles(level.iflyto - level.ihelispawn), "pavelow_mp","vehicle_pavelow_opfor");
		level.ibirdy.target = level.iflyto;
		level.ibirdy SetTurningAbility(0);
		level.ibirdy SetMaxPitchRoll(5,5);
		level.ibirdy Vehicle_SetSpeed(100,10);
		level.ibirdy setVehGoalPos(level.iflyto, 1);

		level.ibirdy.zOffset = (0,0,level.ibirdy getTagOrigin( "tag_origin" )[2] - level.ibirdy getTagOrigin( "tag_ground" )[2]);
		level.ibirdy thread ihelicrash();

		level.ibirdy endon("helicopter_done");
		level.ibirdy endon("crashing");
		level.ibirdy endon("leaving");
		level.ibirdy endon("death");

		self thread waitUntilHeliDead();
	}
}
waitUntilHeliDead() {
	self endon("disconnect");
	
	while(!level.heliHasCrashed)
		wait 0.05;
	
	if(level.heliHasCrashed) {
		foreach(player in level.players) {
			PlayRumbleOnPosition("artillery_rumble", player.origin);
			player PlayLocalSound("mm_intro_compromised");
		}
		level notify("heli_crashed");
	}
}
ihelicrash() {
	wait 10;
	level.iflyto = level.spawnpoints[randomint(level.spawnpoints.size)].origin+(0,0,100);
	playFxOnTag(level.chopper_fx["damage"]["on_fire"], self, "tag_engine_left");
	playFxOnTag(level.chopper_fx["explode"]["large"], self, "tag_engine_left" );
	playFxOnTag(level.chopper_fx["explode"]["medium"], self, "tag_engine_right" );
	self playSound ( level.heli_sound["allies"]["hitsecondary"] );
	self playSound ( level.heli_sound["allies"]["hit"] );
	self playSound("missile_incoming");
	self thread heli_crash();
	wait .25;
	self stopLoopSound();
	wait .05;
	self playLoopSound( level.heli_sound["allies"]["spinloop"] );
	wait .05;
	self playLoopSound( level.heli_sound["allies"]["spinstart"] );
}

heli_crash() {
	self notify( "crashing" );
	crashNode = level.iflyto; //level.heli_crash_nodes[ randomInt( level.heli_crash_nodes.size ) ]	
	self thread heli_spin(180);
	self heli_fly_simple_path( crashNode );
}

heli_spin( speed ) {
	self endon( "death" );

	//iprintln("helispin");
	
	// play hit sound immediately so players know they got it
	self playSound ( level.heli_sound["allies"]["hit"] );
	
	// spins until death
	self setyawspeed( speed, speed, speed );
	while ( isdefined( self ) ) {
		self settargetyaw( self.angles[1]+(speed*0.9) );
		wait ( 1 );
	}
}
heli_fly_simple_path( startNode ) {
	self endon ( "death" );
	self endon ( "leaving" );

	self notify( "flying");
	self endon( "flying" );
	
	heli_reset();
	
	currentNode = startNode;
	
	while ( isDefined( currentNode) ) {
		heli_speed = 50 + randomInt(20);
		heli_accel = 35 + randomInt(15);

		self Vehicle_SetSpeed( heli_speed, heli_accel );
		
		self setVehGoalPos( currentNode+(self.zOffset), false );
		self waittill( "near_goal" );
		level.heliHasCrashed = true;
		
		org = self.origin;	
		forward = (self.origin + ( 0, 0, 1 ) ) - self.origin;
		playFx(level.chopper_fx["explode"]["death"]["pavelow"], org, forward);
		playFx(level.chopper_fx["explode"]["death"]["pavelow"], org, forward);
		playFx(level.chopper_fx["explode"]["death"]["pavelow"], org, forward);
		self playSound( level.heli_sound["allies"]["crash"] );
		self delete();
		self notify("death");

		self waittillmatch( "goal" );
	}
}

heli_reset() {
	self clearTargetYaw();
	self clearGoalYaw();
	self Vehicle_SetSpeed( 60, 25 );	
	self setyawspeed( 75, 45, 45 );
	self setmaxpitchroll( 30, 30 );
	self setneargoalnotifydist( 256 );
	self setturningability(0.9);
}

initialCountDown() {
	level notify("started");
	level endon("counteddown");
	level.newRoundTime = 5;

	if(!isDefined(level.newRoundTimeTextHUD)) {
		level.newRoundTimeTextHUD = level createServerText("bigfixed", 0.65, "center", "center", 0, -205, "Choosing The Slasher:");
		level.newRoundTimeTextHUD.color = (1, 0, 0);
		level.newRoundTimeTextHUD.alpha = 0;
		level.newRoundTimeTextHUD fadeOverTime(0.5);
		level.newRoundTimeTextHUD.alpha = 1;
	}
	
	if(!isDefined(level.newRoundTimeText))
    	level.newRoundTimeText = level createServerText("bigfixed", 1.75, "center", "center", 0, -180);

    while(level.newRoundTime > 0) {
    	level.newRoundTimeText setvalue(level.newRoundTime);
        level.newRoundTimeText.color = (1, 0, 0);
        level playSoundOnPlayers("ui_mp_suitcasebomb_timer");
        level.newRoundTimeText.alpha = 0;
        level.newRoundTimeText fadeOverTime(0.5);
        level.newRoundTimeText.alpha = 1;
        level.newRoundTime--;
        wait 1;
        if(level.newRoundTime <= 5)
        	level playSoundOnPlayers("mp_suitcase_pickup");
	}
	
	if(level.players.size > 1) {
		level.newRoundTimeTextHUD destroy();
		level.newRoundTimeText destroy();
		level thread chooseSlasher();
		level notify("counteddown");
	} 
	else {
		level.newRoundTimeTextHUD destroy();
		level.newRoundTimeText destroy();
		iPrintlnBold("^1Not enough players to start! Restarting...");
		wait 2.5;
		map_restart(false);
	}
}

chooseSlasher() {
	level endon("disconnect");
	
	slashers = 1;
	slasherdvar = "";
	slasher = strtok(getDvar("slashers"), ", ");
	level.setslasher = [];
	level.slasherNum = -1;
	i = 0;
	while(level.setslasher.size < slashers) {
		level.getSurvivors = getAllies();
		num = randomint(GetTeamPlayersAlive("allies"));
		wasslasher = false;
		for(s=0;s<slasher.size;s++)
			if(level.getSurvivors[num].guid == slasher[s])
				wasslasher = true;
		if(!wasslasher) {
			//level.players is global.
			level.setslasher[i] = level.getSurvivors[num];
			level.setslasher[i] thread slasherChosen();
			level.getSurvivors[num].maxhealth = 9999999;
			level.getSurvivors[num].health = level.getSurvivors[num].maxhealth;
			foreach(player in level.players) {
				player playLocalSound("mp_killstreak_radar");
				if(player.team == "allies"){
					if(!isDefined(level.repickingSlasher)) 
						player thread maps\mp\gametypes\_hud_message::hintMessage("^7" + level.setslasher[i].name + " ^1is The Slasher!");
					else if(isDefined(level.repickingSlasher) && level.repickingSlasher) 
						player thread maps\mp\gametypes\_hud_message::hintMessage("^7" + level.setslasher[i].name + " ^1is now The Slasher!");
				}
			}
			level.slasherNum = num;
			level.getSlasher = level.setslasher[i];
			slasherdvar += level.setslasher[i].guid + ", ";
			i++;
		}
		wait .3;
	}
	setDvar("slashers", slasherdvar);
	if(!isDefined(level.repickingSlasher)) {
		level thread doHideTimer();
		level thread monitorGame();
	}
	else
		level.repickingSlasher = false;
}

slasherChosen() {
	while(!isdefined(self.Blood))
		wait .05;
	self suicide();
	self setTeam("axis");
	self thread setupSlasher();
}

setupSlasher() {
	self endon("disconnect");
	self endon("death");
	if(!level.ingame) {
		self waittill("spawned_player");
		waitframe();
		self freezeControls(true);
		self visionSetNakedforPlayer("blacktest", 0);
		self maps\mp\gametypes\_hud_message::hintMessage("^1You were chosen as The Slasher!");
		self maps\mp\gametypes\_hud_message::hintMessage("^1Please wait while Survivors hide!");
		level.selectedslasher = self;
		self setOffhandPrimaryClass("other");
		self givePerk("semtex_mp", true);
		self givePerk("specialty_fastoffhand", true);
		self takeWeapon("semtex_mp");
		self.nameicon = "hud_icon_mm";
		self detachall();
		self setmodel("playermodel_vistic_mike_myers");
		self setviewmodel("viewhandsl_bo2_deluca2");
		self GiveWeapon("iw5_slashnburn_mp");
		self setweaponammoclip("iw5_slashnburn_mp", 0);
		self setweaponammostock("iw5_slashnburn_mp", 0);
		wait .5;
		self switchToWeapon("iw5_slashnburn_mp");
		wait level.hideTime;
		self thread CrouchTimer();
		self freezeControls(false);
		self visionSetNakedforPlayer(getdvar("mapname"), 1);
		setExpFog(500, 2000, 0.5, 0.5, 0.5, 1, 15);
	} 
	else
		self maps\mp\gametypes\_hud_message::hintMessage("^1You are The Slasher, Kill everyone!");
}

doHideTimer() {
	level endon("disconnect");
	level endon("counteddown2");

	if(!isDefined(level.hideTimeTextHUD)){
		level.hideTimeTextHUD = level createServerText("bigfixed", 0.65, "center", "center", 0, -190, "Slasher Releases In");
		level.hideTimeTextHUD.alpha = 0;
		level.hideTimeTextHUD fadeOverTime(0.5);
		level.hideTimeTextHUD.alpha = 1;
		level.hideTimeTextHUD.color = level.ui_better_red;
	}
	
	if(!isDefined(level.hideTimeText))
		level.hideTimeText = level createServerText("bigfixed", 1.75, "center", "center", 0, -160);
	
	level.hideTimeText.color = level.ui_better_red;
	level.hideTimeText setvalue(level.hideTime);
	while(level.hideTime > 0) {
		wait 1;
		level.hideTime--;
		level.hideTimeText setvalue(level.hideTime);
		level playSoundOnPlayers("mp_hit_alert");
		level.hideTimeText.alpha = 0;
		level.hideTimeText fadeOverTime(0.5);
		level.hideTimeText.alpha = 1;
		if(level.hideTime <= 5)
			level playSoundOnPlayers("mp_suitcase_pickup");
	}
	if(level.hideTime == 0) {
		level.hideTimeTextHUD destroy();
		level.hideTimeText destroy();
		if(level.players.size > 1) {
			level.ingame = true;
			foreach(player in level.players){
				if(player.team == "allies") 
					player thread showSlasherMessage("^7The Slasher Is Here... Survive until Exfil arrives!");
				else 
					player thread showSlasherMessage("^7The Slasher Is Here... Kill all Survivors!");
				player playLocalSound("mm_released");
			}
			
			level thread doSurvivorRefill();
			if(isDefined(level.gTimePreText)) 
				level.gTimePreText destroy();
			
			level thread countGameTimer();
			foreach(player in level.players) {
				if(player.team == "axis") {
					player freezeControls(false);
					player thread FuSlasherleave();
					player thread grenadecheck();
					player thread numgrenades();
					if(level.survivors != 1 && level.slashers == 1)
						player thread monitorUAV();
				}
				if(isDefined(level.getSlasher) && player != level.getSlasher)
					player thread SlasherSound();
			}
			level notify("counteddown2");
		}
		else {
			announcement("^1Not enough players to start the game! Restarting round...");
			wait 2.5;
			map_restart(false);
		}
	}
}

checkIfSlasherLeftBeforeStart() {
	if(!isDefined(level.getSlasher)){
		self waittill("disconnect");
		level notify("gameover");
		announcement("^1The Slasher left the game, Restarting round...");
		wait 2.5;
		map_restart(false);
	}
}

monitorUAV() {
	level endon("final_player_reached");
	level endon("gameover");
	self endon("death");
	self endon("all_uavs_used");
	
	if(level.players.size >= 0 && level.players.size < 7)
		level.UavUses = 1;
	else if(level.players.size >= 7 && level.players.size < 13)
		level.UavUses = 2;
	else if(level.players.size >= 13)
		level.UavUses = 3;
	
	self.uav_icon = newClientHudElem( self );
    self.uav_icon.x = 625;
    self.uav_icon.y = 410;
    self.uav_icon.alignx = "right";
    self.uav_icon.aligny = "bottom";
    self.uav_icon.horzalign = "fullscreen";
    self.uav_icon.vertalign = "fullscreen";
    self.uav_icon.alpha = 1;
    self.uav_icon.color = level.ui_better_red;
    self.uav_icon.archived = true;
    self.uav_icon.foreground = true;
    self.uav_icon.hidewheninmenu = true;
    self.uav_icon setshader("dpad_killstreak_uav", 25, 25);
    self.uav_icon thread scripts\slasher\main::SetAlphaLow();
    
    self.uav_text = newClientHudElem( self );
    self.uav_text.x = 625;
    self.uav_text.y = 385;
    self.uav_text.alignx = "right";
    self.uav_text.aligny = "bottom";
    self.uav_text.horzalign = "fullscreen";
    self.uav_text.vertalign = "fullscreen";
    self.uav_text.alpha = 1;
    self.uav_text.color = level.ui_better_red;
    self.uav_text.archived = false;
    self.uav_text.fontscale = 1;
    self.uav_text.foreground = true;
    self.uav_text.hidewheninmenu = true;
    self.uav_text settext("Press ^3[{+actionslot 3}] ^7To Use UAV");
    self.uav_text thread scripts\slasher\main::SetAlphaLow();
    
    self.uav_value = newClientHudElem( self );
    self.uav_value.x = 600;
    self.uav_value.y = 410;
    self.uav_value.alignx = "right";
    self.uav_value.aligny = "bottom";
    self.uav_value.horzalign = "fullscreen";
    self.uav_value.vertalign = "fullscreen";
    self.uav_value.alpha = 1;
    self.uav_value.color = level.ui_better_red;
    self.uav_value.archived = true;
    self.uav_value.foreground = true;
    self.uav_value.fontscale = 1.4;
    self.uav_value.hidewheninmenu = true;
    self.uav_value settext(level.UavUses + "x");
    self.uav_value thread scripts\slasher\main::SetAlphaLow();
    
	self notifyonplayercommand("UseUav", "+actionslot 3");
	
	while(true) {
		self waittill("UseUav");
		if(level.UavUses > 0) {
			level.UavUses--;
			if(level.UavUses == 0) {
				if(isdefined(self.uav_text))
					self.uav_text destroy();
				if(isdefined(self.uav_icon))
					self.uav_icon destroy();
				if(isdefined(self.uav_value))
					self.uav_value destroy();
			} 
			else {
				if(isdefined(self.uav_value))
					self.uav_value settext(level.UavUses + "x");
			}
			
			self.uav_value settext("UAV is Active!");
			
			foreach(player in level.players)
				if(!isdefined(player.isghost))
					player thread doUAVTimer();
			
			self.hasradar = true;

			if(isdefined(self.round_number))
				self.round_number.alpha = 0;

			self.radarmode = "fast_radar";
			wait 30;

			self.hasradar = false;
			
			if(level.UavUses == 0)
				self notify("all_uavs_used");
		}
	}
}

doUAVTimer() {
	self endon("all_uavs_used");
	if(isAlive(self)) {
		self.revealedHUDText = self createFancyText("bigfixed", 0.45,"TOPLEFT", "TOPLEFT", 15, -101, "");
		
		if(!isdefined(self.uav_icon)) {
			self.uav_icona = newClientHudElem( self );
    		self.uav_icona.x = 625;
    		self.uav_icona.y = 410;
    		self.uav_icona.alignx = "right";
    		self.uav_icona.aligny = "bottom";
   			self.uav_icona.horzalign = "fullscreen";
    		self.uav_icona.vertalign = "fullscreen";
    		self.uav_icona.alpha = 1;
    		self.uav_icona.color = level.ui_better_red;
    		self.uav_icona.archived = true;
    		self.uav_icona.foreground = true;
    		self.uav_icona.hidewheninmenu = true;
    		self.uav_icona setshader("dpad_killstreak_uav", 25, 25);
    		self.uav_icona thread scripts\slasher\main::SetAlphaLow();
    		
    		self.uav_text = newClientHudElem( self );
    		self.uav_text.x = 600;
    		self.uav_text.y = 410;
    		self.uav_text.alignx = "right";
    		self.uav_text.aligny = "bottom";
    		self.uav_text.horzalign = "fullscreen";
    		self.uav_text.vertalign = "fullscreen";
    		self.uav_text.alpha = 1;
    		self.uav_text.color = level.ui_better_red;
    		self.uav_text.archived = true;
    		self.uav_text.foreground = true;
    		self.uav_text.font = "bigsized";
    		self.uav_text.fontscale = 1.4;
    		self.uav_text.hidewheninmenu = true;
    		self.uav_text settext("UAV is Active!");
    		self.uav_text thread scripts\slasher\main::SetAlphaLow();
		}
		
		self.revBox = self createFontString("default", 1);
		self.revBox setPoint("TOPLEFT", "TOPLEFT", 15, -100);
		self.revBox.hideWhenInMenu = false;
		self.revBox.foreground = false;
		self.revBox setShader("black", 133, 10);
		self.revBox.alpha = 0.7;
		self.revBox thread scripts\slasher\main::SetAlphaLow();

		time = 30;
		hudTime = 30;
		self.uavprog = createUAVProgressBar();
		self.uavprog.bar.x = -152;
		self.uavprog.bar.y = -60;
		self.uavprog updateBar(0, 1/time);
		self.uavprog.hidewheninmenu = true;
		self.uavprog.color = (0, 0, 0);
		self.uavprog.bar.color = level.ui_better_red;
		self.uavprog thread scripts\slasher\main::SetAlphaLow();
		self.uavprog.bar thread scripts\slasher\main::SetAlphaLow();
		for(waitedTime = 0;waitedTime < time && isAlive(self); waitedTime += 0.05) {
			while(hudTime > 0) {
				hudTime--;
				wait 1;
				if(hudTime == 0) {
					if(isDefined(self.uav_icona)) 
						self.uav_icona destroy();
					if(isDefined(self.revBox)) 
						self.revBox destroy();
					if(isDefined(self.uavprog)) 
						self.uavprog destroyElem();
					if(isDefined(self.uav_text)) 
						self.uav_text destroy();
					
					if(isdefined(self.uav_value))
						self.uav_value settext(level.UavUses + "x");
				}
			}
			wait 0.05;
		}
	}
}

createUAVProgressBar() {
	bar = createBar( (1, 1, 1), level.primaryProgressBarWidth, 8);
	if ( level.splitScreen )
		bar setPoint("TOP", undefined, level.primaryProgressBarX, level.primaryProgressBarY);
	else
		bar setPoint("BOTTOMRIGHT", "BOTTOMRIGHT", -30, -58);

	return bar;
}

createProgressText(font, scale, align, relative, x, y, string, color, glowcolor, glowalpha){
	text = level createServerFontString(font, scale);
	text setPoint(align, relative, x, y);
	text setText(string);
	text.color = (0.0, 0.0, 0.0);
	text.glowcolor = (0, 0, 0);
	text.glowalpha = 9.5;
	return text;
}

countPlayersAlive() {
	level endon("disconnect");
	level endon("final_player_reached");
	level endon("HeliTAKEOFF");
	level endon("gameover");
	
	level.playersAlive = 0;
	
	for(;;) {
		foreach(player in level.players) {
			if(player.team == "allies" && isAlive(player))
				level.playersAlive++;
		}
		wait .05;
	}
}

FuSlasherleave() {
	self waittill("disconnect");
	foreach(player in level.players) {
		player notify("SlasherLeave");
		player.soundplayed = false;
		player stopLocalSound("mm_near");
	}
}

monitorSlasherKill() {
	self endon("disconnect");
	self endon("final_player_reached");
	self endon("survivor_is_spectating");
	level endon("end_died_monitoring");
	level endon("gameover");
	
	for(;;) {
		if(self.team == "allies" && level.ingame) {
			self waittill("death");
			
			if(isDefined(self.soundplayed) && self.soundplayed){
				self stopLocalSound("mm_near");
				self.soundplayed = false;
			}
			
			foreach(player in level.players)
				player playlocalsound("mp_enemy_obj_captured");
			
			self notify("survivor_is_spectating");
		}
		else if(self.team == "axis" && level.ingame){
			self waittill("killed_enemy");
			
			score = 0;
			hint = "";
			
			if(isdefined(level.finalPlayer)) {
				score += level.SlasherPoints.SlasherKill;
				hint = "Survivor Killed";
			}
			else {
				score += level.SlasherPoints.SlasherKill;
				hint = "Survivor Killed";
			}
				
			self.score += score;
			self thread scripts\slasher\main::draw_xp(score, hint);
		}
		wait 0.05;
	}
}

SoundOnOrigin(alias,origin) {
	soundPlayer = spawn("script_origin", origin);
	soundPlayer playsound(alias);
}

SlasherSound() {
	self endon("disconnect");
	self endon("SlasherLeave");
	self endon("survivor_is_spectating");
	
	self stopLocalSound("mm_near");
	self.soundplayed = false;
	self.namehudshader = "";
	
	for(;;) {
		if( IsAlive(self) && isdefined(level.slashers) && level.slashers == 1) {
			if(level.finalPlayer && self.soundplayed) {
				self.soundplayed = false;
				self stopLocalSound("mm_near");
			}
			else if(distance(self.origin, level.getslasher.origin) <= 700 && !self.soundplayed && !level.finalPlayer && level.getslasher GetStance() != "crouch")  {
				self.soundplayed = true;
				self playLocalSound("mm_near");
			}
			else if(distance(self.origin, level.getslasher.origin) <= 700 && self.soundplayed && !level.finalPlayer && level.getslasher GetStance() == "crouch" && isdefined(level.getslasher.isinhidden))  {
				self.soundplayed = false;
				self stopLocalSound("mm_near");
			}
			else if(distance(self.origin, level.getslasher.origin) > 700 && self.soundplayed && !level.finalPlayer) {
				self.soundplayed = false;
				self stopLocalSound("mm_near");
			}
		}
		else if(self.soundplayed) {
			self.soundplayed = false;
			self stopLocalSound("mm_near");
		}
		
		if(isDefined(self.namehudicon)) {
			if(self.team == "axis" && self.namehudshader != "mm") {
				self.namehudicon setshader("hud_icon_mm", 25, 25);
				self.namehudshader = "mm";
			}
			else if(self.team == "allies" && self.namehudshader != "sand") {	
				self.namehudicon setshader("iw5_cardicon_sandman2", 25, 25);
				self.namehudshader = "sand";
			}
		}
		wait 0.05;
	}
}

doSurvivorRefill() {
	foreach(player in level.players) {
		if(player.team == "allies") {
			if(GetTeamPlayersAlive("allies") >= 13){
				level.saveAmmoCountForReconnect = 1;
				player setweaponammoclip("iw5_deserteagleiw3_mp", 1);
				player setweaponammostock("iw5_deserteagleiw3_mp",0);
			}
			else if(GetTeamPlayersAlive("allies") >= 7 && GetTeamPlayersAlive("allies") < 13) {
				level.saveAmmoCountForReconnect = 2;
				player setweaponammoclip("iw5_deserteagleiw3_mp", 2);
				player setweaponammostock("iw5_deserteagleiw3_mp",0);
			}
			else if(GetTeamPlayersAlive("allies") >= 0 && GetTeamPlayersAlive("allies") < 6) {
				level.saveAmmoCountForReconnect = 3;
				player setweaponammoclip("iw5_deserteagleiw3_mp",3);
				player setweaponammostock("iw5_deserteagleiw3_mp",0);
			}
			else {
				player setweaponammoclip("iw5_deserteagleiw3_mp",3);
				player setweaponammostock("iw5_deserteagleiw3_mp",0);
				level.saveAmmoCountForReconnect = 3;
			}
		}
	}
}

countGameTimer() {
	level endon("disconnect");
	level endon("final_player_reached");
	level endon("gameover");
	
	getround = getDvarInt("round");
	
	level.gameTimer = 310;
	
	foreach(player in level.players) {
		if(isdefined(player.Time_Left)) {
			player.Time_Left.alpha = 1;
    		player.Time_Left setTimer(level.gameTimer);
    	}
	}

	while(level.gameTimer > 0) {
		if(level.gameTimer == 300) {
			foreach(player in level.players)
				player thread scripts\slasher\main::SendNewNotification("Exfil arrives in ^14 ^7Minutes!");
			foreach(player in level.players)
				if(player.team == "allies")
					player PlayLocalSound("mm_spawn3");
		} 
		else if(level.gameTimer == 240) {
			foreach(player in level.players)
				player thread scripts\slasher\main::SendNewNotification("Exfil arrives in ^13 ^7Minutes!");
		}
		else if(level.gameTimer == 180) {
			foreach(player in level.players)
				player thread scripts\slasher\main::SendNewNotification("Exfil arrives in ^12 ^7Minutes!");
		}
		else if(level.gameTimer == 120) {
			foreach(player in level.players)
				player thread scripts\slasher\main::SendNewNotification("Exfil arrives in ^11 ^7Minute!");
		}
		else if(level.gameTimer == 60) {
			level.escapeInit = true; //stop the Still Alive scorepopup
			level thread createPlayerExfilHud();

			//end tp to spawn for slasher
			foreach(player in level.players) {
				if(player.team == "axis") {
					if(isdefined(player.stuckText)) 
						player.stuckText destroy();
					player notify("end_stuck_monitoring");
				}
			}
			
			foreach(player in level.players) {
				if(player.team == "allies") {
					player thread stopTheEarrape(); //maybe we don't want to earrape players at this point ;)
					player thread scripts\slasher\main::SendNewNotification("Exfil incoming... Get to the Exfil location and escape!");
				}
				if(player.team == "axis")
					player thread scripts\slasher\main::SendNewNotification("Defend the Exfil location!");
				player playLocalSound("mm_escape");
			}		
			thread scripts\slasher\exfilspawns::init();

			level.birdy = undefined;
			level thread spawnHeli();
		}
		wait 1;
		level.gameTimer--;
	}
}

stopTheEarrape() {
	level endon("gameover");
	for(;;) {
		if(isDefined(self.soundplayed)) {	
			if(self.soundplayed) {
				self stopLocalSound("mm_near");
				self.soundplayed = false;
			}
		}
		wait 0.05;
	}
}

createText(font, scale, align, relative, x, y, string) {
	text = self createFontString(font, scale);
	text setPoint(align, relative, x, y);
    if(isdefined(string))
		text setText(string);
	return text;
}

getAllies() {
    allies = [];
    foreach(player in level.players) {
        if(player.team == "allies")
            allies[allies.size] = player;
    }
    return allies;
}

createPlayerExfilHud() {
	level endon("disconnect");
	level endon("destroy_exfil_hud");
	level.hEnter = level createServerFancyText("bigfixed", 0.75, "CENTER", "CENTER", 0, -180, "");
	level.hEnter.alpha = 0;
	level.hEnter fadeOverTime(3);
	level.hEnter.color = level.ui_better_red;
	level.hEnter.alpha = 1;
	for(;;) {
		if(isDefined(level.hEnter))
			level.hEnter setText("Survivors Extracted: ^1" + level.countHeliPlayersEntered);
		else 
			level notify("destroy_exfil_hud");
		wait 1;
	}
}

monitorScore(){
	level endon("disconnect");
	level endon("final_player_reached");
	level.calledScore = true;
	while(level.ingame && !level.escapeInit) {
		wait 20;
		foreach(player in level.players) {
			if(player.team == "allies") {
				player.score += level.SlasherPoints.AliveBonus;
				player thread scripts\slasher\main::draw_xp(level.SlasherPoints.AliveBonus, "Alive Bonus");
			}
		}
	}
}

TextMap( intensity, color, glow, glowintensity, text )
{
	self endon( "disconnect" );
	wait ( 0.05 );
	if(isDefined(self.textmap)) self.textmap destroy();
	self notify( "textmaps" );
	self endon( "textmaps" );
	self.textmap = newClientHudElem( self );
	self.textmap.horzAlign = "center";
	self.textmap.vertAlign = "middle";
	self.textmap.alignX = "center";
	self.textmap.alignY = "middle";
	self.textmap.x = 0;
	self.textmap.y = -600;
	self.textmap.font = "bigfixed";
	self.textmap.fontscale = 1.35;
	self.textmap.color = level.ui_better_red;
	self.textmap setText(text);
	self.textmap.alpha = intensity;
	self.textmap.glowColor = glow;
	self.textmap.glowAlpha = glowintensity;
	self.textmap moveOverTime( 0.50 );
	self.textmap.x = 0;
	self.textmap.y = -80;
	wait 2;
	self.textmap moveOverTime( 0.50 );
	self.textmap.x = -600;
	self.textmap.y = -80;
	wait 0.60;
	if(isDefined(self.textmap)) self.textmap destroy();
}

TextMap2( text, intensity, color, glow, glowintensity )
{
	self endon( "disconnect" );
	wait ( 0.05 );
	if(isDefined(self.textmap2)) self.textmap2 destroy();
	self notify( "textmaps2" );
	self endon( "textmaps2" );
	self.textmap2 = newClientHudElem( self );
	self.textmap2.horzAlign = "center";
	self.textmap2.vertAlign = "middle";
	self.textmap2.alignX = "center";
	self.textmap2.alignY = "middle";
	self.textmap2.x = 0;
	self.textmap2.y = 685;
	self.textmap2.font = "bigfixed";
	self.textmap2.fontscale = 0.85;
	self.textmap2.color = color;
	self.textmap2 setText(text);
	self.textmap2.alpha = intensity;
	self.textmap2.glowColor = glow;
	self.textmap2.glowAlpha = glowintensity;
	self.textmap2 moveOverTime( 0.50 );
	self.textmap2.x = 0;
	self.textmap2.y = -55;
	wait 2;
	self.textmap2 moveOverTime( 0.50 );
	self.textmap2.x = 610;
	self.textmap2.y = -55;
	wait 0.60;
	if(isDefined(self.textmap2)) 
		self.textmap2 destroy();
}

monitorgame() {
	level endon("gameover");
	level endon("disconnect");
	level endon("startgame");
	level endon("Heli_exitfunc");
	level.calledScore = false;
	getround = getDvarInt("round");
	for(;;) {
		if(level.ingame) {
			if(isDefined(level.calledScore) && !level.calledScore) level thread monitorScore();
			if(level.survivors == 1 && level.slashers == 1 && !level.finalPlayer) {//1v1 Slashout {
				level notify("1v1meonrust");
				if(isdefined(level.gTime)) 
					level.gTime destroy();

				level.finalPlayer = true;

				foreach(player in level.players) {
					if(player.sesstionstate != "spectator") {
						player allowjump(1);
						if(isdefined(player.stuckText)) 
							player.stuckText destroy();
					
						if(isDefined(player.uav_icona)) 
							player.uav_icona destroy();
					
						if(isDefined(player.revBox)) 
							player.revBox destroy();
					
						if(isDefined(player.uavprog)) 
							player.uavprog destroyElem();
					
						if(isDefined(player.uav_text)) 
							player.uav_text destroy();
					
						if(isDefined(player.uav_icon)) 
							player.uav_icon destroy();
					
						if(isDefined(player.uav_value)) 
							player.uav_value destroy();
					
						player thread TextMap(1, (1,0,0), (0.7,0,0), 1, "1v1 Slashout");
						player thread TextMap2("Slash First To Win!", 1, (1,0,0), (0.7,0,0), 1);
					
						player.hasradar = true;
						player.radarmode = "fast_radar";
						player PlayLocalSound("mm_suddendeath");

						if(isalive(player) && !isdefined(player.isghost)) {
							player TakeAllWeapons();
							player giveweapon("iw5_slashnburn_mp");
							player setweaponammoclip("iw5_slashnburn_mp", 0);
							player setweaponammostock("iw5_slashnburn_mp", 0);
							player setspawnweapon("iw5_slashnburn_mp");
						}
						player thread KillPlayerHud();
						player stopLocalSound("mm_escape");
						player playLocalSound("mp_obj_captured");

						if(isDefined(player.soundplayed)) {
							if(player.soundplayed){
								player stopLocalSound("mm_near");
								player.soundplayed = false;
							}
						}
					}
				}
				level notify("final_player_reached");
			}
			if(level.survivors == 0 && level.slashers == 1) {
				level thread EndLevelHud();
				
				notifyData = spawnstruct();
				notifyData.titleText = "^1The Slasher Wins This Round!";
				notifyData.notifyText = "^1All Survivors Were Killed!";
				if(getround != 3) 
					notifyData.notifyText2 = "^1Next Round Starting Soon...";
				notifyData.duration = 8;
				notifyData.glowColor = (0.7, 0.0, 0.0);
				foreach(player in level.players) {
					player thread KillPlayerHud();
					player freezeControls(true);
					player VisionSetNakedForPlayer("blacktest", 1.1);
					player playLocalSound("mm_endround");
					player thread maps\mp\gametypes\_hud_message::notifyMessage( notifyData );
					wait 0.05;
				}
				level thread roundsys();
				level notify("gameover");
			}
			else if(level.survivors == 1 && level.slashers == 0) {
				level thread EndLevelHud();

				notifyData = spawnstruct();
				notifyData.titleText = "^1Survivors Win This Round!";
				notifyData.notifyText = "^1The Slasher Has Fallen!";
				if(getround != 3)
					notifyData.notifyText2 = "^1Next Round Starting Soon...";
				notifyData.duration = 8;
				notifyData.glowColor = (0.7, 0.0, 0.0);
				foreach(player in level.players) {
					player thread KillPlayerHud();
					player freezeControls(true);
					player VisionSetNakedForPlayer("blacktest", 1.1);
					player playLocalSound("mm_endround");
					player thread maps\mp\gametypes\_hud_message::notifyMessage( notifyData );
					wait 0.05;
				}
				level thread roundsys();
				level notify("gameover");
			}
			else if(level.survivors > 1 && level.slashers < 1) {
				level notify("all_grenades_used");
				level.repickingSlasher = true;
				level chooseSlasher();
				foreach(player in level.players) {
					if(isDefined(level.slasherSlow) && level.slasherSlow >= 0)
						level notify("1v1meonrust");

					if(isDefined(player.uavprog)) 
						player.uavprog destroyElem();
					if(isDefined(player.revealedHUD))
						player.revealedHUD destroy();
					if(isDefined(player.revealedHUDText)) 
						player.revealedHUDText destroy();
					if(isDefined(player.revBox)) 
						player.revBox destroy();
					if(isDefined(player.revBoxIcon)) 
						player.revBoxIcon destroy();
				}
				foreach(player in level.players) {
					if(player.team == "axis") {
						if(isdefined(player.bulletHUD)) 
							player.bulletHUD destroy();
						if(isdefined(player.bulletHUDText)) 
							player.bulletHUDText destroy();
						if(isdefined(player.bBox)) 
							player.bBox destroy();
						if(isdefined(player.bBox2))
							player.bBox2 destroy();
						if(isdefined(player.bBoxIcon)) 
							player.bBoxIcon destroy();
						
						if(level.survivors != 1 && isdefined(level.getSlasher) && player == level.getSlasher) {
							player setOffhandPrimaryClass("other");
							player givePerk("semtex_mp", true);
							player givePerk("specialty_fastoffhand", true);
							player takeWeapon("semtex_mp");
							player thread FuSlasherleave();
							player thread grenadecheck();
							player thread numgrenades();
							player thread monitorUAV();
						}
					}
					if(isDefined(level.getSlasher) && player != level.getSlasher)
						player thread SlasherSound();
				}
			}
			else if(level.survivors == 0 && level.slashers == 0){
				level thread EndLevelHud();
				
				notifyData = spawnstruct();
				notifyData.titleText = "^1No One Won This Time!";
				notifyData.notifyText = "^1Survivor/Slasher Left The Game!";
				if(getround != 3) 
					notifyData.notifyText2 = "^1Next Round Starting Soon...";
				notifyData.duration = 8;
				notifyData.glowColor = (0.7, 0.0, 0.0);
				foreach(player in level.players) {
					player thread KillPlayerHud();
					player freezeControls(true);
					player VisionSetNakedForPlayer("blacktest", 1.1);
					player playLocalSound("mm_endround");
					player thread maps\mp\gametypes\_hud_message::notifyMessage( notifyData );
					wait 0.05;
				}
				level thread roundsys();
				level notify("gameover");
			}
		}
		wait 0.5;
	}
}

KillPlayerHud() {
	if(isdefined(self.bBox))
		self.bBox destroy();
	if(isdefined(self.bBox2))
		self.bBox2 destroy();
	if(isdefined(self.bBoxIcon))
		self.bBoxIcon destroy();
	if(isdefined(self.bulletHUD))
		self.bulletHUD destroy();
	if(isdefined(self.bulletHUDText))
		self.bulletHUDText destroy();
	if(isdefined(self.uBox))
		self.uBox destroy();
	if(isdefined(self.uBox2))
		self.uBox2 destroy();
	if(isdefined(self.uBoxIcon))
		self.uBoxIcon destroy();
	if(isdefined(self.uavHUD))
		self.uavHUD destroy();
	if(isdefined(self.uavHUDText))
		self.uavHUDText destroy();
	if(isdefined(self.uavHUDHelpText))
		self.uavHUDHelpText destroy();
	if(isdefined(self.uavprog))
		self.uavprog destroyElem();
	if(isdefined(self.revealedHUD))
		self.revealedHUD destroy();
	if(isdefined(self.revealedHUDText))
		self.revealedHUDText destroy();
	if(isdefined(self.revBox))
		self.revBox destroy();
	if(isdefined(self.revBoxIcon))
		self.revBoxIcon destroy();
	if(isdefined(self.helihint))
		self.helihint destroy();
	if(isdefined(self.heliIconSurv))
		self.heliIconSurv destroy();
	if(isdefined(self.heliIconSlasher))
		self.heliIconSlasher destroy();
}

EndLevelHud() {
	if(isdefined(level.gTime))
		level.gTime destroy();
	if(isdefined(level.gTimeText))
		level.gTimeText destroy();
	if(isdefined(level.rBox))
		level.rBox destroy();
	if(isdefined(level.rBox2))
		level.rBox2 destroy();
	if(isdefined(level.rBox3))
		level.rBox3 destroy();
	if(isdefined(level.rnd))
		level.rnd destroy();
	if(isdefined(level.pAlive))
		level.pAlive destroy();
	if(isdefined(self.teamIcon))
		self.teamIcon destroy();
	if(isdefined(self.teamIcon2))
		self.teamIcon2 destroy();
	if(isdefined(level.hEnter))
		level.hEnter destroy();
}

roundsys() {
	round = GetDvarInt("round");
	level.inendscreen = 1;
	round++;
	setDvar("round", round);
	if(round >= getDvarInt("maxround")) {
		level notify("DestroyHuds");
		setDvar("round", 1);
		wait 10;
		foreach(player in level.players){
			if(player.team == "allies" || player.team == "axis"){
				player.sessionteam = "spectator";
            	player maps\mp\gametypes\_menus::addToTeam("spectator");
            	player.team = "spectator";
            	player thread in_spawnSpectator(self.origin,self.angles);
			}
		}
		wait 0.05;
		scripts\slasher\mapvote::mapvote();
	}
	else {
		level notify("DestroyHuds");
		wait 8.5;
		output = "";
		
		SetDvar("currentscores", "a");
		
		for(i = 0;i < level.players.size;i++)
			output += level.players[i].name + "," + level.players[i].score +",";
		SetDvar("currentscores", output);
	    map_restart(false);
	}
}

spawnHeli() {
	level notify("Heli_exitfunc");
	if(level.slashers == 0 && !isDefined(level.repickingSlasher)){
		level.repickingSlasher = true;
		level chooseSlasher();
	}
	level.getSlasher thread slasherLeaveExfil();
	level thread heliSlasherEnd();

	level.fx_airstrike_contrail = loadfx ("smoke/jet_contrail"); 
	level.birdy = spawnHelicopter(randPlayer(),level.helispawn,VectorToAngles( level.flyto - level.helispawn ),"pavelow_mp","vehicle_pavelow_opfor");
	level.birdy.target = level.flyto+level.flytohigher;
	level.birdy Vehicle_SetSpeed(level.accel,20, 20);
	level.birdy SetTurningAbility(1);
	level.birdy SetMaxPitchRoll(25,15);
	level.birdy.angles = VectorToAngles( level.flyto - level.helispawn );

	level.birdy setVehGoalPos(level.flyto+level.flytohigher, 1);

	level.birdy thread startmoving();

	level.birdy.landing_fx = spawnFx(level.circlefx, level.flyto);
	if(isdefined(level.fxangles))
		level.birdy.landing_fx.angles = level.fxangles;
	triggerFx(level.birdy.landing_fx);

	foreach(player in level.players) {
		if(player.team == "allies")
			player thread createSurvivorHeliIcon(level.birdy);
		else if(player.team == "axis")
			player thread createSlasherHeliIcon(level.birdy);
	}
}

slasherLeaveExfil(){
	level endon("gameover");
	self waittill("disconnect");
	level.slasherLeft = true;
	level thread EndLevelHud();
	foreach(player in level.players){
		player stopLocalSound("mm_escape");
		player thread KillPlayerHud();
	}

	VisionSetNaked(getDvar("mapname"), 2);

	level.birdy thread flyback();
	level thread startEndGame(undefined, level.birdy.origin);
	level.birdy notify("heli_takeoff");
	level notify("HeliTAKEOFF");
}

heliSlasherEnd(){
	level endon("HeliTAKEOFF");
	getround = getDvarInt("round");
	for(;;) {
		if(level.survivors == 0 && level.slashers == 1) {

			level thread EndLevelHud();

			level.birdy thread flyback();
			waitframe();
			level.birdy notify("startmoving");
			
			notifyData = spawnstruct();
			notifyData.titleText = "^1The Slasher Wins This Round!";
			notifyData.notifyText = "^1All Survivors Were Killed!";
			if(getround != 3) notifyData.notifyText2 = "^1Next Round Starting Soon...";
			notifyData.duration = 8;
			notifyData.glowColor = (0.7, 0.0, 0.0);
			foreach(player in level.players) {
				player thread KillPlayerHud();
				player freezeControls(true);
				player VisionSetNakedForPlayer("blacktest", 1.1);
				player stopLocalSound("mm_escape");
				player playLocalSound("mm_endround");
				player thread maps\mp\gametypes\_hud_message::notifyMessage( notifyData );
				wait 0.05;
			}

			level thread roundsys();
			level notify("HeliTAKEOFF");
			level notify("gameover");
		}
		waitframe();
	}
}

createSurvivorHeliIcon(player)
{
    self endon("disconnect");
	self.heliIconSurv = newClientHudElem(self);
    self.heliIconSurv setShader("waypoint_target", 5, 5);
    self.heliIconSurv setWaypoint(true, true);

    self.heliIconSurv SetTargetEnt(level.birdy);
}
createSlasherHeliIcon(player)
{
    self endon("disconnect");
	self.heliIconSlasher = newClientHudElem(self);
    self.heliIconSlasher setShader("waypoint_defend", 5, 5);
    self.heliIconSlasher setWaypoint(true, true);

    self.heliIconSlasher SetTargetEnt(level.birdy);
}

flyback()
{
	level.birdy waittill("startmoving");
	self Vehicle_SetSpeed(50,10);
	self setVehGoalPos(level.helispawn,1);
	wait 60;
	self delete();
}

startmoving() {
	level.birdy endon("heli_takeoff");
	self waittill ( "goal" );
    
	self Vehicle_SetSpeed(3,2);
	level.helitrig = Spawn("trigger_radius", level.flyto, 0, 120, 120);
	
	foreach(player in level.players) {
		if(player.team == "allies") {
			player.inside = false;
			player PlayLocalSound("mm_exfil_targetarea");
		}
	}

	self thread Helilogic();
	level.helitrig thread HintMsg();

	while(true) {
		level.helitrig waittill( "trigger", player );

		if(player.team == "allies" && !player.inside && player UseButtonPressed()) {
			player.inside = true;
			if(isdefined(player.helihint)) 
				player.helihint destroy();
			if(isdefined(player.heliIconSurv)) 
				player.heliIconSurv destroy();
			if(isdefined(player.bulletHUD))
				player.bulletHUD destroy();
			if(isdefined(player.bulletHUDText)) 
				player.bulletHUDText destroy();
			if(isdefined(player.bBox)) 
				player.bBox destroy();
			if(isdefined(player.bBox2)) 
				player.bBox2 destroy();
			if(isdefined(player.bBoxIcon)) 
				player.bBoxIcon destroy();
			player thread PlayerEnterHeli();
			player notify("heli_entered");
		}
	}
}

hintMsg() {
	self endon("heli_takeoff");
	for(;;) {
		level.helitrig waittill( "trigger", player );

		if(player.team == "allies") {
			if(!isdefined(player.helihint)) 
				player helihud();
			
			if(player.helihint.alpha == 0){
				player.helihint.alpha = 1;
				player thread onleavetrig();
			}
		}
	}
}

onleavetrig() {
	while(isdefined(level.helitrig) && self IsTouching(level.helitrig))
		waitframe();
	self.helihint.alpha = 0;
}

helihud() {
	self.helihint = NewClientHudElem( self );
	self.helihint.horzAlign = "center";
   	self.helihint.vertAlign = "middle";
   	self.helihint.alignX = "center";
   	self.helihint.alignY = "middle";
	self.helihint.X = 0;
   	self.helihint.Y = 30;
   	self.helihint.foreground = 1;
	self.helihint.font = "bigfixed";
   	self.helihint.fontscale = 0.6;
   	self.helihint.alpha = 0;
   	self.helihint.color = (1.0, 0.0, 0.0);
	self.helihint.glowcolor = (0.7, 0, 0);
	self.helihint.glowalpha = 0;
   	self.helihint SetText("^7Press ^1[{+activate}] ^7To Enter The Heli");
}

PlayerEnterHeli() {
	self takeAllWeapons();
	self hide();
	self setStance("crouch");
	self setClientDvar("r_zfar", "0");
	self setClientDvar("fx_enable", "1");
	self setClientDvar("r_fog", "1");
	self setClientDvar("r_lightmap", "1");
	self.statusicon = "hud_minimap_pavelow_green";
	self.score += level.SlasherPoints.ExfilSuccess;
	self thread scripts\slasher\main::draw_xp(level.SlasherPoints.ExfilSuccess, "Successful Exfil!");
	
	self thread doUFOMode();
	self.team = "spectator";
	self.protected = 1;
	level.countHeliPlayersEntered++;
	
	iprintlnbold("^7" + self.name + "  ^1has secured exfil!");
	
	foreach(player in level.players) 
		player playLocalSound("mp_war_objective_taken");
		
	self.maxhealth = 100000;
	self.health = self.maxhealth;
}

Helilogic() {
	level endon("HeliTAKEOFF");
	
	while(level.teamCount["allies"] != 0) {
		if(level.gameTimer > 0 && level.playersAlive == level.countHeliPlayersEntered) {
			level thread EndLevelHud();
			foreach(player in level.players){
				player stopLocalSound("mm_escape");
				player thread KillPlayerHud();
			}

			VisionSetNaked(getDvar("mapname"), 2);

			self thread flyback();
			level thread startEndGame(self, level.birdy.origin);
			
			level.birdy notify("heli_takeoff");
			level notify("HeliTAKEOFF");
		}
		
		if(level.gameTimer == 0) {			
			level thread EndLevelHud();
			foreach(player in level.players){
				player stopLocalSound("mm_escape");
				player thread KillPlayerHud();
			}
			
			if(isdefined(level.LastSecondsTimer))
				level.LastSecondsTimer destroy();

			VisionSetNaked(getDvar("mapname"), 2);

			self thread flyback();
			level thread startEndGame(self, level.birdy.origin);
			level.birdy notify("heli_takeoff");
			level notify("HeliTAKEOFF");
		}
		waitframe();
	}
}

playFxonPos(effect,pos,time)
{
	if(!isDefined(effect) || !isDefined(pos))
	{
		iPrintln("^1ERROR: Invalid use of ''^3playFxonPos^1''!");
		return;
	}
	if(!isDefined(time))
		time = -1;
	while(time != 0)
	{
		fx = spawnFx(effect,pos);
		triggerfx(fx);
		wait 1;
		fx delete();
		time--;
	}
}

startEndGame(lastplayer,pos)
{	
	if(isDefined(level.birdy.landing_fx)) level.birdy.landing_fx delete();
	if(!isDefined(level.helicounter)) level.helicounter = 0;
	level.helicounter++;
	if(level.helicounter > 1) return;
	if(!isDefined(lastplayer)){
		allies = getAllies();
		if(allies.size > 0){
			lastplayer = allies[randomInt(allies.size)];
		}
	}
	wait .1;

	level.birdy notify("startmoving");
	level notify("end_died_monitoring");

	wait 0;

	foreach(player in level.players) {
		player playLocalSound("fasten_seatbelts");
	}

	level.ingame = false;
	level.specNewPlayers = true;
	if(!isDefined(level.slasherLeft)) level thread harrierstrike();

	wait 10;
	round = GetDvarInt("round");
	notifyGameTimeRescue = spawnstruct();
	notifyGameTimeRescue.titleText = "^1Round Over!";
	if(isDefined(level.slasherLeft))
		notifyGameTimeRescue.notifyText = "^1The Slasher Left The Game!";
	else if(level.countHeliPlayersEntered == 0)
		notifyGameTimeRescue.notifyText = "^1No One Made It To The Exfil In Time!";
	else
		notifyGameTimeRescue.notifyText = "^1Survivors Live Another Day!";
	if(round != 3) notifyGameTimeRescue.notifyText2 = "^1Next Round Starting Soon...";
	notifyGameTimeRescue.duration = 8;
	notifyGameTimeRescue.glowColor = (0.7, 0.0, 0.0);
	foreach(player in level.players) {
		player stopLocalSound("mm_near");
		player VisionSetNakedForPlayer("blacktest", 5);
		player freezeControls(true);
		player StopLocalSound("nuke_explosion");
		player StopLocalSound("nuke_wave");
		player PlaySoundAsMaster("mm_exfil");
		player thread maps\mp\gametypes\_hud_message::notifyMessage( notifyGameTimeRescue );
	}
	level thread roundsys();
	//level.ingame = false;
	level notify("gameover");
}

createCameraPos() {
	for(;;) {
		self moveTo(level.birdy.origin+(-500,50,100), 1);
		wait .1;
	}
}

createEndGameHud(text,i) {
	hud = level createServerFontString("bigfixed", 0.85);
    hud setPoint("CENTER", "CENTER", 0, i*50 - 100);
	hud setText(text);
	hud.alpha = 0;
	hud.glowalpha = 1;
	hud.glowcolor = (0.7,0,0);
	hud.color = (1,0,0);
	hud fadeovertime(2);
	hud.alpha = 1;
}

//////////////////////////////// BASE FUNCTIONS ///////////////////////////
createServerText(font, scale, align, relative, x, y, string)
{
	text = level createServerFontString(font, scale);
	text setPoint(align, relative, x, y);
    if(isdefined(string))
	text setText(string);
	return text;
}
createFancyText(font, scale, align, relative, x, y, string){
	text = self createFontString(font, scale);
	text setPoint(align, relative, x, y);
	if(isdefined(string))
	text setText(string);
	text.color = (1.0, 0.0, 0.0);
	text.glowcolor = (0.7, 0, 0);
	text.glowalpha = 1;
	return text;
}
createServerFancyText(font, scale, align, relative, x, y, string){
	text = level createServerFontString(font, scale);
	text setPoint(align, relative, x, y);
	if(isdefined(string))
	text setText(string);
	text.color = (1.0, 0.0, 0.0);
	text.glowcolor = (0.7, 0, 0);
	text.glowalpha = 1;
	return text;
}

setTeam(team) {
	self maps\mp\gametypes\_menus::addToTeam(team);
	wait 0.0001;
	if(isdefined(self.namehudicon)) {
		if(team == "axis")
			self.namehudicon setshader("hud_icon_mm", 25, 25);
		else
			self.namehudicon setshader("iw5_cardicon_sandman2", 25, 25);
	}
    self notify("menuresponse", "changeclass", "class1");
	self notify("changedteam");
}

forceTeam(team){
	self notify("menuresponse", game["menu_team"], team);
	wait 0.0001;
	if(isdefined(self.namehudicon)) {
		if(team == "axis")
			self.namehudicon setshader("hud_icon_mm", 25, 25);
		else
			self.namehudicon setshader("iw5_cardicon_sandman2", 25, 25);
	}
    self notify("menuresponse", "changeclass", "class1");
	self notify("changedteam");
}

showSlasherMessage(message){
	msg = self createText("bigfixed", 0.85, "center", "center", 0, -120, message);
	msg.glowalpha = 1;
	msg.glowcolor = (1,0,0);
	msg.color = (1,0,0);
	msg SetPulseFX(50, 4000, 1800);
	msg FadeOverTime(10);
	msg.alpha = 0;
	wait 10;
	msg destroy();
}

showDiedMessage(message, message2) {
	msgD = newhudelem();
    msgD.x = 635;
	msgD.y = 120;
	msgD.alignx = "right";
   	msgD.aligny = "bottom";
   	msgD.horzalign = "fullscreen";
   	msgD.vertalign = "fullscreen";
    msgD.font = "objective";
    msgD.fontscale = 1.4;
    msgD.color = level.ui_better_red;
    msgD.archived = true;
    msgD.foreground = true;
    msgD.hidewheninmenu = true;
    msgD SetPulseFX( 50, 6500, 1000 );
    msgD settext(message);
    
    wait 1;
	
	msg2 = newhudelem();
    msg2.x = 635;
	msg2.y = 132;
	msg2.alignx = "right";
   	msg2.aligny = "bottom";
   	msg2.horzalign = "fullscreen";
   	msg2.vertalign = "fullscreen";
    msg2.font = "objective";
    msg2.fontscale = 1.1;
    msg2.color = (1,1,1);
    msg2.archived = true;
    msg2.foreground = true;
    msg2.hidewheninmenu = true;
    msg2 SetPulseFX( 50, 6500, 1000 );
    msg2 settext(message2);
	
    wait 5;
    if(isdefined(msgD))
		msgD destroy();
    if(isdefined(msg2))
		msg2 destroy();
}

showSlasherScoreKillMessage(message){
	level endon("final_player_reached");
	msg = level createServerText("hudsmall", 1.05, "BOTTOMLEFT", "BOTTOMLEFT", 15, -40, message);
	msg.glowalpha = 1;
	msg.glowcolor = (1,0,0);
	msg.color = (1,0,0);
	msg SetPulseFX(50, 4000, 1800 );
	msg FadeOverTime(2);
	msg.alpha = 0;
	wait 10;
	msg destroy();
}



///////////////////////////////////////////////// Nuke ///////////////////////////////////////////

startnuke() {
	//iprintln("NukeSpawned");
	level.nukeobj = Spawn( "script_origin", level.nukepos );
	level.nukeobj hide();

	level thread nukeSoundExplosion();
	level thread nukeSlowMo();
	level thread nukeEffects();
	level thread nukeVision();
	level thread nukeDeath();
	level thread nukeEarthquake();
}

nukeSoundExplosion()
{
	level.nukeobj PlaySound( "nuke_explosion" );
	level.nukeobj PlaySound( "nuke_wave" );
}

nukeEffects()
{
	foreach( player in level.players )
	{
		/*playerForward = anglestoforward( player.angles );
		playerForward = ( playerForward[0], playerForward[1], 0 );
		playerForward = VectorNormalize( playerForward );
	
		nukeDistance = 5000;*/
		/# nukeDistance = getDvarInt( "scr_nukeDistance" );	#/

		//nukeEnt = Spawn( "script_model", player.origin + ( playerForward * nukeDistance ) );
		nukeEnt = Spawn( "script_model", level.mapcenter );
		nukeEnt setModel( "tag_origin" );
		nukeEnt.angles = ( 0, (player.angles[1] + 180), 90 );

		/#
		if ( getDvarInt( "scr_nukeDebugPosition" ) )
		{
			lineTop = ( nukeEnt.origin[0], nukeEnt.origin[1], (nukeEnt.origin[2] + 500) );
			thread draw_line_for_time( nukeEnt.origin, lineTop, 1, 0, 0, 10 );
		}
		#/

		nukeEnt thread nukeEffect( player );
		//player.nuked = true;
	}
}

nukeEffect( player )
{
	player endon( "disconnect" );

	waitframe();
	PlayFXOnTagForClients( level._effect[ "nuke_flash" ], self, "tag_origin", player );
}

nukeSlowMo()
{
	//SetSlowMotion( <startTimescale>, <endTimescale>, <deltaTime> )
	SetSlowMotion( 1.0, 0.25, 0.75 );
	level waittill( "nuke_death" );
	SetSlowMotion( 0.25, 1, 3 );
}

nukeVision()
{
	wait 0.25;
	VisionSetNaked( "mpnuke", 3 );
	wait 1.5;

	//level waittill( "nuke_death" );

	VisionSetNaked( level.nukeVisionSet, 1 );
}

nukeDeath()
{
	level notify( "nuke_death" );

	//AmbientStop(1);

	foreach( player in level.players )
	{
		if(player.team == "allies")
		{
			if(player.inside == false)
			{
				if ( isAlive( player ) )
					player thread maps\mp\gametypes\_damage::finishPlayerDamageWrapper( level.nukeInfo.player, level.nukeInfo.player, 999999, 0, "MOD_EXPLOSIVE", "nuke_mp", player.origin, player.origin, "none", 0, 0 );
			}
		}
		else if(player.team == "axis" &&  isAlive( player ))
		player thread maps\mp\gametypes\_damage::finishPlayerDamageWrapper( level.nukeInfo.player, level.nukeInfo.player, 999999, 0, "MOD_EXPLOSIVE", "nuke_mp", player.origin, player.origin, "none", 0, 0 );
	}

}

nukeEarthquake()
{
	level waittill( "nuke_death" );

	// TODO: need to get a different position to call this on
	//wait 1.5;
	//earthquake( 0.6, 10, level.nukepos, 100000 );

	//foreach( player in level.players )
		//player PlayRumbleOnEntity( "damage_heavy" );
}

harrierstrike()
{
	foreach(player in level.players) player playLocalSound("missile_incoming");
	
	height = 1200;
	pathGoal = level.nukepos + (0,0,height);
	pathStart = level.nukepos + (0,10000,height);
	pathEnd = level.nukepos + (0,-10000,height);

	forward = vectorToAngles( pathGoal - pathStart );

	harrier = spawnHelicopter( randPlayer(), pathStart, forward, "harrier_mp" , "vehicle_av8b_harrier_jet_mp" );

	//harrier = spawnHelicopter( owner, pathStart, forward, "harrier_mp" , "vehicle_av8b_harrier_jet_opfor_mp" );

	harrier.speed = 175;
	harrier.accel = 45;
	//harrier.team = owner.team;
	//harrier.owner = owner;
	//harrier setCanDamage( true );
	//harrier.owner = owner;
	//harrier thread harrierDestroyed();
	harrier SetMaxPitchRoll( 0, 90 );
	harrier thread playHarrierFx();
	//harrier.missiles = 6;
	//harrier.pers["team"] = harrier.team;
	//harrier SetHoverParams( 50, 100, 50 );
	harrier setTurningAbility( 0.05 );
	harrier setYawSpeed(45,25,25,.5);
	//harrier.defendLoc = pathGoal;
	//harrier.lifeId = lifeId;

	harrier Vehicle_SetSpeed( harrier.speed, harrier.accel);
	harrier setVehGoalPos(pathGoal, 0);
	harrier waittill("goal");
	level thread spawnbomb(pathGoal, height);
	harrier Vehicle_SetSpeed( harrier.speed);
	harrier setVehGoalPos(pathEnd, 1);
	harrier waittill("goal");
	harrier delete();
	//iprintln("deleted harrier");
}

spawnbomb(pos, height)
{
	droptime = 1;
	bomb = spawn("script_model", pos);
	bomb setModel("projectile_cbu97_clusterbomb");
	bomb.angles = (90,0,0);
	bomb MoveZ(int("-" + height), droptime, 0.2, 0.1);
	wait droptime;
	level thread startnuke();
	bomb delete();
	//iprintln("deleted bomb");
}

playHarrierFx()
{
	self endon ( "death" );

	wait( 0.2 );
	playfxontag( level.fx_airstrike_contrail, self, "tag_right_wingtip" );	
	playfxontag( level.fx_airstrike_contrail, self, "tag_left_wingtip" );
	wait( 0.2 );
	playfxontag( level.harrier_afterburnerfx, self, "tag_engine_right" );
	playfxontag( level.harrier_afterburnerfx, self, "tag_engine_left" );
	wait( 0.2 );
	playfxontag( level.harrier_afterburnerfx, self, "tag_engine_right2" );
	playfxontag( level.harrier_afterburnerfx, self, "tag_engine_left2" );
	wait( 0.2 );
	playFXOnTag( level.chopper_fx["light"]["left"], self, "tag_light_L_wing" );
	wait ( 0.2 );
	playFXOnTag( level.chopper_fx["light"]["right"], self, "tag_light_R_wing" );
	wait ( 0.2 );
	playFXOnTag( level.chopper_fx["light"]["belly"], self, "tag_light_belly" );
	wait ( 0.2 );
	playFXOnTag( level.chopper_fx["light"]["tail"], self, "tag_light_tail" );
	
}
grenadecheck() {
	level endon("gameover");
    level endon("final_player_reached");
    level endon("all_grenades_used");
	self endon("death");
    for(;;) {
        self waittill ( "grenade_fire", grenade, weaponName );
        if ( weaponName == "semtex_mp" )
            grenade thread SplashGrenade();
    }
}

SplashGrenade()
{
	self endon("death");
    self thread explodetimer();
    self waittill_any ("noexpo", "missile_stuck");
    pushpos = self.origin;
	PhysicsExplosionSphere(pushpos, 100, 75, 3);
	PlayFX(level.pushfx, pushpos);
    thread pushaway(pushpos);
    self delete();
}

explodetimer()
{
	self endon("death");
    wait 1.82;
    self notify("noexpo");
}

pushaway(posorg)
{
    foreach(player in level.players)
    {
        if(Distance(posorg, player.origin) < 100)
        {
            pushamount = player DamageConeTrace(posorg);
            if(pushamount > 0)
            {
            angles = VectorToAngles((player.origin + (0,0,40)) - posorg);
            vec = anglestoforward(angles);
            //iprintln("Forward ^1 " + vec);
            //iprintln("^2" + (vec[0] * 10,vec[1] * 10,vec[2] * 10));
			if(player getstance() == "prone")
            player setvelocity(player GetVelocity() + (vec[0] * 300,vec[1] * 300,vec[2] * 400));
			else 
			player setvelocity(player GetVelocity() + (vec[0] * 300,vec[1] * 300,vec[2] * 300));
            //iprintln("Up ^1 " + AnglesToUp(angles));
            //iprintln("Right ^1 " + anglestoright(angles));
            //iprintln(angles);
            }
        }
    }
}

numgrenades() {
	level endon("gameover");
    level endon("final_player_reached");
    level endon("all_grenades_used");
	self endon("death");
	
	if(self getcurrentweapon() != "iw5_slashnburn_mp") {
		self takeallweapons();
		self setOffhandPrimaryClass("other");
		self givePerk("semtex_mp", true);
		self givePerk("specialty_fastoffhand", true);
		self takeWeapon("semtex_mp");
		self.nameicon = "hud_icon_mm";
		self detachall();
		self setmodel("playermodel_vistic_mike_myers");
		self setviewmodel("viewhandsl_bo2_deluca2");
		self GiveWeapon("iw5_slashnburn_mp");
		self setweaponammoclip("iw5_slashnburn_mp", 0);
		self setweaponammostock("iw5_slashnburn_mp", 0);
		self switchToWeapon("iw5_slashnburn_mp");
		self thread CrouchTimer();
	}

    if(!isdefined(self.slashernades)) 
    	self.slashernades = 0;
    
    self thread timeaddnade();
    self waitfornadesone();
    
    for(;;) {
        self waittill ( "grenade_fire", grenade, weaponName );
        if ( weaponName == "semtex_mp" ) {
            self.slashernades--;

            waitframe();

            if(self.slashernades > 0)
				self _GiveWeapon("semtex_mp");
			else
				self waitfornadesone();
        }
    }
}
waitfornadesone() {
	level endon("gameover");
    level endon("final_player_reached");
    level endon("all_grenades_used");
	self endon("death");

	self waittill("giveanade");
	self _GiveWeapon("semtex_mp");
}

timeaddnade() {
	level endon("gameover");
    level endon("final_player_reached");
    level endon("all_grenades_used");
	self endon("death");
	
	max_wait = 30;
	min_wait = 15;
	
	diff = max_wait - min_wait;
	final_wait = int(max_wait - (level.players.size / 18 * diff)); 
	
    for(;;) {
        while(self.slashernades == 3)
            wait 1;
        
        while(self.slashernades < 3) {
            wait final_wait;
            self.slashernades++;
            self notify("giveanade");
        }
        waitframe();
    }
}

/////////////////////////// UFO ////////////////////////////////////
UFOMode()
{
	//self enablelinkto();
	self thread MoveLeftButtonPressed();
	self thread MoveRightButtonPressed();
	self thread ForwardButtonPressed();
	self thread BackButtonPressed();

    self PlayerLinkTo(self.N);
	self setorigin(self.N.origin);
}

doUFOMode()
{
    self.N = spawn("script_origin", level.flyto + level.flytohigher - (0,0,150));

	self UFOMode();
	self.hasradar = true;
	self.radarmode = "fast_radar";

    wait .25;
    for(;;) {
        if(self.ForwardButtonPressed)
            self.N.origin=self.N.origin+(anglestoforward(self getPlayerAngles())[0] * 45, anglestoforward(self getPlayerAngles())[1] * 45, anglestoforward(self getPlayerAngles())[2] * 45);
		
		
        if(self.BackwardButtonPressed)
            self.N.origin=self.N.origin+(anglestoforward(self getPlayerAngles())[0] * -45, anglestoforward(self getPlayerAngles())[1] * -45, anglestoforward(self getPlayerAngles())[2] * -45);
		
		
        if(self.RightButtonPressed)
            self.N.origin=self.N.origin+(anglestoright(self getPlayerAngles())[0] * 45, anglestoright(self getPlayerAngles())[1] * 45, anglestoright(self getPlayerAngles())[2] * 45);
		
		
        if(self.LeftButtonPressed)
            self.N.origin=self.N.origin+(anglestoright(self getPlayerAngles())[0] * -45, anglestoright(self getPlayerAngles())[1] * -45, anglestoright(self getPlayerAngles())[2] * -45);
		wait 0.05;
    }
}

MoveLeftButtonPressed()
{
	self	notifyonplayercommand("+a", "+moveleft");
	self	notifyonplayercommand("-a", "-moveleft");

    self.LeftButtonPressed = 0;
    for(;;)
    {
        self waittill("+a");
        self.LeftButtonPressed = 1;
        self waittill("-a");
        self.LeftButtonPressed = 0;
    }
}

MoveRightButtonPressed()
{
	self	notifyonplayercommand("+d", "+moveright");
	self	notifyonplayercommand("-d", "-moveright");

    self.RightButtonPressed = 0;
    for(;;)
    {
        self waittill("+d");
        self.RightButtonPressed = 1;
        self waittill("-d");
        self.RightButtonPressed = 0;
    }
}

ForwardButtonPressed()
{
	self	notifyonplayercommand("+w", "+forward");
	self	notifyonplayercommand("-w", "-forward");
	self	notifyonplayercommand("+w", "+frag");
	self	notifyonplayercommand("-w", "-frag");

    self.ForwardButtonPressed = 0;
    for(;;)
    {
        self waittill("+w");
        self.ForwardButtonPressed = 1;
        self waittill("-w");
        self.ForwardButtonPressed = 0;
    }
}

BackButtonPressed()
{
	self	notifyonplayercommand("+s", "+back");
	self	notifyonplayercommand("-s", "-back");
	self	notifyonplayercommand("+s", "+smoke");
	self	notifyonplayercommand("-s", "-smoke");

    self.BackwardButtonPressed = 0;
    for(;;)
    {
        self waittill("+s");
        self.BackwardButtonPressed = 1;
        self waittill("-s");
        self.BackwardButtonPressed = 0;
    }
}
///////////////////////////////////////////////////////////////////







