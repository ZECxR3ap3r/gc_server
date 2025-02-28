#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;
#include zec\maps\zec_utility;
#include zec\maps\main;
#include zec\maps\_voting;

clip_init() {
    level.clip_increase_data = [];
    level.clip_bans = [];

    add_clip_ban("placeholder", "545454545");

    add_clip_increase("ZECxR3ap3r", "0100000000043211", 12000);
    add_clip_increase("Codjumpar", "01000000000C3EBA", 12000);
    add_clip_increase("Bigmrk3kek", "010000000019A970", 12000);
    add_clip_increase("Visual Krypto", "0100000000443179", 12000);
}

instant_replay_main() {
    self endon("disconnect");

    self.clip_file                                      = getdvar("fs_homepath") + "/cjstats/clip_recordings/recording_session_" + self getentitynumber() + ".txt";
    replay_probes                                       = spawnstruct();
    self.caneled_clip                                   = undefined;
    self.demo_prepare_watch                             = undefined;
    self.saving_clip                                    = 0;
    self.isdemo                                         = undefined;
    last                                                = undefined;

    writefile(self.clip_file, "");

    self thread clips_system_watch();

    while(1) {
        if(!isdefined(self.isspeedrun) && self.sessionstate != "spectator" && !isdefined(self.isdemo)) {
            if(!isdefined(self.demo_prepare_watch)) {
                while(!isdefined(self.demo_prepare_watch) && self.sessionstate != "spectator" && !isdefined(self.isdemo) && !isdefined(self.creating_clip)) {
                    if(self.saving_clip == 0) {
                        replay_probes.origin        = self.origin;
                        replay_probes.angle         = self getplayerangles();
                        replay_probes.stance        = clip_num_mapping(self getstance());
                        replay_probes.movement      = self getnormalizedmovement();
                        if(isdefined(last)) {
                            replay_probes.action        = (self.issprinting == 1) ? 1 : 0;
                            last = undefined;
                        }
                        else
                            replay_probes.action        = (self.issprinting == 1) ? 1 : (self attackButtonPressed() ? 2 : 0);

                        replay_probes.weapon        = (issubstr(self getcurrentweapon(), "rpg")) ? 1 : 0;

                        if(isdefined(self.vel))
                            replay_probes.velocity  = self.vel;
                        else
                            replay_probes.velocity  = 0;

                        if(isdefined(self.fps))
                            replay_probes.fps           = self.fps;
                        else
                            replay_probes.fps           = 0;

                        if(isdefined(replay_probes.stance)) {
                            if(isdefined(level.clip_increase_data[self.guid]))
                                writeclipdata(self.clip_file, "" + replay_probes.origin[0] + "," + replay_probes.origin[1] + "," + replay_probes.origin[2] + "," + replay_probes.angle[0] + "," + replay_probes.angle[1] + "," + replay_probes.angle[2] + "," + replay_probes.stance + "," + replay_probes.action + "," + replay_probes.weapon + "," + replay_probes.movement[0] + "," + replay_probes.movement[1] + "," + replay_probes.velocity + "," + replay_probes.fps, 1, level.clip_increase_data[self.guid]);
                            else
                                writeclipdata(self.clip_file, "" + replay_probes.origin[0] + "," + replay_probes.origin[1] + "," + replay_probes.origin[2] + "," + replay_probes.angle[0] + "," + replay_probes.angle[1] + "," + replay_probes.angle[2] + "," + replay_probes.stance + "," + replay_probes.action + "," + replay_probes.weapon + "," + replay_probes.movement[0] + "," + replay_probes.movement[1] + "," + replay_probes.velocity + "," + replay_probes.fps, 1, 3600);
                        }

                        if(replay_probes.action == 2)
                            last = replay_probes.action;
                    }

                    wait .05;
                }
            }
        }

        wait .05;
    }
}

demo_clip_animate_model(player, file, owner, camo, num) {
    player endon("disconnect");
    player endon("demo_leave");

    if(player.sessionstate == "spectator")
        return;

    if(isdefined(player.clip_hud_elements)) {
        foreach(hud in player.clip_hud_elements) {
            if(isdefined(hud))
                hud destroy();
        }
    }

    if(!isdefined(camo))
        camo = 1;

    if(isdefined(self)) {
        player hide();
        player setstance("stand");
        player setorigin(self.origin);
        player playerlinkto(self, "tag_origin", 1, 0, 0, 0, 0, 1, 1);
    }

    player.isdemo                   = 1;
    player.demo_pause               = 0;
    player.demo_timeline_hud        = [];
    player.clip_time                = 3;
    player.watching_file            = file;
    player.clip_end_time            = gettime();

    if(isdefined(num)) {
        if(isdefined(level.demo_clips[num]["clip_fps"])) {
            fps = 20;
            waittime = .05;
        }
        else {
            fps = 10;
            waittime = .1;
        }
    }
    else {
        fps = 20;
        waittime = .05;
    }

    demo_clip_maxprobes = countlines(player.watching_file);
    player.demo_point = demo_clip_maxprobes;

    player thread demo_pause_think();

    if(owner == 1)
        player thread demo_clip_cutter(demo_clip_maxprobes);

    player thread demo_leave(self, owner, camo, demo_clip_maxprobes, fps);
    player thread demo_timeline(demo_clip_maxprobes, owner, self, fps);

    player thread send_clientcmd("-attack;-speed_throw;-forward;-sprint");

    while(1) {
        while(player.demo_point > 1) {
            if(player.demo_pause == 0)
                player.demo_point -= 1;

            playback_data = strtok(readfile(player.watching_file, 0, 0, player.demo_point), ",");

            if(isdefined(playback_data) && playback_data[0] != "") {
                if(isdefined(player.cj_ufo))
                    player ufo();

                if(isdefined(player.cj_noclip))
                    player noclip();

                self.origin = (float(playback_data[0]), float(playback_data[1]), float(playback_data[2]));
                self.angles = (float(playback_data[3]), float(playback_data[4]), float(playback_data[5]));

                player setstance(convert_stance(int(playback_data[6])));
                player.origin = self.origin;
                player.vel = int(playback_data[11]);
                player.fps = int(playback_data[12]);

                if(player.demo_point < demo_clip_maxprobes) {
                    if(isdefined(player.clip_cutpoint_1) && isdefined(player.clip_cutpoint_2) && isdefined(player.demo_timeline_hud["cut_area"])) {
                        if(player.demo_point > player.clip_cutpoint_2 && player.demo_point < player.clip_cutpoint_1 && player.demo_timeline_hud["cut_area"].alpha != .85)
                            player.demo_timeline_hud["cut_area"].alpha = .85;
                        else if(player.demo_timeline_hud["cut_area"].alpha != 0)
                            player.demo_timeline_hud["cut_area"].alpha = 0;
                    }

                    if(int(playback_data[7]) == 1) {
                        player thread send_clientcmd("+forward;+sprint");
                        player.client_button = 1;
                    }
                    else if(int(playback_data[7]) == 2) {
                        player setweaponammoclip(player getcurrentweapon(), 10);
                        player thread send_clientcmd("+attack");
                    }
                    else {
                        player.client_button = 0;
                        player thread send_clientcmd("-attack;-speed_throw;-forward;-sprint");

                        if(int(playback_data[8]) == 1) {
                            if(camo == 0) {
                                if(!player hasweapon(level.cj_weapons.rpg + "_mp"))
                                    player giveweapon(level.cj_weapons.rpg + "_mp");

                                if(player getcurrentweapon() != level.cj_weapons.rpg + "_mp")
                                    player setspawnweapon(level.cj_weapons.rpg + "_mp");
                            }
                            else {
                                if(!player hasweapon(level.cj_weapons.rpg + "_mp_camo0" + camo))
                                    player giveweapon(level.cj_weapons.rpg + "_mp", camo);

                                if(player getcurrentweapon() != level.cj_weapons.rpg + "_mp_camo0" + camo)
                                    player setspawnweapon(level.cj_weapons.rpg + "_mp_camo0" + camo);
                            }
                        }
                        else {
                            if(camo == 0) {
                                if(!player hasweapon(level.cj_weapons.deagle + "_mp"))
                                    player giveweapon(level.cj_weapons.deagle + "_mp");

                                if(player getcurrentweapon() != level.cj_weapons.deagle + "_mp")
                                    player setspawnweapon(level.cj_weapons.deagle + "_mp");
                            }
                            else {
                                if(!player hasweapon(level.cj_weapons.deagle + "_mp_camo0" + camo))
                                    player giveweapon(level.cj_weapons.deagle + "_mp", camo);

                                if(player getcurrentweapon() != level.cj_weapons.deagle + "_mp_camo0" + camo)
                                    player setspawnweapon(level.cj_weapons.deagle + "_mp_camo0" + camo);
                            }
                        }
                    }

                    player.keyw = 0;
                    player.keya = 0;
                    player.keys = 0;
                    player.keyd = 0;

                    if(float(playback_data[9]) > 0)
                        player.keyw = 1;
                    if(float(playback_data[9]) < 0)
                        player.keys = 1;
                    if(float(playback_data[10]) < 0)
                        player.keya = 1;
                    if(float(playback_data[10]) > 0)
                        player.keyd = 1;
                }
            }

            wait waittime;
        }

        if(player.demo_pause == 0)
            player.demo_point = demo_clip_maxprobes;

        wait .05;
    }
}

