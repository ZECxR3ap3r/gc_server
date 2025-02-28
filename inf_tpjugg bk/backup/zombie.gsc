#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;

init() {
    initializerandomitems();
    level.throwingknifefx = loadFX( "smoke/smoke_geotrail_javelin" );
    level.throwingknifeexplosionfx = loadFX( "explosions/default_explosion" );

    level.nukeInfo.xpScalar = 2;

    level.crateTypes["airdrop_assault"]["airdrop_juggernaut"] = undefined;
    level.crateFuncs["airdrop_assault"]["airdrop_juggernaut"] = undefined;
    level.sentrySettings[ "sentry_minigun" ].timeOut =				45;
	level.sentrySettings[ "sentry_minigun" ].maxHealth =			400;

    level.finalguy = false;
    level.noclearkillstreaksonaxisspawn = true;

    level thread on_connect();
    
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

on_connect() {
    for (;;) {
        level waittill("connected", player);

        player.rtd_canroll = 1;

        player thread EquipmentLogging();
        player thread on_spawned();
    }
}

on_spawned() {
    self endon ("disconnect");
    
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

        if (self.SessionTeam == "axis") {
            self setviewkickscale(.5);
            self TakeAllWeapons();
            self SetOffhandPrimaryClass("throwingknife");
            self GiveWeapon("throwingknife_mp");

            self givePerk("specialty_tacticalinsertion", true);

            if(GetTeamScore("axis") > 1) {
                self GiveWeapon("iw5_usp45_mp_tactical");
                self SetWeaponAmmoClip("iw5_usp45_mp_tactical", 0);
                self SetWeaponAmmoStock("iw5_usp45_mp_tactical", 0);
                self setspawnweapon("iw5_usp45_mp_tactical");

                if( self.rtd_canroll == 1 )
                {
                    self ResetPlayer();
                    self thread DoRandom();
                }

                if(GetTeamPlayersAlive("allies") < 2)
                    self ThermalVisionFOFOverlayOn();
            } 
            else {
                self PowerfulJuggernaut();
                self GiveWeapon("riotshield_mp");
                self GiveWeapon("iw5_smaw_mp");
                self setspawnweapon("iw5_smaw_mp");
            }
        }
        else if (self.SessionTeam == "allies") {
            self setviewkickscale(1);
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

checkgoodspawn(grenade) {
    self endon("spawned_player");

    wait .05;

    while(isdefined(self.setSpawnPoint)) wait .05;
    
    self.goodspawn = undefined;
}

deletetacifinzone() {
    if(!isdefined(self.setSpawnPoint)) wait .05;
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
    			radiusdamage(self.origin, 300, 180, 20, self, "MOD_EXPLOSIVE", "c4_mp");
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
    
    if(isdefined(level.falldamagetriggers) && sMeansOfDeath == "MOD_FALLING") {
        foreach(trig in level.falldamagetriggers) {
            if(self istouching(trig)) {
                self iprintln("^5You Landed On A Soft Matress!");
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
			wait 1.45;
		
			fx = spawnfx(level.fx_airstrike_afterburner, ent.origin);
			triggerfx(fx);
			level thread create_black_hole(ent.origin, fx);
			ent playsound("harrier_fly_away");
		
			if(isdefined(ent))
				ent delete();
			break;
		}
	}
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
                	forceMagnitude = (500 - distanceToBlackHole) / 500 * 175;
                
                	force = direction_normalized * forceMagnitude;
                
                	player SetVelocity(force);
                }
                else
                	player allowjump(1);
            }
        }
        
        wait .05;
    }
    
    foreach(player in level.players)
    	player allowjump(1);
    
    fx delete();
}

