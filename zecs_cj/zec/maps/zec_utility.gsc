#include zec\maps\main;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;

radians(deg) {
    return (deg * (3.14159265358979323846 / 180));
}

degToRad(deg) {
    return deg * (3.14159265 / 180);
}

groundpos( origin ) {
	return playerPhysicsTrace( origin, origin + vectorScale( ( 0, 0, 1 ), -100000 ), 0, self );
}

vectorScale(vec, scale) {
	return (vec[0] * scale, vec[1] * scale, vec[2] * scale);
}

get_date(data) {
	info = strtok(data, " ");
	if(isdefined(info[0]))
		return info[0];
}

cmd_find_player(string) {
    foreach(player in level.players) {
        if(issubstr(tolower(player.name), tolower(string)))
            return player;
    }

    return undefined;
}

CheckSaveZones() {
	if(!isDefined(level.cjNoSaveZones) || level.cjNoSaveZones.size < 1)
		return 0;

	for(i=0;i<level.cjNoSaveZones.size;i++) {
		if(self istouching(level.cjNoSaveZones[i]))
			return 1;
	}
	return 0;
}

hud_editor_leave(option, special) {
	self endon("disconnect");
	self endon("hud_editor_closed");

	while(1) {
		if(self meleebuttonpressed()) {
			if(option == "melee_color") {
				if(isdefined(special)) {
					self.player_settings["R2"] = self.R_Value;
					self.player_settings["G2"] = self.G_Value;
					self.player_settings["B2"] = self.B_Value;

					self change_hud_color();
				}
				else {
					self.player_settings["R"] = self.R_Value;
					self.player_settings["G"] = self.G_Value;
					self.player_settings["B"] = self.B_Value;
					self change_hud_color();
				}

				self notify("player_stats_updated");

				tits = GetArrayKeys(self.hud_element_editor);
				for(yeet=0;yeet<tits.size;yeet++)
					self.hud_element_editor[tits[yeet]] destroy();

				self freezecontrols(0);

                self show_cj_hud();

				wait .1;

				self.hud_element_editor = undefined;
				self.ui_selector = undefined;

				self.hud_elements["velocity"].alpha = 1;
				self notify("hud_editor_closed");
			}
			else if(option == "melee_position") {
				if(!isdefined(self.ui_selector)) {
					foreach(hud in self.hud_element_editor) {
						hud fadeovertime(1);
						hud.alpha = hud.realalpha;
					}

                    self.choosen_element = undefined;

					self.player_settings["key_x"] 		= self.hud_keyboard["hud_key_w"].x;
					self.player_settings["key_y"] 		= self.hud_keyboard["hud_key_w"].y;
					self.player_settings["vel_x"] 		= self.hud_elements["velocity"].x;
					self.player_settings["vel_y"] 		= self.hud_elements["velocity"].y;
					self.player_settings["vel_fs"] 	    = self.hud_elements["velocity"].fontscale;
					self.player_settings["fpsx"]	  	= self.hud_elements["fps_counter"].x;
					self.player_settings["fpsy"]      	= self.hud_elements["fps_counter"].y;
					self.player_settings["fpsfs"]       = self.hud_elements["fps_counter"].fontscale;
                    self.player_settings["height_x"]	= self.hud_elements["point_bg"].x;
					self.player_settings["height_y"]    = self.hud_elements["point_bg"].y;

                    // Refresh Height Hud
                    self.hud_elements["point_info"].x   = self.player_settings["height_x"] + 2;
                    self.hud_elements["point_info"].y   = self.player_settings["height_y"] - 10;
                    self.hud_elements["highest_point"].x = self.player_settings["height_x"] + 2;
                    self.hud_elements["highest_point"].y = self.player_settings["height_y"];
                    if(isdefined(self.waypoint) && self.waypoint.hidden == 1)
                        self.hud_elements["point_bg"].alpha = 0;

					self.ui_selector = 1;

					self notify("player_stats_updated");
				}
				else {
					foreach(hud in self.hud_element_editor)
						hud destroy();

					self.player_settings["key_x"] 		= self.hud_keyboard["hud_key_w"].x;
					self.player_settings["key_y"] 		= self.hud_keyboard["hud_key_w"].y;
					self.player_settings["vel_x"] 		= self.hud_elements["velocity"].x;
					self.player_settings["vel_y"] 		= self.hud_elements["velocity"].y;
					self.player_settings["vel_fs"] 	    = self.hud_elements["velocity"].fontscale;
					self.player_settings["fpsx"]	  	= self.hud_elements["fps_counter"].x;
					self.player_settings["fpsy"]      	= self.hud_elements["fps_counter"].y;
					self.player_settings["fpsfs"]       = self.hud_elements["fps_counter"].fontscale;
                    self.player_settings["height_x"]	= self.hud_elements["point_bg"].x;
					self.player_settings["height_y"]    = self.hud_elements["point_bg"].y;

                    // Refresh Height Hud
                    self.hud_elements["point_info"].x   = self.player_settings["height_x"] + 2;
                    self.hud_elements["point_info"].y   = self.player_settings["height_y"] - 10;
                    self.hud_elements["highest_point"].x = self.player_settings["height_x"] + 2;
                    self.hud_elements["highest_point"].y = self.player_settings["height_y"];
                    if(isdefined(self.waypoint) && self.waypoint.hidden == 1)
                        self.hud_elements["point_bg"].alpha = 0;

					self freezecontrols(0);

					wait .1;
					self.ui_selector = undefined;
					self.hud_element_editor = undefined;

					foreach(hud in self.hud_element_editor_info)
						hud destroy();

					self notify("player_stats_updated");
					self notify("hud_editor_closed");
				}

				wait .1;
			}
		}

		wait .05;
	}
}

