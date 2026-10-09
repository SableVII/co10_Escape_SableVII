systemChat Format["--Automatic ending is disabled. To restart, type '#restart' on dedicated server or press F1 on local host."];

_display = findDisplay 46;
_event_id = _display displayAddEventHandler ["KeyDown", {
	params ["_displayorcontrol", "_key", "_shift", "_ctrl", "_alt"];
	if (_key == 59) then {
		"end1" remoteExec ["BIS_fnc_endMissionServer", 2];
	};
}];