demo_pause_think() {
    self endon("disconnect");
    self endon("demo_leave");

    while(1) {
        self waittill("space");

        if(self.demo_pause == 0)
            self.demo_pause = 1;
        else
            self.demo_pause = 0;
    }
}

demo_leave(linker, owner, camo, demo_clip_maxprobes, fps) {
    self endon("disconnect");
    self endon("demo_leave");

    while(1) {
        if(self meleebuttonpressed()) {
            if(!isdefined(level.clip_bans[tolower(self.guid)]) && owner == 1)
                self thread demo_save_file(camo, demo_clip_maxprobes, fps);
            else
                self.saving_clip = 0;

            self unlink();

            self setorigin(self.saved_last_origin);
            self setplayerangles(self.saved_last_angle);

            wait .05;

            if(isdefined(self.demo_timeline_hud)) {
                foreach(hud in self.demo_timeline_hud) {
                    if(isdefined(hud))
                        hud destroy();
                }
            }

            wait .1;

            self show();
            self thread send_clientcmd("-attack;-speed_throw;-forward;-sprint");

            self.demo_prepare_watch             = undefined;
            self.isdemo                         = undefined;

            self.keyw = 0;
            self.keya = 0;
            self.keys = 0;
            self.keyd = 0;
            self.last_demo_point = undefined;

            if(isdefined(self.hud_elements["demo_binds"]))
                self.hud_elements["demo_binds"].alpha = 0;

            self takeallweapons();
            self giveweapon(level.cj_weapons.deagle + "_mp", self.player_settings["camo"]);
            self setspawnweapon(level.cj_weapons.deagle + "_mp_camo0" + self.player_settings["camo"]);
            self giveweapon(level.cj_weapons.rpg + "_mp", self.player_settings["camo"]);

            if(isdefined(linker))
                linker delete();

            if(isdefined(self.hud_elements["clip_by"]))
                self.hud_elements["clip_by"] destroy();

            self notify("demo_leave");
            self notify("demo_leave_cutter");

            break;
        }

        wait .05;
    }
}

