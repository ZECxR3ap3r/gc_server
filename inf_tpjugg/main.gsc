#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_hud_message;
#include maps\mp\gametypes\infect;
#include scripts\inf_tpjugg\zombie;
#include maps\mp\killstreaks\_airdrop;

// vector killstreakweaponreplacething
// helicopter move down or increase range some shit like that
// maybe door health on firingrange edit



main() {

	replacefunc(::updateMainMenu, ::blanky);
	replacefunc(maps\mp\gametypes\_gamelogic::prematchPeriod, ::blanky);
	replacefunc(maps\mp\gametypes\_gamelogic::fixranktable, ::blanky);
	
	replacefunc(maps\mp\gametypes\_damage::doFinalKillcam, ::doFinalKillcam_edit);
    replacefunc(maps\mp\gametypes\_damage::handleNormalDeath, ::handleNormalDeath_edit);
	replacefunc(maps\mp\gametypes\_damage::handleSuicideDeath, ::handleSuicideDeath_edit);
	replacefunc(maps\mp\gametypes\_rank::init, ::_rank_init_edit);
	replacefunc(maps\mp\gametypes\_playerlogic::spawnplayer, ::spawnplayer_edit);


    replacefunc(maps\mp\killstreaks\_airdrop::init, ::_airdrop_init);
    replacefunc(maps\mp\gametypes\infect::chooseFirstInfected, ::_chooseFirstInfected);
    replacefunc(maps\mp\killstreaks\_remotemissile::MissileEyes, ::_MissileEyes);

    precachemenu("mainmenu");
    precachemenu("main_mod_settings");
	precachemenu("popup_leavegame");

    precachemenu("getclientdvar");
    precachemenu("youkilled_card_display");
    precachemenu("killedby_card_display");
    precachemenu("enter_prestige");
    precachemenu("sendclientdvar");
	precachemenu("ingame_controls");
	precacheMenu("scoreboard");
	precacheMenu("endgameupdate");

	precachemenu("quickmessage");
	precachemenu("quickcommands");
	precachemenu("quicksounds");
	// precachemenu("vipmenu");
}

///////////////////////////////// for zec mod stuff vvvvvvvvvvvvvvvvvvvvvvvvv /////////////////////////////////////////////////

spawnplayer_edit(cancer) {
	self endon( "disconnect" );
	self endon( "joined_spectators" );
	self notify( "spawned" );
	self notify( "end_respawn" );

    if(isDefined(self.setSpawnPoint) && self maps\mp\gametypes\_playerlogic::tiValidationCheck()) {
		spawnPoint = self.setSpawnPoint;

		self playLocalSound( "tactical_spawn" );

		if ( level.teamBased )
			self playSoundToTeam( "tactical_spawn", level.otherTeam[self.team] );
		else
			self playSound( "tactical_spawn" );

		spawnOrigin = self.setSpawnPoint.playerSpawnPos;
		spawnAngles = self.setSpawnPoint.angles;

        self.last_ti_spawn = gettime();

		if ( isDefined( self.setSpawnPoint.enemyTrigger ) )
			 self.setSpawnPoint.enemyTrigger Delete();

		self.setSpawnPoint delete();

		spawnPoint = undefined;
	}
	else {
		spawnPoint = self [[level.getSpawnPoint]]();
		spawnOrigin = spawnpoint.origin;
		spawnAngles = spawnpoint.angles;
	}

	self maps\mp\gametypes\_playerlogic::setSpawnVariables();

	hadSpawned = self.hasSpawned;
	self.fauxDead = undefined;
	self.killsThisLife = [];
	self maps\mp\gametypes\_playerlogic::updateSessionState( "playing", "" );
	self ClearKillcamState();
	self.cancelkillcam = 1;
	self.maxhealth = maps\mp\gametypes\_tweakables::getTweakableValue( "player", "maxhealth" );
	self.health = self.maxhealth;
	self.friendlydamage = undefined;
	self.hasSpawned = true;
	self.spawnTime = getTime();
	self.wasTI = !isDefined( spawnPoint );
	self.afk = false;
	self.lastStand = undefined;
	self.infinalStand = undefined;
	self.inC4Death = undefined;
	self.damagedPlayers = [];
	self.moveSpeedScaler = 1;
	self.killStreakScaler = 1;
	self.xpScaler = 1;
	self.objectiveScaler = 1;
	self.inLastStand = false;
	self.clampedHealth = undefined;
	self.shieldDamage = 0;
	self.shieldBulletHits = 0;
	self.recentShieldXP = 0;
	self.disabledWeapon = 0;
	self.disabledWeaponSwitch = 0;
	self.disabledOffhandWeapons = 0;
	self resetUsability();
	self.avoidKillstreakOnSpawnTimer = 5.0;

	self maps\mp\gametypes\_playerlogic::addToAliveCount();

	if(!self.wasAliveAtMatchStart) {
		acceptablePassedTime = 20;
		if ( getTimeLimit() > 0 && acceptablePassedTime < getTimeLimit() * 60 / 4 )
			acceptablePassedTime = getTimeLimit() * 60 / 4;

		if ( level.inGracePeriod || getTimePassed() < acceptablePassedTime * 1000 )
			self.wasAliveAtMatchStart = true;
	}

	if(!isdefined(self.thirdperson))
		self setClientDvar( "cg_thirdPerson", "0" );

	self setDepthOfField( 0, 0, 512, 512, 4, 0 );
	// self setClientDvar( "cg_fov", "65" );

	if(isDefined(spawnPoint)) {
		self maps\mp\gametypes\_spawnlogic::finalizeSpawnpointChoice( spawnpoint );
		spawnOrigin = maps\mp\gametypes\_playerlogic::getSpawnOrigin( spawnpoint );
		spawnAngles = spawnpoint.angles;
	}
	else
		self.lastSpawnTime = getTime();

	self.spawnPos = spawnOrigin;

	self spawn( spawnOrigin, spawnAngles );
	[[level.onSpawnPlayer]]();

	if ( isDefined( spawnPoint ) )
		self maps\mp\gametypes\_playerlogic::checkPredictedSpawnpointCorrectness( spawnPoint.origin );

	self maps\mp\gametypes\_missions::playerSpawned();

	prof_begin( "spawnPlayer_postUTS" );

	self maps\mp\gametypes\_class::setClass(self.class);
	self maps\mp\gametypes\_class::giveLoadout(self.team, self.class);

	if ( !gameFlag( "prematch_done" ) )
		self freezeControlsWrapper( true );
	else
		self freezeControlsWrapper( false );

	if ( !gameFlag( "prematch_done" ) || !hadSpawned && game["state"] == "playing" )
	{
		self setClientDvar( "scr_objectiveText", getObjectiveHintText( self.pers["team"] ) );

		team = self.pers["team"];

		if ( game["status"] == "overtime" )
			thread maps\mp\gametypes\_hud_message::oldNotifyMessage( game["strings"]["overtime"], game["strings"]["overtime_hint"], undefined, (1, 0, 0), "mp_last_stand" );
		else if ( getIntProperty( "useRelativeTeamColors", 0 ) )
			thread maps\mp\gametypes\_hud_message::oldNotifyMessage( game["strings"][team + "_name"], undefined, game["icons"][team] + "_blue", game["colors"]["blue"] );
		else
			thread maps\mp\gametypes\_hud_message::oldNotifyMessage( game["strings"][team + "_name"], undefined, game["icons"][team], game["colors"][team] );

		thread maps\mp\gametypes\_playerlogic::showSpawnNotifies();
	}

	// if ( !level.splitscreen && getIntProperty( "scr_showperksonspawn", 1 ) == 1 && game["state"] != "postgame" ) { // disabling cause fuck u
	// 	self openMenu( "perk_display" );
	// 	self thread maps\mp\gametypes\_playerlogic::hidePerksAfterTime( 4.0 );
	// 	self thread maps\mp\gametypes\_playerlogic::hidePerksOnDeath();
	// }

	prof_end( "spawnPlayer_postUTS" );
	waittillframeend;
	self.spawningAfterRemoteDeath = undefined;

	self notify( "spawned_player" );
	level notify ( "player_spawned", self );

	if(game["state"] == "postgame") {
		assert( !level.intermission );
		self maps\mp\gametypes\_gamelogic::freezePlayerForRoundEnd();
	}
}

doFinalKillcam_edit() {
	level waittill ( "round_end_finished" );

	level.showingFinalKillcam = true;

	winner = "none";
	if( IsDefined( level.finalKillCam_winner ) )
		winner = level.finalKillCam_winner;

	delay = level.finalKillCam_delay[ winner ];
	victim = level.finalKillCam_victim[ winner ];
	attacker = level.finalKillCam_attacker[ winner ];
	attackerNum = level.finalKillCam_attackerNum[ winner ];
	killCamEntityIndex = level.finalKillCam_killCamEntityIndex[ winner ];
	killCamEntityStartTime = level.finalKillCam_killCamEntityStartTime[ winner ];
	sWeapon = level.finalKillCam_sWeapon[ winner ];
	deathTimeOffset = level.finalKillCam_deathTimeOffset[ winner ];
	psOffsetTime = level.finalKillCam_psOffsetTime[ winner ];
	timeRecorded = level.finalKillCam_timeRecorded[ winner ];
	timeGameEnded = level.finalKillCam_timeGameEnded[ winner ];

	if( !isDefined( victim ) ||
		!isDefined( attacker ) )
	{
		level.showingFinalKillcam = false;
		level notify( "final_killcam_done" );
		return;
	}

	// if the killcam happened longer than 15 seconds ago, don't show it
	killCamBufferTime = 15;
	killCamOffsetTime = timeGameEnded - timeRecorded;
	if( killCamOffsetTime > killCamBufferTime )
	{
		level.showingFinalKillcam = false;
		level notify( "final_killcam_done" );
		return;
	}

	if ( isDefined( attacker ) )
		attacker.finalKill = true;

	postDeathDelay = (( getTime() - victim.deathTime ) / 1000);

	foreach(player in level.players){
		player closePopupMenu();
		player closeInGameMenu();
		if( IsDefined( level.nukeDetonated ) && player.player_settings["render_skybox"] == 1 )
			player VisionSetNakedForPlayer( level.nukeVisionSet, 0 );
		else
			player VisionSetNakedForPlayer( "", 0 ); // go to default visionset

        player setclientdvars("ui_playercard_prestige", attacker.player_settings["prestige"], "playercard_type", attacker.player_settings["conv_card"]);

		player.killcamentitylookat = victim getEntityNumber();

		if ( (player != victim || (!isRoundBased() || isLastRound())) && player _hasPerk( "specialty_copycat" ) )
			player _unsetPerk( "specialty_copycat" );

		player thread maps\mp\gametypes\_killcam::killcam( attackerNum, killcamentityindex, killcamentitystarttime, sWeapon, postDeathDelay + deathTimeOffset, psOffsetTime, 0, 10000, attacker, victim );
	}

	wait .1;

	while ( maps\mp\gametypes\_damage::anyPlayersInKillcam() )
		wait .05;

	level notify( "final_killcam_done" );
	level.showingFinalKillcam = false;
}

registerScoreInfo( type, value )
{ level.scoreInfo[type]["value"] = value; }

_rank_init_edit() {
	level.scoreInfo = [];
	level.xpScale = getDvarInt( "scr_xpscale" );

	if ( level.xpScale > 4 || level.xpScale < 0)
		exitLevel( false );

    registerScoreInfo( "kill", 50 );
	registerScoreInfo( "headshot", 50 );
	registerScoreInfo( "assist", 10 );
	registerScoreInfo( "suicide", 0 );
	registerScoreInfo( "teamkill", 0 );
    registerScoreInfo( "final_rogue", 200 );
	registerScoreInfo( "draft_rogue", 100 );
	registerScoreInfo( "survivor", 100 );
	registerScoreInfo( "win", 1 );
	registerScoreInfo( "loss", 0.5 );
	registerScoreInfo( "tie", 0.75 );
	registerScoreInfo( "capture", 300 );
	registerScoreInfo( "defend", 300 );

	level.xpScale = min( level.xpScale, 4 );
	level.xpScale = max( level.xpScale, 0 );

	level.rankTable = [];
	level.weaponRankTable = [];

	precacheShader("white");

	precacheString( &"RANK_PLAYER_WAS_PROMOTED_N" );
	precacheString( &"RANK_PLAYER_WAS_PROMOTED" );
	precacheString( &"RANK_WEAPON_WAS_PROMOTED" );
	precacheString( &"RANK_PROMOTED" );
	precacheString( &"RANK_PROMOTED_WEAPON" );
	precacheString( &"MP_PLUS" );
	precacheString( &"RANK_ROMANI" );
	precacheString( &"RANK_ROMANII" );
	precacheString( &"RANK_ROMANIII" );

	precacheString( &"SPLASHES_LONGSHOT" );
	precacheString( &"SPLASHES_PROXIMITYASSIST" );
	precacheString( &"SPLASHES_PROXIMITYKILL" );
	precacheString( &"SPLASHES_EXECUTION" );
	precacheString( &"SPLASHES_AVENGER" );
	precacheString( &"SPLASHES_ASSISTEDSUICIDE" );
	precacheString( &"SPLASHES_DEFENDER" );
	precacheString( &"SPLASHES_POSTHUMOUS" );
	precacheString( &"SPLASHES_REVENGE" );
	precacheString( &"SPLASHES_DOUBLEKILL" );
	precacheString( &"SPLASHES_TRIPLEKILL" );
	precacheString( &"SPLASHES_MULTIKILL" );
	precacheString( &"SPLASHES_BUZZKILL" );
	precacheString( &"SPLASHES_COMEBACK" );
	precacheString( &"SPLASHES_KNIFETHROW" );
	precacheString( &"SPLASHES_ONE_SHOT_KILL" );

	level.maxRank = int(tableLookup( "mp/rankTable.csv", 0, "maxrank", 1 ));
	level.maxPrestige = int(tableLookup( "mp/rankIconTable.csv", 0, "maxprestige", 1 ));

	rankId = 0;
	rankName = tableLookup( "mp/ranktable.csv", 0, rankId, 1 );

	while ( isDefined( rankName ) && rankName != "" )
	{
		level.rankTable[rankId][1] = tableLookup( "mp/ranktable.csv", 0, rankId, 1 );
		level.rankTable[rankId][2] = tableLookup( "mp/ranktable.csv", 0, rankId, 2 );
		level.rankTable[rankId][3] = tableLookup( "mp/ranktable.csv", 0, rankId, 3 );
		level.rankTable[rankId][7] = tableLookup( "mp/ranktable.csv", 0, rankId, 7 );

		precacheString( tableLookupIString( "mp/ranktable.csv", 0, rankId, 16 ) );

		rankId++;
		rankName = tableLookup( "mp/ranktable.csv", 0, rankId, 1 );
	}

	weaponMaxRank = int(tableLookup( "mp/weaponRankTable.csv", 0, "maxrank", 1 ));
	for( i = 0; i < weaponMaxRank + 1; i++ )
	{
		level.weaponRankTable[i][1] = tableLookup( "mp/weaponRankTable.csv", 0, i, 1 );
		level.weaponRankTable[i][2] = tableLookup( "mp/weaponRankTable.csv", 0, i, 2 );
		level.weaponRankTable[i][3] = tableLookup( "mp/weaponRankTable.csv", 0, i, 3 );
	}

	level thread maps\mp\gametypes\_rank::patientZeroWaiter();
	level thread maps\mp\gametypes\_rank::onPlayerConnect();
}

