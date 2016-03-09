; Chappie Ears Simon Game
; For Sega Master System
; furrtek - 2015

drawmark:
  ld   a,(TIMER)
  sub  50		;De-offset to zero
  srl  a 		;0~50 -> 0~2
  srl  a
  srl  a
  cp   2
  jr   c,+
  ld   a,2
+:
  ld   b,a
  ld   h,0
  ld   l,a
  add  hl,hl
  add  hl,hl
  add  hl,hl
  add  hl,hl
  add  hl,hl
  add  hl,hl		;Lazy *64 (1 BG tile line)
  
  ld   a,(STREAKCNT)
  ld   d,a
  ld   e,0		;Ninja *256 (4 BG tile lines)
  add  hl,de

  ld   de,$3800+(6*$40)+(26*2)
  add  hl,de
  ld   a,(MARKCNT)
  sla  a
  add  a,l
  jr   nc,+
  inc  h
+:
  out  ($BF),a
  push ix
  pop  ix
  ld   a,h
  or   $40
  out  ($BF),a

  ld   de,84+21+17+15+19+15+13+8+8+8+4+35+4+4
  ld   a,b
  add  a,e
  jr   nc,+
  inc  d
+:
  out  ($BE),a
  ld   a,d
  out  ($BE),a

  ret


drawstreak:
  call updfx

  ld   a,(TIMER)
  srl  a 		;0~50 -> 0~4
  srl  a
  srl  a
  cp   4
  jr   c,+
  ld   a,4
+:
  ld   b,a
  ld   hl,$3800+(7*$40)+(26*2)
  sla  a
  add  a,l
  jr   nc,+
  inc  h
+:
  ld   l,a
  
  ld   a,(STREAKCNT)
  ld   d,a
  ld   e,0		;Ninja *256 (4 BG tile lines)
  add  hl,de

  ld   a,l
  out  ($BF),a
  push ix
  pop  ix
  ld   a,h
  or   $40
  out  ($BF),a

  ld   de,84+21+17+15+19+15+13+8+8+8+4+35+4+4+3
  ld   a,b
  add  a,e
  jr   nc,+
  inc  d
+:
  out  ($BE),a
  ld   a,d
  out  ($BE),a

  ld   a,(TIMER)
  cp   50
  ret  nz

  ld   a,(STREAKCNT)
  cp   4
  jr   z,+
  inc  a
  ld   (STREAKCNT),a
  ld   a,(SEQLEN)	;Increase difficulty
  inc  a
  inc  a
  ld   (SEQLEN),a
+:

  xor  a
  ld   (TIMER),a
  jp   newseq