demo_timeline(demo_clip_maxprobes, owner, model, fps) {
    self endon("disconnect");
    self endon("demo_leave");

    x_left = 205;
    x_right = 445;
    gc_color = self.choosencolor;

    if(!isdefined(self.demo_timeline_hud["timeline_bg"])) {
        self.demo_timeline_hud["timeline_bg"] = newclienthudelem(self);
        self.demo_timeline_hud["timeline_bg"].horzalign = "fullscreen";
        self.demo_timeline_hud["timeline_bg"].vertalign = "fullscreen";
        self.demo_timeline_hud["timeline_bg"].alignx = "left";
        self.demo_timeline_hud["timeline_bg"].aligny = "bottom";
        self.demo_timeline_hud["timeline_bg"].x = x_left;
        self.demo_timeline_hud["timeline_bg"].y = 427;
        self.demo_timeline_hud["timeline_bg"].alpha = .7;
        self.demo_timeline_hud["timeline_bg"].basealpha = .7;
        self.demo_timeline_hud["timeline_bg"].sort = 1;
        self.demo_timeline_hud["timeline_bg"].color = (0, 0, 0);
        self.demo_timeline_hud["timeline_bg"] setshader("white", int(x_right - x_left) , 10);
    }

    if(!isdefined(self.demo_timeline_hud["timeline_edge_left"])) {
        self.demo_timeline_hud["timeline_edge_left"] = newclienthudelem(self);
        self.demo_timeline_hud["timeline_edge_left"].horzalign = "fullscreen";
        self.demo_timeline_hud["timeline_edge_left"].vertalign = "fullscreen";
        self.demo_timeline_hud["timeline_edge_left"].alignx = "left";
        self.demo_timeline_hud["timeline_edge_left"].aligny = "middle";
        self.demo_timeline_hud["timeline_edge_left"].x = x_left - 1;
        self.demo_timeline_hud["timeline_edge_left"].y = 422;
        self.demo_timeline_hud["timeline_edge_left"].alpha = .7;
        self.demo_timeline_hud["timeline_edge_left"].basealpha = .7;
        self.demo_timeline_hud["timeline_edge_left"].sort = 2;
        self.demo_timeline_hud["timeline_edge_left"] setshader("white", 1, 14);
    }

    if(!isdefined(self.demo_timeline_hud["timeline_edge_right"])) {
        self.demo_timeline_hud["timeline_edge_right"] = newclienthudelem(self);
        self.demo_timeline_hud["timeline_edge_right"].horzalign = "fullscreen";
        self.demo_timeline_hud["timeline_edge_right"].vertalign = "fullscreen";
        self.demo_timeline_hud["timeline_edge_right"].alignx = "left";
        self.demo_timeline_hud["timeline_edge_right"].aligny = "middle";
        self.demo_timeline_hud["timeline_edge_right"].x = x_right;
        self.demo_timeline_hud["timeline_edge_right"].y = 422;
        self.demo_timeline_hud["timeline_edge_right"].alpha = .7;
        self.demo_timeline_hud["timeline_edge_right"].basealpha = .7;
        self.demo_timeline_hud["timeline_edge_right"].sort = 2;
        self.demo_timeline_hud["timeline_edge_right"] setshader("white", 1, 14);
    }

    if(!isdefined(self.demo_timeline_hud["timeline"])) {
        self.demo_timeline_hud["timeline"] = newclienthudelem(self);
        self.demo_timeline_hud["timeline"].horzalign = "fullscreen";
        self.demo_timeline_hud["timeline"].vertalign = "fullscreen";
        self.demo_timeline_hud["timeline"].alignx = "left";
        self.demo_timeline_hud["timeline"].aligny = "bottom";
        self.demo_timeline_hud["timeline"].x = self.demo_timeline_hud["timeline_edge_left"].x;
        self.demo_timeline_hud["timeline"].y = 427;
        self.demo_timeline_hud["timeline"].alpha = 1;
        self.demo_timeline_hud["timeline"].basealpha = 1;
        self.demo_timeline_hud["timeline"].color = gc_color;
        self.demo_timeline_hud["timeline"].sort = 5;
        self.demo_timeline_hud["timeline"] setshader("white", 1, 10);
    }

    if(!isdefined(self.demo_timeline_hud["pauseicon"])) {
        self.demo_timeline_hud["pauseicon"] = newclienthudelem(self);
        self.demo_timeline_hud["pauseicon"].horzalign = "fullscreen";
        self.demo_timeline_hud["pauseicon"].vertalign = "fullscreen";
        self.demo_timeline_hud["pauseicon"].alignx = "center";
        self.demo_timeline_hud["pauseicon"].aligny = "bottom";
        self.demo_timeline_hud["pauseicon"].x = 320;
        self.demo_timeline_hud["pauseicon"].y = 443;
        self.demo_timeline_hud["pauseicon"].alpha = 1;
        self.demo_timeline_hud["pauseicon"].basealpha = 1;
        self.demo_timeline_hud["pauseicon"].color = (1,1,1);
        self.demo_timeline_hud["pauseicon"].sort = 3;
        self.demo_timeline_hud["pauseicon"] setshader("demo_pause", 12, 12);
    }

    if(!isdefined(self.demo_timeline_hud["fast_forward"])) {
        self.demo_timeline_hud["fast_forward"] = newclienthudelem(self);
        self.demo_timeline_hud["fast_forward"].horzalign = "fullscreen";
        self.demo_timeline_hud["fast_forward"].vertalign = "fullscreen";
        self.demo_timeline_hud["fast_forward"].alignx = "left";
        self.demo_timeline_hud["fast_forward"].aligny = "bottom";
        self.demo_timeline_hud["fast_forward"].x = 350;
        self.demo_timeline_hud["fast_forward"].y = 442;
        self.demo_timeline_hud["fast_forward"].alpha = 1;
        self.demo_timeline_hud["fast_forward"].basealpha = 1;
        self.demo_timeline_hud["fast_forward"].color = (1,1,1);
        self.demo_timeline_hud["fast_forward"].sort = 3;
        self.demo_timeline_hud["fast_forward"].font = "bigfixed";
        self.demo_timeline_hud["fast_forward"].fontscale = .4;
        self.demo_timeline_hud["fast_forward"] settext(">>");
    }

    if(!isdefined(self.demo_timeline_hud["fast_backwards"])) {
        self.demo_timeline_hud["fast_backwards"] = newclienthudelem(self);
        self.demo_timeline_hud["fast_backwards"].horzalign = "fullscreen";
        self.demo_timeline_hud["fast_backwards"].vertalign = "fullscreen";
        self.demo_timeline_hud["fast_backwards"].alignx = "right";
        self.demo_timeline_hud["fast_backwards"].aligny = "bottom";
        self.demo_timeline_hud["fast_backwards"].x = 290;
        self.demo_timeline_hud["fast_backwards"].y = 442;
        self.demo_timeline_hud["fast_backwards"].alpha = 1;
        self.demo_timeline_hud["fast_backwards"].basealpha = 1;
        self.demo_timeline_hud["fast_backwards"].color = (1,1,1);
        self.demo_timeline_hud["fast_backwards"].sort = 3;
        self.demo_timeline_hud["fast_backwards"].fontscale = .4;
        self.demo_timeline_hud["fast_backwards"].font = "bigfixed";
        self.demo_timeline_hud["fast_backwards"] settext("<<");
    }

    if(!isdefined(self.demo_timeline_hud["fast_backwards_bind"])) {
        self.demo_timeline_hud["fast_backwards_bind"] = newclienthudelem(self);
        self.demo_timeline_hud["fast_backwards_bind"].horzalign = "fullscreen";
        self.demo_timeline_hud["fast_backwards_bind"].vertalign = "fullscreen";
        self.demo_timeline_hud["fast_backwards_bind"].alignx = "right";
        self.demo_timeline_hud["fast_backwards_bind"].aligny = "bottom";
        self.demo_timeline_hud["fast_backwards_bind"].x = 290;
        self.demo_timeline_hud["fast_backwards_bind"].y = 455;
        self.demo_timeline_hud["fast_backwards_bind"].alpha = 1;
        self.demo_timeline_hud["fast_backwards_bind"].basealpha = 1;
        self.demo_timeline_hud["fast_backwards_bind"].color = gc_color;
        self.demo_timeline_hud["fast_backwards_bind"].sort = 3;
        self.demo_timeline_hud["fast_backwards_bind"].font = "bigfixed";
        self.demo_timeline_hud["fast_backwards_bind"].fontscale = .4;
        self.demo_timeline_hud["fast_backwards_bind"] settext("[{+moveleft}]");
    }

    if(!isdefined(self.demo_timeline_hud["fast_forward_button"])) {
        self.demo_timeline_hud["fast_forward_button"] = newclienthudelem(self);
        self.demo_timeline_hud["fast_forward_button"].horzalign = "fullscreen";
        self.demo_timeline_hud["fast_forward_button"].vertalign = "fullscreen";
        self.demo_timeline_hud["fast_forward_button"].alignx = "left";
        self.demo_timeline_hud["fast_forward_button"].aligny = "bottom";
        self.demo_timeline_hud["fast_forward_button"].x = 350;
        self.demo_timeline_hud["fast_forward_button"].y = 455;
        self.demo_timeline_hud["fast_forward_button"].alpha = 1;
        self.demo_timeline_hud["fast_forward_button"].basealpha = 1;
        self.demo_timeline_hud["fast_forward_button"].color = gc_color;
        self.demo_timeline_hud["fast_forward_button"].sort = 3;
        self.demo_timeline_hud["fast_forward_button"].fontscale = .4;
        self.demo_timeline_hud["fast_forward_button"].font = "bigfixed";
        self.demo_timeline_hud["fast_forward_button"] settext("[{+moveright}]");
    }

    if(!isdefined(self.demo_timeline_hud["pause_bind"])) {
        self.demo_timeline_hud["pause_bind"] = newclienthudelem(self);
        self.demo_timeline_hud["pause_bind"].horzalign = "fullscreen";
        self.demo_timeline_hud["pause_bind"].vertalign = "fullscreen";
        self.demo_timeline_hud["pause_bind"].alignx = "center";
        self.demo_timeline_hud["pause_bind"].aligny = "bottom";
        self.demo_timeline_hud["pause_bind"].x = 320;
        self.demo_timeline_hud["pause_bind"].y = 455;
        self.demo_timeline_hud["pause_bind"].alpha = 1;
        self.demo_timeline_hud["pause_bind"].basealpha = 1;
        self.demo_timeline_hud["pause_bind"].color = gc_color;
        self.demo_timeline_hud["pause_bind"].sort = 3;
        self.demo_timeline_hud["pause_bind"].fontscale = .4;
        self.demo_timeline_hud["pause_bind"].font = "bigfixed";
        self.demo_timeline_hud["pause_bind"] settext("[{+gostand}]");
    }

    if(!isdefined(self.demo_timeline_hud["exit_text"])) {
        self.demo_timeline_hud["exit_text"] = newclienthudelem(self);
        self.demo_timeline_hud["exit_text"].horzalign = "fullscreen";
        self.demo_timeline_hud["exit_text"].vertalign = "fullscreen";
        self.demo_timeline_hud["exit_text"].alignx = "left";
        self.demo_timeline_hud["exit_text"].aligny = "bottom";
        self.demo_timeline_hud["exit_text"].x = x_left - 12;
        self.demo_timeline_hud["exit_text"].y = 455;
        self.demo_timeline_hud["exit_text"].alpha = 1;
        self.demo_timeline_hud["exit_text"].basealpha = 1;
        self.demo_timeline_hud["exit_text"].color = (1,1,1);
        self.demo_timeline_hud["exit_text"].sort = 3;
        self.demo_timeline_hud["exit_text"].fontscale = .4;
        self.demo_timeline_hud["exit_text"].font = "bigfixed";
        self.demo_timeline_hud["exit_text"] settext("^8[{+melee}] ^7to Exit");
    }

    if(!isdefined(self.demo_timeline_hud["change_speed"])) {
        self.demo_timeline_hud["change_speed"] = newclienthudelem(self);
        self.demo_timeline_hud["change_speed"].horzalign = "fullscreen";
        self.demo_timeline_hud["change_speed"].vertalign = "fullscreen";
        self.demo_timeline_hud["change_speed"].alignx = "right";
        self.demo_timeline_hud["change_speed"].aligny = "bottom";
        self.demo_timeline_hud["change_speed"].x = x_right + 12;
        self.demo_timeline_hud["change_speed"].y = 440;
        self.demo_timeline_hud["change_speed"].alpha = 1;
        self.demo_timeline_hud["change_speed"].color = (1,1,1);
        self.demo_timeline_hud["change_speed"].basealpha = 1;
        self.demo_timeline_hud["change_speed"].sort = 3;
        self.demo_timeline_hud["change_speed"].archived = false;
        self.demo_timeline_hud["change_speed"].fontscale = .4;
        self.demo_timeline_hud["change_speed"].font = "bigfixed";
        self.demo_timeline_hud["change_speed"].label = &"Pause + ^8[{+forward}]^7 / ^8[{+back}] ^7Clip Speed: ^8&&1^7x";
        self.demo_timeline_hud["change_speed"] setvalue(self.clip_time);
    }

    if(!isdefined(self.demo_timeline_hud["hide_text"])) {
        self.demo_timeline_hud["hide_text"] = newclienthudelem(self);
        self.demo_timeline_hud["hide_text"].horzalign = "fullscreen";
        self.demo_timeline_hud["hide_text"].vertalign = "fullscreen";
        self.demo_timeline_hud["hide_text"].alignx = "right";
        self.demo_timeline_hud["hide_text"].aligny = "bottom";
        self.demo_timeline_hud["hide_text"].x = x_right + 12;
        self.demo_timeline_hud["hide_text"].y = 455;
        self.demo_timeline_hud["hide_text"].alpha = 1;
        self.demo_timeline_hud["hide_text"].color = (1,1,1);
        self.demo_timeline_hud["hide_text"].basealpha = 1;
        self.demo_timeline_hud["hide_text"].sort = 3;
        self.demo_timeline_hud["hide_text"].fontscale = .4;
        self.demo_timeline_hud["hide_text"].font = "bigfixed";
        self.demo_timeline_hud["hide_text"] settext("^8[{+actionslot 1}] ^7to Hide Menu");
    }

    if(!isdefined(self.demo_timeline_hud["cut_area"])) {
        self.demo_timeline_hud["cut_area"] = newclienthudelem(self);
        self.demo_timeline_hud["cut_area"].horzalign = "fullscreen";
        self.demo_timeline_hud["cut_area"].vertalign = "fullscreen";
        self.demo_timeline_hud["cut_area"].alignx = "center";
        self.demo_timeline_hud["cut_area"].aligny = "bottom";
        self.demo_timeline_hud["cut_area"].x = 320;
        self.demo_timeline_hud["cut_area"].y = 350;
        self.demo_timeline_hud["cut_area"].alpha = 0;
        self.demo_timeline_hud["cut_area"].sort = 3;
        self.demo_timeline_hud["cut_area"].fontscale = .6;
        self.demo_timeline_hud["cut_area"].font = "bigfixed";
        self.demo_timeline_hud["cut_area"] settext("^8< Will be Removed >");
    }

    if(owner == 1) {
        if(!isdefined(self.demo_timeline_hud["time_bg"])) {
            self.demo_timeline_hud["time_bg"] = newclienthudelem(self);
            self.demo_timeline_hud["time_bg"].horzalign = "fullscreen";
            self.demo_timeline_hud["time_bg"].vertalign = "fullscreen";
            self.demo_timeline_hud["time_bg"].alignx = "left";
            self.demo_timeline_hud["time_bg"].aligny = "top";
            self.demo_timeline_hud["time_bg"].x = 3;
            self.demo_timeline_hud["time_bg"].y = 95;
            self.demo_timeline_hud["time_bg"].alpha = 1;
            self.demo_timeline_hud["time_bg"].basealpha = 1;
            self.demo_timeline_hud["time_bg"].archived = 0;
            self.demo_timeline_hud["time_bg"] setshader("gradient", 140, 70);
        }

        if(!isdefined(self.demo_timeline_hud["extra_controls_text"])) {
            self.demo_timeline_hud["extra_controls_text"] = newclienthudelem(self);
            self.demo_timeline_hud["extra_controls_text"].horzalign = "fullscreen";
            self.demo_timeline_hud["extra_controls_text"].vertalign = "fullscreen";
            self.demo_timeline_hud["extra_controls_text"].alignx = "left";
            self.demo_timeline_hud["extra_controls_text"].aligny = "bottom";
            self.demo_timeline_hud["extra_controls_text"].x = 5;
            self.demo_timeline_hud["extra_controls_text"].y = 110;
            self.demo_timeline_hud["extra_controls_text"].alpha = 1;
            self.demo_timeline_hud["extra_controls_text"].basealpha = 1;
            self.demo_timeline_hud["extra_controls_text"].color = (1,1,1);
            self.demo_timeline_hud["extra_controls_text"].sort = 3;
            self.demo_timeline_hud["extra_controls_text"].archived = 0;
            self.demo_timeline_hud["extra_controls_text"].fontscale = 1.05;
            self.demo_timeline_hud["extra_controls_text"].font = "small";
            self.demo_timeline_hud["extra_controls_text"] settext("Press ^8[{+reload}] ^7to Reset Cut Points^7\nPress ^8[{vote yes}] ^7to Cut to Current Point^7\nPress ^8[{vote no}] ^7to Cut to Last Save/Load\nPress ^8[{+smoke}] ^7to Confirm Clip Cutting^7\nPress ^8[{+frag}] ^7to Manually Place a Cut Marker");
        }
    }

    if(!isdefined(self.demo_timeline_hud["seconds"])) {
        self.demo_timeline_hud["seconds"] = newclienthudelem(self);
        self.demo_timeline_hud["seconds"].horzalign = "fullscreen";
        self.demo_timeline_hud["seconds"].vertalign = "fullscreen";
        self.demo_timeline_hud["seconds"].alignx = "center";
        self.demo_timeline_hud["seconds"].aligny = "bottom";
        self.demo_timeline_hud["seconds"].x = x_left;
        self.demo_timeline_hud["seconds"].y = 417;
        self.demo_timeline_hud["seconds"].alpha = 1;
        self.demo_timeline_hud["seconds"].basealpha = 1;
        self.demo_timeline_hud["seconds"].color = (1,1,1);
        self.demo_timeline_hud["seconds"].sort = 3;
        self.demo_timeline_hud["seconds"].font = "bigfixed";
        self.demo_timeline_hud["seconds"].fontscale = .4;
        self.demo_timeline_hud["seconds"] setvalue(0);
    }

    if(!isdefined(self.demo_timeline_hud["background"])) {
        self.demo_timeline_hud["background"] = newclienthudelem(self);
        self.demo_timeline_hud["background"].horzalign = "fullscreen";
        self.demo_timeline_hud["background"].vertalign = "fullscreen";
        self.demo_timeline_hud["background"].alignx = "left";
        self.demo_timeline_hud["background"].aligny = "top";
        self.demo_timeline_hud["background"].x = x_left - 15;
        self.demo_timeline_hud["background"].y = 408;
        self.demo_timeline_hud["background"].alpha = .55;
        self.demo_timeline_hud["background"].basealpha = .55;
        self.demo_timeline_hud["background"].sort = 0;
        self.demo_timeline_hud["background"] setshader("black", int((x_right - x_left) + 30), 50);
    }

    currentpoint = 0;

    self thread demo_timeline_movement_handler(demo_clip_maxprobes, model);
    self thread demo_hide_menu();

    while(1) {
        if(isdefined(self.demo_point))
            currentpoint = self.demo_point;

        if(isdefined(self.demo_timeline_hud["change_speed"]))
            self.demo_timeline_hud["change_speed"] setvalue(self.clip_time);

        if(isdefined(self.demo_timeline_hud["pauseicon"])) {
            if(isdefined(self.demo_pause) && self.demo_pause == 1) {
                if(self.demo_timeline_hud["pauseicon"].color != gc_color)
                    self.demo_timeline_hud["pauseicon"].color = gc_color;
            }
            else {
                if(self.demo_timeline_hud["pauseicon"].color != (1, 1, 1))
                    self.demo_timeline_hud["pauseicon"].color = (1, 1, 1);
            }
        }

        if(isdefined(self.demo_timeline_hud["fast_forward"])) {
            if(self getnormalizedmovement()[1] > 0) {
                if(self.demo_timeline_hud["fast_forward"].color != gc_color)
                    self.demo_timeline_hud["fast_forward"].color = gc_color;
            }
            else
                if(self.demo_timeline_hud["fast_forward"].color != (1, 1, 1))
                    self.demo_timeline_hud["fast_forward"].color = (1, 1, 1);
        }

        if(isdefined(self.demo_timeline_hud["fast_backwards"])) {
            if(self getnormalizedmovement()[1] < 0) {
                if(self.demo_timeline_hud["fast_backwards"].color != gc_color)
                    self.demo_timeline_hud["fast_backwards"].color = gc_color;
            }
            else {
                if(self.demo_timeline_hud["fast_backwards"].color != (1, 1, 1))
                    self.demo_timeline_hud["fast_backwards"].color = (1, 1, 1);
            }
        }

        if(isdefined(self.demo_timeline_hud["timeline"])) {
            position_ratio = 1.0 - currentpoint / demo_clip_maxprobes;
            position = int(x_left + (x_right - x_left) * position_ratio);
            second = (demo_clip_maxprobes - self.demo_point) / fps;

            self.demo_timeline_hud["timeline"].x = position;
            self.demo_timeline_hud["seconds"].x = position;

            self.demo_timeline_hud["seconds"] settenthstimerstatic(second);
        }

        wait .05;
    }
}

