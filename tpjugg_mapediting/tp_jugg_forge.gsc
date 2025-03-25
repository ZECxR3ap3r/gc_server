#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include scripts\tpjugg_mapediting\tp_jugg_map_funcs;

Init()
{
	level thread scripts\tpjugg_mapediting\tp_jugg_map_funcs::init();
	level thread scripts\tpjugg_mapediting\tp_jugg_replacefuncs::init();
	level thread scripts\tpjugg_mapediting\tp_jugg_mapedits::init();

	level.debugdeathradius = true;
	level.debugpolygon = true; // comment to disable
	// level.showinviscrates = true; //shows invis crates

	level.mapedit_filepath = getdvar("fs_homepath") + "/map_edits/" + getdvar("mapname") +".gsc";
	
	setDvar("scr_war_timelimit", "0"); 
	setDvar("scr_war_scorelimit", "0");

	level.callbackPlayerDamage = ::damage_player;

	if(!isdefined(level.ent_array_models))
		level.ent_array_models = [];

    level thread onPlayerConnect();
}

damage_player(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset) {

    if(isdefined(level.falldamagetriggers) && sMeansOfDeath == "MOD_FALLING") {
        foreach(trig in level.falldamagetriggers) {
            if(self istouching(trig)) {
                self playlocalsound("vest_deployed");
				self iprintln("^1No Falldamage");
                return;
            }
        }
    }

	maps\mp\gametypes\_damage::Callback_PlayerDamage_internal( eInflictor, eAttacker, self, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset);
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill( "connected", player );

        player thread onPlayerSpawned();	
		player thread fired_distance();
		player thread custom_move_model();

		player SetClientDvar("lowAmmoWarningColor1", "0 0 0 0");
		player SetClientDvar("lowAmmoWarningColor2", "0 0 0 0");
		player SetClientDvar("lowAmmoWarningNoAmmoColor1", "0 0 0 0");
		player SetClientDvar("lowAmmoWarningNoAmmoColor2", "0 0 0 0");
		player SetClientDvar("lowAmmoWarningNoReloadColor1", "0 0 0 0");
		player SetClientDvar("lowAmmoWarningNoReloadColor2", "0 0 0 0");

        player SetClientDvar("cg_teamcolor_allies", ".7 .2 .4 1");
        player SetClientDvar("cg_teamcolor_axis", ".7 .2 .4 1");
	}
}

fired_distance() {
    p1         = undefined;
    p2         = undefined;
    change     = undefined;
    for(;;) {
        self waittill("weapon_fired", weapname);
        if(self GetStance() == "crouch") {
            ang_forward = AnglesToForward(self getplayerangles());
            p1 = BulletTrace(self geteye(), self geteye() + ang_forward * 1000, 0, self);
            self iprintlnbold("^3" + p1["position"]);
            self waittill("weapon_fired", weapname);
            ang_forward = AnglesToForward(self getplayerangles());
            p2 = BulletTrace(self geteye(), self geteye() + ang_forward * 1000, 0, self);
            self iprintlnbold("^;" + p2["position"]);
            wait 1;
            change = (p2["position"] - p1["position"]);
            print("^2" + change);
            self iprintlnbold("^2" + change);
        }
    }
}

onPlayerSpawned()
{
	self endon("disconnect");
	for(;;)
	{
		self waittill("spawned_player");

		self freezecontrols(false);
		self TakeAllWeapons();
		self giveweapon("iw5_mp412_mp");
		self giveweapon("iw5_msr_mp_msrscope");
		self setspawnweapon("iw5_mp412_mp");
		wait 0.05;
		self maps\mp\killstreaks\_killstreaks::clearKillstreaks();
		self setPlayerData( "killstreaks", 0, "none" );
	    self setPlayerData( "killstreaks", 1, "none" );
	    self setPlayerData( "killstreaks", 2, "none" );
        self maps\mp\gametypes\_class::setKillstreaks( "none", "none", "none" );
		self ClearPerks();
	}
}

