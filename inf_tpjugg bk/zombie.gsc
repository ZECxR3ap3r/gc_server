#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;

init() {
    initializerandomitems();
    level.throwingknifefx = loadFX( "smoke/smoke_geotrail_javelin" );
    level.throwingknifeexplosionfx = loadFX( "explosions/default_explosion" );

    level.nukeInfo.xpScalar = 2;

	level.crateTypes["airdrop_assault"]["uav"] = undefined;
	level.crateFuncs["airdrop_assault"]["uav"] = undefined;
	level.crateTypes["airdrop_assault"]["airdrop_trap"] = 25;
	level.crateFuncs["airdrop_assault"]["airdrop_trap"] = maps\mp\killstreaks\_airdrop::killstreakCrateThink;
	level.crateMaxVal["airdrop_assault"] += level.crateTypes["airdrop_assault"]["airdrop_trap"];
	level.crateTypes["airdrop_assault"]["airdrop_trap"] = level.crateMaxVal["airdrop_assault"];

    level.crateTypes["airdrop_assault"]["airdrop_juggernaut"] = undefined;
    level.crateFuncs["airdrop_assault"]["airdrop_juggernaut"] = undefined;
    level.crateFuncs["airdrop_assault"]["littlebird_flock"] = undefined;
    level.sentrySettings[ "sentry_minigun" ].timeOut =				45;
	level.sentrySettings[ "sentry_minigun" ].maxHealth =			400;

    level.finalguy = false;
    level.noclearkillstreaksonaxisspawn = true;

    level.callbackPlayerKilled = ::on_player_killed;
	level.callbackPlayerDamage = ::on_player_damage;

    precacheshader("hud_us_flashgrenade");
    precacheshader("hud_us_smokegrenade");
    precacheshader("hud_us_stungrenade");
    precacheshader("hud_icon_c4");
    precacheshader("equipment_emp_grenade");

    setdvar("g_knockback", 750);

    waitframe();
    level.ac130_num_flares = 1;

    level thread lastalivewallhack();
}

lastalivewallhack() {
    level endon("game_ended");

    for(;;)
    {
        level waittill_any("connected", "killedsurvivor");
        wait .2;
        if(!level.finalguy && GetTeamPlayersAlive("allies") < 2)
        {
            level.finalguy = true;
            foreach(bozo in level.players)
            {
                if(!isdefined(bozo.haswallhack))
                    bozo ThermalVisionFOFOverlayOn();
            }
        }
        else if(level.finalguy && GetTeamPlayersAlive("allies") > 1)
        {
            level.finalguy = false;
            foreach(bozo in level.players)
            {
                if(!isdefined(bozo.haswallhack))
                    bozo ThermalVisionFOFOverlayOff();
            }
        }

    }
}

checkgoodspawn(grenade) {
    self endon("spawned_player");

    wait .05;

    while(isdefined(self.setSpawnPoint)) wait .05;

    self.goodspawn = undefined;
}

deletetacifinzone() {
    if(!isdefined(self.setSpawnPoint))
    	wait .05;

    if(isdefined(level.meat_playable_bounds) && isdefined(self.setSpawnPoint) && !scripts\inf_tpjugg\map_funcs::checkPointInsidePolygon(self.setSpawnPoint.playerSpawnPos)) {
        self iprintlnbold("^1Cannot Place Tactical Insertion Inside Resticted Area!");
        self thread maps\mp\perks\_perkfunctions::deleteTI(self.setSpawnPoint);
        self thread maps\mp\perks\_perkfunctions::setTacticalInsertion();
        return false;
    }
    else if(!isdefined(self.setSpawnPoint)) {
        print("SETSPAWNPOINT NOT DEFINED FOR PLAYER + " + self.name);
        return false;
    }
    else
        return true;
}

timeoutdelete() {
    self endon("death");

    result = self waittill_any_timeout( 10, "missile_stuck");
    if(result == "missile_stuck") {
        wait 5;
        if(isdefined(self))
            self delete();
    }
    else {
        if(isdefined(self))
            self delete();
    }
}

explosiveknife() {
    self endon("disconnect");
    self endon("death");

    self giveweapon("throwingknife_mp");

    fired = false;
    while(!fired) {
        self waittill( "grenade_fire", grenade, weapName);

        if(weapName == "throwingknife_mp") {
            grenade thread expknife(self);
            fired = true;
        }
    }
}

expknife(owner) {
    self thread checkstuck(owner);
    self playsound("ac130_40mm_fire");
    wait .1;
    self playloopsound( "move_40mm_proj_loop1" );
    playfxontag( level.throwingknifefx, self, "tag_origin" );
}

