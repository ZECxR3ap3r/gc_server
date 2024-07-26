#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;

init() {
    precacheStatusIcon( "hud_minimap_pavelow_green" );
    precacheStatusIcon( "cardicon_skull_black" );
	precacheshader("gradient_fadein");
	precacheshader("mw2_main_cloud_overlay");
	
	level waittill("player_spawn");
	level.teamBalance = 0;
	
	level.leaderDialogOnPlayer_func	= ::blank;
}

blank() {
	
}

DestroyReaperHud() {
    if(isdefined(self.health_bar))
    	self.health_bar destroy();
     if(isdefined(self.health_bar_frame))
    	self.health_bar_frame destroy();
     if(isdefined(self.health_text))
    	self.health_text destroy();
    if(isdefined(self.namehud))
    	self.namehud destroy();
    if(isdefined(self.namehudicon))
    	self.namehudicon destroy();
    if(isdefined(self.Time_Left))
    	self.Time_Left destroy();
    if(isdefined(self.WeaponRank))
    	self.WeaponRank destroy();
    if(isdefined(self.Blood)) {
    	self.Blood.color = level.ui_better_cyan;
 		self.Blood.alpha = 0.7;
 		self.Blood setshader("mw2_main_cloud_overlay", 999, 999);
    }
    if(isdefined(self.WeaponRankLine))
    	self.WeaponRankLine destroy();
     if(isdefined(self.WeaponAmmo))
    	self.WeaponAmmo destroy();
    if(isdefined(self.WeaponAmmoTextStock))
    	self.WeaponAmmoTextStock destroy();
    if(isdefined(self.weaponName))
    	self.weaponName destroy();
    if(isdefined(self.WeaponAmmoText))
    	self.WeaponAmmoText destroy();
    if(isdefined(self.GrenadeHud))
    	self.GrenadeHud destroy();
    if(isdefined(self.GrenadeName))
    	self.GrenadeName destroy();
    if(isdefined(self.round_number))
    	self.round_number destroy();
  	
    if(!isdefined(self.GhostText)) {
    	self.GhostText = self createFontString( "objective", 1.4);
		self.GhostText setPoint( "TOP", "TOP", 0, 1 );
		self.GhostText.alpha = 0.7;
    	self.GhostText setText("^5Afterlife Mode");
		self.GhostText.HideWhenInMenu = true;
    	self.GhostText.archived = false;
    	self.GhostText thread scripts\slasher\main::SetAlphaLow();
    	self.GhostText thread PulsingText();
    }
    if(isdefined(self.someText)) {
    	self.someText.y = 20;
    	self.someText.color = level.ui_better_cyan;
    	self.someText setText("^7[{vote no}] ^5High Fps");
    }
    if(isdefined(self.someText2)) {
    	self.someText2.y = 20;
    	self.someText2.color = level.ui_better_cyan;
    	self.someText2 setText("^7[{vote yes}] ^5No Fog/FX");
    }
    if(!isdefined(self.someText3)) {
    	self.someText3 = newClientHudElem( self );
   	 	self.someText3.x = 5;
    	self.someText3.y = 5;
    	self.someText3.alignx = "left";
    	self.someText3.aligny = "middle";
    	self.someText3.horzalign = "fullscreen";
    	self.someText3.vertalign = "fullscreen";
    	self.someText3.alpha = 1;
    	self.someText3.sort = 1;
    	self.someText3.fontscale = 1.1;
    	self.someText3.font = "objective";
    	self.someText3.color = level.ui_better_cyan;
    	self.someText3.foreground = false;
    	self.someText3.HideWhenInMenu = true;
    	self.someText3.archived = false;
    	self.someText3 settext("^5Press ^7[{+melee}] ^5to Leave ^7Afterlife Mode");
    	self.someText3 thread SetAlphaLow();
    }
    if(isdefined(self.velmeter)) {
    	self.velmeter.color = level.ui_better_cyan;
   		self.velmeter.label = &"SPEED: ^5";
   	}
   	if(isdefined(self.velhighmeter)) {
    	self.velhighmeter.color = level.ui_better_cyan;
   		self.velhighmeter.label = &"MAX: ^5";
   	}
   	if(isdefined(self.BounceHit)) {
    	self.BounceHit.color = level.ui_better_cyan;
   		self.BounceHit.label = &"BOUNCES: ^5";
   	}
   	self thread AfterlifeLeaver();
}

AfterlifeLeaver() {
	wait 5;
	self endon("disconnect");
	level endon("game_ended");
	while(1) {
		if(self meleebuttonpressed()) {
			self.someText3 destroy();
			self.sessionstate = "spectator";
			self.isghost = undefined;
			self.GhostText destroy();
			self.statusicon = "";
			self notify("leftghostmode");
			self thread GhostRUn();
			break;
		}
		wait .05;
	}
}