handleNormalDeath_edit( lifeId, attacker, eInflictor, sWeapon, sMeansOfDeath ) {
	attacker thread maps\mp\_events::killedPlayer( lifeId, self, sWeapon, sMeansOfDeath );

    self setclientdvars("ui_playercard_prestige", attacker.player_settings["prestige"], "playercard_type", attacker.player_settings["conv_card"]);
    attacker setclientdvars("ui_playercard_prestige", self.player_settings["prestige"], "playercard_type", self.player_settings["conv_card"]);

	attacker SetCardDisplaySlot( self, 8 );
	attacker openMenu( "youkilled_card_display" );

	self SetCardDisplaySlot( attacker, 7 );
	self openMenu( "killedby_card_display" );

	if ( sMeansOfDeath == "MOD_HEAD_SHOT" ) {
		attacker incPersStat( "headshots", 1 );
		attacker.headshots = attacker getPersStat( "headshots" );
		attacker incPlayerStat( "headshots", 1 );

		if ( isDefined( attacker.lastStand ) )
			value = maps\mp\gametypes\_rank::getScoreInfoValue( "kill" ) * 2;
		else
			value = undefined;

		attacker playLocalSound( "bullet_impact_headshot_2" );
	}
	else {
		if ( isDefined( attacker.lastStand ) )
			value = maps\mp\gametypes\_rank::getScoreInfoValue( "kill" ) * 2;
		else
			value = undefined;
	}

	attacker thread maps\mp\gametypes\_rank::giveRankXP( "kill", value, sWeapon, sMeansOfDeath );

	attacker incPersStat( "kills", 1 );
	attacker.kills = attacker getPersStat( "kills" );
	attacker updatePersRatio( "kdRatio", "kills", "deaths" );
	attacker maps\mp\gametypes\_persistence::statSetChild( "round", "kills", attacker.kills );
	attacker incPlayerStat( "kills", 1 );

	lastKillStreak = attacker.pers["cur_kill_streak"];

	if ( isAlive( attacker ) || attacker.streakType == "support" ) {
		if ( attacker killShouldAddToKillstreak( sWeapon ) ) {
			attacker thread maps\mp\killstreaks\_killstreaks::giveAdrenaline( "kill" );
			attacker.pers["cur_kill_streak"]++;

			if( !isKillstreakWeapon( sWeapon ) )
				attacker.pers["cur_kill_streak_for_nuke"]++;

			numKills = 25;
			if( attacker _hasPerk( "specialty_hardline" ) )
				numKills--;

			if( !isKillstreakWeapon( sWeapon ) && attacker.pers["cur_kill_streak_for_nuke"] == numKills && !isdefined(attacker.hasnuke)) {
                attacker.hasnuke = 1;
				attacker thread maps\mp\killstreaks\_killstreaks::giveKillstreak( "nuke", false, true, attacker, true );
				attacker thread maps\mp\gametypes\_hud_message::killstreakSplashNotify( "nuke", numKills );
			}
		}

		attacker setPlayerStatIfGreater( "killstreak", attacker.pers["cur_kill_streak"] );

		if ( attacker.pers["cur_kill_streak"] > attacker getPersStat( "longestStreak" ) )
			attacker setPersStat( "longestStreak", attacker.pers["cur_kill_streak"] );
	}

	attacker.pers["cur_death_streak"] = 0;

	if(attacker.pers["cur_kill_streak"] > attacker maps\mp\gametypes\_persistence::statGetChild( "round", "killStreak") )
		attacker maps\mp\gametypes\_persistence::statSetChild( "round", "killStreak", attacker.pers["cur_kill_streak"] );

	if(attacker.pers["cur_kill_streak"] > attacker.kill_streak) {
		attacker maps\mp\gametypes\_persistence::statSet( "killStreak", attacker.pers["cur_kill_streak"] );
		attacker.kill_streak = attacker.pers["cur_kill_streak"];
	}

	maps\mp\gametypes\_gamescore::givePlayerScore( "kill", attacker, self );
	maps\mp\_skill::processKill( attacker, self );

	if ( isDefined( level.ac130player ) && level.ac130player == attacker )
		level notify( "ai_killed", self );

	//if ( lastKillStreak != attacker.pers["cur_kill_streak"] )
	level notify ( "player_got_killstreak_" + attacker.pers["cur_kill_streak"], attacker );
	attacker notify( "got_killstreak" , attacker.pers["cur_kill_streak"] );

	attacker notify ( "killed_enemy" );

	if(isDefined(self.UAVRemoteMarkedBy)) {
		if ( self.UAVRemoteMarkedBy != attacker )
			self.UAVRemoteMarkedBy thread maps\mp\killstreaks\_remoteuav::remoteUAV_processTaggedAssist( self );
		self.UAVRemoteMarkedBy = undefined;
	}

	if ( isDefined( level.onNormalDeath ) && attacker.pers[ "team" ] != "spectator" )
		[[ level.onNormalDeath ]]( self, attacker, lifeId );

	if ( !level.teamBased ) {
		self.attackers = [];
		return;
	}

	level thread maps\mp\gametypes\_battlechatter_mp::sayLocalSoundDelayed( attacker, "kill", 0.75 );

	if ( isDefined( self.lastAttackedShieldPlayer ) && isDefined( self.lastAttackedShieldTime ) && self.lastAttackedShieldPlayer != attacker )
	{
		if ( getTime() - self.lastAttackedShieldTime < 2500 )
		{
			self.lastAttackedShieldPlayer thread maps\mp\gametypes\_gamescore::processShieldAssist( self );

			// if you are using the assists perk, then every assist is a kill towards a killstreak
			if( self.lastAttackedShieldPlayer _hasPerk( "specialty_assists" ) )
			{
				self.lastAttackedShieldPlayer.pers["assistsToKill"]++;

				if( !( self.lastAttackedShieldPlayer.pers["assistsToKill"] % 2 ) )
				{
					self.lastAttackedShieldPlayer maps\mp\gametypes\_missions::processChallenge( "ch_hardlineassists" );
					self.lastAttackedShieldPlayer maps\mp\killstreaks\_killstreaks::giveAdrenaline( "kill" );
					self.lastAttackedShieldPlayer.pers["cur_kill_streak"]++;
				}
			}
			else
			{
				self.lastAttackedShieldPlayer.pers["assistsToKill"] = 0;
			}
		}
		else if ( isAlive( self.lastAttackedShieldPlayer ) && getTime() - self.lastAttackedShieldTime < 5000 )
		{
			forwardVec = vectorNormalize( anglesToForward( self.angles ) );
			shieldVec = vectorNormalize( self.lastAttackedShieldPlayer.origin - self.origin );

			if ( vectorDot( shieldVec, forwardVec ) > 0.925 )
			{
				self.lastAttackedShieldPlayer thread maps\mp\gametypes\_gamescore::processShieldAssist( self );

				if( self.lastAttackedShieldPlayer _hasPerk( "specialty_assists" ) )
				{
					self.lastAttackedShieldPlayer.pers["assistsToKill"]++;

					if( !( self.lastAttackedShieldPlayer.pers["assistsToKill"] % 2 ) )
					{
						self.lastAttackedShieldPlayer maps\mp\gametypes\_missions::processChallenge( "ch_hardlineassists" );
						self.lastAttackedShieldPlayer maps\mp\killstreaks\_killstreaks::giveAdrenaline( "kill" );
						self.lastAttackedShieldPlayer.pers["cur_kill_streak"]++;
					}
				}
				else
				{
					self.lastAttackedShieldPlayer.pers["assistsToKill"] = 0;
				}
			}
		}
	}

	if ( isDefined( self.attackers )) {
		foreach ( player in self.attackers ) {
			if ( !isDefined( player ) )
				continue;

			if ( player == attacker )
				continue;

			player thread maps\mp\gametypes\_gamescore::processAssist( self );

			if( player _hasPerk( "specialty_assists" ) ) {
				player.pers["assistsToKill"]++;

				if( !( player.pers["assistsToKill"] % 2 ) ) {
					player maps\mp\gametypes\_missions::processChallenge( "ch_hardlineassists" );
					player maps\mp\killstreaks\_killstreaks::giveAdrenaline( "kill" );
					player.pers["cur_kill_streak"]++;

					numKills = 25;
					if( player _hasPerk( "specialty_hardline" ) )
						numKills--;

					if( player.pers["cur_kill_streak"] == numKills && !isdefined(player.hasnuke)) {
                        player.hasnuke = 1;
						player thread maps\mp\killstreaks\_killstreaks::giveKillstreak( "nuke", false, true, player, true );
						player thread maps\mp\gametypes\_hud_message::killstreakSplashNotify( "nuke", numKills );
					}
				}
			}
			else
				player.pers["assistsToKill"] = 0;
		}
		self.attackers = [];
	}
}

handleSuicideDeath_edit( sMeansOfDeath, sHitLoc ) {
    self setclientdvars("ui_playercard_prestige", self.player_settings["prestige"], "playercard_type", self.player_settings["conv_card"]);

	self SetCardDisplaySlot( self, 7 );
	self openMenu( "killedby_card_display" );

	self thread [[ level.onXPEvent ]]( "suicide" );
	self incPersStat( "suicides", 1 );
	self.suicides = self getPersStat( "suicides" );

	if ( sMeansOfDeath == "MOD_SUICIDE" && sHitLoc == "none" && isDefined( self.throwingGrenade ) )
		self.lastGrenadeSuicideTime = gettime();
}

enter_prestige() {
    if(self.player_settings["xp"] == 1746199 && self.player_settings["prestige"] < level.maxPrestige) {
		var_1 = self maps\mp\gametypes\_rank::getRankForXp(0);
		self.player_settings["xp"] = 0;

		var_2 = self.player_settings["prestige"] + 1;
        self.player_settings["prestige"] = var_2;

		self setRank( var_1, var_2 );

		self tell_raw("^8^7[ ^8Information ^7]: You Are Now Prestige ^8" + var_2);
        iprintln("^8" + self.name + "^7 is now Prestige: ^8" + var_2);

        self setclientdvar("inf_prestige", self.player_settings["prestige"]);

        self notify("player_stats_updated");
	}
}