func_deathradius(position, angles)
{
	pos1 = flatass(position);
	pos2 = (pos1[0], pos1[1], pos1[2] - 15);
	add_to_ent_array_and_logprint("Deathradius(" + pos2 + ", 100 , 100);");

	Deathradius(pos2, 100, 100);
}

func_nofall(position, angles)
{
	pos1 = flatass(position);
	pos2 = (pos1[0], pos1[1], pos1[2] - 15);
	add_to_ent_array_and_logprint("fufalldamage(" + pos2 + ", 150 , 150);");

	fufalldamage(pos2, 150, 150);
}

func_block(position, angles)
{
	pos1 = flatass(position);
	pos2 = (pos1[0], pos1[1], pos1[2] - 15);
	ang = flatass(angles);
	add_to_ent_array_and_logprint("spawncrate(" + pos2 + ", " + ang + ",\"com_plasticcase_friendly\");");
	spawncrate(pos2, ang, "com_plasticcase_friendly");
}

func_logpos(position, angles)
{
	pos1 = flatass(position);
	ang1 = flatass(angles);
	print("^1Position: " + pos1);
	print("^3Angles: " + ang1);
	logprint("^1Position: " + pos1);
	logprint("^3Angles: " + ang1);
}

func_heightdiff(origin1, origin2, angles)
{
	diff = origin2[2] - origin1[2];
	print("Height Difference : " + diff);
	logprint("Height Difference : " + diff);
	iprintln("Height Difference : " + diff);
}


func_quicksteps(origin1, origin2, angles)
{
	pos1 = flatass(origin1);
	pos2 = flatass(origin2);
	pos1 = (pos1[0], pos1[1], pos1[2] - 15);
	pos2 = (pos2[0], pos2[1], pos2[2] - 15);
	height = pos1[2] - pos2[2];
	
	add_to_ent_array_and_logprint("CreateQuicksteps(" + pos1 + "," + height + ", 15, 2, " + angles + ");");

	CreateQuicksteps(pos1, height, 15, 2, angles);
}

func_wall(origin1, origin2, angles)
{
	pos1 = flatass(origin1);
	pos2 = flatass(origin2);
	pos1 = (pos1[0], pos1[1], pos1[2] + 10);
	pos2 = (pos2[0], pos2[1], pos2[2] + 10);
	
	add_to_ent_array_and_logprint("CreateWalls(" + pos1 + "," + pos2 + ");");

	createwalls(origin1, origin2);
}

func_cannon(origin1, origin2, origin3, angles)
{
	pos1 = flatass(origin1);
	pos2 = flatass(origin2);
	pos3 = flatass(origin3);
	pos1 = (pos1[0], pos1[1], pos1[2] - 15);
	pos2 = (pos2[0], pos2[1], pos2[2] + 88);
	height = pos3[2] - pos1[2];
	
	add_to_ent_array_and_logprint("cannonball(" + pos1 + "," + angles + ", 3 ," + pos2 + "," + height + ");");
	
	cannonball(pos1, angles, 3, pos2, height);
}

func_door(origin1, origin2, angles)
{
	pos1 = flatass(origin1);
	pos2 = flatass(origin2);
	pos1 = (pos1[0], pos1[1], pos1[2] + 10);
	pos2 = (pos2[0], pos2[1], pos2[2] + 10);
	ang  = flatass(angles) + (90,0,0);
	
	add_to_ent_array_and_logprint("CreateDoors(" + pos2 + "," + pos1 + "," + ang + ", 3, 2, 20, 140, true);");

	CreateDoors(pos2, pos1, ang, 3, 2, 20, 140, true);
}

func_grid(origin1, origin2, angles)
{
	pos1 = flatass(origin1);
	pos2 = flatass(origin2);
	pos3 = (pos1[0], pos1[1], pos1[2] - 15);
	pos4 = (pos2[0], pos2[1], pos1[2] - 15);

	add_to_ent_array_and_logprint("CreateGrids(" + pos3 + "," + pos4 + ", (0,0,0));");

	self CreateGrids(pos3, pos4, (0,0,0));
}