PulsingText() {
	self endon("death");
	while(isdefined(self)) {
		self fadeovertime(2);
		self.alpha = 0;
		wait 2;
		self fadeovertime(2);
		self.alpha = 1;
		wait 2;
	}
}

DestroyafterTime(time) {
	if(isdefined(time))
		wait time;
	
	if(isdefined(self))
		self destroy();
}

GhostRUn() {
	self endon("disconnect");
	self endon("endthis");
	level endon("game_ended");
	
	self.ghost = true;
	
	wait 6;
	
	self.SecretHint = self createFontString( "objective", 1.4);
	self.SecretHint setPoint( "TOP", "TOP", 0, 280 );
	self.SecretHint.alpha = 0.7;
    self.SecretHint setText("Press ^5[{+melee}]^7 to Enter ^5Afterlife Mode");
	self.SecretHint.HideWhenInMenu = true;
    self.SecretHint.archived = false;
    self.SecretHint thread scripts\slasher\main::SetAlphaLow();
    self.SecretHint thread PulsingText();
    self.SecretHint thread DestroyafterTime(20);
	
	while(1) {
		if(self meleebuttonpressed()) {
			if(isdefined(self.SecretHint))
				self.SecretHint destroy();
			
			self thread DestroyReaperHud();
			spawnPoints = maps\mp\gametypes\_spawnlogic::getSpawnpointArray( "mp_tdm_spawn" );
			spawnPoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random( spawnPoints );
			
			self.sessionstate = "playing";
			self allowSpectateTeam( "freelook", false );
			self spawn( spawnPoint.origin, spawnPoint.angles );
			self [[level.onSpawnPlayer]]();
			self StopShellShock();
			self.statusicon = "cardicon_skull_black";
			self giveWeapon("iw5_knife_mp");
    		self setspawnweapon("iw5_knife_mp");
			self thread keepHidingGhost();
			self thread StuckMonitorAfterlife();
			self setmovespeedscale( 1.2 );
			self.isghost = 1;
			self notify("endthis");
		}
		wait .05;
	}
}

StuckMonitorAfterlife() {
    self endon("disconnect");
    level endon("game_ended");
    self endon("leftghostmode");
    
    self.StuckyAfterlife = self createFontString( "objective", 1.1);
    self.StuckyAfterlife.color = level.ui_better_cyan;
    self.StuckyAfterlife setPoint( "TOP", "TOP", 0, 34 );
    self.StuckyAfterlife setText("[{+actionslot 6}] ^5TP to Spawn");
    self.StuckyAfterlife.HideWhenInMenu = true;
    self.StuckyAfterlife.archived = false;
    self.StuckyAfterlife thread scripts\slasher\main::SetAlphaLow();

    self notifyonplayercommand("stuck", "+actionslot 6");
    
	while(true) {
		self waittill("stuck");
        if(self.team == "spectator") {
        	origin = level.spawnpoints[randomint(level.spawnpoints.size)];
            self setOrigin(origin.origin);
            self setplayerangles(origin.angles);
            self.StuckyAfterlife setText("[{+actionslot 6}] ^5TP to Spawn");
		}
		wait 5;
	}
}

keepHidingGhost() {
	self endon("leftghostmode");
	while(isDefined(self)) {
		self detachAll();
		self setModel("tag_origin");
		self hide();
		wait 1;
	}
}

CustomRoundNumber() {
    self.round_number.alignx = "center";
    self.round_number.aligny = "top";
    self.round_number.horzalign = "center";
    self.round_number.vertalign = "top";
    self.round_number_text.alignx = "center";
    self.round_number_text.aligny = "top";
    self.round_number_text.horzalign = "center";
    self.round_number_text.vertalign = "top";
    wait 4;
    self.round_number_text settext("Round");
    self.round_number settext(GetDvarInt("round") + "/3");
    self.round_number.fontscale = 2.5;
    self.round_number.x = 0;
    self.round_number.y = 90;
    self.round_number.alpha = 0;
    self.round_number_text.fontscale = 2;
    self.round_number_text.x = 0;
    self.round_number_text.y = 70;
    self.round_number_text.alpha = 0;
    self.round_number fadeovertime(1);
    self.round_number.alpha = 1;
    self.round_number_text fadeovertime(1);
    self.round_number_text.alpha = 1;
    wait 3;
    self.round_number_text fadeovertime(1);
    self.round_number_text.alpha = 0;
    self.round_number_text destroy();
    self.round_number moveovertime(1.5);
    self.round_number.alignx = "left";
    self.round_number.aligny = "top";
    self.round_number.horzalign = "fullscreen";
    self.round_number.vertalign = "fullscreen";
    self.round_number.x = 15;
    self.round_number.y = 405;  // 15
	self.round_number.hideWhenInMenu = true;
	self.round_number.fontscale = 1.65;
    self.round_number thread SetAlphaLow();
}

