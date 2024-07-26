#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

init()
{
	level.prevCallbackPlayerDamage = level.callbackPlayerDamage;
	level.callbackPlayerDamage = ::onPlayerDamage;
}

onPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime) {
	self endon("disconnect");
	level endon("1v1meonrust");

	if(sWeapon == "iw5_knife_mp")
		return;

	if(!isDefined(level.DamageBeingDone))
		level.DamageBeingDone = 0;
	
	if(isdefined(self.isghost) && self.isghost == 1) {
		iDamage = 0;
		origin = level.spawnpoints[randomint(level.spawnpoints.size)];
		self setOrigin(origin.origin);
		self setplayerangles(origin.angles);
	}
	else if(sMeansOfDeath == "MOD_TRIGGER_HURT" || sMeansOfDeath == "MOD_SUICIDE" || sMeansOfDeath == "MOD_FALLING") {
		if(self.team == "allies") {
			if(isdefined(level.slashers) && level.slashers == 0) {
				iDamage = 0;
				origin = level.spawnpoints[randomint(level.spawnpoints.size)];
				self setOrigin(origin.origin);
				self setplayerangles(origin.angles);
			}
			else if(!isdefined(self.protected) && isdefined(level.slashers) && level.slashers >= 1){
				if(!isdefined(self.protected)) {
					iDamage = 1000;
					level thread scripts\slasher\mod::showDiedMessage(self.name, "Died!");
					self maps\mp\gametypes\_damage::Callback_PlayerDamage_internal( eInflictor, eAttacker ,self , iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime );
					if(!isdefined(self.ghost))
						self thread scripts\slasher\main::GhostRUn();
				}
			}
		}
		else if(self.team == "axis") {
			if(sMeansOfDeath == "MOD_TRIGGER_HURT") {
				if(level.finalPlayer) {
					iDamage = 1000;
					self maps\mp\gametypes\_damage::Callback_PlayerDamage_internal( eInflictor, eAttacker ,self , iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime );
				}
				else {
					iDamage = 0;
					origin = level.spawnpoints[randomint(level.spawnpoints.size)];
					self setOrigin(origin.origin);
					self setplayerangles(origin.angles);
				}
			}
		}
	}
	else if(eAttacker.team == "axis") {
		if(sMeansOfDeath == "MOD_RIFLE_BULLET" || sMeansOfDeath == "MOD_IMPACT")
			iDamage = 0;
		else {
			iDamage = 1000;
			level thread scripts\slasher\mod::showDiedMessage(self.name, "Died by Slasher!");
			self maps\mp\gametypes\_damage::Callback_PlayerDamage_internal( eInflictor, eAttacker ,self , iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime );
			if(!isdefined(self.ghost))
				self thread scripts\slasher\main::GhostRUn();
			if(level.survivors == 2) {
				self.forcespectatorclient = -1;
				self.killcamentity = -1;
				self.archivetime = 0;
				self.psoffsettime = 0;
			}
		}
	}
	else if(eAttacker.team == "allies" && eAttacker.team != self.team && !level.finalPlayer) {
		if(level.ingame) {
			if(level.DamageBeingDone == 0) {
				level.DamageBeingDone = 1;
				eAttacker.score += level.SlasherPoints.SlasherStunned;
				eAttacker thread scripts\slasher\main::draw_xp(level.SlasherPoints.SlasherStunned, "Slasher Stunned");
				level thread slasherSlowdownEnd();
				level.slasherSlow = 0;
				iDamage = 0;
				level.slasherSlow = 5;	//Set slowdown time to 6 seconds for each shot.
				foreach(player in level.players) {
					if(player.team == "allies")
						player thread weapDisable();
					if(!isdefined(player.isghost))
						player thread doSlasherSlowedProgress();
				}
				while(level.slasherSlow > 0) {
					self setMoveSpeedScale(0.55);
					self allowjump(0);
					level.slasherSlow--;
					wait 1;
				}
				self setMoveSpeedScale(1.07);
				self allowjump(1);
				foreach(player in level.players) {
					if(player.team == "allies")
						player thread weapEnable();
				}
				level.DamageBeingDone = 0;
				level notify("finished_slowdown");
			}
		}
	}
	else if(eAttacker.team == "allies" && eAttacker.team != self.team && level.finalPlayer && sMeansOfDeath == "MOD_MELEE") {
		self maps\mp\gametypes\_damage::Callback_PlayerDamage_internal( eInflictor, eAttacker ,self , 1000, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime );
		self scripts\slasher\mod::forceTeam("spectator");
		notifySurvWin = spawnstruct();
		notifySurvWin.titleText = "^7" + eAttacker.name + " ^1Wins This Round!";
		notifySurvWin.notifyText = "^1The Slasher Was Killed!";
		getround = GetDvarInt("round");
		if(getround != 3) notifySurvWin.notifyText2 = "^1Next Round Starting Soon...";
		notifySurvWin.duration = 8;
		notifySurvWin.glowColor = (0.7, 0.0, 0.0);
		foreach(player in level.players){
			player freezeControls(true);
			player VisionSetNakedForPlayer("blacktest", 1.1);
			player playLocalSound("mm_endround");
			player thread maps\mp\gametypes\_hud_message::notifyMessage(notifySurvWin);
		}
		level.slasherWasKilled = true;
		level thread scripts\slasher\mod::roundsys();
		level.ingame = false;
	}
	else if(eAttacker.team == "axis" && eAttacker.team != self.team && level.finalPlayer) {
		self maps\mp\gametypes\_damage::Callback_PlayerDamage_internal( eInflictor, eAttacker ,self , 1000, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime );
		self scripts\slasher\mod::forceTeam("spectator");
		notifySlasherDeath = spawnstruct();
		notifySlasherDeath.titleText = "^7The Slasher Has Fallen!";
		notifySlasherDeath.notifyText = eAttacker.name + " Wins This Round!";
		notifySlasherDeath.notifyText2 = "^7Next Round Starting Soon...";
		notifySlasherDeath.duration = 8;
		notifySlasherDeath.glowColor = (1.0, 0.0, 0.0);
		foreach(player in level.players) {
			player freezeControls(true);
			player VisionSetNakedForPlayer("blacktest", 1.1);
			player playLocalSound("mp_obj_returned");
			level thread scripts\slasher\mod::showSlasherMessage(notifySlasherDeath);
		}
		level thread scripts\slasher\mod::roundsys();
		level.ingame = false;
	}
}

