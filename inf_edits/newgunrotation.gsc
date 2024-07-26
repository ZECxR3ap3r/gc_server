#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;

giveallPerksNew() {
	perks = [];
	perks[ perks.size ] = "specialty_longersprint";
	perks[ perks.size ] = "specialty_fastreload";
	perks[ perks.size ] = "specialty_scavenger";
	perks[ perks.size ] = "specialty_paint";
	perks[ perks.size ] = "specialty_hardline";
	perks[ perks.size ] = "specialty_quickdraw";
	perks[ perks.size ] = "_specialty_blastshield";
	perks[ perks.size ] = "specialty_detectexplosive";
	perks[ perks.size ] = "specialty_autospot";
	perks[ perks.size ] = "specialty_bulletaccuracy";
	perks[ perks.size ] = "specialty_quieter";
	perks[ perks.size ] = "specialty_stalker";
	perks[ perks.size ] = "specialty_bulletpenetration";
	perks[ perks.size ] = "specialty_marksman";
	perks[ perks.size ] = "specialty_sharp_focus";
	perks[ perks.size ] = "specialty_holdbreathwhileads";
	perks[ perks.size ] = "specialty_longerrange";
	perks[ perks.size ] = "specialty_fastermelee";
	perks[ perks.size ] = "specialty_reducedsway";
	perks[ perks.size ] = "specialty_lightweight";

	foreach( perkName in perks ) {
		if( !self _hasPerk( perkName ) ) {
			self givePerk( perkName, false );
			if( maps\mp\gametypes\_class::isPerkUpgraded( perkName ) ) {
				perkUpgrade = tablelookup( "mp/perktable.csv", 1, perkName, 8 );
				self givePerk( perkUpgrade, false );
			}
		}
	}
}

