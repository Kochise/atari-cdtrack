; /// >  - KOSS 2002 < ///

EqAUTO	EQU	1<<23
EqADJ	EQU	1<<22
EqEND	EQU	1<<20
EqOFF	EQU	1<<8
EqSWITCH	EQU	1<<0

SurrAUTO	EQU	1<<22
SurrOFF	EQU	1<<9
SurrSWITCH	EQU	1<<1

	OPT	p=68030/68882
	comment	HEAD=7	; FastLoad

; --- EQUATE ASSEMBLY (EA) ---

; --- EQUATE DATA (ED) ---

; --- EQUATE INDEX (EI) ---

; --- EQUATE SYSTEM (ES) ---

; /////////////////////////////////////////////////////////////////////////////	
	SECTION	TEXT
; /////////////////////////////////////////////////////////////////////////////	
		
; --- TEXT USER INIT (TUI) ---
	

; --- TEXT USER MAIN (TUM) ---

	pea	TestHost
	move.w	#$26,-(SP)	; - SUPEXEC -
	TRAP	#14	; *** XBIOS ***
	addq.l	#6,SP


; --- TEXT USER EXIT (TUE) ---

PROG_TUE_PTERM0:	clr.w	-(SP)	; - P_TERM0 -
	TRAP	#1	; *** GEMDOS ***

; --- TEXT USER SUB (TUS) ---

; -----------------------------------------------------------------------------

; --- TEXT SUPER MAIN (TSM) ---

TestHost	move.b	#$80,$FFFFA200.w

;	move.l	#SurrOFF,D0
;	BSR	SendDSP
	move.l	#SurrSWITCH,D0
	BSR	SendDSP
	move.l	#SurrAUTO|$03A0,D0
	BSR	SendDSP

;	move.l	#EqOFF,D0
;	BSR	SendDSP
	move.l	#EqSWITCH,D0
	BSR	SendDSP
	
	move.w	#15,D7
	lea	EqualizerTable,A0

InitEqualizer	clr.l	D0
	move.b	(A0,D7.w),D0
	lsl.w	#8,D0
	or.w	D7,D0
	ori.l	#EqAUTO|EqADJ,D0
	BSR	SendDSP
	DBF	D7,InitEqualizer

	RTS
	
SendDSP	btst.b	#1,$FFFFA202.w
	BEQ	SendDSP
	
	move.l	D0,$FFFFA204.w
	
	RTS

; --- TEXT SUPER SUB (TSS) ---

; /////////////////////////////////////////////////////////////////////////////	
	SECTION	DATA
; /////////////////////////////////////////////////////////////////////////////	
	
; --- DATA ADDRESS TABLE (DAT) ---
	
; --- DATA DEFINED ARRAY (DDA) ---

EqualizerTable	dc.b	30	; Left
	dc.b	19
	dc.b	25
	dc.b	22
	dc.b	20
	dc.b	19
	dc.b	20
	dc.b	22

	dc.b	30	; Right
	dc.b	19
	dc.b	25
	dc.b	22
	dc.b	20
	dc.b	19
	dc.b	20
	dc.b	22

; /////////////////////////////////////////////////////////////////////////////	
	SECTION	BSS
; /////////////////////////////////////////////////////////////////////////////	

; --- BSS DATA BUFFER (BDB) ---

; --- BSS FLAG BUFFER (BFB) ---
