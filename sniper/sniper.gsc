#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;

init() {
    cmdexec("load_dsr ffa_snipe");

    replacefunc(maps\mp\gametypes\_killcam::doFinalKillCamFX, ::doFinalKillCamFX_replace);
    replacefunc(maps\mp\gametypes\_gamelogic::processLobbyData, ::processLobbyData_replace);

    level.custom_xp_multiplier = 4;

    //setDvar("scr_dm_scorelimit", 100);
    setDvar("scr_dm_scorelimit", 5000);
	setDvar("scr_dm_timelimit", 15);
    setDvar("sv_maxclients", 18);
    setDvar("player_sprintunlimited", 1);


    setDvar("sv_enableBounces", 1);
    setDvar("sv_allanglesbounces", 1);

    setDvar("jump_disableFallDamage", 0);
    setDvar("bg_falldamagemaxheight", 100000);
    setDvar("bg_falldamageminheight", 99999);

    setDvar("g_speed", 190);
	setDvar("jump_stepSize", 18);
    setDvar("jump_slowdownEnable", 1);
    setDvar("jump_autoBunnyHop", 0);
    setDvar("jump_ladderpushvel", 128);
    setDvar("jump_height", 39);

    setDvar("g_playercollision", 0);
    setDvar("g_playercollisionejectspeed", 0);
    setDvar("g_playerejection", 0);

    level thread on_connect();

    level.callbackplayerDamageMain = level.callbackPlayerDamage;
	level.callbackPlayerDamage = ::PlayerDamageCallback;

    precacheshader("reticle_center_cross");
    precacheshader("killiconmelee");
    precacheshader("iw5_cardtitle_specialty_veteran");

    seg_fontscale = .37;

	if(!isdefined(level.info_hud_elements))
		level.info_hud_elements = [];

	if(!isdefined(level.info_hud_elements["host"])) {
		level.info_hud_elements["host"] = newhudelem();
		level.info_hud_elements["host"].horzalign = "fullscreen";
		level.info_hud_elements["host"].vertalign = "fullscreen";
		level.info_hud_elements["host"].alignx = "center";
		level.info_hud_elements["host"].aligny = "top";
		level.info_hud_elements["host"].x = 320;
		level.info_hud_elements["host"].y = 1;
		level.info_hud_elements["host"].font = "bigfixed";
		level.info_hud_elements["host"].archived = false;
		// level.info_hud_elements["host"].hidewheninmenu = 1;
		level.info_hud_elements["host"].hidewheninkillcam = 1;
		level.info_hud_elements["host"].fontscale = .4;
		level.info_hud_elements["host"].alpha = .75;
		level.info_hud_elements["host"] settext("^8Gillette^7Clan.com");
	}

    level.map_name = getdvar("ui_mapname");

    if(getdvar("sv_sayname") != "^8^7[ ^8Gillette^7 ]")
    	setdvar("sv_sayname", "^8^7[ ^8Gillette^7 ]");

    tpents = GetEntArray("tpjug", "targetname");
    foreach(ent in tpents)
         ent delete();

    classicents = GetEntArray("classicinf", "targetname");
    foreach(ent in classicents)
        ent delete();
}

on_connect() {
    for(;;) {
        level waittill("connected", player);
        //player setclientdvar("g_scriptMainMenu", "escape");
        player.hud_elements = [];

        player thread on_spawned();
        player thread on_weapon_change();
        player thread no_deagle_ammo();
        player thread xp_multiplier_hud_overwrite();

        player SetClientDvar("lowAmmoWarningNoAmmoColor1", "0 0 0 0");
		player SetClientDvar("lowAmmoWarningNoAmmoColor2", "0 0 0 0");
    }
}

on_weapon_change() {
    self endon("disconnect");
    level endon("game_ended");
    temp = undefined;
    while(level.inGracePeriod) {
        wait 0.1;
        if ( self.sessionstate == "playing" )
        {
            if(!isdefined(temp))
                temp = self.class;
            
            if(self.class != temp) {
                //print("^2" + self.class);
                //print("^3" + temp);

                temp = self.class;

                self maps\mp\gametypes\_class::setClass( self.pers["class"] );
                self.tag_stowed_back = undefined;
                self.tag_stowed_hip = undefined;
                self maps\mp\gametypes\_class::giveLoadout( self.pers["team"], self.pers["class"] );
                //print(self maps\mp\gametypes\_class::getWeaponChoice(self.class));
                self special_class_weapon();
            }
        }
    }
}

