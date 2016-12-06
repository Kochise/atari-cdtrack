; /// >  - KOSS 2002 < ///

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

	move.w	#$69,-(SP)	; - DSP_UNLOCK -
	TRAP	#14	; *** XBIOS ***
	addq.l	#2,SP

; --- TEXT USER EXIT (TUE) ---

PROG_TUE_PTERM0:	clr.w	-(SP)	; - P_TERM0 -
	TRAP	#1	; *** GEMDOS ***

; --- TEXT USER SUB (TUS) ---

; -----------------------------------------------------------------------------

; --- TEXT SUPER MAIN (TSM) ---

; --- TEXT SUPER SUB (TSS) ---

; /////////////////////////////////////////////////////////////////////////////	
	SECTION	DATA
; /////////////////////////////////////////////////////////////////////////////	
	
; --- DATA ADDRESS TABLE (DAT) ---
	
; --- DATA DEFINED ARRAY (DDA) ---
	
; /////////////////////////////////////////////////////////////////////////////	
	SECTION	BSS
; /////////////////////////////////////////////////////////////////////////////	

; --- BSS DATA BUFFER (BDB) ---

; --- BSS FLAG BUFFER (BFB) ---