menu_handler() {
    self endon("disconnect");

    base_keys = getarraykeys(level.base_values);

    while(1) {
        self waittill("menuresponse", menu, response);

		// print(menu, response);

		if ( response == "back" )
		{
			self closepopupMenu();
			self closeInGameMenu();
			continue;
		}

        self setclientdvars("inf_prestige", self.player_settings["prestige"], "inf_moabs", self.player_settings["called_in_moabs"], "inf_cancel_moabs", self.player_settings["cancelled_moabs"]);

        if(response == "enter_prestige")
            self thread enter_prestige();

        if(menu == "main_mod_settings") {
            if(issubstr(response, "prestige_selected")) {
                for(i = 0;i < level.maxPrestige + 1;i++) {
                    if(response == "prestige_selected_" + i) {
                        if(self.player_settings["prestige"] >= i) {
                            self.player_settings["choosen_pres"] = i;
                            self setrank(self.rank, self.player_settings["choosen_pres"]);
                            self notify("player_stats_updated");
                            self tell_raw("^8^7[ ^8Information ^7]: Prestige Icon Successfully Updated!");
                        }
                    }
                }
            }
            else if(issubstr(response, "calling_cards/")) {
                card = self scripts\_global_files\player_stats::convert_callingcard_data(response);

                if(isdefined(card)) {
                    self.player_settings["conv_card"] = card;
                    self tell_raw("^8^7[ ^8Information ^7]: Callingcard Successfully Updated!");
                    self notify("player_stats_updated");
                }
            }
            else if(issubstr(response, "inf_settings_")) {
                for(i = 0;i < base_keys.size;i++) {
                    if(response == "inf_settings_" + base_keys[i]) {
                        if(self.player_settings[base_keys[i]] == 0)
                            self.player_settings[base_keys[i]] = 1;
                        else if(self.player_settings[base_keys[i]] == 1)
                            self.player_settings[base_keys[i]] = 0;

                        if(response == "inf_settings_ui_scorelimit") {
                            if(self.player_settings["ui_scorelimit"] == 1)
                                self setclientdvar("inf_scorelimit", 18);
                            else
                                self setclientdvar("inf_scorelimit", 0);
                        }

                        self notify("player_stats_updated");
                    }
                }
            }
            else if(issubstr(response, "teamcolor_surv_")) {
                if(response == "teamcolor_surv_1") {
                    self.player_settings["inf_teamcolor_surv"] = 1;
                    self tell_raw("^8^7[ ^8Information ^7]: Teamcolor for ^:Survivors^7 Changed to ^8Blue");
                    self SetClientDvars("inf_teamcolor_surv", self.player_settings["inf_teamcolor_surv"], "cg_teamcolor_allies", ".15 .15 .85 1");
                    self notify("player_stats_updated");
                }
                else if(response == "teamcolor_surv_2") {
                    self.player_settings["inf_teamcolor_surv"] = 2;
                    self tell_raw("^8^7[ ^8Information ^7]: Teamcolor for ^:Survivors^7 Changed to ^8Pink");
                    self SetClientDvars("inf_teamcolor_surv", self.player_settings["inf_teamcolor_surv"], "cg_teamcolor_allies", "1 0.41 0.71 1");
                    self notify("player_stats_updated");
                }
                else if(response == "teamcolor_surv_3") {
                    self.player_settings["inf_teamcolor_surv"] = 3;
                    self tell_raw("^8^7[ ^8Information ^7]: Teamcolor for ^:Survivors^7 Changed to ^8Green");
                    self SetClientDvars("inf_teamcolor_surv", self.player_settings["inf_teamcolor_surv"], "cg_teamcolor_allies", ".15 .85 .15 1");
                    self notify("player_stats_updated");
                }
                else if(response == "teamcolor_surv_4") {
                    self.player_settings["inf_teamcolor_surv"] = 4;
                    self tell_raw("^8^7[ ^8Information ^7]: Teamcolor for ^:Survivors^7 Changed to ^8Red");
                    self SetClientDvars("inf_teamcolor_surv", self.player_settings["inf_teamcolor_surv"], "cg_teamcolor_allies", ".85 .15 .15 1");
                    self notify("player_stats_updated");
                }
                else if(response == "teamcolor_surv_5") {
                    self.player_settings["inf_teamcolor_surv"] = 5;
                    self tell_raw("^8^7[ ^8Information ^7]: Teamcolor for ^:Survivors^7 Changed to ^8Yellow");
                    self SetClientDvars("inf_teamcolor_surv", self.player_settings["inf_teamcolor_surv"], "cg_teamcolor_allies", ".85 .85 .15 1");
                    self notify("player_stats_updated");
                }
                else if(response == "teamcolor_surv_6") {
                    self.player_settings["inf_teamcolor_surv"] = 6;
                    self tell_raw("^8^7[ ^8Information ^7]: Teamcolor for ^:Survivors^7 Changed to ^8Orange");
                    self SetClientDvars("inf_teamcolor_surv", self.player_settings["inf_teamcolor_surv"], "cg_teamcolor_allies", "1 0.5 0 1");
                    self notify("player_stats_updated");
                }
                else if(response == "teamcolor_surv_7") {
                    self.player_settings["inf_teamcolor_surv"] = 7;
                    self tell_raw("^8^7[ ^8Information ^7]: Teamcolor for ^:Survivors^7 Changed to ^8Cyan");
                    self SetClientDvars("inf_teamcolor_surv", self.player_settings["inf_teamcolor_surv"], "cg_teamcolor_allies", ".15 .85 .85 1");
                    self notify("player_stats_updated");
                }
                else if(response == "teamcolor_surv_8") {
                    self.player_settings["inf_teamcolor_surv"] = 8;
                    self tell_raw("^8^7[ ^8Information ^7]: Teamcolor for ^:Survivors^7 Changed to ^8Purple");
                    self SetClientDvars("inf_teamcolor_surv", self.player_settings["inf_teamcolor_surv"], "cg_teamcolor_allies", "0.5 0 0.5 1");
                    self notify("player_stats_updated");
                }
                else if(response == "teamcolor_surv_0") {
                    self.player_settings["inf_teamcolor_surv"] = 0;
                    self tell_raw("^8^7[ ^8Information ^7]: Teamcolor for ^:Survivors^7 Changed to ^8Default");
                    self SetClientDvars("inf_teamcolor_surv", self.player_settings["inf_teamcolor_surv"], "cg_teamcolor_allies", "0 .7 1 1");
                    self notify("player_stats_updated");
                }
            }
            else if(issubstr(response, "teamcolor_inf_")) {
                if(response == "teamcolor_inf_1") {
                    self.player_settings["inf_teamcolor_inf"] = 1;
                    self tell_raw("^8^7[ ^8Information ^7]: Teamcolor for ^:Infected^7 Changed to ^8Blue");
                    self SetClientDvars("inf_teamcolor_inf", self.player_settings["inf_teamcolor_inf"], "cg_teamcolor_axis", ".15 .15 .85 1");  // Blue
                    self notify("player_stats_updated");
                }
                else if(response == "teamcolor_inf_2") {
                    self.player_settings["inf_teamcolor_inf"] = 2;
                    self tell_raw("^8^7[ ^8Information ^7]: Teamcolor for ^:Infected^7 Changed to ^8Pink");
                    self SetClientDvars("inf_teamcolor_inf", self.player_settings["inf_teamcolor_inf"], "cg_teamcolor_axis", "1 0.41 0.71 1");  // Pink
                    self notify("player_stats_updated");
                }
                else if(response == "teamcolor_inf_3") {
                    self.player_settings["inf_teamcolor_inf"] = 3;
                    self tell_raw("^8^7[ ^8Information ^7]: Teamcolor for ^:Infected^7 Changed to ^8Green");
                    self SetClientDvars("inf_teamcolor_inf", self.player_settings["inf_teamcolor_inf"], "cg_teamcolor_axis", ".15 .85 .15 1");  // Green
                    self notify("player_stats_updated");
                }
                else if(response == "teamcolor_inf_4") {
                    self.player_settings["inf_teamcolor_inf"] = 4;
                    self tell_raw("^8^7[ ^8Information ^7]: Teamcolor for ^:Infected^7 Changed to ^8Red");
                    self SetClientDvars("inf_teamcolor_inf", self.player_settings["inf_teamcolor_inf"], "cg_teamcolor_axis", ".85 .15 .15 1");  // Red
                    self notify("player_stats_updated");
                }
                else if(response == "teamcolor_inf_5") {
                    self.player_settings["inf_teamcolor_inf"] = 5;
                    self tell_raw("^8^7[ ^8Information ^7]: Teamcolor for ^:Infected^7 Changed to ^8Yellow");
                    self SetClientDvars("inf_teamcolor_inf", self.player_settings["inf_teamcolor_inf"], "cg_teamcolor_axis", ".85 .85 .15 1");  // Yellow
                    self notify("player_stats_updated");
                }
                else if(response == "teamcolor_inf_6") {
                    self.player_settings["inf_teamcolor_inf"] = 6;
                    self tell_raw("^8^7[ ^8Information ^7]: Teamcolor for ^:Infected^7 Changed to ^8Orange");
                    self SetClientDvars("inf_teamcolor_inf", self.player_settings["inf_teamcolor_inf"], "cg_teamcolor_axis", "1 0.5 0 1");  // Orange
                    self notify("player_stats_updated");
                }
                else if(response == "teamcolor_inf_7") {
                    self.player_settings["inf_teamcolor_inf"] = 7;
                    self tell_raw("^8^7[ ^8Information ^7]: Teamcolor for ^:Infected^7 Changed to ^8Cyan");
                    self SetClientDvars("inf_teamcolor_inf", self.player_settings["inf_teamcolor_inf"], "cg_teamcolor_axis", ".15 .85 .85 1");  // Cyan
                    self notify("player_stats_updated");
                }
                else if(response == "teamcolor_inf_8") {
                    self.player_settings["inf_teamcolor_inf"] = 8;
                    self tell_raw("^8^7[ ^8Information ^7]: Teamcolor for ^:Infected^7 Changed to ^8Purple");
                    self SetClientDvars("inf_teamcolor_inf", self.player_settings["inf_teamcolor_inf"], "cg_teamcolor_axis", "0.5 0 0.5 1");  // Purple
                    self notify("player_stats_updated");
                }
                else if(response == "teamcolor_inf_0") {
                    self.player_settings["inf_teamcolor_inf"] = 0;
                    self tell_raw("^8^7[ ^8Information ^7]: Teamcolor for ^:Infected^7 Changed to ^8Default");
                    self SetClientDvars("inf_teamcolor_inf", self.player_settings["inf_teamcolor_inf"], "cg_teamcolor_axis", "0 .7 1 1");  // Default
                    self notify("player_stats_updated");
                }
            }

            if(response == "inf_settings_render_skybox") {
                self tell_raw("^8^7[ ^8Information ^7]: Custom Skybox unavailable on ^5TP ^7Jugg");
                // if(self.player_settings["render_skybox"] == 0 && isdefined(self.skybox_model)) {
                //     self.skybox_model delete();
                //     self notify("skybox_change");
                // }
                // else if(self.player_settings["render_skybox"] == 1 && !isdefined(self.skybox_model) && level.skybox != 0)
                //     self thread scripts\inf_classic\main::change_skybox();
            }
        }
    }
}

getclientdvar(dvar) {
    wait 5;

    self setclientdvar("getting_dvar", "clantag");
    self openmenu("getclientdvar");

    while(1) {
        self waittill("menuresponse", menu, response);

        if(menu == "getclientdvar") {
            if(dvar == "clantag") {
                self.clantag = response;
                print("^5" + self.clantag);
                break;
            }
        }
    }
}

///////////////////////////////// for zec mod stuff ^^^^^^^^^^^^^^^^ /////////////////////////////////////////////////

init() {
    replacefunc(maps\mp\gametypes\infect::setinfectedmsg, ::setinfectedmsg_edit);
    replacefunc(maps\mp\killstreaks\_nuke::nuke_EMPJam, ::blank);
    replacefunc(maps\mp\killstreaks\_killstreaks::usedKillstreak, ::usedKillstreak_edit);
    replacefunc(maps\mp\killstreaks\_nuke::nukeSlowMo, ::blank);
    replacefunc(maps\mp\gametypes\_killcam::doFinalKillCamFX, ::disableDoFinalKillCamFX);
    replacefunc(::airDropMarkerActivate, ::_airDropMarkerActivate);
    replacefunc(::airdropDetonateOnStuck, ::_airdropDetonateOnStuck);
    replacefunc(maps\mp\killstreaks\_nuke::cancelnukeondeath, ::cancelnukefix);
	replacefunc(maps\mp\perks\_perkfunctions::GlowStickDamageListener, ::GlowStickDamageListener_replace);
    replacefunc(maps\mp\gametypes\_music_and_dialog::onPlayerSpawned, ::onPlayerSpawned_music_dialog); // for my sanity


    setdvar("prefix", "\r[ ^5TP JUGG^7 ] ");

    precacheshader("xp");
    precacheshader("hudcolorbar");

	SetDvar("scr_nukecancelmode", 1);
	// SetDvar("sv_cheats", 0);
	SetDvar("g_speed", 190);
	SetDvar("g_gravity", 800);
	SetDvar("jump_height", 39);
	SetDvar("player_sustainAmmo", 0);

	setdvar("g_scorescolor_allies", "0 .7 1 1");
	setdvar("g_scorescolor_axis", ".75 .25 .25 1");
	setdvar("g_teamname_allies", "^5SURVIVORS");
	setdvar("g_teamname_axis", "^1INFECTED");
	setdvar("g_teamicon_allies", "iw5_cardicon_sandman2");
	setdvar("g_teamicon_axis", "iw5_cardicon_juggernaut_a");

    game[ "strings" ][ "objective_hint_axis" ] = " ";
    game[ "strings" ][ "objective_hint_allies" ] = " ";

	if(getdvar("sv_sayname") != "^8^7[ ^8Gillette^7 ]")
    	setdvar("sv_sayname", "^8^7[ ^8Gillette^7 ]");

    stringy = "Welcome to INF ^5TP JUGG^7 | Join us on Discord ^5discord.gg/GilletteClan";
    if(getdvar("sv_motd") != stringy)
        setdvar("sv_motd", stringy);

    precacheshader("line_horizontal");
    precacheshader("iw5_cardtitle_specialty_veteran");
    precacheshader("waypoint_kill");
    precacheShader("compass_objpoint_ammo_friendly");
	precacheShader("compass_objpoint_trap_friendly");
	precacheShader("compass_objpoint_ammo_enemy");
	precacheShader("waypoint_ammo_friendly");
	precacheShader("dpad_killstreak_airdrop_trap");
	precacheheadicon("waypoint_ammo_friendly");
	precacheheadicon("dpad_killstreak_airdrop_trap");

    level.sentrySettings["sentry_minigun"].timeOut                = 45;
	level.sentrySettings["sentry_minigun"].maxHealth              = 400;
    level.turretSettings[ "mg_turret" ].maxHealth                 =	400;
    level.ospreySettings["escort_airdrop"].timeOut                = 40;
    level.ospreySettings["osprey_gunner"].timeOut                 = 50;
    level.turretSettings["mg_turret"].timeOut                     = 45;
    level.tankSettings["remote_tank"].timeOut                     = 90;
	level.tankSettings[ "remote_tank" ].maxHealth =				500;
	level.imsSettings[ "ims" ].lifeSpan =				180.0;
	level.imsSettings[ "ims" ].gracePeriod =			0.4; // time once triggered when it'll fire

	level.players_num_list = [];

	level.enable_debug_mode = getdvarint("sv_cheats");

    level thread on_connecting();
	level thread on_connect();
    level thread level_hud_handler();

	if(!level.enable_debug_mode)
		level thread check_players_in_map();


    level.map_name                      = getdvar("mapname");
    level.SpawnedPlayersCheck 			= [];

    if(isdefined(level.infect_timerDisplay)) {
    	level.infect_timerDisplay destroy();

    	level.infect_timerDisplay = createServerTimer("bigfixed", .5);
		level.infect_timerDisplay.horzalign = "fullscreen";
		level.infect_timerDisplay.vertalign = "fullscreen";
		level.infect_timerDisplay.alignx = "left";
		level.infect_timerDisplay.aligny = "middle";
		level.infect_timerDisplay.x = 5;
		level.infect_timerDisplay.y = 120;
		level.infect_timerDisplay.alpha = 0;
		level.infect_timerDisplay.archived = 0;
		level.infect_timerDisplay.hideWhenInMenu = 1;
    }

	seg_fontscale = .37;

	if(!isdefined(level.info_hud_elements))
		level.info_hud_elements = [];

    wait 1;

    level.infect_loadouts["allies"]["loadoutStreakType"] = "assault";
    level.infect_loadouts["allies"]["loadoutKillstreak1"] = "airdrop_assault";
    level.infect_loadouts["allies"]["loadoutKillstreak2"] = "airdrop_sentry_minigun";
    level.infect_loadouts["allies"]["loadoutKillstreak3"] = "none";
    level.infect_loadouts["allies"]["loadoutPerk1"] = "specialty_fastreload";
	level.infect_loadouts["allies"]["loadoutPerk2"] = "specialty_hardline";
	level.infect_loadouts["allies"]["loadoutPerk3"] = "specialty_bulletaccuracy";

    level.infect_loadouts["axis"]["loadoutDeathstreak"] = "specialty_null";

	// Challenges 
	ents = getentarray();
    foreach(ent in ents) {
        if(isdefined(ent.targetname) && ent.targetname == "destructible_toy") {
            if(isdefined(ent.model) && issubstr(ent.model, "chicken"))
                ent thread track_chicken_damage();
        }
    }
}


