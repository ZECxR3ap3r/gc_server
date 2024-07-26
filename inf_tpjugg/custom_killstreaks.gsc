#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

KILLSTREAK_STRING_TABLE = "mp/killstreakTable.csv";
STREAKCOUNT_MAX_COUNT = 3;
KILLSTREAK_NAME_COLUMN = 1;
KILLSTREAK_KILLS_COLUMN = 4;
KILLSTREAK_EARNED_HINT_COLUMN = 6;
KILLSTREAK_SOUND_COLUMN = 7;
KILLSTREAK_EARN_DIALOG_COLUMN = 8;
KILLSTREAK_ENEMY_USE_DIALOG_COLUMN = 11;
KILLSTREAK_WEAPON_COLUMN = 12;
KILLSTREAK_ICON_COLUMN = 14;
KILLSTREAK_OVERHEAD_ICON_COLUMN = 15;
KILLSTREAK_DPAD_ICON_COLUMN = 16;

NUM_KILLS_GIVE_ALL_PERKS = 8;

KILLSTREAK_GIMME_SLOT = 0;
KILLSTREAK_SLOT_1 = 1;
KILLSTREAK_SLOT_2 = 2;
KILLSTREAK_SLOT_3 = 3;
KILLSTREAK_ALL_PERKS_SLOT = 4;
KILLSTREAK_STACKING_START_SLOT = 5;
main() {
    replacefunc(maps\mp\killstreaks\_killstreaks::getKillstreakInformEnemy, ::getKillstreakInformEnemy_replace);
    replacefunc(maps\mp\killstreaks\_killstreaks::getKillstreakSound, ::getKillstreakSound_replace);
    replacefunc(maps\mp\killstreaks\_killstreaks::getKillstreakWeapon, ::getKillstreakWeapon_replace);
    replacefunc(maps\mp\killstreaks\_killstreaks::getKillstreakCrateIcon, ::getKillstreakCrateIcon_replace);
    replacefunc(maps\mp\killstreaks\_killstreaks::getKillstreakIndex, ::getKillstreakIndex_replace);
    replacefunc(maps\mp\killstreaks\_killstreaks::givekillstreak, ::givekillstreak_replace);
    replacefunc(maps\mp\killstreaks\_killstreaks::initKillstreakData, ::initKillstreakData_replace);

}

init() {
    level.killStreakFuncs["strike_run"] = ::strike_run;
	level.killStreakFuncs["guardian"] = ::guardian;

	level.guardian_settings = spawnstruct();
	level.guardian_settings.basemodel =				"sentry_minigun_weak";
	level.guardian_settings.modelPlacement =		"sentry_minigun_weak_obj";
	level.guardian_settings.modelPlacementFailed = 	"sentry_minigun_weak_obj_red";
	level.guardian_settings.hintString =			&"SENTRY_PICKUP";

	// precacheModel( "vehicle_a10_warthog" );	
    // precacheitem("ac130_40mm_mp");
    // precacheModel( "vehicle_a10_warthog" );	
    // PreCacheShader( "compass_objpoint_a10_friendly" );
	// PreCacheShader( "compass_objpoint_a10_enemy" );
	// PrecacheMiniMapIcon( "compass_objpoint_a10_friendly" );
	// PrecacheMiniMapIcon( "compass_objpoint_a10_enemy" );

    replacefunc(maps\mp\killstreaks\_airstrike::tryUseAirstrike, ::tryUseAirstrike_replace);
    replacefunc(maps\mp\killstreaks\_airstrike::selectAirstrikeLocation, ::selectAirstrikeLocation_replace);
    replacefunc(maps\mp\killstreaks\_airstrike::doAirstrike, ::doAirstrike_replace);
    replacefunc(maps\mp\killstreaks\_harrier::harrierDestroyed, ::harrierDestroyed_replace);
    replacefunc(maps\mp\killstreaks\_harrier::backToDefendLocation, ::backToDefendLocation_replace);
    replacefunc(maps\mp\killstreaks\_harrier::harrierTimer, ::harrierTimer_replace);
	

	level.airstrike_planes = 0;
}
///////////////////////////////////// KillStreak Lookups ///////////////////////////
// 0  - 60,
// 1  - harrier_airstrike,
// 2  - KILLSTREAKS_PRECISION_AIRSTRIKE,
// 3  - KILLSTREAKS_PRECISION_AIRSTRIKE_DESC,
// 4  - 6,
// 5  - 6,
// 6  - MP_EARNED_PRECISION_AIRSTRIKE,
// 7  - mp_killstreak_jet,
// 8  - achieve_airstrike,
// 9  - airstrike,
// 10 - airstrike,
// 11 - 1,
// 12 - killstreak_precision_airstrike_mp,
// 13 - 200,
// 14 - dpad_killstreak_precision_airstrike_static,
// 15 - specialty_precision_airstrike_crate,
// 16 - dpad_killstreak_precision_airstrike,
// 17 - dpad_killstreak_precision_airstrike_inactive

