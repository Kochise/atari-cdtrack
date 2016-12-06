; /// CD TRACKER - KOSS 1999-2002 ///

EqAUTO	EQU	1<<23
EqADJ	EQU	1<<22
EqEND	EQU	1<<20
EqOFF	EQU	1<<8
EqSWITCH	EQU	1<<0

SurrAUTO	EQU	1<<22
SurrOFF	EQU	1<<9
SurrSWITCH	EQU	1<<1
SurrLEVEL	EQU	$0020

	comment	HEAD=7
	
	SECTION	TEXT

; On s'en fout de l'initialisation, on lance juste le lecteur de CD-ROM, 
; et on se casse !!!

	; Titre
	pea	TitleString
	move.w	#9,-(SP)	; - C_CONWS -
	trap	#1	; *** GEMDOS ***
	addq.l	#6,SP

	; V‚rifie touches Sp‚ciales
	BSR	KbShift
	
	; Si [L-Shift], Kassos !!!
	btst.l	#1,D0
	BNE	Skip		
	
	; On verifie s'il faut mettre le DSP en route
	BSR	SetDSP
	
	; V‚rifie touches Sp‚ciales
	BSR	KbShift
	
	; Si [Control], s‚lection de la plage
	btst.l	#2,D0
	BNE	SelectTrack

	; Sinon on lance AUTOMATIQUEMENT la plage 1
	BRA	SetTrack

; /// Sous-Routines de Gestion ///

	; --- S‚lection de la Plage ---
	
	; Petit texte du menu
SelectTrack	pea	SelectString
	move.w	#9,-(SP)	; - C_CONWS -
	trap	#1	; *** GEMDOS ***
	addq.l	#6,SP

	; On attend une touche...
KeysLoop	move.w	#7,-(SP)
	trap	#1
	addq.l	#2,SP
	
	; S‚lection du Code Clavier
	swap	D0
	
	; Touche [Esc], Kassos !!!
	cmpi.w	#1,D0
	BEQ	Exit
	
	; Touche [*], Mute
	cmpi.w	#$66,D0
	BEQ	VolMute
	
	; Touche [-], baisse le volume
	cmpi.w	#$4A,D0
	BEQ	VolDown
	
	; Touche [+], augmente le volume
	cmpi.w	#$4E,D0
	BEQ	VolUp
	
	; Touche de Fonction, plage >=1...
	cmpi.w	#$3B,D0
	BGE	FirstHalfPass
	
	; La touche n'est pas interessante, on reprend...
	BRA	KeysLoop
	
VolMute	pea	VolMuteSup
	move.w	#$26,-(SP)	; - SUPEXEC -
	TRAP	#14	; *** XBIOS ***
	addq.l	#6,SP

	BRA	KeysLoop

VolDown	pea	VolDownSup
	move.w	#$26,-(SP)	; - SUPEXEC -
	TRAP	#14	; *** XBIOS ***
	addq.l	#6,SP

	BRA	KeysLoop

VolUp	pea	VolUpSup
	move.w	#$26,-(SP)	; - SUPEXEC -
	TRAP	#14	; *** XBIOS ***
	addq.l	#6,SP

	BRA	KeysLoop
	
; /// S‚lection de la plage
	
	; Plage >10
FirstHalfPass	cmpi.w	#$54,D0
	BGE	SecondHalfPass
	
	; Plage <=10
	cmpi.w	#$44,D0
	BLE	FirstMETADOS
	
	; La touche n'est pas interessante, on reprend...
	BRA	KeysLoop
	
	; C'est une plage comprise entre 1 et 10...
FirstMETADOS	subi.w	#$3B-1,D0
	
	; On lance la Lecture !
	BRA	METADOS

	; Plage <=20
SecondHalfPass	cmpi.w	#$5D,D0
	BLE	SecondMETADOS
	
	; La touche n'est pas interessante, on reprend...
	BRA	KeysLoop
	
	; C'est une plage comprise entre 11 et 20...
SecondMETADOS	subi.w	#$54-11,D0

	; On garde le num‚ro de la plage compris entre 1 et 20 !
METADOS	move.w	D0,D7

	BSR	KbShift
	
	; Si [Control], ...
	btst.l	#2,D0
	BEQ	DirectMeta
	
	; ... on rajoute 20 pour les plages comprises entre 21 et 40 !
	add.w	#20,D7

	; On met la plage choisie en route...
DirectMeta	move.b	D7,TrackNumber

	BSR	LaunchMeta
	
	; On reprend la lecture du clavier...
	BRA	KeysLoop

	; On abandonne
Skip	pea	SkipText
	move.w	#9,-(SP)	; - C_CONWS -
	trap	#1	; *** GEMDOS ***
	addq.l	#6,SP

	BRA	Exit

	; On met la plage 1 en route...
SetTrack	BSR	LaunchMeta

	; Kassos !
Exit	pea	ExitText
	move.w	#9,-(SP)	; - C_CONWS -
	trap	#1	; *** GEMDOS ***
	addq.l	#6,SP

	clr.w	-(SP)	; - P_TERM0 -
	trap	#1	; *** GEMDOS ***
	
	; Acces … MetaDOS...
