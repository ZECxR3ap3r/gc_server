main() {
	replacefunc(maps\mp\killstreaks\_nuke::nukeSlowMo, ::blank);
	replacefunc(maps\mp\gametypes\_killcam::doFinalKillCamFX, ::disableDoFinalKillCamFX);
}

blank() {
	
}

disableDoFinalKillCamFX( camTime ) {
	if ( isDefined( level.doingFinalKillcamFx ) )
    	return;
    
    level.doingFinalKillcamFx = true;
    level.doingFinalKillcamFx = undefined;
}