getKillstreakInformEnemy_replace( streakName )
{
	if(streakName == "harrier_airstrike")
		return 1;
	return int( tableLookup( KILLSTREAK_STRING_TABLE, KILLSTREAK_NAME_COLUMN, streakName, KILLSTREAK_ENEMY_USE_DIALOG_COLUMN ) );
}


getKillstreakSound_replace( streakName )
{
	if(streakName == "harrier_airstrike")
		return "mp_killstreak_jet";
	return tableLookup( KILLSTREAK_STRING_TABLE, KILLSTREAK_NAME_COLUMN, streakName, KILLSTREAK_SOUND_COLUMN );
}

getKillstreakWeapon_replace( streakName )
{
	if(streakName == "harrier_airstrike")
		return "killstreak_precision_airstrike_mp";
	return tableLookup( KILLSTREAK_STRING_TABLE, KILLSTREAK_NAME_COLUMN, streakName, KILLSTREAK_WEAPON_COLUMN );
}

getKillstreakCrateIcon_replace( streakName )
{
	if(streakName == "harrier_airstrike")
		return "death_harrier";
	return tableLookup( KILLSTREAK_STRING_TABLE, KILLSTREAK_NAME_COLUMN, streakName, KILLSTREAK_OVERHEAD_ICON_COLUMN );
}

getKillstreakIndex_replace( streakName )
{
	if(streakName == "harrier_airstrike")
		return 7;
	return tableLookupRowNum( KILLSTREAK_STRING_TABLE, KILLSTREAK_NAME_COLUMN, streakName )-1;
}


givekillstreak_replace( var_0, var_1, var_2, var_3, var_4 )
{
    self endon( "givingLoadout" );

    if ( !isdefined( level.killstreakfuncs[var_0] ))
        return;

    if ( !isdefined( self.pers["killstreaks"] ) )
        return;

    self endon( "disconnect" );

    if ( !isdefined( var_4 ) )
        var_4 = 0;

    var_5 = undefined;

    if ( !isdefined( var_1 ) || var_1 == 0 )
    {
        var_6 = self.pers["killstreaks"].size;

        if ( !isdefined( self.pers["killstreaks"][var_6] ) )
            self.pers["killstreaks"][var_6] = spawnstruct();

        self.pers["killstreaks"][var_6].available = 0;
        self.pers["killstreaks"][var_6].streakname = var_0;
        self.pers["killstreaks"][var_6].earned = 0;
        self.pers["killstreaks"][var_6].awardxp = isdefined( var_2 ) && var_2;
        self.pers["killstreaks"][var_6].owner = var_3;
        self.pers["killstreaks"][var_6].kid = self.pers["kID"];
        self.pers["killstreaks"][var_6].lifeid = -1;
        self.pers["killstreaks"][var_6].isgimme = 1;
        self.pers["killstreaks"][var_6].isspecialist = 0;
        self.pers["killstreaks"][0].nextslot = var_6;
        self.pers["killstreaks"][0].streakname = var_0;
        var_5 = 0;
        var_7 = maps\mp\killstreaks\_killstreaks::getkillstreakindex( var_0 );
        self setplayerdata( "killstreaksState", "icons", 0, var_7 );

        if ( !var_4 )
            maps\mp\killstreaks\_killstreaks::showselectedstreakhint( var_0 );
    }
    else
    {
        for ( var_8 = 1; var_8 < 4; var_8++ )
        {
            if ( isdefined( self.pers["killstreaks"][var_8] ) && isdefined( self.pers["killstreaks"][var_8].streakname ) && var_0 == self.pers["killstreaks"][var_8].streakname )
            {
                var_5 = var_8;
                break;
            }
        }

        if ( !isdefined( var_5 ) )
            return;
    }

    self.pers["killstreaks"][var_5].available = 1;
    self.pers["killstreaks"][var_5].earned = isdefined( var_1 ) && var_1;
    self.pers["killstreaks"][var_5].awardxp = isdefined( var_2 ) && var_2;
    self.pers["killstreaks"][var_5].owner = var_3;
    self.pers["killstreaks"][var_5].kid = self.pers["kID"];
    self.pers["kID"]++;

    if ( !self.pers["killstreaks"][var_5].earned )
        self.pers["killstreaks"][var_5].lifeid = -1;
    else
        self.pers["killstreaks"][var_5].lifeid = self.pers["deaths"];

    if ( self.streaktype == "specialist" && var_5 != 0 )
    {
        self.pers["killstreaks"][var_5].isspecialist = 1;

        if ( isdefined( level.killstreakfuncs[var_0] ) )
            self [[ level.killstreakfuncs[var_0] ]]();

        maps\mp\killstreaks\_killstreaks::usedkillstreak( var_0, var_2 );
    }
    else if ( self maps\mp\killstreaks\_killstreaks::is_player_gamepad_enabled())
    {
        var_9 = maps\mp\killstreaks\_killstreaks::getkillstreakweapon( var_0 );
        maps\mp\killstreaks\_killstreaks::givekillstreakweapon( var_9 );

        if ( isdefined( self.killstreakindexweapon ) )
        {
            var_0 = self.pers["killstreaks"][self.killstreakindexweapon].streakname;
            var_10 = maps\mp\killstreaks\_killstreaks::getkillstreakweapon( var_0 );

            if ( !maps\mp\killstreaks\_killstreaks::iscurrentlyholdingkillstreakweapon( var_10 ) )
                self.killstreakindexweapon = var_5;
        }
        else
            self.killstreakindexweapon = var_5;
    }
    else
    {
        if ( 0 == var_5 && self.pers["killstreaks"][0].nextslot > 5 )
        {
            var_11 = self.pers["killstreaks"][0].nextslot - 1;
            var_12 = maps\mp\killstreaks\_killstreaks::getkillstreakweapon( self.pers["killstreaks"][var_11].streakname );
            self takeweapon( var_12 );
        }

        var_10 = maps\mp\killstreaks\_killstreaks::getkillstreakweapon( var_0 );
        maps\mp\_utility::_giveweapon( var_10, 0 );
        maps\mp\_utility::_setactionslot( var_5 + 4, "weapon", var_10 );
    }

    maps\mp\killstreaks\_killstreaks::updatestreakslots();

    if ( isdefined( level.killstreaksetupfuncs[var_0] ) )
        self [[ level.killstreaksetupfuncs[var_0] ]]();

    if ( isdefined( var_1 ) && var_1 && isdefined( var_2 ) && var_2 )
        self notify( "received_earned_killstreak" );
}

