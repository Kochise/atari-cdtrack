
/* Copyright (C) 1996 Olivier Azeau, France.
   
   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation.

   This program is distributed WITHOUT ANY WARRANTY, without even the
   implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
   See the GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.  */



#ifndef __CDDRIVE_H__
#define __CDDRIVE_H__


#include <xstring.h>

#include <metados.h>
#include <cdromio.h>
#include <cdlocat.h>
#include <cdtrloc.h>
#include <cdstatus.h>

// Classe de stockage des informations standard metados
class CdInformation
{
public:
	META_INFO_1 info1;
	META_DRVINFO drvinfo;

	CdInformation( void )
	{
		info1.mi_drivemap = 0;
		info1.mi_version_string = 0;
		info1.reserved = 0;
		info1.mi_info = 0;
	}
};


// Classe principale d'acces au lecteur de CD
class CdDrive
{

public:
	String software;
	String driver;

	short drive;

protected:
    // acces CD bas niveau
	int ioctl( short code, void *data )
	{
		return Metaioctl( drive, CDROMIO_MAGIC, code, data );
	}

	CdInformation information;
	int drive_detected;

public:
	BYTE mode;	// CDROM_MSF ou CDROM_LBA

	CdDrive( void );

	int detected( void ) { return drive_detected; }

    // Numeros des pistes de debut et de fin
	int start_track( void );
	int end_track( void );

    // Commandes diverses pour action sur CD
	int start( void );
	int stop( void );
	int pause( void );
	int resume( void );
	int allow_removal( void );
	int prevent_removal( void );
	int eject( void );

    // Commande de lecture audio
	int play( BYTE start_track_id, BYTE start_index, BYTE end_track_id, BYTE end_index );

    // Requetes position et taille des pistes
	CdLocation track_position( BYTE t );
	CdLocation track_length( BYTE t );
	CdLocation leadout( void );

    // Requetes position courante de lecture
	CdTrackLocation	current_location( BYTE m = 0 );
	CdLocation current_absolute_location( BYTE m = 0 );

    // Etat actuel du CD
	int audiostatus_value( void );
	CdStatus audiostatus( void );

};


#endif 
