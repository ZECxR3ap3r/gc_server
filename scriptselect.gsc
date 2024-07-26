#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

main() {
    port = getdvar("net_port");

    if(isdefined(port)) {
		if(port == "27027") {
			level thread scripts\inf_tpjugg\custom_killstreaks::main();
        	level thread scripts\inf_tpjugg\main::main();
		}
		else if(port == "27030")
			level thread scripts\steventest\main::main();
    }
}

init() {
	port = getdvar("net_port");

	if(isdefined(port)) {
		if(port != "27029" && port != "27019" && port != "27030") {
			level thread scripts\_global_files\core::init();
			level thread scripts\_global_files\reaper_menu::init();
			level thread scripts\_global_files\commands::init();
			if(port == "27015" || port == "27025" || port == "27027" || port == "27021")
				level thread scripts\_global_files\player_stats::init();
		}
		if(port == "27020") { // inf gillette 1
			level thread scripts\inf_noedits\gillappenoedits::init();
			level thread scripts\inf_noedits\lightstikk::init();
			level thread scripts\inf_noedits\main::init();
			level thread scripts\inf_noedits\mapvotenoedit::init();
			level thread scripts\inf_noedits\newgunrotation::init();
			level thread scripts\inf_noedits\noeditjump::init();
			level thread scripts\inf_noedits\disableslowmo::Main();
		}
		else if(port == "27021")
		{
			level thread scripts\sniper\sniper::init();
		}
		else if(port == "27015" || port == "27025")  { // inf classic 1&2
			level thread scripts\inf_classic\map_rotation::Main();
			level thread scripts\inf_classic\anticamp::init();
			level thread scripts\inf_classic\nextmap::init();
			level thread scripts\inf_classic\disableslowmo::Main();
			level thread scripts\inf_classic\main::init();
			level thread scripts\inf_classic\mapbarriers::init();
			level thread scripts\inf_classic\weapons::init();
			level thread scripts\inf_classic\onscreentext::init();
		}
		else if(port == "27027") { // inf tp-jugg 1&2
			level thread scripts\inf_tpjugg\main::init();
			level thread scripts\inf_tpjugg\nextmap::init();
			level thread scripts\inf_tpjugg\custom_killstreaks::init();
			level thread scripts\inf_tpjugg\zombie::init();
			level thread scripts\inf_tpjugg\gunrotation::init();
			level thread scripts\inf_tpjugg\map_funcs::init();
			level thread scripts\inf_tpjugg\map_objects::init();
		}
		else if(port == "27030")  { // steven test
			level thread scripts\steventest\commands::init();
			level thread scripts\steventest\gungamewpns::init();
			level thread scripts\steventest\main::init();
		}
		else
			print("^5No Scripts for Port Found!");
	}
	else
		print("^1Port Not Defined");
}