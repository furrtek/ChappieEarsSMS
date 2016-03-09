; Chappie Ears Simon Game
; For Sega Master System
 ;SMSPower coding compo post-deadline update
; furrtek 2015
; Do whatever you want with everything :)

; SFX done in Deflemask
; Graphics done in MS Paint and PS, converted with Maxim's Bmp2tile
; Assembles with WLA-DX

.MEMORYMAP
DEFAULTSLOT 0
SLOTSIZE $8000
SLOT 0 $0000
.endme

.ROMBANKMAP
BANKSTOTAL 1
BANKSIZE $8000
BANKS 1
.ENDRO

;Possible states
.DEFINE ST_PAUSE 0
.DEFINE ST_LEFTANIM 1
.DEFINE ST_RIGHTANIM 2
.DEFINE ST_LONGPAUSE 3
.DEFINE ST_INPUT 4
.DEFINE ST_STREAK 5

.SDSCTAG 1.10,"CHAPPIESMN","Simon says","Furrtek"

.BANK 0 SLOT 0
.ORG $0000
  di
  im   1
  jp   main

.ORG $0038
  push af
  in   a,($BF)
  ld   (VBLFLAG),a
  pop  af
  ei
  ret

.ORG $0066
  retn

main:
  ld   sp,$DFF0

  call init

  ei

-:
  ld   a,(VBLFLAG)	;Wait for vblank
  or   a
  jr   z,-
  xor  a
  ld   (VBLFLAG),a

  ld   a,(STATE)	;STATE MASHEEN jumptable
  ld   hl,jt_state
  sla  a
  add  a,l
  jr   nc,+
  inc  h
+:
  ld   l,a
  ld   a,(hl)
  inc  hl
  ld   h,(hl)
  ld   l,a
  call dojump
  
  ld   a,(TIMER)
  inc  a
  ld   (TIMER),a

  jp -

dojump:
  jp   (hl)

jt_state:
  .dw proc_pause
  .dw proc_ear1
  .dw proc_ear2
  .dw proc_lpause
  .dw proc_input
  .dw proc_streak
  
proc_input:
  call readjp

  ld   a,(JP_ACTIVE)
  bit  2,a
  jr   z,+
  ;Left
  ld   a,(PSEQPTR)
  ld   b,a
  ld   hl,PSEQ
  add  a,l
  jr   nc,++
  inc  h
++:
  ld   l,a
  ld   a,1
  ld   (hl),a		;Add input to player sequence
  ld   a,b
  inc  a
  ld   (PSEQPTR),a
  call updarrows	;Refresh player input sequence
+:

  ld   a,(JP_ACTIVE)
  bit  3,a
  jr   z,+
  ;Right
  ld   a,(PSEQPTR)
  ld   b,a
  ld   hl,PSEQ
  add  a,l
  jr   nc,++
  inc  h
++:
  ld   l,a
  ld   a,2
  ld   (hl),a		;Add input to player sequence
  ld   a,b
  inc  a
  ld   (PSEQPTR),a
  call updarrows	;Refresh player input sequence
+:

  ld   a,(PSEQPTR)	;Sequence full ?
  ld   hl,SEQLEN
  cp   (hl)
  ret  nz
  
  ;Check if player did it right
  ld   hl,SEQ
  ld   de,PSEQ
  ld   a,(SEQLEN)
  ld   b,a
-:
  ld   c,(hl)
  ld   a,(de)
  cp   c
  jr   nz,+
  inc  de
  inc  hl
  djnz -
+:

  ld   a,b
  ld   (LOST),a		;Nonzero is wrong
  
  ld   hl,fxh		;Happy sound
  or   a
  jr   z,+
  ld   hl,fxs		;Sad sound
+:
  call prepfx
  
  ld   a,b		;Refresh eyes
  or   a
  ld   a,83+21+17+15+19+15+13+8
  jr   z,+
  ld   a,83+21+17+15+19+15+13+8+8
+:
  ld   de,$3800+(14*$02)+(14*$40)
  ld   hl,map_eyes
  ld   bc,$0402  ;WWHH
  ld   (TIDX),a
  call maptiles

  ld   a,ST_LONGPAUSE
  ld   (STATE),a
  xor  a
  ld   (TIMER),a
  ret
  
proc_pause:
  ld   a,(TIMER)	;Not used :)
  cp   15
  ret  nz
  jp   nextstate

proc_ear1:
  ld   hl,lut_ear1
  ld   de,$3800+(10*2)+(4*$40)
  jr   ear_common

proc_ear2:
  ld   hl,lut_ear2
  ld   de,$3800+(17*2)+(4*$40)
  jr   ear_common

ear_common:
  ld   a,(TIMER)	;Animate ear
  srl  a
  srl  a
  and  3
  sla  a
  add  a,l
  jr   nc,+
  inc  h
+:
  ld   l,a
  ld   a,(hl)
  inc  hl
  ld   h,(hl)
  ld   l,a
  ld   bc,$0507  ;WWHH
  ld   a,(hl)
  inc  hl
  ld   (TIDX),a
  call maptiles
  call updfx
  ld   a,(TIMER)
  cp   15
  ret  nz
  jp   nextstate