func_ramp(origin1, origin2, angles)
{
	pos1 = flatass(origin1);
	pos2 = flatass(origin2);
	pos1 = (pos1[0], pos1[1], pos1[2] - 18);
	pos2 = (pos2[0], pos2[1], pos2[2] - 18);

	add_to_ent_array_and_logprint("CreateRamps(" + pos1 + "," + pos2 + ");");

	self CreateRamps(origin1, origin2);
}

func_flag(origin1, origin2, angles)
{
	pos1 = flatass(origin1);
	angle = self.angles;
	pos2 = flatass(origin2);

	add_to_ent_array_and_logprint("CreateTP(" + pos1 + "," + pos2 + ");");

	self CreateTP(pos1, pos2);
}

func_hiddenflag(origin1, origin2, angles)
{
	pos1 = flatass(origin1);
	pos2 = flatass(origin2);

	add_to_ent_array_and_logprint("CreateHiddenTP(" + pos1 + "," + pos2 +");");

	CreateHiddenTP(pos1, pos2);
}

add_to_ent_array_and_logprint(string) {
	level.ent_array_models[level.ent_array_models.size] = string;
	logprint(string);
}

flatass(org)
{
	yes = (floor(org[0]),floor(org[1]),floor(org[2]));
	return yes;
}

roundUp( floatVal ) // rounds up
{
	if ( int( floatVal ) != floatVal )
		return int( floatVal+1 );
	else
		return int( floatVal );
}

