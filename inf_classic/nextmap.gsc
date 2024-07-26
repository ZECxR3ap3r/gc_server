#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include scripts\inf_classic\map_rotation;

init() {
    level thread nextmaptell();
}

nextmaptell() {
    level waittill("connected");

    level thread next_map_caller();
}

next_map_caller() {
    map = getdvar("mapname");
    data = getdvar("sv_maprotation");
    data = strtok(data, " ");
    nextmap = map;
    found = false;

    for(i = 1;i < data.size;i += 2) {
    	if(map == data[i]) {
    		found = true;
    		if(!isdefined(data[i + 2]))
    			nextmap = data[1];
    		else
    			nextmap = data[i + 2];
    	}
    }

    if(found == false) {
    	data = getdvar("sv_maprotationcurrent");
    	data = strtok(data, " ");
    	nextmap = data[1];
    }

    level.real_next_map = nextmap;

    wait 30;

    time = get_times(getservertime());
    hour = int(23 - int(get_hour(time)));
    min = int(60 - int(get_min(time)));

    if(isdefined(level.next_map))
        say_raw("^8^7[ ^8Information^7 ] Next Map: ^8" + scripts\inf_classic\map_rotation::mapname(level.next_map));
	else
        say_raw("^8^7[ ^8Information^7 ] Next Map: ^8" + scripts\inf_classic\map_rotation::mapname(nextmap));

    if(isdefined(level.betties_map) && level.betties_map == 1)
        say_raw("^8^7[ ^8Information^7 ] Infected Equipment: ^8Bouncing Betty");
    else if(isdefined(level.throwing_knifes_map) && level.throwing_knifes_map == 1)
        say_raw("^8^7[ ^8Information^7 ] Infected Equipment: ^8Throwing Knife");

    say_raw("^8^7[ ^8Information^7 ] New Rotation in: ^8" + hour + "^7h ^8" + min + "^7m");

    level waittill("game_ended");

    time = get_times(getservertime());
    hour = int(23 - int(get_hour(time)));
    min = int(60 - int(get_min(time)));

	if(isdefined(level.next_map))
        say_raw("^8^7[ ^8Information^7 ] Next Map: ^8" + scripts\inf_classic\map_rotation::mapname(level.next_map));
	else
        say_raw("^8^7[ ^8Information^7 ] Next Map: ^8" + scripts\inf_classic\map_rotation::mapname(nextmap));

    say_raw("^8^7[ ^8Information^7 ] New Rotation in: ^8" + hour + "^7h ^8" + min + "^7m");
}