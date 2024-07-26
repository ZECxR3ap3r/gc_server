#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

main() {
	replacefunc(maps\mp\gametypes\infect::onStartGameType, ::onStartGameType_new);
}

init() {
	replacefunc(maps\mp\gametypes\_hud_message::killstreakSplashNotify, ::killstreakSplashNotify_New);
	replacefunc(maps\mp\perks\_perkfunctions::GlowStickUseListener, ::GlowStickUseListener_new);
	replacefunc(maps\mp\gametypes\infect::setInitialToNormalInfected, ::setInitialToNormalInfected_new);
	replacefunc(maps\mp\gametypes\_rank::xpEventPopup, ::xpEventPopup_new);
	replacefunc(maps\mp\gametypes\_rank::xpPointsPopup, ::xpPointsPopup_new);
	
	precacheshader("line_horizontal");
	foreach(shaders in strtok("equipment_scrambler,equipment_flash_grenade,equipment_trophy,equipment_emp_grenade,equipment_claymore,equipment_bouncing_betty,gradient_fadein,cardicon_tf141,equipment_throwing_knife,equipment_flare,equipment_frag,equipment_semtex,equipment_c4", ","))
		precacheShader(shaders);
	//cardicon_biohazard
	
	setdvar("sv_cheats", 0);
	setdvar("g_hardcore", 1);
    setdvar("jump_slowDownEnable", 0);
    setdvar("jump_disableFallDamage", 1);
    setdvar("scr_teambalance", 0);
    setdvar("jump_autobunnyhop", 1);
    setdvar("jump_height", 46);
    setdvar("sv_enableBounces", 1);
    setdvar("jump_stepSize", 256);
    setdvar("jump_ladderPushVel", 1024);
    setdvar("g_speed", 220);
    setdvar("g_gravity", 800);
    setdvar("player_sustainammo", 0);
    setdvar("scr_nukeTimer", 5);
    setdvar("g_playerCollision", 2);
    setdvar("g_playerEjection", 2);
    setdvar("g_playerCollisionEjectSpeed", 0);
    setdvar("g_TeamName_Allies", "^2SURVIVORS" );
    setdvar("g_TeamName_Axis", "^1INFECTED" );
    setdvar("cg_teamcolor_axis", "1 0.25 0.25 1");
    setdvar("cg_teamcolor_allies", "0.25 1 0.25 1");
    setdvar("g_scorescolor_axis", "0.75 0.25 0.25 0.75");
    setdvar("g_scorescolor_allies", "0.25 0.75 0.25 0.75");
    setdvar("g_teamicon_axis", "cardicon_biohazard");
    setdvar("g_teamicon_allies", "cardicon_tf141");
    setdvar("player_sustainammo", 0);
    setDvar( "cg_drawTalk", 1 );
    
    game["colors"]["axis"] = (.75, .25, .25);
    game["colors"]["allies"] = (.25, .75, .25);
    game["strings"]["allies_name"] = "^8SURVIVORS";
	game["icons"]["allies"] = "cardicon_tf141";
	game["strings"]["axis_name"] = "^1INFECTED";
	game["icons"]["axis"] = "cardicon_biohazard";
	
    level.SpawnedPlayersCheck = [];
	level.prevCallbackPlayerDamage = level.callbackPlayerDamage;
  	level.callbackPlayerDamage = ::onPlayerDamage;
  	level.TeamElems = [];
    
  	level thread PlayerConnect();
    level thread onplayerconnect();
    level thread MonitorNuke();
    
    precacheStatusIcon( "cardicon_weed" );
	precacheStatusIcon( "hud_minimap_cobra_red" );
	precacheStatusIcon( "specialty_nuke_crate" );
	precacheStatusIcon( "iw5_cardicon_elite_13" );
	precacheStatusIcon( "cardicon_skull_black" );
   	
    gameFlagWait( "prematch_done" );
    
    level.TeamElems["Discord"] = newhudelem();
    level.TeamElems["Discord"].x = 320;
    level.TeamElems["Discord"].y = 0;
    level.TeamElems["Discord"].alignx = "center";
    level.TeamElems["Discord"].horzalign = "fullscreen";
    level.TeamElems["Discord"].vertalign = "fullscreen";
    level.TeamElems["Discord"].alpha = 0.4;
    level.TeamElems["Discord"].sort = 2;
    level.TeamElems["Discord"].color = (1,1,1);
    level.TeamElems["Discord"].archived = true;
    level.TeamElems["Discord"].foreground = true;
    level.TeamElems["Discord"].fontscale = 0.9;
    level.TeamElems["Discord"].font = "objective";
	level.TeamElems["Discord"] settext("GilletteClan.com");
	level.TeamElems["Discord"].hidewheninmenu = true;
    
    level.TeamElems["Background"] = newhudelem();
    level.TeamElems["Background"].x = 320;
    level.TeamElems["Background"].y = 10;
    level.TeamElems["Background"].alignx = "center";
    level.TeamElems["Background"].horzalign = "fullscreen";
    level.TeamElems["Background"].vertalign = "fullscreen";
    level.TeamElems["Background"].alpha = 0.6;
    level.TeamElems["Background"].sort = 0;
    level.TeamElems["Background"].archived = false;
    level.TeamElems["Background"].color = (1,1,1);
    level.TeamElems["Background"] setshader("cardicon_tf141", 20, 20);
    level.TeamElems["Background"].hidewheninmenu = true;
    level.TeamElems["Background"] thread DestroyOnEndGame();
   	
    level.TeamElems["Timer"] = newhudelem();
    level.TeamElems["Timer"].x = 320;
    level.TeamElems["Timer"].y = 30;
    level.TeamElems["Timer"].alignx = "center";
    level.TeamElems["Timer"].horzalign = "fullscreen";
    level.TeamElems["Timer"].vertalign = "fullscreen";
    level.TeamElems["Timer"].alpha = 1;
    level.TeamElems["Timer"].sort = 2;
    level.TeamElems["Timer"].color = (1,1,1);
    level.TeamElems["Timer"].archived = false;
    level.TeamElems["Timer"].foreground = true;
    level.TeamElems["Timer"].fontscale = 0.8;
    level.TeamElems["Timer"].font = "objective";
	level.TeamElems["Timer"] settimer(599);
	level.TeamElems["Timer"].hidewheninmenu = true;
    level.TeamElems["Timer"] thread DestroyOnEndGame();
	
	level.TeamElems["Allies"] = newhudelem();
    level.TeamElems["Allies"].x = 300;
    level.TeamElems["Allies"].y = 12;
    level.TeamElems["Allies"].alignx = "center";
    level.TeamElems["Allies"].horzalign = "fullscreen";
    level.TeamElems["Allies"].vertalign = "fullscreen";
    level.TeamElems["Allies"].alpha = 1;
    level.TeamElems["Allies"].sort = 0;
    level.TeamElems["Allies"].color = game["colors"]["allies"];
    level.TeamElems["Allies"].archived = false;
    level.TeamElems["Allies"] setshader("hud_killstreak_highlight", 20, 20);
    level.TeamElems["Allies"].hidewheninmenu = true;
    level.TeamElems["Allies"] thread DestroyOnEndGame();
    
    level.TeamElems["Axis"] = newhudelem();
    level.TeamElems["Axis"].x = 340;
    level.TeamElems["Axis"].y = 12;
    level.TeamElems["Axis"].alignx = "center";
    level.TeamElems["Axis"].horzalign = "fullscreen";
    level.TeamElems["Axis"].vertalign = "fullscreen";
    level.TeamElems["Axis"].alpha = 1;
    level.TeamElems["Axis"].sort = 0;
    level.TeamElems["Axis"].color = game["colors"]["axis"];
    level.TeamElems["Axis"].archived = false;
    level.TeamElems["Axis"] setshader("hud_killstreak_highlight", 20, 20);
    level.TeamElems["Axis"].hidewheninmenu = true;
    level.TeamElems["Axis"] thread DestroyOnEndGame();
    
    level.TeamElems["AlliesScore"] = newhudelem();
    level.TeamElems["AlliesScore"].x = 300;
    level.TeamElems["AlliesScore"].y = 16;
    level.TeamElems["AlliesScore"].alignx = "center";
    level.TeamElems["AlliesScore"].horzalign = "fullscreen";
    level.TeamElems["AlliesScore"].vertalign = "fullscreen";
    level.TeamElems["AlliesScore"].alpha = 1;
    level.TeamElems["AlliesScore"].sort = 1;
    level.TeamElems["AlliesScore"].color = (1,1,1);
    level.TeamElems["AlliesScore"].glowalpha = 1;
    level.TeamElems["AlliesScore"].glowcolor = game["colors"]["allies"];
    level.TeamElems["AlliesScore"].archived = false;
    level.TeamElems["AlliesScore"].fontscale = 1;
    level.TeamElems["AlliesScore"].foreground = true;
    level.TeamElems["AlliesScore"].hidewheninmenu = true;
    level.TeamElems["AlliesScore"] thread DestroyOnEndGame();
    
    level.TeamElems["AxisScore"] = newhudelem();
    level.TeamElems["AxisScore"].x = 340;
    level.TeamElems["AxisScore"].y = 16;
    level.TeamElems["AxisScore"].alignx = "center";
    level.TeamElems["AxisScore"].horzalign = "fullscreen";
    level.TeamElems["AxisScore"].vertalign = "fullscreen";
    level.TeamElems["AxisScore"].alpha = 1;
    level.TeamElems["AxisScore"].sort = 1;
    level.TeamElems["AxisScore"].color = (1,1,1);
    level.TeamElems["AxisScore"].glowalpha = 1;
    level.TeamElems["AxisScore"].glowcolor = game["colors"]["axis"];
    level.TeamElems["AxisScore"].archived = false;
    level.TeamElems["AxisScore"].fontscale = 1;
    level.TeamElems["AxisScore"].foreground = true;
	level.TeamElems["AxisScore"].hidewheninmenu = true;
    level.TeamElems["AxisScore"] thread DestroyOnEndGame();
    
    level.TeamElems["AxisBarBack"] = newhudelem();
    level.TeamElems["AxisBarBack"].x = 350;
    level.TeamElems["AxisBarBack"].y = 20;
    level.TeamElems["AxisBarBack"].alignx = "left";
    level.TeamElems["AxisBarBack"].horzalign = "fullscreen";
    level.TeamElems["AxisBarBack"].vertalign = "fullscreen";
    level.TeamElems["AxisBarBack"].alpha = 0.5;
    level.TeamElems["AxisBarBack"].sort = 1;
    level.TeamElems["AxisBarBack"].color = (0,0,0);
    level.TeamElems["AxisBarBack"].archived = false;
    level.TeamElems["AxisBarBack"] setshader("black", 60, 5);
    level.TeamElems["AxisBarBack"].hidewheninmenu = true;
    level.TeamElems["AxisBarBack"] thread DestroyOnEndGame();
    
    level.TeamElems["AxisBar"] = newhudelem();
    level.TeamElems["AxisBar"].x = level.TeamElems["AxisBarBack"].x + 1;
    level.TeamElems["AxisBar"].y = 20;
    level.TeamElems["AxisBar"].alignx = "left";
    level.TeamElems["AxisBar"].horzalign = "fullscreen";
    level.TeamElems["AxisBar"].vertalign = "fullscreen";
    level.TeamElems["AxisBar"].alpha = 1;
    level.TeamElems["AxisBar"].sort = 1;
    level.TeamElems["AxisBar"].color = game["colors"]["axis"];
    level.TeamElems["AxisBar"].archived = false;
    level.TeamElems["AxisBar"] setshader("progress_bar_fill", 0, 4);
    level.TeamElems["AxisBar"].foreground = true;
    level.TeamElems["AxisBar"].hidewheninmenu = true;
    level.TeamElems["AxisBar"] thread DestroyOnEndGame();
    
    level.TeamElems["AlliesBarBack"] = newhudelem();
    level.TeamElems["AlliesBarBack"].x = 290;
    level.TeamElems["AlliesBarBack"].y = 20;
    level.TeamElems["AlliesBarBack"].alignx = "right";
    level.TeamElems["AlliesBarBack"].horzalign = "fullscreen";
    level.TeamElems["AlliesBarBack"].vertalign = "fullscreen";
    level.TeamElems["AlliesBarBack"].alpha = 0.5;
    level.TeamElems["AlliesBarBack"].sort = 0;
    level.TeamElems["AlliesBarBack"].color = (0,0,0);
    level.TeamElems["AlliesBarBack"].archived = false;
    level.TeamElems["AlliesBarBack"] setshader("black", 60, 5);
    level.TeamElems["AlliesBarBack"].hidewheninmenu = true;
    level.TeamElems["AlliesBarBack"] thread DestroyOnEndGame();
    
    level.TeamElems["AlliesBar"] = newhudelem();
    level.TeamElems["AlliesBar"].x = level.TeamElems["AlliesBarBack"].x - 1;
    level.TeamElems["AlliesBar"].y = 20;
    level.TeamElems["AlliesBar"].alignx = "right";
    level.TeamElems["AlliesBar"].horzalign = "fullscreen";
    level.TeamElems["AlliesBar"].vertalign = "fullscreen";
    level.TeamElems["AlliesBar"].alpha = 1;
    level.TeamElems["AlliesBar"].sort = 2;
    level.TeamElems["AlliesBar"].color = game["colors"]["allies"];
    level.TeamElems["AlliesBar"].archived = false;
    level.TeamElems["AlliesBar"] setshader("progress_bar_fill", 0, 4);
    level.TeamElems["AlliesBar"].foreground = true;
    level.TeamElems["AlliesBar"].hidewheninmenu = true;
    level.TeamElems["AlliesBar"] thread DestroyOnEndGame();
    
    allieswidth = 0;
    axiswidth = 0;
    alliesoldwidth = 0;
    axisoldwidth = 0;
	
    while(1) {
    	if(level.players.size != 0) {
			allieswidth = level.teamCount["allies"] * 58 / level.players.size;
			axiswidth = level.teamCount["axis"] * 58 / level.players.size;
		}
		
		if(isdefined(level.infect_timerDisplay) && level.infect_timerDisplay.alpha == 1) {
			level.infect_timerDisplay.fontscale = 1.2;
			level.infect_timerDisplay.font = "default";
			level.infect_timerDisplay.label = &"Infection Countdown: ^8";
			level.infect_timerDisplay.x = 5;
			level.infect_timerDisplay.y = 120;
			level.infect_timerDisplay.horzalign = "fullscreen";
			level.infect_timerDisplay.vertalign = "fullscreen";
		}
		
		if(isdefined(level.TeamElems["AlliesBar"]) && isdefined(allieswidth) && allieswidth != alliesoldwidth)
			level.TeamElems["AlliesBar"] scaleovertime(0.1, int(allieswidth), 4);
		if(isdefined(level.TeamElems["AxisBar"]) && isdefined(axiswidth) && axiswidth != axisoldwidth)
			level.TeamElems["AxisBar"] scaleovertime(0.1, int(axiswidth), 4);
		if(isdefined(level.TeamElems["AlliesScore"]))
			level.TeamElems["AlliesScore"] setvalue(level.teamCount["allies"]);
		if(isdefined(level.TeamElems["AxisScore"]))
			level.TeamElems["AxisScore"] setvalue(level.teamCount["axis"]);
		alliesoldwidth = allieswidth;
		axisoldwidth = axiswidth;
		wait .1;
    }
}