xp_multiplier_hud_overwrite() {
    wait 1.5;

    if(isdefined(self.hud_element_xp) && isdefined(self.hud_element_xp["xp_double_xp"]))
        self.hud_element_xp["xp_double_xp"] settext(level.custom_xp_multiplier+"x");
}

no_deagle_ammo() {
    self endon("disconnect");
    for(;;){
        self setweaponammoclip("iw5_deserteagle_mp", 0);
        self setweaponammostock("iw5_deserteagle_mp", 0);
        wait 0.05;
    }
}

on_spawned() {
    self endon("disconnect");

    self.initial_spawn = true;
    for(;;) {
        self waittill("spawned_player");

        if(self.initial_spawn) {
            self.initial_spawn = false;
            self.shots_hit = 0;
            self.shots_fired = 0;
            self.headshots = 0;
            self.wallbangs = 0;
            self.highest_killstreak = 0;
            self.accuracy = 0;
            self thread shots_fired_tracker();
            self thread hud_create();
        }
        self thread anti_hardscope();

        self special_class_weapon();

        self setweaponammoclip("iw5_deserteagle_mp", 0);
        self setweaponammostock("iw5_deserteagle_mp", 0);
    }
}

special_class_weapon() {
    if(self.pers["class"] == "axis_recipe5" || self.pers["class"] == "allies_recipe5") {
        self giveweapon("iw5_cheytac_mp_cheytacscope_xmags");
        self setspawnweapon("iw5_cheytac_mp_cheytacscope_xmags");
    }
}

anti_hardscope() {
    self endon("disconnect");
    self endon("death");
    count = 0;
    for(;;) {
        wait 0.05;
        if(self AdsButtonPressed()) {
            count = 0;
            while(self AdsButtonPressed()) {
                count++;
                if(count > 15) {
                    self AllowAds(false);
                    wait 1;
                    self AllowAds(true);
                    break;
                }
                wait 0.05;
            }
        }
    }
}

PlayerDamageCallback(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime) {
	if(sMeansOfDeath == "MOD_MELEE")
        return;
    
    if(getWeaponClass( sWeapon ) != "weapon_sniper" && sWeapon != "throwingknife_mp")
        return;
    
    if(sHitLoc == "head")
        eAttacker.headshots++;

    //print(iDFlags);
    if(iDFlags == 10)
        eAttacker.wallbangs++;

	eAttacker.shots_hit++;
    self [[level.callbackplayerDamageMain]](eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime);
}

shots_fired_tracker() {
    self endon("disconnect");
    level endon("game_ended");
    
    for(;;) {
        self waittill("weapon_fired");
        self.shots_fired++;
    }
}

