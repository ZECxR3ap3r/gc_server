#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;

main() {
	replacefunc(maps\mp\gametypes\_menus::init, ::_menus_init);
	replacefunc(maps\mp\gametypes\_hud_message::init, ::_hud_message_init);
	replacefunc(maps\mp\killstreaks\_remotemortar::remoteTargeting, ::remoteTargeting_fuckyou); // add to actual tpjugg
}

init() {
	

}

_menus_init()
{
	
}

_hud_message_init()
{
	precacheString( &"MP_FIRSTPLACE_NAME" );
	precacheString( &"MP_SECONDPLACE_NAME" );
	precacheString( &"MP_THIRDPLACE_NAME" );
	precacheString( &"MP_MATCH_BONUS_IS" );

	// precacheMenu( "splash" );
	// precacheMenu( "challenge" );
	// precacheMenu( "defcon" );
	// precacheMenu( "killstreak" );

	// precacheMenu( "perk_display" );
	// precacheMenu( "perk_hide" );

	// precacheMenu( "killedby_card_display" );
	// precacheMenu( "killedby_card_hide" );
	// precacheMenu( "youkilled_card_display" );

	// precacheMenu("endgameupdate");

	game["strings"]["draw"] = &"MP_DRAW";
	game["strings"]["round_draw"] = &"MP_ROUND_DRAW";
	game["strings"]["round_win"] = &"MP_ROUND_WIN";
	game["strings"]["round_loss"] = &"MP_ROUND_LOSS";
	game["strings"]["victory"] = &"MP_VICTORY";
	game["strings"]["defeat"] = &"MP_DEFEAT";
	game["strings"]["halftime"] = &"MP_HALFTIME";
	game["strings"]["overtime"] = &"MP_OVERTIME";
	game["strings"]["roundend"] = &"MP_ROUNDEND";
	game["strings"]["intermission"] = &"MP_INTERMISSION";
	game["strings"]["side_switch"] = &"MP_SWITCHING_SIDES";
	game["strings"]["match_bonus"] = &"MP_MATCH_BONUS_IS";
}

remoteTargeting_fuckyou( remote )
{	
	level  endon( "game_ended" );
	self   endon( "disconnect" );
	remote endon( "remote_done" );
	remote endon( "death" );	

	remote.targetEnt = SpawnFx( level.remote_mortar_fx["laserTarget"], (0,0,0) );	
	
	while ( true )
	{
	 	origin = self GetEye();
		forward = AnglesToForward( self GetPlayerAngles() );
		endpoint = origin + forward * 15000;
		if(isdefined(level.overwrite_reapertrace))
			traceData = PhysicsTrace(origin, endpoint, undefined,undefined, remote.targetEnt);
		else
			traceData = BulletTrace( origin, endpoint, false, remote.targetEnt );
		
		if(isdefined(level.overwrite_reapertrace)) {
			remote.targetEnt.origin = traceData;
			triggerFX( remote.targetEnt );
			wait( 0.15 );
		}
		else if ( isDefined( traceData["position"] ) )
		{
			remote.targetEnt.origin = traceData["position"];
			triggerFX( remote.targetEnt );
			wait( 0.05 );
		}
		else
			wait( 0.05 );
	}
}