_chooseFirstInfected() {
    level endon("game_ended");
    level endon("infect_stopCountdown");

    level.infect_allowsuicide = 0;
    maps\mp\_utility::gameFlagWait( "prematch_done" );
	if(!isdefined(level.infect_timerDisplay)) {
    	level.infect_timerDisplay = createServerTimer("bigfixed", .5);
		level.infect_timerDisplay.horzalign = "fullscreen";
		level.infect_timerDisplay.vertalign = "fullscreen";
		level.infect_timerDisplay.alignx = "left";
		level.infect_timerDisplay.aligny = "middle";
		level.infect_timerDisplay.x = 5;
		level.infect_timerDisplay.y = 120;
		level.infect_timerDisplay.alpha = 0;
		level.infect_timerDisplay.archived = 0;
		level.infect_timerDisplay.hideWhenInMenu = 1;
    }
    level.infect_timerDisplay.label = &"Infection Countdown: ^8";
    level.infect_timerDisplay settimer(15);
    level.infect_timerDisplay.alpha = 1;
    maps\mp\gametypes\_hostmigration::waitLongDurationWithHostMigrationPause(15);
    level.infect_timerDisplay.alpha = 0;

	if(isdefined(level.infect_timerDisplay)) {
		level.infect_timerDisplay destroy();
	}

	if(str(tolower(getdvar("suicide_final"))) != "undefined") {
		for(i=0;i<level.players.size+1;i++) {
			if(i == level.players.size) {
				rnd = randomint(level.players.size);
				print("Failsafe System: ^3" + level.players[rnd].name + "^7 Selected As ^1First");
    			level.players[rnd] setfirstinfected(1);
				break;
			}
			else if(str(tolower(level.players[i].guid)) == tolower(getdvar("suicide_final")) ) {
				setdvar("suicide_final", "undefined");
				print("^3" + level.players[i].name + " ^1Suicide ^7Forced First");
				level.players[i] setfirstinfected(1);
				break;
			}
		}
	}
	else {
		setdvar("suicide_final", "undefined");
		rnd = randomint(level.players.size);
		print("Normal System: ^3" + level.players[rnd].name + "^7 Selected As ^1First");
    	level.players[rnd] setfirstinfected(1);
	}
}

on_connecting() {
    for(;;) {
        level waittill("connecting", player);

		if(level.players.size > 10) {
        	if(level.teamCount["allies"] <= 3)
        		player.spawnasinf = 1;
        }
    }
}

basegame_threads() {
	// self thread maps\mp\gametypes\_menus::onMenuResponse();
	self thread maps\mp\gametypes\_hud_message::hintMessageDeathThink();
	self thread maps\mp\gametypes\_hud_message::lowerMessageThink();
	self thread maps\mp\gametypes\_hud_message::initNotifyMessage();
}

soundtest() {
	for(;;) {
		wait 3;
		self PlaySound("quick_sound1");
		wait 3;
		self PlaySound("quick_sound2");
		wait 3;
		self PlaySound("quick_sound3");
		wait 3;
		self PlaySound("quick_sound4");
		wait 3;
		self PlaySound("quick_sound5");
		wait 3;
		self PlaySound("quick_sound6");
	}
}

on_connect() {
	while(1) {
		level waittill("connected", player);

		player thread basegame_threads();
		player.thirdperson = 0;
		player thread menuresponse_quickmenu();

		if(level.enable_debug_mode && getdvar("g_gametype") != "infect") {
			player maps\mp\gametypes\_menus::addToTeam( "allies" );
			player.pers["class"] = "CLASS_CUSTOM1";
			player.class = "CLASS_CUSTOM1";
			player notify("end_respawn");
			player iprintlnbold("Switch To INFECT Gametype");
		}

		print("^2" + player.name + "^7 - Connected");
		player SetClientDvar("lowAmmoWarningColor1", "0 0 0 0");
		player SetClientDvar("lowAmmoWarningColor2", "0 0 0 0");
		player SetClientDvar("lowAmmoWarningNoAmmoColor1", "0 0 0 0");
		player SetClientDvar("lowAmmoWarningNoAmmoColor2", "0 0 0 0");
		player SetClientDvar("lowAmmoWarningNoReloadColor1", "0 0 0 0");
		player SetClientDvar("lowAmmoWarningNoReloadColor2", "0 0 0 0");

        player SetClientDvar("cg_teamcolor_allies", "0 .7 1 1");
        player SetClientDvar("cg_teamcolor_axis", ".75 .25 .25 1");

		player setclientdvar("g_scriptMainMenu", "mainmenu");

        if(!isdefined(level.SpawnedPlayersCheck[player.guid]) && !isdefined(player.spawnasinf))
			level.SpawnedPlayersCheck[player.guid] = 1;
		else {
			player maps\mp\gametypes\_menus::addToTeam( "axis", 1 );
			maps\mp\gametypes\infect::updateTeamScores();
			player.infect_firstSpawn = 0;
			player.pers["class"] = "gamemode";
			player.pers["lastClass"] = "";
			player.class = player.pers["class"];
			player.lastClass = player.pers["lastClass"];
			foreach(players in level.players) {
				if(isDefined(players.isInitialInfected))
					players thread maps\mp\gametypes\infect::setInitialToNormalInfected();
			}
			if(isdefined(level.infect_timerdisplay) && level.infect_timerdisplay.alpha == 1)
				level.infect_timerdisplay.alpha = 0;
		}

        player.rtd_canroll          = 1;
        player.initial_spawn        = 0;
        player.hud_elements         = [];

        player thread equipment_handler();
        player thread on_spawned();
        player thread handle_door_huds();

		player thread semtex_hold_death_fix();
		player thread javelin_teamkill_fix();

        player.status = "out";
        player.inoomzone = 0;
        player.attackeddoor = 0;

        player thread scripts\inf_tpjugg\map_funcs::oomzonehud();

		// player thread player_joined_msg();
	}
}

menuresponse_quickmenu() {
	self endon("disconnect");
	for(;;) {
		self waittill("menuresponse", menu, response);
		// print("^3Menu: ^7" + menu + " ^3Response: ^7" + response);
		// self iprintln("^3Menu: ^7" + menu + " ^3Response: ^7" + response);
		
		if(menu == "quickcommands") {
			if(response == "thirdperson") {
				self.thirdperson = !self.thirdperson;
				self setclientdvar("cg_thirdperson", self.thirdperson);
			} else if(response == "suicide") {
				self suicide();
			}
		} else if(menu == "quicksounds") {
			if(self quicksound_allowed(response)) {
				can_sound = false;
				if(int(response) >= 3) {
					if(self isvipuser())
						can_sound = true;
					else
						self iprintln("^3VIP^7 Only");
				} else {
					can_sound = true;
				}

				if(can_sound) {
					self thread quicksound_cooldown(5);
					sound = "quick_sound" + response;
					self playsound(sound);
				}
			}
		}
	}
}

quicksound_cooldown(time) {
	self notify("quicksound_cooldownfunc");
	self endon("quicksound_cooldownfunc");

	self.quicksound_cooldown = time;
	for(i=time;i>0;i--) {
		self.quicksound_cooldown = i;
		wait 1;
	}
	self.quicksound_cooldown = undefined;
}

quicksound_allowed(response) {
	if(isdefined(level.admin_commands_clients[self.guid]) && level.admin_commands_clients[self.guid]["access"] >= 2) {
		return true;
	} else if(isdefined(self.quicksound_cooldown)) {
		self iprintln("^3Sound ^7Cooldown: ^5" + self.quicksound_cooldown);
		return false;
	} else
		return true;
}

player_joined_msg() {

	tok = StrTok(getdvar("connectionlist"), "->");
	cock = false;
	foreach(name in tok) {
		if(name == self.name)
			cock = true;
	}
	
	if(cock)
		return;
	
	setdvar("connectionlist", getdvar("connectionlist") + "->" + self.name);
	wait 0.5;
		
	foreach(player in level.players) {
		player tell_raw(getdvar("sv_sayname") + "^7: ^3" + self.name + "^7 Connected");
	}
}

setkickgraceover(time) {
	level endon("game_ended");
	self endon("disconnect");
	self endon("death");
	wait time;
	self.inmap_kick_graceperiod_over = true;
}

