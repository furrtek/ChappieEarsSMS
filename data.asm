; Chappie Ears Simon Game
; For Sega Master System
; furrtek - 2015

tiledata:
.db 83
.dw $0000
.dw tiles_head

.db 21
.dw $0000+(83*32)
.dw tiles_ear1a

.db 17
.dw $0000+((83+21)*32)
.dw tiles_ear1b

.db 15
.dw $0000+((83+21+17)*32)
.dw tiles_ear1c

.db 19
.dw $0000+((83+21+17+15)*32)
.dw tiles_ear2a

.db 15
.dw $0000+((83+21+17+15+19)*32)
.dw tiles_ear2b

.db 13
.dw $0000+((83+21+17+15+19+15)*32)
.dw tiles_ear2c

.db 13
.dw $0000+((83+21+17+15+19+15+13)*32)
.dw tiles_eyesn

.db 13
.dw $0000+((83+21+17+15+19+15+13+8)*32)
.dw tiles_eyesh

.db 13
.dw $0000+((83+21+17+15+19+15+13+8+8)*32)
.dw tiles_eyess

.db 4
.dw $0000+((84+21+17+15+19+15+13+8+8+8)*32)
.dw tiles_heart

.db 35
.dw $0000+((84+21+17+15+19+15+13+8+8+8+4)*32)
.dw tiles_title

.db 4
.dw $0000+((84+21+17+15+19+15+13+8+8+8+4+35)*32)
.dw tiles_arrow1

.db 4
.dw $0000+((84+21+17+15+19+15+13+8+8+8+4+35+4)*32)
.dw tiles_arrow2

.db 3
.dw $0000+((84+21+17+15+19+15+13+8+8+8+4+35+4+4)*32)
.dw tiles_mark

.db 5
.dw $0000+((84+21+17+15+19+15+13+8+8+8+4+35+4+4+3)*32)
.dw tiles_streak

.db 0 	;EOL

fx_null:
  .db $66

tiles_head:
.include "gfx/tiles_head.inc"
tiles_ear1a:
.include "gfx/tiles_ear1a.inc"
tiles_ear1b:
.include "gfx/tiles_ear1b.inc"
tiles_ear1c:
.include "gfx/tiles_ear1c.inc"
tiles_ear2a:
.include "gfx/tiles_ear2a.inc"
tiles_ear2b:
.include "gfx/tiles_ear2b.inc"
tiles_ear2c:
.include "gfx/tiles_ear2c.inc"

map_head:
.include "gfx/map_head.inc"
map_ear1a:
.db 83
.include "gfx/map_ear1a.inc"
map_ear1b:
.db 83+21
.include "gfx/map_ear1b.inc"
map_ear1c:
.db 83+21+17
.include "gfx/map_ear1c.inc"
map_ear2a:
.db 83+21+17+15
.include "gfx/map_ear2a.inc"
map_ear2b:
.db 83+21+17+15+19
.include "gfx/map_ear2b.inc"
map_ear2c:
.db 83+21+17+15+19+15
.include "gfx/map_ear2c.inc"

tiles_eyesn:
.include "gfx/tiles_eyesn.inc"
tiles_eyesh:
.include "gfx/tiles_eyesh.inc"
tiles_eyess:
.include "gfx/tiles_eyess.inc"

map_eyes:
.include "gfx/map_eyes.inc"

tiles_heart:
.include "gfx/tiles_heart.inc"

tiles_title:
.include "gfx/tiles_title.inc"
map_title:
.include "gfx/map_title.inc"

tiles_arrow1:
.include "gfx/tiles_arrow1.inc"
tiles_arrow2:
.include "gfx/tiles_arrow2.inc"

map_arrow:
.include "gfx/map_arrow.inc"

tiles_mark:
.include "gfx/tiles_mark.inc"
tiles_streak:
.include "gfx/tiles_streak.inc"

fx1:
.incbin "fx1.bin"
fx2:
.incbin "fx2.bin"
fxh:
.incbin "fxh.bin"
fxs:
.incbin "fxs.bin"
fxmark:
.incbin "fxmark.bin"
fxstreak:
.incbin "fxstreak.bin"

PaletteData:
.db $3F $14 $39 $1B $07 $03 $3F $2A $15 $00 $17 $2A $00 $00 $00 $00
.db $3F $14 $39 $1B $07 $03 $3F $2A $15 $00 $17 $2A $00 $00 $00 $00

vdpregs:
.db $04,$80,%10100010,$81,$ff,$83,$ff,$85,$fb,$86,$F0,$87,$00,$88,$00,$89,$ff,$8a
vdpregsend:
