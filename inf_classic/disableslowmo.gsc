main() {
	replacefunc(maps\mp\gametypes\_killcam::doFinalKillCamFX, ::disableDoFinalKillCamFX);
}

disableDoFinalKillCamFX( camTime ) {
	if ( isDefined( level.doingFinalKillcamFx ) )
    	return;

    level.doingFinalKillcamFx = true;
    level.doingFinalKillcamFx = undefined;
}