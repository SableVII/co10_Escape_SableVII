params ["_weapon", ["_factionSpecific", false], ["_faction", independent]];

if (_weapon == "") exitWith {
	"";
};
	
private _tracerColor = "y"; 
switch (_faction) do { 
	case independent:  {_tracerColor = "g"}; 
	case east: {_tracerColor = "r"}; 
	case west: {_tracerColor = "y"};
};

private _primeMagazine = getArray(configfile >> "CfgWeapons" >> _weapon >> "magazines") select 0;	   

private _weaponCompatMagsMap = [_weapon] call a3e_fnc_TryGetCompatibleWeaponMags;
private _weaponName = toLower _weapon;

// Check if weapon has a compatMagsMap
	  

private _primeMagazineName = toLower (_primeMagazine);
if (_primeMagazineName in _weaponCompatMagsMap == false) exitWith {
	""; 
};	

// Check if this is a known mag that can't be replaced
if ((_weaponName + _primeMagazine) in a3e_var_WeaponsWithNonReplaceableMags) exitWith {
	""; 
};
	
//systemChat "d";		
private _tracerMag = "";

private _needNewTracerSelectionList = true;
private _needNewTracerSelectionListList = true;
private _tracerSelectionListList = [];
if (_primeMagazineName in a3e_var_MagToTracerMagMap) then {
	_needNewTracerSelectionListList = false;
	
	_tracerSelectionListList = a3e_var_MagToTracerMagMap get _primeMagazineName;
	 
	// Check to see if seleting tracer mag is compatable with current weapon, if not, continue checking list
	{
		private _tracerSelectionList = _x;		
		private _checkingMag = ""; // Should never end up ""
		
		// Select by faction color if appicable
		if (_factionSpecific) then {
			switch (_tracerColor) do {
				case "r": { _checkingMag = _x select 0; };
				case "g": { _checkingMag = _x select 1; };
				case "y": { _checkingMag = _x select 2; };
				default { _checkingMag = _x select 3; };							  
			};
		} else {
		  _checkingMag = _x select 3;  
		};
				
		if (_checkingMag in _weaponCompatMagsMap) then {
			_tracerMag = _checkingMag;
			_needNewTracerSelectionList = false;
			exit;
		};					
	} foreach _tracerSelectionListList;
};   

