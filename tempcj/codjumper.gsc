#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

init()
{
	// discord hud
	level.huddiscord = createServerFontString ("default", 1.2);
    level.huddiscord.horzalign = "fullscreen";
    level.huddiscord.vertalign = "fullscreen";
    level.huddiscord.x = 320;
    level.huddiscord.y = 1;
    level.huddiscord.alignx = "center";
    level.huddiscord.alpha = 0.5;
    level.huddiscord settext("Gillette^1Clan^7.com/^5discord");  //Replace ClippyMadeCoomersWhatItIs for your own discord link or whatever you want
    level.huddiscord.archived = true;
	//
    
	level thread onPlayerConnect();
	level thread ColorHudWatcher(); // chat listener to allow ppl to change color of their huds

	thread hook_callbacks(); //Callback for player damage, to disable killing etc

	level.markerfx = loadFX( "misc/flare_ambient" );
	level.blockWeaponDrops = true;	//Blocks Weapon Drops
	
	// Colors
	level.ui_better_green = (0.33, 1, 0.33);
	level.ui_better_gold = (0.906, 0.824, 0.467);
	level.ui_better_red = (1, 0.25, 0.25);
	level.ui_better_blue = (0.25, 0.25, 1);
	level.ui_better_cyan = (0.25, 0.75, 0.75);
	level.ui_better_orange = (1, 0.3, 0);
	level.ui_better_yellow = (0.75, 0.75, 0);
	level.ui_better_purple = (0.75, 0, 0.75);
	//
	
	precacheshader("hud_killstreak_highlight");
	setdvar("g_hardcore", 1);
	setdvar("g_teamicon_axis", "");
	setdvar("cg_scoreboardheaderfontscale", 0);
    setdvar("g_teamicon_allies", "killiconfalling");
    setdvar("g_teamname_axis", "                                                                                                                                                                                                                                                                                                                                                                                                                        ");
    setdvar("g_teamname_allies", "^8COD^5JUMPER^7                                                     Bounces        Saves       Loads   Minutes           Ping                                                                                                                                        ");
	setdvar("g_scorescolor_allies", "0.25 0.75 0.25 1");
    setdvar("g_scorescolor_axis", "0.25 0.75 0.75 1");
}

onPlayerConnect()  {
    for(;;) {
        level waittill("connected", player);
        player.choosencolor = level.ui_better_gold; // players color is defaulted to ui_better_gold
        player setclientdvar("cg_teamcolor_allies", "0.25 0.75 0.25 1");
		player.hasloaded = false;
		player.hassaved = false;
		player thread onPlayerSpawned();
		player thread TimeWatcher(); // tracks minutes played for the player to show in scoreboard
    	player setclientdvar("cg_scoreboardheaderfontscale", 0);
    	player setclientdvar("g_hardcore", 1);

		// Notifies for key hud and marker
		player notifyonplayercommand("+jump", "+gostand");
		player notifyonplayercommand("-jump", "-gostand");
		player notifyonplayercommand("marker", "+smoke");
		player notifyonplayercommand("+w", "+forward");
		player notifyonplayercommand("-w", "-forward");
		player notifyonplayercommand("+s", "+back");
		player notifyonplayercommand("-s", "-back");
		player notifyonplayercommand("+d", "+moveright");
		player notifyonplayercommand("-d", "-moveright");
		player notifyonplayercommand("+a", "+moveleft");
		player notifyonplayercommand("-a", "-moveleft");
		player notifyOnPlayerCommand("gimmerpg", "+actionslot 4");
		//

		player thread Hud(); // handles the wasd hud's color and pressing
		player thread hudposition(); // creates all the huds for the wasd hud
    }
}