weapDisable() {
    self.savedAmmo = self GetWeaponAmmoClip("iw5_deserteagleiw3_mp");
    self takeWeapon("iw5_deserteagleiw3_mp");
    self giveWeapon("iw5_knife_mp");
    self switchtoweapon("iw5_knife_mp");
}

weapEnable() {
    self takeWeapon("iw5_knife_mp");
    self giveWeapon("iw5_deserteagleiw3_mp");
    if(isdefined(self.savedAmmo))
        self setWeaponAmmoClip("iw5_deserteagleiw3_mp", self.savedAmmo);
    self setWeaponAmmoStock("iw5_deserteagleiw3_mp", 0);
    self setspawnweapon("iw5_deserteagleiw3_mp");
}

slasherSlowdownEnd() {
	level endon("finished_slowdown");
	level waittill("1v1meonrust");
	level.DamageBeingDone = 0;
	foreach(player in level.players) {
		if(isDefined(player.prog)) 
			player.prog destroyelem();
		if(isDefined(player.progText)) 
			player.progText destroyelem();
		//player EnableWeapons();
		print(player.name + "s saved ammo clip:" + player.savedAmmo);
		player takeWeapon(player GetCurrentWeapon());
		player giveWeapon("iw5_deserteagleiw3_mp");
		player setWeaponAmmoClip("iw5_deserteagleiw3_mp", player.savedAmmo);
		player setWeaponAmmoStock("iw5_deserteagleiw3_mp", 0);
		player switchToWeapon("iw5_deserteagleiw3_mp");
		if(player.team == "axis") 
			player setMoveSpeedScale(1.05);
	}
}

doSlasherSlowedProgress() {
	self notify("endmylifeandsuffering");
	self endon("endmylifeandsuffering");
	level endon("1v1meonrust");
	stunTime = 4.99;
	self.prog = createPrimaryProgressBar(-250);
	self.progText = createPrimaryProgressBarText(-250);
	self.progText.x = 0;
	self.prog.bar.x = -59.5;
	self.prog.x = 0;
	self.progText.y = 165;
	self.prog.bar.y = 180;
	self.prog.y = 180;
	self.progText.color = level.ui_better_red;
	self.progText setText("Slasher Stunned: ^1" + level.slasherSlow);
	self.prog updateBar(0, 1/stunTime);
	self.prog.color = (0, 0, 0);
	self.prog.bar.color = level.ui_better_red;
	for(waitedTime = 0; waitedTime < stunTime && isAlive(self); waitedTime += 1) {
		self.progText setText("Slasher Stunned: ^1" + level.slasherSlow);
		wait 0.95;
	}
	self.prog destroyelem();
	self.progText destroyelem();
}


