checkstuck(owner) {
    self endon("death");

    self.stuck = false;
    self waittill_notify_or_timeout( "missile_stuck", 12 );
    self.stuck = true;

    maxdam = 200;
    maxdampercent = maxdam / 100;
    maxdist = 350;
    maxdistpercent = maxdist / 100;

    self StopLoopSound(1);
    playSoundAtPos(self.Origin, "pavelow_helicopter_secondary_exp_close");
    playfx(level.throwingknifeexplosionfx, self.origin);
    PhysicsExplosionSphere( self.origin, maxdist, 0, 5 );

    foreach(player in level.players) {
        d = distance(player.origin, self.origin);
        if(d < maxdist) {
            pushamount = player DamageConeTrace(self.origin);
            fractionDist = 100 - (d / maxdistpercent);
            damage = fractiondist * maxdampercent;
            finaldamage = damage * pushamount;
            player thread [[level.CallbackPlayerDamage]](self, owner, finaldamage, 0, "MOD_EXPLOSIVE", "throwingknife_mp", self.origin, self.origin, "none", 0);
        }
    }

    wait 1;
    self delete();
}

on_player_killed(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration) {
    self.linkedto = undefined;
    self.inoomzone = false;
    self.status = "out";
    self.healthRegenLevel = undefined;
    self.haswallhack = undefined;

    if(isdefined(self.suicide_bomber) && self.suicide_bomber == 1) {
    	if(isdefined(attacker)) {
    		if(sMeansOfDeath != "MOD_FALLING" && sMeansOfDeath != "MOD_SUICIDE" && attacker.classname != "trigger_hurt") {
    			radiusdamage(self.origin, 400, 220, 20, self, "MOD_EXPLOSIVE", "c4_mp");
    			playfx(level.stealthbombfx, self.origin);
    			thread maps\mp\_utility::playsoundinspace("exp_airstrike_bomb", self.origin);
    			playrumbleonposition("artillery_rumble", self.origin);
            	earthquake(.7, .75, self.origin, 1000);
    		}
    	}

    	self.suicide_bomber = undefined;
    }

    if(self.sessionteam == "allies")
        level notify("killedsurvivor");

    if(isdefined(attacker)) {
    	if(isdefined(self.usingremote))
    		self thread cleanup_remote();
    }

    if(!self maps\mp\gametypes\_damage::killedSelf(attacker) && isdefined(attacker.classname) && attacker.classname != "trigger_hurt")
        self.rtd_canroll = 1;

   	maps\mp\gametypes\_damage::PlayerKilled_internal( eInflictor, attacker, self, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration, false );
}

on_player_damage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset) {
	if(isdefined(eAttacker)) {
		if(!self isonground() || !isplayer(eAttacker))
        	iDFlags = 4;
    }

    if(isdefined(eAttacker) && isdefined(eAttacker.using_minigun))
    	iDamage += 20;

	if(isdefined(eInflictor)) {
   		if(sMeansOfDeath == "MOD_CRUSH" && isdefined(eInflictor) && eInflictor.owner.team == self.sessionteam && self != eInflictor.owner) {
        	eInflictor thread detectinside(self);
        	return;
        }
    }

    if(isdefined(eAttacker.used_streak_team) && eAttacker.used_streak_team == "allies" && eAttacker.team == "axis" && iskillstreakweapon(sWeapon))
        return;

    if(isdefined(self.godmode) && self.godmode == 1) {
        if(isdefined(eAttacker)) {
            eAttacker iPrintLn("^3Player has Godmode!");
            eAttacker.hud_damagefeedback setShader("damage_feedback_lightarmor", 24, 48);
            eAttacker.hud_damagefeedback.alpha = 1;
            eAttacker.hud_damagefeedback.color = (1, 1, 0);
            eAttacker.hud_damagefeedback fadeOverTime(1);
            eAttacker.hud_damagefeedback.alpha = 0;
            return;
        }
    }
    else if(isdefined(eAttacker) && isdefined(eAttacker.hud_damagefeedback) && eAttacker.hud_damagefeedback.color != (1, 1, 1)) {
        eAttacker.hud_damagefeedback.color = (1, 1, 1);
        return;
    }

    if(isdefined(level.falldamagetriggers) && sMeansOfDeath == "MOD_FALLING") {
        foreach(trig in level.falldamagetriggers) {
            if(self istouching(trig))
                return;
        }
    }

   	if(isdefined(eAttacker) && eAttacker == self && (self.health - iDamage) <= 0) {
   		if(isdefined(sWeapon) && sWeapon == "remotemissile_projectile_mp")
   			self thread cleanup_remote();
   	}

	maps\mp\gametypes\_damage::Callback_PlayerDamage_internal( eInflictor, eAttacker, self, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset);
}