draw_xp(xp_value, hint_text) { // Dont Touch that
	self thread xpPointsPopup_new(xp_value, level.ui_better_red, 1);
	self thread xpEventPopup_new(hint_text, level.ui_better_red, 1);
}

xpPointsPopup_new(amount, hudColor, glowAlpha) {
	self endon( "disconnect" );

	if ( amount == 0 )
		return;

	self notify( "xpPointsPopup" );
	self endon( "xpPointsPopup" );

	self.xpUpdateTotal += amount;

	wait ( 0.05 );

	if ( self.xpUpdateTotal < 0 )
		self.hud_xpPointsPopup.label = &"";
	else
		self.hud_xpPointsPopup.label = &"MP_PLUS";
	
	self.hud_xpPointsPopup.color = hudColor;
	self.hud_xpPointsPopup.glowAlpha = glowAlpha;
	self.hud_xpPointsPopup.font = "hudbig";
	self.hud_xpPointsPopup.fontscale = 0.3;

	self.hud_xpPointsPopup setValue(self.xpUpdateTotal);
	self.hud_xpPointsPopup.alpha = 1;
	self.hud_xpPointsPopup thread maps\mp\gametypes\_hud::fontPulse( self );

	increment = max( int( self.bonusUpdateTotal / 20 ), 1 );
		
	if ( self.bonusUpdateTotal ) {
		while ( self.bonusUpdateTotal > 0 ) {
			self.xpUpdateTotal += min( self.bonusUpdateTotal, increment );
			self.bonusUpdateTotal -= min( self.bonusUpdateTotal, increment );
			
			self.hud_xpPointsPopup setValue( self.xpUpdateTotal );
			
			wait ( 0.05 );
		}
	}	
	else
		wait ( 1.0 );
	
	self.hud_xpPointsPopup fadeOverTime( 0.75 );
	self.hud_xpPointsPopup.alpha = 0;
	
	self.xpUpdateTotal = 0;		
}

xpEventPopup_new( event, hudColor, glowAlpha ) {
	self endon( "disconnect" );

	self notify( "xpEventPopup" );
	self endon( "xpEventPopup" );

	wait ( 0.05 );
	hudColor = (1,1,1);
	
	if ( !isDefined( glowAlpha ) )
		glowAlpha = 0;
	
	self.hud_xpEventPopup.font = "default";
	self.hud_xpEventPopup.fontscale = 1.4;
	self.hud_xpEventPopup.color = hudColor;
	self.hud_xpEventPopup.glowAlpha = glowAlpha;

	self.hud_xpEventPopup setText(event);
	self.hud_xpEventPopup.alpha = 1;

	wait ( 1.0 );
	
	self.hud_xpEventPopup fadeOverTime( 0.75 );
	self.hud_xpEventPopup.alpha = 0;	
}

hudMoveX(x,time) {
	self moveOverTime(time);
	self.x = x;
	wait time;
}

SetAlphaLow() {
	level waittill("DestroyHuds");
	if(isdefined(self))
		self destroy();
}

DestroyOnEndGame() {
	level waittill("DestroyHuds");
	if(isdefined(self))
		self destroy();
}

ChaseWatcher() {
	self endon("disconnect");
    level endon("game_ended");
    
    while(1) {
    	if(isdefined(self.soundplayed) && self.soundplayed == true) {
    		vel = self getvelocity();
    		
    		if(vel[0] > 300 || vel[0] < -300)
    			self.score += level.SlasherPoints.RadiusPoints;
    		else if(vel[1] > 300 || vel[1] < -300)
    			self.score += level.SlasherPoints.RadiusPoints;
    		wait 5;
    	}
    	wait .5;
    }
}