onPlayerSpawned()  {
    self endon("disconnect");
    self maps\mp\gametypes\_menus::addToTeam( "allies", 1 ); // automaticly adds player to team on joining server
    self.initial_spawn = 0;
    self.isspectating = self;
    while(1) {
        self waittill("spawned_player");
        if(self.initial_spawn == 0) { // only gets called on first time spawning in
        	self.initial_spawn = 1;
        	
        	self.Spectators = self createFontString( "default", 1.4); //
			self.Spectators setPoint( "TOPLEFT", "TOPLEFT", 5, 125); //
			self.Spectators.label = &"^8Spectators: ^5"; // sets up the hud that shows how many ppl speccing u
        	
        	self.numsaves = 1;
        	self.specvalue = 0;
     		self thread Save(); //save/load logic

			self thread Wkey(); //wasd jump crouch huds
			self thread Akey(); //
			self thread Skey(); //
			self thread Dkey(); //
			self thread Jumpkey(); //
			self thread Crouchkey(); //

			self thread Velocity(); //velocity hud
			self thread Marker(); //flare to mark height

			self thread Bouncewatcher(); // bounce detection
			self thread GiveRPG(); // give rpg on button press
			self thread RPGBounceMessager(); // tells about timing of rpg
			self thread SpecificGunWatcher(); // disables ammo on most guns
			self thread Spectators(); // for displaying amount of speccing people ( not perfect )
        }
        
        if(self.specvalue < 0)
        	self.specvalue = 0;
        
		self FreezeControls(false); //allows moving before timer ends
    }
}

Spectators() {
	self endon("disconnect");
	level endon("game_ended");
	
	while(1) {
		if(self.sessionteam == "spectator") {
			spectatedPlayer = self GetSpectatingPlayer();
			if(isdefined(spectatedPlayer)) {
				if(isdefined(spectatedPlayer) && isdefined(self.isspectating) && self.isspectating.name == "" && self.isspectating.name != spectatedPlayer.name) {
					if(isdefined(spectatedPlayer.specvalue))
						spectatedPlayer.specvalue++;
					self.isspectating = spectatedPlayer;
				}
				else if(isdefined(self.isspectating) && self.isspectating.name != "" && isdefined(spectatedPlayer) && spectatedPlayer.name != self.isspectating.name) {
					if(isdefined(self.isspectating) && isdefined(self.isspectating.name)) {
						earlier = self.isspectating;
						if(isdefined(earlier.specvalue))
							earlier.specvalue--;
					}
				
					self.isspectating = spectatedPlayer;
					spectatedPlayer.specvalue++;
				}
				else if(isdefined(self.isspectating) && self.isspectating.name != "" && !isdefined(spectatedPlayer)){
					if(isdefined(self.isspectating) && isdefined(self.isspectating.name)) {
						earlier = self.isspectating;
						if(isdefined(earlier.specvalue))
							earlier.specvalue--;
					}
					self.isspectating = "";
				}
			}
		}
		else {
			if(self.isspectating.name != self.name) {
				earlier = self.isspectating;
				if(isdefined(earlier.specvalue))
					earlier.specvalue--;
				self.isspectating = self;
			}
		}
		
		if(self.specvalue == 0)
			self.Spectators.alpha = 0;
		else
			self.Spectators.alpha = 1;
		
		self.Spectators setvalue(self.specvalue);
		wait 0.2;
	}
}

ColorHudWatcher() {
	level endon("game_ended");
	while(1) {
		level waittill( "say", message, player ); // waits for anyone to send a message
		
		str = strTok( message, "" ); // removes  from message
		
        i = 0;
        foreach ( s in str ) {
            if ( i > 2 )
                break;
            message = s;
            i++;
        }
		
        Cmd = getSubStr(message,0,6);
        
        if(isdefined(Cmd) && Cmd == "!color") {// checks for !color command
            Color = getSubStr(message,7,message.size); // checks whats after the !color command (the actual color)
            
            if(Color == "green")
            	player SetNewColor("Green");
            
            if(Color == "red")
            	player SetNewColor("Red");
            
            if(Color == "blue")
            	player SetNewColor("Blue");
            
            if(Color == "cyan")
            	player SetNewColor("Cyan");
            
            if(Color == "purple")
            	player SetNewColor("Purple");
            
            if(Color == "yellow")
            	player SetNewColor("Yellow");
            
            if(Color == "orange")
            	player SetNewColor("Orange");
            
            if(Color == "default")
            	player SetNewColor("Default");
        }
        wait .05;
	}
}