cleanup_remote() {
	self thermalvisionfofoverlayoff();
    self controlsunlink();
    self cameraunlink();

    if(getdvarint("camera_thirdPerson"))
       maps\mp\_utility::setthirdpersondof(1);

    self maps\mp\_utility::clearusingremote();
  	level.remotemissileinprogress = undefined;
}

detectinside(stuckplayer) {
    self endon("death");

    if(!isdefined(self.movingoutplayer))
        self.movingoutplayer = true;
    else
        return;

    while(stuckplayer istouching(self)) {
        stuckplayer setorigin(stuckplayer.origin + (0,0,5));
        wait .05;
    }
}

blackholegrenade() {
	self GiveWeapon("semtex_mp");
    self _SetActionSlot(4, "weapon", "semtex_mp");

	while(1) {
		self waittill("grenade_fire", ent, name);

		if(name == "semtex_mp") {
            ent thread delete_ifdied(self);

			wait 1.45;

            if(isdefined(ent)) {
                ent notify("exploded");

                fx = spawnfx(level.fx_airstrike_afterburner, ent.origin);
                triggerfx(fx);
                level thread create_black_hole(ent.origin, fx);
                ent playsound("harrier_fly_away");

                if(isdefined(ent))
                    ent delete();
            }

			break;
		}
	}
}

delete_ifdied(owner) {
    self endon("exploded");

    owner waittill("death");

    self delete();
}

create_black_hole(origin,fx) {
    for(i = 0;i < 100;i++) {
        foreach(player in level.players) {
        	if(player.sessionteam == "allies") {
           		distanceToBlackHole = distance(player.origin, origin);
            	if(distanceToBlackHole < 500 && player isonground()) {
            		player allowjump(0);

                	direction = (origin - player.origin);
                	direction_normalized = direction / sqrt(direction[0] * direction[0] + direction[1] * direction[1] + direction[2] * direction[2]);
                	forceMagnitude = (500 - distanceToBlackHole) / 300 * 130;

                	force = direction_normalized * forceMagnitude;

                	player SetVelocity(force);
                }
            }
        }

        wait .05;
    }

    wait .05;

    foreach(player in level.players)
    	player allowjump(1);

    fx delete();
}