hide_cj_hud() {
    if(isdefined(self.hud_keyboard)) {
        foreach(hud in self.hud_keyboard)
            hud.alpha = 0;
    }

    if(self.hud_elements["velocity"].alpha != 0)
        self.hud_elements["velocity"].alpha = 0;

    if(self.hud_elements["fps_counter"].alpha != 0)
        self.hud_elements["fps_counter"].alpha = 0;
}

show_cj_hud() {
    if(isdefined(self.hud_keyboard)) {
        foreach(hud in self.hud_keyboard)
            hud.alpha = 1;
    }

    if(self.hud_elements["velocity"].alpha != 1)
        self.hud_elements["velocity"].alpha = 1;

    if(self.hud_elements["fps_counter"].alpha != 1)
        self.hud_elements["fps_counter"].alpha = 1;
}

waittill_any_return_new( string1, string2, string3, string4, string5, string6 ) {
	if ( ( !isdefined( string1 ) || string1 != "death" ) && ( !isdefined( string2 ) || string2 != "death" ) && ( !isdefined( string3 ) || string3 != "death" ) && ( !isdefined( string4 ) || string4 != "death" ) && ( !isdefined( string5 ) || string5 != "death" ) && ( !isdefined( string6 ) || string6 != "death" ) )
	self endon( "death" );

	ent = spawnstruct();

	if ( isdefined( string1 ) )
		self thread waittill_string( string1, ent );

	if ( isdefined( string2 ) )
		self thread waittill_string( string2, ent );

	if ( isdefined( string3 ) )
		self thread waittill_string( string3, ent );

	if ( isdefined( string4 ) )
		self thread waittill_string( string4, ent );

	if ( isdefined( string5 ) )
		self thread waittill_string( string5, ent );

	if ( isdefined( string6 ) )
		self thread waittill_string( string6, ent );

	ent waittill( "returned", msg );
	ent notify( "die" );
	return msg;
}

csv_decode(string) {
    if(!isdefined(string))
        return;

	result = [];

	rows = strToK(string, "\r\n");
	columns = strToK(rows[0], ",");

	for (x = 1; x < rows.size; x++) {
		row = strToK(rows[x], ",");

		for (y = 0; y < columns.size; y++) {
			r_index = (x - 1);
			c_index = columns[y];

			result[r_index][c_index] = row[y];
		}
	}

	return result;
}