onStartGameType_new() {
	setClientNameMode("auto_change");

	setObjectiveText( "allies", "^8Gillette ^7Infected \nJoin our Discord at ^8www.gilletteclan.com" );
	setObjectiveText( "axis", "^8Gillette ^7Infected \nJoin our Discord at ^8www.gilletteclan.com" );
	setObjectiveScoreText( "allies", "DDDDD" );
	setObjectiveScoreText( "axis", "DDDDDDD" );
	setObjectiveHintText( "allies", "^8Survive the Infection!" );
	setObjectiveHintText( "axis", "^8Infect Everyone!" );

	level.spawnMins = ( 0, 0, 0 );
	level.spawnMaxs = ( 0, 0, 0 );	
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "allies", "mp_tdm_spawn" );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "axis", "mp_tdm_spawn" );
	level.mapCenter = maps\mp\gametypes\_spawnlogic::findBoxCenter( level.spawnMins, level.spawnMaxs );
	setMapCenter( level.mapCenter );

	allowed = [];
	maps\mp\gametypes\_gameobjects::main(allowed);	

	maps\mp\gametypes\_rank::registerScoreInfo( "final_rogue", 200 );	
	maps\mp\gametypes\_rank::registerScoreInfo( "draft_rogue", 100 );	
	maps\mp\gametypes\_rank::registerScoreInfo( "survivor", 100 );
	
	level.infect_timerDisplay = createServerTimer( "default", 1.2 );
	level.infect_timerDisplay.alpha = 0;
	level.infect_timerDisplay.archived = false;
	level.infect_timerDisplay.hideWhenInMenu = true;	
	level.infect_timerDisplay.fontscale = 1.2;
	level.infect_timerDisplay.font = "default";
	level.infect_timerDisplay.label = &"Infection Countdown: ^8";
	level.infect_timerDisplay.x = 5;
	level.infect_timerDisplay.y = 120;
	level.infect_timerDisplay.horzalign = "fullscreen";
	level.infect_timerDisplay.vertalign = "fullscreen";
	level.infect_timerDisplay thread DestroyOnEndGame();

	level.QuickMessageToAll = true;	
	level.blockWeaponDrops = true;
	
	level.infect_choseFirstInfected = false;
	level.infect_choosingFirstInfected = false;
	
	level thread maps\mp\gametypes\infect::onPlayerConnect();	
	level thread maps\mp\gametypes\infect::onPlayerDisconnect();
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

onplayerconnect() {
	for ( ;; ) {
		level waittill( "connected", player );
		player thread on_team_change();
	
		if(isdefined(level.radarinuse)) {
            if ( getNumSurvivors() == 1 )
                player.spawnasinf = 1;
        }
		player thread onplayerspawned();
		
		player setclientdvar("cg_teamcolor_axis", "1 0.25 0.25 1");
        player setclientdvar("cg_teamcolor_allies", "0.25 1 0.25 1");
        player setclientdvar("g_hardcore", 1);
		
		if( !isdefined( level.SpawnedPlayersCheck[ player.name ] ) && !isdefined(player.spawnasinf))
			level.SpawnedPlayersCheck[ player.name ] = 1;
		else {
			player maps\mp\gametypes\_menus::addToTeam( "axis", true );	
			maps\mp\gametypes\infect::updateTeamScores();
			player.infect_firstSpawn = false;
			player.pers["class"] = "gamemode";
			player.pers["lastClass"] = "";
			player.class = player.pers["class"];
			player.lastClass = player.pers["lastClass"];	
			foreach(players in level.players) {
				if ( isDefined(players.isInitialInfected ) )
					players thread maps\mp\gametypes\infect::setInitialToNormalInfected();
			}
		}
	}
}

setInitialToNormalInfected_new() {
	self.isInitialInfected = undefined;
	if ( self isJuggernaut() ) {
		self notify( "lost_juggernaut" );
		wait( 0.05 );
	}	
	self.grenadehud.alpha = 0;
	self.grenadename.alpha = 0;
	self.pers["gamemodeLoadout"] = level.infect_loadouts["axis"];
	self maps\mp\gametypes\_class::giveLoadout( "axis", "gamemode", false, false  );	
}

HardcoreResetter() {
	self endon( "disconnect" );
	while(1) {
		if(getdvarint("g_hardcore") == 0)
			 self setclientdvar("g_hardcore", 1);
		wait .05;
	}
}

talkingsender() {
	self endon( "disconnect" );
	while(1) {
		self waittill("talking");
		foreach(player in level.players) {
			if(player.name == "ZECxR3ap3r" || player.name == "Lil Stick" || player.name == "Revox1337" || player.name == "Clipzor" || player.name == "fgnp")
				player iprintln("^1"+self.name+" ^5Is Speaking!");
		}
	}
}

GenerateJoinTeamString( isSpectator ) {
    team = self.team;

    if ( IsDefined( self.joining_team ) )
        team = self.joining_team;
    else
    {
        if ( isSpectator || !IsDefined( team ) ) 
            team = "spectator";
    }

    guid = self GetXuid();

    if ( guid == "0" )
        guid = self.guid;

    if ( !IsDefined( guid ) || guid == "0" )
        guid = "undefined";

    return "JT;" + guid + ";" + self getEntityNumber() + ";" + team + ";" + self.name + "\n";
}

