params ["_unit"];

for "_i" from 0 to (count a3e_var_UnconsciousUnits - 1) do {
	_unconsciousUnitDetails = a3e_var_UnconsciousUnits select _i;
	_unconUnit = _unconsciousUnitDetails select 0;
	
	if (_unit == _unconUnit) then {
		a3e_var_UnconsciousUnits deleteAt _i;
		_unconUnit removeEventHandler ["Killed", _unconsciousUnitDetails select 2];
		//systemChat Format["------ Cleaned Up %1", name _unit];
		break;
	};
};