#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

main() {
	replacefunc(maps\mp\gametypes\war::onStartGameType, ::onStartGameType_new);
	replacefunc(maps\mp\gametypes\_spawnlogic::spawnPerFrameUpdate, ::spawnPerFrameUpdate_new);
	replacefunc(maps\mp\gametypes\_playerlogic::spawnPlayer, ::spawnPlayerreplace);
}

init() {
	level.getSpawnPoint = ::getSpawnPoint;
	
	replacefunc(maps\mp\gametypes\_hud_message::hintMessage, ::customHintMessage);
	replacefunc(maps\mp\gametypes\_hud_message::initNotifyMessage, ::customNotifyMessage);
	replacefunc(maps\mp\gametypes\_rank::xpPointsPopup, ::nothing);
	replacefunc(maps\mp\gametypes\_damage::_obituary, ::customObituary);
	replacefunc(maps\mp\gametypes\_weapons::monitorSemtex, ::monitorSemtexBlank);
	replacefunc(maps\mp\gametypes\_battlechatter_mp::grenadeProximityTracking, ::grenadeProximityTrackingBlank);
	replacefunc(maps\mp\gametypes\_battlechatter_mp::grenadeTracking, ::grenadeTrackingBlank);
	replacefunc(maps\mp\_utility::playLeaderDialogOnPlayer, ::playLeaderDialogOnPlayer_new);
	replacefunc(maps\mp\gametypes\_shellshock::bloodEffect, ::bloodEffect_new);
	replacefunc(maps\mp\_utility::_suicide, ::_suicide_new);
}

