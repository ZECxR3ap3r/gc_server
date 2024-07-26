#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;

init()
{
    level thread onPlayerConnect();
}

onPlayerConnect()
{
    for(;;)
    {
    level waittill("connected", player);
    player notifyOnPlayerCommand("suicide_action", "+actionslot 6");
    player thread suicidePlayer();
    }
}

suicidePlayer()
{
	self endon("disconnect");
	level endon("game_ended");
	while(true)
    {
        self waittill("suicide_action");
        self suicide();
    }
}

