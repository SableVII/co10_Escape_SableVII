// Initialization for server
if (!isServer) exitWith {};

private _spawnSegment = [] call A3E_fnc_FindSpawnRoad;

if(!isNull _spawnSegment) then {
	[getPos _spawnSegment, a3e_var_Escape_enemyMinSkill, a3e_var_Escape_enemyMaxSkill, A3E_Param_EnemyFrequency, A3E_Debug] execVM "Scripts\Escape\CreateReinforcementTruck.sqf";
} else {
	diag_log ("ESCAPE SURPRISE: Unable to find road segment for Reinforcement truck");
};

//SystemChat "Escape Surprise: REINFORCEMENTTRUCK";