SetNewColor(Color) {
	// checks which color u choose to change your hud color accordingly
	col = level.ui_better_gold;
	if(Color == "Green") {
		col = level.ui_better_green;
		self setclientdvar("cg_teamcolor_allies", "0.25 1 0.25 1");
	}
	else if(Color == "Red") {
		col = level.ui_better_red;
		self setclientdvar("cg_teamcolor_allies", "1 0.25 0.25 1");
	}
	else if(Color == "Blue") {
		col = level.ui_better_blue;
		self setclientdvar("cg_teamcolor_allies", "0.25 0.25 1 1");
	}
	else if(Color == "Cyan") {
		col = level.ui_better_cyan;
		self setclientdvar("cg_teamcolor_allies", "0.25 0.75 0.75 1");
	}
	else if(Color == "Orange") {
		col = level.ui_better_orange;
		self setclientdvar("cg_teamcolor_allies", "1 0.3 0 1");
	}
	else if(Color == "Yellow") {
		col = level.ui_better_yellow;
		self setclientdvar("cg_teamcolor_allies", "0.75 0.75 0 1");
	}
	else if(Color == "Purple") {
		col = level.ui_better_purple;
		self setclientdvar("cg_teamcolor_allies", "0.75 0 0.75 1");
	}
	else if(Color == "Default") {
		col = level.ui_better_gold;
		self setclientdvar("cg_teamcolor_allies", "0.25 0.75 0.25 1");
	}

	
	if(isdefined(self.keypressD))
		self.keypressD.color = col;
	
	if(isdefined(self.keypressW))
		self.keypressW.color = col;
	
	if(isdefined(self.keypressA))
		self.keypressA.color = col;
	
	if(isdefined(self.keypressS))
		self.keypressS.color = col;
	
	if(isdefined(self.choosencolor))
		self.choosencolor = col;
	
	if(isdefined(self.keypressSpace))
		self.keypressSpace.color = col;
	
	if(isdefined(self.keypressCrouch))
		self.keypressCrouch.color = col;
}

SpecificGunWatcher() {
	self endon("disconnect");
    level endon("game_ended");

	// makes it so that people only have ammo for the specified guns

    while(1) {
    	weapon = getBaseWeaponName(self getcurrentweapon());
    	if(weapon != "iw5_deserteagle" && weapon != "iw5_usp45" && weapon != "rpg" && weapon != "iw5_usp45jugg" && weapon != "xm25") {
			if( isSubStr( self getcurrentweapon(), "akimbo" ) )
			{
				self SetWeaponAmmoClip( self getcurrentweapon(), 0 , "left" );
				self SetWeaponAmmoClip( self getcurrentweapon(), 0 , "right" );
			}
			else
			{
				self setweaponammoclip(self getcurrentweapon(), 0);
			}
    		self setweaponammostock(self getcurrentweapon(), 0);
    	}
    	wait 0.5;
    }
}

GiveRPG() {
	self endon("disconnect");
    level endon("game_ended");
	while(1) {
		self waittill("gimmerpg"); // waits for notify button press
		self giveweapon("rpg_mp", 11); // gives rpg
		self setSpawnWeapon("rpg_mp"); // instantly switches to rpg
		wait 0.5;
		self waittill("weapon_change"); // waits for you to swap away from rpg
		self takeweapon("rpg_mp"); // takes rpg
		self setSpawnWeapon(self getWeaponsListPrimaries()[0]); // instantly switches back to main gun
	}
}