init() {
	replacefunc(maps\mp\gametypes\_weapons::updateMoveSpeedScale, ::updateMoveSpeedScaleReplace);
	replacefunc(maps\mp\killstreaks\_killstreaks::giveAllPerks, ::giveallPerksNew);

    level.ARS = [];
    level.ARS[0] = "iw5_acr_mp";
    level.ARS[1] = "iw5_ak47_mp";
    level.ARS[2] = "iw5_scar_mp";
	level.ARS[3] = "iw5_m4_mp";
	level.ARS[4] = "iw5_m16_mp";
	level.ARS[5] = "iw5_cm901_mp";
	level.ARS[6] = "iw5_mk14_mp";
	level.ARS[7] = "iw5_g36c_mp";
	level.ARS[8] = "iw5_type95_mp";
	level.ARS[9] = "iw5_fad_mp";

	level.ARattach = [];
	level.ARattach[0] = "_xmags";
	level.ARattach[1] = "_silencer";
	level.ARattach[2] = "_reflex";
	level.ARattach[3] = "_heartbeat";
	level.ARattach[4] = "_eotech";
	level.ARattach[5] = "_acog";
	level.ARattach[6] = "";
	level.ARattach[7] = "_reflex_silencer";
	level.ARattach[8] = "_silencer_xmags";
	level.ARattach[9] = "_heartbeat_silencer";
	level.ARattach[10] = "_rof";

	level.SMG = [];
	level.SMG[0] = "iw5_mp5_mp";
	level.SMG[1] = "iw5_ump45_mp";
	level.SMG[2] = "iw5_pp90m1_mp";
	level.SMG[3] = "iw5_p90_mp";
	level.SMG[4] = "iw5_m9_mp";
	level.SMG[5] = "iw5_mp7_mp";
	level.SMG[6] = "iw5_ak74u_mp";

	level.SMGAttach = [];
	level.SMGAttach[0] = "";
	level.SMGAttach[1] = "_silencer";
	level.SMGAttach[2] = "_reflexsmg";
	level.SMGAttach[3] = "_rof";
	level.SMGAttach[4] = "_acogsmg";
	level.SMGAttach[5] = "_xmags";
	level.SMGAttach[6] = "_eotechsmg";
	level.SMGAttach[7] = "_acogsmg_silencer";
	level.SMGAttach[8] = "_acogsmg_rof";
	level.SMGAttach[9] = "_eotechsmg_rof";
	level.SMGAttach[10] = "_eotechsmg_xmags";
	level.SMGAttach[11] = "_eotechsmg_silencer";
	level.SMGAttach[12] = "_rof_xmags";
	level.SMGAttach[13] = "_silencer_xmags";
	level.SMGAttach[14] = "_rof_silencer";

	level.LMG = [];
	level.LMG[0] = "iw5_sa80_mp";
	level.LMG[1] = "iw5_mg36_mp";
	level.LMG[2] = "iw5_pecheneg_mp";
	level.LMG[3] = "iw5_mk46_mp";
	level.LMG[4] = "iw5_m60_mp";
	level.LMG[5] = "iw5_m60jugg_mp";

	level.LMGAttach = [];
	level.LMGAttach[0] = "";
	level.LMGAttach[1] = "_reflexlmg";
	level.LMGAttach[2] = "_eotechlmg";
	level.LMGAttach[3] = "_acog";
	level.LMGAttach[4] = "_silencer";
	level.LMGAttach[5] = "_grip";
	level.LMGAttach[6] = "_rof";
	level.LMGAttach[7] = "_heartbeat";

	level.Sniper = [];
    level.Sniper[0] = "iw5_cheytac_mp";
    level.Sniper[1] = "iw5_msr_mp";
    level.Sniper[2] = "iw5_rsass_mp";
	level.Sniper[3] = "iw5_l96a1_mp";
	level.Sniper[4] = "iw5_as50_mp";
	level.Sniper[5] = "iw5_dragunov_mp";
	level.Sniper[6] = "iw5_barrett_mp";

	level.SniperAttach = [];
    level.SniperAttach[0] = "";
    level.SniperAttach[1] = "_acog";
    level.SniperAttach[2] = "_thermal";
	level.SniperAttach[3] = "_xmags";
	level.SniperAttach[4] = "_silencer03";
	level.SniperAttach[5] = "_heartbeat";

	level.Shot = [];
	level.Shot[0] = "iw5_usas12_mp";
	level.Shot[1] = "iw5_ksg_mp";
	level.Shot[2] = "iw5_spas12_mp";
	level.Shot[3] = "iw5_aa12_mp";
	level.Shot[4] = "iw5_striker_mp";
	level.Shot[5] = "iw5_1887_mp";

	level.ShotAttach = [];
	level.ShotAttach[0] = "";
	level.ShotAttach[1] = "_xmags";
	level.ShotAttach[2] = "_eotech";
	level.ShotAttach[3] = "_reflex";
	level.ShotAttach[4] = "_silencer03";
	level.ShotAttach[5] = "_grip";
	level.ShotAttach[6] = "_grip_reflex";
	level.ShotAttach[7] = "_grip_silencer03";
	level.ShotAttach[8] = "_grip_xmags";
	level.ShotAttach[9] = "_silencer03_xmags";
	level.ShotAttach[10] = "_eotech_xmags";
	level.ShotAttach[11] = "_eotech_silencer03";
	level.ShotAttach[12] = "_eotech_grip";

	level.MachinePistol = [];
    level.MachinePistol[0] = "iw5_fmg9_mp";
    level.MachinePistol[1] = "iw5_mp9_mp";
    level.MachinePistol[2] = "iw5_skorpion_mp";
	level.MachinePistol[3] = "iw5_g18_mp";

	level.MachinePistolAttach = [];
    level.MachinePistolAttach[0] = "";
    level.MachinePistolAttach[1] = "_eotechsmg";
    level.MachinePistolAttach[2] = "_xmags";
	level.MachinePistolAttach[3] = "_reflexsmg";
	level.MachinePistolAttach[4] = "_akimbo";
	level.MachinePistolAttach[5] = "_akimbo";
	level.MachinePistolAttach[6] = "_silencer02";

	level.Camo = [];
	level.Camo[0] = "";
	level.Camo[1] = "_camo01";
	level.Camo[2] = "_camo02";
	level.Camo[3] = "_camo03";
	level.Camo[4] = "_camo04";
	level.Camo[5] = "_camo05";
	level.Camo[6] = "_camo06";
	level.Camo[7] = "_camo07";
	level.Camo[8] = "_camo08";
	level.Camo[9] = "_camo09";
	level.Camo[10] = "_camo10";
	level.Camo[11] = "_camo11";
	level.Camo[12] = "_camo12";
	level.Camo[13] = "_camo13";

    thread doRotation(45);

	level thread onplayerconnect();
	wait 30; // so it doesnt goes on right away when a game starts
	level thread UAVListener();
}