hud_create() {
    self endon("disconnect");

    x_spacing = 20;
    seg_fontscale = .37;
    index = 0;
    x = 80;
    y = 135;

    if (!isdefined(self.hud_elements["kills_ui"])) {
        self.hud_elements["kills_ui"] = newClientHudElem(self);
        self.hud_elements["kills_ui"].alignx = "left";
        self.hud_elements["kills_ui"].aligny = "top";
        self.hud_elements["kills_ui"].horzAlign = "fullscreen";
        self.hud_elements["kills_ui"].vertalign = "fullscreen";
        self.hud_elements["kills_ui"].x = x;
        self.hud_elements["kills_ui"].y = y + (x_spacing * index); index++;
        self.hud_elements["kills_ui"].font = "bigfixed";
        self.hud_elements["kills_ui"].fontscale = seg_fontscale;
        self.hud_elements["kills_ui"].label = &"Kills: ^8";
        // self.hud_elements["kills_ui"].hidewheninmenu = 1;
        self.hud_elements["kills_ui"].hidewheninkillcam = 1;
        self.hud_elements["kills_ui"].archived = false;
        self.hud_elements["kills_ui"].alpha = 0;
    }

    if (!isdefined(self.hud_elements["death_ui"])) {
        self.hud_elements["death_ui"] = newClientHudElem(self);
        self.hud_elements["death_ui"].alignx = "left";
        self.hud_elements["death_ui"].aligny = "top";
        self.hud_elements["death_ui"].horzAlign = "fullscreen";
        self.hud_elements["death_ui"].vertalign = "fullscreen";
        self.hud_elements["death_ui"].x = x;
        self.hud_elements["death_ui"].y = y + (x_spacing * index); index++;
        self.hud_elements["death_ui"].font = "bigfixed";
        self.hud_elements["death_ui"].fontscale = seg_fontscale;
        self.hud_elements["death_ui"].label = &"Deaths: ^8";
        // self.hud_elements["death_ui"].hidewheninmenu = 1;
        self.hud_elements["death_ui"].hidewheninkillcam = 1;
        self.hud_elements["death_ui"].archived = false;
        self.hud_elements["death_ui"].alpha = 0;
    }

    if (!isdefined(self.hud_elements["kdr_ui"])) {
        self.hud_elements["kdr_ui"] = newClientHudElem(self);
        self.hud_elements["kdr_ui"].alignx = "left";
        self.hud_elements["kdr_ui"].aligny = "top";
        self.hud_elements["kdr_ui"].horzAlign = "fullscreen";
        self.hud_elements["kdr_ui"].vertalign = "fullscreen";
        self.hud_elements["kdr_ui"].x = x;
        self.hud_elements["kdr_ui"].y = y + (x_spacing * index); index++;
        self.hud_elements["kdr_ui"].font = "bigfixed";
        self.hud_elements["kdr_ui"].fontscale = seg_fontscale;
        self.hud_elements["kdr_ui"].label = &"K/D Ratio: ^8";
        // self.hud_elements["kdr_ui"].hidewheninmenu = 1;
        self.hud_elements["kdr_ui"].hidewheninkillcam = 1;
        self.hud_elements["kdr_ui"].archived = false;
        self.hud_elements["kdr_ui"].alpha = 0;
    }

    if (!isdefined(self.hud_elements["killsstreak_ui"])) {
        self.hud_elements["killsstreak_ui"] = newClientHudElem(self);
        self.hud_elements["killsstreak_ui"].alignx = "left";
        self.hud_elements["killsstreak_ui"].aligny = "top";
        self.hud_elements["killsstreak_ui"].horzAlign = "fullscreen";
        self.hud_elements["killsstreak_ui"].vertalign = "fullscreen";
        self.hud_elements["killsstreak_ui"].x = x;
        self.hud_elements["killsstreak_ui"].y = y + (x_spacing * index); index++;
        self.hud_elements["killsstreak_ui"].font = "bigfixed";
        self.hud_elements["killsstreak_ui"].fontscale = seg_fontscale;
        self.hud_elements["killsstreak_ui"].label = &"Killstreak: ^8";
        // self.hud_elements["killsstreak_ui"].hidewheninmenu = 1;
        self.hud_elements["killsstreak_ui"].hidewheninkillcam = 1;
        self.hud_elements["killsstreak_ui"].archived = false;
        self.hud_elements["killsstreak_ui"].alpha = 0;
    }

    if (!isdefined(self.hud_elements["accuracy_ui"])) {
        self.hud_elements["accuracy_ui"] = newClientHudElem(self);
        self.hud_elements["accuracy_ui"].alignx = "left";
        self.hud_elements["accuracy_ui"].aligny = "top";
        self.hud_elements["accuracy_ui"].horzAlign = "fullscreen";
        self.hud_elements["accuracy_ui"].vertalign = "fullscreen";
        self.hud_elements["accuracy_ui"].x = x;
        self.hud_elements["accuracy_ui"].y = y + (x_spacing * index); index++;
        self.hud_elements["accuracy_ui"].font = "bigfixed";
        self.hud_elements["accuracy_ui"].fontscale = seg_fontscale;
        self.hud_elements["accuracy_ui"].label = &"Accuracy: ^8";
        // self.hud_elements["accuracy_ui"].hidewheninmenu = 1;
        self.hud_elements["accuracy_ui"].hidewheninkillcam = 1;
        self.hud_elements["accuracy_ui"].archived = false;
        self.hud_elements["accuracy_ui"].alpha = 0;
    }
    
    if (!isdefined(self.hud_elements["headshots_ui"])) {
        self.hud_elements["headshots_ui"] = newClientHudElem(self);
        self.hud_elements["headshots_ui"].alignx = "left";
        self.hud_elements["headshots_ui"].aligny = "top";
        self.hud_elements["headshots_ui"].horzAlign = "fullscreen";
        self.hud_elements["headshots_ui"].vertalign = "fullscreen";
        self.hud_elements["headshots_ui"].x = x;
        self.hud_elements["headshots_ui"].y = y + (x_spacing * index); index++;
        self.hud_elements["headshots_ui"].font = "bigfixed";
        self.hud_elements["headshots_ui"].fontscale = seg_fontscale;
        self.hud_elements["headshots_ui"].label = &"Headshots: ^8";
        // self.hud_elements["headshots_ui"].hidewheninmenu = 1;
        self.hud_elements["headshots_ui"].hidewheninkillcam = 1;
        self.hud_elements["headshots_ui"].archived = false;
        self.hud_elements["headshots_ui"].alpha = 0;
    }

    if (!isdefined(self.hud_elements["wallbangs_ui"])) {
        self.hud_elements["wallbangs_ui"] = newClientHudElem(self);
        self.hud_elements["wallbangs_ui"].alignx = "left";
        self.hud_elements["wallbangs_ui"].aligny = "top";
        self.hud_elements["wallbangs_ui"].horzAlign = "fullscreen";
        self.hud_elements["wallbangs_ui"].vertalign = "fullscreen";
        self.hud_elements["wallbangs_ui"].x = x;
        self.hud_elements["wallbangs_ui"].y = y + (x_spacing * index); index++;
        self.hud_elements["wallbangs_ui"].font = "bigfixed";
        self.hud_elements["wallbangs_ui"].fontscale = seg_fontscale;
        self.hud_elements["wallbangs_ui"].label = &"Wallbangs: ^8";
        // self.hud_elements["wallbangs_ui"].hidewheninmenu = 1;
        self.hud_elements["wallbangs_ui"].hidewheninkillcam = 1;
        self.hud_elements["wallbangs_ui"].archived = false;
        self.hud_elements["wallbangs_ui"].alpha = 0;
    }
    

    self thread stats_menu_think();

    self.kdr = 0;

    while (1) {
        if(self.deaths == 0)
            self.kdr = self.kills;
        else if(self.kills == 0)
            self.kdr = 0;
        else
            self.kdr = self.kills / self.deaths;
        
        if(self.shots_hit == 0 || self.shots_fired == 0)
            self.accuracy = 0;
        else {
            temp = str(self.shots_hit / self.shots_fired);
            self.accuracy = float(getsubstr(temp, 0, 4));
        }
        
        if(self.pers["cur_kill_streak"] > self.highest_killstreak)
            self.highest_killstreak = self.pers["cur_kill_streak"];
        
        self.hud_elements["kills_ui"] setvalue(self.kills);
        self.hud_elements["death_ui"] setvalue(self.deaths);
        self.hud_elements["kdr_ui"] setvalue(self.kdr);
        self.hud_elements["killsstreak_ui"] setValue(self.pers["cur_kill_streak"]);
        self.hud_elements["accuracy_ui"] setValue(self.accuracy);
        self.hud_elements["headshots_ui"] setValue(self.headshots);
        self.hud_elements["wallbangs_ui"] setValue(self.wallbangs);

        wait .05;
    }
}