RPGBounceMessager() {
	self endon("disconnect");
    level endon("game_ended");
	while(1) {
		self waittill("weapon_fired", weaponname); // waits for gun fired
		if(weaponname == "rpg_mp" && isdefined(self.bouncetime)) { // checks if rpg shot and u bounced
			if((gettime() - self.bouncetime) <= 50) // less then 50 since bounce? goood
				self iprintln("^8RPG Shot was ^5Good");
			else 									// if bounced and more then 50, rpg is late
				self iprintln("^8RPG Shot was ^5"+(gettime() - self.bouncetime) + " ^8Milliseconds Late");
			wait 2;
		}
		else if(weaponname == "rpg_mp" && !isdefined(self.bouncetime) && !self isOnGround() && self getvelocity()[1] >= 300) { // shot before bounced
			self iprintln("^8RPG Shot too ^5Early^8!");
			wait 2;
		}
		else if(weaponname == "rpg_mp" && !isdefined(self.bouncetime) && !self isOnGround() && self getvelocity()[0] >= 300) { // shot before bounced
			self iprintln("^8RPG Shot too ^5Early^8!");
			wait 2;
		}
		else if(weaponname == "rpg_mp" && !isdefined(self.bouncetime) && !self isOnGround() && self getvelocity()[1] <= -300) { // shot before bounced
			self iprintln("^8RPG Shot too ^5Early^8!");
			wait 2;
		}
		else if(weaponname == "rpg_mp" && !isdefined(self.bouncetime) && !self isOnGround() && self getvelocity()[0] <= -300) { // shot before bounced
			self iprintln("^8RPG Shot too ^5Early^8!");
			wait 2;
		}
		wait .05;
	}
}

Bouncewatcher() {
	self endon("disconnect");
    level endon("game_ended");
	while(1) {
		if(self getvelocity()[2] >= 350) { // upward velocity higher then 350
			if(!self isonground() && !self isOnLadder() && !isdefined(self.usingjumppad)) { // not on ground not on ladder and not using jump pad ( infected edits etc )
				self.bouncetime = gettime(); 	// gametime when u bounced
				self.score++;					// increment the scoreboard bounce counter
				wait 2;
				self.bouncetime = undefined;	// after 2 full seconds reset bouncetime
			}
		}
		wait .05;
	}
}

TimeWatcher() {
	self endon("disconnect");
	level endon("game_ended");
	self.savedmins = 0;
	while(1) {
		wait 60; // 1 minute waits
		self.savedmins++; // increment minute counter
		self.deaths = self.savedmins; // increment death counter for scoreboard time
	}
}

hook_callbacks() {
	level.prevCallbackPlayerDamage = level.callbackPlayerDamage;
	level.callbackPlayerDamage = ::onPlayerDamage;
}

onPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime) { // does nothing with the taken damage unless player enters death trigger, then kills them
	if(sMeansOfDeath == "MOD_TRIGGER_HURT") // checks if damage is death barrier
		self maps\mp\gametypes\_damage::Callback_PlayerDamage_internal( eInflictor, eAttacker , self , iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime ); // does the damage
}

Wkey() {
	self endon("disconnect");
    level endon("game_ended");
	while(true) {
		self waittill ("+w"); // waits for w button pressed
		self.keyw = 1;
		self waittill ("-w"); // waits for w button unpressed
		self.keyw = 0;
	}
}

Akey() {
	self endon("disconnect");
    level endon("game_ended");
	while(true) {
		self waittill ("+a"); // waits for a button pressed
		self.keya = 1;
		self waittill ("-a"); // waits for a button unpressed
		self.keya = 0;
	}
}

Skey() {
	self endon("disconnect");
    level endon("game_ended");
	while(true) {
		self waittill ("+s"); // waits for s button pressed
		self.keys = 1;
		self waittill ("-s"); // waits for s button unpressed
		self.keys = 0;
	}
}

Dkey() {
	self endon("disconnect");
    level endon("game_ended");
	while(true) {
		self waittill ("+d"); // waits for d button pressed
		self.keyd = 1;
		self waittill ("-d"); // waits for d button unpressed
		self.keyd = 0;
	}
}

Jumpkey() {
	self endon("disconnect");
    level endon("game_ended");
	while(true) {
		self waittill ("+jump"); // waits for jump/space button pressed
		self.keyjump = 1;
		self waittill ("-jump"); // waits for jump/space button unpressed
		self.keyjump = 0;
	}
}

