init() {
	mapname = getdvar("ui_mapname");

	if(mapname == "mp_highrise")
		level CreatePushRegion((-2837.96,5076.25,3213.06), (-2584.63,6882.61,3472.84), (-2816.88, 6891.32, 3232.13));
}

CreatePushRegion(corner1, corner2, pushOrigin) {
    level thread PushRegionThread(corner1, corner2, pushOrigin);
}

PushRegionThread(corner1, corner2, pushOrigin){
    level endon("game_ended");
    
    for(;;) {
        foreach (entity in level.Players) {
            if(insideRegionZ(corner1, corner2, entity.Origin)) {
                entity SetOrigin(pushOrigin);
            }
        }
        wait 0.1;
    }
}

insideRegionZ ( A , B , C) {

    x1 = A[0];
    x2 = B[0];

    y1 = A[1];
    y2 = B[1];
    
    z2 = B[2];
    z = A[2];

    xP = C[0];
    yP = C[1];
    zP = C[2];

    return ((x1 < xP && xP < x2) || x1 > xP && xP > x2) && ((y1 < yP && yP < y2) || y1 > yP && yP > y2) && (zP < z2) && (zP > z);
}