LaunchMeta	pea	TrackNumber
	move.w	#$4304,-(SP)
	move.l	#"FCTL",-(SP)
	move.w	#$41,-(SP)
	move.w	#$37,-(SP)
	trap	#14
	lea	(14,SP),SP

	RTS
	
SetDSP	pea	ConfigureSON
	move.w	#$26,-(SP)	; - SUPEXEC -
	TRAP	#14	; *** XBIOS ***
	addq.l	#6,SP

	move.w	#$68,-(SP)	; - DSP_LOCK -
	TRAP	#14	; *** XBIOS ***
	addq.l	#2,SP

	tst.w	D0
	BMI	ErrorDSP

	move.w	#$71,-(SP)	; - DSP_REQUESTUNIQUEABILITY -
	TRAP	#14	; *** XBIOS ***
	addq.l	#2,SP

	move.w	D0,D7
	
	move.w	#$72,-(SP)	; - DSP_GETPROGABILITY -
	TRAP	#14	; *** XBIOS ***
	addq.l	#2,SP

	cmp.w	D0,D7
	BEQ	ErrorDSP
	
	move.w	D7,-(SP)
	move.l	#(DSPCodeEnd-DSPCodeStart)/3,-(SP)
	pea	DSPCodeStart
	move.w	#$6D,-(SP)	; - DSP_EXECPROG -
	TRAP	#14	; *** XBIOS ***
	lea	(12,SP),SP

	tst.w	D0
	BMI	ErrorDSP

	pea	ConfigureDSP
	move.w	#$26,-(SP)	; - SUPEXEC -
	TRAP	#14	; *** XBIOS ***
	addq.l	#6,SP

	pea	DSPInstall
	move.w	#9,-(SP)	; - C_CONWS -
	trap	#1	; *** GEMDOS ***
	addq.l	#6,SP

	RTS

ErrorDSP	pea	DSPBusy
	move.w	#9,-(SP)	; - C_CONWS -
	trap	#1	; *** GEMDOS ***
	addq.l	#6,SP

	RTS

ConfigureSON	move.b	#$00,$FFFF8920.w
	move.b	#$43,$FFFF8921.w
	
	move.w	#$0091,$FFFF8930.w
	move.w	#$20F0,$FFFF8932.w
	move.b	#$00,$FFFF8934.w
	move.b	#$01,$FFFF8935.w
	move.b	#$00,$FFFF8936.w
	move.b	#$02,$FFFF8937.w
	move.b	#$00,$FFFF8938.w
	move.b	#$44,$FFFF8939.w
	move.w	#$0BB0,$FFFF893A.w
	move.b	#$00,$FFFF893C.w
	move.b	#$07,$FFFF8941.w
	move.b	#$00,$FFFF8943.w

	RTS
	
ConfigureDSP	move.b	#$80,$FFFFA200.w

	move.l	#SurrOFF,D0
	BSR	SendDSP
	move.l	#SurrSWITCH,D0
	BSR	SendDSP
	move.l	#SurrAUTO|SurrLEVEL,D0
	BSR	SendDSP

	move.l	#EqOFF,D0
	BSR	SendDSP
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
	
KbShift	move.w	#-1,-(SP)
	move.w	#11,-(SP)	; - KBSHIFT -
	trap	#13	; *** BIOS ***
	addq.l	#4,SP

	RTS
	
VolMuteSup	move.w	Mute,D0

	tst.w	D0
	BEQ	VolCutSup
	
	move.w	#0,Mute
	move.w	#$20F0,$FFFF8932.w
	
	RTS
	
VolCutSup	move.w	#1,Mute
	move.w	#0,$FFFF8932.w
	
	RTS

VolDownSup	move.w	$FFFF893A.w,D0
	addi.w	#$0110,D0
	cmpi.w	#$0FF0,D0
	BGT	VolDownEnd

	move.w	D0,$FFFF893A.w

VolDownEnd	RTS

VolUpSup	move.w	$FFFF893A.w,D0
	subi.w	#$0110,D0
	cmpi.w	#$0880,D0
	BLT	VolUpEnd

	move.w	D0,$FFFF893A.w

VolUpEnd	RTS

	SECTION	DATA
	
	; Plage, Index, $63, 1
TrackNumber	dc.b	1,1,$63,1  
	
TitleString	dc.b	27,"p CD TRAKER V1.02 - KOSS 1999-2002 ",27,"q",13,10,0
SelectString	dc.b	"   F1 -> F10 : Track 1 - 10",13,10
	dc.b	" + [Shift]   : +10",13,10
	dc.b	" + [Control] : +20",13,10
	dc.b	"   [*]       : Mute",13,10
	dc.b	"   [-]       : Volume Down",13,10
	dc.b	"   [+]       : Volume Up",13,10
	dc.b	" ->[Esc]     : Exit",13,10,0
SkipText	dc.b	" Skipped...",13,10,0
DSPBusy	dc.b	" DSP is busy...",13,10,0
DSPInstall	dc.b	27,"p DSP installed... ",27,"q",13,10,0
ExitText	dc.b	13,10,0

	EVEN

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

DSPCodeStart	incbin	AFM.P56
DSPCodeEnd	EVEN

	SECTION	BSS

Mute	ds.w	1
