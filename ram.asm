; Chappie Ears Simon Game
; For Sega Master System
; furrtek - 2015

.ENUM $C000 EXPORT
VBLFLAG DB
TIMER DB
TIDX DB
LAST_RAND DW
JP_CURRENT DB
JP_LAST DB
JP_ACTIVE DB

STATE DB

SEQ DS 10
SEQLEN DB
SEQPTR DB
PSEQPTR DB
PSEQ DS 10

LOST DB

FXPTR DW
FXIDX DB

MARKCNT DB
STREAKCNT DB

.ENDE
