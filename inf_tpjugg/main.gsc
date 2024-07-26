#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_hud_message;
#include maps\mp\gametypes\infect;
#include scripts\inf_tpjugg\zombie;
#include maps\mp\killstreaks\_airdrop;

main() {
    replacefunc(maps\mp\killstreaks\_airdrop::init, ::_airdrop_init);
    replacefunc(maps\mp\gametypes\infect::chooseFirstInfected, ::_chooseFirstInfected);
    replacefunc(maps\mp\killstreaks\_remotemissile::MissileEyes, ::_MissileEyes);
}

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

	SetDvar("scr_nukecancelmode", 1);

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
    level.ospreySettings["osprey_gunner"].timeOut                 = 30;
    level.turretSettings["mg_turret"].timeOut                     = 45;
    level.tankSettings["remote_tank"].timeOut                     = 40;

    level thread on_connecting();
	level thread on_connect();
    level thread level_hud_handler();

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

on_connect() {
	while(1) {
		level waittill("connected", player);
		print("^2" + player.name + "^7 - Connected");
		player SetClientDvar("lowAmmoWarningColor1", "0 0 0 0");
		player SetClientDvar("lowAmmoWarningColor2", "0 0 0 0");
		player SetClientDvar("lowAmmoWarningNoAmmoColor1", "0 0 0 0");
		player SetClientDvar("lowAmmoWarningNoAmmoColor2", "0 0 0 0");
		player SetClientDvar("lowAmmoWarningNoReloadColor1", "0 0 0 0");
		player SetClientDvar("lowAmmoWarningNoReloadColor2", "0 0 0 0");

        player SetClientDvar("cg_teamcolor_allies", "0 .7 1 1");
        player SetClientDvar("cg_teamcolor_axis", ".75 .25 .25 1");

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
        player.hadgunsrotated       = 0;
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
	}
}

