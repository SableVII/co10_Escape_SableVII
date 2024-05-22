params ["_unit", "_state"];

// Make sure this Unit is not a Player
if (isPlayer _unit) exitWith { };

// Remove Magazines for Ammo Scarcity
if (_state == true) then {
	// Remove magazines
	_unit setVariable["unconsciousRemovedMags", [_unit] call A3E_fnc_RemoveMags];
	_unit setVariable["magsWereRemoved", true];
	
} else {
	// Return removed magazines
	[_unit, _unit getVariable["unconsciousRemovedMags", []]] call A3E_fnc_ReturnRemovedMags;
	_unit setVariable["magsWereRemoved", false];
};	

// Unconscious Cleanup
if (_state == true) then {

	// Bind to Killed Event to ensure any Unconscious AI will get a Killed event. Save eventIndex for removal later if the unit wakes back up.
	private _eventIndex = _unit addEventHandler ["Killed", 
	{
		params ["_unit"];
		if (isPlayer _unit) exitWith { };
		
		// Unconscious Cleanup
		[_unit] call A3E_fnc_RemoveUnconsciousUnit;
		
		//systemChat Format["%1 has died", name _unit];		
	}];

	a3e_var_UnconsciousUnits pushBack [_unit, time, _eventIndex];
	//systemChat Format["%1 is Unconscious Time: %2", name _unit, time];
}
else
{
	[_unit] call A3E_fnc_RemoveUnconsciousUnit;
	//systemChat Format["%1 Woke Up!", name _unit];
};