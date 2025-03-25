#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;

init() {
    replacefunc(maps\mp\killstreaks\_autosentry::updateSentryPlacement, ::updateSentryPlacementReplace);
    replacefunc(maps\mp\killstreaks\_ims::updateImsPlacement, ::updateImsPlacementReplace);
	replacefunc(maps\mp\gametypes\_healthoverlay::playerPainBreathingSound, ::playerPainBreathingSound_replace);
}

updateSentryPlacementReplace( sentryGun ) {
	self endon ( "death" );
	self endon ( "disconnect" );
	level endon ( "game_ended" );

	sentryGun endon ( "placed" );
	sentryGun endon ( "death" );

	sentryGun.canBePlaced = 1;
	lastCanPlaceSentry = -1;

	for(;;) {
        placement = self canPlayerPlaceSentry();

        forang = anglestoforward(self getplayerangles());
        position = self.origin + forang * 55;
        trace = bullettrace(position + (0,0,50), position - (0,0,30), 0, self);
        traceer = bullettracepassed(self.origin + (0,0,40), position + (0,0,40), 0, self);

		sentryGun.origin = placement[ "origin" ];
		sentryGun.angles = placement[ "angles" ];
		sentryGun.canBePlaced = self isOnGround()  && ( abs(sentryGun.origin[2]-self.origin[2]) < 10 ) && placement[ "result" ] && traceer || trace["fraction"] < 1 && traceer;

		if(sentryGun.canBePlaced != lastCanPlaceSentry) {
			if (sentryGun.canBePlaced) {
				sentryGun setModel( level.sentrySettings[ sentryGun.sentryType ].modelPlacement);
				self ForceUseHintOn( &"SENTRY_PLACE" );
			}
			else {
				sentryGun setModel(level.sentrySettings[ sentryGun.sentryType ].modelPlacementFailed);
				self ForceUseHintOn( &"SENTRY_CANNOT_PLACE" );
			}
		}

		lastCanPlaceSentry = sentryGun.canBePlaced;
		wait .05;
	}
}

updateIMSPlacementReplace( ims ) {
	self endon ( "death" );
	self endon ( "disconnect" );
	level endon ( "game_ended" );

	ims endon ( "placed" );
	ims endon ( "death" );

	ims.canBePlaced = 1;
	lastCanPlaceIMS = -1; // force initial update

	for(;;) {
		placement = self canPlayerPlaceSentry();

        forang = anglestoforward(self getplayerangles());
        position = self.origin + forang * 55;
        trace = bullettrace(position + (0,0,50), position - (0,0,30), 0, self);
        traceer = bullettracepassed(self.origin + (0,0,40), position + (0,0,40), 0, self);

		ims.origin = placement[ "origin" ];
		ims.angles = placement[ "angles" ];
		ims.canBePlaced = self isOnGround() && placement[ "result" ] && ( abs(ims.origin[2]-self.origin[2]) < 10 ) && placement[ "result" ] && traceer || trace["fraction"] < 1 && traceer;

		if ( ims.canBePlaced != lastCanPlaceIMS )
		{
			if ( ims.canBePlaced )
			{
				ims setModel( level.imsSettings[ ims.imsType ].modelPlacement );
				self ForceUseHintOn( level.imsSettings[ ims.imsType ].placeString );
			}
			else
			{
				ims setModel( level.imsSettings[ ims.imsType ].modelPlacementFailed );
				self ForceUseHintOn( level.imsSettings[ ims.imsType ].cannotPlaceString );
			}
		}

		lastCanPlaceIMS = ims.canBePlaced;

        wait .05;
	}
}

playerPainBreathingSound_replace( useless )
{
	level endon ( "game_ended" );
	self endon ( "death" );
	self endon ( "disconnect" );
	self endon ( "joined_team" );
	self endon ( "joined_spectators" );
	
	wait ( 2 );

	for (;;)
	{
		wait ( 0.2 );
		
		if ( self.health <= 0 )
			return;
			
		// Player still has a lot of health so no breathing sound
		if ( self.health >= self.maxhealth * 0.55 )
			continue;
		
		if ( level.healthRegenDisabled && gettime() > self.breathingStopTime )
			continue;
			
		if( self isUsingRemote() )
			continue;

		self playLocalSound( "breathing_hurt" );

		wait ( .784 );
		wait ( 0.1 + randomfloat (0.8) );
	}
}