initKillstreakData_replace()
{
	game[ "dialog" ][ "harrier_airstrike" ] = "mp_killstreak_jet";

	game[ "dialog" ][ "allies_friendly_harrier_airstrike_inbound" ] = "use_achieve_airstrike";
	game[ "dialog" ][ "allies_enemy_harrier_airstrike_inbound" ] = "enemy_achieve_airstrike";
	game[ "dialog" ][ "axis_friendly_harrier_airstrike_inbound" ] = "use_achieve_airstrike";
	game[ "dialog" ][ "axis_enemy_harrier_airstrike_inbound" ] = "enemy_achieve_airstrike";

	precacheshader("death_harrier");

	for ( i = 1; true; i++ )
	{
		retVal = tableLookup( KILLSTREAK_STRING_TABLE, 0, i, 1 );
		if ( !IsDefined( retVal ) || retVal == "" )
			break;

		streakRef = tableLookup( KILLSTREAK_STRING_TABLE, 0, i, 1 );
		assert( streakRef != "" );

		streakUseHint = tableLookupIString( KILLSTREAK_STRING_TABLE, 0, i, 6 );
		assert( streakUseHint != &"" );
		PreCacheString( streakUseHint );

		streakEarnDialog = tableLookup( KILLSTREAK_STRING_TABLE, 0, i, 8 );
		assert( streakEarnDialog != "" );
		game[ "dialog" ][ streakRef ] = streakEarnDialog;

		streakAlliesUseDialog = tableLookup( KILLSTREAK_STRING_TABLE, 0, i, 9 );
		assert( streakAlliesUseDialog != "" );
		game[ "dialog" ][ "allies_friendly_" + streakRef + "_inbound" ] = "use_" + streakAlliesUseDialog;
		game[ "dialog" ][ "allies_enemy_" + streakRef + "_inbound" ] = "enemy_" + streakAlliesUseDialog;

		streakAxisUseDialog = tableLookup( KILLSTREAK_STRING_TABLE, 0, i, 10 );
		assert( streakAxisUseDialog != "" );
		game[ "dialog" ][ "axis_friendly_" + streakRef + "_inbound" ] = "use_" + streakAxisUseDialog;
		game[ "dialog" ][ "axis_enemy_" + streakRef + "_inbound" ] = "enemy_" + streakAxisUseDialog;

		streakWeapon = tableLookup( KILLSTREAK_STRING_TABLE, 0, i, 12 );
		precacheItem( streakWeapon );

		streakPoints = int( tableLookup( KILLSTREAK_STRING_TABLE, 0, i, 13 ) );
		assert( streakPoints != 0 );
		maps\mp\gametypes\_rank::registerScoreInfo( "killstreak_" + streakRef, streakPoints );

		streakShader = tableLookup( KILLSTREAK_STRING_TABLE, 0, i, 14 );
		precacheShader( streakShader );

		streakShader = tableLookup( KILLSTREAK_STRING_TABLE, 0, i, 15 );
		if ( streakShader != "" )
			precacheShader( streakShader );

		streakShader = tableLookup( KILLSTREAK_STRING_TABLE, 0, i, 16 );
		if ( streakShader != "" )
			precacheShader( streakShader );

		streakShader = tableLookup( KILLSTREAK_STRING_TABLE, 0, i, 17 );
		if ( streakShader != "" )
			precacheShader( streakShader );
	}
}
////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////// Harrier //////////////////////////////////////