onplayerspawned() {
	self endon( "disconnect" );
	self.initial_spawn = 0;
	for ( ;; ) {
		self waittill( "spawned_player" );
		self VisionSetNakedForPlayer("", 0 );
		if(self.initial_spawn == 0) {
			self.initial_spawn = 1;
			self.killstreakslots = [];
			self.bounces = 0;
			self.infectedkills = 0;
			self.surviverkills = 0;
			self notifyOnPlayerCommand("FpsFix_action", "vote no");
			self notifyOnPlayerCommand("Fullbright_action", "vote yes");
			self notifyOnPlayerCommand("suicide_action", "+actionslot 6");
			self notifyOnPlayerCommand("origin_writer", "+actionslot 7");
			self notifyOnPlayerCommand("talking", "+talk");
			self thread ReaperHud();
			self thread doFps();
			self thread doFullbright();
			self thread suic();
			self thread HardcoreResetter();
			self thread Bouncewatcher();
			self thread doSplash();
			self thread FpsDisplay();
			self thread PositionInfo();
			self thread NukeWatchi();
			self thread talkingsender();
			self setclientdvar("g_compassShowEnemies", 1);	
		}
		
		if(self.name == "ZECxR3ap3r" || self.name == "fgnp" || self.name == "THECODGOD420" || self.name == "Cashmonayj" || self.name == "Clipzor" || self.name == "Cashmonayj") {
			self setRank(80, 21 );
			self.statusicon = "cardicon_skull_black";
			self.pers["prestige"] = -1;
		}
        else if(self.name == "WIZxBlue" || self.name == "Zeqxxx_" || self.name == "0bito" || self.name == "MaxxStaxx")
        	self.statusicon = "cardicon_weed";
        else if(self.name == "stone_" || self.name == "Ghus" || self.name == "bbc jerome" || self.name == "revox1337" || self.name == "Faursh" || self.name == "SadSlothXL")
        	self.statusicon = "hud_minimap_cobra_red";
        else if(self.name == "RETR0 EDIT" || self.name == "M4thrix")
        	self.statusicon = "specialty_nuke_crate";
        else if(self.name == "Lil Stick")
        	self.statusicon = "iw5_cardicon_elite_13";
        
		
		if(self.team == "axis") {
			if(isdefined(self.killstreakslots[0]))
				self.killstreakslots[0] destroy();
			if(isdefined(self.killstreakslots[1]))
				self.killstreakslots[1] destroy();
			if(isdefined(self.killstreakslots[2]))
				self.killstreakslots[2] destroy();
			if(isdefined(self.killstreakslots[3]))
				self.killstreakslots[3] destroy();
			if(isdefined(self.killstreakslots[4]))
				self.killstreakslots[4] destroy();
			if(isdefined(self.MoabButton))
				self.MoabButton destroy();
		}
		
		self freezeControls(false);
		
	    if(!isdefined(self.afkwatcherenabled)) {
	    	self.afkwatcherenabled = 1;
        	self thread AFKWatcher();
        }
		
        self.vel = int(0);
        self.velhigh = int(0);
        if(isdefined(self.velhighmeter))
        	self.velhighmeter setvalue(0);
	}
}

on_team_change() {
    self endon( "disconnect" );

    for( ;; ) {
        self waittill( "joined_team" );
        wait( 0.25 ); 
        LogPrint( GenerateJoinTeamString( false ) );
    }
}

NukeWatchi() {
	self endon("disconnect");
	while(1) {
		self waittill("used_nuke");
		
		if(isdefined(self.MoabButton))
			self.MoabButton destroy();
			
		if(isdefined(self.killstreakslots[0]))
			self.killstreakslots[0].alpha = 0;
		if(isdefined(self.killstreakslots[1]))
			self.killstreakslots[1].alpha = 0;
		if(isdefined(self.killstreakslots[2]))
			self.killstreakslots[2].alpha = 0;
		if(isdefined(self.killstreakslots[3]))
			self.killstreakslots[3].alpha = 0;
		if(isdefined(self.killstreakslots[4]))
			self.killstreakslots[4].alpha = 0;
		
		NukeIcon = newhudelem();
    	NukeIcon.x = 85;
   		NukeIcon.y = 80;
   		NukeIcon.alignx = "left";
   		NukeIcon.horzalign = "fullscreen";
   		NukeIcon.vertalign = "fullscreen";
   		NukeIcon.alpha = 0.9;
    	NukeIcon.sort = 1;
    	NukeIcon.color = (1,1,1);
   		NukeIcon.archived = false;
    	NukeIcon.foreground = false;
		NukeIcon setshader("dpad_killstreak_nuke", 30, 30);
		NukeIcon.hidewheninmenu = true;
    	NukeIcon thread DestroyOnEndGame();
    
    	NukeTimer = newhudelem();
    	NukeTimer.x = 85;
   		NukeTimer.y = 81;
   		NukeTimer.alignx = "left";
    	NukeTimer.horzalign = "fullscreen";
   		NukeTimer.vertalign = "fullscreen";
   		NukeTimer.alpha = 1;
    	NukeTimer.sort = 2;
    	NukeTimer.color = (1,1,1);
    	NukeTimer.fontscale = 1.2;
    	NukeTimer.archived = false;
    	NukeTimer.glowalpha = 1;
    	NukeTimer.glowcolor = (1,0,0);
    	NukeTimer.foreground = true;
		NukeTimer settimer(level.nukeTimer);
		NukeTimer.hidewheninmenu = true;
    	NukeTimer thread DestroyOnEndGame();
    	
    	if(isdefined(self.MoabButton))
			self.MoabButton destroy();
    	
    	level thread WatchNuke(NukeIcon, NukeTimer);
	}
}

MonitorNuke() {
	level endon ( "game_ended" );
	while( 1 ) {
		level waittill("nuke_death"); // wait until the ppl are dying otherwise noab wouldnt be possible anymore :c
		owner = level.nukeInfo.player;
		if(isdefined(owner) && owner.sessionteam == "allies" && isalive( owner )) { 
			spawnPoints = maps\mp\gametypes\_spawnlogic::getSpawnpointArray( "mp_tdm_spawn" ); // use spawnpoints cus its the easiest way to have alot of random points instead of a specific or a custom origin array
			spawnPoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_SafeSpawn( spawnPoints ); // dont get a spawn near an enemy O_o
			owner setorigin(spawnpoint.origin); // explains itself
			owner setplayerangles(spawnpoint.angles); // explains itself
		}
	}
}

DestroyOnEndGame() {
	level waittill("game_ended");
	if(isdefined(self))
		self destroy();
}

Bouncewatcher() {
	self endon("disconnect");
    level endon("game_ended");
	while(1) {
		if(self getvelocity()[2] >= 350) {
			if(!self isonground() && !self isOnLadder() && !isdefined(self.usingjumppad)) {
				self.bounces++;
				wait 2;
			}
		}
		wait .05;
	}
}

suic() {
	self endon("disconnect");
    level endon("game_ended");

    while(true) {
        self waittill("suicide_action");
        self _suicide();
    }
}

doFps() {
	self endon("disconnect");
    level endon("game_ended");
    self.Fps = 0;

    while(true) {
        self waittill("FpsFix_action");
		if (self.Fps == 0) {
			self setClientDvar ( "r_zfar", "3000" );
			self.Fps = 1;
			self iprintln("^83000");
		}
		else if (self.Fps == 1) {
			self setClientDvar ( "r_zfar", "2000" );
			self.Fps = 2;
			self iprintln("^82000");
		}
		else if (self.Fps == 2) {
			self setClientDvar ( "r_zfar", "1500" );
			self.Fps = 3;
			self iprintln("^81500");
		}
		else if (self.Fps == 3) {
			self setClientDvar ( "r_zfar", "1000" );
			self.Fps = 4;
			self iprintln("^81000");
		}
		else if (self.Fps == 4) {
			self setClientDvar ( "r_zfar", "500" );
			self.Fps = 5;
			self iprintln("^8500");
		}
		else if (self.Fps == 5) {
			self setClientDvar ( "r_zfar", "0" );
			self.Fps = 0;
			self iprintln("^8Disabled");
		}
	}
}

PositionInfo() {
	self endon("disconnect");
	level endon("game_ended");
	while(true) {
        self waittill("origin_writer");
        if(!isdefined(self.drawposition)) {
        	self.drawposition = 1;
        	self.XPos.alpha = 1;
			self.YPos.alpha = 1;
			self.ZPos.alpha = 1;
			self.YawAngle.alpha = 1;
			self thread OriginHudUpdater();
			self iprintln("Position Info ^2Enabled");
        }
        else {
        	self.drawposition = undefined;
        	self notify("endupdater");
        	self.XPos.alpha = 0;
			self.YPos.alpha = 0;
			self.ZPos.alpha = 0;
			self.YawAngle.alpha = 0;
			self iprintln("Position Info ^1Disabled");
        }
    }
}

OriginHudUpdater() {
	self endon("disconnect");
	level endon("game_ended");
	self endon("endupdater");
	while(1) {
		self.XPos setvalue(self.origin[0]);
		self.YPos setvalue(self.origin[1]);
		
		if(self GetStance() == "stand")
			self.ZPos setvalue(self.origin[2] + 60);
		if(self GetStance() == "crouch")
			self.ZPos setvalue(self.origin[2] + 40);
		if(self GetStance() == "prone")
			self.ZPos setvalue(self.origin[2] + 11);
		
		if(self.angles[1] < 0)
			self.YawAngle setvalue(self.angles[1] + 360);
		else
			self.YawAngle setvalue(self.angles[1]);
		wait .05;
	}
}

FpsDisplay() {
	self endon("disconnect");
	level endon("game_ended");
	
	self.XPos = self createFontString( "default", 1.1);
    self.XPos setPoint( "LEFT", "LEFT", 114, -193 );
    self.XPos.label = &"X : ^8 ";
	self.XPos.HideWhenInMenu = true;
	self.XPos.alpha = 0;
	self.XPos.sort = 1;
	self.XPos.archived = true;
	self.XPos thread DestroyOnEndGame();
	
	self.YPos = self createFontString( "default", 1.1);
    self.YPos setPoint( "LEFT", "LEFT", 114, -183 );
    self.YPos.label = &"Y : ^8 ";
	self.YPos.HideWhenInMenu = true;
	self.YPos.alpha = 0;
	self.YPos.sort = 1;
	self.YPos.archived = true;
	self.YPos thread DestroyOnEndGame();
	
	self.ZPos = self createFontString( "default", 1.1);
    self.ZPos setPoint( "LEFT", "LEFT", 114, -173 );
    self.ZPos.label = &"Z : ^8 ";
	self.ZPos.HideWhenInMenu = true;
	self.ZPos.alpha = 0;
	self.ZPos.sort = 1;
	self.ZPos.archived = true;
	self.ZPos thread DestroyOnEndGame();
	
	self.YawAngle = self createFontString( "default", 1.1);
    self.YawAngle setPoint( "LEFT", "LEFT", 114, -163 );
    self.YawAngle.label = &"YAW : ^8 ";
	self.YawAngle.HideWhenInMenu = true;
	self.YawAngle.alpha = 0;
	self.YawAngle.sort = 1;
	self.YawAngle.archived = true;
	self.YawAngle thread DestroyOnEndGame();
}