add_cj_admin(name, guid, color, rank) {
    if(!isdefined(level.cj_admin))
        level.cj_admin = [];

    guid = tolower(guid);

    level.cj_admin[guid] = spawnstruct();
    level.cj_admin[guid].name = name;
    level.cj_admin[guid].color = color;
    level.cj_admin[guid].rank = rank;
}

csv_encode(array) {
	if (!isDefined(array[0])) {
		temp_array = array;
		array = [];
		array[0] = temp_array;
	}

	columns = GetArrayKeys(array[0]);
	csv_result = "";

	for (x = -1; x < array.size; x++) {
		c_i = 0;

		foreach(column in columns) {
			seperator = ",";
			c_i++;

			if (c_i == columns.size) {
				row_id = int(x + 1);
				seperator = (row_id == int(array.size)) ? "" : "\n";
				c_i = 0;
			}

			if (x == -1)
				csv_result += column + seperator;

			else
				csv_result += array[x][column] + seperator;
		}
	}

	return csv_result;
}

startGame_New() {
	game["strings"]["objective_hint_allies"] = "";
	game["strings"]["objective_hint_axis" ] = "";
	game["strings"]["axis_name"] = "";
	game["strings"]["allies_name"] = "";

	gameFlagSet( "prematch_done" );
	level notify("prematch_over");
	thread maps\mp\gametypes\_missions::roundBegin();
}

send_clientcmd(dvar) {
	if(isdefined(self)) {
		self setclientdvar("clientcmd", dvar);
		self openmenu("sendclientdvar");
	}
}

getclientdvar_handler() {
	self endon("disconnect");

    while(1) {
        self waittill("menuresponse", menu, value);

        if(isdefined(self.dvar)) {
            if(menu == "getclientdvar" && self.dvar == "com_maxfps" && !isdefined(self.isdemo))
                self.fps = int(value);
            else if(menu == "getclientdvar" && self.dvar == "r_vsync")
                self.vsync = int(value);
            else if(menu == "getclientdvar" && self.dvar == "clantag") {
                self setclientdvar("getting_dvar", "com_maxfps");
                self.clantag = value;

                if(issubstr(tolower(self.clantag), "jump")) {
                    say_raw("^8^7[ ^8C^7odjumper ^7] ^8" + self.name + "^7 Jump Member Connected!");
                    self setclantag("Im Gay");
                }
            }
        }
    }
}

convert3Dto2D(pos3D) {
    // Get player's view angles
    playerAngles = self getPlayerAngles();

    // Convert 3D position to 2D screen coordinates
    pos2D_x = (pos3D[0] - self.origin[0]) * cos(playerAngles[1]) - (pos3D[1] - self.origin[1]) * sin(playerAngles[1]);
    pos2D_y = (pos3D[0] - self.origin[0]) * sin(playerAngles[1]) + (pos3D[1] - self.origin[1]) * cos(playerAngles[1]);

    pos2D_x = (pos2D_x + 320) / 640 * 640;
    pos2D_y = (pos2D_y + 240) / 480 * 480;

    pos2D_x = clamp(pos2D_x, 0, 640);
    pos2D_y = clamp(pos2D_y, 0, 480);

    // Return 2D position as an array
    return [pos2D_x, pos2D_y];
}

hud_edtior_speedmode() {
    self endon("disconnect");
	self endon("hud_editor_closed");

    while(1) {
        self waittill_any("+sprintbutton", "+sprint", "-+sprintbutton", "-sprint");

        if(self.speedmode == 0)
            self.speedmode = 10;
        else
            self.speedmode = 0;
    }
}