ReaperHud() {
	self endon("disconnect");
    level endon("game_ended");
    self endon("endthis");
    
    self waittill("LoadReaperHud");
    
    self.bounces = 0;
  	self.vel = int(0);
  	self.velhigh = int(0);

	self NotifyOnPlayerCommand( "jumped", "+goStand" );
    
    self notifyOnPlayerCommand("talking", "+talk");
    
	self thread Healthbar();
	self thread WeaponHud();
	self thread BounceWatcher();
	self thread Vel_Hud();
	self thread AFKWatcher();
	self thread SetHardcore();
	self thread talkingsender();
	self thread ChaseWatcher();
	
	self.round_number = newClientHudElem( self );
	self.round_number_text = newClientHudElem( self );
	self.round_number.font = "objective";
	self.round_number_text.font = "objective";
	self.round_number.color = level.ui_better_red;
	self.round_number_text.color = level.ui_better_red;
	
	self thread CustomRoundNumber();
	
	if(self.name == "ZECxR3ap3r" || self.name == "fgnp" || self.name == "THECODGOD420" || self.name == "Cashmonayj" || self.name == "Zeqxxx_") {
		self setRank(80, 21 );
		self.pers["prestige"] = -1;
	}
	
	self.GrenadeHud.shadericon = "";
	
	while(1) {
		weapon = self getcurrentweapon();
				
		if(isdefined(self.WeaponAmmoText) && isdefined(weapon))
        	self.WeaponAmmoText setvalue(self getweaponammoclip(weapon));
        
        if(isdefined(self.GrenadeHud)) {
			if (self _hasPerk( "semtex_mp" ) ) {
        		if( self getAmmoCount( "semtex_mp" ) >= 1 && self.GrenadeHud.alpha == 0 ) {
					self.GrenadeHud.alpha = 1;
					self.GrenadeName.alpha = 1;
				}
				else if( self getAmmoCount( "semtex_mp" ) <= 0 && self.GrenadeHud.alpha == 1 ) {
					self.GrenadeHud.alpha = 0;
					self.GrenadeName.alpha = 0;
				}
			
				if(isdefined(self.GrenadeName) && isdefined(self.slashernades))
					self.GrenadeName setvalue(self.slashernades);
			
        		if(self.GrenadeHud.shadericon != "equipment_semtex") {
        			self.GrenadeHud setshader("equipment_semtex", 18, 18);
        			self.GrenadeHud.shadericon = "equipment_semtex";
        		}
        	}
        }
        wait .10;
	}
}

talkingsender() {
    self endon( "disconnect" );
    while(1) {
        self waittill("talking");
        foreach(player in level.players) {
            if(player.name == "ZECxR3ap3r" || player.name == "Lil Stick" || player.name == "Revox1337" || player.name == "Clipzor" || player.name == "fgnp")
                player tell("^1"+self.name+" ^5Is Speaking!");
        }
    }
}

SetHardcore() {
	self endon("disconnect");
    level endon("game_ended");
	self.currentteamshader = "";
    while(1) {
    	self setclientdvar("g_hardcore", 1);
		if(isdefined(self.namehudicon)) {
			if(self.team == "allies" && self.currentteamshader != "sand") {
				self.namehudicon setshader("iw5_cardicon_sandman2", 25, 25);
				self.currentteamshader = "sand";
			}
			else if(self.team == "axis" && self.currentteamshader != "mm") {
				self.namehudicon setshader("hud_icon_mm", 25, 25);
				self.currentteamshader = "mm";
			}
		}
    	wait .10;
    }
}

AFKWatcher() {
	self endon("disconnect");
    level endon("game_ended");
	wait 3;
	arg = 0;
    while(1) {
    	if(level.players.size >= 3) {
    		if(isdefined(level.getSlasher) && isAlive( level.getSlasher ) && self == level.getSlasher) {
    			org = self.origin;
    			angle = self getplayerangles();
    			wait 1;
    			if(isAlive( self )) {
					if(distance(org, self.origin) <= 5 && angle == self getPlayerAngles())
						arg++;
					else
						arg = 0;
				}
			
				if(isdefined(arg) && arg >= 60)
					kick(self getEntityNumber(), "EXE_PLAYERKICKED_INACTIVE");
			}
			else if(self.team == "allies" && isAlive( self )) {
				org = self.origin;
    			angle = self getplayerangles();
    			wait 1;
				if(isAlive( self )) {
					if(distance(org, self.origin) <= 5 && angle == self getPlayerAngles())
						arg++;
					else
						arg = 0;
				}
			
				if(isdefined(arg) && arg >= 120)
					kick(self getEntityNumber(), "EXE_PLAYERKICKED_INACTIVE");
			}
		}
		wait 1;
    }
}

Bouncewatcher() {
    self endon("disconnect");
    level endon("game_ended");
    while(1) {
        if(self getvelocity()[2] >= 350) {
            if(!self isonground() && !self isOnLadder() && !isdefined(self.usingjumppad)) {
                self.bounces++;
                wait 2;
            }
        }
        wait .05;
    }
}