initializerandomitems() {
    level.randomitems = [];
    
    i = level.randomitems.size;
    level.randomitems[i] = SpawnStruct();
    level.randomitems[i].function = ::juggernaut_suicide;
    level.randomitems[i].rollname = "^1Explosive Juggernaut";
    i = level.randomitems.size;
    level.randomitems[i] = SpawnStruct();
    level.randomitems[i].function = ::blackholegrenade;
    level.randomitems[i].rollname = "^6Black Hole Grenade! ^7- Press ^:[{+actionslot 4}] ^7To Use It!";
    i = level.randomitems.size;
    level.randomitems[i] = SpawnStruct();
    level.randomitems[i].function = maps\mp\gametypes\_globallogic::blank;
    level.randomitems[i].rollname = "^2Nothing!";
    i = level.randomitems.size;
    level.randomitems[i] = SpawnStruct();
    level.randomitems[i].function = ::ExtraSpeed;
    level.randomitems[i].rollname = "^2Extra Speed";
    i = level.randomitems.size;
    level.randomitems[i] = SpawnStruct();
    level.randomitems[i].function = ::SMAW;
    level.randomitems[i].rollname = "^2SMAW";
    i = level.randomitems.size;
    level.randomitems[i] = SpawnStruct();
    level.randomitems[i].function = ::Stinger;
    level.randomitems[i].rollname = "^1Stinger";
    i = level.randomitems.size;
    level.randomitems[i] = SpawnStruct();
    level.randomitems[i].function = ::lowhealthquick;
    level.randomitems[i].rollname = "^1Increased Speed, Reduced Health";
    i = level.randomitems.size;
    level.randomitems[i] = SpawnStruct();
    level.randomitems[i].function = ::Javelin;
    level.randomitems[i].rollname = "^2Javelin";
    i = level.randomitems.size;
    level.randomitems[i] = SpawnStruct();
    level.randomitems[i].function = ::Juggernaut;
    level.randomitems[i].rollname = "^2Juggernaut";
    i = level.randomitems.size;
    level.randomitems[i] = SpawnStruct();
    level.randomitems[i].function = ::OneBullet;
    level.randomitems[i].rollname = "^2One Bullet";
    i = level.randomitems.size;
    level.randomitems[i] = SpawnStruct();
    level.randomitems[i].function = ::PowerfulJuggernaut;
    level.randomitems[i].rollname = "^3Powerful Juggernaut";
    i = level.randomitems.size;
    level.randomitems[i] = SpawnStruct();
    level.randomitems[i].function = ::C4;
    level.randomitems[i].rollname = "^2C4 ^7- Press ^:[{+actionslot 4}] ^7To Use It!";
    i = level.randomitems.size;
    level.randomitems[i] = SpawnStruct();
    level.randomitems[i].function = ::FlashBang;
    level.randomitems[i].rollname = "^2Flash Bang ^7- Press ^:[{+actionslot 4}] ^7To Use It!";
    i = level.randomitems.size;
    level.randomitems[i] = SpawnStruct();
    level.randomitems[i].function = ::ConcussionGrenade;
    level.randomitems[i].rollname = "^2Concussion Grenade ^7- Press ^:[{+actionslot 4}] ^7To Use It!";
    i = level.randomitems.size;
    level.randomitems[i] = SpawnStruct();
    level.randomitems[i].function = ::EmpGrenade;
    level.randomitems[i].rollname = "^2EMP Grenade ^7- Press ^:[{+actionslot 4}] ^7To Use It!";
    i = level.randomitems.size;
    level.randomitems[i] = SpawnStruct();
    level.randomitems[i].function = ::smokegrenade;
    level.randomitems[i].rollname = "^2Smoke Grenade ^7- Press ^:[{+actionslot 4}] ^7To Use It!";
    i = level.randomitems.size;
    level.randomitems[i] = SpawnStruct();
    level.randomitems[i].function = ::Akimbo;
    level.randomitems[i].rollname = "^2Akimbo";
    i = level.randomitems.size;
    level.randomitems[i] = SpawnStruct();
    level.randomitems[i].function = ::magnum44;
    level.randomitems[i].rollname = "^2Magnum 44";
    i = level.randomitems.size;
    level.randomitems[i] = SpawnStruct();
    level.randomitems[i].function = ::GodMode;
    level.randomitems[i].rollname = "^3Godmode for 5 seconds";
    i = level.randomitems.size;
    level.randomitems[i] = SpawnStruct();
    level.randomitems[i].function = ::TerminatorJuggernaut;
    level.randomitems[i].rollname = "^1Terminator Juggernaut";
    i = level.randomitems.size;
    level.randomitems[i] = SpawnStruct();
    level.randomitems[i].function = ::RPG;
    level.randomitems[i].rollname = "^2RPG";
    i = level.randomitems.size;
    level.randomitems[i] = SpawnStruct();
    level.randomitems[i].function = ::UnlimitedKnifes;
    level.randomitems[i].rollname = "^2Unlimited Knifes";
    i = level.randomitems.size;
    level.randomitems[i] = SpawnStruct();
    level.randomitems[i].function = ::Riotshield;
    level.randomitems[i].rollname = "^2Riotshield";
    i = level.randomitems.size;
    level.randomitems[i] = SpawnStruct();
    level.randomitems[i].function = ::Wallhack;
    level.randomitems[i].rollname = "^2Wallhack for 30 seconds";
    i = level.randomitems.size;
    level.randomitems[i] = SpawnStruct();
    level.randomitems[i].function = ::ExplosiveKnife;
    level.randomitems[i].rollname = "^2Exploding Throwingknife";
    i = level.randomitems.size;
    level.randomitems[i] = SpawnStruct();
    level.randomitems[i].function = ::givecoldblooded;
    level.randomitems[i].rollname = "^2Cold Blooded ^7- Run Past The Turrets!";
    i = level.randomitems.size;
}

DoRandom()
{
    self endon("death");
    wait .05;
    roll = RandomInt(level.randomitems.size);
    rollname = "ERROR";

    self thread [[level.randomitems[roll].function]]();
    self PrintRollNames(level.randomitems[roll].rollname);
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
    self endon("death");
    self endon("stopGodMode");
    self endon("disconnect");
    self endon("game_ended");

    self.Health = -1;
    wait 1;
    for(i=5;i>=0;i--) {
        if(i != 0) {
            self iprintlnbold("Godmode For " + i + " Seconds");
            wait 1;
        }
        else
            self iprintlnbold("Godmode Turned Off");
    }
    self.Health = self.maxhealth;
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
    self.moveSpeedScaler = 1;	self maps\mp\gametypes\_weapons::updateMoveSpeedScale();
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