Crouchkey() {
	self endon("disconnect");
    level endon("game_ended");
    self.keycrouch = 0;
	while(true)
	{
		if(self GetStance() == "crouch" && self.keycrouch == 0)	// checks your current stance, if its crouch
			self.keycrouch = 1;
		if(self GetStance() != "crouch" && self.keycrouch == 1) // checks your current stance, if its not crouch
			self.keycrouch = 0;
		wait 0.10;
	}
}

hudposition() {
	self endon("disconnect");
    level endon("game_ended");
	
	//explain = self createFontString( "FONT", SIZE );
	//explain setPoint( "point", "relativePoint", xOffset, yOffset )
	//explain setshader( "SHADER", WIDTH, HEIGHT );
	//explain settext( "TEXT" );
	
	self.keypressW = self createFontString( "hudbig", 1.2);
	self.keypressW setPoint( "TOP", "TOP", -330, 400 );
	self.keypressW setshader("hud_killstreak_highlight", 35, 35);
	
	self.keypressA = self createFontString( "hudbig", 1.2);
	self.keypressA setPoint( "TOP", "TOP", -360, 430 );
	self.keypressA setshader("hud_killstreak_highlight", 35, 35);
	
	self.keypressS = self createFontString( "hudbig", 1.2);
	self.keypressS setPoint( "TOP", "TOP", -330, 430 );
	self.keypressS setshader("hud_killstreak_highlight", 35, 35);
	
	self.keypressD = self createFontString( "hudbig", 1.2);
	self.keypressD setPoint( "TOP", "TOP", -300, 430 );
	self.keypressD setshader("hud_killstreak_highlight", 35, 35);
	
	self.keypressSpace = self createFontString( "hudbig", 1.2);
	self.keypressSpace setPoint( "TOP", "TOP", -235, 430 );
	self.keypressSpace setshader("hud_killstreak_highlight", 80, 35);
	
	self.keypressCrouch = self createFontString( "hudbig", 1.2);
	self.keypressCrouch setPoint( "TOP", "TOP", -250, 400 );
	self.keypressCrouch setshader("hud_killstreak_highlight", 35, 35);
	
	self.KeyIconW = self createFontString( "default", 1.4);
	self.KeyIconW setPoint( "TOP", "TOP", -330, 409 );
	self.KeyIconW settext("W");
	
	self.KeyIconA = self createFontString( "default", 1.4);
	self.KeyIconA setPoint( "TOP", "TOP", -360, 440 );
	self.KeyIconA settext("A");
	
	self.KeyIconS = self createFontString( "default", 1.4);
	self.KeyIconS setPoint( "TOP", "TOP", -330, 440 );
	self.KeyIconS settext("S");
	
	self.KeyIconD = self createFontString( "default", 1.4);
	self.KeyIconD setPoint( "TOP", "TOP", -300, 440 );
	self.KeyIconD settext("D");
	
	self.KeyIconSpace = self createFontString( "default", 1.4);
	self.KeyIconSpace setPoint( "TOP", "TOP", -235, 440 );
	self.KeyIconSpace settext("Space");
	
	self.KeyIconC = self createFontString( "default", 1.4);
	self.KeyIconC setPoint( "TOP", "TOP", -250, 409 );
	self.KeyIconC settext("C");
	
	self.velmeter = self createFontString( "hudbig", 1);
	self.velmeter setPoint( "TOP", "TOP", 0, 440 );
}