on_spawned() {
    self endon("disconnect");

    for(;;) {
        self waittill("spawned_player");


		//print("^2" + self.name + "^7 - Has Class - ^3" + self.pers["class"] + " / " + self.class);
        self SetClientDvar("cg_objectiveText", "visit us at ^8Gillette^7Clan.com\nJoin us on Discord ^8discord.gg/GilletteClan");

		self.flag_protection = undefined;

        if(self.initial_spawn == 0) {
        	self.initial_spawn = 1;

			self thread setkickgraceover(15);

			self notifyOnPlayerCommand("FpsFix_action", "vote no");
			self notifyOnPlayerCommand("Fullbright_action", "vote yes");
			self notifyOnPlayerCommand("suicide_action", "+actionslot 1");

			self thread doFps();
			self thread doFullbright();
			self thread suicidePlayer();
			self thread var_resetter();
            self thread hud_create();
			self thread menu_handler();
			self thread track_insertions();

            self thread Create_Xp_Bar();
        	if(!level.enable_debug_mode)
        		self thread adv_afk_check();
        }

        if(isDefined(self.laststatus) && isdefined(self.goodspawn)) {
            self.status = self.laststatus;
            self.laststatus = undefined;
            self.goodspawn = undefined;
        }
        else {
            self.laststatus = undefined;
            self.goodspawn = undefined;
        }

        if(self.SessionTeam == "axis") {
            self TakeAllWeapons();
            self SetOffhandPrimaryClass("throwingknife");
            self GiveWeapon("throwingknife_mp");

            self givePerk("specialty_tacticalinsertion", 1);
			self setViewKickScale( 0.5 );

            if(!isdefined(self.isInitialInfected)) {
                self GiveWeapon("iw5_usp45_mp_tactical");
                self SetWeaponAmmoClip("iw5_usp45_mp_tactical", 0);
                self SetWeaponAmmoStock("iw5_usp45_mp_tactical", 0);
                self setspawnweapon("iw5_usp45_mp_tactical");
				self notify("force_end_exp_tk");
                self maps\mp\killstreaks\_killstreaks::clearKillstreaks();

                if(self.rtd_canroll == 1 || level.enable_debug_mode) {
                    self ResetPlayer();
                    self thread roll_random_effect();
                }
            }
            else {
                self PowerfulJuggernaut();
                self GiveWeapon("riotshield_mp");
                self GiveWeapon("at4_mp");
				self SetWeaponAmmoClip("at4_mp", 1);
                self SetWeaponAmmoStock("at4_mp", 1);
                self setspawnweapon("at4_mp");
				self thread [[level.roll_items["exp_tk"].function]]();
				self setperk("specialty_fastreload", 1, 1);
            }

            if(!isdefined(self.initial_axis)) {
                self thread door_damage_handler();
                self.hud_elements["door_bind"] settext("^1Attack Door");

                self.initial_axis = 1;
            }
        }
        else if(self.SessionTeam == "allies") {
            self takeallweapons();

            self giveperk("trophy_mp", 0);
            self giveperk("claymore_mp", 0);
            self GiveWeapon(level.selected_starting_weapon);
            self GiveMaxAmmo(level.selected_starting_weapon);
			if(issubstr(level.selected_starting_weapon, "kriss"))
            	self switchtoweapon(level.selected_starting_weapon);
			else
            	self setspawnweapon(level.selected_starting_weapon);

            if(!isdefined(self.initial_allies)) {
                self.hud_elements["door_bind"] settext("^2Open ^7/ ^1Close");

                self.initial_allies = 1;
            }
        }

        self setperk("specialty_fastoffhand", 1, 1);

		if(self.team == "allies") {
			if(self.name == "Clippy" || self.name == "Sloth" || self.name == "QueasyNurples") {
				self detachall();
				self setmodel("mp_body_codo_cyberfemale");
				self setviewmodel("codo_vh_cyberfemale_iw5");
				self Attach("weapon_radar", "j_helmet", true);
			} 
			else {
				self detachall();
				self setmodel("mp_fb_t6_seal_assault_iw5");
				self setviewmodel("vh_t6_seal_longsleeve");
			}
		}
    }
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
        self.hud_element_xp["xp_bar_bg"] setShader("hudcolorbar", 800, 4);
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
        self.hud_element_xp["xp_double_xp"] settext(getdvarint("inf_xp")+"x");
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

	oldxp = self.player_settings["xp"] - 1;

	for(;;) {
		if(oldxp != self.player_settings["xp"]) {
			rank = self maps\mp\gametypes\_rank::getRankForXp(self.player_settings["xp"]);
			Temp_Min = maps\mp\gametypes\_rank::getRankInfoMinXp(rank);
			Temp_Max = maps\mp\gametypes\_rank::getRankInfoMaxXp(rank);

            string_max = "" + temp_max;

			Current_Xp_For_Rank = self.player_settings["xp"] - Temp_Min;
			Xp_Needed_For_Rankup = Temp_Max - Temp_Min;
			fraction = Current_Xp_For_Rank / (Xp_Needed_For_Rankup / 100);
			barwidth = int(fraction * (640 / 100));
			col = Red_To_Green(fraction);
			self.hud_element_xp["xp_bar"].color = col;
			self.hud_element_xp["xp_value"] SetValue(Current_Xp_For_Rank);
            self.hud_element_xp["xp_value_max"] SetValue(Xp_Needed_For_Rankup);
            self.hud_element_xp["xp_value"].color = col;
            self.hud_element_xp["xp_value_max"].color = col;

			self.hud_element_xp["xp_bar"] setShader("hudcolorbar", barwidth, 4);
			oldxp = self.player_settings["xp"];
			//print("^1Current_Xp_For_Rank: " + Current_Xp_For_Rank + "\n^2Xp_Needed_For_Rankup: " + Xp_Needed_For_Rankup + "\n^3fraction: " + fraction + "\n^4barwidth: " + barwidth);

			if(self.player_settings["xp"] == 1746200)
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

semtex_hold_death_fix() {
	self endon("disconnect");
	for(;;) {
		self waittill("grenade_fire", ent, weap);
		if(weap != "semtex_mp")
			continue;

		wait 0.1;
		if(!IsAlive(self) && isdefined(ent)){
			ent delete();
		}
	}
}

javelin_teamkill_fix() {
	self endon("disconnect");
	for(;;) {
		self waittill("missile_fire", missile, weap);
		if(weap == "javelin_mp" && self.team == "allies")
			self thread check_javelin_teamchange(missile);
	}
}

check_javelin_teamchange(missile) {
	while(isdefined(missile)) {
		wait 0.05;
		if(self.team != "allies")
			missile delete();
	}
}

adv_afk_check() {
	self endon("disconnect");
	level endon("game_ended");

	wait 3;

	arg = 0;

    while(1) {
		wait 1;
    	if(level.players.size > 3) {
			if(self.sessionstate == "spectator")
			 	continue;

	    	if(isdefined(self.isInitialInfected) && isAlive(self)) {
	    		org = self.origin;

	    		wait 1;

	    		if(isAlive(self)) {
					if(distance(org, self.origin) <= 30)
						arg++;
					else
						arg = 0;
				}

				if(isdefined(arg) && arg >= 30)
					kick(self getEntityNumber(), "EXE_PLAYERKICKED_INACTIVE");
			}
			else if(self.team == "axis" && isAlive(self)) {
				org = self.origin;

	    		wait 1;

				if(isAlive(self)) {
					if(distance(org, self.origin) <= 90)
						arg++;
					else
						arg = 0;
				}

				if(isdefined(arg) && arg >= 80)
					kick(self getEntityNumber(), "EXE_PLAYERKICKED_INACTIVE");
			}
			else
				wait 1;
		}
    }
}

check_players_in_map() {
	level endon("game_end");

	gameFlagWait( "prematch_done" );

	wait 1;
	if(!isdefined(level.meat_playable_bounds))
		return;

	start = gettime();
	part = GetDvarfloat("scr_" + getdvar("g_gametype") + "_timelimit") * 0.25;

	for(;;) {
		wait 5;
		//print(gettime() - start);
		if((gettime() - start >= part*60000)) {
			foreach(player in level.players) {
				if(player.team == "allies") {
					if(player.status == "in")
						continue;
					
					if(isdefined(player.inmap_kick_graceperiod_over) && !isdefined(player.not_in_edit_kick)) {
						player.not_in_edit_kick = true;
						player thread player_kick_warning();
					}
				}
			}
		}
	}
}

player_kick_warning() {
	self endon("disconnect");
	self endon("stop_my_asscheeks");
	kicktime = 15;
	if(!isdefined(self.hud_elements["about_to_kick"])) {
        self.hud_elements["about_to_kick"] = newclienthudelem(self);
        self.hud_elements["about_to_kick"].x = 230;
        self.hud_elements["about_to_kick"].y = 80;
        self.hud_elements["about_to_kick"].alignx = "left";
        self.hud_elements["about_to_kick"].aligny = "top";
        self.hud_elements["about_to_kick"].horzalign = "fullscreen";
        self.hud_elements["about_to_kick"].vertalign = "fullscreen";
        self.hud_elements["about_to_kick"].alpha = 1;
        self.hud_elements["about_to_kick"].color = (1, 1, 1);
        self.hud_elements["about_to_kick"].foreground = 0;
        self.hud_elements["about_to_kick"].HideWhenInMenu = 1;
        self.hud_elements["about_to_kick"].archived = 1;
        self.hud_elements["about_to_kick"].fontscale = 1.8;
        self.hud_elements["about_to_kick"].font = "objective";
        self.hud_elements["about_to_kick"].label = &"^7Getting ^1KICKED^7 In: ^1&&1\n^7Move Into The ^3Edit";
        self.hud_elements["about_to_kick"] setvalue(kicktime);
    }

	while(self.status == "out" && self.team == "allies") {
		self.hud_elements["about_to_kick"] setvalue(kicktime);
		if(kicktime <= 0) {
			kick(self getEntityNumber(), "EXE_PLAYERKICKED_INACTIVE");
			self notify("stop_my_asscheeks");
			break;
		}
		wait 1;
		kicktime--;
	}

	if(isdefined(self.hud_elements["about_to_kick"]))
		self.hud_elements["about_to_kick"] destroy();

	self.not_in_edit_kick = undefined;
}

handle_door_huds() {
	level endon("game_ended");
    self endon("disconnect");

    if(!isdefined(self.hud_elements["door_title"])) {
        self.hud_elements["door_title"] = newclienthudelem(self);
        self.hud_elements["door_title"].x = 320;
        self.hud_elements["door_title"].y = 258;
        self.hud_elements["door_title"].alignx = "center";
        self.hud_elements["door_title"].aligny = "top";
        self.hud_elements["door_title"].horzalign = "fullscreen";
        self.hud_elements["door_title"].vertalign = "fullscreen";
        self.hud_elements["door_title"].alpha = 0;
        self.hud_elements["door_title"].color = (1, 1, 1);
        self.hud_elements["door_title"].foreground = 0;
        self.hud_elements["door_title"].HideWhenInMenu = 1;
        self.hud_elements["door_title"].archived = 1;
        self.hud_elements["door_title"].fontscale = 1.3;
        self.hud_elements["door_title"].font = "small";
        self.hud_elements["door_title"].label = &"Door is: &&1";
    }

    if(!isdefined(self.hud_elements["door_hp_bar_bg"])) {
        self.hud_elements["door_hp_bar_bg"] = newclienthudelem(self);
        self.hud_elements["door_hp_bar_bg"].x = 320;
        self.hud_elements["door_hp_bar_bg"].y = 258 + 19;
        self.hud_elements["door_hp_bar_bg"].alignx = "center";
        self.hud_elements["door_hp_bar_bg"].aligny = "top";
        self.hud_elements["door_hp_bar_bg"].horzalign = "fullscreen";
        self.hud_elements["door_hp_bar_bg"].vertalign = "fullscreen";
        self.hud_elements["door_hp_bar_bg"].alpha = 0;
        self.hud_elements["door_hp_bar_bg"].color = (1, 1, 1);
        self.hud_elements["door_hp_bar_bg"].foreground = 0;
        self.hud_elements["door_hp_bar_bg"].sort = 0;
        self.hud_elements["door_hp_bar_bg"].HideWhenInMenu = 1;
        self.hud_elements["door_hp_bar_bg"].archived = 1;
        self.hud_elements["door_hp_bar_bg"] setshader("black", 120, 6);
    }

    if(!isdefined(self.hud_elements["door_hp_bar"])) {
        self.hud_elements["door_hp_bar"] = newclienthudelem(self);
        self.hud_elements["door_hp_bar"].x = 320 - 59;
        self.hud_elements["door_hp_bar"].y = 258 + 20;
        self.hud_elements["door_hp_bar"].alignx = "left";
        self.hud_elements["door_hp_bar"].aligny = "top";
        self.hud_elements["door_hp_bar"].horzalign = "fullscreen";
        self.hud_elements["door_hp_bar"].vertalign = "fullscreen";
        self.hud_elements["door_hp_bar"].alpha = 0;
        self.hud_elements["door_hp_bar"].color = (0, .5, 0);
        self.hud_elements["door_hp_bar"].sort = 1;
        self.hud_elements["door_hp_bar"].foreground = 0;
        self.hud_elements["door_hp_bar"].HideWhenInMenu = 1;
        self.hud_elements["door_hp_bar"].archived = 1;
        self.hud_elements["door_hp_bar"] setshader("white", 1, 4);
    }

    if(!isdefined(self.hud_elements["door_bind"])) {
        self.hud_elements["door_bind"] = newclienthudelem(self);
        self.hud_elements["door_bind"].x = 320;
        self.hud_elements["door_bind"].y = 258 + 130;
        self.hud_elements["door_bind"].alignx = "center";
        self.hud_elements["door_bind"].aligny = "top";
        self.hud_elements["door_bind"].horzalign = "fullscreen";
        self.hud_elements["door_bind"].vertalign = "fullscreen";
        self.hud_elements["door_bind"].alpha = 0;
        self.hud_elements["door_bind"].color = (1, 1, 1);
        self.hud_elements["door_bind"].foreground = 0;
        self.hud_elements["door_bind"].HideWhenInMenu = 1;
        self.hud_elements["door_bind"].archived = 1;
        self.hud_elements["door_bind"].fontscale = 1.3;
        self.hud_elements["door_bind"].font = "small";
        self.hud_elements["door_bind"].label = &"Press/Hold ^3[{+activate}]^7 to ";
    }

    state = "";

    while(1) {
        if(isdefined(self.touching_trigger)) {
            if(self.hud_elements["door_title"].alpha != 1)
                self.hud_elements["door_title"].alpha = 1;

            if(self.touching_trigger.state == "closed") {
                if(self.hud_elements["door_hp_bar"].alpha != .7) {
                    self.hud_elements["door_hp_bar"].alpha = .7;
                    self.hud_elements["door_hp_bar_bg"].alpha = .6;
                }

                if(self.hud_elements["door_bind"].alpha != 1)
                    self.hud_elements["door_bind"].alpha = 1;
            }
            else {
                if(self.hud_elements["door_hp_bar"].alpha != 0) {
                    self.hud_elements["door_hp_bar"].alpha = 0;
                    self.hud_elements["door_hp_bar_bg"].alpha = 0;
                }

                if(self.hud_elements["door_bind"].alpha != 1 && self.team == "allies")
                    self.hud_elements["door_bind"].alpha = 1;
            }

            if(self.touching_trigger.state != state) {
                if(self.touching_trigger.state == "open")
                    self.hud_elements["door_title"] settext("^2Open");
                else
                    self.hud_elements["door_title"] settext("^1Closed");

                state = self.touching_trigger.state;
            }

            if(self.touching_trigger.hp >= (self.touching_trigger.maxhp / 2))
                self.hud_elements["door_hp_bar"].color = (0, .5, 0);
            else if(self.touching_trigger.hp >= (self.touching_trigger.maxhp / 3))
                self.hud_elements["door_hp_bar"].color = (.5, .5, 0);
            else if(self.touching_trigger.hp >= (self.touching_trigger.maxhp / 5))
                self.hud_elements["door_hp_bar"].color = (.5, 0, 0);

            self.hud_elements["door_hp_bar"] setshader("white", int((self.touching_trigger.hp / self.touching_trigger.maxhp) * 118), 4);
        }
        else {
            self.save_origin = self.origin;

            if(self.hud_elements["door_title"].alpha != 0) {
                self.hud_elements["door_title"].alpha = 0;
                self.hud_elements["door_hp_bar"].alpha = 0;
                self.hud_elements["door_hp_bar_bg"].alpha = 0;
                self.hud_elements["door_bind"].alpha = 0;
            }
        }

        wait .1;
    }
}

door_damage_handler() {
    self endon("disconnect");

    while(1) {
        self waittill("door_damage");

        self.door_cooldown = 1;

        wait 1.5;

        self.door_cooldown = undefined;
    }
}

equipment_handler() {
    self endon("disconnect");

    for(;;) {
        self waittill("grenade_fire", grenade, weapName);

        if(weapName == "flare_mp" && self.sessionteam == "axis") {
            if(!isDefined(self.TISpawnPosition))
                continue;

            if(self touchingBadTrigger())
                continue;

            if(isDefined(level.meat_playable_bounds) && self.status == "in" && self deletetacifinzone()) {
                self.goodspawn = 1;
                self thread Checkgoodspawn();
                self.laststatus = "in";
            }
        }
        else if(weapName == "throwingknife_mp" && self.sessionteam == "axis")
            grenade thread timeoutdelete();
    }
}

usedKillstreak_edit(streakName, awardXp) {
	self playLocalSound("weap_c4detpack_trigger_plr");

	if(awardXp) {
		self thread [[ level.onXPEvent ]]( "killstreak_" + streakName);
		self thread maps\mp\gametypes\_missions::useHardpoint(streakName);
	}

    self.used_streak_team = self.team;

	awardref = maps\mp\_awards::getKillstreakAwardRef(streakName);
	if(IsDefined(awardref))
		self thread incPlayerStat(awardref, 1);

	if(maps\mp\killstreaks\_killstreaks::isAssaultKillstreak(streakName))
		self thread incPlayerStat("assaultkillstreaksused", 1);
	else if(maps\mp\killstreaks\_killstreaks::isSupportKillstreak(streakName))
		self thread incPlayerStat("supportkillstreaksused", 1);
	else if(maps\mp\killstreaks\_killstreaks::isSpecialistKillstreak(streakName)) {
		self thread incPlayerStat("specialistkillstreaksearned", 1);
		return;
	}

	team = self.team;
	if(level.teamBased) {
		thread leaderDialog( team + "_friendly_" + streakName + "_inbound", team );

		if(maps\mp\killstreaks\_killstreaks::getKillstreakInformEnemy(streakName))
			thread leaderDialog( team + "_enemy_" + streakName + "_inbound", level.otherTeam[ team ] );
	}
	else {
		self thread leaderDialogOnPlayer( team + "_friendly_" + streakName + "_inbound" );

		if(maps\mp\killstreaks\_killstreaks::getKillstreakInformEnemy(streakName)) {
			excludeList[0] = self;
			thread leaderDialog( team + "_enemy_" + streakName + "_inbound", undefined, undefined, excludeList );
		}
	}
}

setinfectedmsg_edit() {
    if ( isdefined( self.changingtoregularinfected ) ) {
        self.changingtoregularinfected = undefined;

        if ( isdefined( self.changingtoregularinfectedbykill ) ) {
            self.changingtoregularinfectedbykill = undefined;
            thread maps\mp\gametypes\_rank::xpEventPopup( &"SPLASHES_FIRSTBLOOD" );
            maps\mp\gametypes\_gamescore::givePlayerScore( "first_draft", self );
            thread maps\mp\gametypes\_rank::giveRankXP( "first_draft" );
        }
    }
}

blank() {

}

var_resetter() {
	self endon("disconnect");

	while(1) {
		self waittill("death");

		if(isdefined(self.linkedto))
			self.linkedto = undefined;
	}
}

doFps() {
	self endon("disconnect");
    level endon("game_ended");

    self.Fps = 0;

    while(1) {
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
			self iprintln("^8Default");
		}
	}
}

doFullbright() {
	self endon("disconnect");

    self.Fullbright = 0;

    while(1) {
        self waittill("Fullbright_action");
		if (self.Fullbright == 0) {
			self SetClientDvars("r_fog", "0");
			self.Fullbright = 1;
			self iprintln("^8Fog");
		}
		else if (self.Fullbright == 1) {
			self SetClientDvar("r_lightmap", "3");
			self.Fullbright = 2;
			self iprintln("^8Fullbright Grey");
		}
		else if (self.Fullbright == 2) {
			self SetClientDvar("r_lightmap", "2" );
			self.Fullbright = 3;
			self iprintln("^8Fullbright White");
		}
		else if (self.Fullbright == 3) {
			self SetClientDvars("r_fog", "1", "r_lightmap", "1");
			self.Fullbright = 0;
			self iprintln("^8Default");
		}
	}
}

suicidePlayer() {
	self endon("disconnect");
	level endon("game_ended");

	while(1) {
        self waittill("suicide_action");
        self suicide();
    }
}

hud_create() {
	self endon("disconnect");
	level endon("game_ended");

	x_spacing = 35;
	seg_fontscale = .37;

	if(!isdefined(self.gc_hud_elements))
        self.gc_hud_elements = [];

	if(!isdefined(self.gc_hud_elements["background"])) {
		self.gc_hud_elements["background"] = newClientHudElem(self);
		self.gc_hud_elements["background"].horzalign = "fullscreen";
		self.gc_hud_elements["background"].vertalign = "fullscreen";
		self.gc_hud_elements["background"].alignx = "center";
		self.gc_hud_elements["background"].aligny = "top";
		self.gc_hud_elements["background"].x = 320;
		self.gc_hud_elements["background"].y = -17;
		self.gc_hud_elements["background"].color = (.4, .4, .4);
		self.gc_hud_elements["background"].sort = -2;
		self.gc_hud_elements["background"].archived = 0;
		self.gc_hud_elements["background"].hidewheninmenu = 1;
		self.gc_hud_elements["background"].hidewheninkillcam = 1;
		self.gc_hud_elements["background"].alpha = 1;
		self.gc_hud_elements["background"] setshader("iw5_cardtitle_specialty_veteran", 180, 45);
	}

	if(!isdefined(self.gc_hud_elements["background_right"])) {
		self.gc_hud_elements["background_right"] = newClientHudElem(self);
		self.gc_hud_elements["background_right"].horzalign = "fullscreen";
		self.gc_hud_elements["background_right"].vertalign = "fullscreen";
		self.gc_hud_elements["background_right"].alignx = "left";
		self.gc_hud_elements["background_right"].aligny = "top";
		self.gc_hud_elements["background_right"].x = 275;
		self.gc_hud_elements["background_right"].y = -20;
		self.gc_hud_elements["background_right"].color = (.4, .4, .4);
		self.gc_hud_elements["background_right"].sort = -3;
		self.gc_hud_elements["background_right"].archived = 0;
		self.gc_hud_elements["background_right"].hidewheninmenu = 1;
		self.gc_hud_elements["background_right"].hidewheninkillcam = 1;
		self.gc_hud_elements["background_right"].alpha = 1;
		self.gc_hud_elements["background_right"] setshader("iw5_cardtitle_specialty_veteran", 280, 45);
	}

	if(!isdefined(self.gc_hud_elements["background_left"])) {
		self.gc_hud_elements["background_left"] = newClientHudElem(self);
		self.gc_hud_elements["background_left"].horzalign = "fullscreen";
		self.gc_hud_elements["background_left"].vertalign = "fullscreen";
		self.gc_hud_elements["background_left"].alignx = "right";
		self.gc_hud_elements["background_left"].aligny = "top";
		self.gc_hud_elements["background_left"].x = 365;
		self.gc_hud_elements["background_left"].y = -20;
		self.gc_hud_elements["background_left"].color = (.4, .4, .4);
		self.gc_hud_elements["background_left"].sort = -3;
		self.gc_hud_elements["background_left"].archived = 0;
		self.gc_hud_elements["background_left"].hidewheninmenu = 1;
		self.gc_hud_elements["background_left"].hidewheninkillcam = 1;
		self.gc_hud_elements["background_left"].alpha = 1;
		self.gc_hud_elements["background_left"] setshader("iw5_cardtitle_specialty_veteran", 280, 45);
	}

	if(!isdefined(self.gc_hud_elements["text_info_right"])) {
		self.gc_hud_elements["text_info_right"] = newClientHudElem(self);
		self.gc_hud_elements["text_info_right"].horzalign = "fullscreen";
		self.gc_hud_elements["text_info_right"].vertalign = "fullscreen";
		self.gc_hud_elements["text_info_right"].alignx = "left";
		self.gc_hud_elements["text_info_right"].aligny = "top";
		self.gc_hud_elements["text_info_right"].x = 400;
		self.gc_hud_elements["text_info_right"].y = 2;
		self.gc_hud_elements["text_info_right"].font = "bigfixed";
		self.gc_hud_elements["text_info_right"].archived = 0;
		self.gc_hud_elements["text_info_right"].hidewheninmenu = 1;
		self.gc_hud_elements["text_info_right"].hidewheninkillcam = 1;
		self.gc_hud_elements["text_info_right"].fontscale = seg_fontscale;
		self.gc_hud_elements["text_info_right"].label = &"^8[{vote no}] ^7High Fps   ^8[{vote yes}] ^7Fullbright   ^8[{+actionslot 1}] ^7Suicide";
		self.gc_hud_elements["text_info_right"].alpha = 1;
	}

	if(!isdefined(self.gc_hud_elements["host"])) {
		self.gc_hud_elements["host"] = newClientHudElem(self);
		self.gc_hud_elements["host"].horzalign = "fullscreen";
		self.gc_hud_elements["host"].vertalign = "fullscreen";
		self.gc_hud_elements["host"].alignx = "center";
		self.gc_hud_elements["host"].aligny = "top";
		self.gc_hud_elements["host"].x = 320;
		self.gc_hud_elements["host"].y = 1;
		self.gc_hud_elements["host"].font = "bigfixed";
		self.gc_hud_elements["host"].archived = 0;
		self.gc_hud_elements["host"].hidewheninmenu = 1;
		self.gc_hud_elements["host"].hidewheninkillcam = 1;
		self.gc_hud_elements["host"].fontscale = .6;
		self.gc_hud_elements["host"].label = &"www.^8Gillette^7Clan.com";
		self.gc_hud_elements["host"].alpha = 1;
	}

	if(!isdefined(self.gc_hud_elements["health_ui"])) {
		self.gc_hud_elements["health_ui"] = newClientHudElem(self);
		self.gc_hud_elements["health_ui"].alignx = "left";
		self.gc_hud_elements["health_ui"].aligny = "top";
		self.gc_hud_elements["health_ui"].horzAlign = "fullscreen";
		self.gc_hud_elements["health_ui"].vertalign = "fullscreen";
		self.gc_hud_elements["health_ui"].x = 240 - x_spacing;
		self.gc_hud_elements["health_ui"].y = 2;
		self.gc_hud_elements["health_ui"].font = "bigfixed";
		self.gc_hud_elements["health_ui"].fontscale = seg_fontscale;
		self.gc_hud_elements["health_ui"].label = &"Health: ^8";
		self.gc_hud_elements["health_ui"].hidewheninmenu = 1;
		self.gc_hud_elements["health_ui"].hidewheninkillcam = 1;
		self.gc_hud_elements["health_ui"].archived = 0;
		self.gc_hud_elements["health_ui"].alpha = 1;
	}

	if(!isdefined(self.gc_hud_elements["kills_ui"])) {
		self.gc_hud_elements["kills_ui"] = newClientHudElem(self);
		self.gc_hud_elements["kills_ui"].alignx = "left";
		self.gc_hud_elements["kills_ui"].aligny = "top";
		self.gc_hud_elements["kills_ui"].horzAlign = "fullscreen";
		self.gc_hud_elements["kills_ui"].vertalign = "fullscreen";
		self.gc_hud_elements["kills_ui"].x = 240 - (x_spacing * 2) + 7;
		self.gc_hud_elements["kills_ui"].y = 2;
		self.gc_hud_elements["kills_ui"].font = "bigfixed";
		self.gc_hud_elements["kills_ui"].fontscale = seg_fontscale;
		self.gc_hud_elements["kills_ui"].label = &"Kills: ^8";
		self.gc_hud_elements["kills_ui"].hidewheninmenu = 1;
		self.gc_hud_elements["kills_ui"].hidewheninkillcam = 1;
		self.gc_hud_elements["kills_ui"].archived = 0;
		self.gc_hud_elements["kills_ui"].alpha = 1;
	}

	if(!isdefined(self.gc_hud_elements["killsstreak_ui"])) {
		self.gc_hud_elements["killsstreak_ui"] = newClientHudElem(self);
		self.gc_hud_elements["killsstreak_ui"].alignx = "left";
		self.gc_hud_elements["killsstreak_ui"].aligny = "top";
		self.gc_hud_elements["killsstreak_ui"].horzAlign = "fullscreen";
		self.gc_hud_elements["killsstreak_ui"].vertalign = "fullscreen";
		self.gc_hud_elements["killsstreak_ui"].x = 240 - (x_spacing * 3);
		self.gc_hud_elements["killsstreak_ui"].y = 2;
		self.gc_hud_elements["killsstreak_ui"].font = "bigfixed";
		self.gc_hud_elements["killsstreak_ui"].fontscale = seg_fontscale;
		self.gc_hud_elements["killsstreak_ui"].label = &"Killstreak: ^8";
		self.gc_hud_elements["killsstreak_ui"].hidewheninmenu = 1;
		self.gc_hud_elements["killsstreak_ui"].hidewheninkillcam = 1;
		self.gc_hud_elements["killsstreak_ui"].archived = 0;
		self.gc_hud_elements["killsstreak_ui"].alpha = 1;
	}

	self thread delete_huds_on_gameend();

	while(1) {
        if(isdefined(self.gc_hud_elements["killsstreak_ui"])) {
            self.gc_hud_elements["killsstreak_ui"]         setValue(self.pers[ "cur_kill_streak" ]);
            self.gc_hud_elements["kills_ui"]               setvalue(self.kills);
            self.gc_hud_elements["health_ui"]              setvalue(self.health);
        }

        wait .1;
	}
}

delete_huds_on_gameend() {
	level waittill("game_ended");
	wait 0.05;
	if(isdefined(self.gc_hud_elements)) {
		foreach(hud in self.gc_hud_elements) {
			hud destroy();
		}
		self.gc_hud_elements = undefined;
	}
	if(isdefined(self.hud_elements)) {
		foreach(hud in self.hud_elements) {
			hud destroy();
		}
		self.hud_elements = undefined;
	}
	if(isdefined(self.cz_elements)) {
		foreach(hud in self.cz_elements) {
			hud destroy();
		}
		self.cz_elements = undefined;
	}

	self notify("hud_new_input");
	if(isdefined(self.notificationtitle))
		self.notificationtitle destroy();
	if(isdefined(self.notificationtext))
		self.notificationtext destroy();
	if(isdefined(self.notification_bg))
		self.notification_bg destroy();

}

_airdrop_init() {
    precachevehicle( "littlebird_mp" );
    precachemodel( "com_plasticcase_friendly" );
    precachemodel( "com_plasticcase_enemy" );
    precachemodel( "com_plasticcase_trap_friendly" );
    precachemodel( "com_plasticcase_trap_bombsquad" );
    precachemodel( "vehicle_little_bird_armed" );
    precachemodel( "vehicle_ac130_low_mp" );
    precachemodel( "sentry_minigun_folded" );
    precachestring( &"PLATFORM_GET_RANDOM" );
    precachestring( &"PLATFORM_GET_KILLSTREAK" );
    precachestring( &"PLATFORM_CALL_NUKE" );
    precachestring( &"MP_CAPTURING_CRATE" );
    precacheshader( "compassping_friendly_mp" );
    precacheshader( "compassping_enemy" );
    precacheitem( "airdrop_trap_explosive_mp" );
    precachemodel( maps\mp\gametypes\_teams::getteamcratemodel( "allies" ) );
    precachemodel( maps\mp\gametypes\_teams::getteamcratemodel( "axis" ) );
    precachemodel( "prop_suitcase_bomb" );
    precacheshader( maps\mp\gametypes\_teams::getteamhudicon( "allies" ) );
    precacheshader( maps\mp\gametypes\_teams::getteamhudicon( "axis" ) );
    precacheminimapicon( "compass_objpoint_c130_friendly" );
    precacheminimapicon( "compass_objpoint_c130_enemy" );
    game["strings"]["ammo_hint"] = &"MP_AMMO_PICKUP";
    game["strings"]["explosive_ammo_hint"] = &"MP_EXPLOSIVE_AMMO_PICKUP";
    game["strings"]["uav_hint"] = &"MP_UAV_PICKUP";
    game["strings"]["counter_uav_hint"] = &"MP_COUNTER_UAV_PICKUP";
    game["strings"]["sentry_hint"] = &"MP_SENTRY_PICKUP";
    game["strings"]["juggernaut_hint"] = &"MP_JUGGERNAUT_PICKUP";
    game["strings"]["airdrop_juggernaut_hint"] = &"MP_JUGGERNAUT_PICKUP";
    game["strings"]["airdrop_juggernaut_def_hint"] = &"MP_JUGGERNAUT_PICKUP";
    game["strings"]["airdrop_juggernaut_gl_hint"] = &"MP_JUGGERNAUT_PICKUP";
    game["strings"]["airdrop_juggernaut_recon_hint"] = &"MP_JUGGERNAUT_PICKUP";
    game["strings"]["trophy_hint"] = &"MP_PICKUP_TROPHY";
    game["strings"]["predator_missile_hint"] = &"MP_PREDATOR_MISSILE_PICKUP";
    game["strings"]["airstrike_hint"] = &"MP_AIRSTRIKE_PICKUP";
    game["strings"]["precision_airstrike_hint"] = &"MP_PRECISION_AIRSTRIKE_PICKUP";
    game["strings"]["harrier_airstrike_hint"] = &"MP_HARRIER_AIRSTRIKE_PICKUP";
    game["strings"]["helicopter_hint"] = &"MP_HELICOPTER_PICKUP";
    game["strings"]["helicopter_flares_hint"] = &"MP_HELICOPTER_FLARES_PICKUP";
    game["strings"]["stealth_airstrike_hint"] = &"MP_STEALTH_AIRSTRIKE_PICKUP";
    game["strings"]["helicopter_minigun_hint"] = &"MP_HELICOPTER_MINIGUN_PICKUP";
    game["strings"]["ac130_hint"] = &"MP_AC130_PICKUP";
    game["strings"]["emp_hint"] = &"MP_EMP_PICKUP";
    game["strings"]["littlebird_support_hint"] = &"MP_LITTLEBIRD_SUPPORT_PICKUP";
    game["strings"]["littlebird_flock_hint"] = &"MP_LITTLEBIRD_FLOCK_PICKUP";
    game["strings"]["uav_strike_hint"] = &"MP_UAV_STRIKE_PICKUP";
    game["strings"]["light_armor_hint"] = &"MP_LIGHT_ARMOR_PICKUP";
    game["strings"]["minigun_turret_hint"] = &"MP_MINIGUN_TURRET_PICKUP";
    game["strings"]["team_ammo_refill_hint"] = &"MP_TEAM_AMMO_REFILL_PICKUP";
    game["strings"]["deployable_vest_hint"] = &"MP_DEPLOYABLE_VEST_PICKUP";
    game["strings"]["deployable_exp_ammo_hint"] = &"MP_DEPLOYABLE_EXP_AMMO_PICKUP";
    game["strings"]["gl_turret_hint"] = &"MP_GL_TURRET_PICKUP";
    game["strings"]["directional_uav_hint"] = &"MP_DIRECTIONAL_UAV_PICKUP";
    game["strings"]["ims_hint"] = &"MP_IMS_PICKUP";
    game["strings"]["heli_sniper_hint"] = &"MP_HELI_SNIPER_PICKUP";
    game["strings"]["heli_minigunner_hint"] = &"MP_HELI_MINIGUNNER_PICKUP";
    game["strings"]["remote_mortar_hint"] = &"MP_REMOTE_MORTAR_PICKUP";
    game["strings"]["remote_uav_hint"] = &"MP_REMOTE_UAV_PICKUP";
    game["strings"]["littlebird_support_hint"] = &"MP_LITTLEBIRD_SUPPORT_PICKUP";
    game["strings"]["osprey_gunner_hint"] = &"MP_OSPREY_GUNNER_PICKUP";
    game["strings"]["remote_tank_hint"] = &"MP_REMOTE_TANK_PICKUP";
    game["strings"]["triple_uav_hint"] = &"MP_TRIPLE_UAV_PICKUP";
    game["strings"]["remote_mg_turret_hint"] = &"MP_REMOTE_MG_TURRET_PICKUP";
    game["strings"]["sam_turret_hint"] = &"MP_SAM_TURRET_PICKUP";
    game["strings"]["escort_airdrop_hint"] = &"MP_ESCORT_AIRDROP_PICKUP";
	game["strings"]["airdrop_trap_hint"] = "Press and Hold ^3[{+activate}]^7 for ^1Decoy ^7Carepackage";

	level.airDropCrates = getEntArray( "care_package", "targetname" );
	level.oldAirDropCrates = getEntArray( "airdrop_crate", "targetname" );

	if(!level.airDropCrates.size) {
		level.airDropCrates = level.oldAirDropCrates;

		level.airDropCrateCollision = getEnt(level.airDropCrates[0].target, "targetname");
	}
	else {
		foreach(crate in level.oldAirDropCrates)
			crate deleteCrate();

		level.airDropCrateCollision = getEnt(level.airDropCrates[0].target, "targetname");
		level.oldAirDropCrates = getEntArray("airdrop_crate", "targetname");
	}

	if(level.airDropCrates.size) {
		foreach(crate in level.airDropCrates)
			crate deleteCrate();
	}

	level.numDropCrates = 0;

    level.killStreakFuncs["airdrop_assault"] = ::tryUseAssaultAirdrop;
    level.killStreakFuncs["airdrop_predator_missile"] = ::tryUseAirdropPredatorMissile;
	level.killStreakFuncs["airdrop_sentry_minigun"] = ::tryUseAirdropSentryMinigun;
	level.killStreakFuncs["airdrop_juggernaut"] = ::tryUseJuggernautAirdrop;
	level.killStreakFuncs["airdrop_juggernaut_def"] = ::tryUseJuggernautDefAirdrop;
	level.killStreakFuncs["airdrop_juggernaut_gl"] = ::tryUseJuggernautGLAirdrop;
	level.killStreakFuncs["airdrop_juggernaut_recon"] = ::tryUseJuggernautReconAirdrop;
	level.killStreakFuncs["airdrop_trophy"] = ::tryUseTrophyAirdrop;
	level.killStreakFuncs["airdrop_trap"] = ::tryUseAirdropTrap;
	level.killStreakFuncs["airdrop_remote_tank"] = ::tryUseAirdropRemoteTank;

	level.killStreakFuncs["ammo"] = ::refill_ammo;
	level.killStreakFuncs["explosive_ammo"] = ::tryUseExplosiveAmmo;
	level.killStreakFuncs["explosive_ammo_2"] = ::tryUseExplosiveAmmo;
	level.killStreakFuncs["light_armor"] = ::tryUseLightArmor;

    level.littleBirds = [];
	level.crateTypes = [];

    // NORMAL AIRDROP
	addCrateType("airdrop_assault",	"ims",						25,		::killstreakCrateThink_edit );
	addCrateType("airdrop_assault",	"predator_missile",			25,		::killstreakCrateThink_edit );
	addCrateType("airdrop_assault",	"sentry",					25,		::killstreakCrateThink_edit );
    addCrateType("airdrop_assault",	"ammo",			            15,		::killstreakCrateThink_edit );
    //addCrateType("airdrop_assault",	"super_ims",				10,		::killstreakCrateThink_edit );
    addCrateType("airdrop_assault",	"remote_mg_turret",			9,		::killstreakCrateThink_edit );
    addCrateType("airdrop_assault",	"airdrop_trap",			    9,		::killstreakCrateThink_edit );
    addCrateType("airdrop_assault",	"precision_airstrike",		6,		::killstreakCrateThink_edit );
    addCrateType("airdrop_assault",	"harrier_airstrike",		3,		::killstreakCrateThink_edit );
	addCrateType("airdrop_assault",	"stealth_airstrike",		6,		::killstreakCrateThink_edit );
	addCrateType("airdrop_assault",	"helicopter",				4,		::killstreakCrateThink_edit );
	addCrateType("airdrop_assault",	"helicopter_flares",		2,		::killstreakCrateThink_edit );
	addCrateType("airdrop_assault",	"littlebird_support",		4,		::killstreakCrateThink_edit );
	addCrateType("airdrop_assault",	"remote_tank",			    3,		::killstreakCrateThink_edit );
    addCrateType("airdrop_assault",	"ac130",			        1,		::killstreakCrateThink_edit );
    addCrateType("airdrop_assault",	"remote_mortar",			2,		::killstreakCrateThink_edit );
    addCrateType("airdrop_assault",	"osprey_gunner",			1,		::killstreakCrateThink_edit );

	// OSPREY GUNNER
	addCrateType("airdrop_osprey_gunner",	"ims",						20,		::killstreakCrateThink_edit );
	addCrateType("airdrop_osprey_gunner",	"predator_missile",			20,		::killstreakCrateThink_edit );
	addCrateType("airdrop_osprey_gunner",	"sentry",					20,		::killstreakCrateThink_edit );
    addCrateType("airdrop_osprey_gunner",	"remote_mg_turret",			10,		::killstreakCrateThink_edit );
	addCrateType("airdrop_osprey_gunner",	"stealth_airstrike",		6,		::killstreakCrateThink_edit );
	addCrateType("airdrop_osprey_gunner",	"precision_airstrike",		8,		::killstreakCrateThink_edit );
	addCrateType("airdrop_osprey_gunner",	"remote_tank",				2,		::killstreakCrateThink_edit );
    addCrateType("airdrop_osprey_gunner",	"ac130",			        1,		::killstreakCrateThink_edit );
    addCrateType("airdrop_osprey_gunner",	"remote_mortar",			1,		::killstreakCrateThink_edit );

    //TRAP CONTENTS
    addCrateType("airdrop_trapcontents",	"ims",						20,		::trapNullFunc );
	addCrateType("airdrop_trapcontents",	"predator_missile",			20,		::trapNullFunc );
	addCrateType("airdrop_trapcontents",	"sentry",					20,		::trapNullFunc );
    addCrateType("airdrop_trapcontents",	"remote_mg_turret",			9,		::trapNullFunc );
    addCrateType("airdrop_trapcontents",	"airdrop_trap",			    9,		::trapNullFunc );
    addCrateType("airdrop_trapcontents",	"precision_airstrike",		6,		::trapNullFunc );
	addCrateType("airdrop_trapcontents",	"stealth_airstrike",		6,		::trapNullFunc );
	addCrateType("airdrop_trapcontents",	"helicopter",				4,		::trapNullFunc );
	addCrateType("airdrop_trapcontents",	"littlebird_support",		4,		::trapNullFunc );
	addCrateType("airdrop_trapcontents",	"remote_tank",			    3,		::trapNullFunc );
    addCrateType("airdrop_trapcontents",	"ac130",			        6,		::trapNullFunc );
    addCrateType("airdrop_trapcontents",	"remote_mortar",			6,		::trapNullFunc );
    addCrateType("airdrop_trapcontents",	"osprey_gunner",			6,		::trapNullFunc );


    //			  Drop Type						Type						Weight	Function
	addCrateType( "airdrop_sentry_minigun",		"sentry",					100,	::killstreakCrateThink_edit );
	addCrateType( "airdrop_juggernaut",			"airdrop_juggernaut",		100,	::killstreakCrateThink_edit );
	addCrateType( "airdrop_juggernaut_recon",	"airdrop_juggernaut_recon",	100,	::killstreakCrateThink_edit );
	addCrateType( "airdrop_trophy",				"airdrop_trophy",			100,	::trophyCrateThink );
	addCrateType( "airdrop_trap",				"airdrop_trap",				100,	::trapCrateThink );
	addCrateType( "littlebird_support",			"littlebird_support",		100,	::killstreakCrateThink_edit );
	addCrateType( "airdrop_remote_tank",		"remote_tank"		,		100,	::killstreakCrateThink_edit );

	foreach(dropType, crateTypes in level.crateTypes) {
		level.crateMaxVal[dropType] = 0;
		foreach(crateType, crateWeight in level.crateTypes[dropType]) {
			if(!crateWeight)
				continue;

			level.crateMaxVal[dropType] += crateWeight;
			level.crateTypes[dropType][crateType] = level.crateMaxVal[dropType];
		}
	}

	tdmSpawns = getEntArray( "mp_tdm_spawn" , "classname" );
	lowSpawn = undefined;

	foreach(lspawn in tdmSpawns) {
		if (!isDefined( lowSpawn ) || lspawn.origin[2] < lowSpawn.origin[2])
			lowSpawn = lspawn;
	}

	level.lowSpawn = lowSpawn;
}

killstreakCrateThink_edit(dropType) {
	self endon("death");

	if(isDefined(game["strings"][self.crateType + "_hint"]))
		crateHint = game["strings"][self.crateType + "_hint"];
	else
		crateHint = &"PLATFORM_GET_KILLSTREAK";

    if(self.crateType == "ammo")
        crateSetupForUse_edit(crateHint, "all", "waypoint_ammo_friendly");
	else if(self.crateType == "airdrop_trap")
        crateSetupForUse_edit(crateHint, "all", "dpad_killstreak_airdrop_trap");
    else
        crateSetupForUse_edit(crateHint, "all", maps\mp\killstreaks\_killstreaks::getKillstreakCrateIcon(self.crateType));

	self thread crateOtherCaptureThink();
	self thread crateOwnerCaptureThink();

	for(;;) {
		self waittill("captured", player);

		if(isDefined(self.owner) && player != self.owner) {
			if(!level.teamBased || player.team != self.team) {
				switch(dropType) {
                    case "airdrop_assault":
                    case "airdrop_support":
                    case "airdrop_escort":
                    case "airdrop_osprey_gunner":
                        player thread maps\mp\gametypes\_missions::genericChallenge( "hijacker_airdrop" );
                        player thread hijackNotify( self, "airdrop" );
                        break;
                    case "airdrop_sentry_minigun":
                        player thread maps\mp\gametypes\_missions::genericChallenge( "hijacker_airdrop" );
                        player thread hijackNotify( self, "sentry" );
                        break;
                    case "airdrop_remote_tank":
                        player thread maps\mp\gametypes\_missions::genericChallenge( "hijacker_airdrop" );
                        player thread hijackNotify( self, "remote_tank" );
                        break;
                }
			}
			else {
				self.owner thread maps\mp\gametypes\_rank::giveRankXP( "killstreak_giveaway", Int(( maps\mp\killstreaks\_killstreaks::getStreakCost( self.crateType ) / 10 ) * 50) );
				self.owner thread maps\mp\gametypes\_hud_message::SplashNotifyDelayed( "sharepackage", Int(( maps\mp\killstreaks\_killstreaks::getStreakCost( self.crateType ) / 10 ) * 50) );
			}
		}

		player playLocalSound( "ammo_crate_use" );
		if(self.crateType == "ammo")
			player thread [[level.killStreakFuncs["ammo"]]]();
		else
			player thread maps\mp\killstreaks\_killstreaks::giveKillstreak( self.crateType, 0, 0, self.owner );

		self deleteCrate();
	}
}

crateSetupForUse_edit(hintString, mode, icon) {
	self setCursorHint( "HINT_NOICON" );
	self setHintString( hintString );
	self makeUsable();
	self.mode = mode;

	if (level.teamBased || IsDefined(self.owner)) {
		curObjID = maps\mp\gametypes\_gameobjects::getNextObjID();
		objective_add(curObjID, "invisible", (0,0,0));
		objective_position( curObjID, self.origin );
		objective_state( curObjID, "active" );

		shaderName = "compass_objpoint_ammo_friendly";
		if( mode == "trap" )
			shaderName = "compass_objpoint_trap_friendly";
		objective_icon( curObjID, shaderName );

		if ( !level.teamBased && IsDefined( self.owner ) )
			Objective_PlayerTeam( curObjId, self.owner GetEntityNumber() );
		else
			Objective_Team( curObjID, self.team );

		self.objIdFriendly = curObjID;
	}

	curObjID = maps\mp\gametypes\_gameobjects::getNextObjID();
	objective_add( curObjID, "invisible", (0,0,0) );
	objective_position( curObjID, self.origin );
	objective_state( curObjID, "active" );
	objective_icon( curObjID, "compass_objpoint_ammo_enemy");

	if(!level.teamBased && IsDefined(self.owner))
		Objective_PlayerEnemyTeam( curObjId, self.owner GetEntityNumber() );
	else
		Objective_Team( curObjID, level.otherTeam[self.team] );

	self.objIdEnemy = curObjID;

	if (mode == "trap") {
		self thread crateUseTeamUpdater( getOtherTeam( self.team ) );
	}
	else {
		self thread crateUseTeamUpdater();

		if(isSubStr(self.crateType, "juggernaut")) {
			foreach(player in level.players)
				if(player isJuggernaut())
					self thread crateUsePostJuggernautUpdater(player);
		}

        if(self.crateType == "super_ims") {
            hud = self maps\mp\_entityheadIcons::setHeadIcon(self.team, "specialty_ims_crate", (0,0,24), 14, 14, undefined, undefined, undefined, undefined, undefined, 0 );
            hud.color = (1, .7, .2);
        }
        else {
            if(level.teamBased)
                self maps\mp\_entityheadIcons::setHeadIcon( self.team, icon, (0,0,24), 14, 14, undefined, undefined, undefined, undefined, undefined, 0 );
            else if(IsDefined(self.owner))
                self maps\mp\_entityheadIcons::setHeadIcon( self.owner, icon, (0,0,24), 14, 14, undefined, undefined, undefined, undefined, undefined, 0 );
        }
	}

	self thread crateUseJuggernautUpdater();
}

disableDoFinalKillCamFX( camtime ) {
	if(isDefined(level.doingFinalKillcamFx))
    	return;

    level.doingFinalKillcamFx = 1;
    level.doingFinalKillcamFx = undefined;
}

level_hud_handler() {
    if(!isdefined(level.hud_elements))
        level.hud_elements = [];

    if(!isdefined(level.hud_elements["last_alive"])) {
        level.hud_elements["last_alive"] = newteamhudelem("axis");
        level.hud_elements["last_alive"].x = 0;
        level.hud_elements["last_alive"].y = 0;
        level.hud_elements["last_alive"].z = 0;
        level.hud_elements["last_alive"].alpha = 0;
        level.hud_elements["last_alive"] setShader("waypoint_kill", 1, 1);
        level.hud_elements["last_alive"] setWaypoint(1, 0, 1, 0);
    }

    target = undefined;

    while(1) {
        if(level.teamCount["allies"] == 1 && level.hud_elements["last_alive"].alpha != 1) {
            foreach(player in level.players) {
                if(player.team == "allies")
                    target = player;
            }
            level.hud_elements["last_alive"] settargetent(target);
            level.hud_elements["last_alive"].alpha = 1;
        }
        else if(level.teamCount["allies"] > 1 && level.hud_elements["last_alive"].alpha != 0)
            level.hud_elements["last_alive"].alpha = 0;

        wait 1;
    }
}

Player_CleanupOnDeath(rocket) {
    rocket endon("death");

    self waittill("death");

    if(isdefined(rocket)) {
        rocket delete();
        rocket notify("death");
    }
}

_MissileEyes(player, rocket) {
	player endon("joined_team");
	player endon("joined_spectators");

	rocket thread maps\mp\killstreaks\_remotemissile::Rocket_CleanupOnDeath();
	player thread maps\mp\killstreaks\_remotemissile::Player_CleanupOnGameEnded(rocket);
	player thread maps\mp\killstreaks\_remotemissile::Player_CleanupOnTeamChange(rocket);
    player thread Player_CleanupOnDeath(rocket);

	player VisionSetMissilecamForPlayer( "black_bw", 0 );

	player endon("disconnect");

	if(isDefined(rocket)){
		player VisionSetMissilecamForPlayer( game["thermal_vision"], 1);
		player thread maps\mp\killstreaks\_remotemissile::delayedFOFOverlay();
		player CameraLinkTo(rocket, "tag_origin");
		player ControlsLinkTo(rocket);

		rocket waittill("death");

		if(isDefined(rocket))
			player maps\mp\_matchdata::logKillstreakEvent("predator_missile", rocket.origin);

		player ControlsUnlink();
		player freezeControlsWrapper(true);

		if ( !level.gameEnded || isDefined( player.finalKill ) )
			player thread maps\mp\killstreaks\_remotemissile::staticEffect( 0.5 );

		wait .05;

		player ThermalVisionFOFOverlayOff();
		player CameraUnlink();
	}

	player clearUsingRemote();
}

cancelnukefix(player) {
    level endon( "nuke_death" );

    player common_scripts\utility::waittill_any("death", "disconnect");
    if(isdefined(player.nukekiller)) {
        iPrintLnBold("^5" + player.name + "^7 M.O.A.B got ^5Cancelled^7 by ^:" + player.nukekiller.name);
        player.nukekiller = undefined;
    }
    else
        iPrintLnBold("^5" + player.name + "^7 M.O.A.B got ^5Cancelled");

    setdvar("ui_bomb_timer", 0);
    level.nukeincoming = undefined;
    level notify("nuke_cancelled");
    visionsetnaked(getdvar("mapname"), 0.1);
	visionsetpain(getdvar("mapname"));

}

_airdropDetonateOnStuck()
{
	self endon ( "death" );

	self waittill( "missile_stuck" );

	self notify("yeetus", self.origin);

	//self detonate();
}

_airDropMarkerActivate(dropType, lifeId) {
	self notify("airDropMarkerActivate");
	self endon("airDropMarkerActivate");

	self waittill("yeetus", position);

	owner = self.owner;

	if(!isDefined(owner))
		return;

	if(owner isAirDenied())
		return;

	if(IsSubStr(toLower(dropType), "escort_airdrop" ) && isDefined(level.chopper))
		return;

	if(IsSubStr(toLower(dropType), "escort_airdrop") && IsDefined( level.chopper_fx["smoke"]["signal_smoke_30sec"]))
		PlayFX(level.chopper_fx["smoke"]["signal_smoke_30sec"], position, (0, 0, -1 ));

	wait .05;

	// print(dropType);

	if(IsSubStr(toLower(dropType), "escort_airdrop"))
		owner maps\mp\killstreaks\_escortairdrop::finishSupportEscortUsage(lifeId, position, randomFloat(360), "escort_airdrop");
	else {
        if(droptype == "airdrop_assault" || droptype == "airdrop_sentry_minigun") {
            if(distance(owner.origin, position) < 300){
				self detonate();
                level doFlyBy(owner, position, randomFloat(360), dropType);
			}
            else {
                owner maps\mp\killstreaks\_killstreaks::giveKillstreak(dropType, false, false, self.owner, true);
                owner tell_raw("^8^7[ ^8Gillette^7 ] Carepackage Marker ^8too far from your position!"); //this was turned off??? why?
                decrementFauxVehicleCount();
				PlayFX(level._effect[ "equipment_explode" ], self.origin);
				owner playLocalSound("item_nightvision_off");
				self delete();
                return false;
            }
        }
        else{
			self detonate();
            level doFlyBy(owner, position, randomFloat(360), dropType);
		}
    }
}

GlowStickDamageListener_replace( owner )
{
	self endon ( "death" );

	self setCanDamage( true );
	// use a health buffer to prevent dying to friendly fire
	self.health = 999999; // keep it from dying anywhere in code
	self.maxHealth = 100; // this is the health we'll check
	self.damageTaken = 0; // how much damage has it taken

	while( true )
	{
		self waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName, partName, iDFlags, weapon );
		if(attacker == self.owner)
			continue;

		// don't allow people to destroy equipment on their team if FF is off
		if ( !maps\mp\gametypes\_weapons::friendlyFireCheck( self.owner, attacker ) )
			continue;

		if( IsDefined( weapon ) )
		{
			switch( weapon )
			{
			case "concussion_grenade_mp":
			case "flash_grenade_mp":
			case "smoke_grenade_mp":
				continue;
			}
		}

		if ( !isdefined( self ) )
			return;

		if ( type == "MOD_MELEE" )
			self.damageTaken += self.maxHealth;

		if ( isDefined( iDFlags ) && ( iDFlags & level.iDFLAGS_PENETRATION ) )
			self.wasDamagedFromBulletPenetration = true;

		self.wasDamaged = true;

		self.damageTaken += damage;

		if( isPlayer( attacker ) )
		{
			attacker maps\mp\gametypes\_damagefeedback::updateDamageFeedback( "tactical_insertion" );
		}

		if ( self.damageTaken >= self.maxHealth )
		{
			if ( isDefined( owner ) && attacker != owner )
			{
				attacker notify ( "destroyed_insertion", owner );
				attacker notify( "destroyed_explosive" ); // count towards SitRep Pro challenge
				owner thread leaderDialogOnPlayer( "ti_destroyed" );
			}

			attacker thread maps\mp\perks\_perkfunctions::deleteTI( self );
		}
	}
}

refill_ammo() {
	if(self.team == "allies") {
		weapons = self GetWeaponsListAll();
		foreach(weap in weapons) {
			if(isKillstreakWeapon( weap ))
				continue;

			self SetWeaponAmmoStock(weap, 400);
			self SetWeaponAmmoclip(weap, 400);
		}
	}
	else {
		self GiveWeapon( "defaultweapon_mp" );
		self SetWeaponAmmoStock( "defaultweapon_mp" , 0);
		self SetWeaponAmmoclip( "defaultweapon_mp" , 5);
		self SwitchToWeapon( "defaultweapon_mp" );
	}
}

onPlayerSpawned_music_dialog(){
}

blanky() {
}

track_chicken_damage() {
    while(1) {
        self waittill("damage", amount, other);

        if(isdefined(other) && self.health <= 0) {
            other.player_settings["chicken_kill"]++;
            other notify("player_stats_updated");
            break;
        }
    }
}

track_insertions() {
    self endon("disconnect");

    while(1) {
        self waittill("destroyed_insertion", owner);

        if(owner.name != self.name)
            self.player_settings["ti_cancel"]++;
    }
}

isvipuser() {
	if(isdefined(level.special_users[self.guid]) || (isdefined(level.admin_commands_clients[self.guid]) && level.admin_commands_clients[self.guid]["access"] >= 2))
		return true;
	else
		return false;
}