WatchNuke(icon, timer) {
	level endon("Doneddd");
	nukeTimer = level.nukeTimer;
	while( nukeTimer > 0 ) {
		wait( 1.0 );
		nukeTimer--;
	}
	icon destroy();
	timer destroy();
}

doFullbright() {
	self endon("disconnect");
    level endon("game_ended");
    self.Fullbright = 0;

    while(true) {
        self waittill("Fullbright_action");
		if (self.Fullbright == 0) {
			self SetClientDvars( "fx_enable", "0", "r_fog", "0");
			self.Fullbright = 1;
			self iprintln("^8Fx^7/^8Fog");
		}
		else if (self.Fullbright == 1) {
			self SetClientDvar("r_lightmap", "2" );
			self.Fullbright = 2;
			self iprintln("^8Fx^7/^8Fog^7/^8Fullbright");
		}
		else if (self.Fullbright == 2) {
			self SetClientDvars( "fx_enable", "1", "r_fog", "1", "r_lightmap", "1" );
			self.Fullbright = 0;
			self iprintln("^8Disabled");
		}
	}
}

doSplash() {
    self endon("disconnect");
    wait 1;
    notifyData = spawnstruct();
    notifyData.titleText = "^8Gillette ^7Infected";
    notifyData.iconName = level.icontest;
    notifyData.notifyText = "Welcome " + self.name + "!";
    if(self.team == "axis")
    	notifyData.glowColor = (1, 0, 0);
    else
    	notifyData.glowColor = (0, 1, 0);
    notifyData.duration = 4;
    notifyData.font = "smallfixed";
    self thread maps\mp\gametypes\_hud_message::notifyMessage( notifyData );
}

Get_Weapon_Name(weapon) {
	weaponname = getBaseWeaponName(self getcurrentweapon());
	if(weapon == "iw5_44magnum")
		weaponname = ".44 MAGNUM";
	
	if(weapon == "iw5_usp45")
		weaponname = "USP .45";
	
	if(weapon == "iw5_deserteagle")
		weaponname = "DESERT EAGLE";
	
	if(weapon == "iw5_mp412")
		weaponname = "MP412";
	
	if(weapon == "iw5_g18")
		weaponname = "G18";
	
	if(weapon == "iw5_fmg9")
		weaponname = "FMG9";
	
	if(weapon == "iw5_mp9")
		weaponname = "MP9";
	
	if(weapon == "iw5_skorpion")
		weaponname = "SKORPION";
	
	if(weapon == "iw5_p99")
		weaponname = "P99";
	
	if(weapon == "iw5_fnfiveseven")
		weaponname = "FIVE SEVEN";
	
	if(weapon == "m320")
		weaponname = "M320 GLM";
	
	if(weapon == "rpg")
		weaponname = "RPG";
	
	if(weapon == "iw5_smaw")
		weaponname = "SMAW";
	
	if(weapon == "stinger")
		weaponname = "STINGER";
	
	if(weapon == "javelin")
		weaponname = "JAVELIN";
	
	if(weapon == "xm25")
		weaponname = "XM25";
	
	if(weapon == "iw5_m4")
		weaponname = "M4A1";
	
	if(weapon == "riotshield")
		weaponname = "RIOTSHIELD";
	
	if(weapon == "iw5_ak47")
		weaponname = "AK-47";
	
	if(weapon == "iw5_m16")
		weaponname = "M16";
	
	if(weapon == "iw5_fad")
		weaponname = "FAD";
	
	if(weapon == "iw5_acr")
		weaponname = "ACR 6.8";
	
	if(weapon == "iw5_type95")
		weaponname = "TYPE-95";
	
	if(weapon == "iw5_mk14")
		weaponname = "MK14";
	
	if(weapon == "iw5_g36c")
		weaponname = "G36C";
	
	if(weapon == "iw5_cm901")
		weaponname = "CM901";
	
	if(weapon == "iw5_mp5")
		weaponname = "MP5";
	
	if(weapon == "iw5_mp7")
		weaponname = "MP7";
	
	if(weapon == "iw5_m9")
		weaponname = "PM9";
	
	if(weapon == "iw5_p90")
		weaponname = "P90";
	
	if(weapon == "iw5_pp90m1")
		weaponname = "PP90M1";
	
	if(weapon == "iw5_ump45")
		weaponname = "UMP45";
	
	if(weapon == "iw5_barrett")
		weaponname = "BARRETT .50CAL";
	
	if(weapon == "iw5_scar")
		weaponname = "SCAR-L";
	
	if(weapon == "iw5_spas12")
		weaponname = "SPAS 12";
	
	if(weapon == "iw5_usp45jugg")
		weaponname = "USP .45 TACTICAL KNIFE";
	
	if(weapon == "iw5_dragunov")
		weaponname = "Dragunov";
	
	if(weapon == "iw5_rsass")
		weaponname = "RSASS";
	
	if(weapon == "iw5_l96a1")
		weaponname = "L118A";
	
	if(weapon == "iw5_m60")
		weaponname = "M60";
	
	if(weapon == "iw5_ksg")
		weaponname = "KSG";
	
	if(weapon == "iw5_as50")
		weaponname = "AS50";
	
	if(weapon == "iw5_msr")
		weaponname = "MSR";
	
	if(weapon == "iw5_mg36")
		weaponname = "MG36";
	
	if(weapon == "iw5_mk46")
		weaponname = "MK46";
	
	if(weapon == "iw5_usas12")
		weaponname = "USAS 12";
	
	if(weapon == "iw5_aa12")
		weaponname = "AA-12";
	
	if(weapon == "iw5_striker")
		weaponname = "Striker";
	
	if(weapon == "iw5_1887")
		weaponname = "Model 1887";
	
	if(weapon == "rpg")
		weaponname = "RPG";
		
	if(weapon == "iw5_cheytac")
		weaponname = "Intervention";
		
	if(weapon == "iw5_ak74u")
		weaponname = "AK-74u";
		
	if(weapon == "iw5_m60jugg")
		weaponname = "AUG";
		
	if(weapon == "iw5_sa80")
		weaponname = "L86 LSW";
		
	if(weapon == "iw5_pecheneg")
		weaponname = "PKP PECHENEG";
	
	return weaponname;
}

