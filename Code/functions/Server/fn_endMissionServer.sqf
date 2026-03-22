params["_end"];
[_end] call A3E_fnc_EndSession;
[_end] call A3E_fnc_SaveStatistics;
systemChat Format["--Everyone is dead/unconscious. Mission Failed."];
if (A3E_Param_NoAutomaticMissionEnd == 0) then {
	systemChat Format["-- Should be ending server"];
	_end call BIS_fnc_endMissionServer;
};