custom_move_model() {
	self endon("disconnect");

	self notifyOnPlayerCommand("toggle_bring", "+reload");
	self notifyOnPlayerCommand("stop_toggle_bring", "-reload");
	self notifyOnPlayerCommand("copy_model", "+attack");
	self notifyOnPlayerCommand("stop_copy_model", "-attack");
	self notifyOnPlayerCommand("copy_model_2", "+actionslot 7");
	self notifyOnPlayerCommand("stop_copy_model", "-actionslot 7");
	self notifyOnPlayerCommand("toggle_move", "+activate");
	self notifyOnPlayerCommand("stop_toggle_move", "-activate");

	self notifyOnPlayerCommand("angle_mode", "+actionslot 4");
	self notifyOnPlayerCommand("spawn_mode", "+actionslot 5");

	self notifyOnPlayerCommand("print_models", "+actionslot 6");
	
	self notifyOnPlayerCommand("forward", "+forward");
	self notifyOnPlayerCommand("back", "+back");
	self notifyOnPlayerCommand("left", "+moveleft");
	self notifyOnPlayerCommand("right", "+moveright");
	self notifyOnPlayerCommand("up", "+melee");
	self notifyOnPlayerCommand("down", "+smoke");

	self notifyOnPlayerCommand("speed_up", "+actionslot 2");
	self notifyOnPlayerCommand("speed_down", "+actionslot 1");

	level.menu_strings = [];
	level.menu_strings[level.menu_strings.size] = "F - ^3[{+forward}]^7\nB - ^3[{+back}]^7\nL - ^3[{+moveleft}]^7\nR - ^3[{+moveright}]^7\nUp - ^3[{+melee}]^7\nDown - ^3[{+smoke}]^7\n\nSpd Up - ^3[{+actionslot 2}]^7\nSpd Down - ^3[{+actionslot 1}]^7\n\nBring Mode - ^3[{+reload}]^7\nMove Mode - ^3[{+activate}]^7\nAngle Mode - ^3[{+actionslot 4}]^7\n\nForge Mode - ^3[{+actionslot 5}]^7\nCopy Model - ^3[{+attack}]^7/^3[{+actionslot 7}]^7\nPrint Models - ^3[{+actionslot 6}]^7";
	level.menu_strings[level.menu_strings.size] = "Return - ^3[{+actionslot 7}]^7\nSet Position - ^3[{+reload}]^7\nSelection Up - ^3[{+activate}]^7\nSelection Down - ^3[{+frag}]^7\n\n";

	make_forge_funcs("Crate", ::func_block, 1, "^3Spawned Crate");
	make_forge_funcs("Wall", ::func_wall, 2, "^3Spawned Wall");
	make_forge_funcs("Grid", ::func_grid, 2, "^3Spawned Grid");
	make_forge_funcs("Ramp", ::func_ramp, 2, "^3Spawned Ramp");
	make_forge_funcs("Door", ::func_door, 2, "^3Spawned Door");
	make_forge_funcs("Quicksteps", ::func_quicksteps, 2, "^3Spawned Quicksteps");
	make_forge_funcs("Cannonball", ::func_cannon, 3, "^3Spawned Cannonball");
	make_forge_funcs("No Falldamage", ::func_nofall, 1, "^3Spawned No Falldamage Area");
	make_forge_funcs("Death Radius", ::func_deathradius, 1, "^3Spawned Death Radius");
	make_forge_funcs("Normal Flag", ::func_flag, 2, "^3Spawned Normal Flag");
	make_forge_funcs("Hidden Flag", ::func_hiddenflag, 2, "^3Spawned Hidden Flag");
	make_forge_funcs("Log Position", ::func_logpos, 1, "^3Logged Position");
	make_forge_funcs("Height Difference", ::func_heightdiff, 2, "^3Logged Height Difference");


	if(!isdefined(self.forge_label)) {
		self.forge_label = newclienthudelem(self);
		self.forge_label.horzalign = "fullscreen";
		self.forge_label.vertalign = "fullscreen";
		self.forge_label.alignx = "left";
		self.forge_label.aligny = "top";
		self.forge_label.x = 10;
		self.forge_label.y = 110;
		self.forge_label.alpha = 1;
		self.forge_label.archived = false;
		self.forge_label.hidewheninmenu = true;
		self.forge_label.fontscale = 0.9;
		self.forge_label.font = "objective";
		self.forge_label.color = (0.7,0.2,0.4);
		self.forge_label settext(level.menu_strings[0]);
	}


	self.current_mode = "undefined";
	self.move_ent = undefined;
	self.model_move_speed = 5;
	self.angle_mode = false;
	self.freeze_ent = spawn("script_origin",self.origin);

	self thread model_move_actions();

	for(;;) {
		response = custom_waittill_any_return("forward","back","left","right","up","down");

		if(isdefined(self.move_ent) && self.current_mode == "move"){
			if(!self.angle_mode) {
				if(response == "forward") {
					self.move_ent.origin = flatass(self.move_ent.origin + (self.model_move_speed,0,0));
				} else if(response == "back") {
					self.move_ent.origin = flatass(self.move_ent.origin + (self.model_move_speed*-1,0,0));
				} else if(response == "left") {
					self.move_ent.origin = flatass(self.move_ent.origin + (0,self.model_move_speed,0));
				} else if(response == "right") {
					self.move_ent.origin = flatass(self.move_ent.origin + (0,self.model_move_speed*-1,0));
				} else if(response == "up") {
					self.move_ent.origin = flatass(self.move_ent.origin + (0,0,self.model_move_speed));
				} else if(response == "down") {
					self.move_ent.origin = flatass(self.move_ent.origin + (0,0,self.model_move_speed*-1));
				}
			} else if(self.angle_mode) {
				if(response == "forward") {
					self.move_ent.angles = self.move_ent.angles + (ceil(self.model_move_speed),0,0);
				} else if(response == "back") {
					self.move_ent.angles = self.move_ent.angles + (ceil(self.model_move_speed)*-1,0,0);
				} else if(response == "left") {
					self.move_ent.angles = self.move_ent.angles + (0,ceil(self.model_move_speed),0);
				} else if(response == "right") {
					self.move_ent.angles = self.move_ent.angles + (0,ceil(self.model_move_speed)*-1,0);
				} else if(response == "up") {
					self.move_ent.angles = self.move_ent.angles + (0,0,ceil(self.model_move_speed));
				} else if(response == "down") {
					self.move_ent.angles = self.move_ent.angles + (0,0,ceil(self.model_move_speed)*-1);
				}
				self iprintln(self.move_ent.angles);
			}
		}
	}
}