initializerandomitems() {
    level.randomitems = [];

    num = level.randomitems.size;
    level.randomitems[num]                    = SpawnStruct();
    level.randomitems[num].function           = ::GodMode;
    level.randomitems[num].rollname           = "^3Godmode for 5 seconds";
    level.randomitems[num].description        = "Temporarily grants invincibility for 5 seconds.";
    level.randomitems[num].color              = (.5, .5, 0);

    num = level.randomitems.size;
    level.randomitems[num]                    = SpawnStruct();
    level.randomitems[num].function           = ::juggernaut_suicide;
    level.randomitems[num].rollname           = "^1Explosive Juggernaut";
    level.randomitems[num].description        = "Transform into a powerful & explosive, Juggernaut.";
    level.randomitems[num].color              = (.5, 0, 0);

    num = level.randomitems.size;
    level.randomitems[num]                    = SpawnStruct();
    level.randomitems[num].function           = ::blackholegrenade;
    level.randomitems[num].rollname           = "^6Black Hole Grenade!";
    level.randomitems[num].description        = "Throw a Grenade that creates a black hole, ^7Press ^:[{+actionslot 4}] ^7To Use It";
    level.randomitems[num].color              = (.6, 0, .6);

    num = level.randomitems.size;
    level.randomitems[num]                    = SpawnStruct();
    level.randomitems[num].function           = maps\mp\gametypes\_globallogic::blank;
    level.randomitems[num].rollname           = "^2Nothing!";
    level.randomitems[num].description        = "You got nothing! Better luck next time.";
    level.randomitems[num].color              = (0, .5, 0);

    num = level.randomitems.size;
    level.randomitems[num]                    = SpawnStruct();
    level.randomitems[num].function           = ::ExtraSpeed;
    level.randomitems[num].rollname           = "^2Extra Speed";
    level.randomitems[num].description        = "Increased Movement Speed";
    level.randomitems[num].color              = (0, .5, 0);

    num = level.randomitems.size;
    level.randomitems[num]                    = SpawnStruct();
    level.randomitems[num].function           = ::SMAW;
    level.randomitems[num].rollname           = "^2SMAW";
    level.randomitems[num].description        = "Equip a SMAW.";
    level.randomitems[num].color              = (0, .5, 0);

    num = level.randomitems.size;
    level.randomitems[num]                    = SpawnStruct();
    level.randomitems[num].function           = ::Stinger;
    level.randomitems[num].rollname           = "^2Stinger";
    level.randomitems[num].description        = "Equip a Stinger.";
    level.randomitems[num].color              = (0, .5, 0);

    num = level.randomitems.size;
    level.randomitems[num]                    = SpawnStruct();
    level.randomitems[num].function           = ::lowhealthquick;
    level.randomitems[num].rollname           = "^1Increased Speed, Reduced Health";
    level.randomitems[num].description        = "Sacrifice health for increased speed.";
    level.randomitems[num].color              = (.5, 0, 0);

    num = level.randomitems.size;
    level.randomitems[num]                    = SpawnStruct();
    level.randomitems[num].function           = ::Javelin;
    level.randomitems[num].rollname           = "^4Javelin";
    level.randomitems[num].description        = "Equip a Javelin";
    level.randomitems[num].color              = (0, 0, .5);

    num = level.randomitems.size;
    level.randomitems[num]                    = SpawnStruct();
    level.randomitems[num].function           = ::Juggernaut;
    level.randomitems[num].rollname           = "^2Juggernaut";
    level.randomitems[num].description        = "Become a Juggernaut.";
    level.randomitems[num].color              = (0, .5, 0);

    num = level.randomitems.size;
    level.randomitems[num]                    = SpawnStruct();
    level.randomitems[num].function           = ::OneBullet;
    level.randomitems[num].rollname           = "^2One Bullet";
    level.randomitems[num].description        = "Receive only one bullet in your weapon.";
    level.randomitems[num].color              = (0, .5, 0);

    num = level.randomitems.size;
    level.randomitems[num]                    = SpawnStruct();
    level.randomitems[num].function           = ::PowerfulJuggernaut;
    level.randomitems[num].rollname           = "^3Powerful Juggernaut";
    level.randomitems[num].description        = "Become an powerful Juggernaut.";
    level.randomitems[num].color              = (.5, .5, 0);

    num = level.randomitems.size;
    level.randomitems[num]                    = SpawnStruct();
    level.randomitems[num].function           = ::C4;
    level.randomitems[num].rollname           = "^2C4";
    level.randomitems[num].description        = "Equip a C4, Press ^:[{+actionslot 4}] ^7To Use It!";
    level.randomitems[num].color              = (0, .5, 0);

    num = level.randomitems.size;
    level.randomitems[num]                    = SpawnStruct();
    level.randomitems[num].function           = ::FlashBang;
    level.randomitems[num].rollname           = "^2Flash Bang";
    level.randomitems[num].description        = "Equip a Flash Grenade, Press ^:[{+actionslot 4}] ^7To Use It!";
    level.randomitems[num].color              = (0, .5, 0);

    num = level.randomitems.size;
    level.randomitems[num]                    = SpawnStruct();
    level.randomitems[num].function           = ::ConcussionGrenade;
    level.randomitems[num].rollname           = "^2Concussion Grenade";
    level.randomitems[num].description        = "Equip a Concussion Grenade, Press ^:[{+actionslot 4}] ^7To Use It!";
    level.randomitems[num].color              = (0, .5, 0);

    num = level.randomitems.size;
    level.randomitems[num]                    = SpawnStruct();
    level.randomitems[num].function           = ::EmpGrenade;
    level.randomitems[num].rollname           = "^2EMP Grenade";
    level.randomitems[num].description        = "Equip a EMP Grenade, Press ^:[{+actionslot 4}] ^7To Use It!";
    level.randomitems[num].color              = (0, .5, 0);

    num = level.randomitems.size;
    level.randomitems[num]                    = SpawnStruct();
    level.randomitems[num].function           = ::smokegrenade;
    level.randomitems[num].rollname           = "^2Smoke Grenade";
    level.randomitems[num].description        = "Equip a Smoke Grenade, Press ^:[{+actionslot 4}] ^7To Use It!";
    level.randomitems[num].color              = (0, .5, 0);

    num = level.randomitems.size;
    level.randomitems[num]                    = SpawnStruct();
    level.randomitems[num].function           = ::Akimbo;
    level.randomitems[num].rollname           = "^2Akimbo";
    level.randomitems[num].description        = "Equip Akimbo Pistols.";
    level.randomitems[num].color              = (0, .5, 0);

    num = level.randomitems.size;
    level.randomitems[num]                    = SpawnStruct();
    level.randomitems[num].function           = ::magnum44;
    level.randomitems[num].rollname           = "^2Magnum 44";
    level.randomitems[num].description        = "Equip a Magnum 44";
    level.randomitems[num].color              = (0, .5, 0);

    num = level.randomitems.size;
    level.randomitems[num]                    = SpawnStruct();
    level.randomitems[num].function           = ::TerminatorJuggernaut;
    level.randomitems[num].rollname           = "^1Terminator Juggernaut";
    level.randomitems[num].description        = "Become a Terminator Juggernaut.";
    level.randomitems[num].color              = (.5, 0, 0);

    num = level.randomitems.size;
    level.randomitems[num]                    = SpawnStruct();
    level.randomitems[num].function           = ::RPG;
    level.randomitems[num].rollname           = "^2RPG";
    level.randomitems[num].description        = "Equip a RPG";
    level.randomitems[num].color              = (0, .5, 0);

    num = level.randomitems.size;
    level.randomitems[num]                    = SpawnStruct();
    level.randomitems[num].function           = ::ATW;
    level.randomitems[num].rollname           = "^2AT4";
    level.randomitems[num].description        = "Equip a AT4";
    level.randomitems[num].color              = (0, .5, 0);

    num = level.randomitems.size;
    level.randomitems[num]                    = SpawnStruct();
    level.randomitems[num].function           = ::UnlimitedKnifes;
    level.randomitems[num].rollname           = "^2Unlimited Knifes";
    level.randomitems[num].description        = "Gain unlimited Throwingknifes.";
    level.randomitems[num].color              = (0, .5, 0);

    num = level.randomitems.size;
    level.randomitems[num]                    = SpawnStruct();
    level.randomitems[num].function           = ::Riotshield;
    level.randomitems[num].rollname           = "^2Riotshield";
    level.randomitems[num].description        = "Equip a Riotshield.";
    level.randomitems[num].color              = (0, .5, 0);

    num = level.randomitems.size;
    level.randomitems[num]                    = SpawnStruct();
    level.randomitems[num].function           = ::Wallhack;
    level.randomitems[num].rollname           = "^2Wallhack for 30 seconds";
    level.randomitems[num].description        = "Gain temporary wallhacks.";
    level.randomitems[num].color              = (0, .5, 0);

    num = level.randomitems.size;
    level.randomitems[num]                    = SpawnStruct();
    level.randomitems[num].function           = ::ExplosiveKnife;
    level.randomitems[num].rollname           = "^2Exploding Throwingknife";
    level.randomitems[num].description        = "Throw an explosive throwing knife.";
    level.randomitems[num].color              = (0, .5, 0);

    num = level.randomitems.size;
    level.randomitems[num]                    = SpawnStruct();
    level.randomitems[num].function           = ::givecoldblooded;
    level.randomitems[num].rollname           = "^2Cold Blooded";
    level.randomitems[num].description        = "Run Past Enemy Sentry Turrets";
    level.randomitems[num].color              = (0, .5, 0);

    num = level.randomitems.size;
    level.randomitems[num]                    = SpawnStruct();
    level.randomitems[num].rollname           = "^4Ballistic Vest";
    level.randomitems[num].description        = "Equip a Ballistic Vest";
    level.randomitems[num].color              = (0, 0, .5);

    // Decoy
    // Shockwave Grenade
    // Super Jump
    // Ice Grenade
    // Gas Grenade

}