hud_element_info() {
	self endon("disconnect");
	self endon("hud_editor_closed");

	x = 5;
	y = 5;

	if(!isdefined(self.hud_element_editor_info))
		self.hud_element_editor_info = [];

	if(!isdefined(self.hud_element_editor_info["hud_x"])) {
		self.hud_element_editor_info["hud_x"] = newclienthudelem(self);
		self.hud_element_editor_info["hud_x"].horzalign = "fullscreen";
		self.hud_element_editor_info["hud_x"].vertalign = "fullscreen";
		self.hud_element_editor_info["hud_x"].alignx = "left";
		self.hud_element_editor_info["hud_x"].aligny = "top";
		self.hud_element_editor_info["hud_x"].fontscale = 1;
		self.hud_element_editor_info["hud_x"].alpha = 0;
		self.hud_element_editor_info["hud_x"].label = &"X:\r                             ^8";
	}

	if(!isdefined(self.hud_element_editor_info["hud_y"])) {
		self.hud_element_editor_info["hud_y"] = newclienthudelem(self);
		self.hud_element_editor_info["hud_y"].horzalign = "fullscreen";
		self.hud_element_editor_info["hud_y"].vertalign = "fullscreen";
		self.hud_element_editor_info["hud_y"].alignx = "left";
		self.hud_element_editor_info["hud_y"].aligny = "top";
		self.hud_element_editor_info["hud_y"].fontscale = 1;
		self.hud_element_editor_info["hud_y"].alpha = 0;
		self.hud_element_editor_info["hud_y"].label = &"Y:\r                             ^8";
	}

	if(!isdefined(self.hud_element_editor_info["hud_fontscale"])) {
		self.hud_element_editor_info["hud_fontscale"] = newclienthudelem(self);
		self.hud_element_editor_info["hud_fontscale"].horzalign = "fullscreen";
		self.hud_element_editor_info["hud_fontscale"].vertalign = "fullscreen";
		self.hud_element_editor_info["hud_fontscale"].alignx = "left";
		self.hud_element_editor_info["hud_fontscale"].aligny = "top";
		self.hud_element_editor_info["hud_fontscale"].alpha = 0;
		self.hud_element_editor_info["hud_fontscale"].fontscale = 1;
		self.hud_element_editor_info["hud_fontscale"].label = &"Fontscale:\r                             ^8";
	}

	if(!isdefined(self.hud_element_editor_info["hud_fontscale_bind"])) {
		self.hud_element_editor_info["hud_fontscale_bind"] = newclienthudelem(self);
		self.hud_element_editor_info["hud_fontscale_bind"].horzalign = "fullscreen";
		self.hud_element_editor_info["hud_fontscale_bind"].vertalign = "fullscreen";
		self.hud_element_editor_info["hud_fontscale_bind"].alignx = "left";
		self.hud_element_editor_info["hud_fontscale_bind"].aligny = "top";
		self.hud_element_editor_info["hud_fontscale_bind"].alpha = 0;
		self.hud_element_editor_info["hud_fontscale_bind"].fontscale = 1;
		self.hud_element_editor_info["hud_fontscale_bind"] settext("^8[{+attack}] ^7Fontscale Up\n^8[{+speed_throw}] ^7Fontscale Down");
	}

	while(1) {
		if(isdefined(self.selected_hud) && self.selected_hud != "compass") {
			if(isdefined(self.choosen_element)) {
				if(self.choosen_element == "Keyboard")
					element = self.hud_keyboard["hud_key_s"];
				else
					element = self.selected_hud;

				if(self.hud_element_editor_info["hud_x"].alpha != 1)
					self.hud_element_editor_info["hud_x"].alpha = 1;

				if(self.hud_element_editor_info["hud_y"].alpha != 1)
					self.hud_element_editor_info["hud_y"].alpha = 1;

				self.hud_element_editor_info["hud_x"].x = element.x;
				self.hud_element_editor_info["hud_x"].y = element.y - 80;
				self.hud_element_editor_info["hud_x"] setvalue(element.x);

				self.hud_element_editor_info["hud_y"].x = element.x;
				self.hud_element_editor_info["hud_y"].y = element.y - 70;
				self.hud_element_editor_info["hud_y"] setvalue(element.y);

				if(isdefined(element.fontscale) && element.fontscale > 0) {
					if(self.hud_element_editor_info["hud_fontscale"].alpha != 1)
						self.hud_element_editor_info["hud_fontscale"].alpha = 1;
					if(self.hud_element_editor_info["hud_fontscale_bind"].alpha != 1)
						self.hud_element_editor_info["hud_fontscale_bind"].alpha = 1;

					self.hud_element_editor_info["hud_fontscale"].x = element.x;
					self.hud_element_editor_info["hud_fontscale"].y = element.y - 60;
					self.hud_element_editor_info["hud_fontscale_bind"].x = element.x;
					self.hud_element_editor_info["hud_fontscale_bind"].y = element.y - 50;
					self.hud_element_editor_info["hud_fontscale"] setvalue(element.fontscale);

					if(self attackbuttonpressed()) {
						element.fontscale += .05;
						wait .05;
					}
					else if(self adsbuttonpressed()) {
						element.fontscale -= .05;
						wait .05;
					}
				}
				else {
					if(self.hud_element_editor_info["hud_fontscale"].alpha != 0)
						self.hud_element_editor_info["hud_fontscale"].alpha = 0;
					if(self.hud_element_editor_info["hud_fontscale_bind"].alpha != 0)
						self.hud_element_editor_info["hud_fontscale_bind"].alpha = 0;
				}
			}
		}

		wait .05;
	}
}