tryUseAirstrike_replace( lifeId, streakName )
{
	if ( ! self validateUseStreak() )
		return false;
	
	if ( isDefined( level.civilianJetFlyBy ) )
	{
		self iPrintLnBold( &"MP_CIVILIAN_AIR_TRAFFIC" );
		return false;
	}

	if ( self isUsingRemote() )
	{
		return false;
	}

	switch( streakName )
	{
		case "precision_airstrike":
			break;
		case "stealth_airstrike":
			break;
		case "harrier_airstrike":
			if ( level.airstrike_planes > 1 )
			{
				self iPrintLnBold( &"MP_AIR_SPACE_TOO_CROWDED" );
				return false;	
			}
			break;
		case "super_airstrike":
			break;
	}
	
	result = self selectAirstrikeLocation_replace( lifeId, streakName );

	if ( !isDefined( result ) || !result )
		return false;
	
	return true;
}

selectAirstrikeLocation_replace( lifeId, streakname )
{
	targetSize = level.mapSize / 6.46875; // 138 in 720
	if ( level.splitscreen )
		targetSize *= 1.5;
	
	chooseDirection = false;
	switch( streakName )
	{
	case "precision_airstrike":
		chooseDirection = true;
		self PlayLocalSound( game[ "voice" ][ self.team ] + "KS_hqr_airstrike" );
		break;
	case "stealth_airstrike":
		chooseDirection = true;
		self PlayLocalSound( game[ "voice" ][ self.team ] + "KS_hqr_bomber" );
		break;
	}

	self _beginLocationSelection( streakname, "map_artillery_selector", chooseDirection, targetSize );

	self endon( "stop_location_selection" );
	
	// wait for the selection. randomize the yaw if we're not doing a precision airstrike.
	self waittill( "confirm_location", location, directionYaw );
	if ( !chooseDirection )
		directionYaw = randomint(360);

	self setblurforplayer( 0, 0.3 );

	if ( streakname == "harrier_airstrike" && level.airstrike_planes > 1 )
	{
		self notify ( "cancel_location" );
		self iPrintLnBold( &"MP_AIR_SPACE_TOO_CROWDED" );
		return false;	
	}

	self thread maps\mp\killstreaks\_airstrike::airstrikeMadeSelectionVO( streakName );
	
	self maps\mp\_matchdata::logKillstreakEvent( streakName, location );	
	
	self thread maps\mp\killstreaks\_airstrike::finishAirstrikeUsage( lifeId, location, directionYaw, streakName );
	return true;
}