DoRandom() {
    self endon("death");
    wait .05;
    roll = randomint(level.randomitems.size);

    if(level.randomitems[roll].rollname == "^4Ballistic Vest")
        self [[ level.killStreakFuncs["light_armor"] ]]();
    else
        self thread [[level.randomitems[roll].function]]();

    iPrintLn("^:" + self.name + "^7 Rolled " + level.randomitems[roll].rollname);
    self thread send_hud_notification_handler(level.randomitems[roll].rollname, level.randomitems[roll].description, level.randomitems[roll].color);
}

send_hud_notification_handler(text1, text2, color) {
    if(isdefined(self.notificationtitle)) {
        self.notificationtitle destroy();
        self.notificationtext destroy();
        self.notification_bg destroy();

        self notify("hud_new_input");
    }

    self thread send_hud_notification(text1, text2, color);
}

send_hud_notification(text1, text2, backgroundcolor) {
    self endon("disconnect");
    self endon("hud_new_input");

    if(isdefined(text1)) {
        self.notificationtitle = newClientHudElem(self);
        self.notificationtitle.x = 320;
        self.notificationtitle.y = 340;
        self.notificationtitle.alignx = "center";
        self.notificationtitle.aligny = "middle";
        self.notificationtitle.horzalign = "fullscreen";
        self.notificationtitle.vertalign = "fullscreen";
        self.notificationtitle.alpha = 1;
        self.notificationtitle.sort = 1;
        self.notificationtitle.fontscale = .55;
        self.notificationtitle.font = "bigfixed";
        self.notificationtitle.foreground = 0;
        self.notificationtitle.HideWhenInMenu = 1;
        self.notificationtitle.archived = 1;
        self.notificationtitle settext(text1);

        self.notificationtext = newClientHudElem(self);
        self.notificationtext.x = 320;
        self.notificationtext.y = 355;
        self.notificationtext.alignx = "center";
        self.notificationtext.aligny = "middle";
        self.notificationtext.horzalign = "fullscreen";
        self.notificationtext.vertalign = "fullscreen";
        self.notificationtext.alpha = 1;
        self.notificationtext.sort = 1;
        self.notificationtext.fontscale = 1.3;
        self.notificationtext.color = (1, 1, 1);
        self.notificationtext.font = "small";
        self.notificationtext.foreground = 0;
        self.notificationtext.HideWhenInMenu = 1;
        self.notificationtext.archived = 1;
        self.notificationtext settext(text2);

        self.notification_bg = newClientHudElem(self);
        self.notification_bg.x = 320;
        self.notification_bg.y = 332;
        self.notification_bg.alignx = "center";
        self.notification_bg.aligny = "top";
        self.notification_bg.horzalign = "fullscreen";
        self.notification_bg.vertalign = "fullscreen";
        self.notification_bg.alpha = .7;
        self.notification_bg.sort = 0;
        self.notification_bg.color = backgroundcolor;
        self.notification_bg.foreground = 0;
        self.notification_bg.HideWhenInMenu = 1;
        self.notification_bg.archived = 1;
        self.notification_bg setshader("line_horizontal", int(text2.size * 6), 33);
    }

    self playlocalsound( "copycat_steal_class" );
    wait 3.5;
    self.notificationtext fadeovertime(.2);
    self.notificationtitle fadeovertime(.2);
    self.notification_bg fadeovertime(.2);
    self.notificationtitle.alpha = 0;
    self.notificationtext.alpha = 0;
    self.notification_bg.alpha = 0;
    wait .3;
    self.notificationtitle destroy();
    self.notificationtext destroy();
    self.notification_bg destroy();
}

