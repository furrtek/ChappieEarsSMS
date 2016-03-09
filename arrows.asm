; Chappie Ears Simon Game
; For Sega Master System
; furrtek - 2015

updarrows:
  ld   a,(hl)
  dec  a
  ld   b,84+21+17+15+19+15+13+8+8+8+4+35
  or   a
  jr   z,+
  ld   b,84+21+17+15+19+15+13+8+8+8+4+35+4
+:
  ld   a,b
  ld   (TIDX),a

  ld   de,$3800+(6*2)+(22*$40)
  ld   a,(PSEQPTR)
  sla  a
  sla  a
  add  a,e
  jr   nc,+
  inc  d
+:
  ld   e,a
  ld   bc,$0202
  ld   hl,map_arrow
  call maptiles

  ret

erasearrows:
  ;Clear BG zone
  ld   hl,$3800+(22*$40)
  ld   a,l
  out  ($BF),a
  push ix
  pop  ix
  ld   a,h
  or   $40
  out  ($BF),a
  ld   b,32*2*2
  xor  a
-:
  out  ($BE),a
  push ix
  pop  ix
  djnz -
  ret