make_forge_funcs(string, function, points, string2) {
	if(!isdefined(level.forge_functions_list)) 
		level.forge_functions_list = [];

	index = level.forge_functions_list.size;
	
	level.forge_functions_list[index] = spawnstruct();
	level.forge_functions_list[index].name = string;
	level.forge_functions_list[index].function = function;
	level.forge_functions_list[index].points = points;
	if(isdefined(string2))
		level.forge_functions_list[index].end_string = string2;
}

spawn_mode() {
	self notifyOnPlayerCommand("place_pos", "+reload");
	self notifyOnPlayerCommand("selection_up", "+activate");
	self notifyOnPlayerCommand("selection_down", "+frag");
	self notifyOnPlayerCommand("return_menu", "+actionslot 7");

	self.selection = 0;
	self reset_positions();

	self adjust_selection();

	for(;;) {
		response = custom_waittill_any_return("place_pos","selection_up","selection_down","return_menu");
		if(response == "return_menu") {
			self reset_positions();
			self.forge_label settext(level.menu_strings[0]);
			return;
		} else if(response == "place_pos") {
			if(level.forge_functions_list[self.selection].points == 1) {
				self.pos_1 = self.origin;
				self.ang_1 = self.angles;
				self [[level.forge_functions_list[self.selection].function]](self.pos_1, self.ang_1);
				self reset_positions();
				if(isdefined(level.forge_functions_list[self.selection].end_string))
					self iprintlnbold(level.forge_functions_list[self.selection].end_string);
			} else if(level.forge_functions_list[self.selection].points > 1 && self.pos_1 == (0,0,0)) {
				self.pos_1 = self.origin;
				self.ang_1 = self.angles;
				self iprintln("Position 1 Set");
			} else if(level.forge_functions_list[self.selection].points >= 2) {
				if(level.forge_functions_list[self.selection].points == 2 && self.pos_2 == (0,0,0)) {
					self.pos_2 = self.origin;
					self [[level.forge_functions_list[self.selection].function]](self.pos_1, self.pos_2, self.ang_1);
					self reset_positions();
					if(isdefined(level.forge_functions_list[self.selection].end_string))
						self iprintlnbold(level.forge_functions_list[self.selection].end_string);
				} else if(level.forge_functions_list[self.selection].points > 2 && self.pos_2 == (0,0,0)) {
					self.pos_2 = self.origin;
					self iprintln("Position 2 Set");
				} else if(level.forge_functions_list[self.selection].points == 3 && self.pos_3 == (0,0,0)) {
					self.pos_3 = self.origin;
					self [[level.forge_functions_list[self.selection].function]](self.pos_1, self.pos_2, self.pos_3, self.ang_1);
					self reset_positions();
					if(isdefined(level.forge_functions_list[self.selection].end_string))
						self iprintlnbold(level.forge_functions_list[self.selection].end_string);
				}
			}
		} else if(response == "selection_up") {
			self reset_positions();

			self.selection--;
			if(self.selection < 0)
				self.selection = level.forge_functions_list.size-1;
			self iprintlnbold("^8Selected ^3" + level.forge_functions_list[self.selection].name);
			self adjust_selection();
		} else if(response == "selection_down") {
			self reset_positions();

			self.selection++;
			if(self.selection > level.forge_functions_list.size-1)
				self.selection = 0;
			self iprintlnbold("^8Selected ^3" + level.forge_functions_list[self.selection].name);
			self adjust_selection();
		} 
	}
}

sel_next(index, length, incr) {
    d = (index + length + incr) % length;
	return d;
}

sel_prev(index, length, decr) {
    d = (index + length - decr) % length;
	return d;
}