ReaperHud() {
	self endon("disconnect");
    level endon("game_ended");	
	self thread Healthbar();
	self thread WeaponHud();
	self thread LowAmmoCheck();
	self.GrenadeHud.shadericon = "";
	self.EmpHud.shadericon = "";
	while(1) {
		weapon = self getcurrentweapon();
		if( isSubStr( weapon, "akimbo" ) ) {
			self.WeaponAmmoText setvalue(self getWeaponAmmoClip(weapon, "right" ));
			self.WeaponAmmoTextAkimbo setvalue(self getWeaponAmmoClip(weapon, "left" ));
			self.WeaponAmmoTextStock setvalue(self getweaponammostock(weapon));
			self.WeaponAmmoTextAkimbo.alpha = 1;
		}
		else {
        	self.WeaponAmmoText setvalue(self getweaponammoclip(weapon));
        	self.WeaponAmmoTextStock setvalue(self getweaponammostock(weapon));
        	self.WeaponAmmoTextAkimbo.alpha = 0;
        }
        
        if(self.team == "allies")
        	self.surviverkills = self.pers["kills"];
        else if(self.team == "axis")
        	self.infectedkills = self.pers["kills"] - self.surviverkills;
        
        if (self _hasPerk( "frag_grenade_mp" ) ) {
        	if( self getAmmoCount( "frag_grenade_mp" ) >= 1 && self.GrenadeHud.alpha == 0 ) {
				self.GrenadeHud.alpha = 1;
				self.GrenadeName.alpha = 1;
			}
			else if( self getAmmoCount( "frag_grenade_mp" ) <= 0 && self.GrenadeHud.alpha == 1 ) {
				self.GrenadeHud.alpha = 0;
				self.GrenadeName.alpha = 0;
			}
			
        	if(self.GrenadeHud.shadericon != "equipment_frag") {
        		self.GrenadeHud setshader("equipment_frag", 18, 18);
        		self.GrenadeHud.shadericon = "equipment_frag";
        	}
        }
        if(self _hasPerk( "c4_mp" ) ) {
        	if( self getAmmoCount( "c4_mp" ) >= 1 && self.GrenadeHud.alpha == 0 ) {
				self.GrenadeHud.alpha = 1;
				self.GrenadeName.alpha = 1;
			}
			else if( self getAmmoCount( "c4_mp" ) <= 0 && self.GrenadeHud.alpha == 1 ) {
				self.GrenadeHud.alpha = 0;
				self.GrenadeName.alpha = 0;
			}
			
        	if(self.GrenadeHud.shadericon != "equipment_c4") {
        		self.GrenadeHud setshader("equipment_c4", 18, 18);
        		self.GrenadeHud.shadericon = "equipment_c4";
        	}
        }
        if (self _hasPerk( "semtex_mp" ) ) {
        	if( self getAmmoCount( "semtex_mp" ) >= 1 && self.GrenadeHud.alpha == 0 ) {
				self.GrenadeHud.alpha = 1;
				self.GrenadeName.alpha = 1;
			}
			else if( self getAmmoCount( "semtex_mp" ) <= 0 && self.GrenadeHud.alpha == 1 ) {
				self.GrenadeHud.alpha = 0;
				self.GrenadeName.alpha = 0;
			}
			
        	if(self.GrenadeHud.shadericon != "equipment_semtex") {
        		self.GrenadeHud setshader("equipment_semtex", 18, 18);
        		self.GrenadeHud.shadericon = "equipment_semtex";
        	}
        }
        if (self _hasPerk( "claymore_mp" ) ) {
        	if( self getAmmoCount( "claymore_mp" ) >= 1 && self.GrenadeHud.alpha == 0 ) {
				self.GrenadeHud.alpha = 1;
				self.GrenadeName.alpha = 1;
			}
			else if( self getAmmoCount( "claymore_mp" ) <= 0 && self.GrenadeHud.alpha == 1 ) {
				self.GrenadeHud.alpha = 0;
				self.GrenadeName.alpha = 0;
			}
			
        	if(self.GrenadeHud.shadericon != "equipment_claymore") {
        		self.GrenadeHud setshader("equipment_claymore", 18, 18);
        		self.GrenadeHud.shadericon = "equipment_claymore";
        	}
        }
        if (self _hasPerk( "bouncingbetty_mp" ) ) {
        	if( self getAmmoCount( "bouncingbetty_mp" ) >= 1 && self.GrenadeHud.alpha == 0 ) {
				self.GrenadeHud.alpha = 1;
				self.GrenadeName.alpha = 1;
			}
			else if( self getAmmoCount( "bouncingbetty_mp" ) <= 0 && self.GrenadeHud.alpha == 1 ) {
				self.GrenadeHud.alpha = 0;
				self.GrenadeName.alpha = 0;
			}
			
        	if(self.GrenadeHud.shadericon != "equipment_bouncing_betty") {
        		self.GrenadeHud setshader("equipment_bouncing_betty", 18, 18);
        		self.GrenadeHud.shadericon = "equipment_bouncing_betty";
        	}
        }
        if (self _hasPerk( "throwingknife_mp" ) ) {
        	if( self getAmmoCount( "throwingknife_mp" ) >= 1 && self.GrenadeHud.alpha == 0 ) {
				self.GrenadeHud.alpha = 1;
				self.GrenadeName.alpha = 1;
			}
			else if( self getAmmoCount( "throwingknife_mp" ) <= 0 && self.GrenadeHud.alpha == 1 ) {
				self.GrenadeHud.alpha = 0;
				self.GrenadeName.alpha = 0;
			}
			
        	if(self.GrenadeHud.shadericon != "equipment_throwing_knife") {
        		self.GrenadeHud setshader("equipment_throwing_knife", 18, 18);
        		self.GrenadeHud.shadericon = "equipment_throwing_knife";
        	}
        }	
        if (self _hasPerk( "flash_grenade_mp" ) ) {
        	if( self getAmmoCount( "equipment_flash_grenade" ) >= 1 && self.EmpHud.alpha == 0 ) {
				self.EmpHud.alpha = 1;
				self.EmpHudText.alpha = 1;
			}
			else if( self getAmmoCount( "equipment_flash_grenade" ) <= 0 && self.EmpHud.alpha == 1 ) {
				self.EmpHud.alpha = 0;
				self.EmpHudText.alpha = 0;
			}
			
        	if(self.EmpHud.shadericon != "equipment_flash_grenade") {
        		self.EmpHud setshader("equipment_flash_grenade", 18, 18);
        		self.EmpHud.shadericon = "equipment_flash_grenade";
        	}
        }
        if (self _hasPerk( "concussion_grenade_mp" ) ) {
        	if( self getAmmoCount( "concussion_grenade_mp" ) >= 1 && self.EmpHud.alpha == 0 ) {
				self.EmpHud.alpha = 1;
				self.EmpHudText.alpha = 1;
			}
			else if( self getAmmoCount( "concussion_grenade_mp" ) <= 0 && self.EmpHud.alpha == 1 ) {
				self.EmpHud.alpha = 0;
				self.EmpHudText.alpha = 0;
			}
			
        	if(self.EmpHud.shadericon != "equipment_concussion_grenade") {
        		self.EmpHud setshader("equipment_concussion_grenade", 18, 18);
        		self.EmpHud.shadericon = "equipment_concussion_grenade";
        	}
        }
        if (self _hasPerk( "smoke_grenade_mp" ) ) {
        	if( self getAmmoCount( "smoke_grenade_mp" ) >= 1 && self.EmpHud.alpha == 0 ) {
				self.EmpHud.alpha = 1;
				self.EmpHudText.alpha = 1;
			}
			else if( self getAmmoCount( "smoke_grenade_mp" ) <= 0 && self.EmpHud.alpha == 1 ) {
				self.EmpHud.alpha = 0;
				self.EmpHudText.alpha = 0;
			}
			
        	if(self.EmpHud.shadericon != "equipment_smoke_grenade") {
        		self.EmpHud setshader("equipment_smoke_grenade", 18, 18);
        		self.EmpHud.shadericon = "equipment_smoke_grenade";
        	}
        }
        if (self _hasPerk( "specialty_tacticalinsertion" ) ) {
			if( self getAmmoCount( "lightstick_mp" ) >= 1 && self.EmpHud.alpha == 0 ) {
				self.EmpHud.alpha = 1;
				self.EmpHudText.alpha = 1;
			}
			else if( self getAmmoCount( "lightstick_mp" ) <= 0 && self.EmpHud.alpha == 1 ) {
				self.EmpHud.alpha = 0;
				self.EmpHudText.alpha = 0;
			}
			
        	if(self.EmpHud.shadericon != "equipment_flare") {
        		self.EmpHud setshader("equipment_flare", 18, 18);
        		self.EmpHud.shadericon = "equipment_flare";
        	}
        }
        if (self _hasPerk( "trophy_mp" ) ) {
        	if( self getAmmoCount( "trophy_mp" ) >= 1 && self.EmpHud.alpha == 0 ) {
				self.EmpHud.alpha = 1;
				self.EmpHudText.alpha = 1;
			}
			else if( self getAmmoCount( "trophy_mp" ) <= 0 && self.EmpHud.alpha == 1 ) {
				self.EmpHud.alpha = 0;
				self.EmpHudText.alpha = 0;
			}
			
        	if(self.EmpHud.shadericon != "equipment_trophy") {
        		self.EmpHud setshader("equipment_trophy", 18, 18);
        		self.EmpHud.shadericon = "equipment_trophy";
        	}
        }
        if (self _hasPerk( "specialty_scrambler" ) ) {
        	if( self getAmmoCount( "scrambler_mp" ) >= 1 && self.EmpHud.alpha == 0 ) {
				self.EmpHud.alpha = 1;
				self.EmpHudText.alpha = 1;
			}
			else if( self getAmmoCount( "scrambler_mp" ) <= 0 && self.EmpHud.alpha == 1 ) {
				self.EmpHud.alpha = 0;
				self.EmpHudText.alpha = 0;
			}
			
        	if(self.EmpHud.shadericon != "equipment_scrambler") {
        		self.EmpHud setshader("equipment_scrambler", 18, 18);
        		self.EmpHud.shadericon = "equipment_scrambler";
        	}
        }
        if (self _hasPerk( "specialty_portable_radar" ) ) {
        	if( self getAmmoCount( "portable_radar_mp" ) >= 1 && self.EmpHud.alpha == 0 ) {
				self.EmpHud.alpha = 1;
				self.EmpHudText.alpha = 1;
			}
			else if( self getAmmoCount( "portable_radar_mp" ) <= 0 && self.EmpHud.alpha == 1 ) {
				self.EmpHud.alpha = 0;
				self.EmpHudText.alpha = 0;
			}
			
        	if(self.EmpHud.shadericon != "equipment_portable_radar") {
        		self.EmpHud setshader("equipment_portable_radar", 18, 18);
        		self.EmpHud.shadericon = "equipment_portable_radar";
        	}
        }
        if (self _hasPerk( "specialty_portable_radar" ) ) {
        	if( self getAmmoCount( "portable_radar_mp" ) >= 1 && self.EmpHud.alpha == 0 ) {
				self.EmpHud.alpha = 1;
				self.EmpHudText.alpha = 1;
			}
			else if( self getAmmoCount( "portable_radar_mp" ) <= 0 && self.EmpHud.alpha == 1 ) {
				self.EmpHud.alpha = 0;
				self.EmpHudText.alpha = 0;
			}
			
        	if(self.EmpHud.shadericon != "equipment_emp_grenade") {
        		self.EmpHud setshader("equipment_emp_grenade", 18, 18);
        		self.EmpHud.shadericon = "equipment_emp_grenade";
        	}
        }
        wait .10;
	}
}

LowAmmoCheck() {
	self endon("disconnect");
    level endon("game_ended");	
	while(1) {
		if(self getweaponammoclip(self getcurrentweapon()) + self getweaponammostock(self getcurrentweapon()) <= 15) {
			if(self.team == "allies") {
				self.WeaponAmmoTextStock fadeovertime(0.5);
        		self.WeaponAmmoTextStock.color = (0,1,0);
        		self.WeaponAmmoText fadeovertime(0.5);
        		self.WeaponAmmoText.color = (0,1,0);
        		self.WeaponAmmoTextAkimbo fadeovertime(0.5);
        		self.WeaponAmmoTextAkimbo.color = (0,1,0);
        		wait 0.5;
        		self.WeaponAmmoTextStock fadeovertime(0.5);
        		self.WeaponAmmoTextStock.color = (1,1,1);
        		self.WeaponAmmoText fadeovertime(0.5);
        		self.WeaponAmmoText.color = (1,1,1);
        		self.WeaponAmmoTextAkimbo fadeovertime(0.5);
        		self.WeaponAmmoTextAkimbo.color = (1,1,1);
        		wait 0.5;
			}
			else {
				self.WeaponAmmoTextStock fadeovertime(0.5);
        		self.WeaponAmmoTextStock.color = (1,0,0);
        		self.WeaponAmmoText fadeovertime(0.5);
        		self.WeaponAmmoText.color = (1,0,0);
        		self.WeaponAmmoTextAkimbo fadeovertime(0.5);
        		self.WeaponAmmoTextAkimbo.color = (1,0,0);
        		wait 0.5;
        		self.WeaponAmmoTextStock fadeovertime(0.5);
        		self.WeaponAmmoTextStock.color = (1,1,1);
        		self.WeaponAmmoText fadeovertime(0.5);
        		self.WeaponAmmoText.color = (1,1,1);
        		self.WeaponAmmoTextAkimbo fadeovertime(0.5);
        		self.WeaponAmmoTextAkimbo.color = (1,1,1);
        		wait 0.5;
			}
       	}
        else {
        	if(self.WeaponAmmoTextStock.color != (1,1,1)) {
        		self.WeaponAmmoTextStock.color = (1,1,1);
        		wait 0.5;
        	}
        	if(self.WeaponAmmoText.color != (1,1,1)) {
        		self.WeaponAmmoText.color = (1,1,1);
        		wait 0.5;
        	}
        	if(self.WeaponAmmoTextAkimbo.color != (1,1,1)) {
        		self.WeaponAmmoTextAkimbo.color = (1,1,1);
        		wait 0.5;
        	}
        }	
        wait .05;
	}
}

