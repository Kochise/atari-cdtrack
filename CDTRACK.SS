; /// CD TRACKER - KOSS 1999 ///

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
	BNE	Exit	
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

	; On met la plage 1 en route...
SetTrack	BSR	LaunchMeta

	; Kassos !
Exit	clr.w	-(SP)	; - P_TERM0 -
	trap	#1	; *** GEMDOS ***
	
	; AccŠs … MetaDOS...
LaunchMeta	pea	TrackNumber
	move.w	#$4304,-(SP)
	move.l	#"FCTL",-(SP)
	move.w	#$41,-(SP)
	move.w	#$37,-(SP)
	trap	#14
	lea	(14,SP),SP

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
	
TitleString	dc.b	27,"p CD TRAKER V1.00 - KOSS 1999",27,"q",13,10,13,10,0
SelectString	dc.b	"   F1 -> F10 : Track 1 - 10",13,10
	dc.b	" + [Shift]   : +10",13,10
	dc.b	" + [Control] : +20",13,10
	dc.b	"   [*]       : Mute",13,10
	dc.b	"   [-]       : Volume Down",13,10
	dc.b	"   [+]       : Volume Up",13,10
	dc.b	" ->[Esc]     : Exit",13,10,13,10,0
	
	SECTION	BSS
	
Mute	ds.w	1
