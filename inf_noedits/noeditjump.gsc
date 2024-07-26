#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;

init() {
    level thread onPlayerConnect();
    level.jump_zones = [];
    level thread Jumps();
}

onPlayerConnect() {
    for(;;) {
        level waittill("connected", player);
        player notifyOnPlayerCommand("jump_action", "+activate");
		player notifyOnPlayerCommand("jump_action_controller", "+usereload");
        player thread jumpPlayer();
    }
}

getMyCoordenates() {
	self endon("disconnect");
	level endon("game_ended");
	while (true) {
		iprintln(self getOrigin());
		wait 5;
	}
}

Jumps() {
	level endon ("game_ended");
	switch(getDvar("mapname"))  {	
		case "mp_boneyard":
            iprintln(getDvar("mapname"));
            createJumpZone((-1526, 743, -127), (0, 0, 650));	
			
			break;
		default:
			iprintln(getDvar("Ninguna opcion"));
			break;		
	}
}

createJumpZone(position, impulse) {	
	zone = spawn("script_model", position);
    zone setModel("weapon_c4_bombsquad");
	thread createText(position, "Press ^1[{+activate}] ^7for Jump", 90, 90);
	zone makeUsable();
	zone.impulse = impulse;
	
	level.jump_zones[level.jump_zones.size] = zone;
	
	return zone;		
}

createText(position, text, range, height)
{
    triggernumber = level.MSGNUMBER;
    level.MSGNUMBER++;
    trigger = Spawn( "trigger_radius", position, 0, range, height );
    for(;;) 
    {
        trigger waittill( "trigger", player );

        if(player.team == "allies")
        {
                player setLowerMessage("msg", text);
                player thread deleteLowerMsg(trigger, range);
        }
        
        else if(player.team == "axis")
        {
               player setLowerMessage("msg", text);
               player thread deleteLowerMsg(trigger, range);
        }
        
    }
}

deleteLowerMsg(trigger, range)
{
    self notify("Deletemsg");
    self endon("Deletemsg");
    near = true;
    while(near)
    {
        wait .5;

        if(Distance(self.origin,trigger.origin) > range)
        {
            //iprintln("test");
            self clearLowerMessage("msg");
            near = false;
        }
    }
}


jumpPlayer() {
	self endon("disconnect");
	level endon("game_ended");
	
	while(true) {
		self waittill_any("jump_action", "jump_action_controller");
		
		for(j=0; j < level.jump_zones.size; j++) {
			if(distance(self getOrigin(),level.jump_zones[j] getOrigin()) < 175 && self isOnGround() ==1) {
				self.usingjumppad = 1;
				self setVelocity(level.jump_zones[j].impulse);
				wait .5;
				self.usingjumppad = undefined;
			}
		}
	}	
}



