UAVListener() {
	while(1) {
		if(getNumSurvivors() == 1 && !isdefined(level.radarinuse)) {
			level.radarinuse = 1;
			maps\mp\killstreaks\_uav::setTeamRadarWrapper("axis", 1);
			UAVINFO = newhudelem();
        	UAVINFO.horzalign = "fullscreen";
        	UAVINFO.alignx = "center";
        	UAVINFO.vertalign = "fullscreen";
        	UAVINFO.aligny = "middle";
        	UAVINFO.x = 320;
        	UAVINFO.y = 50;
        	UAVINFO.fontscale = 1.6;
        	UAVINFO.sort = 2;
        	UAVINFO.glowColor = (1, 0, 0);
			UAVINFO.glowAlpha = 1;
        	UAVINFO.foreground = true;
        	UAVINFO settext("Last Player Revealed!");
        	UAVINFO setPulseFX(100, 5000, 1000);
			wait 2.5;
			playSoundOnPlayers( "mp_killstreak_radar" );
			UAVINFOSHADER = newhudelem();
        	UAVINFOSHADER.horzalign = "fullscreen";
        	UAVINFOSHADER.alignx = "center";
        	UAVINFOSHADER.vertalign = "fullscreen";
        	UAVINFOSHADER.aligny = "middle";
        	UAVINFOSHADER.x = 320;
        	UAVINFOSHADER.y = 75;
        	UAVINFOSHADER.color = (1,1,1);
        	UAVINFOSHADER.sort = 2;
        	UAVINFOSHADER setshader("dpad_killstreak_uav", 30, 30);
        	wait 3.5; 
        	UAVINFOSHADER destroy();
        	UAVINFO destroy();
		}
		if(getNumSurvivors() > 1 && isdefined(level.radarinuse)) {
			level.radarinuse = undefined;
			maps\mp\killstreaks\_uav::setTeamRadarWrapper("axis", 0);
		}
		wait 2;
	}
}

getNumSurvivors() {
	numSurvivors = 0;
	foreach ( player in level.players ){
		if ( player.team == "allies" )
			numSurvivors++;
		if(player _hasPerk("specialty_coldblooded_ks" ) )
			player _unsetPerk( "specialty_coldblooded_ks" );
	}
	return numSurvivors;	
}

onPlayerConnect() {
    for(;;) {
        level waittill("connected", player);
        player thread onPlayerSpawned();    
		player setclientDvar("lowAmmoWarningNoAmmoColor2", 0, 0, 0, 0);
	  	player setclientDvar("lowAmmoWarningNoAmmoColor1", 0, 0, 0, 0);
    }
}

onPlayerSpawned() {
    self endon("disconnect");
	level endon("game_ended");
    for(;;) {
        self waittill("spawned_player");
		if (self.team == "allies") {
			self TakeAllWeapons();
			self takeweapon(self getcurrentweapon());
			self _giveWeapon(level.gun);
			self setspawnweapon(level.gun);
		}
    }
}

