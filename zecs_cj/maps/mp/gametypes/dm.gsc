main() {
	setDvar( "g_gametype", "cj" );
	setDvar( "ui_gametype", "cj" );

	level.callbackStartGameType = maps\mp\gametypes\_callbacksetup::callbackVoid;
	level.callbackPlayerConnect = maps\mp\gametypes\_callbacksetup::callbackVoid;
	level.callbackPlayerDisconnect = maps\mp\gametypes\_callbacksetup::callbackVoid;
	level.callbackPlayerDamage = maps\mp\gametypes\_callbacksetup::callbackVoid;
	level.callbackPlayerKilled = maps\mp\gametypes\_callbacksetup::callbackVoid;
	level.callbackCodeEndGame = maps\mp\gametypes\_callbacksetup::callbackVoid;
	level.callbackPlayerLastStand = maps\mp\gametypes\_callbacksetup::callbackVoid;
	level.callbackPlayerMigrated = maps\mp\gametypes\_callbacksetup::callbackVoid;
	level.callbackHostMigration = maps\mp\gametypes\_callbacksetup::callbackVoid;

	map_restart();
}