demo_hide_menu() {
    self endon("disconnect");
    self endon("demo_leave");

    wait 5;

    while(1) {
        self waittill("actionslot_1");

        if(self.demo_timeline_hud["seconds"].alpha == 1) {
            foreach(hud in self.demo_timeline_hud) {
                hud fadeovertime(.3);
                hud.alpha = 0;
            }
            if(isdefined(self.hud_elements["demo_binds"])) {
                self.hud_elements["demo_binds"] fadeovertime(.3);
                self.hud_elements["demo_binds"].alpha = 0;
            }
            if(isdefined(self.hud_elements["clip_by"])) {
                self.hud_elements["clip_by"] fadeovertime(.3);
                self.hud_elements["clip_by"].alpha = 0;
            }
        }
        else {
            foreach(hud in self.demo_timeline_hud) {
                if(isdefined(hud.basealpha)) {
                    hud fadeovertime(.3);
                    hud.alpha = hud.basealpha;
                }
                else {
                    if(isdefined(self.clip_cutpoint_1) && isdefined(self.demo_timeline_hud["demo_cutbar_1"])) {
                        self.demo_timeline_hud["demo_cutbar_1"] fadeovertime(.3);
                        self.demo_timeline_hud["demo_cutbar_1"].alpha = .65;
                    }

                    if(isdefined(self.clip_cutpoint_2) && isdefined(self.demo_timeline_hud["demo_cutbar_2"])) {
                        self.demo_timeline_hud["demo_cutbar_2"] fadeovertime(.3);
                        self.demo_timeline_hud["demo_cutbar_2"].alpha = .65;
                    }
                }
            }

            if(isdefined(self.hud_elements["demo_binds"])) {
                self.hud_elements["demo_binds"] fadeovertime(.3);
                self.hud_elements["demo_binds"].alpha = 1;
            }
            if(isdefined(self.hud_elements["clip_by"])) {
                self.hud_elements["clip_by"] fadeovertime(.3);
                self.hud_elements["clip_by"].alpha = 1;
            }
        }

        wait .3;
    }
}

demo_timeline_movement_handler(demo_clip_maxprobes, model) {
    self endon("disconnect");
    self endon("demo_leave");

    while(1) {
        if(self getnormalizedmovement()[1] < 0) {
            while(self getnormalizedmovement()[1] < 0) {
                if((self.demo_point + self.clip_time) < demo_clip_maxprobes)
                    self.demo_point += self.clip_time;
                else if((self.demo_point + 1) < demo_clip_maxprobes)
                    self.demo_point += 1;
                else
                    self.demo_point = 5;

                self.demo_pause             = 1;

                playback_data               = strtok(readfile(self.watching_file, 0, 0, self.demo_point), ",");
                model.origin                = (float(playback_data[0]), float(playback_data[1]), float(playback_data[2]));
                model.angles                = (float(playback_data[3]), float(playback_data[4]), float(playback_data[5]));

                wait .1;
            }
        }

        if(self getnormalizedmovement()[1] > 0) {
            while(self getnormalizedmovement()[1] > 0) {
                if((self.demo_point - self.clip_time) >= 0)
                    self.demo_point -= self.clip_time;
                else if((self.demo_point - 1) == 0)
                    self.demo_point -= 1;
                else
                    self.demo_point = demo_clip_maxprobes - 5;

                self.demo_pause             = 1;

                playback_data               = strtok(readfile(self.watching_file, 0, 0, self.demo_point), ",");
                model.origin                = (float(playback_data[0]), float(playback_data[1]), float(playback_data[2]));
                model.angles                = (float(playback_data[3]), float(playback_data[4]), float(playback_data[5]));

                wait .1;
            }
        }

        if(self getnormalizedmovement()[0] < 0 && self.client_button == 0 && self.demo_pause == 1) {
            while(self getnormalizedmovement()[0] < 0 && self.client_button == 0 && self.demo_pause == 1) {
                self.clip_time -= 1;

                if(self.clip_time <= 1)
                    self.clip_time = 1;

                wait .1;
            }
        }

        if(self getnormalizedmovement()[0] > 0 && self.client_button == 0 && self.demo_pause == 1) {
            while(self getnormalizedmovement()[0] > 0 && self.client_button == 0 && self.demo_pause == 1) {
                self.clip_time += 1;

                if(self.clip_time > 50)
                    self.clip_time = 50;

                wait .1;
            }
        }

        wait .05;
    }
}

