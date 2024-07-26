#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;

init()
{
    level thread onPlayerConnect();
    level.jump_zones = [];
    level thread Jumps();
}

onPlayerConnect()
{
    for(;;)
    {
        level waittill("connected", player);
        player notifyOnPlayerCommand("jump_action", "+activate");
		player notifyOnPlayerCommand("jump_action_controller", "+usereload");
        player thread jumpPlayer();
    }
}

getMyCoordenates()
{
	self endon("disconnect");
	level endon("game_ended");
	while (true)
	{
		iprintln(self getOrigin());
		wait 5;
	}
}

Jumps()
{
	
	level endon ("game_ended");
	switch(getDvar("mapname")) 
	{
	    case "mp_alpha":
			iprintln(getDvar("mapname"));
			createJumpZone((-1382.54, 1770.72,158.749), (0, 0, 1135)); 	
		break;
		case "mp_paris":
			iprintln(getDvar("mapname"));
				
		break;
		case "mp_boneyard":
            iprintln(getDvar("mapname"));
            createJumpZone((-1526, 743, -127), (0, 0, 650));	
			
			break;
			
		case "mp_terminal_cls":
			iprintln(getDvar("mapname"));
		break;
		
		case "mp_underground":
			iprintln(getDvar("mapname"));
			createJumpZone((-871.472, -116.243, 0.125001), (0, 0, 550)); 
		break;
		
		case "mp_hardhat":
			iprintln(getDvar("mapname"));

		break;
			
		case "mp_dome":
			iprintln(getDvar("mapname"));
			createJumpZone((260.855, -13.1901, -390.375), (0, 0, 600));
		break;
		
		case "mp_highrise":
            iprintln(getDvar("mapname"));
            createJumpZone((-265, 5690, 2915), (100, 150, 600));
		break;
			
		case "mp_geometric":
            iprintln(getDvar("mapname"));
            createJumpZone((1645, -617, 32), (0, 0, 800));
			createJumpZone((-617, 1636, 32), (0, 0, 800));
			createJumpZone((1322, 1352, 192), (150, 150, 600));
			createJumpZone((-316, -334, 192), (-150, -150, 600));
		break;
		
		case "mp_abandon":
            iprintln(getDvar("mapname"));
            createJumpZone((-607, 193, -62), (0, 0, 600));	
		break;
		
		case "mp_favela":
            iprintln(getDvar("mapname"));
            createJumpZone((430, 1097, 300), (0, 0, 500));	
			
			break;
		default:
			iprintln(getDvar("Ninguna opcion"));
			break;		
	}
}

createJumpZone(position, impulse)
{	
	zone = spawn("script_model", position);
    zone setModel("weapon_c4_bombsquad");
    zone setCursorHint("HINT_NOICON");
	zone setHintString("Press ^1[{+activate}] ^7for jump");    		
	zone makeUsable();
	zone.impulse = impulse;
	
	level.jump_zones[level.jump_zones.size] = zone;
	
	return zone;		
}

jumpPlayer()
{
	self endon("disconnect");
	level endon("game_ended");
	
	while(true)
	{
		self waittill_any("jump_action", "jump_action_controller");
		
			for(j=0; j < level.jump_zones.size; j++)
			{
				 if(distance(self getOrigin(),level.jump_zones[j] getOrigin()) < 175 && self isOnGround() ==1)
					{
						self setVelocity(level.jump_zones[j].impulse);
						
					}
			}
	}	
}