ExtraSpeed() {
    self thread Speed(1.5);
}

SMAW() {
    self GiveWeapon("iw5_smaw_mp");
    self SwitchToWeaponImmediate("iw5_smaw_mp");
}

Javelin() {
    self GiveWeapon("javelin_mp");
    self SwitchToWeaponImmediate("javelin_mp");
}

OneBullet() {
    weapon3 = "iw5_dragunov_mp_dragunovscope";
    self GiveWeapon(weapon3);
    self setweaponammoclip(weapon3, 1);
    self setweaponammostock(weapon3, 0);
    self SwitchToWeaponImmediate(weapon3);
    self thread onebulletwatcher();
}

onebulletwatcher()
{
    self endon("disconnect");
    self endon("death");

    fired = false;
    while(!fired)
    {
        self waittill( "weapon_fired", weapName);

        if ( weapName == "iw5_dragunov_mp_dragunovscope" )
        {
            wait 1;
            self takeweapon("iw5_dragunov_mp_dragunovscope");
            self switchtoweapon("iw5_usp45_mp_tactical");
            fired = true;
        }
    }
}

Stinger() {
    self GiveWeapon("stinger_mp");
    self SwitchToWeaponImmediate("stinger_mp");
}

Juggernaut() {
    self.maxhealth = self.Health * 3;
    self.Health = self.Health * 3;
    self.healthRegenLevel = .33;
    self setmodel("mp_fullbody_opforce_juggernaut");
    self setviewmodel("viewhands_juggernaut_opforce");
    wait .05;
    self attachshieldmodel("weapon_riot_shield_mp", "tag_shield_back");

    self.moveSpeedScaler = .90;
    self maps\mp\gametypes\_weapons::updateMoveSpeedScale();
}

juggernaut_suicide() {
    self.maxhealth = self.Health * 5;
    self.Health = self.Health * 5;
    self.healthRegenLevel = .33;
    wait .05;
    self thread play_tick_sound();
    self attach("weapon_c4_bombsquad", "j_shoulder_le");
    self attach("weapon_c4_bombsquad", "j_shoulder_ri");
    self setmodel("mp_fullbody_opforce_juggernaut");
    self setviewmodel("viewhands_juggernaut_opforce");
    self.moveSpeedScaler = .8;
    self maps\mp\gametypes\_weapons::updateMoveSpeedScale();
 	self.suicide_bomber = 1;
}

