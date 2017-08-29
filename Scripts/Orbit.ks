//Programm für ein Orbit mit einer 3 Stufigen Rakete
//Startparameter -> run orbit("Orbithöhe","Kompass Richtung").
//build by Raychan for KSP KOS
//Tested mit PERIAPSIS = 201km; APOAPSIS = 203km.
//---------------------------------------------------------------------------//
//Change log table:						Version 0.9(getestet)
//Date          | Changes
//24.08.2017	| - Erweiterung der Startparameter
//				| - Verbesserung der APOAPSIS Korrektur
//				| - Code Optimierung
//25.08.2017	| - Gravity Turn Simulation
//28.08.2017 	| - Code Optimierung
//---------------------------------------------------------------------------//

//Funktion Parameter die übergeben werden
DECLARE PARAMETER vOrbithoehe IS 200000, vCompass IS 90.
//---------------------------------------------------------------------------//
//Bildschirm Clearn und Variablen Declarieren.
//===========================================================================//
CLEARSCREEN. 
PRINT "Programm für den Orbit wird geladen...".
DECLARE vEngineStage IS 1. 		//1 = 1te Stage; 2 = 2te Stage; 3 = 3te Stage.
DECLARE vSubOrbitFlag IS 0. 	//0 = 5°Grad Pitch; 1 = 90°Grad Pitch; 2 = APOAPSIS Korrektur, 3 = APOAPSIS Korrektur Teil 2
DECLARE vPitchTxtFlag IS 0.		//Ein Flag für eine Textanzeige
DECLARE vCountdown IS 10.		//Start Countdown
DECLARE vPitch IS 0.			//Pitch für Simulierten Gravity Turn
DECLARE vApoapsisKorrektur IS 0.
DECLARE vHeading IS HEADING(vCompass,90).
WAIT 1.
PRINT "Programm mit der Orbithöhe " + vOrbithoehe + "m und".
PRINT "Kompassrichtung " + vCompass + "° wurde geladen.".
PRINT "Zum Abbruch des Starts [STRG] + [C] drücken.".
PRINT " ".
WAIT 1.
//---------------------------------------------------------------------------//
//Vorkonfiguration der Rakete
//===========================================================================//
PRINT "Konfigurationen werden übertragen...".
WAIT 1.
PRINT "Schubregler auf 100%".
LOCK THROTTLE TO 1.
PRINT "Ausrichtung der Flugrichtung".
LOCK STEERING TO vHeading.
PRINT "Konfiguration wurde erfolgreich übertragen.".
PRINT " ".
//---------------------------------------------------------------------------//
//Start des Countdoun von 10 bis 1
//===========================================================================//
PRINT "Start des Countdowns:".
FROM {vCountdown.} UNTIL vCountdown = 0 STEP {SET vCountdown TO vCountdown - 1.} DO {
	PRINT "T - " + vCountdown.
	WAIT 1.
	IF vCountdown = 6 {
		//Zündung des Triebwerks
		PRINT "Zündung des Haupttriebwerks".
		STAGE.
	}
}
//Starten der Rakete
PRINT "Trennen der Halterung vom Tower.".
STAGE.
WAIT UNTIL SHIP:VELOCITY:SURFACE:MAG > 2.
PRINT " ".
PRINT "Liftoff! We Have A Liftoff!".
PRINT " ".
//---------------------------------------------------------------------------//
//Starte Kurz für den SubOrbit
//===========================================================================//
UNTIL (SHIP:PERIAPSIS) > vOrbithoehe - 1000 {

	//Pitch auf 85° Grad
	IF SHIP:VELOCITY:SURFACE:MAG >= 100 AND SHIP:ALTITUDE >= 1000 AND vSubOrbitFlag = 0 {
		PRINT "Starten der Vorbereitungsphase.".
		PRINT "Aktuelle Höhe: " + SHIP:ALTITUDE + "m".
		PRINT "Altielle Geschwindigkeit " + SHIP:VELOCITY:SURFACE:MAG + "m/s.".
		PRINT "Pitch auf 85° Grad.".
		PRINT " ".
		SET vPitch TO 85.
		SET vHeading TO HEADING(vCompass,vPitch).
		SET vSubOrbitFlag TO 1.
	}
	//Pitch auf 0° Grad
	IF (SHIP:VELOCITY:SURFACE:MAG >= 1000 OR SHIP:ALTITUDE > 20000) AND vSubOrbitFlag = 1 {
		IF vPitchTxtFlag = 0 {
			PRINT "Starten des Simulierten Gravity Turn Phase".
			PRINT "Aktuelle Höhe: " + SHIP:ALTITUDE + "m".
			PRINT "Altielle Geschwindigkeit " + SHIP:VELOCITY:SURFACE:MAG + "m/s.".
			PRINT "Pitch auf 0° Grad.".
			PRINT " ".
			SET vPitchTxtFlag TO 1.
		}
		SET vPitch TO 90*(1-((SHIP:APOAPSIS + 1000)/vOrbithoehe)).
		SET vHeading TO HEADING(vCompass,vPitch).
		IF vPitch <= 0  {
			PRINT "Autokorrektur Phase 1 wird gestartet.".
			SET vSubOrbitFlag TO 2.
		}	
	}
	//Trennen der ersten Stufen und Zünden der zweiten.
	IF SHIP:MAXTHRUST = 0 AND vEngineStage = 1{
		//PRINT "Trennen der ersten Stufe.".
		STAGE.
		WAIT 1.
		//PRINT "Zünden der Hilfsbooster.".
		STAGE.
		WAIT 1.
		PRINT "Zünden der zweiten Stufe.".
		PRINT " ".
		STAGE.
		SET vEngineStage TO 2.
	}
	//Trennen der zweiten Stufen und Zünden der dritten (falls erforderlich).
	IF SHIP:MAXTHRUST = 0 AND vEngineStage = 2{
		//PRINT "Trennen der zweiten Stufe.".
		STAGE.
		WAIT 2.
		//PRINT "Zünden der Hilfsbooster.".
		STAGE.
		WAIT 1.
		PRINT "Zünden der dritten Stufe.".
		PRINT " ".
		STAGE.
		SET vEngineStage TO 3.
	}
	//Korrektur der APOAPSIS Teil 1
	IF vSubOrbitFlag = 2 {
		LOCK THROTTLE TO 0.01.
		IF ((SHIP:APOAPSIS > (vOrbithoehe + 2000)) = 0 OR (ETA:APOAPSIS < ETA:PERIAPSIS) = 0) AND ((SHIP:APOAPSIS > (vOrbithoehe + 2000)) OR (ETA:APOAPSIS < ETA:PERIAPSIS)){
			IF vApoapsisKorrektur < +5 {	
				SET vApoapsisKorrektur TO vApoapsisKorrektur + 5.
				//PRINT "+5° Grad".
			}	
		}ELSE{ 
			IF vApoapsisKorrektur > -5 {	
				SET vApoapsisKorrektur TO vApoapsisKorrektur - 5.
				//PRINT "-5° Grad".
			}
		}
		SET vHeading TO HEADING(vCompass,vApoapsisKorrektur).
		IF SHIP:PERIAPSIS > vOrbithoehe - 100000{
			PRINT "Autokorrektur Phase 2 wird gestartet.".
			SET vSubOrbitFlag TO 3.
		}
	}
	//Korrektur der APOAPSIS Teil 2
	IF vSubOrbitFlag = 3{
		IF ((SHIP:APOAPSIS > (vOrbithoehe + 2000)) = 0 OR (ETA:APOAPSIS < ETA:PERIAPSIS) = 0) AND ((SHIP:APOAPSIS > (vOrbithoehe + 2000)) OR (ETA:APOAPSIS < ETA:PERIAPSIS)){
			IF vApoapsisKorrektur < +45 {	
				SET vApoapsisKorrektur TO vApoapsisKorrektur + 10.
				//PRINT "+10° Grad".
			}	
		}ELSE{ 
			IF vApoapsisKorrektur > -45 {	
				SET vApoapsisKorrektur TO vApoapsisKorrektur - 10.
				//PRINT "-10° Grad".
			}
		}
		SET vHeading TO HEADING(vCompass,vApoapsisKorrektur).
	}
}
//---------------------------------------------------------------------------//
//Abschalten des Triebwerks.
//===========================================================================//
LOCK THROTTLE TO 0.
PRINT "Triebwerk wird abgeschalten.".
//Abschalten von allen Triebwerken
LIST ENGINES IN tempList. // get a list of all engines in vessel
       FOR eng IN tempList { // loop through the engines
       IF eng:STAGE = stage:number { // compare engine's stage to current stage
          eng:shutdown. // tell it to git fugged
    }
}
//---------------------------------------------------------------------------//
//Beenden des Orbit und ausrichten für Manuelen Betrieb.
//===========================================================================//
UNLOCK THROTTLE.
UNLOCK STEERING.
SAS ON.
RCS ON.
PRINT "Orbit mit der Höhe: " + vOrbithoehe + "m wurde erreicht".
PRINT "APOAPSIS ist " + SHIP:APOAPSIS + "m".
PRINT "PERIAPSIS ist " + SHIP:PERIAPSIS + "m".
PRINT "Geschwindigkeit ist " + SHIP:VELOCITY:SURFACE:MAG + "m/s".
PRINT "Programm wird beendet...".
WAIT 2.