if (_needNewTracerSelectionList || _needNewTracerSelectionListList) then {
	// Create TracerSelectionList		
	private _primeMagRoundCount =  getNumber (configFile >> "CfgMagazines" >> _primeMagazine >> "count");
	
	// Try to find best tracer mag based off round count - tracersEvery - and at worst lastRoundsTracer.
	private _correctTracerMags = []; // For mags the perfectly match the original round count (if applicable) and is all tracers
	private _semiCorrectTracerMags = []; // For mags that have right round count but every few rounds are tracers OR round count != the original mag count but is all tracers
	private _lessIdealTracerMags = []; // For mags with only last tracers (must match original round count)
	{
		// Check for High Explosive, Frag, and Smoke mags (For shotguns). Also ignore ACE IR Tracer mags. 
		private _xLower = toLower _x; 
		if (_xLower find "_he" > 0 || _xLower find "_frag" > 0 || _xLower find "_smoke" > 0 || _xLower find "_dim" > 0 || _xLower find "_mdim" > 0 || _xLower find "_tdim" > 0) then {
			continue;
		};
	  
		private _tracersEvery = getNumber (configFile >> "CfgMagazines" >> _x >> "tracersEvery");
		if (_primeMagRoundCount isEqualTo -1 || _primeMagRoundCount == getNumber(configFile >> "CfgMagazines" >> _x >> "count")) then {
			// Correct tracer Mag check. Counts == Same && tracersEvery == 1
			if (_tracersEvery isEqualTo 1) then {
				// Catch FAKE tracer mags (Global Mobilization is weird and has FAKE mags that have 'tracersEvery' set to 0, but it doesnt actually fire tracers!?!)
				private _dlc =  getText(configFile >> "CfgMagazines" >> _x >> "dlc");
				//systemChat Format ["DLC: %1", _dlc];
				if (_dlc isEqualTo "gm") then {
					private _ammoName = getText(configFile >> "CfgMagazines" >> _x >> "ammo");				  
					if (_ammoName find "_T_" > 0) then { // The ones with "_T_" in the ammo name I believe are good
						_correctTracerMags pushBack _x;
					};
				} else {
					_correctTracerMags pushBack _x; 
				};
			} else {
				// Semi-Ideal check. Counts == Same && tracersEvery != 0
				if (_tracersEvery isNotEqualTo 0) then {
					_semiCorrectTracerMags pushBack _x;	
				} else {
					// Less ideal check. Counts == Same && lastRoundsTracer != 0 
					if (getNumber (configFile >> "CfgMagazines" >> _x >> "lastRoundsTracer") isNotEqualTo 0) then {
						_lessIdealTracerMags pushBack _x;			 
					};
				};
			};			
		} else {
			// Semi-Ideal. Counts != Same && tracersEvery == 1
			if (_tracersEvery isEqualTo 1) then {
				_semiCorrectTracerMags pushBack _x;	
			}
		};		
	} foreach _weaponCompatMagsMap; // _weaponCompatMagsMap should already be found if found or created

	//systemChat (format ["Correct: %1, Semi-Correct %2, Less Ideal: %3", count _correctTracerMags, count _semiCorrectTracerMags, count _lessIdealTracerMags]);
	
	// Pick from the other next-best mags (if any)
	if (count _correctTracerMags == 0) then {
		if (count _semiCorrectTracerMags == 0) then 
		{
			_correctTracerMags = _lessIdealTracerMags;
		} else {
			_correctTracerMags = _semiCorrectTracerMags;
		};
	};
	
	private _saveList = ["", "", "", ""]; // Slots can share other colors. They should never end up empty. [Red, Green, Yellow, Random-One] 
	 
	if (count _correctTracerMags > 0) then {
		//_tracerMag = _correctTracerMags select 0;
		 
		private _redColorMags = [];
		private _greenColorMags = [];
		private _yellowColorMags = [];
		private _otherColorMags = [];
		{
			private _magName = toLower _x;
			if (_magName find "red" > 0) then {
				_redColorMags pushBack _x;
				continue;
			};
			if (_magName find "green" > 0) then {
				_greenColorMags pushBack _x;					
				continue;
			};
			if (_magName find "yellow" > 0) then {
				_yellowColorMags pushBack _x;  
				continue;				
			};
			
			_otherColorMags pushBack _x;		
	
		} foreach _correctTracerMags;   
		
		// Save redMag. Prefer Red->Other->Yellow->Green;
		private _redMag = "";
		if (count _redColorMags > 0) then {
			_redMag = _redColorMags select (floor random (count _redColorMags));
		} else {
			if (count _otherColorMags > 0) then {
				_redMag = _otherColorMags select (floor random (count _otherColorMags));   
			} else {
				if (count _yellowColorMags > 0) then {
					_redMag = _yellowColorMags select (floor random (count _yellowColorMags)); 
				} else {
					_redMag = _greenColorMags select (floor random (count _greenColorMags)); 
				};
			};
		};
		_saveList set [0, _redMag];
		
		// Save greenMag. Prefer Green->Other->Yellow->Red;
		private _greenMag = "";
		if (count _greenColorMags > 0) then {
			_greenMag = _greenColorMags select (floor random (count _greenColorMags));
		} else {
			if (count _otherColorMags > 0) then {
				_greenMag = _otherColorMags select (floor random (count _otherColorMags));   
			} else {
				if (count _yellowColorMags > 0) then {
					_greenMag = _yellowColorMags select (floor random (count _yellowColorMags)); 
				} else {
					_greenMag = _redColorMags select (floor random (count _redColorMags)); 
				};
			};
		};
		_saveList set [1, _greenMag];
		
		// Save yellowMag. Prefer Yellow->Other->Red->Green;
		private _yellowMag = "";
		if (count _yellowColorMags > 0) then {
			_yellowMag = _yellowColorMags select (floor random (count _yellowColorMags));
		} else {
			if (count _otherColorMags > 0) then {
				_yellowMag = _otherColorMags select (floor random (count _otherColorMags));   
			} else {
				if (count _redColorMags > 0) then {
					_yellowMag = _redColorMags select (floor random (count _redColorMags)); 
				} else {
					_yellowMag = _greenColorMags select (floor random (count _greenColorMags)); 
				};
			};
		};
		_saveList set [2, _yellowMag];
		
		// Saving a random mag for when Faction Specific Mode is on
		_saveList set [3, _correctTracerMags select (floor random count _correctTracerMags)];
				
		//systemChat (format ["Adding Saved. Red: %1, Green: %2, Yellow: %3, Other: %4", count _redColorMags, count _greenColorMags, count _yellowColorMags, count _otherColorMags, _saveList select 3]);				 
	}; 
	
	
	// Select a mag of prefered color
	if (_factionSpecific) then {
		switch (_tracerColor) do {
			case "r": { _tracerMag = _saveList select 0; };
			case "g": { _tracerMag = _saveList select 1; };
			case "y": { _tracerMag = _saveList select 2; };
			default { _tracerMag = _saveList select 3; };							  
		};				
	} else {
	  _tracerMag = _saveList select 3;  
	};
	
	// If there isn't a tracer mag available for this Weapon and Original Mag, then remember this combo for later
	if (_tracerMag == "") then {
		a3e_var_WeaponsWithNonReplaceableMags set [_weaponName + _primeMagazine, true];
		
		if (_needNewTracerSelectionListList == false && name player == "Sable7") then {
			systemChat Format["Rare Case: %1  with Mag: %2", _weaponName, _primeMagazine];
		};
	} else {
		// Save info about this list for optimized use later!
		_tracerSelectionListList pushback _saveList;
		
		if (_needNewTracerSelectionListList == true) then {
			 a3e_var_MagToTracerMagMap set [_primeMagazineName, _tracerSelectionListList];
		};
	};		   
};	

_tracerMag; 