Hud() {
	self endon("disconnect");
    level endon("game_ended");	
	self waittill("spawned_player"); // waits for player to have spawned to give time for huds to be set up
	
	inactivealpha = 0.2;
	
	self.keyw = 0;
	self.keya = 0;
	self.keys = 0;
	self.keyd = 0;
	self.keyjump = 0;
	self.keycrouch = 0;
	
	//this changes the color and alpha of the key press icons and text, .alpha changes opacity .color changes color

	while(true) {
		if(self.keyw == 0) {
			self.keypressW.alpha = inactivealpha;
			self.KeyIconW.alpha = inactivealpha;
			self.KeyIconW.color = (0,0,0);
		}
		else if(self.keyw == 1) {
			self.keypressW.alpha = 1;
			self.KeyIconW.alpha = 1;
			self.KeyIconW.color = self.choosencolor;
		}
		
		if(self.keya == 0) {
			self.keypressA.alpha = inactivealpha;
			self.KeyIconA.alpha = inactivealpha;
			self.KeyIconA.color = (0,0,0);
		}
		else if(self.keya == 1) {
			self.keypressA.alpha = 1;
			self.KeyIconA.alpha = 1;
			self.KeyIconA.color = self.choosencolor;
		}
		
		if(self.keys == 0) {
			self.keypressS.alpha = inactivealpha;
			self.KeyIconS.alpha = inactivealpha;
			self.KeyIconS.color = (0,0,0);
		}
		else if(self.keys == 1) {
			self.keypressS.alpha = 1;
			self.KeyIconS.alpha = 1;
			self.KeyIconS.color = self.choosencolor;
		}
		
		if(self.keyd == 0) {
			self.keypressD.alpha = inactivealpha;
			self.KeyIconD.alpha = inactivealpha;
			self.KeyIconD.color = (0,0,0);
		}
		else if(self.keyd == 1) {
			self.keypressD.alpha = 1;
			self.KeyIconD.alpha = 1;
			self.KeyIconD.color = self.choosencolor;
		}
		
		if(self.keyjump == 0) {
			self.keypressSpace.alpha = inactivealpha;
			self.KeyIconSpace.alpha = inactivealpha;
			self.KeyIconSpace.color = (0,0,0);
		}
		else if(self.keyjump == 1) {
			self.keypressSpace.alpha = 1;
			self.KeyIconSpace.alpha = 1;
			self.KeyIconSpace.color = self.choosencolor;
		}

		if(self.keycrouch == 0) {
			self.keypressCrouch.alpha = inactivealpha;
			self.KeyIconC.alpha = inactivealpha;
			self.KeyIconC.color = (0,0,0);
		}
		else if(self.keycrouch == 1) {
			self.keypressCrouch.alpha = 1;
			self.KeyIconC.alpha = 1;
			self.KeyIconC.color = self.choosencolor;
		}
		wait 0.05;
	}
}

Velocity() {
	self endon("disconnect");
	level endon("game_ended");	
	self.velmeter.label = &"^8";
	while(true) {
		self.newvel = self getvelocity(); // gets the players current velocity vectors
		self.newvel = sqrt(float(self.newvel[0] * self.newvel[0]) + float(self.newvel[1] * self.newvel[1])); // some math, boring. pretty much makes it all positive if i remember cause 1 axis goes into plus and minus
		self.vel = self.newvel;	
		self.velmeter setvalue(int(self.vel)); // sets the velocity hud's value to new velocity
		wait 0.05;
	}
}