spawnPlayerreplace( fauxSpawn )
{
	self endon( "disconnect" );
	self endon( "joined_spectators" );
	self notify( "spawned" );
	self notify( "end_respawn" );
	
	if ( !isDefined( fauxSpawn ) )
		fauxSpawn = false;
	
    if ( isDefined( self.setSpawnPoint ) && ( isDefined( self.setSpawnPoint.notTI ) || self maps\mp\gametypes\_playerlogic::tiValidationCheck() ) )
	{
		spawnPoint = self.setSpawnPoint;

		if ( !isDefined( self.setSpawnPoint.notTI ) )
		{
			self playLocalSound( "tactical_spawn" );
			
			if ( level.teamBased )
				self playSoundToTeam( "tactical_spawn", level.otherTeam[self.team] );
			else
				self playSound( "tactical_spawn" );
		}
		
		//check for vehicles and kill them
		foreach ( tank in level.ugvs )
		{
			if ( DistanceSquared( tank.origin, spawnPoint.playerSpawnPos ) < 1024 )//32^2
				tank notify( "damage", 5000, tank.owner, ( 0, 0, 0 ), ( 0, 0, 0 ), "MOD_EXPLOSIVE", "", "", "", undefined, "killstreak_emp_mp" );
		}

		assert( isDefined( spawnPoint.playerSpawnPos ) );
		assert( isDefined( spawnPoint.angles ) );
			
		spawnOrigin = self.setSpawnPoint.playerSpawnPos;
		spawnAngles = self.setSpawnPoint.angles;		

		if ( isDefined( self.setSpawnPoint.enemyTrigger ) )
			 self.setSpawnPoint.enemyTrigger Delete();
		
		self.setSpawnPoint delete();

		spawnPoint = undefined;
	}
	else
	{
		spawnPoint = self [[level.getSpawnPoint]]();

		assert( isDefined( spawnPoint ) );
		assert( isDefined( spawnPoint.origin ) );
		assert( isDefined( spawnPoint.angles ) );

		spawnOrigin = spawnpoint.origin;
		spawnAngles = spawnpoint.angles;
	}
	
	
	self maps\mp\gametypes\_playerlogic::setSpawnVariables();

	/#
	if ( !getDvarInt( "scr_forcerankedmatch" ) )
		assert( (level.teamBased && ( !allowTeamChoice() || self.sessionteam == self.team )) || (!level.teamBased && self.sessionteam == "none") );
	#/

	hadSpawned = self.hasSpawned;

	self.fauxDead = undefined;

	if ( !fauxSpawn )
	{
		self.killsThisLife = [];
	
		self maps\mp\gametypes\_playerlogic::updateSessionState( "playing", "" );
		self ClearKillcamState();
		self.cancelkillcam = 1;
		self openMenu( "killedby_card_hide" );
		
		self.maxhealth = maps\mp\gametypes\_tweakables::getTweakableValue( "player", "maxhealth" );
		self.health = self.maxhealth;
		
		self.friendlydamage = undefined;
		self.hasSpawned = true;
		self.spawnTime = getTime();
		self.wasTI = !isDefined( spawnPoint );
		self.afk = false;
		self.damagedPlayers = [];
		self.killStreakScaler = 1;
		self.xpScaler = 1;
		self.objectiveScaler = 1;
		self.clampedHealth = undefined;
		self.shieldDamage = 0;
		self.shieldBulletHits = 0;
		self.recentShieldXP = 0;
	}
	
	self.moveSpeedScaler = 1;
	self.inLastStand = false;
	self.lastStand = undefined;
	self.infinalStand = undefined;
	self.inC4Death = undefined;
	self.disabledWeapon = 0;
	self.disabledWeaponSwitch = 0;
	self.disabledOffhandWeapons = 0;
	self resetUsability();

	if ( !fauxSpawn )
	{
		// trying to stop killstreaks from targeting the newly spawned
		self.avoidKillstreakOnSpawnTimer = 5.0;
	
		if ( self.pers["lives"] == getGametypeNumLives() )
		{
			maps\mp\gametypes\_playerlogic::addToLivesCount();
		}
		
		if ( self.pers["lives"] )
			self.pers["lives"]--;
	
		self maps\mp\gametypes\_playerlogic::addToAliveCount();
	
		if ( !hadSpawned || gameHasStarted() || (gameHasStarted() && level.inGracePeriod && self.hasDoneCombat) )
			self maps\mp\gametypes\_playerlogic::removeFromLivesCount();
	
		if ( !self.wasAliveAtMatchStart )
		{
			acceptablePassedTime = 20;
			if ( getTimeLimit() > 0 && acceptablePassedTime < getTimeLimit() * 60 / 4 )
				acceptablePassedTime = getTimeLimit() * 60 / 4;
			
			if ( level.inGracePeriod || getTimePassed() < acceptablePassedTime * 1000 )
				self.wasAliveAtMatchStart = true;
		}
	}
	
	//self setClientDvar( "cg_thirdPerson", "0" );
	//self setDepthOfField( 0, 0, 512, 512, 4, 0 );
	//self setClientDvar( "cg_fov", "65" );

	// Don't do this stuff for TI spawn points	
	if ( isDefined( spawnPoint ) )
	{
		self maps\mp\gametypes\_spawnlogic::finalizeSpawnpointChoice( spawnpoint );
		spawnOrigin = maps\mp\gametypes\_playerlogic::getSpawnOrigin( spawnpoint );
		spawnAngles = spawnpoint.angles;
	}
	else
	{
		// the only useful part of finalizeSpawnpointChoice() when using tactical insertion
		self.lastSpawnTime = getTime();
	}

	self.spawnPos = spawnOrigin;

	//	the actual spawn
	self spawn( spawnOrigin, spawnAngles );
	
	//	immediately fix our stance if we were spawned in place so we don't get stuck in geo
	if ( fauxSpawn && isDefined( self.faux_spawn_stance ) )
	{
		self setStance( self.faux_spawn_stance );
		self.faux_spawn_stance = undefined;
	}
	
	//	spawn callback
	[[level.onSpawnPlayer]]();
	
	// Don't do this stuff for TI spawn points	
	if ( isDefined( spawnPoint ) )
		self maps\mp\gametypes\_playerlogic::checkPredictedSpawnpointCorrectness( spawnPoint.origin );
	
	if ( !fauxSpawn )
		self maps\mp\gametypes\_missions::playerSpawned();
	
	prof_begin( "spawnPlayer_postUTS" );
	
	assert( isValidClass( self.class ) );
	
	self maps\mp\gametypes\_class::setClass( self.class );
	self maps\mp\gametypes\_class::giveLoadout( self.team, self.class );

	if ( getDvarInt( "camera_thirdPerson" ) )
		self setThirdPersonDOF( true );

	if ( !gameFlag( "prematch_done" ) )
		self freezeControlsWrapper( true );
	else
		self freezeControlsWrapper( false );

	if ( !gameFlag( "prematch_done" ) || !hadSpawned && game["state"] == "playing" )
	{
		//self setClientDvar( "scr_objectiveText", getObjectiveHintText( self.pers["team"] ) );

		team = self.pers["team"];
		
		if ( game["status"] == "overtime" )
			thread maps\mp\gametypes\_hud_message::oldNotifyMessage( game["strings"]["overtime"], game["strings"]["overtime_hint"], undefined, (1, 0, 0), "mp_last_stand" );
		else if ( getIntProperty( "useRelativeTeamColors", 0 ) )
			thread maps\mp\gametypes\_hud_message::oldNotifyMessage( game["strings"][team + "_name"], undefined, game["icons"][team] + "_blue", game["colors"]["blue"] );
		else
			thread maps\mp\gametypes\_hud_message::oldNotifyMessage( game["strings"][team + "_name"], undefined, game["icons"][team], game["colors"][team] );

		thread maps\mp\gametypes\_playerlogic::showSpawnNotifies();
	}

	if( getIntProperty( "scr_showperksonspawn", 1 ) == 1 && game["state"] != "postgame" )
	{
		self openMenu( "perk_display" );
		self thread maps\mp\gametypes\_playerlogic::hidePerksAfterTime( 4.0 );
		self thread maps\mp\gametypes\_playerlogic::hidePerksOnDeath();
	}

	prof_end( "spawnPlayer_postUTS" );

	//self logstring( "S " + self.origin[0] + " " + self.origin[1] + " " + self.origin[2] );
	
	// give "connected" handlers a chance to start
	// many of these start onPlayerSpawned handlers which rely on the "spawned_player"
	// notify which can happen on the same frame as the "connected" notify
	waittillframeend;

	//	- when killed while using a remote, the player's location remains at their corpse
	//	- the using remote variable is cleared before they are actually respawned and moved
	//	- if you want control over proximity related events with relation to their corpse location
	//    between the clearing of the remote variables and their actual respawning somewhere else use this variable
	self.spawningAfterRemoteDeath = undefined;

	self notify( "spawned_player" );
	level notify ( "player_spawned", self );
	
	if ( game["state"] == "postgame" )
	{
		assert( !level.intermission );
		// We're in the victory screen, but before intermission
		self maps\mp\gametypes\_gamelogic::freezePlayerForRoundEnd();
	}	
}

_suicide_new() {
	if ( self isUsingRemote() && !isDefined( self.fauxDead ) && !isdefined(self.protected) )
		self thread maps\mp\gametypes\_damage::PlayerKilled_internal( self, self, self, 10000, "MOD_SUICIDE", "frag_grenade_mp", (0,0,0), "none", 0, 1116, true );
	else if( !self isUsingRemote() && !isDefined( self.fauxDead ) && !isdefined(self.protected) )
		self suicide();	
}

bloodEffect_new( position ) {
	self endon ( "disconnect" );
	
	forwardVec = vectorNormalize( anglesToForward( self.angles ) );
	rightVec = vectorNormalize( anglesToRight( self.angles ) );
	grenadeVec = vectorNormalize( position - self.origin );
	
	fDot = vectorDot( grenadeVec, forwardVec );
	rDot = vectorDot( grenadeVec, rightVec );
	
	effectMenus = [];
	if ( fDot > 0 && fDot > 0.5 && self getCurrentWeapon() != "riotshield_mp" )
		effectMenus[effectMenus.size] = "dirt_effect_center";
	
	if ( abs(fDot) < 0.866 ) {
		if ( rDot > 0 )
			effectMenus[effectMenus.size] = "dirt_effect_right";
		else
			effectMenus[effectMenus.size] = "dirt_effect_left";		
	}

	foreach ( menu in effectMenus )
		self closeMenu( menu );
}

spawnPerFrameUpdate_new() {
}

playLeaderDialogOnPlayer_new( dialog, team ) {
}

grenadeProximityTrackingBlank(){}
grenadeTrackingBlank(){}
monitorSemtexBlank(){}

