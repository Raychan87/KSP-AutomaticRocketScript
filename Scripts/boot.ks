//Boot Programm für eine Rakete wo Voreinstellungen gemacht werden
//Startparameter -> run boot.
//build by Raychan for KSP KOS
//
//---------------------------------------------------------------------------//
//Change log table:						Version 0.1(untestet)
//Date          | Changes
//24.08.2017	| - erstellt
//				| - 
//				| - 
//---------------------------------------------------------------------------//

//Starten des Boot vorgangs.
CLEARSCREEN.
PRINT "Bootlader startet...".
//Schubregler auf Null
SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 0.

//TODO: Anderen Prozessor auswählen und dort Fenster mit Live Anzeigen ausgeben

WAIT 1.
PRINT "Herrunterladen der Missions Daten...".
COPYPATH("0:/Orbit","").
COPYPATH("0:/PTR_V","").
COPYPATH("0:/PTR_I","").
COPYPATH("0:/watch","").

//TODO: - Weitere Skripte
// Rendevew Skript für ISS
// Reise Skript TO 

//Aufrufen der Programmliste
LIST.
PRINT "Herrunterladen abgeschlossen.".

//TODO: Fenster mit Auswahl der Skripts und Eingabe Parameter

PRINT "Bitte um Eingabe des gewünschten Programmes..."