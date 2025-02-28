#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include scripts\bouncefected\player_stats;

Init()
{
	replacefunc(maps\mp\gametypes\_menus::onmenuresponse, ::onmenuresponse_edit);
	replacefunc(maps\mp\gametypes\_killcam::waittillKillcamOver, ::waittillKillcamOverReplace);

	level.callbackplayerkilledMain 		= level.callbackPlayerKilled;
    level.callbackPlayerKilled 			= ::PlayerKilledCallback;

    level.callbackplayerDamageMain = level.callbackPlayerDamage;
	level.callbackPlayerDamage = ::PlayerDamageCallback;

	level thread Game_Settings();
    level thread onPlayerConnect();
}

Game_Settings()
{
	setDvar("jump_height", 45);
	setDvar("g_speed", 220);
	setDvar("g_gravity", 800 );
	setDvar("sv_enableBounces", 1);
	setDvar("sv_allanglesbounces", 1);

	setDvar("jump_ladderpushvel", 256);
	setDvar("jump_stepSize", 18);
	setDvar("jump_slowdownEnable", 0);
	setDvar("jump_disableFallDamage", 0);
	setDvar("jump_autoBunnyHop", 0);

	setDvar("g_playercollision", 0);
	setDvar("g_playerejection", 0);
	setDvar("g_playercollisionejectspeed", 25);

    setDvar("g_teamname_axis", "^1Infected");
    setDvar("g_scorescolor_axis", ".75 .25 .25 1");

    setDvar("g_teamname_allies", "^5Survivors");
	setDvar("g_scorescolor_allies", ".114 .694 .898 1");
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill( "connected", player );
		
		player thread onPlayerSpawned();
		player thread AFKWatcher();

		player SetClientDvar( "cl_maxpackets", 120);
		player SetClientDvar( "cg_objectiveText", "^5Gillette^7Clan.com\n^7Join us on Discord ^5discord.gg/GilletteClan");
		
		if(!isdefined(player.ui_elements))
			player.ui_elements = [];
		player thread scripts\bouncefected\player_hud::ui_create();
        
        player thread handlestats();
	}
}

handlestats()
{
    /////// stats /////
    wait 0.2;
    self setupStats();
    self.pers["rankxp"] = self getStats( "saved_experience" );

    if ( self.pers["rankxp"] < 0 )
        self.pers["rankxp"] = 0;

    var_1 = self maps\mp\gametypes\_rank::getRankForXp( self maps\mp\gametypes\_rank::getRankXP() );
    //print(var_1);
    self.pers["rank"] = var_1;
    self.pers["participation"] = 0;
    self.xpUpdateTotal = 0;
    self.bonusUpdateTotal = 0;
    var_2 = self getPlayerPrestigeLevel();
    //print(var_2);
    self setRank( var_1, var_2 );
    self.pers["prestige"] = var_2;
    ////// stats /////
    self.ranksetup = true;
}

onPlayerSpawned()
{
	self endon("disconnect");
	self.initial_spawn = 0;

    for(;;) {
        self waittill("spawned_player");

        self freezecontrols(false);
        
        self SetClientDvar("cg_objectiveText", "^5Gillette^7Clan.com\n^7Join us on Discord ^5discord.gg/GilletteClan");
        self setclientdvar("cg_teamcolor_axis", ".75 .25 .25 1");
        self setclientdvar("cg_teamcolor_allies", ".114 .694 .898 1");
        
        if(self.initial_spawn == 0) {
        	self.initial_spawn = 1;
            self.moab = false;
        	
       		self notifyOnPlayerCommand("FpsFix_action", "vote no");
			self notifyOnPlayerCommand("Fullbright_action", "vote yes");
			self notifyOnPlayerCommand("suicide_action", "+actionslot 6");
			self notifyOnPlayerCommand("suicide_action", "+actionslot 1");
            self notifyOnPlayerCommand("skipcam_action", "+actionslot 3");

			
			self thread doFps();
			self thread doFullbright();
            self thread doSkipKillcam();
			self thread suicidePlayer();
        }

		if(self.sessionteam == "allies")
		{
			self survivor_init();
		}
	}
}

