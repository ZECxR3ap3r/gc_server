#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

init()
{
	level thread on_connect();

    if(getDvar("mapname") == "mp_rust"){ /** rust **/
		level thread Rust();
	}
    else if(getDvar("mapname") == "mp_courtyard_ss"){ /** Erosion **/
		level thread Erosion();
	}
	else if(getDvar("mapname") == "mp_alpha"){ /** Lockdown **/
		level thread Lockdown();
	}
	else if(getDvar("mapname") == "mp_underpass"){ /** Underpass **/
		level thread Underpass();
	}
	else if(getDvar("mapname") == "mp_lambeth"){ /** fallen **/
		level thread Fallen();
	}
    else if(getDvar("mapname") == "mp_aground_ss"){ /** Aground **/
		level thread Aground();
	}
    else if(getDvar("mapname") == "mp_paris"){ /** Resistance **/
		level thread Resistance();
	}
    else if(getDvar("mapname") == "mp_bravo"){ /** Mission **/
		level thread Mission();
	}
    else if(getDvar("mapname") == "mp_nightshift"){ /** Skidrow **/
		level thread Skidrow();
	}
    else if(getDvar("mapname") == "mp_terminal_cls"){ /** Terminal **/
		level thread Terminal();
	}
    else if(getDvar("mapname") == "mp_highrise"){ /** Highrise **/
		level thread Highrise();
	}
	else if(getDvar("mapname") == "mp_rats"){ /** Rats **/
		level thread Rats();
	}
	else if(getDvar("mapname") == "mp_quarry"){ /** Quarry **/
		level thread Quarry();
	}
	else if(getDvar("mapname") == "mp_exchange"){ /** Downturn **/
		level thread Downturn();
	}
	else if(getDvar("mapname") == "mp_dome"){ /** Dome **/
		level thread Dome();
	}
	else if(getDvar("mapname") == "mp_plaza2"){ /** Arkaden **/
		level thread Arkaden();
	}
	else if(getDvar("mapname") == "mp_abandon"){ /** Carnival **/
		level thread Carnival();
	}
	else if(getDvar("mapname") == "mp_bootleg"){ /** Bootleg **/
		level thread Bootleg();
	}
	else if(getDvar("mapname") == "mp_qadeem"){ /** Oasis **/
		level thread Oasis();
	}
	else if(getDvar("mapname") == "mp_favela"){ /** Favela **/
		level thread Favela();
	}
	else if(getDvar("mapname") == "mp_fav_tropical"){ /** FavelaTropical **/
		level thread FavelaTropical();
	}
}

Rust()
{
	thread createText((1312, 55, -175), "^1 If you're reading this you are not alone!\nbut get rekt!", 10, 10);

}
Lockdown()
{
	thread createText((-1471, 2858, 171), "^3McBigMac, T i e r & {*__*} Aaron", 10, 10);
}

Erosion()
{

}

Fallen()
{
	thread createText((-329, 1474, -243), "^1Lil Sticks hiding spot :3", 1, 10);
	thread createText((128, 39, -176), "Translation: ^1Revox bad owner", 1, 10);
}
Underpass()
{
	thread createText((887, 2608, 430), "^5Legend has it - if you shoot all four corners \nof the door a babushka will appear", 1, 10);
	thread createText((2065, -1569, 443), "^1What is this? 2009?", 1, 10);
	thread createText((-401, 2209, 87), "^2You're not Mario, get the fuck out of the pipe!", 10, 10);
}
Aground()
{

}

Resistance()
{

	thread createText((-108, 165, 103), "^1What are you doing, step bro?", 1, 10);
}

Mission()
{

}

Skidrow()
{


}

Terminal()
{

}

Highrise()
{

}

Rats()
{


}

Quarry()
{


}

Downturn()
{

	thread createText((720, -1783, 52), "^3PRETZEL", 1, 1);
	thread createText((1712, -453, 71), "^1ITS DAX!!!", 1, 1);

}

Carnival()
{



}

Dome()
{



}

Arkaden()
{

	thread createText((379, -663, 887), "^5HELICOPTER! HELICOPTER!", 25, 0);

}

Bootleg()
{
	thread createText((-1357, -1027, 62), "^2Lil Sticks ^3chicken coop", 1, 10);

}

Oasis()
{

}

Favela()
{


}

FavelaTropical()
{

}

on_connect() {
	while(1) {
		level waittill("connected", player);

		player thread trigger_watcher();
		player.touching_trigger = player;
	}
}

trigger_watcher() {
	self endon("disconnect");

	while(1) {
		if(isalive(self)) {
			if(isdefined(level.total_triggers)) {
				for(i = 0;i < level.total_triggers.size;i++) {
					if(isdefined(level.total_triggers[i])) {
						if(self istouching(level.total_triggers[i]) && self.touching_trigger != level.total_triggers[i]) {
							self setlowermessage("msg", level.total_triggers[i].text);
							self.touching_trigger = level.total_triggers[i];
							self.lowermessage.hidewheninkillcam = false;
							self.lowermessage.archived = 1;
							self thread deleteLowerMsg(level.total_triggers[i], "msg");
						}
					}
				}
			}
		}

		wait .1;
	}
}

createText(position, text, range, height) {
    trigger = Spawn( "trigger_radius", position, 0, range, height);
	trigger.text = text;

	if(!isdefined(level.total_triggers))
		level.total_triggers = [];

	level.total_triggers[level.total_triggers.size] = trigger;
}

deleteLowerMsg(trigger, name) {
    self notify("Deletemsg");
    self endon("Deletemsg");
    self endon("disconnect");

    while(self istouching(trigger))
        wait .5;

    self clearLowerMessage(name);
    self.touching_trigger = self;
}