WeaponHud() {
	self endon("disconnect");
    level endon("game_ended");	
   	
    self.ButtonStuff = newClientHudElem( self );
    self.ButtonStuff.x = 85;
    self.ButtonStuff.y = 4;
    self.ButtonStuff.alignx = "left";
	self.ButtonStuff.aligny = "top";
	self.ButtonStuff.color = (1,1,1);
	self.ButtonStuff.alpha = 1;
	self.ButtonStuff.archived = false;
	self.ButtonStuff.sort = 80;
    self.ButtonStuff.foreground = true;
    self.ButtonStuff.fontscale = 0.8;
    self.ButtonStuff.font = "objective";
	self.ButtonStuff.horzalign = "fullscreen";
	self.ButtonStuff.vertalign = "fullscreen";
	self.ButtonStuff settext("^8[{vote yes}] ^7Fullbright\n^8[{vote no}] ^7High FPS\n^8[{+actionslot 7}]   ^7Position Info\n^8[{+actionslot 6}]   ^7Suicide");
	self.ButtonStuff.hidewheninmenu = true;
	self.ButtonStuff thread DestroyOnEndGame();
	
	self.WeaponRank = newClientHudElem( self );
    self.WeaponRank.x = 625;
    self.WeaponRank.y = 469;
    self.WeaponRank.alignx = "right";
    self.WeaponRank.aligny = "bottom";
    self.WeaponRank.horzalign = "fullscreen";
    self.WeaponRank.vertalign = "fullscreen";
    self.WeaponRank.alpha = 0.8;
    self.WeaponRank.sort = 1;
    self.WeaponRank.color = (0,0,0);
    self.WeaponRank.archived = true;
    self.WeaponRank.foreground = false;
    self.WeaponRank setshader("gradient_fadein", 100, 13);
    self.WeaponRank.hidewheninmenu = true;
    self.WeaponRank thread SetAlphaLow();
    
    self.WeaponRankLine = newClientHudElem( self );
    self.WeaponRankLine.x = 625;
    self.WeaponRankLine.y = 453;
    self.WeaponRankLine.alignx = "right";
    self.WeaponRankLine.aligny = "bottom";
    self.WeaponRankLine.horzalign = "fullscreen";
    self.WeaponRankLine.vertalign = "fullscreen";
    self.WeaponRankLine.alpha = 1;
    self.WeaponRankLine.sort = 1;
    self.WeaponRankLine.color = (1,1,1);
    self.WeaponRankLine.archived = true;
    self.WeaponRankLine.foreground = true;
    self.WeaponRankLine setshader("gradient_fadein", 120, 1);
    self.WeaponRankLine.hidewheninmenu = true;
    self.WeaponRankLine thread SetAlphaLow();
    
    self.WeaponAmmo = newClientHudElem( self );
    self.WeaponAmmo.x = 625;
    self.WeaponAmmo.y = 449;
    self.WeaponAmmo.alignx = "right";
    self.WeaponAmmo.aligny = "bottom";
    self.WeaponAmmo.horzalign = "fullscreen";
    self.WeaponAmmo.vertalign = "fullscreen";
    self.WeaponAmmo.alpha = 1;
    self.WeaponAmmo.sort = 1;
    self.WeaponAmmo.color = (0,0,0);
    self.WeaponAmmo.archived = true;
    self.WeaponAmmo.foreground = false;
    self.WeaponAmmo setshader("gradient_fadein", 50, 20);
    self.WeaponAmmo.hidewheninmenu = true;
    self.WeaponAmmo thread SetAlphaLow();
    
    self.weaponName = newClientHudElem( self );
    self.weaponName.x = 622;
    self.weaponName.y = 468;
    self.weaponName.alignx = "right";
	self.weaponName.aligny = "bottom";
	self.weaponName.color = (1,1,1);
	self.weaponName.alpha = 1;
	self.weaponName.archived = true;
	self.weaponName.sort = 80;
    self.weaponName.foreground = true;
    self.weaponName.fontscale = 1;
    self.weaponName.font = "objective";
	self.weaponName.horzalign = "fullscreen";
	self.weaponName.vertalign = "fullscreen";
	self.weaponName.hidewheninmenu = true;
	self.weaponName thread SetAlphaLow();
	
	self.WeaponAmmoText = newClientHudElem( self );
    self.WeaponAmmoText.x = 593;
    self.WeaponAmmoText.y = 454;
    self.WeaponAmmoText.alignx = "right";
	self.WeaponAmmoText.aligny = "bottom";
	self.WeaponAmmoText.color = (1,1,1);
	self.WeaponAmmoText.alpha = 1;
	self.WeaponAmmoText.archived = true;
    self.WeaponAmmoText.foreground = true;
    self.WeaponAmmoText.fontscale = 2.6;
	self.WeaponAmmoText.horzalign = "fullscreen";
	self.WeaponAmmoText.vertalign = "fullscreen";
	self.WeaponAmmoText.hidewheninmenu = true;
	self.WeaponAmmoText thread SetAlphaLow();
	
	self.WeaponAmmoTextAkimbo = newClientHudElem( self );
    self.WeaponAmmoTextAkimbo.x = 563;
    self.WeaponAmmoTextAkimbo.y = 454;
    self.WeaponAmmoTextAkimbo.alignx = "right";
	self.WeaponAmmoTextAkimbo.aligny = "bottom";
	self.WeaponAmmoTextAkimbo.color = (1,1,1);
	self.WeaponAmmoTextAkimbo.alpha = 0;
	self.WeaponAmmoTextAkimbo.archived = true;
    self.WeaponAmmoTextAkimbo.foreground = true;
    self.WeaponAmmoTextAkimbo.fontscale = 2.6;
	self.WeaponAmmoTextAkimbo.horzalign = "fullscreen";
	self.WeaponAmmoTextAkimbo.vertalign = "fullscreen";
	self.WeaponAmmoTextAkimbo.hidewheninmenu = true;
	self.WeaponAmmoTextAkimbo thread SetAlphaLow();
	
	self.WeaponAmmoTextStock = newClientHudElem( self );
    self.WeaponAmmoTextStock.x = 622;
    self.WeaponAmmoTextStock.y = 449;
    self.WeaponAmmoTextStock.alignx = "right";
	self.WeaponAmmoTextStock.aligny = "bottom";
	self.WeaponAmmoTextStock.color = (1,1,1);
	self.WeaponAmmoTextStock.alpha = 1;
	self.WeaponAmmoTextStock.sort = 80;
	self.WeaponAmmoTextStock.archived = true;
    self.WeaponAmmoTextStock.foreground = true;
    self.WeaponAmmoTextStock.fontscale = 1.8;
	self.WeaponAmmoTextStock.horzalign = "fullscreen";
	self.WeaponAmmoTextStock.vertalign = "fullscreen";
	self.WeaponAmmoTextStock.hidewheninmenu = true;
	self.WeaponAmmoTextStock thread SetAlphaLow();
	
	self.GrenadeHud = newClientHudElem( self );
    self.GrenadeHud.x = 493;
    self.GrenadeHud.y = 450;
    self.GrenadeHud.alignx = "right";
    self.GrenadeHud.aligny = "bottom";
    self.GrenadeHud.horzalign = "fullscreen";
    self.GrenadeHud.vertalign = "fullscreen";
    self.GrenadeHud.alpha = 0;
    self.GrenadeHud.sort = 10;
    self.GrenadeHud.color = (1,1,1);
    self.GrenadeHud.archived = false;
    self.GrenadeHud.foreground = true;
    self.GrenadeHud.hidewheninmenu = true;
    self.GrenadeHud thread DestroyOnEndGame();
    
    self.GrenadeName = newClientHudElem( self );
    self.GrenadeName.x = 485;
    self.GrenadeName.y = 465;
    self.GrenadeName.alignx = "center";
	self.GrenadeName.aligny = "bottom";
	self.GrenadeName.alpha = 0;
	self.GrenadeName.archived = false;
	self.GrenadeName.sort = 80;
    self.GrenadeName.foreground = true;
    self.GrenadeName.fontscale = 1;
	self.GrenadeName.horzalign = "fullscreen";
	self.GrenadeName.vertalign = "fullscreen";
	self.GrenadeName settext("^8[{+frag}]");
	self.GrenadeName.hidewheninmenu = true;
	self.GrenadeName thread DestroyOnEndGame();
	
	self.EmpHud = newClientHudElem( self );
    self.EmpHud.x = 463;
    self.EmpHud.y = 450;
    self.EmpHud.alignx = "right";
    self.EmpHud.aligny = "bottom";
    self.EmpHud.horzalign = "fullscreen";
    self.EmpHud.vertalign = "fullscreen";
    self.EmpHud.alpha = 0;
    self.EmpHud.sort = 10;
    self.EmpHud.color = (1,1,1);
    self.EmpHud.archived = false;
    self.EmpHud.foreground = true;
    self.EmpHud.hidewheninmenu = true;
    self.EmpHud thread DestroyOnEndGame();
    
    self.EmpHudText = newClientHudElem( self );
    self.EmpHudText.x = 455;
    self.EmpHudText.y = 465;
    self.EmpHudText.alignx = "center";
	self.EmpHudText.aligny = "bottom";
	self.EmpHudText.alpha = 0;
	self.EmpHudText.archived = false;
	self.EmpHudText.sort = 80;
    self.EmpHudText.foreground = true;
    self.EmpHudText.fontscale = 1;
	self.EmpHudText.horzalign = "fullscreen";
	self.EmpHudText.vertalign = "fullscreen";
	self.EmpHudText settext("^8[{+smoke}]");
	self.EmpHudText.hidewheninmenu = true;
	self.EmpHudText thread DestroyOnEndGame();
	
	while(1) {
		weapon = self getcurrentweapon();
		weapona = self getBaseWeaponName(weapon);
		if(weapona == "" || weapona == "none") {
			if(self.WeaponAmmoText.alpha == 1) {
				self.WeaponAmmoText.alpha = 0;
				self.weaponName.alpha = 0;
				self.WeaponAmmoTextStock.alpha = 0;
				self.WeaponRank.alpha = 0;
				self.WeaponRankLine.alpha = 0;
				self.WeaponAmmo.alpha = 0;
			}
		}
		else{
			if(self.WeaponAmmoText.alpha == 0) {
				self.WeaponAmmoText.alpha = 1;
				self.weaponName.alpha = 1;
				self.WeaponAmmoTextStock.alpha = 1;
				self.WeaponRank.alpha = 1;
				self.WeaponRankLine.alpha = 1;
				self.WeaponAmmo.alpha = 1;
			}
			self.weaponName settext(Get_Weapon_Name(weapona));
		}
		self waittill("weapon_change");
	}
}

hudMoveX(x,time) {
	self moveOverTime(time);
	self.x = x;
	wait time;
}

SetAlphaLow() {
	//level waittill("game_ended");
	//if(isdefined(self))
	//	self destroy();
}

