// Initialization for server
if (!isServer) exitWith {};

private _spawnSegment = [] call A3E_fnc_FindSpawnRoad;

if(!isNull _spawnSegment) then {
	 [call A3E_fnc_GetPlayerGroup, getPos _spawnSegment, A3E_VAR_Side_Opfor, a3e_arr_Escape_EnemyCivilianCarTypes, A3E_arr_recon_InfantryTypes, A3E_Param_EnemyFrequency] execVM "Scripts\Escape\CreateCivilEnemy.sqf";
} else {
	diag_log ("ESCAPE SURPRISE: Unable to find road segment for Civil Enemy");
};

//SystemChat "Escape Surprise: CIVILIANENEMY";