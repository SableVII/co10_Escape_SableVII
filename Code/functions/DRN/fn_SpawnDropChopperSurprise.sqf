// Initialization for server
if (!isServer) exitWith {};

// Sleep till at least 28 seconds have passed since the last chopper spawned to avoid collisions
while {diag_tickTime - a3e_var_TimeSinceLastChopper < 28} do {
	sleep 5;
};
a3e_var_TimeSinceLastChopper = diag_tickTime;

private _spawnLoc = getMarkerPos "drn_dropChopperStartPosMarker";

// Make sure we don't spawn the chopper if a player is within 400m
private _allowSpawn = true;
{
	private _playerPos = getPos _x;
	if ((_playerPos vectorDistance _spawnLoc) < 400) exitWith {
		_allowSpawn = false;
	};	
} foreach call A3E_FNC_GetPlayers;

if (_allowSpawn) then {
	private _dropPosition = [drn_searchAreaMarkerName] call drn_fnc_CL_GetRandomMarkerPos;

	private _onGroupDropped = {
		private ["_group", "_dropPos"];
		
		_group = _this select 0;
		_dropPos = _this select 1;
		
		//[_group, drn_searchAreaMarkerName, _dropPos, a3e_var_Escape_DebugSearchGroup] execVM "Scripts\DRN\SearchGroup\SearchGroup.sqf";
		[_group, drn_searchAreaMarkerName, _dropPos, A3E_Debug] spawn DRN_fnc_SearchGroup;
	};

	private _helitype = a3e_arr_O_transport_heli select floor(random(count(a3e_arr_O_transport_heli)));
	private _crewtype = a3e_arr_O_pilots select floor(random(count(a3e_arr_O_pilots)));
	[_spawnLoc, A3E_VAR_Side_Opfor, _helitype, _crewtype, (A3E_Param_EnemyFrequency + 2) + floor random (A3E_Param_EnemyFrequency * 2), _dropPosition, a3e_var_Escape_enemyMinSkill, a3e_var_Escape_enemyMaxSkill, _onGroupDropped, A3E_Debug] execVM "Scripts\Escape\CreateDropChopper.sqf";
};

//SystemChat "Escape Surprise: DROPCHOPPER";