proc_lpause:
  call updfx
  
  ld   a,(LOST)
  or   a
  jr   nz,+
  ld   a,(TIMER)	;Animate <3 icon during frames 0~49 if win
  cp   50
  jr   nc,++
  sra  a
  cpl
  add  a,64		;64-Y
  ld   b,a
  ld   a,$00
  out  ($BF),a
  push ix
  pop  ix
  ld   a,$3F+$40
  out  ($BF),a
  push ix
  pop  ix
  ld   a,b
  out  ($BE),a
  push ix
  pop  ix
  ld   a,b
  out  ($BE),a
  push ix
  pop  ix
  ld   a,$D0		;Hasta la vista, VDP
  out  ($BE),a
  jr   +
++:
  call drawmark       	;Animate counter during frames 50~99 if win
+:

  ld   a,(TIMER)	;Whatever happened, clear stuff at frame 50
  cp   50
  jr   nz,+++
  ld   a,$00
  out  ($BF),a
  push ix
  pop  ix
  ld   a,$3F+$40
  out  ($BF),a
  push ix
  pop  ix
  ld   a,$D0		;Disable <3
  out  ($BE),a
  ld   a,83+21+17+15+19+15+13
  ld   de,$3800+(14*$02)+(14*$40)
  ld   hl,map_eyes
  ld   bc,$0402  ;WWHH
  ld   (TIDX),a
  call maptiles         ;Normal eyes
  call erasearrows
  ld   a,(LOST)
  or   a
  jr   nz,+
  ;Won
  ld   hl,fxmark	;Chalkboard fx for mark
  call prepfx
  jr   +++
+:
  ;Lost, clear score
  xor  a
  ld   (MARKCNT),a
  ld   (STREAKCNT),a
  ld   a,3
  ld   (SEQLEN),a
  ;Clear BG zone
  ld   hl,$3800+(6*$40)+(26*2)
  ld   c,16 
--:
  ld   a,l
  out  ($BF),a
  push ix
  pop  ix
  ld   a,h
  or   $40
  out  ($BF),a
  ld   b,5*2
  xor  a
-:
  out  ($BE),a
  push ix
  pop  ix
  djnz -
  ld   de,64
  add  hl,de
  dec  c
  jr   nz,--
+++:

  ld   a,(TIMER)
  cp   100		;Next game at frame 100
  jr   z,nextstate
  ret

proc_streak:
  jp   drawstreak

nextstate:		;State change
  xor  a
  ld   (TIMER),a
  ld   a,(STATE)
  cp   ST_PAUSE
  jr   z,nst_anim
  cp   ST_LEFTANIM
  jr   z,nst_anim
  cp   ST_RIGHTANIM
  jr   z,nst_anim
  cp   ST_LONGPAUSE
  jr   z,nst_lp
  ret

nst_anim:
  ld   hl,SEQLEN	;Chappie moves ears
  ld   a,(SEQPTR)
  inc  a
  cp   (hl)
  jr   z,++
  ld   hl,SEQ
  ld   (SEQPTR),a
  add  a,l
  jr   nc,+
  inc  h
+:
  ld   l,a
  ld   a,(hl)
  ld   (STATE),a	;Set state for animation
  or   a
  ret  z
  cp   1
  ld   hl,fx1		;Left ear sound
  jr   z,+
  ld   hl,fx2		;Right ear sound
+:
  call prepfx
  ret
++:
  xor  a
  ld   (PSEQPTR),a
  ld   a,ST_INPUT
  ld   (STATE),a
  ret

nst_lp:
  ld   a,(LOST)
  or   a
  jr   nz,newseq
  ld   a,(MARKCNT)
  inc  a
  cp   5
  jr   nz,++
  xor  a
  ld   (MARKCNT),a
  ld   a,ST_STREAK
  ld   (STATE),a
  ld   hl,fxstreak
  call prepfx
  ret
++:
  ld   (MARKCNT),a
newseq:
  xor  a
  ld   (SEQPTR),a
  ld   hl,SEQ		;Make new seq
  ld   a,(SEQLEN)
  ld   b,a
-:
  call getrand
  ld   a,(LAST_RAND)
  srl  a		;Whatever...
  and  1
  inc  a		;0~1 -> 1~2
  ld   (hl),a
  inc  hl
  djnz -
  ld   a,(SEQ)		;Set sequence up to start playing
  cp   1
  ld   hl,fx1
  jr   z,+
  ld   hl,fx2
+:
  ld   (STATE),a
  call prepfx
  ret

lut_ear1:
  .dw map_ear1b
  .dw map_ear1c
  .dw map_ear1b
  .dw map_ear1a

lut_ear2:
  .dw map_ear2b
  .dw map_ear2c
  .dw map_ear2b
  .dw map_ear2a

.INCLUDE "count.asm"
.INCLUDE "arrows.asm"
.INCLUDE "sound.asm"
.INCLUDE "util.asm"
.INCLUDE "init.asm"
.INCLUDE "data.asm"
.INCLUDE "ram.asm"