onStartGameType_new() {
	setClientNameMode("auto_change");

	if ( !isdefined( game["switchedsides"] ) )
		game["switchedsides"] = false;

	if ( game["switchedsides"] ) {
		oldAttackers = game["attackers"];
		oldDefenders = game["defenders"];
		game["attackers"] = oldDefenders;
		game["defenders"] = oldAttackers;
	}

	setObjectiveText( "allies", "^9Gillette ^7Michael Myers\nJoin our Discord at ^9www.gilletteclan.com" );
    setObjectiveText( "axis", "^9Gillette ^7Michael Myers\nJoin our Discord at ^9www.gilletteclan.com" );
			
	level.spawnMins = ( 0, 0, 0 );
	level.spawnMaxs = ( 0, 0, 0 );	
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "allies", "mp_tdm_spawn" );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "axis", "mp_tdm_spawn" );
	
	level.mapCenter = maps\mp\gametypes\_spawnlogic::findBoxCenter( level.spawnMins, level.spawnMaxs );
	setMapCenter( level.mapCenter );
	
	allowed[0] = level.gameType;
	allowed[1] = "airdrop_pallet";
	
	maps\mp\gametypes\_gameobjects::main(allowed);	
}

getSpawnPoint() {
	spawnPoints = maps\mp\gametypes\_spawnlogic::getSpawnpointArray( "mp_tdm_spawn" );
	spawnPoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_SafeSpawn( spawnPoints );

	return spawnPoint;
}

customObituary(victim, attacker, sWeapon, sMeansOfDeath) {
	victimTeam = victim.team;
	foreach(player in level.players) {
		playerTeam = player.team;
		if(playerTeam == "spectator") 
			player iPrintLn("^1" + &"MP_OBITUARY_NEUTRAL", attacker.name, victim.name);
		else if(playerTeam == victimTeam) 
			player iPrintLn("^1" + &"MP_OBITUARY_ENEMY", attacker.name, victim.name);
		else 
			player iPrintLn("^1" + &"MP_OBITUARY_FRIENDLY", attacker.name, victim.name);
	}
}

nothing(amount, bonus, hudColor, glowAlpha){}

customHintMessage(hintText) {
	notifyData = spawnstruct();
	notifyData.notifyText = hintText;
	notifyData.glowColor = (0.7, 0.0, 0.0);
	maps\mp\gametypes\_hud_message::notifyMessage(notifyData);
}

customNotifyMessage() {
	if(level.splitscreen) {
		titleSize = 2.0;
		textSize = 1.5;
		iconSize = 24;
		font = "default";
		point = "TOP";
		relativePoint = "BOTTOM";
		yOffset = 30;
		xOffset = 0;
	}
	else {
		titleSize = 1.55;
		textSize = 0.95;
		iconSize = 30;
		font = "bigfixed";
		point = "TOP";
		relativePoint = "BOTTOM";
		yOffset = 125;
		xOffset = 0;
	}
	
	self.notifyTitle = createFontString( font, titleSize );
	self.notifyTitle setPoint( point, undefined, xOffset, yOffset );
	self.notifyTitle.glowColor = (0.7, 0.0, 0.0);
	self.notifyTitle.glowAlpha = 1;
	self.notifyTitle.hideWhenInMenu = true;
	self.notifyTitle.archived = false;
	self.notifyTitle.alpha = 0;

	self.notifyText = createFontString( font, textSize );
	self.notifyText setParent( self.notifyTitle );
	self.notifyText setPoint( point, relativePoint, 0, 25 );
	self.notifyText.glowColor = (0.7, 0.0, 0.0);
	self.notifyText.glowAlpha = 1;
	self.notifyText.hideWhenInMenu = true;
	self.notifyText.archived = false;
	self.notifyText.alpha = 0;

	self.notifyText2 = createFontString( font, textSize );
	self.notifyText2 setParent( self.notifyTitle );
	self.notifyText2 setPoint( point, relativePoint, 0, 25 );
	self.notifyText2.glowColor = (0.7, 0.0, 0.0);
	self.notifyText2.glowAlpha = 1;
	self.notifyText2.hideWhenInMenu = true;
	self.notifyText2.archived = false;
	self.notifyText2.alpha = 0;

	self.notifyIcon = createIcon( "white", iconSize, iconSize );
	self.notifyIcon setParent( self.notifyText2 );
	self.notifyIcon setPoint( point, relativePoint, 0, 5 );
	self.notifyIcon.hideWhenInMenu = true;
	self.notifyIcon.archived = false;
	self.notifyIcon.alpha = 0;

	self.notifyOverlay = createIcon( "white", iconSize, iconSize );
	self.notifyOverlay setParent( self.notifyIcon );
	self.notifyOverlay setPoint( "CENTER", "CENTER", 0, 5 );
	self.notifyOverlay.hideWhenInMenu = true;
	self.notifyOverlay.archived = false;
	self.notifyOverlay.alpha = 0;

	self.doingSplash = [];
	self.doingSplash[0] = undefined;
	self.doingSplash[1] = undefined;
	self.doingSplash[2] = undefined;
	self.doingSplash[3] = undefined;

	self.splashQueue = [];
	self.splashQueue[0] = [];
	self.splashQueue[1] = [];
	self.splashQueue[2] = [];
	self.splashQueue[3] = [];
}