adjust_selection() {
	temp_string = level.menu_strings[1];

	temp_string = temp_string + "-- " +level.forge_functions_list[sel_prev(self.selection, level.forge_functions_list.size, 2)].name + "^7\n";
	temp_string = temp_string + "-- " +level.forge_functions_list[sel_prev(self.selection, level.forge_functions_list.size, 1)].name + "^7\n";
	temp_string = temp_string + "^3-> " + level.forge_functions_list[self.selection].name + "^7\n";
	temp_string = temp_string + "-- " +level.forge_functions_list[sel_next(self.selection, level.forge_functions_list.size, 1)].name + "^7\n";
	temp_string = temp_string + "-- " +level.forge_functions_list[sel_next(self.selection, level.forge_functions_list.size, 2)].name + "^7\n";


	// for(i=0;i<level.forge_functions_list.size;i++)  {
	// 	if(self.selection == i)
	// 		temp_string = temp_string + level.forge_functions_list[i].name + " ^3<--- ^7\n";
	// 	else
	// 		temp_string = temp_string + level.forge_functions_list[i].name + "^7\n";
	// }
	self.forge_label settext(temp_string);
}

reset_positions() {
	self.pos_1 = (0,0,0);
	self.pos_2 = (0,0,0);
	self.pos_3 = (0,0,0);
	self.ang_1 = (0,0,0);
}

