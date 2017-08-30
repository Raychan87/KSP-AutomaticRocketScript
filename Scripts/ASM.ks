//Boot Program for all Rockets.
//=============================
//build by Raychan for KSP v1.2.2
//					   KOS v1.1.0
//					   RSS/RO/RP-0
//
//---------------------------------------------------------------------------//
//Change log table:						Version 0.3(testet)
//Date          | Changes
//24.08.2017	| - erstellt
//28.08.2017	| - Code Optimierung
//				| - 
//---------------------------------------------------------------------------//

//Starten des Boot vorgangs.
CLEARSCREEN.
PRINT "[ASM] Automatic safety and monitoring program.".
PRINT "=========================================================".
PRINT "ASM Wird geladen...".
PRINT " ".
//Flags
DECLARE vFairingFlag IS 0.
DECLARE vModule IS 0.
DECLARE vSolarPanel IS 0.
DECLARE vFallschirm IS 0.
DECLARE vAntennen IS 0.

//Höhen Einstellungen
DECLARE vAntennenHigh IS 145000.
DECLARE vFallschirmHigh IS 20000.
DECLARE vSolarPanelHigh IS 140000.
DECLARE vFaringhigh IS 135000.

WAIT 2.
PRINT "ASM ist geladen und Aktiv.".
PRINT "ASM kann nur mit [STRG] + [C] Beendet werden.".
PRINT " ".

//Main
UNTIL 0 {
	//---------------------------------------------------------------------------//
	//Fairing Steuerung
	//===========================================================================//
	IF vFairingFlag = 0 AND SHIP:ALTITUDE > vFaringhigh{
		//Abarbeiten der Liste aller Stock und KW Fairings
		FOR vModule IN SHIP:MODULESNAMED("ModuleProceduralFairing") { 
			//Fairings werden Decouplet
			vModule:DOEVENT("deploy").
			PRINT "Fairings getrennt.".
		}
		//Abarbeiten der Liste aller Procedural Fairings Mod
		FOR vModule IN SHIP:MODULESNAMED("ProceduralFairingDecoupler") { 
			//Fairings werden Decoupelt
			vModule:DOEVENT("jettison").
			PRINT "Fairings getrennt.".
		}
		set vFairingFlag TO 1.
	}
	//---------------------------------------------------------------------------//
	//Solarpanel Steuerung (nur bei Erde!!)
	//===========================================================================//
	IF vSolarPanel = 0 AND SHIP:ALTITUDE > vSolarPanelHigh{
		PANELS ON.
		PRINT"SolarPanels werden ausgefahren.".
		set vSolarPanel TO 1.
	}
	IF vSolarPanel = 1 AND SHIP:ALTITUDE < vSolarPanelHigh - 10000{
		PANELS OFF.
		PRINT"SolarPanels werden eingefahren.".
		set vSolarPanel TO 0.
	}
	//---------------------------------------------------------------------------//
	//Fallschirm Steuerung (nur für Erde!!)
	//===========================================================================//
	IF vFallschirm = 0 AND SHIP:ALTITUDE > vFallschirmHigh + 10000{
		PRINT "Fallschirme sind jetzt aktiv.".
		SET vFallschirm TO 1.
	}
	IF vFallschirm = 1 AND SHIP:ALTITUDE < vFallschirmHigh{
		CHUTES ON.
		PRINT "Fallschirme wurden aktiviert.".
	}
	//---------------------------------------------------------------------------//
	//Energie Überwachung
	//===========================================================================//
	IF vAntennen = 0 AND SHIP:ALTITUDE > vAntennenHigh{
		SET vAntennen TO 1.
		PRINT "Antennen werden ausgefahren.".
		
	}
	IF vAntennen = 1 AND SHIP:ALTITUDE < vAntennenHigh - 10000{
		SET vAntennen TO 0.
		PRINT "Antennen werden eingefahren.".
	}
	
	//---------------------------------------------------------------------------//
	//Energie Überwachung
	//===========================================================================//
	
	//---------------------------------------------------------------------------//
	//Escape Kommando Modul
	//===========================================================================//
}
