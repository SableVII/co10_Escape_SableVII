params ["_unit", "_magsRemoved"];

returnRemovedContainerMags = {
	params ["_container", "_removedMags"];

	private _leftoverMags = [];	
	{
		if (_container canAdd (_x select 0)) then {
			_container addMagazineAmmoCargo [_x select 0, 1, _x select 1]; 
		} else {
			_leftoverMags pushBack _x;
		};
		
	} foreach _removedMags;
	
	_leftoverMags;
};

private _leftoverMags = [];

//systemChat format["Returning Magazines: %1", _magsRemoved];

private _uniform = uniformContainer _unit;
if (isNull _uniform == false) then {
	_leftoverMags append ([_uniform, _magsRemoved select 0] call returnRemovedContainerMags);
};

private _vest = vestContainer _unit;
if (isNull _vest == false) then {
	_leftoverMags append ([_vest, _magsRemoved select 1] call returnRemovedContainerMags);
};

private _backpack = backpackContainer _unit;
if (isNull _backpack == false) then {
	_leftoverMags append ([_backpack, _magsRemoved select 2] call returnRemovedContainerMags);
};

// Attempt to add any leftovers
{
	_unit addMagazine [_x select 0, _x select 1];		
} foreach _leftoverMags;