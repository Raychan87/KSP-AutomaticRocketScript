//Boot Program for all Rockets
//=============================
//build by Raychan for KSP v1.2.2
//					   KOS v1.1.0
//					   RSS/RO/RP-0
//
//---------------------------------------------------------------------------//
//Change log table:						Version 0.1(untestet)
//Date          | Changes
//24.08.2017	| - erstellt
//29.08.2017	| - Code Optimiert
//				| - 
//---------------------------------------------------------------------------//

//Starten des Bootvorgangs.
CLEARSCREEN.
PRINT "Bootlader startet...".

//Schubregler auf Null
LOCK THROTTLE TO 0.
UNLOCK THROTTLE.

//TODO: Anderen Prozessor auswählen und dort Fenster mit Live Anzeigen ausgeben

WAIT 1.
PRINT "Herrunterladen der Missions Daten...".
COPYPATH("0:/Orbit","").
COPYPATH("0:/ASM","").

//TODO: - Weitere Skripte
// Rendevew Skript für ISS
// Reise Skript TO 

//Aufrufen der Programmliste
LIST.
PRINT "Herrunterladen abgeschlossen.".

//TODO: Fenster mit Auswahl der Skripts und Eingabe Parameter

PRINT "Bitte um Eingabe des gewünschten Programmes..."
