; Chappie Ears Simon Game
; For Sega Master System
; furrtek - 2015

updfx:
  ld   a,(FXPTR)	;VGM play
  ld   l,a
  ld   a,(FXPTR+1)
  ld   h,a
  ld   a,(FXIDX)	;Offset
  ld   b,a
  add  a,l
  jr   nc,+
  inc  h
+:
  ld   l,a
-:
  ld   a,(hl)
  cp   $66		;End
  ret  z
  cp   $62		;Wait frame
  jr   z,+
  inc  hl
  inc  b
  ld   a,(hl)
  out  ($7F),a
  inc  hl
  inc  b
  jr   -
+:
  ld   a,b
  inc  a
  ld   (FXIDX),a
  ret

prepfx:
  ld   a,l
  ld   (FXPTR),a
  ld   a,h
  ld   (FXPTR+1),a
  xor  a
  ld   (FXIDX),a
  ret
  