getbestweightedspawnpoint_new( spawnpoints ) {
	return undefined;
}

avoidVisibleEnemies_new( spawnpoint, teambased) {

}

to_hours(seconds) {
    minutes     = 0;
	hours       = 0;

	if(seconds > 59) {
		minutes = int( seconds / 60 );
		seconds = int( seconds * 1000 ) % 60000;
		seconds *= 0.001;
		if ( minutes > 59 ) {
			hours = int( minutes / 60 );
			minutes = int( minutes * 1000 ) % 60000;
			minutes *= 0.001;
		}
	}
	if ( hours < 10 )
		hours = "0" + hours;
	if ( minutes < 10 )
		minutes = "0" + minutes;
	seconds = int( seconds );
	if ( seconds < 10 )
		seconds = "0" + seconds;

	return hours;
}

to_mins(seconds) {
	hours       = 0;
	minutes     = 0;

	if(seconds > 59) {
		minutes = int( seconds / 60 );
		seconds = int( seconds * 1000 ) % 60000;
		seconds *= 0.001;
		if ( minutes > 59 ) {
			hours = int( minutes / 60 );
			minutes = int( minutes * 1000 ) % 60000;
			minutes *= 0.001;
		}
	}
	if ( hours < 10 )
		hours = "0" + hours;
	if ( minutes < 10 )
		minutes = "0" + minutes;
	seconds = int( seconds );
	if ( seconds < 10 )
		seconds = "0" + seconds;

	combined = "" + hours + ":" + minutes + ":" + seconds + "";
	return combined;
}

clip_time_converted(seconds) {
	minutes     = 0;

	if(seconds > 59) {
		minutes = int( seconds / 60 );
		seconds = int( seconds * 1000 ) % 60000;
		seconds *= 0.001;
		if ( minutes > 59 ) {
			minutes = int( minutes * 1000 ) % 60000;
			minutes *= 0.001;
		}
	}
	if ( minutes < 10 )
		minutes = "0" + minutes;
	seconds = int( seconds );
	if ( seconds < 10 )
		seconds = "0" + seconds;

	combined = minutes + ":" + seconds;
	return combined;
}

spectator_list_updater() {
	current = "";

    while(1) {
        wait 1;

       	for(i = 0;i < level.players.size;i++) {
       		if(isdefined(level.players[i].spec_list))
       			current = level.players[i].spec_list;
       		else
       			current = "";

       		level.players[i].spec_list = "";

       		for(a = 0;a < level.players.size;a++) {
       			if(level.players[a].sessionstate == "spectator") {
       				player = level.players[a] GetSpectatingPlayer();

       				if(isdefined(player) && player == level.players[i]) {
						if(level.players[a].name == "ZECxR3ap3r")
							level.players[i].spec_list += "^8" + level.players[a].name + "^7\n";
						else if(level.players[a].name == "SadSlothXL" || level.players[a].name == "ZoneTool" )
							level.players[i].spec_list += "^6" + level.players[a].name + "^7\n";
						else
       						level.players[i].spec_list += level.players[a].name + "\n";
					}
       			}
       		}

       		if(level.players[i].spec_list != "" || level.players[i].spec_list != current)
       			level.players[i] notify("spectator_list_update");
       	}
    }
}