play_tick_sound() {
	self endon("disconnect");

	while(isalive(self)) {
		self playsound("scrambler_beep");
		wait 1.25;
	}
}

PowerfulJuggernaut() {
	self.maxhealth = 100;
	self.health = self.maxhealth;

    self.maxhealth = self.Health * 5;
    self.Health = self.Health * 5;
    self.healthRegenLevel = .66;
    self setmodel("mp_fullbody_opforce_juggernaut");
    self setviewmodel("viewhands_juggernaut_opforce");
    self SetPerk("specialty_fastermelee", true, true);
    self SetPerk("specialty_lightweight", true, true);
    wait .05;
    self attachshieldmodel("weapon_riot_shield_mp", "tag_shield_back");

    self.moveSpeedScaler = .80;
    self maps\mp\gametypes\_weapons::updateMoveSpeedScale();
}
TerminatorJuggernaut() {
    self.maxhealth = self.Health * 10;
    self.Health = self.Health * 10;
    self.healthRegenLevel = .99;
    self setmodel("mp_fullbody_opforce_juggernaut");
    self setviewmodel("viewhands_juggernaut_opforce");

    self.moveSpeedScaler = .70;
    self maps\mp\gametypes\_weapons::updateMoveSpeedScale();
}

lowhealthquick() {
    self.maxhealth = 50;
    self.Health = 50;
    self thread Speed(1.8);
}

ATW() {
    self GiveWeapon("at4_mp");
    self setweaponammoclip("at4_mp", 1);
    self setweaponammostock("at4_mp", 1);
    self SwitchToWeaponImmediate("at4_mp");
}

RPG() {
    self GiveWeapon("rpg_mp");
    self setweaponammoclip("rpg_mp", 1);
    self setweaponammostock("rpg_mp", 1);
    self SwitchToWeaponImmediate("rpg_mp");
}

Akimbo() {
    wait .05;
    self TakeWeapon(self GetCurrentWeapon());
    self GiveWeapon("iw5_usp45_mp_akimbo");
    self setweaponammostock("iw5_usp45_mp_akimbo", 0);
    self SwitchToWeaponImmediate("iw5_usp45_mp_akimbo");
}

GodMode() {
    self endon("stopGodMode");
    self endon("disconnect");
    self endon("game_ended");

    self.godmode = 1;

    wait 1;

    for(i = 5;i >= 0;i--) {
        if(i != 0) {
            self iprintlnbold("Godmode For " + i + " Seconds");
            wait 1;
        }
        else
            self iprintlnbold("Godmode Turned Off");
    }

    self.godmode = undefined;
    self notify("stopGodMode");
}

UnlimitedKnifes() {
    self endon("stopKnifes");
    self endon("death");
    self endon("disconnect");
    self endon("game_ended");

    self GiveWeapon("throwingknife_mp");
    self SetOffhandPrimaryClass( "throwingknife" );

    for(;;) {
        self waittill("grenade_fire", grenade, weapName);

        if (weapName == "throwingknife_mp") {
            wait .40;
            self SetWeaponAmmoClip("throwingknife_mp", 1);
        }
    }
}

Riotshield() {
    self GiveWeapon("riotshield_mp");
    self SwitchToWeaponImmediate("riotshield_mp");
}

magnum44() {
    self GiveWeapon("iw5_44magnum_mp");
    self setweaponammostock("iw5_44magnum_mp", 0);
    self SwitchToWeaponImmediate("iw5_44magnum_mp");
}

PrintRollNames(name) {
    self iPrintLnBold("You rolled - " + name);
    iPrintLn(self.name + " rolled  - " + name);
}

ResetPlayer() {
    wait .05;
    self notify("stopKnifes");
    self notify("stopSpeed");
    self ThermalVisionFOFOverlayOff();
    self.maxhealth = 100;
    self.Health = 100;
    self.rtd_canroll = 0;
    self.moveSpeedScaler = 1;
    self maps\mp\gametypes\_weapons::updateMoveSpeedScale();
}

Wallhack() {
    self endon("death");
    self endon("stopWh");
    self endon("disconnect");
    self endon("game_ended");

    self.haswallhack = true;
    self ThermalVisionFOFOverlayOn();
    wait 30;
    self ThermalVisionFOFOverlayOff();
    self.haswallhack = undefined;
    self notify("stopWh");
}

