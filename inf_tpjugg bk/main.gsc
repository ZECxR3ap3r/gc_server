#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_hud_message;
#include maps\mp\gametypes\infect;
#include scripts\inf_tpjugg\zombie;

blank() {

}

init() {
	replacefunc(maps\mp\killstreaks\_helicopter_flock::callstrike, ::callstrike_edit);
    replacefunc(maps\mp\gametypes\infect::setinfectedmsg, ::setinfectedmsg_edit);
    replacefunc(maps\mp\killstreaks\_nuke::nuke_EMPJam, ::blank);
    replacefunc(maps\mp\killstreaks\_killstreaks::usedKillstreak, ::usedKillstreak_edit);

	setdvar("g_scorescolor_allies", ".122 .753 .945 1");
	setdvar("g_scorescolor_axis", "1 .25 .25 1");
	setdvar("g_teamname_allies", "^5Survivors");
	setdvar("g_teamname_axis", "^1Infected");
	setdvar("g_teamicon_allies", "iw5_cardicon_juggernaut_c");
	setdvar("g_teamicon_axis", "iw5_cardicon_juggernaut_a");

	if(getdvar("sv_sayname") != "^5^7[ ^5Gillette^7 ]")
    	setdvar("sv_sayname", "^5^7[ ^5Gillette^7 ]");

    stringy = "Welcome to INF ^5TP JUGG^7 | Join us on Discord ^5discord.gg/GilletteClan";
    if(getdvar("sv_motd") != stringy)
        setdvar("sv_motd", stringy);

    precacheshader("line_horizontal");

    maps\mp\killstreaks\_airdrop::addcratetype("airdrop_assault", "stealth_airstrike", 4, maps\mp\killstreaks\_airdrop::killstreakcratethink);
    maps\mp\killstreaks\_airdrop::addcratetype("airdrop_assault", "remote_mg_turret", 5, maps\mp\killstreaks\_airdrop::killstreakcratethink);

	level thread on_connect();

    if(isdefined(level.infect_timerDisplay)) {
    	level.infect_timerDisplay destroy();

    	level.infect_timerDisplay = createServerTimer("bigfixed", .5);
		level.infect_timerDisplay.horzalign = "fullscreen";
		level.infect_timerDisplay.vertalign = "fullscreen";
		level.infect_timerDisplay.alignx = "left";
		level.infect_timerDisplay.aligny = "top";
		level.infect_timerDisplay.x = 4;
		level.infect_timerDisplay.y = 105;
		level.infect_timerDisplay.alpha = 0;
		level.infect_timerDisplay.archived = false;
		level.infect_timerDisplay.hideWhenInMenu = true;
    }

    wait 1;

    level.infect_loadouts["allies"]["loadoutStreakType"] = "assault";
    level.infect_loadouts["allies"]["loadoutKillstreak1"] = "airdrop_assault";
    level.infect_loadouts["allies"]["loadoutKillstreak2"] = "airdrop_sentry_minigun";
    level.infect_loadouts["allies"]["loadoutKillstreak3"] = "none";

    wait 4;

    foreach(doors in level.usables) {
        if(isdefined(doors)) {
            if(isdefined(doors.linked_ents)) {
                foreach(crate in doors.linked_ents)
                    crate thread check_player();
            }
        }
    }
}

on_connect() {
	while(1) {
		level waittill("connected", player);

		player SetClientDvar("lowAmmoWarningColor1", "0 0 0 0");
		player SetClientDvar("lowAmmoWarningColor2", "0 0 0 0");
		player SetClientDvar("lowAmmoWarningNoAmmoColor1", "0 0 0 0");
		player SetClientDvar("lowAmmoWarningNoAmmoColor2", "0 0 0 0");
		player SetClientDvar("lowAmmoWarningNoReloadColor1", "0 0 0 0");
		player SetClientDvar("lowAmmoWarningNoReloadColor2", "0 0 0 0");

        player.rtd_canroll = 1;
        player thread EquipmentLogging();
        player thread on_spawned();
        player thread client_origin_check();
	}
}