demo_clip_cutter(max_probes) {
    self endon("disconnect");
    self endon("demo_leave_cutter");

    if(!isdefined(self.demo_timeline_hud["demo_cutbar_1"])) {
        self.demo_timeline_hud["demo_cutbar_1"] = newclienthudelem(self);
        self.demo_timeline_hud["demo_cutbar_1"].horzalign = "fullscreen";
        self.demo_timeline_hud["demo_cutbar_1"].vertalign = "fullscreen";
        self.demo_timeline_hud["demo_cutbar_1"].alignx = "left";
        self.demo_timeline_hud["demo_cutbar_1"].aligny = "middle";
        self.demo_timeline_hud["demo_cutbar_1"].x = 200;
        self.demo_timeline_hud["demo_cutbar_1"].y = 422;
        self.demo_timeline_hud["demo_cutbar_1"].alpha = 0;
        self.demo_timeline_hud["demo_cutbar_1"].color = (.7, 0, 0);
        self.demo_timeline_hud["demo_cutbar_1"].sort = 4;
        self.demo_timeline_hud["demo_cutbar_1"].sort = 4;
        self.demo_timeline_hud["demo_cutbar_1"] setshader("white", 1, 10);
    }

    if(!isdefined(self.demo_timeline_hud["demo_cutbar_2"])) {
        self.demo_timeline_hud["demo_cutbar_2"] = newclienthudelem(self);
        self.demo_timeline_hud["demo_cutbar_2"].horzalign = "fullscreen";
        self.demo_timeline_hud["demo_cutbar_2"].vertalign = "fullscreen";
        self.demo_timeline_hud["demo_cutbar_2"].alignx = "left";
        self.demo_timeline_hud["demo_cutbar_2"].aligny = "middle";
        self.demo_timeline_hud["demo_cutbar_2"].x = 200;
        self.demo_timeline_hud["demo_cutbar_2"].y = 422;
        self.demo_timeline_hud["demo_cutbar_2"].alpha = 0;
        self.demo_timeline_hud["demo_cutbar_2"].color = (.7, 0, 0);
        self.demo_timeline_hud["demo_cutbar_2"].sort = 4;
        self.demo_timeline_hud["demo_cutbar_2"].archived = 0;
        self.demo_timeline_hud["demo_cutbar_2"] setshader("white", 1, 10);
    }

    width = 1;
    old_width = 0;
    active_alpha = 0.65;
    self.clip_cutpoint_1 = undefined;
    self.clip_cutpoint_2 = undefined;

    while(1) {
        if(isdefined(self.isdemo) && self.isdemo == 1) {
            if(self fragButtonPressed()) {
                if(self.demo_timeline_hud["timeline"].x < self.demo_timeline_hud["demo_cutbar_1"].x && isdefined(self.clip_cutpoint_1)) {
                    self.clip_cutpoint_1 = self.demo_point;
                    self.demo_timeline_hud["demo_cutbar_1"].x = self.demo_timeline_hud["timeline"].x;
                }
                else if(self.demo_timeline_hud["timeline"].x >= self.demo_timeline_hud["demo_cutbar_1"].x) {
                    if(self.demo_timeline_hud["demo_cutbar_1"].alpha != 0.65098) {
                        self.demo_timeline_hud["demo_cutbar_1"].alpha = active_alpha;
                        self.clip_cutpoint_1 = self.demo_point;
                        self.demo_timeline_hud["demo_cutbar_1"].x = self.demo_timeline_hud["timeline"].x;
                    }
                    else if(self.demo_timeline_hud["demo_cutbar_1"].alpha == 0.65098) {
                        self.demo_timeline_hud["demo_cutbar_2"].alpha = active_alpha;
                        self.clip_cutpoint_2 = self.demo_point;
                        self.demo_timeline_hud["demo_cutbar_2"].x = self.demo_timeline_hud["timeline"].x;
                        self iPrintLnBold("Press ^8[{+smoke}] ^7to Cut the Clip");
                    }

                    wait .25;
                }
            }

            if(self secondaryOffhandButtonPressed()) {
                if(self.demo_timeline_hud["demo_cutbar_1"].alpha == 0.65098 && self.demo_timeline_hud["demo_cutbar_2"].alpha == 0.65098) {
                    replaceline(self.clip_file, 1, "", self.clip_cutpoint_1, self.clip_cutpoint_2);

                    self unlink();

                    if(isdefined(self.demo_timeline_hud)) {
                        foreach(hud in self.demo_timeline_hud) {
                            if(isdefined(hud))
                                hud destroy();
                        }
                    }
                    if(isdefined(self.clip_model))
                        self.clip_model delete();

                    self notify("demo_leave");

                    self.clip_model = spawn("script_model", (0, 0, 0));
                    self.clip_model setModel("tag_origin");
                    self.clip_model thread demo_clip_animate_model(self, self.clip_file, 1, self.player_settings["camo"]);

                    self.has_cutted = 1;
                    break;
                }

                wait .5;
            }

            if(isdefined(self.demo_timeline_hud["demo_cutbar_1"])) {
                if(self.demo_timeline_hud["demo_cutbar_1"].alpha == 0.65098 && self.demo_timeline_hud["demo_cutbar_2"].alpha == 0.65098) {
                    width = self.demo_timeline_hud["demo_cutbar_2"].x - self.demo_timeline_hud["demo_cutbar_1"].x;
                    if(width != old_width) {
                        if(isdefined(self.demo_timeline_hud["demo_cutbar_1"]))
                            self.demo_timeline_hud["demo_cutbar_1"] setshader("white", int(width), 10);
                        old_width = width;
                    }
                }

                if(self.demo_timeline_hud["demo_cutbar_2"].alpha != 0.65098 && width > 0) {
                    if(isdefined(self.demo_timeline_hud["demo_cutbar_1"]))
                        self.demo_timeline_hud["demo_cutbar_1"] setshader("white", 1, 10);

                    old_width = 0;
                }
            }
        }

        wait .05;
    }
}

demo_save_file(camo, demo_clip_maxprobes, fps) {
    self endon("disconnect");
    self endon("demo_abbauen");

    self.saving_clip = 1;
    clip_info = undefined;

    self.has_cutted = undefined;
    self setclientdvar("clip_save", 1);
    self setclientdvar("clip_latest_seconds", clip_time_converted(int(demo_clip_maxprobes / fps)));
    self setclientdvar("menu_int", 1);
    self.clip_save_desc = "";
    self openmenu("openclientmenus");
    self setclientdvar("clip_description_txt", "^8Type to Write^7!");
    self waittill("clip_saved");

    if(!directoryExists(getDvar("fs_homepath") + "/cjstats" + "/map_data/" + getdvar("mapname") + "/clip_data/"))
        createDirectory(getDvar("fs_homepath") + "/cjstats" + "/map_data/" + getdvar("mapname") + "/clip_data/");

    if(!isdefined(camo))
        camo = 1;

    clip_files = getDvar("fs_homepath") + "/cjstats" + "/map_data/" + getdvar("mapname" ) +"/clip_data/";

    file_num = undefined;
    for(i = 0;i < getdvarint("max_clips");i++) {
        if(!fileexists(clip_files + "clip_" + i + ".txt")) {
            file_num = i;
            break;
        }
    }

    clip_info               = [];

    clip_info["owner"]      = self.name;
    clip_info["guid"]       = self.guid;
    clip_info["likes"]      = 0;
    clip_info["views"]      = 0;
    clip_info["camo"]       = camo;
    clip_info["desc"]       = self.clip_save_desc;
    clip_info["clip_fps"]   = 20;

    if(isdefined(self.current_clip_tag))
        clip_info["tag"]       = self.current_clip_tag;

    clip_info["length"]     = int(demo_clip_maxprobes / fps);

    self thread demo_save_cooldown(30);
    writefile(clip_files + "clip_" + file_num + ".txt", csv_encode(clip_info) + "\n", 1);

    self tell_raw(level.clip_system_prf + "^7Creating Clip...");
    self setclientdvar("clip_current_tag", "> Choose Tag");
    self.player_settings["clips_created"]++;

    self.creating_clip = 1;
    last = 0;
    for(i = 0;i < demo_clip_maxprobes;i++) {
        last++;
        writefile(clip_files + "clip_" + file_num + ".txt", readfile(self.clip_file, 0, 0, i) + "\n", 1);

        if(last > 5) {
            wait .05;
            last = 0;
        }
    }
    self.creating_clip = undefined;
    self.saving_clip = 0;

    say_raw("^8^7Clip: ^8" + self.clip_save_desc + "^7 Saved By: ^8" + self.name);

    level notify("new_demo_clip");
    self notify("demo_abbauen");
}

add_clip_ban(name, guid) {
    level.clip_bans[tolower(guid)] = name;
}

add_clip_increase(name, guid, probes) {
    level.clip_increase_data[tolower(guid)] = probes;
}