save() {
	self endon("disconnect");
	
	i = 0;
	if(!isdefined(self.numsaves)) self.numsaves = 1;
	
	while(1) {
		if(self.sessionteam != "spectator") { // if person is not spectating
			if(self AttackButtonPressed() && self UseButtonPressed()) { // resets your saves, so u cant load, incase this is needed, hold left click and use (LMB + F) default
				self.curpos = undefined;
				self.curang = undefined;
				wait 1;
			}
			
			if(self meleeButtonPressed()) { // if melee button is pressed
				if(!self isMantling() && self isOnGround()) { // is not mantling and is on ground
					self iPrintLn("^8Saved Position ^5" + self.numsaves); // send msg to bottom left with the number of the save
					self.pos[self.numsaves] = self.origin; // saves players origin
					self.ang[self.numsaves] = self GetPlayerAngles(); // saves players angles

					self.curpos = self.pos[self.numsaves];
					self.curang = self.ang[self.numsaves];

					self.kills = self.numsaves; // sets the number of saves in scoreboard
					self.numsaves++; // increments the number of saves
					
					if(!self.hassaved)
						self.hassaved = true;
					
					while(self meleeButtonPressed()) // loops here while u hold down melee to stop continuous saving
						wait .05;
				}
			}
			else if(self useButtonPressed()) { // if use button pressed
				if(!self isMantling()) { // is not mantling
					if(isDefined(self.curpos)) { // if a load positon is defined
						self iPrintLn("^8Loaded Position ^5" + (self.numsaves - 1)); // send msg to bottom left with the number of the save
						self.assists++; // increments the amount of loads in scoreboard
						self setOrigin(self.curpos); // sets origin
						self setPlayerAngles(self.curang); // sets angles

						self freezeControls(true); // freezes player to stop momentum
						wait 0.1;
						self freezeControls(false); // unfreezes player again
					}
					
					if(!self.hasloaded)
						self.hasloaded = true;
					
					while(self useButtonPressed()) // loops here while u hold down use to stop continuous saving
						wait .05;
				}
			}

			// to load to previous saves
			if(self FragButtonPressed() && isdefined(self.curpos)) // hold grenade button
			{
				i = self.numsaves;
				while(self FragButtonPressed()) // while grenade button is held down
				{
					if(self UseButtonPressed()) // if pressing f/use
					{
						i++; // number goes up to next save
						if(i > self.pos.size) // if number higher then total saves
						i = 1; // number goes to 0
						self Iprintln("Loaded Position ^2" + i); // same save logic pretty much 
						self.curpos = self.pos[i];
						self.curang = self.ang[i];
						self setOrigin(self.curpos);
						self setPlayerAngles(self.curang);
						self freezeControls(true);
						wait 0.1;
						self freezeControls(false);
						while(self useButtonPressed())
						waitframe();
					}
					else if(self AttackButtonPressed()) // if pressing attack/lmb
					{
						i--; // number down to go to previous save
						if(i < 1) // if 0
						i = self.pos.size; // 0 goes back to latest number of save
						self Iprintln("Loaded Position ^2" + i); // same load logic pretty much
						self.curpos = self.pos[i];
						self.curang = self.ang[i];
						self setOrigin(self.curpos);
						self setPlayerAngles(self.curang);
						self freezeControls(true);
						wait 0.1;
						self freezeControls(false);
						while(self AttackButtonPressed())
						waitframe();
					}
					waitframe();
				}	
			}
		}
		wait .05;
	}
}

Marker() {
	self endon("disconnect");
	level endon("game_ended");

	self.marker = []; // sets up marker array
	self.markernum=0; // sets up the number of markers

	self thread MarkerDestroy(); // to destroy the markers on death game end and disconnect
	
	self waittill("marker"); // waits for marker button to be pressed // This is only for the first time u press it
	self.marker[self.markernum] = spawnFX( level.markerfx, self.origin ); // spawns the marker, at your origin with the flare fx
	TriggerFX(self.marker[self.markernum]); // triggers the fx so it plays
	self.marker[self.markernum] Hide(); // hides the marker from everyone
	self.marker[self.markernum] ShowToPlayer(self); // shows the marker to only yourself
	waitframe();
	self.markernum++; // increments the number of markers

	for(;;) {
		self waittill("marker"); // waits for marker button again
		self.marker[self.markernum-1] delete(); // deletes previous marker
		waitframe();
		self.marker[self.markernum] = spawnFX( level.markerfx, self.origin ); // spawns new marker
		TriggerFX(self.marker[self.markernum]); // triggers it again
		self.marker[self.markernum] Hide(); // hides again
		self.marker[self.markernum] ShowToPlayer(self); // shows again
		self.markernum++; // increments numbers of markers
	}
}

MarkerDestroy() {
	self waittill_any("disconnect", "game_ended", "death"); // waits for you to disconnect, end game, or die, and will delete the last marker
	if(isdefined(self.marker[self.markernum-1])) self.marker[self.markernum-1] delete();
}














