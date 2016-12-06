
/// XBIOS $30/ 48 : MetaInit ///

Paramätres : LONG : Adresse d'un Tableau META_INFO_1
Retour     : Aucun
Pile       : 6

/// XBIOS $31/ 49 : MetaOpen ///

Paramätres : LONG : Adresse d'un Tableau META_DRVINFO
             WORD : Lettre ASCII du Canal Physique du Lecteur (A..Z)
Retour     : D0.l =
Pile       : 8

/// XBIOS $32/ 50 : MetaClose ///

Paramätres : WORD : Lettre ASCII du Canal Physique du Lecteur (A..Z)
Retour     : D0.l =
Pile       : 6

/// XBIOS $33/ 51 : MetaRead ///

Paramätres : WORD : Nombre de Blocks (short)
             LONG : Block de dÇpart
             LONG : Adresse d'un Buffer
             WORD : Lettre ASCII du Canal Physique du Lecteur (A..Z)
Retour     : D0.l =
Pile       : 14

/// XBIOS $34/ 52 : MetaWrite ///

Paramätres : WORD : Nombre de Blocks (short)
             LONG : Block de dÇpart
             LONG : Adresse d'un Buffer
             WORD : Lettre ASCII du Canal Physique du Lecteur (A..Z)
Retour     : D0.l =
Pile       : 14

/// XBIOS $36/ 54 : MetaStatus ///

Paramätres : LONG : Adresse d'un Buffer
             WORD : Lettre ASCII du Canal Physique du Lecteur (A..Z)
Retour     : D0.l =
Pile       : 8

/// XBIOS $37/ 55 : MetaIOCtl ///

Paramätres : LONG : Argument
             WORD : OpCode $43xx, avec xx...
                     0 : CDROMReadOffSet
                         Retourne le NumÇro de Bloc du Premier Secteur de la
                         derniäre Session d'un CD MultiSession
                         Argument ->
                     1 : CDROMPause
                         Met la Lecture Audio en Pause
                         Argument == 0
                     2 : CDROMResume
                         Continue la Lecture Audio
                         Argument == 0
                     3 : CDROMPlayMSF
                         Lecture Audio
                         Argument -> Tableau CDROM_MSF
                     4 : CDROMPlayTrKind
                         Lecture Audio
                         Argument -> Tableau CDROM_TI
                     5 : CDROMReadToChDr
                         Lecture du Header du Directory
                         Argument -> Tableau CDROM_TOCHDR
                     6 : CDROMReadTOCEntry
                         Lecture d'une EntrÇe TOC
                         Argument -> CDROM_TOCENTRY
                     7 : CDROMStop
                         Stoppe le Moteur du Lecteur de CDROM
                         Argument == 0
                     8 : CDROMStart
                         Met en route le Moteur du Lecteur de CDROM
                         Argument == 0
                     9 : CDROMEject
                         Ejecte le CDROM, mais ne le rentre pas ensuite...
                         Argument == 0
                    10 : CDROMVolCtrl
                         Controle le Volume Audio du Lecteur de CDROM
                         Argument -> CDROM_VOLCTRL
                    11 : CDROMSubChnl
                         Lecture d'Information SubChannel
                         Argument -> CDROM_SUBCHNL

#define CDROM_AUDIO_INVALID     0x00    /* audio status not supported */
#define CDROM_AUDIO_PLAY        0x11    /* audio play operation in progress */
#define CDROM_AUDIO_PAUSED      0x12    /* audio play operation paused */
#define CDROM_AUDIO_COMPLETED   0x13    /* audio play successfully completed */
#define CDROM_AUDIO_ERROR       0x14    /* audio play stopped due to error */
#define CDROM_AUDIO_NO_STATUS   0x15    /* no current audio status to return */

                    12 : CDROMReadMode2
                         Lecture de Secteurs Mode 2 (2336 Bytes)
                         Argument -> CDROM_READ
                    13 : CDROMReadMode1
                         Lecture de Secteurs Mode 1 (2048 Bytes)
                         Argument -> CDROM_READ
                    14 : CDROMPreventRemoval
                         Bloque le MÇcanisme d'Ejection
                         Argument == 0
                         !!! Ne fonctionne pas sur certains lecteurs
                    15 : CDROMAllowRemoval
                         DÇbloque le MÇcanisme d'Ejection
                         Argument == 0
                         !!! Ne fonctionne pas sur certains lecteurs                         
                    16 : CDROMAudioCtrl
                         Controle des RÇglages Audio du Lecteur de CDROM
                         Argument -> CDROM_AUDIOCTRL
                    17 : CDROMReadDA
                         Lecture de Secteurs DigitalAudio (RedBook)
                         Argument -> CDROM_READ (Blocks == 2352 Bytes)
                    19 : CDROMGetMCN
                         Lecture du Media Catalog Number
                         Argument -> CDROM_MCN
                    20 : CDROMGetTISRC
                         Lecture du Track International Standart Recording Code
                         Argument -> CDROM_TISRC
             LONG : Magic "FCTL"
             WORD : Lettre ASCII du Canal Physique du lecteur (A..Z)
Retour     : D0.l = -32.l : OpCode Inconnu
             D0.l =  -3.l : Fonction Non SupportÇe (MetaIOCtl)
Pile       : 14

/// XBIOS $3B/ 59 : MetaStartAudio ///

Paramätres : LONG : Adresse d'un Tableau (unsigned char *bytearray)
             WORD : Flag (short)
             WORD : Lettre ASCII du Canal Physique du Lecteur (A..Z)
Retour     : D0.l =
Pile       : 10

/// XBIOS $3C/ 60 : MetaStopAudio ///

Paramätres : WORD : Lettre ASCII du Canal Physique du Lecteur (A..Z)
Retour     : D0.l =
Pile       : 4