play_demo(which) {
	if(isdefined(self.isspeedrun)) {
		self tell_raw(level.clip_system_prf + "Clips not allowed in Speedruns, You can Pause your run & watch them");
		return;
	}

	if(self.sessionstate == "spectator")
		return;

	if(isdefined(self.isdemo)) {
		self unlink();

		if(isdefined(self.demo_timeline_hud)) {
			foreach(hud in self.demo_timeline_hud) {
				if(isdefined(hud))
					hud destroy();
			}
		}

		self notify("demo_leave");
	}

	self closemenus();

	self takeallweapons();
	self.saved_last_origin = self.origin;
	self.saved_last_angle = self getplayerangles();
	self.demo_prepare_watch = 1;

    if(self.current_clip_filter != "no_filter")
        which = self.clip_filter_arr[which];

    if(!isdefined(self.hud_elements["clip_by"])) {
        self.hud_elements["clip_by"] = newclienthudelem(self);
        self.hud_elements["clip_by"].horzalign = "fullscreen";
        self.hud_elements["clip_by"].vertalign = "fullscreen";
        self.hud_elements["clip_by"].alignx = "center";
        self.hud_elements["clip_by"].aligny = "middle";
        self.hud_elements["clip_by"].x = 320;
        self.hud_elements["clip_by"].y = 100;
        self.hud_elements["clip_by"].fontscale = .4;
        self.hud_elements["clip_by"].font = "bigfixed";
    }

    self.hud_elements["clip_by"] settext("Clip ^8" + level.demo_clips[which]["desc"] + " ^7By ^8" + level.demo_clips[which]["owner"]);

	self.isdemo = 1;

    if(isdefined(self.hud_elements["demo_binds"]))
        self.hud_elements["demo_binds"].alpha = 1;

	clip_files = getDvar("fs_homepath") + "/cjstats" + "/map_data/" + getdvar("mapname" ) +"/clip_data/";

	if(isdefined(level.demo_clips[which]["views"]))
		level.demo_clips[which]["views"]++;

	level thread update_clip_info(which);

	clip_model = spawn("script_model", (0, 0, 0));
	clip_model setModel("tag_origin");
	clip_model thread demo_clip_animate_model(self, clip_files + "clip_" + level.demo_clips[which]["file"] + ".txt", 0, level.demo_clips[which]["camo"], which);

    level thread clip_array_sort("views");
}

calculatePageCount(itemCount, items_per_page, filter) {
    if(filter != "no_filter") {
        itemCount = 0;

        for(i = 0;i < level.demo_clips.size;i++) {
            if(isdefined(level.demo_clips[(i)])) {
                if(isdefined(level.demo_clips[i]["tag"]) && level.demo_clips[i]["tag"] == filter)
                    itemCount++;
            }
        }
    }

  	pages = int(ceil(itemCount / items_per_page));
  	return pages;
}

delete_clip(which, owner) {
    clip_files = getDvar("fs_homepath") + "/cjstats" + "/map_data/" + getdvar("mapname" ) +"/clip_data/";

    if(owner.current_clip_filter != "no_filter")
        which = owner.clip_filter_arr[which];

    which = level.demo_clips[(which)]["file"];

    if(fileExists(clip_files + "clip_" + which + ".txt")) {
        description = readfile(clip_files + "clip_" + which + ".txt", 0, 0, 0) + "\n" + readfile(clip_files + "clip_" + which + ".txt", 0, 0, 1);
        converted = csv_decode(description)[0];

        if(owner.guid == converted["guid"] || owner.name == converted["owner"] || isdefined(level.cj_admin[owner.guid].name)) {
            deletefile(clip_files + "clip_" + which + ".txt");

            if(owner.name == converted["owner"] || owner.guid == converted["guid"])
                owner tell_raw(level.clip_system_prf + "Clip Successfully Removed!");
            else
                owner tell_raw(level.clip_system_prf + "You are not the Clip Owner, but you are Allowed ^8O_O");

            level notify("new_demo_clip");
        }
        else
            owner tell_raw(level.clip_system_prf + "Madafaka that aint your Clip!");
    }
}

rename_clip(which, owner) {
    clip_files = getDvar("fs_homepath") + "/cjstats" + "/map_data/" + getdvar("mapname" ) +"/clip_data/";

    if(owner.current_clip_filter != "no_filter")
        which = owner.clip_filter_arr[which];

    which = level.demo_clips[(which)]["file"];

    if(fileExists(clip_files + "clip_" + which + ".txt")) {
        description = readfile(clip_files + "clip_" + which + ".txt", 0, 0, 0) + "\n" + readfile(clip_files + "clip_" + which + ".txt", 0, 0, 1);
        converted = csv_decode(description)[0];

        if(owner.guid == converted["guid"] || owner.name == converted["owner"] || isdefined(level.cj_admin[owner.guid].name)) {
            owner setclientdvar("clip_save", 1);
            owner setclientdvar("clip_latest_seconds", converted["length"]);
            owner setclientdvar("menu_int", 1);
            owner.clip_save_desc = converted["desc"];
            owner openmenu("openclientmenus");
            owner setclientdvar("clip_description_txt", "^8Type to Write^7!");
            owner waittill("clip_saved");

            clip_info               = [];
            clip_info["owner"]      = converted["owner"];
            clip_info["desc"]       = owner.clip_save_desc;
            clip_info["likes"]      = converted["likes"];
            clip_info["views"]      = converted["views"];
            clip_info["camo"]       = converted["camo"];
            clip_info["length"]     = converted["length"];
            clip_info["guid"]       = converted["guid"];
            if(isdefined(converted["clip_fps"]))
                clip_info["clip_fps"]   = converted["clip_fps"];
            clip_info["tag"]        = owner.current_clip_tag;

            replaceline(clip_files + "clip_" + which + ".txt", 2, "", 0, 0);
            replaceline(clip_files + "clip_" + which + ".txt", 1, csv_encode(clip_info), 0, 0);

            owner tell_raw(level.clip_system_prf + "Clip Successfully Renamed!");

            level notify("new_demo_clip");
        }
        else
            owner tell_raw(level.clip_system_prf + "Madafaka that aint your Clip!");
    }
}

update_clips_menu(which) {
    clip_files = getDvar("fs_homepath") + "/cjstats" + "/map_data/" + getdvar("mapname" ) +"/clip_data/";

	if(isdefined(which)) {
		if(which == "next")
			self.clips_menu_page++;
		else
			self.clips_menu_page--;
	}

    level.clip_max_pages = calculatePageCount(level.demo_clips.size, level.clip_max_items, self.current_clip_filter);

    if(level.clip_max_pages == 0)
        level.clip_max_pages = 1;

    self setclientdvar("menu_clips_pagecount", self.clips_menu_page + " / " + level.clip_max_pages);

    if(self.current_clip_filter == "no_filter") {
        start = level.clip_max_items * (self.clips_menu_page - 1);

        for(i = 0;i < level.clip_max_items;i++) {
            if(isdefined(level.demo_clips[(start + i)])) {
                self setclientdvar("menu_clips_" + i + "_a", "" + level.demo_clips[(start + i)]["owner"] + "\r                                " + level.demo_clips[(start + i)]["desc"]);
                self setclientdvar("menu_clips_" + i + "_b", "" + clip_time_converted(level.demo_clips[(start + i)]["length"]) + "\r                              " + level.demo_clips[(start + i)]["likes"] + "\r                                                      " + level.demo_clips[(start + i)]["views"]);
                if(isdefined(level.demo_clips[(start + i)]["tag"]))
                    self setclientdvar("menu_clips_" + i + "_label", level.demo_clips[(start + i)]["tag"]);
                else
                    self setclientdvar("menu_clips_" + i + "_label", "# ^1Not Selected");
            }
            else {
                self setclientdvar("menu_clips_" + i + "_a", "");
                self setclientdvar("menu_clips_" + i + "_b", "");
                self setclientdvar("menu_clips_" + i + "_label", "");
            }
        }
    }
    else {
        start = level.clip_max_items * (self.clips_menu_page - 1);
        count = 0;

        for(i = 0; i < level.demo_clips.size; i++) {
            if(isdefined(level.demo_clips[i]["tag"]) && level.demo_clips[i]["tag"] == self.current_clip_filter) {
                if(count >= start && count < (start + level.clip_max_items)) {
                    self setclientdvar("menu_clips_" + (count - start) + "_a", "" + level.demo_clips[i]["owner"] + "\r                                " + level.demo_clips[i]["desc"]);
                    self setclientdvar("menu_clips_" + (count - start) + "_b", "" + clip_time_converted(level.demo_clips[i]["length"]) + "\r                              " + level.demo_clips[i]["likes"] + "\r                                                      " + level.demo_clips[i]["views"]);
                    self setclientdvar("menu_clips_" + (count - start) + "_label", level.demo_clips[i]["tag"]);
                    self.clip_filter_arr[count - start] = i;
                }
                count++;
            }
        }
        for(i = count - start; i < level.clip_max_items; i++) {
            self setclientdvar("menu_clips_" + i + "_a", "");
            self setclientdvar("menu_clips_" + i + "_b", "");
            self setclientdvar("menu_clips_" + i + "_label", "");
        }
    }
}