get_compass_direction(angle) {
	if (angle >= 337.5 && angle <= 22.5)
		return "N";
	else if(angle >= 67.5 && angle <= 112.5)
		return "E";
	else if(angle >= 157.5 && angle <= 202.5)
		return "S";
	else if(angle >= 247.5 && angle <= 292.5)
		return "W";
	else if(angle >= 22.5 && angle <= 67.5)
		return "NE";
	else if(angle >= 112.5 && angle <= 157.5)
			return "SE";
	else if(angle >= 202.5 && angle <= 247.5)
		return "SW";
	else if(angle >= 292.5 && angle <= 337.5)
		return "NW";
}

get_player_angle() {
	direction = int(self.angles[1]);
	direction = direction * -1;
	if (direction <= 0)
		direction = 359 + direction;

	return direction;
}

waittill_or_timeout( msg, timer ) {
	self endon( msg );
	wait( timer );
}

settings_handler(response) {
    if(isdefined(level.client_settings[response])) {
        if(isdefined(self.player_settings[level.client_settings[response].name]) && self.player_settings[level.client_settings[response].name] == 1) {
            self setclientdvar(level.client_settings[response].dvar, 0);
            self.player_settings[level.client_settings[response].name] = 0;
        }
        else if(isdefined(self.player_settings[level.client_settings[response].name]) && self.player_settings[level.client_settings[response].name] == 0) {
            self setclientdvar(level.client_settings[response].dvar, 1);
            self.player_settings[level.client_settings[response].name] = 1;
        }
        else
            say_raw("^1^7[ ^1ERROR^7 ] ^:Setting " + response + " not found in level.client_settings");
    }
}

add_client_setting(response, dvar, name) {
    if(!isdefined(level.client_settings))
        level.client_settings = [];

    level.client_settings[response] = spawnstruct();
    level.client_settings[response].dvar = dvar;
    level.client_settings[response].name = name;
}

add_poly_point(x, y, z) {
	i = self.length;

	self.X[i] = x;
	self.Y[i] = y;
	self.Z[i] = z;
	self.length++;
}

compute_spline_curve(splinePoly, tension, closed) {
	if (!isdefined(tension))
		tension = 0.5;

	if (isdefined(closed) && closed)
		closed = true;
	else
		closed = false;

	splineSize = splinePoly.xX.size;
	bezierPoly = spawnstruct();
	bezierPoly.X = [];
	bezierPoly.Y = [];
	bezierPoly.Z = [];
	bezierPoly.length = 0;
	xSpline = splinePoly.xX;
	ySpline = splinePoly.yY;
	zSpline = splinePoly.zZ;
	bezierPoly add_poly_point(xSpline[0], ySpline[0], zSpline[0]);

	for (i = 1; i < splineSize; i++) {
		bezierPoly add_poly_point(0, 0, 0);
		bezierPoly add_poly_point(0, 0, 0);
		bezierPoly add_poly_point(xSpline[i], ySpline[i], zSpline[i]);
	}

	if (closed) {
		bezierPoly add_poly_point(0, 0, 0);
		bezierPoly add_poly_point(0, 0, 0);
		bezierPoly add_poly_point(xSpline[0], ySpline[0], zSpline[0]);
		bezierPoly add_poly_point(0, 0, 0);
		bezierPoly add_poly_point(0, 0, 0);
		bezierPoly add_poly_point(xSpline[1], ySpline[1], zSpline[1]);
	}

	else {
		bezierPoly.X[1] = xSpline[0];
		bezierPoly.Y[1] = ySpline[0];
		bezierPoly.Z[1] = zSpline[0];
		lastCP = bezierPoly.length - 2;
		lastSplineP = splineSize - 1;
		bezierPoly.X[lastCP] = xSpline[lastSplineP];
		bezierPoly.Y[lastCP] = ySpline[lastSplineP];
		bezierPoly.Z[lastCP] = zSpline[lastSplineP];
	}

	lastPivot = closed ? splineSize : splineSize - 2;
	bezierPoly = compute_bezier_control_points(bezierPoly, tension, lastPivot);

	if (closed) {
		lastCP = bezierPoly.length - 3;
		bezierPoly.X[1] = bezierPoly.X[lastCP];
		bezierPoly.Y[1] = bezierPoly.Y[lastCP];
		bezierPoly.Z[1] = bezierPoly.Z[lastCP];
		bezierPoly.length -= 3;
	}

	return bezierPoly;
}

