#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

main() {
	replacefunc(maps\mp\perks\_perkfunctions::setTacticalInsertion, ::setTacticalInsertionn);
	replacefunc(maps\mp\perks\_perkfunctions::GlowStickDamageListener, ::GlowStickDamageListener_new);
	replacefunc(maps\mp\perks\_perkfunctions::monitorTIUse, ::monitorTIUseNew);
}

init() {
	precacheitem("lightstick_mp");
}

setTacticalInsertionn() {
	self SetOffhandSecondaryClass( "flash" );
	self _giveWeapon( "lightstick_mp", 0 );
	self giveStartAmmo( "lightstick_mp" );
	
	self thread monitorTIUseNew();
}

monitorTIUseNew() {
	self endon ( "death" );
	self endon ( "disconnect" );
	level endon ( "game_ended" );
	self endon ( "end_monitorTIUse" );

	self thread maps\mp\perks\_perkfunctions::updateTISpawnPosition();
	self thread maps\mp\perks\_perkfunctions::clearPreviousTISpawnpoint();
	
	for ( ;; ) {
		self waittill( "grenade_fire", lightstick, weapName );
				
		if ( weapName != "lightstick_mp" )
			continue;
		
		if ( isDefined( self.setSpawnPoint ) )
			self maps\mp\perks\_perkfunctions::deleteTI( self.setSpawnPoint );

		if ( !isDefined( self.TISpawnPosition ) )
			continue;

		if ( self touchingBadTrigger() )
			continue;

		TIGroundPosition = playerPhysicsTrace( self.TISpawnPosition + (0,0,16), self.TISpawnPosition - (0,0,2048) ) + (0,0,1);
		
		glowStick = spawn( "script_model", TIGroundPosition );
		glowStick.angles = self.angles;
		glowStick.team = self.team;
		glowStick.enemyTrigger =  spawn( "script_origin", TIGroundPosition );
		glowStick thread maps\mp\perks\_perkfunctions::GlowStickSetupAndWaitForDeath( self );
		glowStick.playerSpawnPos = self.TISpawnPosition;
		
		self.setSpawnPoint = glowStick;		
		return;
	}
}

GlowStickDamageListener_new( owner ) {
    self endon( "death" );
    self setcandamage( 1 );
    self.health = 999999;
    self.maxHealth = 100;
    self.damagetaken = 0;

    for (;;) {
        self waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName, partName, iDFlags, weapon );

        if(isdefined(attacker) && attacker.team != self.team ) {
        	if ( isdefined( weapon ) ) {
           	 	switch ( weapon ) {
                	case "concussion_grenade_mp":
                	case "smoke_grenade_mp":
                	case "flash_grenade_mp":
                    	continue;
            	}
            	if(weapon == "frag_grenade_mp") {
            		if(isdefined(attacker) && attacker.team == owner.team) {
            			return;
            		}
            	}
        	}
        	if ( !isdefined( self ) )
          	  	return;

        	if ( type == "MOD_MELEE" )
            	self.damagetaken = self.damagetaken + self.maxHealth;

        	if ( isdefined( iDFlags ) && iDFlags & level.iDFLAGS_PENETRATION )
            	self.wasDamagedFromBulletPenetration = 1;

        	self.wasDamaged = 1;
        	self.damagetaken = self.damagetaken + damage;

        	if ( isplayer( attacker ) )
            	attacker maps\mp\gametypes\_damagefeedback::updateDamageFeedback( "tactical_insertion" );

        	if ( self.damagetaken >= self.maxHealth ) {
            	if ( isdefined( owner ) && attacker != owner ) {
                	attacker notify( "destroyed_insertion", owner );
                	attacker notify( "destroyed_explosive" );
                	owner thread maps\mp\_utility::leaderDialogOnPlayer( "ti_destroyed" );
            	}
            	attacker thread maps\mp\perks\_perkfunctions::deleteTI( self );
            }
        }
    }
}