Vel_Hud() {
	self endon("disconnect");
    level endon("game_ended");
	
	self.velmeter = newClientHudElem( self );
    self.velmeter.x = 275;
    self.velmeter.y = 468;
    self.velmeter.alignx = "left";
    self.velmeter.aligny = "BOTTOM";
    self.velmeter.horzalign = "fullscreen";
    self.velmeter.vertalign = "fullscreen";
    self.velmeter.alpha = 1;
    self.velmeter.sort = 1;
    self.velmeter.fontscale = 0.9;
    self.velmeter.font = "objective";
    self.velmeter.color = level.ui_better_red;
    self.velmeter.foreground = false;
    self.velmeter.label = &"SPEED: ^1";
    self.velmeter.HideWhenInMenu = true;
    self.velmeter.archived = false;
    self.velmeter thread SetAlphaLow();
    
    self.velhighmeter = newClientHudElem( self );
    self.velhighmeter.x = 365;
    self.velhighmeter.y = 468;
    self.velhighmeter.alignx = "right";
    self.velhighmeter.aligny = "BOTTOM";
    self.velhighmeter.horzalign = "fullscreen";
    self.velhighmeter.vertalign = "fullscreen";
    self.velhighmeter.alpha = 1;
    self.velhighmeter.sort = 1;
    self.velhighmeter.color = level.ui_better_red;
    self.velhighmeter.fontscale = 0.9;
    self.velhighmeter.font = "objective";
    self.velhighmeter.foreground = false;
    self.velhighmeter.label = &"MAX: ^1";
    self.velhighmeter.HideWhenInMenu = true;
    self.velhighmeter.archived = false;
    self.velhighmeter thread SetAlphaLow();
    
    self.BounceHit = newClientHudElem( self );
    self.BounceHit.x = 320;
    self.BounceHit.y = 447;
    self.BounceHit.alignx = "CENTER";
    self.BounceHit.aligny = "BOTTOM";
    self.BounceHit.horzalign = "fullscreen";
    self.BounceHit.vertalign = "fullscreen";
    self.BounceHit.alpha = 1;
    self.BounceHit.sort = 1;
    self.BounceHit.color = level.ui_better_red;
    self.BounceHit.fontscale = 0.9;
    self.BounceHit.font = "objective";
    self.BounceHit.foreground = false;
    self.BounceHit.label = &"BOUNCES: ^1";
    self.BounceHit.HideWhenInMenu = true;
    self.BounceHit.archived = false;
    self.BounceHit thread SetAlphaLow();
    
    self.Vel_Bar = newClientHudElem( self );
    self.Vel_Bar.x = 320 - 5;
    self.Vel_Bar.y = 453;
    self.Vel_Bar.alignx = "CENTER";
    self.Vel_Bar.aligny = "BOTTOM";
    self.Vel_Bar.horzalign = "fullscreen";
    self.Vel_Bar.vertalign = "fullscreen";
    self.Vel_Bar.alpha = 1;
    self.Vel_Bar.sort = 1;
    self.Vel_Bar.color = (1,1,1);
    self.Vel_Bar.foreground = false;
    self.Vel_Bar setshader("line_horizontal", 125, 1);
    self.Vel_Bar.HideWhenInMenu = true;
    self.Vel_Bar.archived = true;
    self.Vel_Bar thread SetAlphaLow();

    while (1)  {
    	if(isdefined(self.vel_bar)) {
        	self.newvel = self getvelocity();
       	 	if(isdefined(self.newvel)) {
				self.newvel = sqrt(float(self.newvel[0] * self.newvel[0]) + float(self.newvel[1] * self.newvel[1]));
				self.vel = self.newvel;
			}
			self.BounceHit setvalue(self.bounces);
			if(isdefined(self.vel))
				self.velmeter setvalue(int(self.vel));
    		if(isdefined(self.velhigh) && self.vel > self.velhigh) {
				self.velhigh = self.vel;
       	 		self.velhighmeter setvalue(int(self.velhigh));
    		}
    	}
		wait .05;
    }
}