doAirstrike_replace( lifeId, origin, yaw, owner, team, streakName )
{	
	assert( isDefined( origin ) );
	assert( isDefined( yaw ) );

	if ( streakName == "harrier_airstrike" )
		level.airstrike_planes++;
	
	if ( isDefined( level.airstrikeInProgress ) )
	{
		while ( isDefined( level.airstrikeInProgress ) )
			level waittill ( "begin_airstrike" );

		level.airstrikeInProgress = true;
		wait ( 2.0 );
	}

	if ( !isDefined( owner ) )
	{
		if ( streakName == "harrier_airstrike" )
			level.airstrike_planes--;
			
		return;
	}

	level.airstrikeInProgress = true;
	
	num = 17 + randomint(3);
	trace = bullettrace(origin, origin + (0,0,-1000000), false, undefined);
	targetpos = trace["position"];

	//if ( level.teambased )
	//{
	//	players = level.players;
	//	
	//	for ( i = 0; i < level.players.size; i++ )
	//	{
	//		player = level.players[i];
	//		playerteam = player.pers["team"];
	//		if ( isdefined( playerteam ) )
	//		{
	//			if ( playerteam == team && streakName != "stealth_airstrike" )
	//				player iprintln( &"MP_WAR_AIRSTRIKE_INBOUND", owner );
	//		}
	//	}
	//}
	//else
	//{
	//	if ( !level.hardcoreMode )
	//	{
	//		if ( pointIsInAirstrikeArea( owner.origin, targetpos, yaw, streakName ) )
	//			owner iprintlnbold(&"MP_WAR_AIRSTRIKE_INBOUND_NEAR_YOUR_POSITION");
	//	}
	//}
	
	dangerCenter = spawnstruct();
	dangerCenter.origin = targetpos;
	dangerCenter.forward = anglesToForward( (0,yaw,0) );
	dangerCenter.streakName = streakName;

	level.artilleryDangerCenters[ level.artilleryDangerCenters.size ] = dangerCenter;
	//level thread maps\mp\killstreaks\_killstreaks::debugArtilleryDangerCenters( streakName );
	
	harrierEnt = maps\mp\killstreaks\_airstrike::callStrike( lifeId, owner, targetpos, yaw, streakName );
	
	wait( 1.0 );
	level.airstrikeInProgress = undefined;
	owner notify ( "begin_airstrike" );
	level notify ( "begin_airstrike" );
	
	wait 7.5;

	found = false;
	newarray = [];
	for ( i = 0; i < level.artilleryDangerCenters.size; i++ )
	{
		if ( !found && level.artilleryDangerCenters[i].origin == targetpos )
		{
			found = true;
			continue;
		}
		
		newarray[ newarray.size ] = level.artilleryDangerCenters[i];
	}
	assert( found );
	assert( newarray.size == level.artilleryDangerCenters.size - 1 );
	level.artilleryDangerCenters = newarray;
	
	if ( streakName != "harrier_airstrike" )
		return;

	while ( isDefined( harrierEnt ) )
		wait ( 0.1 );
		
	level.airstrike_planes--;
}

harrierDestroyed_replace()
{
	self endon( "harrier_gone" );
	
	self waittill( "death" );
	
	if (! isDefined(self) )
		return;

	self scripts\inf_tpjugg\map_funcs::heli_crash_replace(true);
}

backToDefendLocation_replace( forced )
{
	self.defendloc = self.owner.origin + (randomintrange(-100, 100),randomintrange(-100, 100),2000);
	self setVehGoalPos( self.defendloc, 1 );
	
	if ( isDefined( forced ) && forced )
		self waittill ( "goal" );
}

harrierTimer_replace()
{
	self endon( "death" );
	level.harrier_time = 45;
	time = level.harrier_time * 20;
	while(time > 0 && self.owner.team == self.team) {
		wait 0.05;
		time--;
	}
	self maps\mp\killstreaks\_harrier::harrierLeave();
}


////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////// A10 //////////////////////////////////////////

strike_run() {
    self _giveWeapon("uav_strike_marker_mp");
	self switchToWeapon( "uav_strike_marker_mp" );

	traceData = undefined;
	for(;;)
	{
		self waittill( "weapon_fired", weapname );
		
		if(weapname != "uav_strike_marker_mp")
            continue;

	 	origin = self GetEye();
        angle = self GetPlayerAngles();
		forward = AnglesToForward( angle );
		endpoint = origin + forward * 15000;
		
		traceData = BulletTrace( origin, endpoint, true, self );		
		if ( isDefined(traceData["position"]) )
			break;
	}

	self notify( "uav_strike_used" );
		
	targetPosition = traceData["position"];		

	fxEnt = SpawnFx( level._effect[ "laserTarget" ], targetPosition);
	TriggerFx( fxEnt );
	fxEnt thread waitFxEntDie(4);

    a10 = spawnA10(self, targetPosition, angle);
    a10 thread start_moving();
	a10 thread wait_to_shoot();

	self takeWeapon( "uav_strike_marker_mp" );
	self switchToWeapon( self.last_weapon );
}

waitFxEntDie(time)
{
	wait( time );
	self delete();
}

start_moving() {
    max_speed = 3000;
    distance = 500;
    time_distance = distance/max_speed;
    iprintlnbold("^1"+time_distance);
    for(;;) {
        moveto_pos = self.origin + AnglesToForward(self.angles) * distance;
        self MoveTo(moveto_pos, time_distance);
        wait 0.05;
    }
}

wait_to_shoot(){

    while(Distance(self.origin, self.targetposition) > 9000)
        wait 0.05;

    self thread angle_to_endpos(1.2);
	shots = 0;
    while(Distance(self.origin, self.targetposition) <= 9000){
        pos = self GetTagOrigin("tag_gun");
        startpos = pos + AnglesToForward(self.angles) * 300;
		ang = self.angles + (randomintrange(-2,2),randomintrange(-2,2),0);
        endpos = pos + AnglesToForward(ang) * 1000;
        MagicBullet("ac130_40mm_mp", startpos, endpos, self.owner);
		shots++;
		print(shots);
		if(shots > 35)
			break;
        wait 0.1;
    }
}

