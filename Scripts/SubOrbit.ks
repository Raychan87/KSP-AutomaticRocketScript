PRINT "Starte Sequenz".
PRINT "Werte werden Uebertragen".
SAS ON.
lock throttle to 1.
PRINT "Go for Launch".
PRINT "3".
WAIT 1.
PRINT "2".
WAIT 1.
PRINT "1".
WAIT 1.
PRINT "Zuendung".
STAGE.
WAIT 7.
PRINT "Decouple Tower".
STAGE.
WAIT UNTIL SHIP:APOAPSIS > 150000.
PRINT "APOAPSIS 150000m erreicht".
PRINT "Engine Shutdown".
 LIST ENGINES IN tempList. // get a list of all engines in vessel
       FOR eng IN tempList { // loop through the engines
       IF eng:STAGE = stage:number { // compare engine's stage to current stage
          eng:shutdown. // tell it to git fugged
     }
 }
WAIT 1.
PRINT "Decouple Engine".
STAGE.
WAIT UNTIL SHIP:ALTITUDE > 141000.
PRINT "Höhe 141000m erreicht".
RCS ON.
SET SASMODE TO "PROGRADE".
WAIT 10.
PRINT "Booster ON".
STAGE.
WAIT 10.
PRINT "Decouple Booster".
STAGE.
WAIT UNTIL SHIP:ALTITUDE < 10000.
PRINT "Fallschirme raus und System OFF".
STAGE.
SAS OFF.
RAS OFF.
WAIT UNTIL SHIP:ALTITUDE < 2000.
STAGE.
STAGE.