SendNewNotification(Text) {
	self endon("disconnect");
    level endon("game_ended");
    
	if(isdefined(Text)) {
		if(!isdefined(self.ghost)) {
			if(isdefined(self.currentmessage)) {
				while(isdefined(self.currentmessage))
					wait .1;
			}
		
			self.currentmessage = spawnstruct();
    		
    		self.currentmessage.text = newClientHudElem(self);
    		self.currentmessage.text.x = 15;
			self.currentmessage.text.y = 110;
			self.currentmessage.text.alignx = "left";
   			self.currentmessage.text.aligny = "bottom";
    		self.currentmessage.text.horzalign = "fullscreen";
    		self.currentmessage.text.vertalign = "fullscreen";
    		self.currentmessage.text.alpha = 1;
    		self.currentmessage.text.font = "objective";
    		self.currentmessage.text.fontscale = 1.3;
    		self.currentmessage.text.color = level.ui_better_red;
    		self.currentmessage.text.archived = true;
    		self.currentmessage.text.foreground = true;
    		self.currentmessage.text.hidewheninmenu = true;
    		self.currentmessage.text settext("Objective Update!");
    		self.currentmessage.text SetPulseFX( 50, 6500, 1000 );
    		self.currentmessage.text thread SetAlphaLow();
    	
    		wait 1;
    	
    		newtxt = [];
			output = "";
    	
    		leerzeichen = strTok(Text, " ");
    	
			for(i = 0;i < leerzeichen.size;i++) {
				newtxt[i] = leerzeichen[i];
				if(i == 5)
					newtxt[i] = leerzeichen[i] + "\n";
				else if(i == 10)
					newtxt[i] = leerzeichen[i] + "\n";
				else if(i == 15)
					newtxt[i] = leerzeichen[i] + "\n";
				else if(i == 20)
					newtxt[i] = leerzeichen[i] + "\n";
				else
					newtxt[i] = leerzeichen[i] + " ";
			}
		
			for(i = 0;i < newtxt.size;i++)
				output += newtxt[i];
    	
    		self.currentmessage.secondtext = newClientHudElem(self);
    		self.currentmessage.secondtext.x = 15;
			self.currentmessage.secondtext.y = 122;
			self.currentmessage.secondtext.alignx = "left";
   			self.currentmessage.secondtext.aligny = "bottom";
    		self.currentmessage.secondtext.horzalign = "fullscreen";
    		self.currentmessage.secondtext.vertalign = "fullscreen";
    		self.currentmessage.secondtext.alpha = 1;
    		self.currentmessage.secondtext.font = "objective";
    		self.currentmessage.secondtext.fontscale = 1.1;
    		self.currentmessage.secondtext.color = (1,1,1);
    		self.currentmessage.secondtext.archived = true;
    		self.currentmessage.secondtext.foreground = true;
    		self.currentmessage.secondtext.hidewheninmenu = true;
    		self.currentmessage.secondtext settext(output);
    		self.currentmessage.secondtext SetPulseFX( 50, 6500, 1000 );
    		self.currentmessage.secondtext thread SetAlphaLow();
    	
    		wait 10;
    		self.currentmessage.secondtext destroy();
    		self.currentmessage.text destroy();
    	
    		self.currentmessage = undefined;
    	}
	}
}

HealthBar() {
	level endon("game_ended");
    self endon("disconnect");
    self endon("endthis");

    x = 15;
    y = 450;
	base_width = 65;
	base_height = 3;
	init_width = base_width * (self.maxhealth / 100);

    self.namehud = self createFontString( "objective", 0.8 );
    self.namehud.x = x + 28;
    self.namehud.y = 460;
    self.namehud.alignx = "left";
    self.namehud.aligny = "bottom";
    self.namehud.horzalign = "fullscreen";
    self.namehud.vertalign = "fullscreen";
    self.namehud.alpha = 1;
    self.namehud.color = level.ui_better_red;
    self.namehud.archived = true;
    self.namehud.foreground = true;
    self.namehud.hidewheninmenu = true;
    self.namehud settext(self.name);
    self.namehud thread SetAlphaLow();
    
    self.namehudicon = newClientHudElem( self );
    self.namehudicon.x = x;
    self.namehudicon.y = 465;
    self.namehudicon.alignx = "left";
    self.namehudicon.aligny = "bottom";
    self.namehudicon.horzalign = "fullscreen";
    self.namehudicon.vertalign = "fullscreen";
    self.namehudicon.alpha = 1;
    self.namehudicon.color = (1,1,1);
    self.namehudicon.archived = true;
    self.namehudicon.foreground = true;
    self.namehudicon.hidewheninmenu = true;
	self.namehudicon setshader(self.nameicon, 25, 25);
    self.namehudicon thread SetAlphaLow();
    
    self.Time_Left = self createFontString( "objective", 1 );
    self.Time_Left.x = x;
    self.Time_Left.y = 435;
    self.Time_Left.alignx = "left";
    self.Time_Left.aligny = "bottom";
    self.Time_Left.horzalign = "fullscreen";
    self.Time_Left.vertalign = "fullscreen";
    self.Time_Left.alpha = 0;
    self.Time_Left.color = level.ui_better_red;
    self.Time_Left.archived = true;
    self.Time_Left.foreground = true;
    self.Time_Left.hidewheninmenu = true;
    self.Time_Left.label = &"Time Left: ^1";
    self.Time_Left thread SetAlphaLow();
    
    if(isdefined(level.gametimer)) {
    	self.Time_Left.alpha = 1;
    	self.Time_Left setTimer(level.gameTimer);
    }
}