survivor_init() {
    weap1 = scripts\bouncefected\weapons::BuildWeapon("ShotGun"); 
    weap2 = scripts\bouncefected\weapons::BuildWeapon("Pistol");

    self TakeAllWeapons();
    self GiveWeapon(weap1);
    self GiveMaxAmmo(weap1);
    self GiveWeapon(weap2);
    self GiveMaxAmmo(weap2);

    randomItem2 = ["smoke_grenade_mp", "flash_grenade_mp"];
    secondaryOffHand = randomItem2[randomint(randomItem2.size)];
    self GiveWeapon(secondaryOffHand);
    if(secondaryOffHand == "smoke_grenade_mp")
        self SetOffhandSecondaryClass( "smoke" );

    randomItem = ["bouncingbetty_mp", "c4_mp", "semtex_mp", "claymore_mp"/*, "throwingknife_mp"*/];
    primaryOffHand = randomItem[randomint(randomItem.size)];
    self GiveWeapon(primaryOffHand);
    /*if(primaryOffHand == "throwingknife_mp"){
        self SetOffhandPrimaryClass( "throwingknife" );
        self SetWeaponAmmoClip("throwingknife_mp", 1);
    } 
    else */if(primaryOffHand == "semtex_mp")
        self SetOffhandPrimaryClass( "other" );

    self setspawnweapon(weap1);
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
				if(distance(org, self.origin) <= 15 && angle == self getPlayerAngles())
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
				if(distance(org, self.origin) <= 15 && angle == self getPlayerAngles())
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

doFps() {
	self endon("disconnect");
    level endon("game_ended");

    while(!isdefined(self.ranksetup))
        wait 0.1;

    wait 0.05;
    self.Fps = self getsetting(0);
    cset = self.Fps;

    while(true) {
        if (self.Fps == 0) {
            cset = 0;
			self setClientDvar ( "r_zfar", "0" );
			self.Fps = 1;
			self iprintln("^5Default");
		}
		else if (self.Fps == 1) {
            cset = 1;
			self setClientDvar ( "r_zfar", "3000" );
			self.Fps = 2;
			self iprintln("^53000");
		}
		else if (self.Fps == 2) {
            cset = 2;
			self setClientDvar ( "r_zfar", "2000" );
			self.Fps = 3;
			self iprintln("^52000");
		}
		else if (self.Fps == 3) {
            cset = 3;
			self setClientDvar ( "r_zfar", "1500" );
			self.Fps = 4;
			self iprintln("^51500");
		}
		else if (self.Fps == 4) {
            cset = 4;
			self setClientDvar ( "r_zfar", "1000" );
			self.Fps = 5;
			self iprintln("^51000");
		}
		else if (self.Fps == 5) {
            cset = 5;
			self setClientDvar ( "r_zfar", "500" );
			self.Fps = 0;
			self iprintln("^5500");
		}
        self setsetting(0, cset);
        self waittill("FpsFix_action");
	}
}

doFullbright() {
	self endon("disconnect");
    level endon("game_ended");
    
    while(!isdefined(self.ranksetup))
        wait 0.1;

    wait 0.05;
    self.Fullbright = self getsetting(1);
    cset = self.Fullbright;
    
    while(true) {
        if (self.Fullbright == 0) {
            cset = 0;
			self SetClientDvars("fx_enable", "1", "r_fog", "1", "fx_drawclouds", "1", "r_lightmap", "1");
			self.Fullbright = 1;
			self iprintln("^5Default");
		}
		else if (self.Fullbright == 1) {
            cset = 1;
			self SetClientDvars("fx_enable", "0", "r_fog", "0", "fx_drawclouds", "0", "r_lightmap", "1");
			self.Fullbright = 2;
			self iprintln("^5Fx^7/^5Fog");
		}
		else if (self.Fullbright == 2) {
            cset = 2;
			self SetClientDvars("fx_enable", "0", "r_fog", "0", "fx_drawclouds", "0", "r_lightmap", "3");
			self.Fullbright = 3;
			self iprintln("^5Fullbright Grey");
		}
		else if (self.Fullbright == 3) {
            cset = 3;
			self SetClientDvars("fx_enable", "0", "r_fog", "0", "fx_drawclouds", "0", "r_lightmap", "2" );
			self.Fullbright = 0;
			self iprintln("^5Fullbright White");
		}
        self setsetting(1, cset);
        self waittill("Fullbright_action");
	}
}

doSkipKillcam() {
	self endon("disconnect");
    level endon("game_ended");
    
    while(!isdefined(self.ranksetup))
        wait 0.1;

    wait 0.05;
    self.skipkillcamtoggle = self getsetting(2);
    cset = self.skipkillcamtoggle;
    
    while(true) {
        if (self.skipkillcamtoggle == 0) {
            cset = 0;
            self.skipkillcamtoggle = 1;
			self iprintln("^3Auto Skip ^7Killcam ^1Disabled");
		}
		else if (self.skipkillcamtoggle == 1) {
            cset = 1;
			self.skipkillcamtoggle = 0;
			self iprintln("^3Auto Skip ^7Killcam ^2Enabled");
		}
        self setsetting(2, cset);
        self waittill("skipcam_action");
	}
}


suicidePlayer() {
	self endon("disconnect");
	level endon("game_ended");
	
	while(true) {
        self waittill("suicide_action");
        self suicide();
    }
}


checkMoabActivated() {
	level endon("game_ended");
	for(;;) {
        wait 0.1;
		if(isDefined(level.nukeInfo)) {
			player = level.nukeInfo.player;
			if(isDefined(player)) {
				if(!player.moab) {
					player.moab = true;
				}
			}
		}
	}
}

PlayerKilledCallback( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration ) {
    if (isDefined( attacker ) && isPlayer( attacker ) && attacker != self && attacker.SessionTeam == "allies") {

        if((attacker.pers[ "cur_kill_streak" ] + 1) >= 30 && !attacker.moab && !isdefined(attacker.moved)) {
            attacker thread movetoclosestspawn();
            attacker.moved = true;
        }
        else if((attacker.pers[ "cur_kill_streak" ] + 1 ) == 25)
        {
            attacker iPrintLnBold("^1You Got A M.O.A.B. Use It Or You Will Get Moved!");
        }
    }

    [[level.callbackplayerkilledMain]]( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration );
}

PlayerDamageCallback(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime) {
    iDFlags = 4;
	if(sMeansOfDeath == "MOD_FALLING" && self.sessionteam == "axis")
        return;
	
    self [[level.callbackplayerDamageMain]](eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime);
}

movetoclosestspawn()
{
    rrr = undefined;
    dist = undefined;
    org = undefined;
    foreach(spot in level.spawnpoints)
    {
        if(!isdefined(org))
        {
            org = spot;
            dist = distance(self.origin, org.origin);
        }
        rrr = Distance(self.origin, spot.origin);
        if(rrr < dist)
        {
            org = spot;
            dist = rrr;
        }
    }
    self setOrigin(org.origin);
    self setplayerangles(org.angles);
}









waittillKillcamOverReplace()
{
	self endon("abort_killcam");
	
    if(isdefined(self.skipkillcamtoggle) && self.skipkillcamtoggle == 1) // 1 is disabled 0 is enabled
	    wait(self.killcamlength - 0.05);
}

// Menu Manipulation //

onmenuresponse_edit()
{
    self endon( "disconnect" );

    for (;;) {
        self waittill( "menuresponse", var_0, var_1 );

        if ( var_1 == "back" ) {
            self closepopupmenu();
            self closeingamemenu();
            
            if ( isoptionsmenu( var_0 ) ) {
                if ( self.pers["team"] == "allies" )
                    self openpopupmenu( game["menu_class_allies"] );

                if ( self.pers["team"] == "axis" )
                    self openpopupmenu( game["menu_class_axis"] );
            }
            continue;
        }

        if ( var_1 == "changeteam" ) {
        	self closepopupmenu();
            self closeingamemenu();
            self iprintlnbold("^7Nope ^5:) ");
            continue;
        }

        if ( var_1 == "changeclass_marines" ) {
            self closepopupmenu();
            self closeingamemenu();
            self iprintlnbold("^7Nope ^5:) ");
            continue;
        }

        if ( var_1 == "changeclass_opfor" ) {
            self closepopupmenu();
            self closeingamemenu();
            self iprintlnbold("^7Nope ^5:) ");
            continue;
        }

        if ( var_1 == "changeclass_marines_splitscreen" ) {
            self closepopupmenu();
            self closeingamemenu();
            self iprintlnbold("^7Nope ^5:) ");
            continue;
        }

        if ( var_1 == "changeclass_opfor_splitscreen" ) {
            self closepopupmenu();
            self closeingamemenu();
            self iprintlnbold("^7Nope ^5:) ");
            continue;
        }

        if ( var_1 == "endgame" )
        {
            if ( level.splitscreen )
            {
                endparty();

                if ( !level.gameended )
                    level thread maps\mp\gametypes\_gamelogic::forceend();
            }

            continue;
        }

        if ( var_1 == "endround" )
        {
            if ( !level.gameended )
                level thread maps\mp\gametypes\_gamelogic::forceend();
            else
            {
                self closepopupmenu();
                self closeingamemenu();
                self iprintln( &"MP_HOST_ENDGAME_RESPONSE" );
            }

            continue;
        }

        if ( var_0 == game["menu_team"] )
        {
            self closepopupmenu();
            self closeingamemenu();
            self iprintlnbold("^7Nope ^5:) ");
            continue;
        }

        if ( var_0 == game["menu_changeclass"] || isdefined( game["menu_changeclass_defaults_splitscreen"] ) && var_0 == game["menu_changeclass_defaults_splitscreen"] || isdefined( game["menu_changeclass_custom_splitscreen"] ) && var_0 == game["menu_changeclass_custom_splitscreen"] )
        {
            self closepopupmenu();
            self closeingamemenu();
            self iprintlnbold("^7Nope ^5:) ");
            continue;
        }
        
        if ( var_0 == game["menu_team"] ) {
            switch ( var_1 ) {
                case "allies":
                    self closepopupmenu();
            		self closeingamemenu();
            		self iprintlnbold("^7Nope ^5:) ");
                    break;
                case "axis":
                    self closepopupmenu();
            		self closeingamemenu();
            		self iprintlnbold("^7Nope ^5:) ");
                    break;
                case "autoassign":
                    self closepopupmenu();
            		self closeingamemenu();
            		self iprintlnbold("^7Nope ^5:) ");
                    break;
                case "spectator":
                    self closepopupmenu();
            		self closeingamemenu();
            		self iprintlnbold("^7Nope ^5:) ");
                    break;
            }

            continue;
        }

        if ( !level.console )
        {
            if ( var_0 == game["menu_quickcommands"] )
            {
                maps\mp\gametypes\_quickmessages::quickcommands( var_1 );
                continue;
            }

            if ( var_0 == game["menu_quickstatements"] )
            {
                maps\mp\gametypes\_quickmessages::quickstatements( var_1 );
                continue;
            }

            if ( var_0 == game["menu_quickresponses"] )
                maps\mp\gametypes\_quickmessages::quickresponses( var_1 );
        }
    }
}

isoptionsmenu( var_0 ) {
    if ( var_0 == game["menu_changeclass"] )
        return 1;

    if ( var_0 == game["menu_team"] )
        return 1;

    if ( var_0 == game["menu_controls"] )
        return 1;

    if ( issubstr( var_0, "pc_options" ) )
        return 1;

    return 0;
}