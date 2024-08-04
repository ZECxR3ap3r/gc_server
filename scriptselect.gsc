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
		if(port == "27015" || port == "27025" || port == "27027" || port == "27021")
			level thread scripts\_global_files\player_stats::init();
		level thread scripts\inf_classic\map_rotation::Main();
		level thread scripts\inf_classic\anticamp::init();
		level thread scripts\inf_classic\nextmap::init();
		level thread scripts\inf_classic\disableslowmo::Main();
		level thread scripts\inf_classic\main::init();
		level thread scripts\inf_classic\mapbarriers::init();
		level thread scripts\inf_classic\weapons::init();
		level thread scripts\inf_classic\onscreentext::init();
	}
	else
		print("^1Port Not Defined");
}