angle_to_endpos(delay) {
		clamp_ending = self.ending_angle[0] * -1;
	print("^1"+self.ending_angle[0] * -1);
	print("^3"+self.ending_angle[0]);
    wait(delay);

    for(;;) {
        forward = anglestoforward(self.angles+(-1,0,0));
        check_pos = self.origin + forward * 800;
        self.angles = vectortoangles(check_pos - self.origin);
		clamp_self = AngleClamp180( self.angles[0]);
        wait 0.05;
        //print(clamp_self + " --- " + clamp_ending);
        if(clamp_self < clamp_ending)
            break;
    }
} 

spawnA10( owner, targetPosition, angle)
{
	// need to move the start point up so we get a dive bombing look
	start_pitch = 35;
	ending_pitch = 20;

	start_angle_fix = (start_pitch,angle[1], 0);
	ending_angle_fix = (ending_pitch,angle[1], 0);

	start_forward = AnglesToForward( start_angle_fix );
	ending_forward = AnglesToForward( ending_angle_fix );
	

    start_point = (targetPosition + start_forward * -17000);


	a10 = Spawn( "script_model", start_point );
	// TODO: figure out a better way to do this
	// spawning in a plane so the minimap icon is right
	//fakeA10 = spawnPlane( owner, "script_model", start_point, "cb_compass_objpoint_a10_friendly" , "cb_compass_objpoint_a10_enemy" );

	//fakeA10 LinkTo( a10 );
	//a10.fakeA10 = fakeA10;
    owner setorigin(start_point);

	a10 SetModel( "vehicle_a10_warthog" );
	a10.health = 999999; 
	a10.maxhealth = 2500;
	a10.damageTaken = 0;
	a10.owner = owner;
	a10.team = owner.team;
	a10.killCount = 0;
	a10.start_point = start_point;
	a10.targetposition = targetPosition;
    a10.ending_angle = ending_angle_fix;
	a10.angles = start_angle_fix;	

	//if ( level.teamBased )
	//{
	//	curObjID = maps\mp\gametypes\_gameobjects::getNextObjID();	
	//	Objective_Add( curObjID, "active", startPoint, "compass_objpoint_a10_friendly" );
	//	Objective_Team( curObjID, a10.team );
	//	Objective_OnEntity( curObjID, a10 );
	//	a10.objIdFriendly = curObjID;

	//	curObjID = maps\mp\gametypes\_gameobjects::getNextObjID();	
	//	Objective_Add( curObjID, "active", startPoint, "compass_objpoint_a10_enemy" );
	//	Objective_Team( curObjID, level.otherTeam[a10.team] );
	//	Objective_OnEntity( curObjID, a10 );
	//	a10.objIdEnemy = curObjID;
	//}

	//if ( !level.teamBased )
	//{
	//	curObjID = maps\mp\gametypes\_gameobjects::getNextObjID();	
	//	Objective_Add( curObjID, "active", startPoint, "compass_objpoint_a10_friendly" );
	//	Objective_OnEntity( curObjID, a10 );
	//	a10.objIdFriendly = curObjID;
	//}

	//a10.damageCallback = ::Callback_VehicleDamage;

	return a10;
}

///////////////////////////////////// A10 END //////////////////////////////////////////

///////////////////////////////////// Guardian /////////////////////////////////////////


guardian( )
{
	if(!isalive(self))
		return;

	guardian = self create_guardian();
	
	//	returning from this streak activation seems to strip this?
	//	manually removing and restoring
	//self removePerks();		
	
	result = self setCarryingguardian(guardian);
	
	//self thread waitRestorePerks();
	
	// we're done carrying for sure and sometimes this might not get reset
	// this fixes a bug where you could be carrying and have it in a place where it won't plant, get killed, now you can't scroll through killstreaks
	self.isCarrying = false;

	//guardian sentry_setOwner( owner );
	// guardian thread sentry_handleDamage();
	// guardian thread sentry_handleDeath();
	// guardian thread sentry_timeOut();

	// if we failed to place the sentry, it will have been deleted at this point
	if ( IsDefined( guardian ) )
		return true;
	else
		return false;
}

create_guardian() {
	guardian = spawn( "script_model", self.origin );
	if(!isdefined(guardian))
		print("^1GUARDIAN NOT DEFINED");

	guardian setmodel(level.guardian_settings.basemodel);
	guardian.health = 999999; 
	guardian.maxhealth = 500;
	guardian.damageTaken = 0;
	guardian.owner = self;
	guardian.team = self.team;
	guardian.killCount = 0;
	guardian.angles = (0,self.angles[1],0);
	
	return guardian;
}

