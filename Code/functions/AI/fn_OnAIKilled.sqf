params ["_unit"];

// Make sure this Unit is not a Player
if (isPlayer _unit) exitWith { };

// Remove Magazines for Ammo Scarcity
if (_unit getVariable["magsWereRemoved", false] == false) then { // Don't remove mags if they were already removed (ie. from unconcious -> death)
	[_unit] call A3E_Fnc_RemoveMags;
};