stats_menu_think() {
    self endon("disconnect");
    level endon("game_ended");
    self notifyOnPlayerCommand( "opentab", "+scores" );
    self notifyOnPlayerCommand( "closetab", "-scores" );
    time = 0.05;
    for(;;) {
        self waittill( "opentab");

        self.hud_elements["kills_ui"].alpha = 1;
        self.hud_elements["death_ui"].alpha = 1;
        self.hud_elements["kdr_ui"].alpha = 1;
        self.hud_elements["killsstreak_ui"].alpha = 1;
        self.hud_elements["accuracy_ui"].alpha = 1;
        self.hud_elements["headshots_ui"].alpha = 1;
        self.hud_elements["wallbangs_ui"].alpha = 1;
        
        self waittill( "closetab");

        self.hud_elements["kills_ui"].alpha = 0;
        self.hud_elements["death_ui"].alpha = 0;
        self.hud_elements["kdr_ui"].alpha = 0;
        self.hud_elements["killsstreak_ui"].alpha = 0;
        self.hud_elements["accuracy_ui"].alpha = 0;
        self.hud_elements["headshots_ui"].alpha = 0;
        self.hud_elements["wallbangs_ui"].alpha = 0;
    }
}

build_best_players() {

    x = 320;
    items = 4;
    offset = 100;
    y = 80;
    startpos = x - offset*items/2;
    i=0;

    best_kdr            = undefined;
    best_accuracy       = undefined;
    best_headshots      = undefined;
    best_wallbangs      = undefined;
    best_killstreak     = undefined;

    foreach(player in level.players) {
        if(!isdefined(best_kdr))            best_kdr = player;
        if(!isdefined(best_accuracy))       best_accuracy = player;
        if(!isdefined(best_headshots))      best_headshots = player;
        if(!isdefined(best_wallbangs))      best_wallbangs = player;
        if(!isdefined(best_killstreak))     best_killstreak = player;
        
        
        if(player.kdr > best_wallbangs.best_kdr)
            best_kdr = player;

        if(player.accuracy > best_accuracy.accuracy)
            best_accuracy = player;

        if(player.headshots > best_headshots.headshots)
            best_headshots = player;

        if(player.wallbangs > best_wallbangs.wallbangs)
            best_wallbangs = player;
        
        if(player.highest_killstreak > best_killstreak.highest_killstreak)
            best_killstreak = player;
    }


    if(!isdefined(level.info_hud_elements["best_kdr"])) {
		level.info_hud_elements["best_kdr"] = newhudelem();
		level.info_hud_elements["best_kdr"].horzalign = "fullscreen";
		level.info_hud_elements["best_kdr"].vertalign = "fullscreen";
		level.info_hud_elements["best_kdr"].alignx = "center";
		level.info_hud_elements["best_kdr"].aligny = "top";
		level.info_hud_elements["best_kdr"].x = startpos + (offset * i); i++;
		level.info_hud_elements["best_kdr"].y = y;
		level.info_hud_elements["best_kdr"].font = "bigfixed";
		level.info_hud_elements["best_kdr"].archived = true;
		level.info_hud_elements["best_kdr"].hidewheninkillcam = 1;
		level.info_hud_elements["best_kdr"].fontscale = .4;
		level.info_hud_elements["best_kdr"].alpha = 0;
		level.info_hud_elements["best_kdr"] settext("^8Best K/D Ratio - ^3" + best_kdr.kdr + "\n^7" + best_kdr.name);
	}

    if(!isdefined(level.info_hud_elements["best_accuracy"])) {
		level.info_hud_elements["best_accuracy"] = newhudelem();
		level.info_hud_elements["best_accuracy"].horzalign = "fullscreen";
		level.info_hud_elements["best_accuracy"].vertalign = "fullscreen";
		level.info_hud_elements["best_accuracy"].alignx = "center";
		level.info_hud_elements["best_accuracy"].aligny = "top";
		level.info_hud_elements["best_accuracy"].x = startpos + (offset * i); i++;
		level.info_hud_elements["best_accuracy"].y = y;
		level.info_hud_elements["best_accuracy"].font = "bigfixed";
		level.info_hud_elements["best_accuracy"].archived = true;
		level.info_hud_elements["best_accuracy"].hidewheninkillcam = 1;
		level.info_hud_elements["best_accuracy"].fontscale = .4;
		level.info_hud_elements["best_accuracy"].alpha = 0;
		level.info_hud_elements["best_accuracy"] settext("^8Highest Accuracy - ^3" + best_accuracy.accuracy + "\n^7" + best_accuracy.name);
	}

    if(!isdefined(level.info_hud_elements["best_headshots"])) {
		level.info_hud_elements["best_headshots"] = newhudelem();
		level.info_hud_elements["best_headshots"].horzalign = "fullscreen";
		level.info_hud_elements["best_headshots"].vertalign = "fullscreen";
		level.info_hud_elements["best_headshots"].alignx = "center";
		level.info_hud_elements["best_headshots"].aligny = "top";
		level.info_hud_elements["best_headshots"].x = startpos + (offset * i); i++;
		level.info_hud_elements["best_headshots"].y = y;
		level.info_hud_elements["best_headshots"].font = "bigfixed";
		level.info_hud_elements["best_headshots"].archived = true;
		level.info_hud_elements["best_headshots"].hidewheninkillcam = 1;
		level.info_hud_elements["best_headshots"].fontscale = .4;
		level.info_hud_elements["best_headshots"].alpha = 0;
		level.info_hud_elements["best_headshots"] settext("^8Most Headshots - ^3" + best_headshots.headshots + "\n^7" + best_headshots.name);
	}

    if(!isdefined(level.info_hud_elements["best_wallbangs"])) {
		level.info_hud_elements["best_wallbangs"] = newhudelem();
		level.info_hud_elements["best_wallbangs"].horzalign = "fullscreen";
		level.info_hud_elements["best_wallbangs"].vertalign = "fullscreen";
		level.info_hud_elements["best_wallbangs"].alignx = "center";
		level.info_hud_elements["best_wallbangs"].aligny = "top";
		level.info_hud_elements["best_wallbangs"].x = startpos + (offset * i); i++;
		level.info_hud_elements["best_wallbangs"].y = y;
		level.info_hud_elements["best_wallbangs"].font = "bigfixed";
		level.info_hud_elements["best_wallbangs"].archived = true;
		level.info_hud_elements["best_wallbangs"].hidewheninkillcam = 1;
		level.info_hud_elements["best_wallbangs"].fontscale = .4;
		level.info_hud_elements["best_wallbangs"].alpha = 0;
		level.info_hud_elements["best_wallbangs"] settext("^8Most Wallbangs - ^3" + best_wallbangs.wallbangs + "\n^7" + best_wallbangs.name);
	}

    if(!isdefined(level.info_hud_elements["best_killstreak"])) {
		level.info_hud_elements["best_killstreak"] = newhudelem();
		level.info_hud_elements["best_killstreak"].horzalign = "fullscreen";
		level.info_hud_elements["best_killstreak"].vertalign = "fullscreen";
		level.info_hud_elements["best_killstreak"].alignx = "center";
		level.info_hud_elements["best_killstreak"].aligny = "top";
		level.info_hud_elements["best_killstreak"].x = startpos + (offset * i); i++;
		level.info_hud_elements["best_killstreak"].y = y;
		level.info_hud_elements["best_killstreak"].font = "bigfixed";
		level.info_hud_elements["best_killstreak"].archived = true;
		level.info_hud_elements["best_killstreak"].hidewheninkillcam = 1;
		level.info_hud_elements["best_killstreak"].fontscale = .4;
		level.info_hud_elements["best_killstreak"].alpha = 0;
		level.info_hud_elements["best_killstreak"] settext("^8Highest Killstreak - ^3" + best_killstreak.highest_killstreak + "\n^7" + best_killstreak.name);
	}

    foreach(player in level.players) {
        player.hud_elements["kills_ui"].alpha = 1;
        player.hud_elements["death_ui"].alpha = 1;
        player.hud_elements["kdr_ui"].alpha = 1;
        player.hud_elements["killsstreak_ui"].alpha = 1;
        player.hud_elements["accuracy_ui"].alpha = 1;
        player.hud_elements["headshots_ui"].alpha = 1;
        player.hud_elements["wallbangs_ui"].alpha = 1;
    }

    level.info_hud_elements["best_kdr"].alpha = 1;
    level.info_hud_elements["best_accuracy"].alpha = 1;
    level.info_hud_elements["best_headshots"].alpha = 1;
    level.info_hud_elements["best_wallbangs"].alpha = 1;
    level.info_hud_elements["best_killstreak"].alpha = 1;
}

processLobbyData_replace()
{
	curPlayer = 0;
	foreach ( player in level.players )
	{
		if ( !isDefined( player ) )
			continue;

		player.clientMatchDataId = curPlayer;
		curPlayer++;

		// on PS3 cap long names
		if ( level.ps3 && (player.name.size > level.MaxNameLength) )
		{
			playerName = "";
			for ( i = 0; i < level.MaxNameLength-3; i++ )
				playerName += player.name[i];

			playerName += "...";
		}
		else
		{
			playerName = player.name;
		}
		
		setClientMatchData( "players", player.clientMatchDataId, "xuid", playerName );	

	}
	
	maps\mp\_awards::assignAwards();
	maps\mp\gametypes\_scoreboard::processLobbyScoreboards();
	
	sendClientMatchData();

    foreach(player in level.players) {
        player.sessionstate = "spectator";
    }

    build_best_players();
    wait 4;
}

doFinalKillCamFX_replace( camTime )
{
	if ( isDefined( level.doingFinalKillcamFx ) )
		return;
	level.doingFinalKillcamFx = true;
	
	intoSlowMoTime = camTime;
	if ( intoSlowMoTime > 1.5 )
	{
		intoSlowMoTime = 1.5;
		wait( camTime - 1.5 );
	}
	
	setSlowMotion( 1.0, 0.5, intoSlowMoTime ); // start timescale, end timescale, lerp duration
	wait( intoSlowMoTime + .5 );
	setSlowMotion( 0.5, 1, 1.0 );
	
	level.doingFinalKillcamFx = undefined;
}
