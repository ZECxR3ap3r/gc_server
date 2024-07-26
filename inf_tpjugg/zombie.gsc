#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;

init() {
    initializerandomitems();
    level.throwingknifefx = loadFX( "smoke/smoke_geotrail_javelin" );
    level.throwingknifeexplosionfx = loadFX( "explosions/default_explosion" );
    level.smokelauncher_fx = loadfx( "smoke/smoke_grenade_11sec_mp" );
    
    //attachshieldmodel powerfull jugg

    //replacefunc(maps\mp\_utility::givePerk, ::givePerk_replace);
    replacefunc(maps\mp\_utility::isKillstreakWeapon, ::isKillstreakWeapon_Replace);

    level.nukeInfo.xpScalar = 2;

    level.finalguy = 0;
    level.noclearkillstreaksonaxisspawn = 1;

    level.callbackPlayerKilled = ::on_player_killed;
	level.callbackPlayerDamage = ::on_player_damage;

    precacheshader("hud_us_flashgrenade");
    precacheshader("hud_us_smokegrenade");
    precacheshader("hud_us_stungrenade");
    precacheshader("hud_icon_c4");
    precacheshader("equipment_emp_grenade");
    precacheshader("compassping_explosion");

    setdvar("g_knockback", 700);

    wait 1;

    level.ac130_num_flares = 1;
}

checkgoodspawn(grenade) {
    self endon("spawned_player");

    while(isdefined(self.setSpawnPoint))
        wait .05;

    self.goodspawn = undefined;
}

deletetacifinzone() {
    if(!isdefined(self.setSpawnPoint))
    	wait .05;

    if(isdefined(level.meat_playable_bounds) && isdefined(self.setSpawnPoint) && !scripts\inf_tpjugg\map_funcs::checkPointInsidePolygon(self.setSpawnPoint.playerSpawnPos)) {
        self iprintlnbold("^1Cannot Place Tactical Insertion Inside Resticted Area!");
        self thread maps\mp\perks\_perkfunctions::deleteTI(self.setSpawnPoint);
        self thread maps\mp\perks\_perkfunctions::setTacticalInsertion();
        return 0;
    }
    else if(!isdefined(self.setSpawnPoint)) {
        print("SETSPAWNPOINT NOT DEFINED FOR PLAYER + " + self.name);
        return 0;
    }
    else
        return 1;
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

    powerup_hud = self createFontString( "default", 1.0);
	powerup_hud setPoint( "center", "BOTTOMRIGHT", -90, -14 );
    powerup_hud setShader("compassping_explosion", 24, 24);
    powerup_hud.HideWhenInMenu = 1;
    powerup_hud.HideWhenInkillcam = 1;
    powerup_hud.HideWhendead = 1;
    powerup_hud.alpha = 1;
    //powerup_hud.color = (1,0,0);
	powerup_hud.archived = 1;
    powerup_hud thread delete_on_death(self);
    
    self giveweapon("throwingknife_mp");

    fired = 0;
    while(!fired) {
        self waittill( "grenade_fire", grenade, weapName);

        if(weapName == "throwingknife_mp") {
            self notify("used_exp_tk");
            grenade thread expknife(self);
            fired = 1;
        }
    }
}

delete_on_death(owner) {
    owner waittill_any("death","disconnect","used_exp_tk");
    self destroy();
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

    self.stuck = 0;
    self waittill_notify_or_timeout( "missile_stuck", 12 );
    self.stuck = 1;

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
    self.inoomzone = 0;
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

    if(isdefined(level.nukeinfo.player) && level.nukeinfo.player == self && isdefined(attacker.name))
        level.nukeinfo.player.nukekiller = attacker;

    if(self.sessionteam == "allies")
        level notify("killedsurvivor");

    if(isdefined(attacker)) {
    	if(isdefined(self.usingremote))
    		self thread cleanup_remote();
    }

    if(isdefined(attacker.classname)) {
        if(!self maps\mp\gametypes\_damage::killedSelf(attacker) && attacker.classname != "trigger_hurt")
            self.rtd_canroll = 1;

        if((sMeansOfDeath == "MOD_SUICIDE" || sMeansOfDeath == "MOD_FALLING" || sMeansOfDeath == "MOD_TRIGGER_HURT") && level.teamCount["allies"] == 1 && self.team == "allies") {
            setdvar("suicide_final", self.guid);
        }
    }

   	maps\mp\gametypes\_damage::PlayerKilled_internal( eInflictor, attacker, self, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration, 0 );

    /*if(isdefined(attacker) && sWeapon == "remote_turret_mp") {
        if(attacker.adrenaline != 0) {
            self.adrenaline--;
            self setClientDvar("ui_adrenaline", self.adrenaline);
            self maps\mp\killstreaks\_killstreaks::updateStreakCount();
        }
    }*/
}

