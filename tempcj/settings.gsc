#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

init()
{
	level thread movementMechanic();
}

movementMechanic() 
{
    setDvar("g_speed", 220); // change this value to adjust the speed
	setDvar("g_playercollision", 2); // this changes player Collision: 0 - Everyone, 1 - Enemies, 2 - Nobody
	setDvar("g_playerejection", 2); // this changes player ejection: 0 - Everyone, 1 - Enemies, 2 - Nobody
    //setDvar("jump_stepSize", 256); // stepsize ( the thing that teleports u up if u dont make a strafe)
    setDvar("jump_disableFallDamage", 1); // disables falldamage
    //setDvar("jump_slowdownEnable", 0); // stops jump slowdown ( if u keep on jumping in place u dont get slowed down or lower jump)
    //setDvar("jump_autoBunnyHop", 1); // hold space to bunnyhop
	setDvar("player_sustainammo", 1); // infinite ammo
	setDvar("sv_cheats", 1); // cheats
	//setDvar("jump_ladderpushvel", 1024); // ladder pushvelocity for when u jump off a ladder
	setDvar("jump_height", 45); // changes the jump height 
	setDvar("scr_war_timelimit", 0); // infinite time on tdm
	setDvar("scr_dm_timelimit", 0); // infinite time on ffa
	setDvar("sv_enableDoubleTaps", 1);
}