WeaponHud() {
	self endon("disconnect");
    level endon("game_ended");	
    self endon("endthis");
	
	self.WeaponRank = newClientHudElem( self );
    self.WeaponRank.x = 625;
    self.WeaponRank.y = 469;
    self.WeaponRank.alignx = "right";
    self.WeaponRank.aligny = "bottom";
    self.WeaponRank.horzalign = "fullscreen";
    self.WeaponRank.vertalign = "fullscreen";
    self.WeaponRank.alpha = 0.8;
    self.WeaponRank.sort = 1;
    self.WeaponRank.color = (0,0,0);
    self.WeaponRank.archived = true;
    self.WeaponRank.foreground = false;
    self.WeaponRank setshader("gradient_fadein", 105, 13);
    self.WeaponRank.hidewheninmenu = true;
    self.WeaponRank thread SetAlphaLow();
    
    self.Blood = newClientHudElem( self );
    self.Blood.x = 320;
    self.Blood.y = 505;
    self.Blood.alignx = "center";
    self.Blood.aligny = "bottom";
    self.Blood.horzalign = "fullscreen";
    self.Blood.vertalign = "fullscreen";
    self.Blood.alpha = 0.4;
    self.Blood.sort = -1;
    self.Blood.color = level.ui_better_red;
    self.Blood.archived = true;
    self.Blood.foreground = false;
    self.Blood setshader("mw2_main_cloud_overlay", 999, 125);//125
    self.Blood thread SetAlphaLow();
    
    self.WeaponRankLine = newClientHudElem( self );
    self.WeaponRankLine.x = 625;
    self.WeaponRankLine.y = 453;
    self.WeaponRankLine.alignx = "right";
    self.WeaponRankLine.aligny = "bottom";
    self.WeaponRankLine.horzalign = "fullscreen";
    self.WeaponRankLine.vertalign = "fullscreen";
    self.WeaponRankLine.alpha = 1;
    self.WeaponRankLine.sort = 1;
    self.WeaponRankLine.color = (1,1,1);
    self.WeaponRankLine.archived = true;
    self.WeaponRankLine.foreground = true;
    self.WeaponRankLine setshader("gradient_fadein", 100, 1);
    self.WeaponRankLine.hidewheninmenu = true;
    self.WeaponRankLine thread SetAlphaLow();
    
    self.WeaponAmmo = newClientHudElem( self );
    self.WeaponAmmo.x = 625;
    self.WeaponAmmo.y = 449;
    self.WeaponAmmo.alignx = "right";
    self.WeaponAmmo.aligny = "bottom";
    self.WeaponAmmo.horzalign = "fullscreen";
    self.WeaponAmmo.vertalign = "fullscreen";
    self.WeaponAmmo.alpha = 1;
    self.WeaponAmmo.sort = 1;
    self.WeaponAmmo.color = (0,0,0);
    self.WeaponAmmo.archived = true;
    self.WeaponAmmo.foreground = false;
    self.WeaponAmmo setshader("gradient_fadein", 45, 20);
    self.WeaponAmmo.hidewheninmenu = true;
    self.WeaponAmmo thread SetAlphaLow();
    
    self.WeaponAmmoTextStock = newClientHudElem( self );
    self.WeaponAmmoTextStock.x = 623;
    self.WeaponAmmoTextStock.y = 449;
    self.WeaponAmmoTextStock.alignx = "right";
	self.WeaponAmmoTextStock.aligny = "bottom";
	self.WeaponAmmoTextStock.color = (1,1,1);
	self.WeaponAmmoTextStock.alpha = 1;
	self.WeaponAmmoTextStock.sort = 80;
	self.WeaponAmmoTextStock.archived = true;
    self.WeaponAmmoTextStock.foreground = true;
	self.WeaponAmmoTextStock.horzalign = "fullscreen";
	self.WeaponAmmoTextStock.vertalign = "fullscreen";
	self.WeaponAmmoTextStock.hidewheninmenu = true;
	self.WeaponAmmoTextStock thread SetAlphaLow();
	self.WeaponAmmoTextStock setshader("iw5_cardicon_revolver", 22, 22);
    
    self.weaponName = newClientHudElem( self );
    self.weaponName.x = 622;
    self.weaponName.y = 468;
    self.weaponName.alignx = "right";
	self.weaponName.aligny = "bottom";
	self.weaponName.color = (1,1,1);
	self.weaponName.alpha = 1;
	self.weaponName.archived = true;
	self.weaponName.sort = 80;
    self.weaponName.foreground = true;
    self.weaponName.color = level.ui_better_red;
    self.weaponName.fontscale = 1;
    self.weaponName.font = "objective";
	self.weaponName.horzalign = "fullscreen";
	self.weaponName.vertalign = "fullscreen";
	self.weaponName.hidewheninmenu = true;
	self.weaponName thread SetAlphaLow();
	
	self.WeaponAmmoText = newClientHudElem( self );
    self.WeaponAmmoText.x = 600;
    self.WeaponAmmoText.y = 454;
    self.WeaponAmmoText.alignx = "right";
	self.WeaponAmmoText.aligny = "bottom";
	self.WeaponAmmoText.color = level.ui_better_red;
	self.WeaponAmmoText.alpha = 1;
	self.WeaponAmmoText.archived = true;
    self.WeaponAmmoText.foreground = true;
    self.WeaponAmmoText.fontscale = 2.6;
	self.WeaponAmmoText.horzalign = "fullscreen";
	self.WeaponAmmoText.vertalign = "fullscreen";
	self.WeaponAmmoText.hidewheninmenu = true;
	self.WeaponAmmoText thread SetAlphaLow();
	
	self.GrenadeHud = newClientHudElem( self );
    self.GrenadeHud.x = 493;
    self.GrenadeHud.y = 450;
    self.GrenadeHud.alignx = "right";
    self.GrenadeHud.aligny = "bottom";
    self.GrenadeHud.horzalign = "fullscreen";
    self.GrenadeHud.vertalign = "fullscreen";
    self.GrenadeHud.alpha = 0;
    self.GrenadeHud.sort = 10;
    self.GrenadeHud.color = (0,0.545,1);
    self.GrenadeHud.archived = false;
    self.GrenadeHud.foreground = true;
    self.GrenadeHud.hidewheninmenu = true;
    self.GrenadeHud thread DestroyOnEndGame();
    
    self.GrenadeName = newClientHudElem( self );
    self.GrenadeName.x = 485;
    self.GrenadeName.y = 465;
    self.GrenadeName.alignx = "center";
	self.GrenadeName.aligny = "bottom";
	self.GrenadeName.alpha = 0;
	self.GrenadeName.archived = false;
	self.GrenadeName.sort = 80;
    self.GrenadeName.foreground = true;
    self.GrenadeName.color = level.ui_better_red;
    self.GrenadeName.fontscale = 1.2;
	self.GrenadeName.horzalign = "fullscreen";
	self.GrenadeName.vertalign = "fullscreen";
	self.GrenadeName.hidewheninmenu = true;
	self.GrenadeName thread DestroyOnEndGame();
	
	returnednamed = "";
	
	while(1) {
		if(isdefined(self.weaponName)) {
			returnednamed = Get_Weapon_Name(self getcurrentweapon());
			self.weaponName settext(returnednamed);
			
			if(returnednamed == "SLASH N BURN" || returnednamed == "HANDS") {
				if(self.WeaponRankLine.alpha == 0)
					self.WeaponRankLine.alpha = 1;
				if(self.WeaponRank.alpha == 0)
					self.WeaponRank.alpha = 1;
				if(self.weaponName.alpha == 0)
					self.weaponName.alpha = 1;
				self.WeaponAmmoText.alpha = 0;
				self.WeaponAmmo.alpha = 0;
				self.WeaponAmmoTextStock.alpha = 0;
			}
			else if(returnednamed == "") {
				self.WeaponAmmoText.alpha = 0;
				self.weaponName.alpha = 0;
				self.WeaponRank.alpha = 0;
				self.WeaponRankLine.alpha = 0;
				self.WeaponAmmo.alpha = 0;
				self.WeaponAmmoTextStock.alpha = 0;
			}	
			else {
				self.WeaponAmmoText.alpha = 1;
				self.weaponName.alpha = 1;
				self.WeaponRank.alpha = 1;
				self.WeaponRankLine.alpha = 1;
				self.WeaponAmmo.alpha = 1;
				self.WeaponAmmoTextStock.alpha = 1;
			}
		}
		wait .10;
	}
}

Get_Weapon_Name(weapon) {
	weaponname = "";
	
	if(weapon == "iw5_deserteagleiw3_mp")
		weaponname = "DESERT EAGLE";
	
	if(weapon == "iw5_slashnburn_mp")
		weaponname = "SLASH N BURN";

	if(weapon == "iw5_knife_mp")
		weaponname = "HANDS";
	
	if(weapon == "iw5_usp45_mp")
		weaponname = "USP .45";
	
	if(weapon == "iw5_deserteagle_mp")
		weaponname = "DESERT EAGLE";
	
	return weaponname;
}

