model_move_actions() {
	self endon("disconnect");
	for(;;) {
		response = custom_waittill_any_return("copy_model","copy_model_2","toggle_bring","toggle_move","speed_up", "speed_down", "angle_mode", "print_models", "spawn_mode");
		time = gettime();
		if(response == "spawn_mode") {
			self iprintlnbold("^3Forge Mode ^8- " + self.angle_mode);
			self spawn_mode();
		}

		if(response == "angle_mode") {
			self.angle_mode = !self.angle_mode;
			self iprintlnbold("^3Angle Mode ^8- " + self.angle_mode);
		}

		if(response == "print_models") {
			self write_models_location();
			self iprintlnbold("Printed All Moved Ents");
		}


		if(response == "speed_up") {
			self.model_move_speed = min(10, self.model_move_speed + 1);
			self iprintlnbold(self.model_move_speed);
		} else if(response == "speed_down") {
			self.model_move_speed = max(1, self.model_move_speed - 1);
			self iprintlnbold(self.model_move_speed);
		}

		if(response == "copy_model" || response == "copy_model_2") {
			if(isdefined(self.move_ent))
				continue;
			self waittill("stop_copy_model");
			if(gettime() - time > 800 && response == "copy_model_2") {
				copying_ent = undefined;
				list = GetEntArray("script_model", "classname");
				foreach(item in list) {
					if(!isdefined(copying_ent) || distance(self geteye(), item.origin) < distance(self geteye(), copying_ent.origin)) {
						copying_ent = item;
					}
				}
				ent = spawn("script_model", self.origin);
				ent setmodel(copying_ent.model);
				ent.angles = copying_ent.angles;
				ent thread add_to_ent_array();
				self iprintlnbold("^3Copied ^7- ^8" + copying_ent.model);
			} else {
				forward = anglestoforward(self getplayerangles());
				eye = self geteye();
				trace = BulletTrace(eye, eye + forward * 3000, 0, self, 1, 1);

				if(isdefined(trace["entity"])) {
					// if(isdefined(trace["entity"].classname && trace["entity"].classname == "script_brushmodel")) {
						// self iprintlnbold("^3Copied ^8- ^1Brushmodel");
						// ent = spawn("script_model", self.origin);
						// ent.angles = trace["entity"].angles;
						// ent CloneBrushmodelToScriptmodel(trace["entity"]);
						// ent thread add_to_ent_array();
					// }
					// else {
						ent = spawn("script_model", self.origin);
						ent setmodel(trace["entity"].model);
						ent.angles = trace["entity"].angles;
						ent thread add_to_ent_array();
						self iprintlnbold("^3Copied ^7- ^8" + ent.model);
					// }
				}
			}
		}


		if(response == "toggle_move" && self.current_mode != "bring") {
			self waittill("stop_toggle_move");
			if(gettime() - time > 800) {
				if(isdefined(self.move_ent) && self.current_mode == "move") {
					self iprintlnbold("^1Stopped ^7Moving - ^8" + self.move_ent.model);
					self.move_ent = undefined;
					self.current_mode = "undefined";
					self.freeze_ent.origin = self.origin;
					self unlink();
				} else {
					brushmodel = undefined;
					moving_ent = undefined;
					list = GetEntArray("script_model", "classname");
					foreach(item in list) {
						if(!isdefined(moving_ent) || distance(self geteye(), item.origin) < distance(self geteye(), moving_ent.origin)) {
							moving_ent = item;
						}
					}
					list = GetEntArray("script_brushmodel", "classname");
					foreach(item in list) {
						if(!isdefined(moving_ent) || distance(self geteye(), item.origin) < distance(self geteye(), moving_ent.origin)) {
							moving_ent = item;
							brushmodel = true;
						}
					}
					if(isdefined(brushmodel)) {
						print(moving_ent.classname);
						print(moving_ent.targetname);
						print(moving_ent.origin);
						print(moving_ent.angles);
						self iprintlnbold("^2Now ^7Bringing - ^8" + moving_ent.targetname);
					}
					else 
						self iprintlnbold("^2Now ^7Bringing - ^8" + moving_ent.model);
					self.move_ent = moving_ent;
					self.move_ent thread add_to_ent_array();
					self iprintlnbold("^2Now ^7Moving - ^8" + moving_ent.model);
					self.current_mode = "move";
					self.freeze_ent.origin = self.origin;
					self playerlinkto(self.freeze_ent);
				}
			} else {
				forward = anglestoforward(self getplayerangles());
				eye = self geteye();
				trace = BulletTrace(eye, eye + forward * 3000, 0, self, 1, 1);
				if(isdefined(self.move_ent) && self.current_mode == "move") {
					self iprintlnbold("^1Stopped ^7Moving - ^8" + self.move_ent.model);
					self.move_ent = undefined;
					self.current_mode = "undefined";
					self.freeze_ent.origin = self.origin;
					self unlink();
				} else if(isdefined(trace["entity"]) && isdefined(trace["entity"].model)) {
					self.move_ent = trace["entity"];
					self.move_ent thread add_to_ent_array();
					self iprintlnbold("^2Now ^7Moving - ^8" + trace["entity"].model);
					self.current_mode = "move";
					self.freeze_ent.origin = self.origin;
					self playerlinkto(self.freeze_ent);
				}
			}
		}

		if(response == "toggle_bring" && self.current_mode != "move") {
			self waittill("stop_toggle_bring");
			if(gettime() - time > 800) {
				brushmodel = undefined;
				if(isdefined(self.move_ent) && self.current_mode == "bring") {
					self iprintlnbold("^1Stopped ^7Bringing - ^8" + self.move_ent.model);
					self notify("stop_bring_logic");
					self.move_ent = undefined;
					self.current_mode = "undefined";
				} else {
					bringing_ent = undefined;
					list = GetEntArray("script_model", "classname");
					foreach(item in list) {
						if(!isdefined(bringing_ent) || distance(self geteye(), item.origin) < distance(self geteye(), bringing_ent.origin)) {
							bringing_ent = item;
						}
					}
					list = GetEntArray("script_brushmodel", "classname");
					foreach(item in list) {
						if(!isdefined(bringing_ent) || distance(self geteye(), item.origin) < distance(self geteye(), bringing_ent.origin)) {
							bringing_ent = item;
							brushmodel = true;
						}
					}
					if(isdefined(brushmodel)) {
						print(bringing_ent.classname);
						print(bringing_ent.targetname);
						print(bringing_ent.origin);
						print(bringing_ent.angles);
						self iprintlnbold("^2Now ^7Bringing - ^8" + bringing_ent.targetname);
					}
					else 
						self iprintlnbold("^2Now ^7Bringing - ^8" + bringing_ent.model);
					self.move_ent = bringing_ent;
					self.move_ent thread add_to_ent_array();
					self.current_mode = "bring";
					self thread bring_logic();
				}
			} else {
				forward = anglestoforward(self getplayerangles());
				eye = self geteye();
				trace = BulletTrace(eye, eye + forward * 3000, 0, self, 1, 1);
				if(isdefined(self.move_ent) && self.current_mode == "bring") {
					self iprintlnbold("^1Stopped ^7Bringing - ^8" + self.move_ent.model);
					self notify("stop_bring_logic");
					self.move_ent = undefined;
					self.current_mode = "undefined";
				} else if(isdefined(trace["entity"]) && isdefined(trace["entity"].model)) {
					self.move_ent = trace["entity"];
					self.move_ent thread add_to_ent_array();
					self iprintlnbold("^2Now ^7Bringing - ^8" + trace["entity"].model);
					self.current_mode = "bring";
					self thread bring_logic();
				}
			}
		}
	}
}

