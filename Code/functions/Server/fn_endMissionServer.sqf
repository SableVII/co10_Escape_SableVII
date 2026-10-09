params["_end"];
[_end] call A3E_fnc_EndSession;
[_end] call A3E_fnc_SaveStatistics;

if (_end == "end1") then {
	systemChat Format["--Everyone is dead/unconscious. Mission Failed."];
};

if (A3E_Param_NoAutomaticMissionEnd == 0 || _end != "end1") then {
	_end call BIS_fnc_endMissionServer;
}
else
{
	[] remoteexec ["A3E_fnc_AwaitEndKeyPress", 0];
};