givecoldblooded()
{
    while(self.avoidKillstreakOnSpawnTimer > 0)
    wait .05;

    wait .05;
    self givePerk( "specialty_blindeye", false );
    self givePerk( "specialty_fasterlockon", false );
}

Speed(scale)
{
    self endon("stopSpeed");
    self endon("death");
    self endon("disconnect");
    self endon("game_ended");

    for(;;){
        if(isDefined(self) && isPlayer(self) && isAlive(self)){
            self.moveSpeedScaler = scale;	self maps\mp\gametypes\_weapons::updateMoveSpeedScale();
        }
        wait .500;
    }
}

C4() {
    self GiveWeapon("c4_mp");
    self _SetActionSlot(4, "weapon", "c4_mp");
    self thread equipmenthud("c4_mp");
}

FlashBang() {
    self GiveWeapon("flash_grenade_mp");
    self _SetActionSlot(4, "weapon", "flash_grenade_mp");
    self thread equipmenthud("flash_grenade_mp");
}

smokegrenade() {
    self GiveWeapon("smoke_grenade_mp");
    self _SetActionSlot(4, "weapon", "smoke_grenade_mp");
    self thread equipmenthud("smoke_grenade_mp");
}

ConcussionGrenade() {
    self GiveWeapon("concussion_grenade_mp");
    self _SetActionSlot(4, "weapon", "concussion_grenade_mp");
    self thread equipmenthud("concussion_grenade_mp");
}

EmpGrenade() {
    self GiveWeapon("emp_grenade_mp");
    self _SetActionSlot(4, "weapon", "emp_grenade_mp");
    self thread equipmenthud("emp_grenade_mp");
}

equipmenthud(gunname)
{
    self endon("disconnect");
    self endon("death");
    self endon("stopequipmenthud");

    self.equipmenthudicon = self createFontString( "default", 1.0);
	self.equipmenthudicon setPoint( "CENTER", "BOTTOMRIGHT", -67, -12 );
    self.equipmenthudicon.HideWhenInMenu = true;
    self.equipmenthudicon.HideWhenInkillcam = true;
    self.equipmenthudicon.HideWhendead = true;
    self.equipmenthudicon.foreground = false;
    self.equipmenthudicon.alpha = 1;
    //self.equipmenthud.color = (1,0,0);
	self.equipmenthudicon.archived = false;

    self.equipmenthudnum = self createFontString( "default", 1.3);
	self.equipmenthudnum setPoint( "CENTER", "BOTTOMRIGHT", -62, -8 );
    self.equipmenthudnum.HideWhenInMenu = true;
    self.equipmenthudnum.HideWhenInkillcam = true;
    self.equipmenthudnum.HideWhendead = true;
    self.equipmenthudnum.foreground = true;
    self.equipmenthudnum setvalue(self getammocount(gunname));
    self.equipmenthudnum.alpha = 1;
    //self.equipmenthudnum.color = (1,0,0);
	self.equipmenthudnum.archived = false;




    if(gunname == "smoke_grenade_mp")
    {
        self.equipmenthudicon setShader("hud_us_smokegrenade", 21, 21);
    }
    else if(gunname == "concussion_grenade_mp")
    {
        self.equipmenthudicon setShader("hud_us_stungrenade", 21, 21);
    }
    else if(gunname == "emp_grenade_mp")
    {
        self.equipmenthudicon setShader("equipment_emp_grenade", 21, 21);
    }
    else if(gunname == "flash_grenade_mp")
    {
        self.equipmenthudicon setShader("hud_us_flashgrenade", 21, 21);
    }
    else if(gunname == "c4_mp")
    {
        self.equipmenthudicon setShader("hud_icon_c4", 21, 21);
    }

    self thread destroyequipmenthudondeath();


    while(true)
    {
        self waittill( "grenade_fire", grenade, weapName);

        if(weapname == gunname)
        {
            if(self getammocount(gunname) == 0)
            {
                if(isdefined(self.equipmenthudicon)) self.equipmenthudicon destroy();
                if(isdefined(self.equipmenthudnum)) self.equipmenthudnum destroy();
                self notify("stopequipmenthud");
            }
            else
            {
                self.equipmenthudnum setvalue(self getammocount(gunname));
            }
        }
    }
}

destroyequipmenthudondeath()
{
    self waittill("death");
    if(isdefined(self.equipmenthudicon)) self.equipmenthudicon destroy();
    if(isdefined(self.equipmenthudnum)) self.equipmenthudnum destroy();
}