setCarryingguardian(guardian)
{
	self endon ( "death" );
	self endon ( "disconnect" );

	
	guardian guardian_setCarried( self );
	
	self _disableWeapon();

	self notifyOnPlayerCommand( "place", "+attack" );
	self notifyOnPlayerCommand( "place", "+attack_akimbo_accessible" ); // support accessibility control scheme
	
	for ( ;; )
	{
		result = waittill_any_return( "place");

		if ( !guardian.canBePlaced )
			continue;
			
		guardian guardian_setPlaced();
		self _enableWeapon();		
		return true;
	}
}

guardian_setCarried( carrier )
{
	assert( isPlayer( carrier ) );

	assertEx( carrier == self.owner, "guardian_setCarried() specified carrier does not own this sentry" );

	self setModel( level.guardian_settings.modelPlacement );

	self setCanDamage( false );

	self.carriedBy = carrier;
	carrier.isCarrying = true;

	carrier thread updateguardianplacement( self );
	
	self thread guardian_onCarrierChecks( carrier );


	//self sentry_setInactive();
	
	self notify ( "carried" );
}

guardian_setPlaced()
{
	self setModel( level.guardian_settings.modelBase );

	self setCanDamage( true );
	
	//	JDS TODO: - turret aligns to ground normal which the player will align to when they mount the turret
	//						- temp fix to keep up vertical

	self.angles = self.carriedBy.angles;
		// show the pickup message
	if( IsAlive( self.owner ) )
		self.owner setLowerMessage( "pickup_hint", level.guardian_settings.hintString, 3.0, undefined, undefined, undefined, undefined, undefined, true );
		// spawn a trigger so we know if the owner is within range to pick it up
		self.ownerTrigger = Spawn( "trigger_radius", self.origin + ( 0, 0, 1 ), 0, 105, 64 );
		assert( IsDefined( self.ownerTrigger ) );
			self.owner thread guardian_handlePickup( self );

	

	self.carriedBy forceUseHintOff();
	self.carriedBy = undefined;

	self.owner.isCarrying = false;

	//self sentry_setActive();

	self playSound( "sentry_gun_plant" );

	self notify ( "placed" );
}

guardian_handlePickup( guardian ) // self == owner (player)
{
	self endon( "disconnect" );
	level endon( "game_ended" );
	guardian endon( "death" );

	if( !IsDefined( guardian.ownerTrigger ) )
		return;

	buttonTime = 0;
	for ( ;; )
	{
		if( IsAlive( self ) && 
			self IsTouching( guardian.ownerTrigger ) && 
			!IsDefined( guardian.inUseBy ) && 
			!IsDefined( guardian.carriedBy ) &&
			self IsOnGround() )
		{
			if ( self UseButtonPressed() )
			{
				if( IsDefined( self.using_remote_turret ) && self.using_remote_turret )
					continue;

				buttonTime = 0;
				while ( self UseButtonPressed() )
				{
					buttonTime += 0.05;
					wait( 0.05 );
				}

				println( "pressTime1: " + buttonTime );
				if ( buttonTime >= 0.5 )
					continue;

				buttonTime = 0;
				while ( !self UseButtonPressed() && buttonTime < 0.5 )
				{
					buttonTime += 0.05;
					wait( 0.05 );
				}

				println( "delayTime: " + buttonTime );
				if ( buttonTime >= 0.5 )
					continue;

				if ( !isReallyAlive( self ) )
					continue;

				if( IsDefined( self.using_remote_turret ) && self.using_remote_turret )
					continue;

				//disable here
				//turret setMode( level.sentrySettings[ turret.sentryType ].sentryModeOff );
				self thread setCarryingguardian( guardian, false );
				guardian.ownerTrigger delete();
				return;
			}
		}
		wait( 0.05 );
	}
}

guardian_onCarrierChecks( carrier )
{
	self endon ( "placed" );
	self endon ( "death" );

	self thread guardian_onGameEnded(carrier);

	yeet = carrier waittill_any_return( "death","disconnect","joined_team","joined_spectators" );
	
	if(yeet == "death") {
		if ( self.canBePlaced )
			self guardian_setPlaced();
		else
			self delete();
	} else {
		self delete();
	}
}

guardian_onGameEnded( carrier )
{
	self endon ( "placed" );
	self endon ( "death" );

	level waittill ( "game_ended" );
	
	self delete();
}