check_clip_files() {
	level endon("end_game");

	if(!directoryExists(getDvar("fs_homepath") + "/cjstats" + "/map_data/" + getdvar("mapname") + "/clip_data/"))
		createDirectory(getDvar("fs_homepath") + "/cjstats" + "/map_data/" + getdvar("mapname") + "/clip_data/");

	clip_files = getDvar("fs_homepath") + "/cjstats" + "/map_data/" + getdvar("mapname" ) +"/clip_data/";

	if(!isdefined(level.demo_clips))
		level.demo_clips = [];

	for(i = 0;i < getdvarint("max_clips");i++) {
		if(fileExists(clip_files + "clip_" + i + ".txt")) {
            description = readfile(clip_files + "clip_" + i + ".txt", 0, 0, 0) + "\n" + readfile(clip_files + "clip_" + i + ".txt", 0, 0, 1);
            converted = csv_decode(description)[0];

            origin = strtok(readfile(clip_files + "clip_" + i + ".txt", 0, 0, int(countlines(clip_files + "clip_" + i + ".txt") - 1)), ",");
            origin = (float(origin[0]), float(origin[1]), float(origin[2]));

			if(isdefined(converted)) {
                num = level.demo_clips.size;

                if(!isdefined(converted["likes"]))
                    print("\r" + level.clip_system_prf + "Broken Clip File ^1" + clip_files + "clip_" + i + ".txt");
                else {
                    level.demo_clips[num] 				= [];

                    level.demo_clips[num]["owner"] 		= converted["owner"];
                    level.demo_clips[num]["desc"] 		= converted["desc"];
                    level.demo_clips[num]["guid"] 		= converted["guid"];
                    level.demo_clips[num]["likes"] 		= int(converted["likes"]);
                    level.demo_clips[num]["views"] 		= int(converted["views"]);
                    level.demo_clips[num]["camo"] 		= int(converted["camo"]);
                    level.demo_clips[num]["length"] 	= int(converted["length"]);
                    level.demo_clips[num]["origin"] 	= origin;
                    level.demo_clips[num]["file"] 	    = i;
                    if(isdefined(converted["tag"]))
                        level.demo_clips[num]["tag"] 		= converted["tag"];
                    if(isdefined(converted["clip_fps"]))
                        level.demo_clips[num]["clip_fps"] 	= int(converted["clip_fps"]);
                }
			}
		}
	}

    level thread clip_array_sort("views");

	while(1) {
		level waittill("new_demo_clip");

        level.demo_clips = undefined;
        level.demo_clips = [];

		for(i = 0;i < getdvarint("max_clips");i++) {
            if(fileExists(clip_files + "clip_" + i + ".txt")) {
                description = readfile(clip_files + "clip_" + i + ".txt", 0, 0, 0) + "\n" + readfile(clip_files + "clip_" + i + ".txt", 0, 0, 1);
                converted = csv_decode(description)[0];

                origin = strtok(readfile(clip_files + "clip_" + i + ".txt", 0, 0, int(countlines(clip_files + "clip_" + i + ".txt") - 1)), ",");
                origin = (float(origin[0]), float(origin[1]), float(origin[2]));

                if(isdefined(converted)) {
                    num = level.demo_clips.size;

                    if(!isdefined(converted["likes"]))
                        print("\r" + level.clip_system_prf + "Broken Clip File ^1" + clip_files + "clip_" + i + ".txt");
                    else {
                        level.demo_clips[num] 				= [];

                        level.demo_clips[num]["owner"] 		= converted["owner"];
                        level.demo_clips[num]["desc"] 		= converted["desc"];
                        level.demo_clips[num]["guid"] 		= converted["guid"];
                        level.demo_clips[num]["likes"] 		= int(converted["likes"]);
                        level.demo_clips[num]["views"] 		= int(converted["views"]);
                        level.demo_clips[num]["camo"] 		= int(converted["camo"]);
                        level.demo_clips[num]["length"] 	= int(converted["length"]);
                        level.demo_clips[num]["origin"] 	= origin;
                        level.demo_clips[num]["file"] 	    = i;
                        if(isdefined(converted["tag"]))
                            level.demo_clips[num]["tag"] 	= converted["tag"];
                        if(isdefined(converted["clip_fps"]))
                            level.demo_clips[num]["clip_fps"] 	= int(converted["clip_fps"]);
                    }
                }
            }
        }

        level thread clip_array_sort("views");

        foreach(player in level.players)
            player thread update_clips_menu();
	}
}

clip_array_sort(key) {
    if(isdefined(level.demo_clips)) {
        for(i = 0;i < level.demo_clips.size - 1;i++) {
            if(isdefined(level.demo_clips[i])) {
                for(j = 0;j < level.demo_clips.size - i - 1;j++) {
                    if(isdefined(level.demo_clips[j + 1])) {
                        if(level.demo_clips[j][key] < level.demo_clips[j + 1][key]) {
                            temp = level.demo_clips[j];

                            level.demo_clips[j] = level.demo_clips[j + 1];
                            level.demo_clips[j + 1] = temp;
                        }
                    }
                }
            }
        }
    }
}

update_clip_info(filenum) {
	clip_dir = getDvar("fs_homepath") + "/cjstats" + "/map_data/" + getdvar("mapname" ) +"/clip_data/";

	clip_info = [];

	clip_info["owner"] 		= level.demo_clips[filenum]["owner"];
	clip_info["desc"] 		= level.demo_clips[filenum]["desc"];
    clip_info["guid"] 		= level.demo_clips[filenum]["guid"];
	clip_info["likes"] 		= int(level.demo_clips[filenum]["likes"]);
	clip_info["views"] 		= int(level.demo_clips[filenum]["views"]);
	clip_info["camo"] 		= int(level.demo_clips[filenum]["camo"]);
	clip_info["length"] 	= int(level.demo_clips[filenum]["length"]);
    if(isdefined(level.demo_clips[filenum]["tag"]))
        clip_info["tag"] 		= level.demo_clips[filenum]["tag"];
    if(isdefined(level.demo_clips[filenum]["clip_fps"]))
        clip_info["clip_fps"]   = level.demo_clips[filenum]["clip_fps"];

    replaceline(clip_dir + "clip_" + level.demo_clips[filenum]["file"] + ".txt", 2, "", -1, -1);
    replaceline(clip_dir + "clip_" + level.demo_clips[filenum]["file"] + ".txt", 1, csv_encode(clip_info), -1, -1);
}

sprint_checker() {
	self endon("disconnect");

	self.issprinting = 0;

	while(1) {
		self waittill("+sprintbutton");
		self.issprinting = 1;

		self waittill("sprint_end");
		self.issprinting = 0;
	}
}

clip_num_mapping(info) {
	if(!isdefined(level.clip_num_mapping)) {
		level.clip_num_mapping 				= [];

		level.clip_num_mapping["stand"] 	= 0;
		level.clip_num_mapping["crouch"] 	= 1;
		level.clip_num_mapping["prone"] 	= 2;
		level.clip_num_mapping["none"] 		= 3;
	}
	else
		return level.clip_num_mapping[info];
}

convert_stance(num) {
	if(!isdefined(num))
		return "none";
	else if(num == 0)
		return "stand";
	else if(num == 1)
		return "crouch";
	else if(num == 2)
		return "prone";
	else
		return "none";
}

demo_save_cooldown(time) {
	self.clip_cooldown = 1;
	wait time;
	self.clip_cooldown = undefined;
}

filter_clips(which) {
    self.current_clip_filter = which;
    self.clips_menu_page = 1;
    self setclientdvar("menu_clips_pagecount", self.clips_menu_page + " / " + level.clip_max_pages);
    self thread update_clips_menu();
}