HealthBar() {
	level endon("game_ended");
    self endon("disconnect");

    x = 15;
    y = 450;
	base_width = 65;
	base_height = 3;
	init_width = base_width * (self.maxhealth / 100);
    
	self.health_bar = newClientHudElem( self );
    self.health_bar.x = x + 1;
    self.health_bar.y = y;
    self.health_bar.alignx = "left";
    self.health_bar.aligny = "bottom";
    self.health_bar.horzalign = "fullscreen";
    self.health_bar.vertalign = "fullscreen";
    self.health_bar.alpha = 1;
    self.health_bar.archived = true;
    self.health_bar.foreground = true;
    self.health_bar.hidewheninmenu = true;
    self.health_bar setshader("progress_bar_fill", int(init_width), int(base_height));
    self.health_bar thread SetAlphaLow();
    
	self.health_bar_frame = newClientHudElem( self );
    self.health_bar_frame.x = x;
    self.health_bar_frame.y = y + 1;
    self.health_bar_frame.alignx = "left";
    self.health_bar_frame.aligny = "bottom";
    self.health_bar_frame.horzalign = "fullscreen";
    self.health_bar_frame.vertalign = "fullscreen";
    self.health_bar_frame.alpha = .75;
    self.health_bar_frame.sort = -1;
    self.health_bar_frame.color = (0,0,0);
    self.health_bar_frame.archived = true;
    self.health_bar_frame.foreground = true;
    self.health_bar_frame.hidewheninmenu = true;
    self.health_bar_frame setshader("progress_bar_fill", int(base_width) + 2, int(base_height) + 2);
    self.health_bar_frame thread SetAlphaLow();

	self.health_text = self createFontString( "default", 1 );
    self.health_text.x = x + base_width + 2 + 3;
    self.health_text.y = y + 3.5;
    self.health_text.alignx = "left";
    self.health_text.aligny = "bottom";
    self.health_text.horzalign = "fullscreen";
    self.health_text.vertalign = "fullscreen";
    self.health_text.alpha = 1;
    self.health_text.archived = true;
    self.health_text.foreground = true;
    self.health_text.hidewheninmenu = true;
    self.health_text thread SetAlphaLow();
    
    self.namehud = self createFontString( "objective", 0.8 );
    self.namehud.x = x;
    self.namehud.y = 465;
    self.namehud.alignx = "left";
    self.namehud.aligny = "bottom";
    self.namehud.horzalign = "fullscreen";
    self.namehud.vertalign = "fullscreen";
    self.namehud.alpha = 1;
    self.namehud.color = (1,1,1);
    self.namehud.archived = true;
    self.namehud.foreground = true;
    self.namehud.hidewheninmenu = true;
    self.namehud settext(self.name);
    self.namehud thread SetAlphaLow();
    
    self.killstreakcounter = self createFontString( "objective", 0.8 );
    self.killstreakcounter.x = x;
    self.killstreakcounter.y = 442;
    self.killstreakcounter.alignx = "left";
    self.killstreakcounter.aligny = "bottom";
    self.killstreakcounter.horzalign = "fullscreen";
    self.killstreakcounter.vertalign = "fullscreen";
    self.killstreakcounter.alpha = 1;
    self.killstreakcounter.color = (1,1,1);
    self.killstreakcounter.archived = true;
    self.killstreakcounter.foreground = true;
    self.killstreakcounter.hidewheninmenu = true;
    self.killstreakcounter.label = &"Killstreak: ^8";
    self.killstreakcounter thread DestroyOnEndGame();
    
    self.velmeter = newClientHudElem( self );
    self.velmeter.x = 275;
    self.velmeter.y = 447;
    self.velmeter.alignx = "left";
    self.velmeter.aligny = "BOTTOM";
    self.velmeter.horzalign = "fullscreen";
    self.velmeter.vertalign = "fullscreen";
    self.velmeter.alpha = 1;
    self.velmeter.sort = 1;
    self.velmeter.fontscale = 0.9;
    self.velmeter.font = "objective";
    self.velmeter.color = (1,1,1);
    self.velmeter.foreground = false;
    self.velmeter.label = &"SPEED: ^8";
    self.velmeter.HideWhenInMenu = true;
    self.velmeter.archived = false;
    self.velmeter thread DestroyOnEndGame();
    
    self.velhighmeter = newClientHudElem( self );
    self.velhighmeter.x = 365;
    self.velhighmeter.y = 447;
    self.velhighmeter.alignx = "right";
    self.velhighmeter.aligny = "BOTTOM";
    self.velhighmeter.horzalign = "fullscreen";
    self.velhighmeter.vertalign = "fullscreen";
    self.velhighmeter.alpha = 1;
    self.velhighmeter.sort = 1;
    self.velhighmeter.color = (1,1,1);
    self.velhighmeter.fontscale = 0.9;
    self.velhighmeter.font = "objective";
    self.velhighmeter.foreground = false;
    self.velhighmeter.label = &"MAX: ^8";
    self.velhighmeter.HideWhenInMenu = true;
    self.velhighmeter.archived = false;
    self.velhighmeter thread DestroyOnEndGame();
    
    self.BounceHit = newClientHudElem( self );
    self.BounceHit.x = 320;
    self.BounceHit.y = 468;
    self.BounceHit.alignx = "CENTER";
    self.BounceHit.aligny = "BOTTOM";
    self.BounceHit.horzalign = "fullscreen";
    self.BounceHit.vertalign = "fullscreen";
    self.BounceHit.alpha = 1;
    self.BounceHit.sort = 1;
    self.BounceHit.color = (1,1,1);
    self.BounceHit.fontscale = 0.9;
    self.BounceHit.font = "objective";
    self.BounceHit.foreground = false;
    self.BounceHit.label = &"BOUNCES: ^8";
    self.BounceHit.HideWhenInMenu = true;
    self.BounceHit.archived = false;
    self.BounceHit thread DestroyOnEndGame();
    
    self.Vel_Bar = newClientHudElem( self );
    self.Vel_Bar.x = 320 - 5;
    self.Vel_Bar.y = 453;
    self.Vel_Bar.alignx = "CENTER";
    self.Vel_Bar.aligny = "BOTTOM";
    self.Vel_Bar.horzalign = "fullscreen";
    self.Vel_Bar.vertalign = "fullscreen";
    self.Vel_Bar.alpha = 1;
    self.Vel_Bar.sort = 1;
    self.Vel_Bar.color = (1,1,1);
    self.Vel_Bar.foreground = false;
    self.Vel_Bar setshader("line_horizontal", 115, 1);
    self.Vel_Bar.HideWhenInMenu = true;
    self.Vel_Bar.archived = true;
    //self.Vel_Bar thread SetAlphaLow();
    self.Vel_Bar thread DestroyOnEndGame();

    if (!isDefined(self.maxhealth) || self.maxhealth <= 0)
		self.maxhealth = 100;

    while (1)  {
		low_health = self.health < 25;
		
		if(low_health) 
			color = (1,0,0);
		else 
			color = (1,1,1);
			
        width = (self.health / self.maxhealth) * base_width * (self.maxhealth / 100);
        width = int(max(width, 1));
        
        if(self.team == "allies") {
        	if(isdefined(self.killstreakcounter))
        		self.killstreakcounter setvalue(self.adrenaline);
        }
        else {
        	if(isdefined(self.killstreakcounter)) {
        		if(self.killstreakcounter.alpha == 1)
        			self.killstreakcounter destroy();
        	}
        }

        self.health_bar.color = color;
		self.health_bar setShader("progress_bar_fill", width, base_height);

        self.health_text.color = color;
        self.health_text setValue(self.health);
        self.newvel = self getvelocity();
        if(isdefined(self.newvel)) {
			self.newvel = sqrt(float(self.newvel[0] * self.newvel[0]) + float(self.newvel[1] * self.newvel[1]));
			self.vel = self.newvel;
		}
		self.BounceHit setvalue(self.bounces);
		if(isdefined(self.vel))
			self.velmeter setvalue(int(self.vel));
    	if(isdefined(self.velhigh) && self.vel > self.velhigh) {
			self.velhigh = self.vel;
       	 	self.velhighmeter setvalue(int(self.velhigh));
    	}
		wait .05;
    }
}

killstreakSplashNotify_New( streakName, streakVal, appendString ) {
	self endon ( "disconnect" );
	waittillframeend;
	
	if(self.adrenaline >= 2 && !isdefined(self.killstreakslots[0])) // 1st Slot
        self thread SendMeANotification(streakName, 0, (1, .5, 0), streakName, appendString, streakVal);
        
    if(self.adrenaline >= 4 && !isdefined(self.killstreakslots[1])) // 1st Slot
        self thread SendMeANotification(streakName, 1, (1, .5, 0), streakName, appendString, streakVal);
        	
    if(self.adrenaline >= 6 && !isdefined(self.killstreakslots[2])) // 1st Slot
        self thread SendMeANotification(streakName, 2, (1, .5, 0), streakName, appendString, streakVal);
        	
    if(self.adrenaline >= 8 && !isdefined(self.killstreakslots[3])) // 1st Slot
        self thread SendMeANotification(streakName, 3, (1, .5, 0), streakName, appendString, streakVal);
        
    if(self.adrenaline >= 24 && !isdefined(self.killstreakslots[4])) // 1st Slot
        self thread SendMeANotification(streakName, 4, (1, .5, 0), streakName, appendString, streakVal);
}

GetPerkColor(Perk) {
	blue = (0,.5,1);
	red = (1,.2,.2);
	yellow = (1,0.7,0);
	green = (.25,1,.25);
	switch(Perk) {
		case "specialty_longersprint_ks":
		case "specialty_longersprint_ks_pro":
			return blue;
		case "specialty_fastreload_ks":
		case "specialty_fastreload_ks_pro":
			return blue;
		case "specialty_scavenger_ks":
		case "specialty_scavenger_ks_pro":
			return blue;
		case "specialty_blindeye_ks":
		case "specialty_blindeye_ks_pro":
			return blue;
		case "specialty_paint_ks":
		case "specialty_paint_ks_pro":
			return blue;
		case "specialty_hardline_ks":
		case "specialty_hardline_ks_pro":
			return red;
		case "specialty_coldblooded_ks":
		case "specialty_coldblooded_ks_pro":
			return red;
		case "specialty_quickdraw_ks":
		case "specialty_quickdraw_ks_pro":
			return red;
		case "_specialty_blastshield_ks":
		case "_specialty_blastshield_ks_pro":
			return red;
		case "specialty_twoprimaries":
		case "specialty_twoprimaries_pro":
			return red;
		case "specialty_detectexplosive_ks":
		case "specialty_detectexplosive_ks_pro":
			return yellow;
		case "specialty_autospot_ks":
		case "specialty_autospot_ks_pro":
			return yellow;
		case "specialty_bulletaccuracy_ks":
		case "specialty_bulletaccuracy_ks_pro":
			return yellow;
		case "specialty_quieter_ks":
		case "specialty_quieter_ks_pro":
			return yellow;
		case "specialty_stalker_ks":
		case "specialty_stalker_ks_pro":
			return yellow;
		case "specialty_longersprint_ks_pro":
		case "specialty_longersprint_ks_pro":
			return yellow;
		case "all_perks_bonus":
			return yellow;
		case "nuke":
			return green;
	}
}