customJoinedTeam() {
	self endon("disconnect");
	for(;;) {
		self waittill("joined_team");
	}
}

onMenuResponseReplace() {
	self endon("disconnect");
	
	for(;;) {
		self waittill("menuresponse", menu, response);
		
		if ( response == "back" ) {
			self closepopupMenu();
			self closeInGameMenu();

			if ( isOptionsMenuNew( menu ) ) {
				if( self.pers["team"] == "allies" )
					self openpopupMenu( game["menu_class_allies"] );
				if( self.pers["team"] == "axis" )
					self openpopupMenu( game["menu_class_axis"] );
			}
			continue;
		}
		if(response == "changeteam") {
			self closepopupMenu();
			self closeInGameMenu();
		}
		if(response == "changeclass_marines" ) {
			self closepopupMenu();
			self closeInGameMenu();
			continue;
		}
		if(response == "changeclass_opfor" ) {
			self closepopupMenu();
			self closeInGameMenu();
			continue;
		}
		if(response == "endgame") {
			if(level.splitscreen) {
				endparty();
				if ( !level.gameEnded )
					level thread maps\mp\gametypes\_gamelogic::forceEnd();
			}
			continue;
		}
		if ( response == "endround" ) {
			if ( !level.gameEnded )
				level thread maps\mp\gametypes\_gamelogic::forceEnd();
			else {
				self closepopupMenu();
				self closeInGameMenu();
				self iprintln( &"MP_HOST_ENDGAME_RESPONSE" );
			}			
			continue;
		}
		if(menu == game["menu_team"]) {
			switch(response) {
				case "allies":
					self [[level.allies]]();
					break;

				case "axis":
					self [[level.axis]]();
					break;

				case "autoassign":
					self [[level.autoassign]]();
					break;

				case "spectator":
					self [[level.spectator]]();
					break;
			}
		}
		else if ( menu == game["menu_changeclass"] || ( isDefined( game["menu_changeclass_defaults_splitscreen"] ) && menu == game["menu_changeclass_defaults_splitscreen"] ) || ( isDefined( game["menu_changeclass_custom_splitscreen"] ) && menu == game["menu_changeclass_custom_splitscreen"] ) ) {
			self closepopupMenu();
			self closeInGameMenu();
		
			self.selectedClass = true;
			self [[level.class]](response);
		}
		else if ( !level.console ) {
			if(menu == game["menu_quickcommands"])
				maps\mp\gametypes\_quickmessages::quickcommands(response);
			else if(menu == game["menu_quickstatements"])
				maps\mp\gametypes\_quickmessages::quickstatements(response);
			else if(menu == game["menu_quickresponses"])
				maps\mp\gametypes\_quickmessages::quickresponses(response);
		}
	}
}

isOptionsMenuNew( menu ) {
	if ( menu == game["menu_changeclass"] )
		return true;
		
	if ( menu == game["menu_team"] )
		return true;

	if ( menu == game["menu_controls"] )
		return true;

	if ( isSubStr( menu, "pc_options" ) )
		return true;

	return false;
}



