on_spawned() {
    self endon("disconnect");

    for(;;) {
        self waittill("spawned_player");
		print("^2" + self.name + "^7 - Has Class - ^3" + self.pers["class"] + " / " + self.class);
        self SetClientDvar("cg_objectiveText", "visit us at ^8Gillette^7Clan.com\nJoin us on Discord ^8discord.gg/GilletteClan");

        if(self.initial_spawn == 0) {
        	self.initial_spawn = 1;

			self notifyOnPlayerCommand("FpsFix_action", "vote no");
			self notifyOnPlayerCommand("Fullbright_action", "vote yes");
			self notifyOnPlayerCommand("suicide_action", "+actionslot 1");

			self thread doFps();
			self thread doFullbright();
			self thread suicidePlayer();
			self thread var_resetter();
            self thread hud_create();
        	//self thread adv_afk_check();
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

            if(!isdefined(self.isInitialInfected)) {
                self GiveWeapon("iw5_usp45_mp_tactical");
                self SetWeaponAmmoClip("iw5_usp45_mp_tactical", 0);
                self SetWeaponAmmoStock("iw5_usp45_mp_tactical", 0);
                self setspawnweapon("iw5_usp45_mp_tactical");

                self maps\mp\killstreaks\_killstreaks::clearKillstreaks();

                if(self.rtd_canroll == 1) {
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
            self GiveWeapon("iw5_mp7_mp_silencer");
            self GiveMaxAmmo("iw5_mp7_mp_silencer");
            self setspawnweapon("iw5_mp7_mp_silencer");

            if(!isdefined(self.initial_allies)) {
                self.hud_elements["door_bind"] settext("^2Open ^7/ ^1Close");

                self.initial_allies = 1;
            }
        }

        self setperk("specialty_fastoffhand", 1, 1);
    }
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
    	if(level.players.size > 3) {
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

        wait 1;
    }
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

	if(!isdefined(self.hud_elements["background"])) {
		self.hud_elements["background"] = newClientHudElem(self);
		self.hud_elements["background"].horzalign = "fullscreen";
		self.hud_elements["background"].vertalign = "fullscreen";
		self.hud_elements["background"].alignx = "center";
		self.hud_elements["background"].aligny = "top";
		self.hud_elements["background"].x = 320;
		self.hud_elements["background"].y = -17;
		self.hud_elements["background"].color = (.4, .4, .4);
		self.hud_elements["background"].sort = -2;
		self.hud_elements["background"].archived = 0;
		self.hud_elements["background"].hidewheninmenu = 1;
		self.hud_elements["background"].hidewheninkillcam = 1;
		self.hud_elements["background"].alpha = 1;
		self.hud_elements["background"] setshader("iw5_cardtitle_specialty_veteran", 180, 45);
	}

	if(!isdefined(self.hud_elements["background_right"])) {
		self.hud_elements["background_right"] = newClientHudElem(self);
		self.hud_elements["background_right"].horzalign = "fullscreen";
		self.hud_elements["background_right"].vertalign = "fullscreen";
		self.hud_elements["background_right"].alignx = "left";
		self.hud_elements["background_right"].aligny = "top";
		self.hud_elements["background_right"].x = 275;
		self.hud_elements["background_right"].y = -20;
		self.hud_elements["background_right"].color = (.4, .4, .4);
		self.hud_elements["background_right"].sort = -3;
		self.hud_elements["background_right"].archived = 0;
		self.hud_elements["background_right"].hidewheninmenu = 1;
		self.hud_elements["background_right"].hidewheninkillcam = 1;
		self.hud_elements["background_right"].alpha = 1;
		self.hud_elements["background_right"] setshader("iw5_cardtitle_specialty_veteran", 280, 45);
	}

	if(!isdefined(self.hud_elements["background_left"])) {
		self.hud_elements["background_left"] = newClientHudElem(self);
		self.hud_elements["background_left"].horzalign = "fullscreen";
		self.hud_elements["background_left"].vertalign = "fullscreen";
		self.hud_elements["background_left"].alignx = "right";
		self.hud_elements["background_left"].aligny = "top";
		self.hud_elements["background_left"].x = 365;
		self.hud_elements["background_left"].y = -20;
		self.hud_elements["background_left"].color = (.4, .4, .4);
		self.hud_elements["background_left"].sort = -3;
		self.hud_elements["background_left"].archived = 0;
		self.hud_elements["background_left"].hidewheninmenu = 1;
		self.hud_elements["background_left"].hidewheninkillcam = 1;
		self.hud_elements["background_left"].alpha = 1;
		self.hud_elements["background_left"] setshader("iw5_cardtitle_specialty_veteran", 280, 45);
	}

	if(!isdefined(self.hud_elements["text_info_right"])) {
		self.hud_elements["text_info_right"] = newClientHudElem(self);
		self.hud_elements["text_info_right"].horzalign = "fullscreen";
		self.hud_elements["text_info_right"].vertalign = "fullscreen";
		self.hud_elements["text_info_right"].alignx = "left";
		self.hud_elements["text_info_right"].aligny = "top";
		self.hud_elements["text_info_right"].x = 400;
		self.hud_elements["text_info_right"].y = 2;
		self.hud_elements["text_info_right"].font = "bigfixed";
		self.hud_elements["text_info_right"].archived = 0;
		self.hud_elements["text_info_right"].hidewheninmenu = 1;
		self.hud_elements["text_info_right"].hidewheninkillcam = 1;
		self.hud_elements["text_info_right"].fontscale = seg_fontscale;
		self.hud_elements["text_info_right"].label = &"^8[{vote no}] ^7High Fps   ^8[{vote yes}] ^7Fullbright   ^8[{+actionslot 1}] ^7Suicide";
		self.hud_elements["text_info_right"].alpha = 1;
	}

	if(!isdefined(self.hud_elements["host"])) {
		self.hud_elements["host"] = newClientHudElem(self);
		self.hud_elements["host"].horzalign = "fullscreen";
		self.hud_elements["host"].vertalign = "fullscreen";
		self.hud_elements["host"].alignx = "center";
		self.hud_elements["host"].aligny = "top";
		self.hud_elements["host"].x = 320;
		self.hud_elements["host"].y = 1;
		self.hud_elements["host"].font = "bigfixed";
		self.hud_elements["host"].archived = 0;
		self.hud_elements["host"].hidewheninmenu = 1;
		self.hud_elements["host"].hidewheninkillcam = 1;
		self.hud_elements["host"].fontscale = .6;
		self.hud_elements["host"].label = &"www.^8Gillette^7Clan.com";
		self.hud_elements["host"].alpha = 1;
	}

	if(!isdefined(self.hud_elements["health_ui"])) {
		self.hud_elements["health_ui"] = newClientHudElem(self);
		self.hud_elements["health_ui"].alignx = "left";
		self.hud_elements["health_ui"].aligny = "top";
		self.hud_elements["health_ui"].horzAlign = "fullscreen";
		self.hud_elements["health_ui"].vertalign = "fullscreen";
		self.hud_elements["health_ui"].x = 240 - x_spacing;
		self.hud_elements["health_ui"].y = 2;
		self.hud_elements["health_ui"].font = "bigfixed";
		self.hud_elements["health_ui"].fontscale = seg_fontscale;
		self.hud_elements["health_ui"].label = &"Health: ^8";
		self.hud_elements["health_ui"].hidewheninmenu = 1;
		self.hud_elements["health_ui"].hidewheninkillcam = 1;
		self.hud_elements["health_ui"].archived = 0;
		self.hud_elements["health_ui"].alpha = 1;
	}

	if(!isdefined(self.hud_elements["kills_ui"])) {
		self.hud_elements["kills_ui"] = newClientHudElem(self);
		self.hud_elements["kills_ui"].alignx = "left";
		self.hud_elements["kills_ui"].aligny = "top";
		self.hud_elements["kills_ui"].horzAlign = "fullscreen";
		self.hud_elements["kills_ui"].vertalign = "fullscreen";
		self.hud_elements["kills_ui"].x = 240 - (x_spacing * 2) + 7;
		self.hud_elements["kills_ui"].y = 2;
		self.hud_elements["kills_ui"].font = "bigfixed";
		self.hud_elements["kills_ui"].fontscale = seg_fontscale;
		self.hud_elements["kills_ui"].label = &"Kills: ^8";
		self.hud_elements["kills_ui"].hidewheninmenu = 1;
		self.hud_elements["kills_ui"].hidewheninkillcam = 1;
		self.hud_elements["kills_ui"].archived = 0;
		self.hud_elements["kills_ui"].alpha = 1;
	}

	if(!isdefined(self.hud_elements["killsstreak_ui"])) {
		self.hud_elements["killsstreak_ui"] = newClientHudElem(self);
		self.hud_elements["killsstreak_ui"].alignx = "left";
		self.hud_elements["killsstreak_ui"].aligny = "top";
		self.hud_elements["killsstreak_ui"].horzAlign = "fullscreen";
		self.hud_elements["killsstreak_ui"].vertalign = "fullscreen";
		self.hud_elements["killsstreak_ui"].x = 240 - (x_spacing * 3);
		self.hud_elements["killsstreak_ui"].y = 2;
		self.hud_elements["killsstreak_ui"].font = "bigfixed";
		self.hud_elements["killsstreak_ui"].fontscale = seg_fontscale;
		self.hud_elements["killsstreak_ui"].label = &"Killstreak: ^8";
		self.hud_elements["killsstreak_ui"].hidewheninmenu = 1;
		self.hud_elements["killsstreak_ui"].hidewheninkillcam = 1;
		self.hud_elements["killsstreak_ui"].archived = 0;
		self.hud_elements["killsstreak_ui"].alpha = 1;
	}

	self thread delete_huds_on_gameend();

	while(1) {
        if(isdefined(self.hud_elements["killsstreak_ui"])) {
            self.hud_elements["killsstreak_ui"]         setValue(self.pers[ "cur_kill_streak" ]);
            self.hud_elements["kills_ui"]               setvalue(self.kills);
            self.hud_elements["health_ui"]              setvalue(self.health);
        }

        wait .1;
	}
}

delete_huds_on_gameend() {
	level waittill("game_ended");
	wait 0.05;
	if(isdefined(self.hud_elements)) {
		foreach(hud in self.hud_elements) {
			hud destroy();
		}
	}
	if(isdefined(self.cz_elements)) {
		foreach(hud in self.cz_elements) {
			hud destroy();
		}
	}

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
    addCrateType("airdrop_assault",	"sentry",					4,		::killstreakCrateThink_edit );
	addCrateType("airdrop_assault",	"helicopter",				4,		::killstreakCrateThink_edit );
	addCrateType("airdrop_assault",	"helicopter_flares",		2,		::killstreakCrateThink_edit );
	addCrateType("airdrop_assault",	"littlebird_support",		4,		::killstreakCrateThink_edit );
	addCrateType("airdrop_assault",	"remote_tank",			    3,		::killstreakCrateThink_edit );
    addCrateType("airdrop_assault",	"ac130",			        1,		::killstreakCrateThink_edit );
    addCrateType("airdrop_assault",	"remote_mortar",			1,		::killstreakCrateThink_edit );
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
    addCrateType("airdrop_trapcontents",	"ims",						25,		::trapNullFunc );
	addCrateType("airdrop_trapcontents",	"predator_missile",			25,		::trapNullFunc );
	addCrateType("airdrop_trapcontents",	"sentry",					25,		::trapNullFunc );
    addCrateType("airdrop_trapcontents",	"remote_mg_turret",			9,		::trapNullFunc );
    addCrateType("airdrop_trapcontents",	"airdrop_trap",			    9,		::trapNullFunc );
    addCrateType("airdrop_trapcontents",	"precision_airstrike",		6,		::trapNullFunc );
	addCrateType("airdrop_trapcontents",	"stealth_airstrike",		6,		::trapNullFunc );
    addCrateType("airdrop_trapcontents",	"sentry",					4,		::trapNullFunc );
	addCrateType("airdrop_trapcontents",	"helicopter",				4,		::trapNullFunc );
	addCrateType("airdrop_trapcontents",	"littlebird_support",		4,		::trapNullFunc );
	addCrateType("airdrop_trapcontents",	"remote_tank",			    3,		::trapNullFunc );
    addCrateType("airdrop_trapcontents",	"ac130",			        1,		::trapNullFunc );
    addCrateType("airdrop_trapcontents",	"remote_mortar",			1,		::trapNullFunc );
    addCrateType("airdrop_trapcontents",	"osprey_gunner",			1,		::trapNullFunc );


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
                owner tell_raw("^8^7[ ^8Gillette^7 ] Carepackage Marker ^8too far from your position!");
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
		self SwitchToWeapon( "defaultweapon_mp" );
	}
}

onPlayerSpawned_music_dialog(){
}