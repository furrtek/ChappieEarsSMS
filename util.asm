; Chappie Ears Simon Game
; For Sega Master System
; furrtek - 2015

getrand:
  push af
  push de
  push hl
  ld   de,(LAST_RAND)
  ld   a,d
  ld   h,e
  ld   l,253
  or   a
  sbc  hl,de
  sbc  a,0
  sbc  hl,de
  ld   d,0
  sbc  a,d
  ld   e,a
  sbc  hl,de
  jr   nc,+
  inc  hl
+:
  ld   (LAST_RAND),hl
  pop  hl
  pop  de
  pop  af
  ret

maptiles:
  ld   a,e
  out  ($BF),a
  ld   a,d
  or   $40
  push ix
  pop  ix
  out  ($BF),a
  push bc
-:
  ld   a,(TIDX)
  add  a,(hl)
  out  ($BE),a
  ld   a,0
  adc  a,0
  inc  hl
  or   (hl)
  out  ($BE),a
  inc  hl

  dec  b
  ld   a,b
  or   a
  jr   nz,-

  push hl
  ld   hl,$0040		;Next line
  add  hl,de
  ld   d,h
  ld   e,l
  ld   a,e
  out  ($BF),a
  push ix
  pop  ix
  ld   a,d
  or   $40
  out  ($BF),a
  pop  hl

  pop  af
  push af
  ld   b,a
  dec  c
  ld   a,c
  or   a
  jr   nz,-
  pop  af
  ret

loadtiles:
  ld   a,e
  out  ($BF),a
  ld   a,d
  or   $40
  push ix
  pop  ix
  out  ($BF),a
  ld   c,$08
-:
  ld   a,(hl)
  out  ($BE),a
  push ix
  pop  ix
  inc  hl
  ld   a,(hl)
  out  ($BE),a
  push ix
  pop  ix
  inc  hl
  ld   a,(hl)
  out  ($BE),a
  push ix
  pop  ix
  inc  hl
  ld   a,(hl)
  out  ($BE),a
  push ix
  pop  ix
  inc  hl
  dec  c
  jp   nz,-
  ld   c,8
  dec  b
  jp   nz,-
  ret
  
readjp:
  ld   hl,JP_LAST
  in   a,($DC)
  ld   b,a
  xor  $FF
  ld   (JP_CURRENT),a
  ld   c,a
  ld   a,(hl)
  ld   (hl),b
  xor  b		;Difference
  and  c                ;Rising edges
  ld   (JP_ACTIVE),a
  ret
  