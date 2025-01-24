// Initialization for server
if (!isServer) exitWith {};

private _spawnSegment = [] call A3E_fnc_FindSpawnRoad;
if(!isNull _spawnSegment) then {
	[getPos _spawnSegment, drn_searchAreaMarkerName, A3E_Param_EnemyFrequency, a3e_var_Escape_enemyMinSkill, a3e_var_Escape_enemyMaxSkill, A3E_Debug] execVM "Scripts\Escape\CreateMotorizedSearchGroup.sqf";
} else {
	diag_log "ESCAPE SURPRISE: Unable to find spawn road for Motorized Searchgroup";
};

//SystemChat "Escape Surprise: MOTORIZEDSEARCHGROUP";