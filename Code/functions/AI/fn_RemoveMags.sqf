params ["_unit"];

removeContainerMags = {
	params ["_container"];

	private _removedMags = [];
	
	private _intelItems = missionnamespace getvariable ["A3E_IntelItems",["Files","FileTopSecret","FilesSecret","FlashDisk","DocumentsSecret","Wallet_ID","FileNetworkStructure","MobilePhone","SmartPhone"]];


	if (isNull _container == false) then {
		{
			private _magName = _x select 0;
			
			// Ignore any intel items as they are listed as magazines and can't be identified by anything other than their name :\
			if (_magName in _intelItems) then {
				continue;
			}; 
						
			// Checking if nameSound == "magazine" or "mgun" ... im not sure what other way to tell if this magazine is a weapon's magazine.
			private _nameSound = getText(configFile >> "CfgMagazines" >> _magName >> "nameSound");
			if (_nameSound == "magazine" || _nameSound == "mgun") then {
				if (A3E_Param_AmmoScarcity >= random 100) then {
					_removedMags pushBack [_magName, _x select 1];	
				}	 
			};
		} foreach magazinesAmmoCargo _container;
	};
	   
	// Actually remove the mags
	{
		_container addMagazineCargoGlobal [_x select 0, -1]; // Removes one magazine of type
	} foreach _removedMags;
	
	_removedMags;
};

private _magsRemoved = [[], [], []]; // [[uniform mags], [vest mags], [backpack mags]]

private _uniform = uniformContainer _unit;
if (isNull _uniform == false) then {
	_magsRemoved set [0, [_uniform] call removeContainerMags];
};

private _vest = vestContainer _unit;
if (isNull _vest == false) then {
	_magsRemoved set [1, [_vest] call removeContainerMags];
};

private _backpack = backpackContainer _unit;
if (isNull _backpack == false) then {
	_magsRemoved set [2, [_backpack] call removeContainerMags];
};

//systemChat Format["Mags Removed: %1", _magsRemoved]; 

_magsRemoved;