updateguardianplacement( guardian ) {
	self endon ( "death" );
	self endon ( "disconnect" );
	level endon ( "game_ended" );

	guardian endon ( "placed" );
	guardian endon ( "death" );

	guardian.canBePlaced = 1;
	lastCanPlaceSentry = -1;

	for(;;) {
        placement = self canPlayerPlaceSentry();

        forang = anglestoforward(self getplayerangles());
        position = self.origin + forang * 55;
        trace = bullettrace(position + (0,0,50), position - (0,0,30), 0, self);
        traceer = bullettracepassed(self.origin + (0,0,40), position + (0,0,40), 0, self);

		guardian.origin = placement[ "origin" ];
		guardian.angles = placement[ "angles" ];
		guardian.canBePlaced = self isOnGround()  && ( abs(guardian.origin[2]-self.origin[2]) < 10 ) && placement[ "result" ] && traceer || trace["fraction"] < 1 && traceer;

		if(guardian.canBePlaced != lastCanPlaceSentry) {
			if (guardian.canBePlaced) {
				guardian setModel( level.guardian_settings.modelPlacement);
				self ForceUseHintOn( &"SENTRY_PLACE" );
			}
			else {
				guardian setModel(level.guardian_settings.modelPlacementFailed);
				self ForceUseHintOn( &"SENTRY_CANNOT_PLACE" );
			}
		}

		lastCanPlaceSentry = guardian.canBePlaced;
		wait .05;
	}
}


/*
sentry_handleDamage()
{
	self endon( "death" );
	level endon( "game_ended" );

	self.health = level.sentrySettings[ self.sentryType ].health;
	self.maxHealth = level.sentrySettings[ self.sentryType ].maxHealth;
	self.damageTaken = 0; // how much damage has it taken

	while ( true )
	{
		self waittill( "damage", damage, attacker, direction_vec, point, meansOfDeath, modelName, tagName, partName, iDFlags, weapon );
		
		// don't allow people to destroy equipment on their team if FF is off
		if ( !maps\mp\gametypes\_weapons::friendlyFireCheck( self.owner, attacker ) )
			continue;

		if ( IsDefined( iDFlags ) && ( iDFlags & level.iDFLAGS_PENETRATION ) )
			self.wasDamagedFromBulletPenetration = true;

		// up the damage for airstrikes, stealth bombs, and bomb sites
		switch( weapon )
		{
		case "artillery_mp":
		case "stealth_bomb_mp":
			damage *= 4;
			break;
		case "bomb_site_mp":
			damage = self.maxHealth;
			break;
		}

		if ( meansOfDeath == "MOD_MELEE" )
			self.damageTaken += self.maxHealth;

		modifiedDamage = damage;
		if ( isPlayer( attacker ) )
		{
			attacker maps\mp\gametypes\_damagefeedback::updateDamageFeedback( "sentry" );

			if ( attacker _hasPerk( "specialty_armorpiercing" ) )
			{
				modifiedDamage = damage * level.armorPiercingMod;			
			}			
		}

		// in case we are shooting from a remote position, like being in the osprey gunner shooting this
		if( IsDefined( attacker.owner ) && IsPlayer( attacker.owner ) )
		{
			attacker.owner maps\mp\gametypes\_damagefeedback::updateDamageFeedback( "sentry" );
		}
		
		if( IsDefined( weapon ) )
		{
			switch( weapon )
			{
			case "ac130_105mm_mp":
			case "ac130_40mm_mp":
			case "stinger_mp":
			case "javelin_mp":
			case "remote_mortar_missile_mp":		
			case "remotemissile_projectile_mp":
				self.largeProjectileDamage = true;
				modifiedDamage = self.maxHealth + 1;
				break;

			case "artillery_mp":
			case "stealth_bomb_mp":
				self.largeProjectileDamage = false;
				modifiedDamage += ( damage * 4 );
				break;

			case "bomb_site_mp":
			case "emp_grenade_mp":
				self.largeProjectileDamage = false;
				modifiedDamage = self.maxHealth + 1;
				break;
			}
		}

		self.damageTaken += modifiedDamage;		

		if ( self.damageTaken >= self.maxHealth )
		{
			thread maps\mp\gametypes\_missions::vehicleKilled( self.owner, self, undefined, attacker, damage, meansOfDeath, weapon );

			if ( isPlayer( attacker ) && (!IsDefined(self.owner) || attacker != self.owner) )
			{
				attacker thread maps\mp\gametypes\_rank::giveRankXP( "kill", 100, weapon, meansOfDeath );				
				attacker notify( "destroyed_killstreak" );
				
				if ( IsDefined( self.UAVRemoteMarkedBy ) && self.UAVRemoteMarkedBy != attacker )
					self.UAVRemoteMarkedBy thread maps\mp\killstreaks\_remoteuav::remoteUAV_processTaggedAssist();
			}
		
			if ( IsDefined( self.owner ) )
				self.owner thread leaderDialogOnPlayer( level.sentrySettings[ self.sentryType ].voDestroyed );
		
			self notify ( "death" );
			return;
		}
	}
}
*/

