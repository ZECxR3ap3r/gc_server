#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

main() {
    level thread scripts\inf_classic\main::main();
}

init() {
	port = getdvar("net_port");

	if(isdefined(port)) {
		level thread scripts\_global_files\core::init();
		level thread scripts\_global_files\reaper_menu::init();
		level thread scripts\_global_files\commands::init();
		level thread scripts\_global_files\player_stats::init();

		if(port == 11111) {
			level thread scripts\inf_classic\map_rotation::Main();
			level thread scripts\inf_classic\main::init();
			level thread scripts\inf_classic\weapons::init();
		}
		else if(port == 22222) {
			level thread scripts\inf_tpjugg\main::init();
			level thread scripts\inf_tpjugg\nextmap::init();
			level thread scripts\inf_tpjugg\custom_killstreaks::init();
			level thread scripts\inf_tpjugg\zombie::init();
			level thread scripts\inf_tpjugg\gunrotation::init();
			level thread scripts\inf_tpjugg\map_funcs::init();
			level thread scripts\inf_tpjugg\map_objects::init();
		}
	}
	else
		print("^1Port Not Defined");
}