write_models_location() {
	logprint("===================================================================================\n");
	for(i=0;i<level.ent_array_models.size;i++) {
		if(isstring(level.ent_array_models[i]))
			logprint(level.ent_array_models[i] + "\n");
		else if(isdefined(level.ent_array_models[i].classname) && level.ent_array_models[i].classname == "script_brushmodel") {
			logprint("clonedcollision(" + level.ent_array_models[i].origin + " , " + level.ent_array_models[i].angles + " , \"" + level.ent_array_models[i].targetname + "\");\n");
		}
		else
			logprint("spawnmodel(" + level.ent_array_models[i].origin + " , " + level.ent_array_models[i].angles + " , \"" + level.ent_array_models[i].model + "\");\n");
	}
	logprint("===================================================================================\n");
}

/*
write_models_location() {
	level.mapedit_file = fopen(level.mapedit_filepath, "w");
	for(i=0;i<level.ent_array_models.size;i++) {
		if(isstring(level.ent_array_models[i]))
			fwrite(level.mapedit_file, level.ent_array_models[i] + "\n");
		else if(isdefined(level.ent_array_models[i].classname) && level.ent_array_models[i].classname == "script_brushmodel") {
			fwrite(level.mapedit_file,"clonedcollision(" + level.ent_array_models[i].origin + " , " + level.ent_array_models[i].angles + " , \"" + level.ent_array_models[i].targetname + "\");\n");
		}
		else
			fwrite(level.mapedit_file,"spawnmodel(" + level.ent_array_models[i].origin + " , " + level.ent_array_models[i].angles + " , \"" + level.ent_array_models[i].model + "\");\n");
	}
	fclose(level.mapedit_file);
}
*/

add_to_ent_array() {

	dupe = false;
	for(i=0;i<level.ent_array_models.size;i++) {
		if(!isstring(level.ent_array_models[i]) && self == level.ent_array_models[i])
			dupe = true;
	}
	
	if(!dupe)
		level.ent_array_models[level.ent_array_models.size] = self;
}

bring_logic() {
	self endon("stop_bring_logic");
	offset = flatass(self.move_ent.origin - self.origin);
	for(;;) {
		wait 0.05;
		self.move_ent.origin = flatass(self.origin + offset);
	}
}


custom_waittill_any_return( string1, string2, string3, string4, string5, string6, string7, string8, string9)
{
	// if ( ( !isdefined( string1 ) || string1 != "death" ) &&
	// ( !isdefined( string2 ) || string2 != "death" ) &&
	// ( !isdefined( string3 ) || string3 != "death" ) &&
	// ( !isdefined( string4 ) || string4 != "death" ) &&
	// ( !isdefined( string5 ) || string5 != "death" ) &&
	// ( !isdefined( string6 ) || string6 != "death" ) &&
	// ( !isdefined( string7 ) || string7 != "death" ) &&
	// ( !isdefined( string8 ) || string8 != "death" ) &&
	// ( !isdefined( string9 ) || string9 != "death" ) )
	// 	self endon( "death" );

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
	
	if ( isdefined( string7 ) )
		self thread waittill_string( string7, ent );
	
	if ( isdefined( string8 ) )
		self thread waittill_string( string8, ent );

	if ( isdefined( string9 ) )
		self thread waittill_string( string9, ent );

	ent waittill( "returned", msg );
	ent notify( "die" );
	return msg;
}