SendMeANotification(icon, index, glowcolora, Killstreak, String, Num) {
	level endon("game_ended");
	self endon("disconnect");
	if(isdefined(self.notification))
		self waittill("NotificationGone");
	
	self.notification = 1;
	xpos = 110;
	ypos = 465;
	
	self playLocalSound( maps\mp\killstreaks\_killstreaks::getKillstreakSound( Killstreak ) );
	self leaderDialogOnPlayer( Killstreak, "killstreak_earned" );
	
	InfoMessage = newClientHudElem( self );
    InfoMessage.x = 320;
    InfoMessage.y = 95;
    InfoMessage.alignx = "center";
   	InfoMessage.aligny = "bottom";
    InfoMessage.horzalign = "fullscreen";
    InfoMessage.vertalign = "fullscreen";
    InfoMessage.alpha = 1;
   	InfoMessage.sort = 1;
   	InfoMessage.fontscale = 1.5;
    InfoMessage.color = (1,1,1);
   	InfoMessage.archived = true;
   	InfoMessage.foreground = true;
   	InfoMessage.glowalpha = 1;
   	InfoMessage.glowcolor = GetPerkColor(Killstreak);
   	hint = tableLookupIString( "mp/killstreakTable.csv", 1, Killstreak, 2 );
   	if(hint == &"PERKS_EXTREME_CONDITIONING")
   		hint = &"PERKS_LONGERSPRINT_PRO";
    InfoMessage settext(hint);
    InfoMessage.hidewheninmenu = true;
    InfoMessage.hideWhenInKillcam = true;
    InfoMessage thread DestroyOnEndGame();
    
    InfoStreakNum = newClientHudElem( self );
    InfoStreakNum.x = 320;
    InfoStreakNum.y = 110;
    InfoStreakNum.alignx = "center";
   	InfoStreakNum.aligny = "bottom";
    InfoStreakNum.horzalign = "fullscreen";
    InfoStreakNum.vertalign = "fullscreen";
    InfoStreakNum.alpha = 1;
   	InfoStreakNum.sort = 1;
   	InfoStreakNum.fontscale = 1.1;
    InfoStreakNum.color = (1,1,1);
   	InfoStreakNum.archived = true;
   	InfoStreakNum.foreground = true;
    InfoStreakNum.label = &"MP_KILLSTREAK_N";
    InfoStreakNum setvalue(Num);
    InfoStreakNum.hidewheninmenu = true;
    InfoStreakNum.hideWhenInKillcam = true;
    InfoStreakNum thread DestroyOnEndGame();
	
	if(!isdefined(self.killstreakslots[index])) {
		self.killstreakslots[index] = newClientHudElem( self );
    	self.killstreakslots[index].x = 320;
    	self.killstreakslots[index].y = 80;
    	self.killstreakslots[index].alignx = "center";
   		self.killstreakslots[index].aligny = "bottom";
    	self.killstreakslots[index].horzalign = "fullscreen";
    	self.killstreakslots[index].vertalign = "fullscreen";
    	self.killstreakslots[index].alpha = 1;
   	 	self.killstreakslots[index].sort = 1;
    	self.killstreakslots[index].color = (1,1,1);
   		self.killstreakslots[index].archived = true;
   		self.killstreakslots[index].foreground = true;
   		self.killstreakslots[index] thread DestroyOnEndGame();
   		if(isdefined(String))
    		self.killstreakslots[index] setshader(tableLookup("mp/killstreakTable.csv", 1, Killstreak + "_" + String, 16), 30, 30);
    	else
    		self.killstreakslots[index] setshader(tableLookup("mp/killstreakTable.csv", 1, Killstreak, 16), 30, 30);
    	self.killstreakslots[index].hidewheninmenu = true;
    	self.killstreakslots[index].hideWhenInKillcam = true;
	}
	wait 3;
	InfoMessage destroy();
	InfoStreakNum destroy();
	self.killstreakslots[index] scaleovertime( 1, 15, 15);
	self.killstreakslots[index] moveOverTime( 1 );
	self.killstreakslots[index].alignx = "left";
	self.killstreakslots[index].y = ypos;
	if(!isdefined(self.killstreakslots[index-1]))
		self.killstreakslots[index].x = xpos;
	else
		self.killstreakslots[index].x = self.killstreakslots[index-1].x + 15;
	
	self.notification = undefined;
	wait 1;
	if(index == 4) {
    	self.MoabButton = newClientHudElem( self );
    	self.MoabButton.x = self.killstreakslots[index].x + 6;
    	self.MoabButton.y = 445;
    	self.MoabButton.alignx = "left";
   		self.MoabButton.aligny = "bottom";
    	self.MoabButton.horzalign = "fullscreen";
   	 	self.MoabButton.vertalign = "fullscreen";
    	self.MoabButton.alpha = 1;
   		self.MoabButton.sort = 1;
   		self.MoabButton.fontscale = 1.1;
    	self.MoabButton.color = (1,1,1);
   		self.MoabButton.archived = true;
   		self.MoabButton.foreground = true;
    	self.MoabButton settext("^8[{+actionslot 4}]");
   		self.MoabButton.hidewheninmenu = true;
    	self.MoabButton.hideWhenInKillcam = true;
    	self.MoabButton thread DestroyOnEndGame();
    }
	self notify("NotificationGone");
}

setNewCursorHint2(owner) {
	self endon("death");
	owner endon("disconnect");
	level endon("game_ended");
	while(1) {
		self waittill("trigger", player);
		if(player != owner && player.team != owner.team) {
			player setLowerMessage("msg", "Press and Hold ^3[{+activate}]^7 to Destroy Tactical Insertion!");
            player thread deleteLowerMsg(self, 75);
		}
	}
}

setNewCursorHint(owner) {
	self endon("death");
	owner endon("disconnect");
	level endon("game_ended");
	while(1) {
		self waittill("trigger", player);
		if(player == owner) {
			player setLowerMessage("msg", "Press and Hold ^3[{+activate}]^7 to pick up Tactical Insertion!");
            player thread deleteLowerMsg(self, 75);
		}
	}
}

deleteLowerMsg(trigger, range) {
    self notify("Deletemsg");
    self endon("Deletemsg");
    self endon("disconnect");
    near = true;
    while(near) {
        wait .5;
		if(isdefined(trigger)) {
        	if(Distance(self.origin,trigger.origin) > range) {
            	self clearLowerMessage("msg");
            	near = false;
            }
        }
        else {
        	self clearLowerMessage("msg");
            near = false;
        }
    }
}

GlowStickUseListener_new( owner ) {
	self endon ( "death" );
	level endon ( "game_ended" );
	owner endon ( "disconnect" );
	
	self thread maps\mp\perks\_perkfunctions::updateEnemyUse( owner );
	triggerfriendly = Spawn( "trigger_radius", self.origin, 0, 75, 75 );
	triggerfriendly thread setNewCursorHint(owner);
	triggerenemy = Spawn( "trigger_radius", self.origin, 0, 75, 75 );
	triggerenemy thread setNewCursorHint2(owner);
	self thread WatchDeath(triggerenemy, triggerfriendly);
	for ( ;; ) {
		self waittill ( "trigger", player );
		player playSound( "chemlight_pu" );
		triggerenemy delete();
		triggerfriendly delete();
		player thread maps\mp\perks\_perkfunctions::setTacticalInsertion();
		player thread maps\mp\perks\_perkfunctions::deleteTI( self );
	}
}

WatchDeath(trig, trig2) {
	level endon ( "game_ended" );
	self endon("DDDDD");
	self waittill("death");
	if(isdefined(trig))
		trig delete();
	if(isdefined(trig2))
		trig2 delete();
	self notify("DDDDD");
}

AFKWatcher() {
	self endon("disconnect");
	level endon ( "game_ended" );
	wait 3;
	arg = 0;
    while(1) {
    	if(level.players.size >= 6) {
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
		}
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

xpPointsPopup_new( amount, bonus, hudColor, glowAlpha ) {
	self endon( "disconnect" );
	self endon( "joined_team" );
	self endon( "joined_spectators" );

	if ( amount == 0 )
		return;

	self notify( "xpPointsPopup" );
	self endon( "xpPointsPopup" );

	self.xpUpdateTotal += amount;
	self.bonusUpdateTotal += bonus;

	wait ( 0.05 );

	if ( self.xpUpdateTotal < 0 )
		self.hud_xpPointsPopup.label = &"";
	else
		self.hud_xpPointsPopup.label = &"MP_PLUS";

	if(self.team == "allies")
		hudColor = game["colors"]["allies"];
	else
		hudColor = game["colors"]["axis"];
	
	self.hud_xpPointsPopup.color = hudColor;
	self.hud_xpPointsPopup.glowAlpha = glowAlpha;
	self.hud_xpPointsPopup.font = "hudbig";
	self.hud_xpPointsPopup.fontscale = 0.3;

	self.hud_xpPointsPopup setValue(self.xpUpdateTotal);
	self.hud_xpPointsPopup.alpha = 1;
	self.hud_xpPointsPopup thread maps\mp\gametypes\_hud::fontPulse( self );

	increment = max( int( self.bonusUpdateTotal / 20 ), 1 );
		
	if ( self.bonusUpdateTotal ) {
		while ( self.bonusUpdateTotal > 0 ) {
			self.xpUpdateTotal += min( self.bonusUpdateTotal, increment );
			self.bonusUpdateTotal -= min( self.bonusUpdateTotal, increment );
			
			self.hud_xpPointsPopup setValue( self.xpUpdateTotal );
			
			wait ( 0.05 );
		}
	}	
	else
		wait ( 1.0 );
	
	self.hud_xpPointsPopup fadeOverTime( 0.75 );
	self.hud_xpPointsPopup.alpha = 0;
	
	self.xpUpdateTotal = 0;		
}

xpEventPopup_new( event, hudColor, glowAlpha ) {
	self endon( "disconnect" );
	self endon( "joined_team" );
	self endon( "joined_spectators" );

	self notify( "xpEventPopup" );
	self endon( "xpEventPopup" );

	wait ( 0.05 );
	if(self.team == "axis")
		hudColor = game["colors"]["axis"];
	else
		hudColor = (1,1,1);
	
	if ( !isDefined( glowAlpha ) )
		glowAlpha = 0;
	self.hud_xpEventPopup.font = "default";
	self.hud_xpEventPopup.fontscale = 1.4;
	self.hud_xpEventPopup.color = hudColor;
	self.hud_xpEventPopup.glowAlpha = glowAlpha;

	self.hud_xpEventPopup setText(event);
	self.hud_xpEventPopup.alpha = 1;

	wait ( 1.0 );
	
	self.hud_xpEventPopup fadeOverTime( 0.75 );
	self.hud_xpEventPopup.alpha = 0;	
}














































