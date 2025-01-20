params["_numIntel"];

private _pois = (missionnamespace getvariable ["A3E_POIs",[]] select {_x # 7 && (_x # 4 || _x # 5)});
_numIntel = _numIntel min count(_pois);

//private _markertype = "Unknown";
for [{ _i = 0 }, { _i < _numIntel }, { _i = _i + 1 }] do { 
	private _poi = selectRandom _pois;

	// If type is a communication center, try another roll. (To make communication centers just a bit less likely to be instantly found by intel)
	_poi params ["_marker","_markerType","_color","_markerPosition","_hidden","_unknown","_accuracy"];	
	if (_markerType == "o_hq") then {
		_poi = selectRandom _pois;
	};
	
	_markerType = [_poi # 0] call A3E_fnc_updateLocationMarker;
	
	switch(_markerType) do {
		case "o_hq": { 
			format["Intel revealed the location of a communication center."] remoteexec ["systemchat",0];
		};
		case "o_service": { 
			format["Intel revealed the location of a vehicle depot."] remoteexec ["systemchat",0];
		};
		case "hd_warning": { 
			format["Intel revealed the location of wreckage of an allied vehicle."] remoteexec ["systemchat",0];
		};
		case "o_installation": { 
			format["Intel revealed the location of an ammo depot."] remoteexec ["systemchat",0];
		};
		case "o_mortar": { 
			format["Intel revealed the location of a mortar site."] remoteexec ["systemchat",0];
		};
		default { 
			format["Intel revealed one point of interest on the map."] remoteexec ["systemchat",0];
		};
	};
};