doRotation(duration) {
   	level endon("game_ended");

  	hud_timer = NewHudElem();
  	hud_timer.x = 5;
  	hud_timer.y = 105;
	hud_timer.alignX = "left";
   	hud_timer.alignY = "top";
   	hud_timer.horzAlign = "fullscreen";
   	hud_timer.vertAlign = "fullscreen";
   	hud_timer.fontScale = 1.3;
   	hud_timer.font = "default";
   	hud_timer.alpha = 1;
    hud_timer.glowalpha = 1; 
    hud_timer.glowcolor = (1, 0, 0);   
    hud_timer.label = &"Rotation In: ^1";
    hud_timer.foreground = true;
    hud_timer.hidewheninmenu = true;
    hud_timer.hidewheninkillcam = true; 
    hud_timer thread GameEndGone();
   
    while(1) {
		input = randomint(100);

		if(input < 25) {
			num = level.ARS[randomInt(level.ARS.size)];
			attach = level.ARattach[randomInt(level.ARattach.size)];
			Camo = level.Camo[randomInt(level.Camo.size)];
			if(attach == "_rof" && (num == "iw5_type95_mp" || num == "iw5_mk14_mp" || num == "iw5_m16_mp"))
				level.gun = num + attach + Camo;
			else if(attach == "_rof")
				level.gun = num + Camo;
			else
				level.gun = num + attach + Camo;
			level.gunclass = "AR";
		}
		else if(input >= 25 && input < 35) {
			num = level.Sniper[randomInt(level.Sniper.size)];
			attach = level.SniperAttach[randomInt(level.SniperAttach.size)];
			Camo = level.Camo[randomInt(level.Camo.size)];
			if(attach == "_acog" || attach == "_thermal")		
				level.gun = num + attach + Camo;
			else {
				switch(num) {
					case "iw5_cheytac_mp" :
						level.scope = "_cheytacscope";
						break;		    
					case "iw5_msr_mp" :
						level.scope = "_msrscope";
						break;        
					case "iw5_rsass_mp" :
						level.scope = "_rsassscope";
						break;
					case "iw5_l96a1_mp" :
						level.scope = "_l96a1scope";
						break;		    
					case "iw5_as50_mp" :
						level.scope = "_as50scope";
						break;        
					case "iw5_dragunov_mp" :
						level.scope = "_dragunovscope";
						break;
					case "iw5_barrett_mp" :
						level.scope = "_barrettscope";
						break; 
				}
				if(attach == "_heartbeat" && (num == "iw5_rsass_mp" || num == "iw5_l96a1_mp" || num == "iw5_msr_mp"))
					level.gun = num + attach + level.scope + Camo;
				else
					level.gun = num + level.scope + attach + Camo;
			}
			level.gunclass = "Sniper";
		}
		else if(input >= 35 && input < 55) {
			num = level.Shot[randomInt(level.Shot.size)];
			attach = level.ShotAttach[randomInt(level.ShotAttach.size)];
			Camo = level.Camo[randomInt(level.Camo.size)];
			if(num == "iw5_1887_mp")
				level.gun = num + Camo;
			else
				level.gun = num + attach + Camo;
			level.gunclass = "Shot";
		}
		else if(input >= 55 && input < 85)  {
			num = level.SMG[randomInt(level.SMG.size)];
			attach = level.SMGAttach[randomInt(level.SMGAttach.size)];
			Camo = level.Camo[randomInt(level.Camo.size)];
			level.gun = num + attach + Camo;
			level.gunclass = "Sub";
		}
		else if(input >= 85 && input < 90) {
			num = level.LMG[randomInt(level.LMG.size)];
			attach = level.LMGAttach[randomInt(level.LMGAttach.size)];
			Camo = level.Camo[randomInt(level.Camo.size)];
			if(attach == "_heartbeat" && (num == "iw5_pecheneg_mp" || num == "iw5_m60_mp"))
				level.gun = num + Camo;
			else if(num == "iw5_m60jugg_mp")
				level.gun = num + "_thermal_xmags_camo01";
			else
				level.gun = num + attach + Camo;
			level.gunclass = "LMG";
		}
		else if(input >= 90) {
			num = level.MachinePistol[randomInt(level.MachinePistol.size)];
			attach = level.MachinePistolAttach[randomInt(level.MachinePistolAttach.size)];
			level.gun = num + attach;
			level.gunclass = "MP";
		}

        foreach (player in level.players) {
			if (player.team == "allies") {
				max = WeaponMaxAmmo(level.gun);
				ammo = player GetFractionMaxAmmo(player getcurrentweapon());
				stock = ceil((max * ammo));
				
				player takeweapon(player GetWeaponsListPrimaries()[0]);
				player _giveWeapon(level.gun);
  				player setWeaponAmmoStock(level.gun, int(stock));
				player setspawnweapon(level.gun);
				player.oldgun = level.gun;
            }
        }
        hud_timer SetTenthsTimer(duration);
		wait (duration);
    }
}

GameEndGone() {
	level waittill("game_ended");
	self destroy();
}

updateMoveSpeedScaleReplace() {	
	wep = self getcurrentweapon();
	class = weaponclass(wep);
	if(class == "mg")
		self.weaponSpeed = 0.8;
	else
		self.weaponSpeed = 1;
	self setMoveSpeedScale( self.weaponSpeed * self.moveSpeedScaler );
}