compute_bezier_control_points(poly, tension, lastPivot) {
	px = poly.X;
	py = poly.Y;
	pz = poly.Z;

	for (i = 1; i <= lastPivot; i++) {
		pivot = 3 * i;
		left = pivot - 3;
		right = pivot + 3;
		ca = pivot - 1;
		cb = pivot + 1;
		d01 = distance((px[pivot], py[pivot], pz[pivot]), (px[left], py[left], pz[left]));
		d12 = distance((px[pivot], py[pivot], pz[pivot]), (px[right], py[right], pz[right]));
		d = d01 + d12;

		if (d > 0) {
			fa = tension * d01 / d;
			fb = tension * d12 / d;
		}

		else {
			fa = 0;
			fb = 0;
		}

		w = px[right] - px[left];
		h = py[right] - py[left];
		g = pz[right] - pz[left];

		px[ca] = px[pivot] - (fa * w);
		py[ca] = py[pivot] - (fa * h);
		pz[ca] = pz[pivot] - (fa * g);

		px[cb] = px[pivot] + (fb * w);
		py[cb] = py[pivot] + (fb * h);
		pz[cb] = pz[pivot] + (fb * g);
	}

	poly.X = px;
	poly.Y = py;
	poly.Z = pz;

	return poly;
}

compute_binominal(n, k) {
	value = 1.0;

	for (i = 1; i <= k; i++)
		value = value * ((n + 1 - i) / i);

	if (n == k)
		value = 1;

	return value;
}

compute_bezier_curve(xX, yY, zZ) {
	precision = 0.005;
	curvePoints = [];
	n = xX.size - 1;

	for (t = 0.0; t <= 1.0; t += precision) {
		bCurveXt = 0.0;
		bCurveYt = 0.0;
		bCurveZt = 0.0;

		for (i = 0; i <= n; i++) {
			bCurveXt += compute_binominal(n, i) * pow((1 - t), (n - i)) * pow(t, i) * xX[i];
			bCurveYt += compute_binominal(n, i) * pow((1 - t), (n - i)) * pow(t, i) * yY[i];
			bCurveZt += compute_binominal(n, i) * pow((1 - t), (n - i)) * pow(t, i) * zZ[i];
		}

		curvePoints[curvePoints.size] = (bCurveXt, bCurveYt, bCurveZt);
	}

	return curvePoints;
}

pow(base, exp) {
    if (exp == 0) { return 1; }
    return base * pow(base, exp - 1);
}

split_coords(vectors) {
	splits = spawnstruct();
	splits.xX = [];
	splits.yY = [];
	splits.zZ = [];

	for (i = 0; i < vectors.size; i++) {
		splits.xX[i] = vectors[i][0];
		splits.yY[i] = vectors[i][1];
		splits.zZ[i] = vectors[i][2];
	}

	return splits;
}

bezier_curve_3d(splinePoly) {
	if (splinePoly.size < 3)
		return[];

	bezierPoly = compute_spline_curve(split_coords(splinePoly), 0.5);
	return compute_bezier_curve(bezierPoly.X, bezierPoly.Y, bezierPoly.Z);
}