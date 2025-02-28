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

build_killstreak_data(arg_1, arg_2, arg_3, arg_4, arg_5, arg_6, arg_7, arg_8, arg_9, arg_10, arg_11) {
	game["dialog"][arg_1] = arg_3;

	if(isdefined(arg_2)) {
		if(arg_2 == "Loc_String")
			arg_2 = tablelookupistring( "mp/killstreakTable.csv", 1, arg_1, 6 );

		precachestring( arg_2 );
	}
	
	game["dialog"]["allies_friendly_" + arg_1 + "_inbound"] = "use_" + arg_4;
	game["dialog"]["allies_enemy_" + arg_1 + "_inbound"] = "enemy_" + arg_4;
	game["dialog"]["axis_friendly_" + arg_1 + "_inbound"] = "use_" + arg_5;
	game["dialog"]["axis_enemy_" + arg_1 + "_inbound"] = "enemy_" + arg_5;
	precacheitem( arg_6 );
	maps\mp\gametypes\_rank::registerscoreinfo( "killstreak_" + arg_1, arg_7 );
	precacheshader( arg_8 );

	arg_8 = tablelookup( "mp/killstreakTable.csv", 1, arg_1, 14 );

	if(isdefined(arg_9))
		precacheshader( arg_9 );
	if(isdefined(arg_10))
		precacheshader( arg_10 );
	if(isdefined(arg_11))
		precacheshader( arg_11 );
}

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
	precacheheadicon("waypoint_ammo_friendly");
	precacheheadicon("dpad_killstreak_airdrop_trap");

	build_killstreak_data( "harrier_airstrike" , undefined , "achieve_airstrike" , "airstrike" , "airstrike" , "killstreak_precision_airstrike_mp" , 200 , "death_harrier" , "death_harrier" , "death_harrier" , "death_harrier" );

	build_killstreak_data( "uav" , "Loc_String" , "achieve_uav" , "uav" , "uav" , "killstreak_uav_mp" , 100 , "dpad_killstreak_uav_static" , "specialty_uav_crate" , "dpad_killstreak_uav" , "dpad_killstreak_uav" );
	build_killstreak_data( "airdrop_assault" , "Loc_String" , "achieve_carepackage" , "carepackage" , "carepackage" , "airdrop_marker_mp" , 100 , "dpad_killstreak_carepackage_static" , "specialty_null" , "dpad_killstreak_carepackage" , "dpad_killstreak_carepackage" );
	build_killstreak_data( "predator_missile" , "Loc_String" , "achieve_hellfire" , "hellfire" , "hellfire" , "killstreak_predator_missile_mp" , 150 , "dpad_killstreak_predator_missile_static" , "specialty_predator_missile_crate" , "dpad_killstreak_predator_missile" , "dpad_killstreak_predator_missile" );
	build_killstreak_data( "ims" , "Loc_String" , "achieve_ims" , "null" , "null" , "killstreak_ims_mp" , 150 , "dpad_killstreak_ims_static" , "specialty_ims_crate" , "dpad_killstreak_ims" , "dpad_killstreak_ims" );
	build_killstreak_data( "airdrop_sentry_minigun" , "Loc_String" , "achieve_sentrygun" , "sentrygun" , "sentrygun" , "airdrop_sentry_marker_mp" , 150 , "dpad_killstreak_sentry_gun_static" , "specialty_null" , "dpad_killstreak_sentry_gun" , "dpad_killstreak_sentry_gun" );
	build_killstreak_data( "sentry" , "Loc_String" , "deploy_sentry" , "null" , "null" , "killstreak_sentry_mp" , 150 , "dpad_killstreak_sentry_gun_static" , "specialty_sentry_gun_crate" , "dpad_killstreak_sentry_gun" , "dpad_killstreak_sentry_gun" );
	build_killstreak_data( "precision_airstrike" , "Loc_String" , "achieve_airstrike" , "airstrike" , "airstrike" , "killstreak_precision_airstrike_mp" , 200 , "dpad_killstreak_precision_airstrike_static" , "specialty_precision_airstrike_crate" , "dpad_killstreak_precision_airstrike" , "dpad_killstreak_precision_airstrike" );
	build_killstreak_data( "helicopter" , "Loc_String" , "achieve_heli" , "cobra" , "hind" , "killstreak_helicopter_mp" , 200 , "dpad_killstreak_attack_helicopter_static" , "specialty_attack_helicopter_crate" , "dpad_killstreak_attack_helicopter" , "dpad_killstreak_attack_helicopter" );
	build_killstreak_data( "littlebird_flock" , "Loc_String" , "achieve_strafe" , "strafe" , "strafe" , "killstreak_precision_airstrike_mp" , 200 , "dpad_killstreak_helicopter_flock_static" , "specialty_helicopter_flock_crate" , "dpad_killstreak_helicopter_flock" , "dpad_killstreak_helicopter_flock" );
	build_killstreak_data( "littlebird_support" , "Loc_String" , "achieve_ah6guard" , "ah6guard" , "ah6guard" , "killstreak_helicopter_mp" , 200 , "dpad_killstreak_helicopter_guard_static" , "specialty_helicopter_guard_crate" , "dpad_killstreak_helicopter_guard" , "dpad_killstreak_helicopter_guard" );
	build_killstreak_data( "remote_mortar" , "Loc_String" , "achieve_agm" , "agm" , "agm" , "killstreak_remote_mortar_mp" , 100 , "dpad_killstreak_reaper_static" , "specialty_reaper_crate" , "dpad_killstreak_reaper" , "dpad_killstreak_reaper" );
	build_killstreak_data( "airdrop_remote_tank" , "Loc_String" , "achieve_assault_drone" , "null" , "null" , "airdrop_tank_marker_mp" , 150 , "dpad_killstreak_talon_static" , "specialty_null" , "dpad_killstreak_talon" , "dpad_killstreak_talon" );
	build_killstreak_data( "remote_tank" , "Loc_String" , "achieve_assault_drone" , "assault_drone" , "assault_drone" , "killstreak_remote_tank_mp" , 350 , "dpad_killstreak_talon_static" , "specialty_talon_crate" , "dpad_killstreak_talon" , "dpad_killstreak_talon" );
	build_killstreak_data( "helicopter_flares" , "Loc_String" , "achieve_pavelow" , "pavelow" , "pavelow" , "killstreak_helicopter_flares_mp" , 300 , "dpad_killstreak_pave_low_static" , "specialty_pave_low_crate" , "dpad_killstreak_pave_low" , "dpad_killstreak_pave_low" );
	build_killstreak_data( "ac130" , "Loc_String" , "achieve_ac130" , "ac130" , "ac130" , "killstreak_ac130_mp" , 350 , "dpad_killstreak_ac130_static" , "specialty_ac130_crate" , "dpad_killstreak_ac130" , "dpad_killstreak_ac130" );
	build_killstreak_data( "airdrop_juggernaut" , "Loc_String" , "achieve_juggernaut" , "juggernaut" , "juggernaut" , "airdrop_juggernaut_mp" , 150 , "dpad_killstreak_airdrop_juggernaut_static" , "specialty_juggernaut_crate" , "dpad_killstreak_airdrop_juggernaut" , "dpad_killstreak_airdrop_juggernaut" );
	build_killstreak_data( "osprey_gunner" , "Loc_String" , "achieve_osprey_gunner" , "osprey_gunner" , "osprey_gunner" , "killstreak_helicopter_minigun_mp" , 350 , "dpad_killstreak_osprey_gunner_static" , "specialty_osprey_gunner_crate" , "dpad_killstreak_osprey_gunner" , "dpad_killstreak_osprey_gunner" );
	// build_killstreak_data( "uav_support" , "Loc_String" , "achieve_uav" , "uav" , "uav" , "killstreak_uav_mp" , 100 , "dpad_killstreak_uav_static" , "specialty_uav_crate" , "dpad_killstreak_uav" , "dpad_killstreak_uav" );
	// build_killstreak_data( "counter_uav" , "Loc_String" , "achieve_jamuav" , "jamuav" , "jamuav" , "killstreak_counter_uav_mp" , 100 , "dpad_killstreak_counter_uav_static" , "specialty_counter_uav_crate" , "dpad_killstreak_counter_uav" , "dpad_killstreak_counter_uav" );
	build_killstreak_data( "deployable_vest" , "Loc_String" , "achieve_vest_dep" , "null" , "null" , "deployable_vest_marker_mp" , 200 , "dpad_killstreak_deployable_vest_static" , "specialty_deployable_vest_crate" , "dpad_killstreak_deployable_vest" , "dpad_killstreak_deployable_vest" );
	build_killstreak_data( "airdrop_trap" , "Loc_String" , "achieve_airtrap" , "airtrap" , "airtrap" , "airdrop_trap_marker_mp" , 100 , "dpad_killstreak_airdrop_trap_static" , "specialty_null" , "dpad_killstreak_airdrop_trap" , "dpad_killstreak_airdrop_trap" );
	// build_killstreak_data( "sam_turret" , "Loc_String" , "achieve_sam" , "sam" , "sam" , "killstreak_sentry_mp" , 150 , "dpad_killstreak_sam_turret_static" , "specialty_sam_turret_crate" , "dpad_killstreak_sam_turret" , "dpad_killstreak_sam_turret" );
	// build_killstreak_data( "remote_uav" , "Loc_String" , "achieve_recon_drone" , "recon_drone" , "recon_drone" , "killstreak_uav_mp" , 350 , "dpad_killstreak_remote_uav_static" , "specialty_remote_uav_crate" , "dpad_killstreak_remote_uav" , "dpad_killstreak_remote_uav" );
	// build_killstreak_data( "triple_uav" , "Loc_String" , "achieve_phantom_ray" , "advanced_uav" , "advanced_uav" , "killstreak_triple_uav_mp" , 150 , "dpad_killstreak_advanced_uav_static" , "specialty_advanced_uav_crate" , "dpad_killstreak_advanced_uav" , "dpad_killstreak_advanced_uav" );
	build_killstreak_data( "remote_mg_turret" , "Loc_String" , "achieve_remote_sentry" , "null" , "null" , "killstreak_remote_turret_mp" , 250 , "dpad_killstreak_remote_mg_turret_static" , "specialty_remote_mg_turret_crate" , "dpad_killstreak_remote_mg_turret" , "dpad_killstreak_remote_mg_turret" );
	build_killstreak_data( "stealth_airstrike" , "Loc_String" , "achieve_stealth" , "null" , "null" , "killstreak_stealth_airstrike_mp" , 300 , "dpad_killstreak_stealth_bomber_static" , "specialty_stealth_bomber_crate" , "dpad_killstreak_stealth_bomber" , "dpad_killstreak_stealth_bomber" );
	// build_killstreak_data( "emp" , "Loc_String" , "achieve_emp" , "emp" , "emp" , "killstreak_emp_mp" , 500 , "dpad_killstreak_emp_static" , "specialty_emp_crate" , "dpad_killstreak_emp" , "dpad_killstreak_emp" );
	// build_killstreak_data( "airdrop_juggernaut_recon" , "Loc_String" , "achieve_juggernaut" , "juggernaut" , "juggernaut" , "airdrop_juggernaut_mp" , 150 , "dpad_killstreak_airdrop_juggernaut_support_static" , "specialty_juggernaut_support_crate" , "dpad_killstreak_airdrop_juggernaut_support" , "dpad_killstreak_airdrop_juggernaut_support" );
	// build_killstreak_data( "escort_airdrop" , "Loc_String" , "achieve_escort_airdrop" , "escort_airdrop" , "escort_airdrop" , "airdrop_escort_marker_mp" , 350 , "dpad_killstreak_escort_airdrop_static" , "specialty_escort_airdrop_crate" , "dpad_killstreak_escort_airdrop" , "dpad_killstreak_escort_airdrop" );
	build_killstreak_data( "nuke" , "Loc_String" , "achieve_moab" , "moab" , "moab" , "killstreak_uav_mp" , 100 , "dpad_killstreak_nuke" , "specialty_null" , "dpad_killstreak_nuke" , "dpad_killstreak_nuke" );
	
	// build_killstreak_data( "specialty_longersprint_ks" , "Loc_String" , "achieve_extremeconditioning" , "null" , "null" , "killstreak_uav_mp" , 150 , "specialty_longersprint" , "specialty_longersprint" , "specialty_longersprint" , "specialty_longersprint" );
	// build_killstreak_data( "specialty_fastreload_ks" , "Loc_String" , "achieve_sleightofhand" , "null" , "null" , "killstreak_uav_mp" , 150 , "specialty_fastreload" , "specialty_fastreload" , "specialty_fastreload" , "specialty_fastreload" );
	// build_killstreak_data( "specialty_scavenger_ks" , "Loc_String" , "achieve_scavenger" , "null" , "null" , "killstreak_uav_mp" , 150 , "specialty_scavenger" , "specialty_scavenger" , "specialty_scavenger" , "specialty_scavenger" );
	// build_killstreak_data( "specialty_blindeye_ks" , "Loc_String" , "achieve_blindeye" , "null" , "null" , "killstreak_uav_mp" , 150 , "specialty_blindeye" , "specialty_blindeye" , "specialty_blindeye" , "specialty_blindeye" );
	// build_killstreak_data( "specialty_paint_ks" , "Loc_String" , "achieve_recon" , "null" , "null" , "killstreak_uav_mp" , 150 , "specialty_paint" , "specialty_paint" , "specialty_paint" , "specialty_paint" );
	// build_killstreak_data( "specialty_hardline_ks" , "Loc_String" , "achieve_hardline" , "null" , "null" , "killstreak_uav_mp" , 150 , "specialty_hardline" , "specialty_hardline" , "specialty_hardline" , "specialty_hardline" );
	// build_killstreak_data( "specialty_coldblooded_ks" , "Loc_String" , "achieve_assassin" , "null" , "null" , "killstreak_uav_mp" , 150 , "specialty_coldblooded" , "specialty_coldblooded" , "specialty_coldblooded" , "specialty_coldblooded" );
	// build_killstreak_data( "specialty_quickdraw_ks" , "Loc_String" , "achieve_quickdraw" , "null" , "null" , "killstreak_uav_mp" , 150 , "specialty_quickdraw" , "specialty_quickdraw" , "specialty_quickdraw" , "specialty_quickdraw" );
	// build_killstreak_data( "_specialty_blastshield_ks" , "Loc_String" , "achieve_blastshield" , "null" , "null" , "killstreak_uav_mp" , 150 , "specialty_blastshield" , "specialty_blastshield" , "specialty_blastshield" , "specialty_blastshield" );
	// build_killstreak_data( "specialty_detectexplosive_ks" , "Loc_String" , "achieve_sitrep" , "null" , "null" , "killstreak_uav_mp" , 150 , "specialty_bombsquad" , "specialty_bombsquad" , "specialty_bombsquad" , "specialty_bombsquad" );
	// build_killstreak_data( "specialty_autospot_ks" , "Loc_String" , "achieve_marksman" , "null" , "null" , "killstreak_uav_mp" , 150 , "specialty_ironlungs" , "specialty_ironlungs" , "specialty_ironlungs" , "specialty_ironlungs" );
	// build_killstreak_data( "specialty_bulletaccuracy_ks" , "Loc_String" , "achieve_steadyaim" , "null" , "null" , "killstreak_uav_mp" , 150 , "specialty_steadyaim" , "specialty_steadyaim" , "specialty_steadyaim" , "specialty_steadyaim" );
	// build_killstreak_data( "specialty_quieter_ks" , "Loc_String" , "achieve_deadsilence" , "null" , "null" , "killstreak_uav_mp" , 150 , "specialty_quieter" , "specialty_quieter" , "specialty_quieter" , "specialty_quieter" );
	// build_killstreak_data( "specialty_stalker_ks" , "Loc_String" , "achieve_stalker" , "null" , "null" , "killstreak_uav_mp" , 150 , "specialty_stalker" , "specialty_stalker" , "specialty_stalker" , "specialty_stalker" );
	// build_killstreak_data( "specialty_longersprint_ks_pro" , "Loc_String" , "achieve_extremeconditioning" , "null" , "null" , "killstreak_uav_mp" , 150 , "specialty_longersprint_upgrade" , "specialty_longersprint_upgrade" , "specialty_longersprint_upgrade" , "specialty_longersprint_upgrade" );
	// build_killstreak_data( "specialty_fastreload_ks_pro" , "Loc_String" , "achieve_sleightofhand" , "null" , "null" , "killstreak_uav_mp" , 150 , "specialty_fastreload_upgrade" , "specialty_fastreload_upgrade" , "specialty_fastreload_upgrade" , "specialty_fastreload_upgrade" );
	// build_killstreak_data( "specialty_scavenger_ks_pro" , "Loc_String" , "achieve_scavenger" , "null" , "null" , "killstreak_uav_mp" , 150 , "specialty_scavenger_upgrade" , "specialty_scavenger_upgrade" , "specialty_scavenger_upgrade" , "specialty_scavenger_upgrade" );
	// build_killstreak_data( "specialty_blindeye_ks_pro" , "Loc_String" , "achieve_blindeye" , "null" , "null" , "killstreak_uav_mp" , 150 , "specialty_blindeye_upgrade" , "specialty_blindeye_upgrade" , "specialty_blindeye_upgrade" , "specialty_blindeye_upgrade" );
	// build_killstreak_data( "specialty_paint_ks_pro" , "Loc_String" , "achieve_recon" , "null" , "null" , "killstreak_uav_mp" , 150 , "specialty_paint_upgrade" , "specialty_paint_upgrade" , "specialty_paint_upgrade" , "specialty_paint_upgrade" );
	// build_killstreak_data( "specialty_hardline_ks_pro" , "Loc_String" , "achieve_hardline" , "null" , "null" , "killstreak_uav_mp" , 150 , "specialty_hardline_upgrade" , "specialty_hardline_upgrade" , "specialty_hardline_upgrade" , "specialty_hardline_upgrade" );
	// build_killstreak_data( "specialty_coldblooded_ks_pro" , "Loc_String" , "achieve_assassin" , "null" , "null" , "killstreak_uav_mp" , 150 , "specialty_coldblooded_upgrade" , "specialty_coldblooded_upgrade" , "specialty_coldblooded_upgrade" , "specialty_coldblooded_upgrade" );
	// build_killstreak_data( "specialty_quickdraw_ks_pro" , "Loc_String" , "achieve_quickdraw" , "null" , "null" , "killstreak_uav_mp" , 150 , "specialty_quickdraw_upgrade" , "specialty_quickdraw_upgrade" , "specialty_quickdraw_upgrade" , "specialty_quickdraw_upgrade" );
	// build_killstreak_data( "_specialty_blastshield_ks_pro" , "Loc_String" , "achieve_blastshield" , "null" , "null" , "killstreak_uav_mp" , 150 , "specialty_blastshield_upgrade" , "specialty_blastshield_upgrade" , "specialty_blastshield_upgrade" , "specialty_blastshield_upgrade" );
	// build_killstreak_data( "specialty_detectexplosive_ks_pro" , "Loc_String" , "achieve_sitrep" , "null" , "null" , "killstreak_uav_mp" , 150 , "specialty_bombsquad_upgrade" , "specialty_bombsquad_upgrade" , "specialty_bombsquad_upgrade" , "specialty_bombsquad_upgrade" );
	// build_killstreak_data( "specialty_autospot_ks_pro" , "Loc_String" , "achieve_marksman" , "null" , "null" , "killstreak_uav_mp" , 150 , "specialty_ironlungs_upgrade" , "specialty_ironlungs_upgrade" , "specialty_ironlungs_upgrade" , "specialty_ironlungs_upgrade" );
	// build_killstreak_data( "specialty_bulletaccuracy_ks_pro" , "Loc_String" , "achieve_steadyaim" , "null" , "null" , "killstreak_uav_mp" , 150 , "specialty_steadyaim_upgrade" , "specialty_steadyaim_upgrade" , "specialty_steadyaim_upgrade" , "specialty_steadyaim_upgrade" );
	// build_killstreak_data( "specialty_quieter_ks_pro" , "Loc_String" , "achieve_deadsilence" , "null" , "null" , "killstreak_uav_mp" , 150 , "specialty_quieter_upgrade" , "specialty_quieter_upgrade" , "specialty_quieter_upgrade" , "specialty_quieter_upgrade" );
	// build_killstreak_data( "specialty_stalker_ks_pro" , "Loc_String" , "achieve_stalker" , "null" , "null" , "killstreak_uav_mp" , 150 , "specialty_stalker_upgrade" , "specialty_stalker_upgrade" , "specialty_stalker_upgrade" , "specialty_stalker_upgrade" );
	// build_killstreak_data( "all_perks_bonus" , "Loc_String" , "achieve_specialty_bonus" , "null" , "null" , "killstreak_uav_mp" , 150 , "specialty_perks_all" , "specialty_perks_all" , "specialty_perks_all" , "specialty_perks_all" );
	
	// for ( i = 1; true; i++ )
	// {
	// 	retVal = tableLookup( KILLSTREAK_STRING_TABLE, 0, i, 1 );
	// 	if ( !IsDefined( retVal ) || retVal == "" )
	// 		break;

	// 	streakRef = tableLookup( KILLSTREAK_STRING_TABLE, 0, i, 1 );
	// 	assert( streakRef != "" );

	// 	streakUseHint = tableLookupIString( KILLSTREAK_STRING_TABLE, 0, i, 6 );
	// 	assert( streakUseHint != &"" );
	// 	PreCacheString( streakUseHint );

	// 	streakEarnDialog = tableLookup( KILLSTREAK_STRING_TABLE, 0, i, 8 );
	// 	assert( streakEarnDialog != "" );
	// 	game[ "dialog" ][ streakRef ] = streakEarnDialog;

	// 	streakAlliesUseDialog = tableLookup( KILLSTREAK_STRING_TABLE, 0, i, 9 );
	// 	assert( streakAlliesUseDialog != "" );
	// 	game[ "dialog" ][ "allies_friendly_" + streakRef + "_inbound" ] = "use_" + streakAlliesUseDialog;
	// 	game[ "dialog" ][ "allies_enemy_" + streakRef + "_inbound" ] = "enemy_" + streakAlliesUseDialog;

	// 	streakAxisUseDialog = tableLookup( KILLSTREAK_STRING_TABLE, 0, i, 10 );
	// 	assert( streakAxisUseDialog != "" );
	// 	game[ "dialog" ][ "axis_friendly_" + streakRef + "_inbound" ] = "use_" + streakAxisUseDialog;
	// 	game[ "dialog" ][ "axis_enemy_" + streakRef + "_inbound" ] = "enemy_" + streakAxisUseDialog;

	// 	streakWeapon = tableLookup( KILLSTREAK_STRING_TABLE, 0, i, 12 );
	// 	precacheItem( streakWeapon );

	// 	streakPoints = int( tableLookup( KILLSTREAK_STRING_TABLE, 0, i, 13 ) );
	// 	assert( streakPoints != 0 );
	// 	maps\mp\gametypes\_rank::registerScoreInfo( "killstreak_" + streakRef, streakPoints );

	// 	streakShader = tableLookup( KILLSTREAK_STRING_TABLE, 0, i, 14 );
	// 	precacheShader( streakShader );

	// 	streakShader = tableLookup( KILLSTREAK_STRING_TABLE, 0, i, 15 );
	// 	if ( streakShader != "" )
	// 		precacheShader( streakShader );

	// 	streakShader = tableLookup( KILLSTREAK_STRING_TABLE, 0, i, 16 );
	// 	if ( streakShader != "" )
	// 		precacheShader( streakShader );

	// 	streakShader = tableLookup( KILLSTREAK_STRING_TABLE, 0, i, 17 );
	// 	if ( streakShader != "" )
	// 		precacheShader( streakShader );

	// 	arg_1 = tablelookup( "mp/killstreakTable.csv", 0, i, 1 ); // killstreak name
	// 	arg_2 = tablelookupistring( "mp/killstreakTable.csv", 0, i, 6 ); // killstreak string
	// 	arg_3 = tablelookup( "mp/killstreakTable.csv", 0, i, 8 ); // dialog killstreakname sound?
	// 	arg_4 = tablelookup( "mp/killstreakTable.csv", 0, i, 9 ); // dialog killstreakname inbound sound allies?
	// 	arg_5 = tablelookup( "mp/killstreakTable.csv", 0, i, 10 ); // dialog killstreakname inbound sound axis?
	// 	arg_6 = tablelookup( "mp/killstreakTable.csv", 0, i, 12 ); // weapon name
	// 	arg_7 = int( tablelookup( "mp/killstreakTable.csv", 0, i, 13 ) ); //scorestreak killstreak name int

	// 	arg_8 = tablelookup( "mp/killstreakTable.csv", 0, i, 14 ); // not sure
	// 	arg_9 = tablelookup( "mp/killstreakTable.csv", 0, i, 15 ); // not sure var_9 != ""
	// 	arg_10 = tablelookup( "mp/killstreakTable.csv", 0, i, 16 ); // not sure var_9 != ""
	// 	arg_11 = tablelookup( "mp/killstreakTable.csv", 0, i, 17 ); // not sure var_9 != ""

	// 	if(arg_9 == "")
	// 		arg_9 = "^1undefined^3";
	// 	if(arg_10 == "")
	// 		arg_10 = "^1undefined^3";
	// 	if(arg_11 == "")
	// 		arg_11 = "^1undefined^3";

	// 	print("^3build_killstreak_data( \"" + arg_1 + "\" , \"" + "Loc_String" + "\" , \"" + arg_3 + "\" , \"" + arg_4 + "\" , \"" + arg_5 + "\" , \"" + arg_6 + "\" , \"" + arg_7 + "\" , \"" + arg_8 + "\" , \"" + arg_9 + "\" , \"" + arg_10 + "\" , \"" + arg_10 + "\" );" );

	// }
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

