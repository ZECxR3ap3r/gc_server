#include maps\mp\_load;

init() {
	setdvar("g_scorescolor_allies", ".122 .753 .945 1");
	setdvar("g_scorescolor_axis", "1 .25 .25 1");
	setdvar("g_teamname_allies", "^5Survivors");
	setdvar("g_teamname_axis", "^1Infected");
	setdvar("g_teamicon_allies", "iw5_cardicon_juggernaut_c");
	setdvar("g_teamicon_axis", "iw5_cardicon_juggernaut_a");
	
	level thread on_connect();
	
	wait 5;
}

on_connect() {
	while(1) {
		level waittill("connected", player);
		
		player SetClientDvar("lowAmmoWarningColor1", "0 0 0 0");
		player SetClientDvar("lowAmmoWarningColor2", "0 0 0 0");
		player SetClientDvar("lowAmmoWarningNoAmmoColor1", "0 0 0 0");
		player SetClientDvar("lowAmmoWarningNoAmmoColor2", "0 0 0 0");
		player SetClientDvar("lowAmmoWarningNoReloadColor1", "0 0 0 0");
		player SetClientDvar("lowAmmoWarningNoReloadColor2", "0 0 0 0");
		
		if(!isdefined(player.afkwatcherenabled)) {
	    		player.afkwatcherenabled = 1;
        		player thread AFKWatcher();
		}
        }
}

AFKWatcher() {
	self endon("disconnect");
	level endon ("game_ended");
	
	self waittill("spawned_player");
	
	wait 3;
	arg = 0;
	
    while(1) {
    	if(isdefined(self.isInitialInfected) && isAlive( self )) {
    		org = self.origin;
    		angle = self getplayerangles();
    		wait 1;
    		if(isAlive(self)) {
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
		
			if(isdefined(arg) && arg >= 120)
				kick(self getEntityNumber(), "EXE_PLAYERKICKED_INACTIVE");
		}
		else
			wait 1;
    }
}

