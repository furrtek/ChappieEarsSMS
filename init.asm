; Chappie Ears Simon Game
; For Sega Master System
; furrtek - 2015

init:
  ;Set VDP registers
  ld   hl,vdpregs
  ld   b,vdpregsend-vdpregs
  ld   c,$BF
  otir

  ;Clear whole VRAM
  ld   a,$00
  out  ($BF),a
  push ix
  pop  ix
  ld   a,$40
  out  ($BF),a
  ld   bc,$4000
-:
  xor  a
  out  ($BE),a
  dec  bc
  ld   a,b
  or   c
  jr   nz,-

  ;Load palettes
  ld   a,$00
  out  ($BF),a
  push ix
  pop  ix
  ld   a,$C0
  out  ($BF),a
  ld   hl,PaletteData
  ld   b,32
  ld   c,$BE
  otir

  ;Load tile data list
  ld   hl,tiledata
-:
  ld   a,(hl)
  or   a
  jr   z,+
  ld   b,a
  inc  hl
  ld   e,(hl)
  inc  hl
  ld   d,(hl)
  inc  hl
  ld   a,(hl)
  inc  hl
  push hl		;10 minutes were lost here
  ld   h,(hl)
  ld   l,a
  call loadtiles
  pop  hl
  inc  hl
  jr   -
+:

  ;Map head
  ld   de,$3800+(9*$02)+(4*$40)
  ld   hl,map_head
  ld   bc,$0E12  ;WWHH
  xor  a
  ld   (TIDX),a
  call maptiles

  ;Map left ear
  ld   de,$3800+(10*2)+(4*$40)
  ld   hl,map_ear1a+1
  ld   bc,$0507  ;WWHH
  ld   a,83
  ld   (TIDX),a
  call maptiles

  ;Map right ear
  ld   de,$3800+(17*2)+(4*$40)
  ld   hl,map_ear2a+1
  ld   bc,$0507  ;WWHH
  ld   a,83+21+17+15
  ld   (TIDX),a
  call maptiles

  ;Map normal eyes
  ld   de,$3800+(14*$02)+(14*$40)
  ld   hl,map_eyes
  ld   bc,$0402  ;WWHH
  ld   a,83+21+17+15+19+15+13
  ld   (TIDX),a
  call maptiles

  ;Map title
  ld   de,$3800+(5*$02)+(1*$40)
  ld   hl,map_title
  ld   bc,$1602  ;WWHH
  ld   a,84+21+17+15+19+15+13+8+8+8+4
  ld   (TIDX),a
  call maptiles

  ;Sprite setup
  ld   a,$00
  out  ($BF),a
  push ix
  pop  ix
  ld   a,$3F+$40
  out  ($BF),a
  push ix
  pop  ix
  ld   a,$D0
  out  ($BE),a		;Nothing for now

  ld   a,$80
  out  ($BF),a
  push ix
  pop  ix
  ld   a,$3F+$40
  out  ($BF),a
  ld   a,120
  out  ($BE),a		;X
  push ix
  pop  ix
  ld   a,84+21+17+15+19+15+13+8+8+8
  out  ($BE),a		;Tile #
  push ix
  pop  ix
  ld   a,120+8
  out  ($BE),a		;X
  push ix
  pop  ix
  ld   a,84+21+17+15+19+15+13+8+8+8+2
  out  ($BE),a		;Tile #

  ;Turn screen on
  ld   a,%11100110
  out  ($BF),a
  push ix
  pop  ix
  ld   a,$81
  out  ($BF),a

  ld   a,$1D
  ld   (LAST_RAND),a	;Seed
  ld   a,$EA
  ld   (LAST_RAND+1),a

  xor  a
  ld   (TIMER),a
  ld   (SEQPTR),a
  ld   (FXIDX),a
  ld   (MARKCNT),a
  ld   (STREAKCNT),a
  ld   a,3
  ld   (SEQLEN),a
  ld   (LOST),a
  ld   a,ST_LONGPAUSE
  ld   (STATE),a
  ld   hl,fx_null	;Loops VGM player to nothing
  call prepfx
  ret