on_player_damage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset) {
	if(sWeapon == "m320_mp") {
        if(isdefined(eInflictor) && isdefined(eInflictor.smoke)) {
            return;
        }
    }
    if(sWeapon == "m320_mp") {
        if(isdefined(eInflictor) && isdefined(eInflictor.smoke)) {
            return;
        }
    }
    
    if(isdefined(eAttacker)) {
		if(!self isonground() || !isplayer(eAttacker))
        	iDFlags = 4;
        
        if(isdefined(eAttacker.using_minigun))
            iDamage += 20;

        if(isdefined(eInflictor) && isdefined(eInflictor.heli_explode_death)) {
			self maps\mp\gametypes\_damage::finishPlayerDamageWrapper( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset, 0.0 );
            return;
        }

        if(isdefined(eAttacker.used_streak_team) && eAttacker.used_streak_team == "allies" && eAttacker.team == "axis" && iskillstreakweapon(sWeapon)) {
            //print("trying team damage");
            return;
        }
    }

	if(isdefined(eInflictor)) {
   		if(sMeansOfDeath == "MOD_CRUSH" && isdefined(eInflictor) && eInflictor.owner.team == self.sessionteam && self != eInflictor.owner) {
        	eInflictor thread detectinside(self);
        	return;
        }
    }

    if(isdefined(self.godmode) && self.godmode == 1) {
        if(isdefined(eAttacker) && IsPlayer(eAttacker) ) {
            eAttacker iPrintLn("^3Player has Godmode!");
            eAttacker.hud_damagefeedback setShader("damage_feedback_lightarmor", 24, 48);
            eAttacker.hud_damagefeedback.alpha = 1;
            eAttacker.hud_damagefeedback.color = (1, 1, 0);
            eAttacker.hud_damagefeedback fadeOverTime(1);
            eAttacker.hud_damagefeedback.alpha = 0;
            return;
        }
    }
    else if(isdefined(eAttacker)  && IsPlayer(eAttacker) && isdefined(eAttacker.hud_damagefeedback) && eAttacker.hud_damagefeedback.color != (1, 1, 1)) {
        eAttacker.hud_damagefeedback.color = (1, 1, 1);
        return;
    }
    
    if(isdefined(level.falldamagetriggers) && sMeansOfDeath == "MOD_FALLING") {
        foreach(trig in level.falldamagetriggers) {
            if(self istouching(trig)) {
                self playlocalsound("vest_deployed");
                return;
            }
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

    self maps\mp\_utility::clearusingremote();
  	level.remotemissileinprogress = undefined;
}

detectinside(stuckplayer) {
    self endon("death");

    if(!isdefined(self.movingoutplayer))
        self.movingoutplayer = 1;
    else
        return;

    while(stuckplayer istouching(self)) {
        stuckplayer setorigin(stuckplayer.origin + (0,0,5));
        wait .05;
    }
}

blackholegrenade() {
    self endon("death");
    self endon("disconnect");

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

    if(isdefined(self))
        self delete();
}

create_black_hole(origin,fx) {
    for(i = 0;i < 50;i++) {
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

        wait .1;
    }

    wait .1;

    foreach(player in level.players)
    	player allowjump(1);

    fx delete();
}

initializerandomitems() {
    devprint = false;
    
    //////////////////////////////////////////////////////////////////////////////////////////
    //  set the highest roll items at the bottom of the list, for now.                      //
    //  maybe in the future i organize the array. this is for small performance improvement //
    //////////////////////////////////////////////////////////////////////////////////////////

    level.roll_items = [];

    level.roll_items["nothing"]                         = SpawnStruct();
    level.roll_items["nothing"].rollname                = "^2Nothing!";
    level.roll_items["nothing"].weight                  = 7;
    level.roll_items["nothing"].function                = maps\mp\gametypes\_globallogic::blank;
    level.roll_items["nothing"].description             = "You got nothing! Better luck next time";
    level.roll_items["nothing"].color                   = (0, .5, 0);

    level.roll_items["smaw"]                            = SpawnStruct();
    level.roll_items["smaw"].rollname                   = "^2SMAW";
    level.roll_items["smaw"].weight                     = 15;
    level.roll_items["smaw"].function                   = ::SMAW;
    level.roll_items["smaw"].description                = "You have a SMAW rocket launcher";
    level.roll_items["smaw"].color                      = (0, .5, 0);

    level.roll_items["m320"]                            = SpawnStruct();
    level.roll_items["m320"].rollname                   = "^2M320";
    level.roll_items["m320"].weight                     = 17;
    level.roll_items["m320"].function                   = ::M_320;
    level.roll_items["m320"].description                = "You have a Noob Tube";
    level.roll_items["m320"].color                      = (0, .5, 0);

    level.roll_items["m320_smoke"]                      = SpawnStruct();
    level.roll_items["m320_smoke"].rollname             = "^2Smoke Launcher";
    level.roll_items["m320_smoke"].weight               = 24;
    level.roll_items["m320_smoke"].function             = ::M_320_smoke;
    level.roll_items["m320_smoke"].description          = "You have a Smoke Launcher";
    level.roll_items["m320_smoke"].color                = (0, .5, 0);

    level.roll_items["javelin"]                         = SpawnStruct();
    level.roll_items["javelin"].rollname                = "^4Javelin";
    level.roll_items["javelin"].weight                  = 20;
    level.roll_items["javelin"].function                = ::Javelin;
    level.roll_items["javelin"].description             = "You have a Javelin";
    level.roll_items["javelin"].color                   = (0, 0, .5);

    level.roll_items["rpg"]                             = SpawnStruct();
    level.roll_items["rpg"].rollname                    = "^2RPG";
    level.roll_items["rpg"].weight                      = 23;
    level.roll_items["rpg"].function                    = ::RPG;
    level.roll_items["rpg"].description                 = "You have an RPG";
    level.roll_items["rpg"].color                       = (0, .5, 0);

    level.roll_items["at4"]                             = SpawnStruct();
    level.roll_items["at4"].rollname                    = "^2AT4";
    level.roll_items["at4"].weight                      = 15;
    level.roll_items["at4"].function                    = ::ATW;
    level.roll_items["at4"].description                 = "You have an AT4";
    level.roll_items["at4"].color                       = (0, .5, 0);

    level.roll_items["stinger"]                         = SpawnStruct();
    level.roll_items["stinger"].rollname                = "^2Stinger";
    level.roll_items["stinger"].weight                  = 10;
    level.roll_items["stinger"].function                = ::Stinger;
    level.roll_items["stinger"].description             = "You have a Stinger rocket launcher";
    level.roll_items["stinger"].color                   = (0, .5, 0);

    level.roll_items["speed_1"]                         = SpawnStruct();
    level.roll_items["speed_1"].rollname                = "^2Extra Speed";
    level.roll_items["speed_1"].weight                  = 18;
    level.roll_items["speed_1"].function                = ::ExtraSpeed;
    level.roll_items["speed_1"].description             = "Increased Movement Speed";
    level.roll_items["speed_1"].color                   = (0, .5, 0);

    level.roll_items["speed_2"]                         = SpawnStruct();
    level.roll_items["speed_2"].rollname                = "^1Increased Speed, Reduced Health";
    level.roll_items["speed_2"].weight                  = 14;
    level.roll_items["speed_2"].function                = ::lowhealthquick;
    level.roll_items["speed_2"].description             = "You have less Health, but move much Faster";
    level.roll_items["speed_2"].color                   = (.5, 0, 0);

    level.roll_items["ballistic_vest"]                  = SpawnStruct();
    level.roll_items["ballistic_vest"].rollname         = "^4Ballistic Vest";
    level.roll_items["ballistic_vest"].weight           = 22;
    level.roll_items["ballistic_vest"].function         = level.killStreakFuncs["light_armor"];
    level.roll_items["ballistic_vest"].description      = "You have a Ballistic Vest (200 HP).";
    level.roll_items["ballistic_vest"].color            = (0, 0, .5);

    level.roll_items["jugg"]                            = SpawnStruct();
    level.roll_items["jugg"].rollname                   = "^2Juggernaut";
    level.roll_items["jugg"].weight                     = 15;
    level.roll_items["jugg"].function                   = ::Juggernaut;
    level.roll_items["jugg"].description                = "You're a Juggernaut (300 HP).";
    level.roll_items["jugg"].color                      = (0, .5, 0);

    level.roll_items["jugg_power"]                      = SpawnStruct();
    level.roll_items["jugg_power"].rollname             = "^3Powerful Juggernaut";
    level.roll_items["jugg_power"].weight               = 12;
    level.roll_items["jugg_power"].function             = ::PowerfulJuggernaut;
    level.roll_items["jugg_power"].description          = "You're a powerful Juggernaut (500 HP).";
    level.roll_items["jugg_power"].color                = (.5, .5, 0);

    level.roll_items["jugg_terminator"]                 = SpawnStruct();
    level.roll_items["jugg_terminator"].rollname        = "^1Terminator Juggernaut";
    level.roll_items["jugg_terminator"].weight          = 9;
    level.roll_items["jugg_terminator"].function        = ::TerminatorJuggernaut;
    level.roll_items["jugg_terminator"].description     = "You're a Terminator Juggernaut (1,000 HP).";
    level.roll_items["jugg_terminator"].color           = (.5, 0, 0);

    level.roll_items["exp_jugg"]                        = SpawnStruct();
    level.roll_items["exp_jugg"].rollname               = "^1Explosive Juggernaut";
    level.roll_items["exp_jugg"].weight                 = 9;
    level.roll_items["exp_jugg"].function               = ::juggernaut_suicide;
    level.roll_items["exp_jugg"].description            = "You're a powerful & explosive, Juggernaut (500 HP).";
    level.roll_items["exp_jugg"].color                  = (.5, 0, 0);

    level.roll_items["god"]                             = SpawnStruct();
    level.roll_items["god"].rollname                    = "^3Godmode for 5 seconds";
    level.roll_items["god"].weight                      = 12;
    level.roll_items["god"].function                    = ::GodMode;
    level.roll_items["god"].description                 = "Temporarily grants invincibility for 5 seconds";
    level.roll_items["god"].color                       = (.5, .5, 0);

    level.roll_items["riotshield"]                      = SpawnStruct();
    level.roll_items["riotshield"].rollname             = "^2Riotshield";
    level.roll_items["riotshield"].weight               = 25;
    level.roll_items["riotshield"].function             = ::Riotshield;
    level.roll_items["riotshield"].description          = "You have a Riotshield.";
    level.roll_items["riotshield"].color                = (0, .5, 0);
	
    level.roll_items["black_hole"]                      = SpawnStruct();
    level.roll_items["black_hole"].rollname             = "^6Black Hole Grenade!";
    level.roll_items["black_hole"].weight               = 15;
    level.roll_items["black_hole"].function             = ::blackholegrenade;
    level.roll_items["black_hole"].description          = "Throw a Grenade that creates a black hole, ^7Press ^:[{+actionslot 4}] ^7To Use It";
    level.roll_items["black_hole"].color                = (.6, 0, .6);

    level.roll_items["c4"]                              = SpawnStruct();
    level.roll_items["c4"].rollname                     = "^2C4";
    level.roll_items["c4"].weight                       = 25;
    level.roll_items["c4"].function                     = ::C4;
    level.roll_items["c4"].description                  = "You have a C4, Press ^:[{+actionslot 4}] ^7To Use It!";
    level.roll_items["c4"].color                        = (0, .5, 0);

    level.roll_items["flash"]                           = SpawnStruct();
    level.roll_items["flash"].rollname                  = "^2Flash Bang";
    level.roll_items["flash"].weight                    = 25;
    level.roll_items["flash"].function                  = ::FlashBang;
    level.roll_items["flash"].description               = "You have 2 Flash Grenades, Press ^:[{+actionslot 4}] ^7To Use It!";
    level.roll_items["flash"].color                     = (0, .5, 0);

    level.roll_items["concussion"]                      = SpawnStruct();
    level.roll_items["concussion"].rollname             = "^2Concussion Grenade";
    level.roll_items["concussion"].weight               = 25;
    level.roll_items["concussion"].function             = ::ConcussionGrenade;
    level.roll_items["concussion"].description          = "You have 2 Concussion Grenades, Press ^:[{+actionslot 4}] ^7To Use It!";
    level.roll_items["concussion"].color                = (0, .5, 0);

    level.roll_items["emp"]                             = SpawnStruct();
    level.roll_items["emp"].rollname                    = "^2EMP Grenade";
    level.roll_items["emp"].weight                      = 25;
    level.roll_items["emp"].function                    = ::EmpGrenade;
    level.roll_items["emp"].description                 = "You have a EMP Grenade, Press ^:[{+actionslot 4}] ^7To Use It!";
    level.roll_items["emp"].color                       = (0, .5, 0);

    level.roll_items["smoke"]                           = SpawnStruct();
    level.roll_items["smoke"].rollname                  = "^2Smoke Grenade";
    level.roll_items["smoke"].weight                    = 25;
    level.roll_items["smoke"].function                  = ::smokegrenade;
    level.roll_items["smoke"].description               = "You have a Smoke Grenade, Press ^:[{+actionslot 4}] ^7To Use It!";
    level.roll_items["smoke"].color                     = (0, .5, 0);

    level.roll_items["akimbo"]                          = SpawnStruct();
    level.roll_items["akimbo"].rollname                 = "^2Akimbo";
    level.roll_items["akimbo"].weight                   = 12;
    level.roll_items["akimbo"].function                 = ::Akimbo;
    level.roll_items["akimbo"].description              = "You have Akimbo Pistols";
    level.roll_items["akimbo"].color                    = (0, .5, 0);

    level.roll_items["magnum"]                          = SpawnStruct();
    level.roll_items["magnum"].rollname                 = "^2.44 Magnum";
    level.roll_items["magnum"].weight                   = 16;
    level.roll_items["magnum"].function                 = ::magnum44;
    level.roll_items["magnum"].description              = "You have a .44 Magnum with 6 bullets";
    level.roll_items["magnum"].color                    = (0, .5, 0);

    level.roll_items["one_bullet"]                      = SpawnStruct();
    level.roll_items["one_bullet"].rollname             = "^2One Bullet";
    level.roll_items["one_bullet"].weight               = 12;
    level.roll_items["one_bullet"].function             = ::OneBullet;
    level.roll_items["one_bullet"].description          = "You have a Sniper with one bullet";
    level.roll_items["one_bullet"].color                = (0, .5, 0);

    level.roll_items["unlimited_tk"]                    = SpawnStruct();
    level.roll_items["unlimited_tk"].rollname           = "^2Limited Knifes";
    level.roll_items["unlimited_tk"].weight             = 12;
    level.roll_items["unlimited_tk"].function           = ::UnlimitedKnifes;
    level.roll_items["unlimited_tk"].description        = "Gain limited Throwingknifes.";
    level.roll_items["unlimited_tk"].color              = (0, .5, 0);

    level.roll_items["exp_tk"]                          = SpawnStruct();
    level.roll_items["exp_tk"].rollname                 = "^2Exploding Throwingknife";
    level.roll_items["exp_tk"].weight                   = 20;
    level.roll_items["exp_tk"].function                 = ::ExplosiveKnife;
    level.roll_items["exp_tk"].description              = "You have an explosive throwing knife.";
    level.roll_items["exp_tk"].color                    = (0, .5, 0);

    level.roll_items["freeze"]                          = SpawnStruct();
    level.roll_items["freeze"].rollname                 = "^5Freeze Grenade";
    level.roll_items["freeze"].weight                   = 20;
    level.roll_items["freeze"].function                 = ::givefreezegrenade;
    level.roll_items["freeze"].description              = "Freeze Enemies or Turrets for 2 seconds, Press ^:[{+actionslot 4}] ^7to Use It!";
    level.roll_items["freeze"].color                    = (0, .8, .8);

    level.roll_items["wallhack"]                        = SpawnStruct();
    level.roll_items["wallhack"].rollname               = "^2Wallhack for 30 seconds";
    level.roll_items["wallhack"].weight                 = 20;
    level.roll_items["wallhack"].function               = ::Wallhack;
    level.roll_items["wallhack"].description            = "Gain temporary wallhacks.";
    level.roll_items["wallhack"].color                  = (0, .5, 0);

    level.roll_items["coldblooded"]                     = SpawnStruct();
    level.roll_items["coldblooded"].rollname            = "^2Cold Blooded";
    level.roll_items["coldblooded"].weight              = 20;
    level.roll_items["coldblooded"].function            = ::givecoldblooded;
    level.roll_items["coldblooded"].description         = "Run past enemy sentry turrets and hide from thermal";
    level.roll_items["coldblooded"].color               = (0, .5, 0);

    level.roll_items["jump"]                            = SpawnStruct();
    level.roll_items["jump"].rollname                   = "^5Jump Boost";
    level.roll_items["jump"].weight                     = 18;
    level.roll_items["jump"].function                   = ::jump_boost;
    level.roll_items["jump"].description                = "You have higher jump Height!";
    level.roll_items["jump"].color                      = (.5, .6, .3);

    //level.roll_items["clone"]                           = SpawnStruct();
    //level.roll_items["clone"].rollname                  = "^5Spawn Clone";
    //level.roll_items["clone"].weight                    = 20;
    //level.roll_items["clone"].function                  = ::spawn_clone;
    //level.roll_items["clone"].description               = "Distract your Enemies with your Clone, Press ^:[{+actionslot 4}] ^7To Spawn It!";
    //level.roll_items["clone"].color                     = (.2, .8, .6);

    // Decoy clone done
    // Shockwave Grenade
    // Super Jump done
    // Gas Grenade

    level.roll_items_keys = GetArrayKeys(level.roll_items);

    roll_items_max_weight = 0;

    foreach(roll in level.roll_items) {
        roll_items_max_weight += roll.weight;
    }

    percent = roll_items_max_weight / 100; // 1 percent of max roll
    level.roll_percent_numbers = [];
    temp = 0;
    foreach(item in level.roll_items_keys) {
        roll_percent = level.roll_items[item].weight / percent;
        temp += roll_percent;
        level.roll_percent_numbers[str(min(temp,100))] = item;

        if(devprint) {
            print("^1" + item + " ^7= " + roll_percent +"%");
            print("^2Total ^7= ^3" + min(temp,100) +"%");
        }
    }
    level.roll_percent_keys = GetArrayKeys(level.roll_percent_numbers);

    level.roll_25 = int((level.roll_percent_keys.size-1) * .25);
    level.roll_50 = int((level.roll_percent_keys.size-1) * .5);
    level.roll_75 = int((level.roll_percent_keys.size-1) * .75);
}

get_random_roll() {
    self endon("disconnect");
    self endon("death");

    num = randomint(10000)/100;

    if(num > Float(level.roll_percent_keys[level.roll_25])) {
        d = level.roll_25;
        if(num > Float(level.roll_percent_keys[level.roll_50])) {
            d = level.roll_50;
            if(num > Float(level.roll_percent_keys[level.roll_75])) {
                d = level.roll_75;
            }
        }
    } else {
        d = 0;
    }

    //j=0;
    for(i=d;i<level.roll_percent_keys.size;i++) {
        if(num > Float(level.roll_percent_keys[i])) {
            //j++;
            //print("^2"+num + " ^7is greater then ^2" + level.roll_percent_keys[i] + "/" +level.roll_percent_numbers[level.roll_percent_keys[i]]);
        } else {
            //print("^1"+num + " ^7is lower then ^2" + level.roll_percent_keys[i] + "/" +level.roll_percent_numbers[level.roll_percent_keys[i]]);
            //print("^3Amount of Rolls Before Pick - ^1" + j);
            // print("^2"+ num + " ^7- ^2" +level.roll_percent_numbers[level.roll_percent_keys[i]]);
            //level.rolls_average[level.rolls_average.size] = j;
            return level.roll_percent_numbers[level.roll_percent_keys[i]];
        }
    }
}

roll_random_effect() {
    self endon("disconnect");
    self endon("death");
    wait .05;

    roll = get_random_roll();

    self thread [[level.roll_items[roll].function]]();

    foreach(player in level.players) {
        if(player.team == self.team)
            player iPrintLn("^8" + self.name + "^7 Rolled " + level.roll_items[roll].rollname);
        else
            player iPrintLn("^9" + self.name + "^7 Rolled " + level.roll_items[roll].rollname);
    }

    self thread send_hud_notification_handler(level.roll_items[roll].rollname, level.roll_items[roll].description, level.roll_items[roll].color);
}

jump_boost() {
    self endon("disconnect");
    self endon("death");
    self notifyonplayercommand("jumped", "+gostand");
    for(;;) {
        self waittill("jumped");
        vel = self GetVelocity();
        self SetVelocity((vel[0], vel[1], 310));
        while(!self isonground())
            wait 0.2;
    }
}

spawn_clone() {
    self endon("disconnect");
    self endon("death");
    self notifyonplayercommand("clone", "+actionslot 4");
    self waittill("clone");
    clone = self ClonePlayer(2);
    clone thread delete_clone(self);
    self hide();
    self thread show_on_death();
    wait 2;
    self notify("finished_clone");
    self show();
}

show_on_death() {
    level endon("game_ended");
    self endon("finished_clone");
    self waittill("death");
    self show();
}

delete_clone(owner) {
    owner waittill_any_timeout(10, "death","disconnect");
    self delete();
}

givefreezegrenade() {
    self endon("disconnect");
    self endon("death");

    self GiveWeapon("semtex_mp");
    self _SetActionSlot(4, "weapon", "semtex_mp");

	while(1) {
		self waittill("grenade_fire", ent, name);

		if(name == "semtex_mp") {
            ent thread delete_ifdied(self);

			wait 1.45;

            if(isdefined(ent)) {
                ent notify("exploded");

                playfx(level.empGrenadeExplode, ent.origin);
                turrets = getEntArray( "misc_turret", "classname" );

                foreach(player in level.players) {
                    if(distance(player.origin, ent.origin) < 250 && player.team == "allies")
                        player thread frozen(2);
                }
                foreach ( turret in turrets )
                {
                    if(distance(turret.origin, ent.origin) < 250)
                        turret thread turret_frozen(4);
                }

                if(isdefined(ent))
                    ent delete();
            }

			break;
		}
	}
}

turret_frozen(freeze_time) {
    self endon("death");
    moved=undefined;
    PlayFXOnTag( getfx( "sentry_explode_mp" ), self, "tag_aim" );

    //self makeUnUsable();
    self SetDefaultDropPitch( 40 );
    if(isdefined(self.turrettype) && self.turrettype == "mg_turret"){
        //self SetMode( level.turretSettings[ self.turretType ].sentryModeOff );
        if(isdefined(self.ownertrigger)) {
            self.ownertrigger.origin = self.ownertrigger.origin + (0,0,10000);
            moved = true;
        }
        self thread remote_bug_fix_turret(freeze_time);
        self.owner.throwingGrenade = "yeet";
    } else if(isdefined(self.sentryType) && self.sentryType == "sentry_minigun")
        self SetMode( level.sentrySettings[ self.sentryType ].sentryModeOff );
    else {
        self.overheated = true;
        self SetMode("sentry_offline");
    }

    wait( freeze_time );


    if(isdefined(self.turrettype) && self.turrettype == "mg_turret") {
        //self SetMode( level.turretSettings[ self.turretType ].sentryModeOn );
        if(isdefined(moved))
            self.ownertrigger.origin = self.ownertrigger.origin - (0,0,10000);
        self.owner.throwingGrenade = undefined;
    }else if(isdefined(self.sentryType) && self.sentryType == "sentry_minigun")
        self SetMode( level.sentrySettings[ self.sentryType ].sentryModeOn );
    else {
        self.overheated = false;
        self SetMode("manual");
    }

    self SetDefaultDropPitch( 0 );
    //self makeusable();

    //still bugged with remotes - hopefully fixed now
}
remote_bug_fix_turret(time) {
    time_total = time*20;
    for(i=0;i<time_total;i++){
        if ( self.owner getcurrentweapon() == "killstreak_remote_turret_remote_mp" )
        {
            self.owner.using_remote_turret = false;
            self.owner maps\mp\killstreaks\_remoteturret::takeKillstreakWeapons( self.turretType );
            self maps\mp\killstreaks\_remoteturret::stopUsingRemoteTurret();
            wait 0.5;
            self.owner ThermalVisionOff();
            self.owner ThermalVisionFOFOverlayOff();
            self.owner VisionSetThermalForPlayer( game["thermal_vision"], 0 );
            break;
        }

        wait 0.05;
    }
}

frozen(time) {
    self endon("disconnect");

    self freezecontrols(1);
    self iPrintLnBold("^5Frozen^7 for ^52^7 Seconds!");

    self.frozenoverlay = newClientHudElem(self);
	self.frozenoverlay.x = 0;
	self.frozenoverlay.y = 0;
	self.frozenoverlay.alignX = "left";
	self.frozenoverlay.alignY = "top";
	self.frozenoverlay.horzAlign = "fullscreen";
	self.frozenoverlay.vertAlign = "fullscreen";
	self.frozenoverlay setshader("combathigh_overlay", 640, 480);
	self.frozenoverlay.sort = -10;
	self.frozenoverlay.archived = 1;
    self.frozenoverlay.color = (0, 1, 1);

    wait time;

    self freezecontrols(0);
    self.frozenoverlay destroy();
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
        self.notificationtitle.y = 320;
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
        self.notificationtext.y = 335;
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
        self.notification_bg.y = 312;
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

    self playlocalsound("copycat_steal_class");
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
    self setweaponammoclip("iw5_smaw_mp", 1);
    self setweaponammostock("iw5_smaw_mp", 0);
    self SwitchToWeaponImmediate("iw5_smaw_mp");
}

M_320() {
    self GiveWeapon("m320_mp");
    self setweaponammoclip("m320_mp", 1);
    self setweaponammostock("m320_mp", 0);
    self SwitchToWeaponImmediate("m320_mp");
}

M_320_smoke() {
    level endon("game_ended");
    self endon("death");

    self GiveWeapon("m320_mp");
    self setweaponammoclip("m320_mp", 1);
    self setweaponammostock("m320_mp", 0);
    self SwitchToWeaponImmediate("m320_mp");

    for(;;) {
        self waittill( "missile_fire", missile, weaponName );
        if ( weaponName == "m320_mp")
        {
            missile thread smoke_launcher_thread();
        }
    }
}

smoke_launcher_thread() {
    self.smoke = true;
    org = (0,0,0);
    while(isdefined(self)) {
        org = self.origin;
        wait 0.05;
    }
    PlayFX(level.smokelauncher_fx, org);
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

onebulletwatcher() {
    self endon("disconnect");
    self endon("death");

    fired = 0;
    while(!fired) {
        self waittill( "weapon_fired", weapName);

        if ( weapName == "iw5_dragunov_mp_dragunovscope" ) {
            wait 1;
            self takeweapon("iw5_dragunov_mp_dragunovscope");
            self switchtoweapon("iw5_usp45_mp_tactical");
            fired = 1;
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
    level endon("game_ended");

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
    self SetPerk("specialty_fastermelee", 1, 1);
    self SetPerk("specialty_lightweight", 1, 1);
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
    self setweaponammostock("at4_mp", 0);
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
        if(isalive(self)) {
            if(i != 0) {
                self iprintlnbold("Godmode For ^:" + i + " ^7Seconds");
                wait 1;
            }
        }
        else
            break;
    }

    self iprintlnbold("Godmode turned ^:Off");
    self.godmode = undefined;
    self notify("stopGodMode");
}

UnlimitedKnifes() {
    self endon("stopKnifes");
    self endon("death");
    self endon("disconnect");
    self endon("game_ended");

    amount = 30;
    powerup_hud = newClientHudElem( self );
	powerup_hud.horzAlign = "fullscreen";
	powerup_hud.vertAlign = "fullscreen";
    powerup_hud.x = 585;
    powerup_hud.y = 460;
    powerup_hud.fontscale = 0.60;
    powerup_hud.font = "hudbig";
    powerup_hud.label = &" - ^1";
    powerup_hud.HideWhenInMenu = 1;
    powerup_hud.HideWhenInkillcam = 1;
    powerup_hud.HideWhendead = 1;
    powerup_hud.alpha = 1;
    powerup_hud.color = (1,1,1);
	powerup_hud.archived = true;
    powerup_hud thread delete_on_death(self);
    powerup_hud setvalue(amount);

    self GiveWeapon("throwingknife_mp");
    self SetOffhandPrimaryClass( "throwingknife" );


    for(;;) {
        self waittill("grenade_fire", grenade, weapName);

        if (weapName == "throwingknife_mp") {
            amount--;
            if(amount > 0) {
                powerup_hud setvalue(amount);
                wait 0.65;
                self SetWeaponAmmoClip("throwingknife_mp", 1);
            }
            else {
                self notify("calling_all_homos");
                return;
            }
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

    self.haswallhack = 1;
    self ThermalVisionFOFOverlayOn();
    wait 30;
    self ThermalVisionFOFOverlayOff();
    self.haswallhack = undefined;
    self notify("stopWh");
}

givecoldblooded() {
    self endon("death");
    while(isdefined(self.avoidKillstreakOnSpawnTimer) && self.avoidKillstreakOnSpawnTimer > 0)
        wait .05;

    wait .05;
    self givePerk( "specialty_blindeye", 0 );
    self givePerk( "specialty_fasterlockon", 0 );
	self givePerk("specialty_coldblooded", 1);
	self givePerk("specialty_spygame", 1);
}

Speed(scale) {
    self endon("stopSpeed");
    self endon("death");
    self endon("disconnect");
    self endon("game_ended");

    for(;;) {
        if(isDefined(self) && isPlayer(self) && isAlive(self))
            self.moveSpeedScaler = scale;	self maps\mp\gametypes\_weapons::updateMoveSpeedScale();

        wait .5;
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
    self.equipmenthudicon.HideWhenInMenu = 1;
    self.equipmenthudicon.HideWhenInkillcam = 1;
    self.equipmenthudicon.HideWhendead = 1;
    self.equipmenthudicon.foreground = 0;
    self.equipmenthudicon.alpha = 1;
    //self.equipmenthud.color = (1,0,0);
	self.equipmenthudicon.archived = 0;

    self.equipmenthudnum = self createFontString( "default", 1.3);
	self.equipmenthudnum setPoint( "CENTER", "BOTTOMRIGHT", -62, -8 );
    self.equipmenthudnum.HideWhenInMenu = 1;
    self.equipmenthudnum.HideWhenInkillcam = 1;
    self.equipmenthudnum.HideWhendead = 1;
    self.equipmenthudnum.foreground = 1;
    self.equipmenthudnum setvalue(self getammocount(gunname));
    self.equipmenthudnum.alpha = 1;
    //self.equipmenthudnum.color = (1,0,0);
	self.equipmenthudnum.archived = 0;




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


    while(1)
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

destroyequipmenthudondeath() {
    self waittill("death");

    if(isdefined(self.equipmenthudicon))
        self.equipmenthudicon destroy();
    if(isdefined(self.equipmenthudnum))
        self.equipmenthudnum destroy();
}










givePerk_replace( perkName, useSlot )
{
	AssertEx( IsDefined( perkName ), "givePerk perkName not defined and should be" );
	AssertEx( IsDefined( useSlot ), "givePerk useSlot not defined and should be" );
	AssertEx( !IsSubStr( perkName, "specialty_null" ), "givePerk perkName shouldn't be specialty_null, use _clearPerks()s" );

    
	if ( IsSubStr( perkName, "_mp" ) )
	{
		switch( perkName )
		{
		case "frag_grenade_mp":
			self SetOffhandPrimaryClass( "frag" );
			break;
		case "throwingknife_mp":
			self SetOffhandPrimaryClass( "throwingknife" );
			break;
		case "trophy_mp":
			self SetOffhandSecondaryClass( "flash" );
			break;
		}

		self _giveWeapon( perkName, 0 );
		self giveStartAmmo( perkName );

		self _setPerk( perkName, useSlot );
        //print("^2"+self.name+"^1 - ^3" + perkName + " _ " + useSlot + " ^2> substr _mp");
		return;
	}

	if( IsSubStr( perkName, "specialty_weapon_" ) )
	{
		self _setPerk( perkName, useSlot );
        //print("^2"+self.name+"^1 - ^3" + perkName + " _ " + useSlot + " ^2> substr specialty_weapon_");
		return;
	}

	self _setPerk( perkName, useSlot );

	self _setExtraPerks( perkName );
        //print("^2"+self.name+"^1 - ^3" + perkName + " _ " + useSlot);
    
}

isKillstreakWeapon_replace( weapon )
{
    //print("^1ERROR WEAPON: ^3" + weapon);
    
	if( !IsDefined( weapon ) )
	{
		AssertMsg( "isKillstreakWeapon called without a weapon name passed in" );
		return false;
	}

	if ( weapon == "none" )
		return false;
	
	tokens = strTok( weapon, "_" );
	foundSuffix = false;
	
	//this is necessary because of weapons potentially named "_mp(somthign)" like the mp5
	if( weapon != "destructible_car" && weapon != "barrel_mp" )
	{
		foreach(token in tokens)
		{
			if( token == "mp" )
			{
				foundSuffix = true;
				break;
			}
		}
		
		if ( !foundSuffix )
		{
			weapon += "_mp";
		}
	}
	
	/*UGLY HACK REMOVE THIS BEFORE SHIPPING AND PROPERLY CACHE AKIMBO WEAPONS
	if ( isSubstr( weapon, "akimbo" ) )
		return false;
	*/
	
	if ( isSubStr( weapon, "destructible" ) )
		return false;

	if ( isSubStr( weapon, "killstreak" ) )
		return true;
	
	if ( maps\mp\killstreaks\_airdrop::isAirdropMarker( weapon ) )
		return true;

	if ( isDefined( level.killstreakWeildWeapons[weapon] ) )
		return true;

    if ( weapon == "c4_mp" || weapon == "flash_mp" || weapon == "smoke_mp" || weapon == "concussion_mp" || weapon == "emp_mp")
		return false;

	if ( IsDefined( weaponInventoryType( weapon ) ) && weaponInventoryType( weapon ) == "exclusive" && ( weapon != "destructible_car" && weapon != "barrel_mp" ) )
		return true;
			
	return false;
}