/// XBIOS $3D/ 61 : MetaSetSongTime ///

Paramätres : LONG : EndTime
             LONG : StartTime
             WORD : Repeat (short)
             WORD : Lettre ASCII du Canal Physique du Lecteur (A..Z)
Retour     : D0.l =
Pile       : 14

/// XBIOS $3E/ 62 : MetaGetTOC ///

Paramätres : LONG : Adresse d'un Tableau CD_TOC_ENTRY
             WORD : Flag (short)
             WORD : Lettre ASCII du Canal Physique du Lecteur (A..Z)
Retour     : D0.l =
Pile       : 10

/// XBIOS $3F/ 63 : MetaDiscInfo ///

Paramätres : LONG : Adresse d'un tableau CD_DISC_INFO
             WORD : Lettre ASCII du Canal Physique du Lecteur (A..Z)
Retour     : D0.l =
Pile       : 8

--- Structures ---

CDROM_MSF	ds.b	1	; cdmsf_min0, start minute
	ds.b	1	; cdmsf_sec0, start second
	ds.b	1	; cdmsf_frame0, start frame
	ds.b	1	; cdmsf_min1, end minute
	ds.b	1	; cdmsf_sec1, end second
	ds.b	1	; cdmsf_frame1, end frame

; ---

CDROM_TI	ds.b	1	; cdti_trk0, start track
	ds.b	1	; cdti_ind0, start index
	ds.b	1	; cdti_trk1, end track
	ds.b	1	; cdti_ind1, end index

; ---

CDROM_TOCHDR	ds.b	1	; cdth_trk0, start track
	ds.b	1	; cdth_trk1, end track

; ---

CDROM_TOCENTRY
       /* input parameters */

    BYTE    cdte_track;     /* track number or CDROM_LEADOUT */
    BYTE    cdte_format;    /* CDROM_LBA or CDROM_MSF */

    /* output parameters */

    unsigned    cdte_adr:4;     /* the SUBQ channel encodes 0: nothing,
                                    1: position data, 2: MCN, 3: ISRC,
                                    else: reserved */
    unsigned    cdte_ctrl:4;    /* bit 0: audio with pre-emphasis,
                                    bit 1: digital copy permitted,
                                    bit 2: data track,
                                    bit 3: four channel */
    BYTE    cdte_datamode;    /* currently not set */
   CD_AD cdte_addr;        /* track start */

; ---

CDROM_SUBCHNL
   /* input parameters */

    BYTE    cdsc_format;      /* CDROM_MSF or CDROM_LBA */

    /* output parameters */

    BYTE    cdsc_audiostatus; /* see below */
    unsigned   cdsc_resvd: 8; /* reserved */
    unsigned   cdsc_adr:   4; /* see above */
    unsigned   cdsc_ctrl:  4; /* see above */
    BYTE    cdsc_trk;         /* current track */
    BYTE    cdsc_ind;         /* current index */
   cd_ad cdsc_absaddr;     /* absolute address */
   cd_ad cdsc_reladdr;     /* track relative address */

; ---

CDROM_MCN	ds.b	1	; mcn_audiostatus, see above
	ds.b	23	; mcn_mcn[23], Media catalog number as ASCII string

; ---

CDROM_TISRC
   /* input parameters */

    BYTE    tisrc_track;      /* track number */

    /* output parameters */

    BYTE    tisrc_audiostatus;   /* see above */
    BYTE    tisrc_tisrc[23];  /* Track International Standard
                           Recording Code (ASCII) */

; ---

CDROM_VOLCTRL	ds.b	1	; channel0, volume level 0..255
	ds.b	1	; channel1
	ds.b	1	; channel2
	ds.b	1	; channel3

; ---

CDROM_AUDIOCTRL
   /* input parameters */

    short   set;    /* 0 == inquire only */

    /* input/output parameters */

    struct {
        BYTE selection;
        BYTE volume;
    } channel[4];

; ---

CDROM_READ
    long    cdread_lba;       /* logical block address */
    char    *cdread_bufaddr;  /* buffer pointer */
    long    cdread_buflen;    /* byte count */

; ---


/* CD-ROM address types */

#define CDROM_LBA   0x01
#define CDROM_MSF   0x02

; ---

/* SUB Q control bits */

#define CDROM_AUDIO_EMPHASIS    0x01
#define CDROM_COPY_PERMITTED    0x02
#define CDROM_DATA_TRACK        0x04
#define CDROM_FOUR_CHANNEL      0x08

; ---

/* The leadout track is always 0xAA, regardless of # of tracks on disc */

#define CDROM_LEADOUT   0xAA

; ---

CD_TOC_ENTRY	ds.b	1	; trackno
	ds.b	1	; minute
	ds.b	1	; second
	ds.b	1	; frame

; ---

CD_DISC_INFO	unsigned char disctype;    /* 0: audio, 1: data */
	unsigned char firsttrack, lasttrack, curtrack;
	unsigned char relposz, relposm, relposs, relposf;
	unsigned char absposz, absposm, absposs, absposf;
	unsigned char endposz, endposm, endposs, endposf;
	unsigned char index, res[3];
	unsigned long reserved[123];

; ---

META_INFO_2	ds.w	1	; mi_version, $0230 == '02.30' 
	dc.l	"_MET"	; mi_magic == '_MET'
	const char     *mi_log2phys;  /* maps DOS-IDs to MetaDOS XBIOS device numbers

; ---

META_INFO_1	ds.l	1	; mi_drivemap
	const char     *mi_version_string;
	ds.l	1	; reserved
	META_INFO_2    *mi_info;

; ---

META_DRVINFO	ds.l	1	; *mdr_name
	ds.l	3	; res[3]
 