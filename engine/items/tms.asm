RandomizeTMLocal:
	push hl 
	push de
	ld hl, .doneRandomizingTM	
	push hl
	ld a, BANK(.doneRandomizingTM)	
	push af	
	ld hl, RandomizeTM
	push hl
	ld a, BANK(RandomizeTM)
	push af
	jp BankSwitchCall
.doneRandomizingTM
	pop de
	pop hl
	ret
	
RandomizeCanLearnTMLocal:
	push hl 
	push de
	ld hl, .doneRandomizingCanLearnTM	
	push hl
	ld a, BANK(.doneRandomizingCanLearnTM)	
	push af	
	ld hl, RandomizeCanLearnTM
	push hl
	ld a, BANK(RandomizeCanLearnTM)
	push af
	jp BankSwitchCall
.doneRandomizingCanLearnTM
	pop de
	pop hl
	ret	

; tests if mon [wcf91] can learn move [wMoveNum]
CanLearnTM:
	ld a, [wRandomizerOptions]
	bit 3, a	
	jr nz, .randomTMLearn
	ld a, [wcf91]
	ld [wd0b5], a
	call GetMonHeader
	ld hl, wMonHLearnset
	push hl
	ld a, [wMoveNum]
	ld b, a
	ld c, $0
	ld hl, TechnicalMachines
.findTMloop
	ld a, [hli]
	cp b
	jr z, .TMfoundLoop
	inc c
	jr .findTMloop
.TMfoundLoop
	pop hl
	ld b, FLAG_TEST
	predef_jump FlagActionPredef
	
.randomTMLearn
	call RandomizeCanLearnTMLocal
	ld a, [wUnusedC000]
	ld c, a
	ret
; converts TM/HM number in wd11e into move number
; HMs start at 51
TMToMove:
	ld a, [wd11e]
	dec a
	ld e, a
	ld hl, TechnicalMachines
	ld b, $0
	ld c, a
	add hl, bc
	ld a, [hl]
	ld d, a 
	ld a, e
	cp 50
	ld a, d	
	jr nc, .keepHMs
	ld [wUnusedC000], a 
	call RandomizeTMLocal
	ld a, [wUnusedC000]
.keepHMs
	ld [wd11e], a
	ret

INCLUDE "data/tms.asm"