on_spawned() {
    self endon("disconnect");

    for(;;) {
        self waittill("spawned_player");

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

            self givePerk("specialty_tacticalinsertion", true);

            if(!isdefined(self.isInitialInfected)) {
                self GiveWeapon("iw5_usp45_mp_tactical");
                self SetWeaponAmmoClip("iw5_usp45_mp_tactical", 0);
                self SetWeaponAmmoStock("iw5_usp45_mp_tactical", 0);
                self setspawnweapon("iw5_usp45_mp_tactical");

                if(self.rtd_canroll == 1) {
                    self ResetPlayer();
                    self thread DoRandom();
                }

                if(GetTeamPlayersAlive("allies") < 2)
                    self ThermalVisionFOFOverlayOn();
            }
            else {
                self PowerfulJuggernaut();
                self GiveWeapon("riotshield_mp");
                self GiveWeapon("at4_mp");
                self setspawnweapon("at4_mp");
            }
        }
        else if (self.SessionTeam == "allies") {
            self takeallweapons();
            self maps\mp\_utility::giveperk( "trophy_mp", 0 );
            self maps\mp\_utility::giveperk( "claymore_mp", 0 );
            self GiveWeapon("iw5_mp7_mp_silencer");
            self GiveMaxAmmo("iw5_mp7_mp_silencer");
            self setspawnweapon("iw5_mp7_mp_silencer");
        }

        self SetPerk("specialty_fastoffhand", true, true);
    }
}

EquipmentLogging() {
    self endon("disconnect");

    for(;;) {
        self waittill( "grenade_fire", grenade, weapName);

        if ( weapName == "flare_mp" && self.sessionteam == "axis") {
            if ( !isDefined( self.TISpawnPosition ) )
                continue;

            if ( self touchingBadTrigger() )
                continue;

            if(isDefined( level.meat_playable_bounds ) && self.status == "in" && self deletetacifinzone()) {
                self.goodspawn = true;
                self thread Checkgoodspawn();
                self.laststatus = "in";
            }
        }
        else if(weapName == "throwingknife_mp" && self.sessionteam == "axis")
            grenade thread timeoutdelete();
    }
}

callstrike_edit( var_0, var_1, var_2 ) {
    level endon( "game_ended" );
    self endon( "disconnect" );

    var_3 = maps\mp\killstreaks\_helicopter_flock::getflightpath( var_1, var_2, 0 );
    var_4 = maps\mp\killstreaks\_helicopter_flock::getflightpath( var_1, var_2, -520 );
    var_5 = maps\mp\killstreaks\_helicopter_flock::getflightpath( var_1, var_2, 520 );

    level thread maps\mp\killstreaks\_helicopter_flock::dolbstrike( var_0, self, var_3, 0 );

    wait .3;

    level thread maps\mp\killstreaks\_helicopter_flock::dolbstrike( var_0, self, var_4, 1 );
    level thread maps\mp\killstreaks\_helicopter_flock::dolbstrike( var_0, self, var_5, 2 );
    maps\mp\_matchdata::logkillstreakevent( "littlebird_flock", var_1);
}

usedKillstreak_edit(streakName, awardXp) {
	self playLocalSound( "weap_c4detpack_trigger_plr" );

	if(awardXp) {
		self thread [[ level.onXPEvent ]]( "killstreak_" + streakName );
		self thread maps\mp\gametypes\_missions::useHardpoint( streakName );
	}

    self.used_streak_team = self.team;

	awardref = maps\mp\_awards::getKillstreakAwardRef( streakName );
	if ( IsDefined( awardref ) )
		self thread incPlayerStat( awardref, 1 );

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

client_origin_check() {
    self endon("disconnect");

    while(1) {
        self.bad = 0;

        foreach(ent in level.usables) {
            if(isdefined(ent)) {
                if(distance2d(self.origin, ent.origin) <= 250)
                    self.bad = 1;
            }
        }

        if(self.bad == 0)
            self.save_origin = self.origin;

        wait 1;
    }
}

check_player() {
    level endon("game_ended");

    while(isdefined(self)) {
        if(isdefined(level.players)) {
            foreach(player in level.players) {
                if(player istouching(self))
                    player setorigin(player.save_origin);
            }
        }

        wait 1;
    }
}